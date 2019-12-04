//
//  ImageClassification.m
//  SuperMapAI
//
//  Created by wnmng on 2019/10/28.
//  Copyright © 2019 wnmng. All rights reserved.
//

#import "ImageClassification.h"
#import "TFLInterpreterOptions.h"
#import "TFLInterpreter.h"
#import "TFLTensor.h"
#import "TFLQuantizationParameters.h"
#import "ImageUtil.h"
#import <Accelerate/Accelerate.h>
#import "Recognition.h"
#import "TFLInterpreter.h"

@interface ImageClassification(){
    TFLInterpreter* interpreter;
    NSArray* labels;
}
@end

@implementation ImageClassification

-(id)initWithModle:(NSString*)modelFilePath labels:(NSString*)labelsFilePath andThreadCount:(int)nThreadCount{
    if (self = [super init]) {
        NSError* error;
        TFLInterpreterOptions *options = [[TFLInterpreterOptions alloc] init];
        options.numberOfThreads = nThreadCount;
        
        //初始化解释器
        interpreter = [[TFLInterpreter alloc]initWithModelPath:modelFilePath options:options error:&error];
        
        if (error) {
            NSLog(@"Failed to create the interpreter with error:%@", error.localizedDescription);
            return nil;
        }
        [interpreter allocateTensorsWithError:&error];
        if (error) {
            return nil;
        }

        NSString *strLabels = [NSString stringWithContentsOfFile:labelsFilePath encoding:NSUTF8StringEncoding error:nil];
        //初始化返回条目
        labels = [strLabels componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    }
    return self;
}
-(NSArray*)recognizeImage:(UIImage*)image{
    CVPixelBufferRef cVPixelBufferRef=[ImageUtil CVPixelBufferRefFromUiImage:image];
    return [self recognizeCVP:cVPixelBufferRef];
}

-(NSArray*)recognizeCVP:(CVPixelBufferRef)pixelBuffer{
    OSType sourcePixelFormat = CVPixelBufferGetPixelFormatType(pixelBuffer);
    BOOL isRunable =   sourcePixelFormat == kCVPixelFormatType_32ARGB ||
    sourcePixelFormat == kCVPixelFormatType_32BGRA ||
    sourcePixelFormat == kCVPixelFormatType_32RGBA;
    if (!isRunable) {
        return nil;
    }
    
    int imageChannels = 4;
    size_t imageWidth = CVPixelBufferGetWidth(pixelBuffer);
    size_t imageHeight = CVPixelBufferGetHeight(pixelBuffer);
    size_t inputImageRowBytes = CVPixelBufferGetBytesPerRow(pixelBuffer);
    size_t thumbnailSize = imageWidth;//min
    int originX = 0;
    int originY = 0;
    if (imageWidth>imageHeight) {
        thumbnailSize = imageHeight;
        originX = (imageWidth-imageHeight)/2;
    }else{
        thumbnailSize = imageWidth;
        originY = (imageHeight-imageWidth)/2;
    }
    //CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    CVPixelBufferLockBaseAddress(pixelBuffer, kCVPixelBufferLock_ReadOnly);
    
    Byte* buffer = (Byte*)CVPixelBufferGetBaseAddress(pixelBuffer);
    int offset = originY * inputImageRowBytes + originX * imageChannels;
    
    vImage_Buffer inputVImageBuffer;
    inputVImageBuffer.data = buffer+offset;
    inputVImageBuffer.height = thumbnailSize;
    inputVImageBuffer.width = thumbnailSize;
    inputVImageBuffer.rowBytes = inputImageRowBytes;
    
    int thumbnailRowBytes = 224*imageChannels;
    Byte* thumbnailBytes = (Byte*)malloc(224 * thumbnailRowBytes);
    
    vImage_Buffer thumbnailVImageBuffer;
    thumbnailVImageBuffer.data = thumbnailBytes;
    thumbnailVImageBuffer.height = 224;
    thumbnailVImageBuffer.width = 224;
    thumbnailVImageBuffer.rowBytes = thumbnailRowBytes;
    
    vImageScale_ARGB8888(&inputVImageBuffer, &thumbnailVImageBuffer, nil, 0);
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, kCVPixelBufferLock_ReadOnly);
    
    CVPixelBufferRef thumbnailPixelBuffer;
    CVReturn conversionStatus = CVPixelBufferCreateWithBytes(nil, 224, 224, sourcePixelFormat, thumbnailBytes, thumbnailRowBytes,releaseCallback, nil, nil, &thumbnailPixelBuffer);
    if (conversionStatus!=kCVReturnSuccess) {
        free(thumbnailBytes);
        return nil;
    }
    
    
    NSError* error;
    TFLTensor* inputTensor =  [interpreter inputTensorAtIndex:0 error:&error];
    if (error) {
        return nil;
    }
    
    //byteCount = batchSize * inputWidth * inputHeight * inputChannels
    int byteCount = 1 * 224 * 224 * 3;
    BOOL isModelQuantized = (inputTensor.dataType==TFLTensorDataTypeUInt8);
    
    CVPixelBufferLockBaseAddress(thumbnailPixelBuffer,kCVPixelBufferLock_ReadOnly);
    size_t datalength = CVPixelBufferGetDataSize(thumbnailPixelBuffer);
    Byte* databyte = (Byte*)CVPixelBufferGetBaseAddress(thumbnailPixelBuffer);
    //    NSData *bufferData = [NSData dataWithBytesNoCopy:databyte length:datalength freeWhenDone:NO];
    Byte* rgbBytes = new Byte[byteCount];
    int index = 0;
    for (int i=0; i<datalength; i++) {
        if (i%4==3) {
            continue;
        }else{
            rgbBytes[index] = databyte[i];
            index++;
        }
    }
    CVPixelBufferUnlockBaseAddress(thumbnailPixelBuffer,kCVPixelBufferLock_ReadOnly);
    
    CVPixelBufferRelease(thumbnailPixelBuffer);
    
    NSData *rgbData = nil;
    if (!isModelQuantized) {
        float* rgbFloat = new float[byteCount];
        for (int j=0; j<byteCount; j++) {
            rgbFloat[j] = rgbBytes[j]*1.0/255.0;
        }
        delete[] rgbBytes;
        rgbBytes = NULL;
        //rgbData = [[NSData alloc]initWithBytes:rgbFloat length:byteCount*sizeof(float)/sizeof(Byte)];
        rgbData = [NSData dataWithBytesNoCopy:rgbFloat length:byteCount*sizeof(float)/sizeof(Byte) freeWhenDone:YES];
    }else{
        rgbData = [NSData dataWithBytesNoCopy:rgbBytes length:byteCount freeWhenDone:YES];
        //rgbData = [[NSData alloc]initWithBytes:rgbBytes length:byteCount*sizeof(Byte)];
    }
    
    
    [inputTensor copyData:rgbData error:&error];
    if (error) {
        return nil;
    }
    
    NSDate *startTime = [NSDate date];
    //NSTimeInterval currentTimeMs = [date timeIntervalSince1970]*1000;
    
    [interpreter invokeWithError:&error];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:startTime]*1000;
    
    TFLTensor* outputTensor = [interpreter outputTensorAtIndex:0 error:&error];
    if (error) {
        return nil;
    }
    NSData *outputData = [outputTensor dataWithError:&error];
    if (error) {
        return nil;
    }
    
    float *result;
    int resultLength;
    switch (outputTensor.dataType) {
        case TFLTensorDataTypeUInt8:
        {
            if(outputTensor.quantizationParameters==nil){
                return nil;
            }
            resultLength = [outputData length];
            result = new float[resultLength];
            Byte resByte[resultLength];
            [outputData getBytes:&resByte length:resultLength];
            float scale = outputTensor.quantizationParameters.scale;
            int32_t zeroPoint = outputTensor.quantizationParameters.zeroPoint;
            for (int i=0; i<resultLength; i++) {
                result[i] = scale*(resByte[i] - zeroPoint);
            }
        }
            break;
            
        case TFLTensorDataTypeFloat32:
        {
            resultLength = [outputData length];
            Byte* resByte = new Byte[resultLength];
            [outputData getBytes:resByte length:resultLength];
            result = (float*)resByte;
            resultLength /= sizeof(float)/sizeof(Byte);
        }
            break;
            
        default:
            break;
    }
    
    NSMutableArray<Recognition*> *arr = [[NSMutableArray alloc]init];
    for (int i=0; i<resultLength; i++) {
        //        NSString *labelTemp = labels[i];
        //        float confidenceTemp = result[i];
        Recognition* recognitionTemp = [[Recognition alloc]initWith:labels[i] confidence:result[i]];
        int j=0;
        for (; j<arr.count; j++) {
            Recognition* recognition = arr[j];
            if (recognitionTemp.confidence > recognition.confidence) {
                break;
            }
        }
        [arr insertObject:recognitionTemp atIndex:j];
    }
    
    delete [] result;
    result = NULL;
    
    NSArray *arrResult = [NSArray arrayWithObjects:arr[0],arr[1],arr[2], nil];
    
    return arrResult;
}

static void releaseCallback( void * CV_NULLABLE releaseRefCon, const void * CV_NULLABLE baseAddress ){
    //free(baseAddress);
    free((Byte*)baseAddress);
}


@end

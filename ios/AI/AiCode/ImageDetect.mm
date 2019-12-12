//
//  ImageDetect.m
//  SuperMapAI
//
//  Created by wnmng on 2019/10/28.
//  Copyright © 2019 wnmng. All rights reserved.
//

#import "ImageDetect.h"
#import "TFLInterpreterOptions.h"
#import "TFLInterpreter.h"
#import "TFLTensor.h"
#import "TFLQuantizationParameters.h"
#import <Accelerate/Accelerate.h>
#import "AIRecognition.h"
#import "CameraManager.h"

@interface ImageDetect(){
    TFLInterpreter* interpreter;
    NSArray* labels;
}
@end

@implementation ImageDetect

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

-(NSArray*)runModel:(CVPixelBufferRef)pixelBuffer{
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
    
    CVPixelBufferLockBaseAddress(pixelBuffer, kCVPixelBufferLock_ReadOnly);
    
    vImage_Buffer inputVImageBuffer;
    inputVImageBuffer.data = (Byte*)CVPixelBufferGetBaseAddress(pixelBuffer);;
    inputVImageBuffer.height = imageHeight;
    inputVImageBuffer.width = imageWidth;
    inputVImageBuffer.rowBytes = inputImageRowBytes;
    
    int scaledImageRowBytes = 300 * imageChannels;
    Byte* scaledImageBytes = (Byte*)malloc(300 * scaledImageRowBytes);
    
    vImage_Buffer scaledVImageBuffer;
    scaledVImageBuffer.data = scaledImageBytes;
    scaledVImageBuffer.height = 300;
    scaledVImageBuffer.width = 300;
    scaledVImageBuffer.rowBytes = scaledImageRowBytes;
    
    vImageScale_ARGB8888(&inputVImageBuffer, &scaledVImageBuffer, nil, 0);
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, kCVPixelBufferLock_ReadOnly);
    
    CVPixelBufferRef scaledPixelBuffer;
    CVReturn conversionStatus = CVPixelBufferCreateWithBytes(nil, 300,300, sourcePixelFormat, scaledImageBytes, scaledImageRowBytes,releaseCallback, nil, nil, &scaledPixelBuffer);
    if (conversionStatus!=kCVReturnSuccess) {
        free(scaledImageBytes);
        return nil;
    }
    
    NSError* error;
    TFLTensor* inputTensor =  [interpreter inputTensorAtIndex:0 error:&error];
    if (error) {
        return nil;
    }
    
    //byteCount = batchSize * inputWidth * inputHeight * inputChannels
    int byteCount = 1 * 300 * 300 * 3;
    BOOL isModelQuantized = (inputTensor.dataType==TFLTensorDataTypeUInt8);
    
    CVPixelBufferLockBaseAddress(scaledPixelBuffer,kCVPixelBufferLock_ReadOnly);
    size_t datalength = CVPixelBufferGetDataSize(scaledPixelBuffer);
    Byte* databyte = (Byte*)CVPixelBufferGetBaseAddress(scaledPixelBuffer);
    //    NSData *bufferData = [NSData dataWithBytesNoCopy:databyte length:datalength freeWhenDone:NO];
    Byte* rgbBytes = new Byte[byteCount];
    int pixelIndex = 0;
    for (int i=0; i<datalength; i++) {
        // Swizzle BGR -> RGB.
        int bgraComponent = i % 4;
        
        if ( bgraComponent==3) {
            pixelIndex++;
            continue;
        }else{
            int rgbIndex = pixelIndex * 3 + (2 - bgraComponent);
            rgbBytes[rgbIndex] = databyte[i];
        }
    }
    CVPixelBufferUnlockBaseAddress(scaledPixelBuffer,kCVPixelBufferLock_ReadOnly);
    
    CVPixelBufferRelease(scaledPixelBuffer);
    
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
    
    TFLTensor* outputBoundingBox = [interpreter outputTensorAtIndex:0 error:&error];
    TFLTensor* outputClasses = [interpreter outputTensorAtIndex:1 error:&error];
    TFLTensor* outputScores = [interpreter outputTensorAtIndex:2 error:&error];
    TFLTensor* outputCount = [interpreter outputTensorAtIndex:3 error:&error];
    
    if (error) {
        return nil;
    }
    float dCountValue;
    NSData *outputCountData = [outputCount dataWithError:&error];
    [outputCountData getBytes:&dCountValue length:sizeof(int)];
    int nCount = dCountValue;
    
    float boundingBox[nCount*4];
    NSData *outputBoundingBoxData = [outputBoundingBox dataWithError:&error];
    [outputBoundingBoxData getBytes:&boundingBox length:nCount*4*sizeof(float)];
    
    float classes[nCount];
    NSData *outputClassesData = [outputClasses dataWithError:&error];
    [outputClassesData getBytes:&classes length:nCount*sizeof(float)];
    
    float scores[nCount];
    NSData *outputScoresData = [outputScores dataWithError:&error];
    [outputScoresData getBytes:&scores length:nCount*sizeof(float)];
    
    NSMutableArray<AIRecognition*> *arr = [[NSMutableArray alloc]init];
    for (int i=0; i<nCount; i++) {
        if (scores[i]<0.6) {
            continue;
        }
        int outputClassIndex = classes[i];
        NSString* outputClass = labels[outputClassIndex + 1];
        
        CGRect rect = CGRectMake(boundingBox[4*i+1],
                                 boundingBox[4*i],
                                 boundingBox[4*i+3]-boundingBox[4*i+1],
                                 boundingBox[4*i+2]-boundingBox[4*i]);
        
        UIColor* colorToAssign = UIColor.redColor; //???
        AIRecognition* inferenceTemp = [[AIRecognition alloc]initWith:outputClass confidence:scores[i] rect:rect displayColor:colorToAssign count:0];
        [arr addObject:inferenceTemp];
    }
    
//    return [[ModelDataResult alloc] initWith:arr duringTime:interval];
    return arr;
}

static void releaseCallback( void * CV_NULLABLE releaseRefCon, const void * CV_NULLABLE baseAddress ){
    //free(baseAddress);
    free((Byte*)baseAddress);
}


@end

//
//  AIPlateCollectionView.m
//  SuperMapAI
//
//  Created by wnmng on 2019/12/20.
//  Copyright © 2019 wnmng. All rights reserved.
//



#ifdef __cplusplus
//#import <opencv2/opencv.hpp>
//#import <opencv2/imgcodecs/ios.h>
#import "opencv2/opencv.hpp"
#import "opencv2/imgcodecs/ios.h"
#endif

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMedia/CoreMedia.h>
#endif

#import "Utility.h"
#import "Pipeline.h"

#import "AIPlateCollectionView.h"

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
//#import "CameraManager.h"
#import "ImageDetect.h"
#import "AIDetectViewInfo.h"
#import "AIRecognition.h"
#import "InfoView.h"
#import "TensorflowTrackNative.h"
#import "MultiBoxTracker.h"
#import <Accelerate/Accelerate.h>


@interface  AIPlateCollectionView()<UIAlertViewDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVCaptureSession *_session;
    AVCaptureDeviceInput *_captureInput;
    //AVCaptureStillImageOutput *_captureOutput;
    AVCaptureVideoPreviewLayer *_preview;
    AVCaptureDevice *_device;
    
    MultiBoxTracker *_tracker;
    Byte* _yuvFrame;
    
    ImageDetect* _imageDetect;
    //CameraManager* _cameraManager;
    InfoView *_infoView;
    
    NSTimeInterval _previousInferenceTimeMs;
    long _detectInterval;
    
    BOOL _isCollecting;
    BOOL _isFoucePixel;
    NSTimer *_timer; //定时器
    
    BOOL _adjustingFocus;
    
    int _count;//每几帧识别
    CGFloat _isLensChanged;//镜头位置
    
    /*相位聚焦下镜头位置 镜头晃动 值不停的改变 */
    CGFloat _isIOS8AndFoucePixelLensPosition;
    
    /*
     控制识别速度，最小值为1！数值越大识别越慢。
     相机初始化时，设置默认值为1（不要改动），判断设备若为相位对焦时，设置此值为2（可以修改，最小为1，越大越慢）
     此值的功能是为了减小相位对焦下，因识别速度过快
     此值在相机初始化中设置，在相机代理中使用，用户若无特殊需求不用修改。
     */
    int _MaxFR;
}

@end

@implementation AIPlateCollectionView

-(id)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)coder{
   if (self = [super initWithCoder:coder]) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
//    _cameraManager = [[CameraManager alloc]initWithView:self];
//    _cameraManager.delegate = self;
    //判断摄像头授权
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        self.backgroundColor = [UIColor blackColor];
        UIAlertView * alt = [[UIAlertView alloc] initWithTitle:@"未获得授权使用摄像头" message:@"请在'设置-隐私-相机'打开" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alt show];
        return;
    }
    
     _MaxFR = 1;
    //1.创建会话层
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        //2.创建、配置输入设备
    //    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    //    for (AVCaptureDevice *device in devices){
    //        if (device.position == AVCaptureDevicePositionBack){
    //            _device = device;
    //            _captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //        }
    //    }
    _device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo  position:AVCaptureDevicePositionBack];
    NSError* error;
        //创建设备输入流，并增加到会话。
    _captureInput = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
        
    [_session addInput:_captureInput];
        
    //2.创建视频流输出
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    dispatch_queue_t queue;
    queue = dispatch_queue_create("cameraQueue", NULL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    [_session addOutput:captureOutput];
    [[captureOutput connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:(AVCaptureVideoOrientation)UIInterfaceOrientationPortrait];
    //3.创建、配置静态拍照输出
//    _captureOutput = [[AVCaptureStillImageOutput alloc] init];
//    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
//    [_captureOutput setOutputSettings:outputSettings];
//    [_session addOutput:_captureOutput];
//    [[_captureOutput connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:(AVCaptureVideoOrientation)UIInterfaceOrientationPortrait];
//
    //4.预览图层
    _preview = [AVCaptureVideoPreviewLayer layerWithSession: _session];
    _preview.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //_preview.connection.videoOrientation =  UIInterfaceOrientationPortrait;

    [self.layer addSublayer:_preview];
    
    _isCollecting = false;
    _isFoucePixel = false;
    //判断是否相位对焦
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        AVCaptureDeviceFormat *deviceFormat = _device.activeFormat;
        if (deviceFormat.autoFocusSystem == AVCaptureAutoFocusSystemPhaseDetection){
            _isFoucePixel = YES;
            _MaxFR = 2;
        }
    }
    
    _infoView=[[InfoView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _infoView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_infoView];

    _tracker = [[MultiBoxTracker alloc]init];
    
    NSString* modelPath = [[NSBundle mainBundle] pathForResource:@"detect" ofType:@"tflite"];
    NSString* labelPath = [[NSBundle mainBundle] pathForResource:@"labelmap" ofType:@"txt"];
    _imageDetect=[[ImageDetect alloc]initWithModle:modelPath labels:labelPath andThreadCount:1];
    
    _previousInferenceTimeMs = -1;
    _detectInterval = 100;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    _preview.frame = self.bounds;
    _infoView.frame = self.bounds;
}


//刷新布局
-(void)setaIRecognitionArrayAndUpdateView:(NSArray *)aIRecognitionArray withSize:(CGSize)size{

    _infoView.sizeCamera = size;
    _infoView.aIRecognitionArray=aIRecognitionArray;
    [_infoView refresh];
}

-(void) startCollection{

    _isCollecting = true;
    
    //不支持相位对焦情况下(iPhone6以后的手机支持相位对焦) 设置定时器 开启连续对焦
    if (!_isFoucePixel) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.3 target:self selector:@selector(fouceMode) userInfo:nil repeats:YES];
    }
    
    AVCaptureDevice*camDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    int flags = NSKeyValueObservingOptionNew;
    //注册通知
    [camDevice addObserver:self forKeyPath:@"adjustingFocus" options:flags context:nil];
    if (_isFoucePixel) {
        [camDevice addObserver:self forKeyPath:@"lensPosition" options:flags context:nil];
    }
    
    [_session startRunning];
}
-(void) stopCollection{

    _isCollecting = false;
    if (!_isFoucePixel) {
        [_timer invalidate];
        _timer = nil;
    }
    AVCaptureDevice*camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [camDevice removeObserver:self forKeyPath:@"adjustingFocus"];
    if (_isFoucePixel) {
        [camDevice removeObserver:self forKeyPath:@"lensPosition"];
    }
    
    [_session stopRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{

    NSDate *date = [NSDate date];
    NSTimeInterval currentTimeMs = [date timeIntervalSince1970]*1000;
    if ( currentTimeMs-_previousInferenceTimeMs < _detectInterval ) {
        return;
    }
    _previousInferenceTimeMs = currentTimeMs;
    
    if (!_isCollecting) {
        return;
    }
    
    
    @try {
        CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        NSArray *resultOriginal = [_imageDetect runModel:pixelBuffer];
        //筛选car
        NSMutableArray* arrCar = [[NSMutableArray alloc]init];
        
        for (int i=0; i<resultOriginal.count; i++) {
            AIRecognition* resultTemp = [resultOriginal objectAtIndex:i];
            if ([resultTemp.label isEqualToString:@"car"] || [resultTemp.label isEqualToString:@"bus"] || [resultTemp.label isEqualToString:@"truck"] ) {
                [arrCar addObject:resultTemp];
            }
        }
        
        NSArray *result = [_tracker track:arrCar with:pixelBuffer];
       
       
        size_t width = CVPixelBufferGetWidth(pixelBuffer);
        size_t height = CVPixelBufferGetHeight(pixelBuffer);
        
        //更新所有子view
        [self setaIRecognitionArrayAndUpdateView:result withSize:CGSizeMake(width,height)];
        
        if ([result count]==0) {
            return;
        }
      
        if (!_adjustingFocus) {  //反差对焦下 非正在对焦状态（相位对焦下self.adjustingFocus此值不会改变）
            if (_isLensChanged == _isIOS8AndFoucePixelLensPosition) {
                _count++;
                if (_count >= _MaxFR){
                    if ([self infoFrom:pixelBuffer withRecognitions:result]) {
                        _count = 0;
                    }
                }else{
                    _isLensChanged = _isIOS8AndFoucePixelLensPosition;
                    _count = 0;
                }
                
            }
        }
        
        
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

-(BOOL)infoFrom:(CVImageBufferRef)pixelBuffer withRecognitions:(NSArray*)arrCar{
    BOOL bResult = false;
    size_t width = CVPixelBufferGetWidth(pixelBuffer);
    size_t height = CVPixelBufferGetHeight(pixelBuffer);
    CVPixelBufferLockBaseAddress(pixelBuffer,0);
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(pixelBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer);

    /*We unlock the  image buffer*/
    CVPixelBufferUnlockBaseAddress(pixelBuffer,0);
            
    /*Create a CGImageRef from the CVImageBufferRef*/
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef fullImage = CGBitmapContextCreateImage(newContext);
            
    /*We release some components*/
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
            
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
            
    for(int i=0;i<arrCar.count;i++){
        AIRecognition* resultTemp = [arrCar objectAtIndex:i];
        CGRect rectTemp = CGRectMake(resultTemp.rect.origin.x*width,
                                             resultTemp.rect.origin.y*height,
                                             resultTemp.rect.size.width*width,
                                             resultTemp.rect.size.height*height);
        CGImageRef carRefImage = CGImageCreateWithImageInRect(fullImage, rectTemp);
        UIImage *carImage = nil;
                
    //            switch (deviceOrientation) {
    //                case UIDeviceOrientationPortrait:           // Device oriented vertically, home button on the bottom
    //                   carImage = [UIImage imageWithCGImage:carRefImage scale:1.0 orientation:UIImageOrientationRight];
    //                    break;
    //                case  UIDeviceOrientationPortraitUpsideDown:  // Device oriented vertically, home button on the top
    //                    carImage = [UIImage imageWithCGImage:carRefImage scale:1.0 orientation:UIImageOrientationLeft];
    //                    break;
    //                case UIDeviceOrientationLandscapeRight:     // Device oriented horizontally, home button on the left
    //                    carImage = [UIImage imageWithCGImage:carRefImage scale:1.0 orientation:UIImageOrientationDown];
    //                    break;
    //
    //                default:
    //                    carImage = [UIImage imageWithCGImage:carRefImage scale:1.0 orientation:UIImageOrientationUp];
    //                    break;
    //            }
                
        switch (deviceOrientation) {
            case UIDeviceOrientationPortrait:           // Device oriented vertically, home button on the bottom
                carImage = [UIImage imageWithCGImage:carRefImage scale:1.0 orientation:UIImageOrientationUp];
            break;
            case  UIDeviceOrientationPortraitUpsideDown:  // Device oriented vertically, home button on the top
                carImage = [UIImage imageWithCGImage:carRefImage scale:1.0 orientation:UIImageOrientationDown];
            break;
            case UIDeviceOrientationLandscapeRight:     // Device oriented horizontally, home button on the left
                carImage = [UIImage imageWithCGImage:carRefImage scale:1.0 orientation:UIImageOrientationRight];
            break;
                                   
            default:
                carImage = [UIImage imageWithCGImage:carRefImage scale:1.0 orientation:UIImageOrientationLeft];
            break;
        }
                
        //识别
        UIImage *temp_image = [Utility scaleAndRotateImageBackCamera:carImage];
        cv::Mat source_image = [Utility cvMatFromUIImage:temp_image];
        NSString* text = [self simpleRecognition:source_image];
                                       
        if (text.length == 7) { //识别成功            bResult = true;
            if(self.delegate!=nil){
                AICARType carType;
                if([resultTemp.label isEqualToString:@"truck"] ){
                    carType = AI_TRUCK;
                }else if( [resultTemp.label isEqualToString:@"bus"] ){
                    carType = AI_BUS;
                } else{
                    carType = AI_CAR;
                }
                
                [self.delegate collectedPlate:text forCarType:carType andImage:carImage];
            }
        }
                
        CGImageRelease(carRefImage);
    }
            
    CGImageRelease(fullImage);
    CVPixelBufferUnlockBaseAddress(pixelBuffer,0);
    return bResult;
}

- (NSString *)getPath:(NSString*)fileName
{
    NSString *bundlePath = [NSBundle mainBundle].bundlePath;
    NSString *path = [bundlePath stringByAppendingPathComponent:fileName];
    return path;
}

- (NSString *)simpleRecognition:(cv::Mat&)src
{
    NSString *path_1 = [self getPath:@"cascade.xml"];
    NSString *path_2 = [self getPath:@"HorizonalFinemapping.prototxt"];
    NSString *path_3 = [self getPath:@"HorizonalFinemapping.caffemodel"];
    NSString *path_4 = [self getPath:@"Segmentation.prototxt"];
    NSString *path_5 = [self getPath:@"Segmentation.caffemodel"];
    NSString *path_6 = [self getPath:@"CharacterRecognization.prototxt"];
    NSString *path_7 = [self getPath:@"CharacterRecognization.caffemodel"];
    
    std::string *cpath_1 = new std::string([path_1 UTF8String]);
    std::string *cpath_2 = new std::string([path_2 UTF8String]);
    std::string *cpath_3 = new std::string([path_3 UTF8String]);
    std::string *cpath_4 = new std::string([path_4 UTF8String]);
    std::string *cpath_5 = new std::string([path_5 UTF8String]);
    std::string *cpath_6 = new std::string([path_6 UTF8String]);
    std::string *cpath_7 = new std::string([path_7 UTF8String]);
    
    
    pr::PipelinePR pr2 = pr::PipelinePR(*cpath_1, *cpath_2, *cpath_3, *cpath_4, *cpath_5, *cpath_6, *cpath_7);
    
    std::vector<pr::PlateInfo> list_res = pr2.RunPiplineAsImage(src);
    std::string concat_results = "";
    for(auto one:list_res) {
        if(one.confidence>0.7) {
            concat_results += one.getPlateName()+",";
        }
    }
    
    NSString *str = [NSString stringWithCString:concat_results.c_str() encoding:NSUTF8StringEncoding];
    if (str.length > 0) {
        str = [str substringToIndex:str.length-1];
        str = [NSString stringWithFormat:@"%@",str];
    } else {
        str = [NSString stringWithFormat:@"未识别成功"];
    }
    NSLog(@"===> 识别结果 = %@", str);
    
    return str;
}

//对焦
- (void)fouceMode
{
    NSError *error;
    AVCaptureDevice *device = [self cameraWithPosition:AVCaptureDevicePositionBack];
    if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        if ([device lockForConfiguration:&error]) {
            CGPoint cameraPoint = [_preview captureDevicePointOfInterestForPoint:self.center];
            [device setFocusPointOfInterest:cameraPoint];
            [device setFocusMode:AVCaptureFocusModeAutoFocus];
            [device unlockForConfiguration];
        } else {
            //NSLog(@"Error: %@", error);
        }
    }
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices){
        if (device.position == position){
            return device;
        }
    }
    return nil;
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    
    /*反差对焦 监听反差对焦此*/
    if([keyPath isEqualToString:@"adjustingFocus"]){
        _adjustingFocus =[[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1]];
    }
    /*监听相位对焦此*/
    if([keyPath isEqualToString:@"lensPosition"]){
        _isIOS8AndFoucePixelLensPosition =[[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        //NSLog(@"监听_isIOS8AndFoucePixelLensPosition == %f",_isIOS8AndFoucePixelLensPosition);
    }
}

@end

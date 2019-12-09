//
//  CameraManager.m
//  SuperMapAI
//
//  Created by wnmng on 2019/10/28.
//  Copyright © 2019 wnmng. All rights reserved.
//

#import "CameraManager.h"

@interface CameraManager()<AVCaptureVideoDataOutputSampleBufferDelegate>{
    UIView *captureVideoPreviewView;
    AVCaptureSession *session;
    AIDetectView* aiDetectView;
    //图像预览层，实时显示捕获的图像
    AVCaptureVideoPreviewLayer *previewLayer;
    AVCaptureStillImageOutput* _imageOutput;
}

@end

@implementation CameraManager

-(void)outputImage:(id) takePictureSuccess{
    AVCaptureStillImageOutput *imageOutput = [[AVCaptureStillImageOutput alloc] init];
    imageOutput.outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    if ([session canAddOutput:imageOutput]) {
        [session addOutput:imageOutput];
        _imageOutput = imageOutput;
    }

    // 输出图片
    AVCaptureConnection *connection = [_imageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (connection.isVideoOrientationSupported) {
        connection.videoOrientation = UIInterfaceOrientationPortrait;
    }
//    static UIImage *image = nil;
    
    [_imageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:takePictureSuccess];
}
-(id)initWithView:(AIDetectView*)view{
    if (self = [super init]) {
        aiDetectView = view;
        session = [[AVCaptureSession alloc]init];
        session.sessionPreset = AVCaptureSessionPresetHigh;
        //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
        previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
        previewLayer.session=session;
        previewLayer.frame = view.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [aiDetectView.layer insertSublayer:previewLayer atIndex:0];
        view.previewLayer = previewLayer;
        previewLayer.connection.videoOrientation =  UIInterfaceOrientationPortrait;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        [session beginConfiguration];
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo  position:AVCaptureDevicePositionBack];
        NSError* error;
        //创建设备输入流，并增加到会话。
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (!input || error!=nil || ![session canAddInput:input]) {
            //处理错误
            NSLog(@"无法访问相机");
            [session commitConfiguration];
            return nil;
        }else{
            [session addInput:input];
        }
        
        AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
        
        
        //配置输出流
        dispatch_queue_t sampleBufferQueue = dispatch_queue_create("sampleBufferQueue", NULL);
        //添加相机回调
        [videoDataOutput setSampleBufferDelegate:self queue:sampleBufferQueue];
        
        [videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
        //指定像素格式。
        videoDataOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
        
        if (![session canAddOutput:videoDataOutput]) {
            [session commitConfiguration];
            return nil;
        }else{
            [session addOutput:videoDataOutput];
            [[videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:(AVCaptureVideoOrientation)UIInterfaceOrientationPortrait];
        }
        
        
        [session commitConfiguration];
    }
    return self;
}

-(void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    if (_delegate!=nil && [_delegate respondsToSelector:@selector(didOutput:)]) {
        [_delegate didOutput:pixelBuffer];
    }
}

-(void)checkCameraConfigurationAndStartSession{
    if(session){
        [session startRunning];
    }
}
-(void)checkCameraConfigurationAndStopSession{
    if(session){
        [session stopRunning];
    }
}

@end

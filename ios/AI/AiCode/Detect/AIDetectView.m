//
//  AIDetectView.m
//  SuperMapAI
//
//  Created by zhouyuming on 2019/11/15.
//  Copyright © 2019年 wnmng. All rights reserved.
//


#import "AIDetectView.h"
#import "CameraManager.h"
#import "ImageDetect.h"
#import "AIDetectViewInfo.h"
#import "AIRecognition.h"
#import "InfoView.h"
#import "TensorflowTrackNative.h"
#import "MultiBoxTracker.h"
#import <Accelerate/Accelerate.h>

@interface AIDetectView()<CameraManagerDelegate>
{
    UIImage* m_image;

    MultiBoxTracker *_tracker;
    Byte* _yuvFrame;
}

//@property (nonatomic,assign) long detectInterval;
@property (nonatomic,assign) NSTimeInterval previousInferenceTimeMs;
@property (strong, nonatomic) ImageDetect* imageDetect;
@property (nonatomic,strong) AIDetectViewInfo* aIDetectViewInfo;
@property (strong, nonatomic) CameraManager* cameraManager;

@property (nonatomic,assign) BOOL isDetecting;
@property (nonatomic,strong) AIDetectStyle* aIDetectStyle;
@property (nonatomic,strong) InfoView *infoView;
@end

@implementation AIDetectView


-(void)initData{
    
    self.cameraManager = [[CameraManager alloc]initWithView:self];
    self.cameraManager.delegate=self;
    
    _infoView=[[InfoView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _infoView.backgroundColor = [UIColor clearColor];
//    _infoView.opaque = NO;
    _infoView.callBackBlock = ^(AIRecognition *aIRecognition) {
        NSLog(@"++ touch %@",aIRecognition.label);
        if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(touchAIRecognition:)]) {
            [self.delegate touchAIRecognition:aIRecognition];
        }
    };
    if(_aIDetectStyle){
        _infoView.aIDetectStyle=_aIDetectStyle;
    }
//    _infoView.userInteractionEnabled = NO;
    [self addSubview:_infoView];
    
//    self.detectInterval = 100;

    _tracker = [[MultiBoxTracker alloc]init];
}

-(void)outputImage:(getImageCallBackBlock)getImageCallback withInfo:(BOOL)bInfo{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImageView* uiimage = [[UIImageView alloc]initWithImage:m_image];
        uiimage.backgroundColor = [UIColor clearColor];
        uiimage.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        if(bInfo){
            [uiimage addSubview:_infoView];
        }
         CGSize s = uiimage.bounds.size;
         UIGraphicsBeginImageContextWithOptions(s, NO, 1);
         [uiimage.layer renderInContext:UIGraphicsGetCurrentContext()];
         UIImage* imageRes = UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();
         getImageCallback(imageRes,nil);
    });

}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//
//    [self outputImage:^(UIImage *image, NSError *error) {
//
//    } withInfo:YES];
//}

//刷新布局
-(void)setaIRecognitionArrayAndUpdateView:(NSArray *)aIRecognitionArray withSize:(CGSize)size{

    _infoView.sizeCamera = size;
    _infoView.aIRecognitionArray=aIRecognitionArray;
    [_infoView refresh];
}


-(void) setDetectInfo:(AIDetectViewInfo*) detectViewInfo{
    self.aIDetectViewInfo=detectViewInfo;
    
     self.imageDetect=[[ImageDetect alloc]initWithModle:detectViewInfo.modeFile labels:detectViewInfo.lableFile andThreadCount:1];
}

-(void) startCameraPreview{
    [self.cameraManager checkCameraConfigurationAndStartSession];
}
-(void) stopCameraPreview{
    [self.cameraManager checkCameraConfigurationAndStopSession];
}
-(void) resumeDetect{
    self.isDetecting=YES;
}
-(void) pauseDetect{
    self.isDetecting=NO;
}

-(void) setAIDetectStyle:(AIDetectStyle*) aIDetectStyle{
    _aIDetectStyle=aIDetectStyle;
    if(_infoView){
        _infoView.aIDetectStyle=_aIDetectStyle;
    }
}

-(void)clearClickAIRecognition{
    _infoView.clickAIRecognition=nil;
}


-(void)didOutput:(CVPixelBufferRef)pixelBuffer{
    if(!_isDetecting){
        return;
    }
    NSDate *date = [NSDate date];
    NSTimeInterval currentTimeMs = [date timeIntervalSince1970]*1000;
    if (currentTimeMs-_previousInferenceTimeMs < _detectInterval) {
        return;
    }
    _previousInferenceTimeMs = currentTimeMs;
    
    @try {
        NSArray *resultOriginal = [self.imageDetect runModel:pixelBuffer];
        
        NSArray *result = [_tracker track:resultOriginal with:pixelBuffer];
       
        //更新所有子view
        [self setaIRecognitionArrayAndUpdateView:result withSize:CGSizeMake(CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer))];
      
        m_image = [[UIImage alloc] initWithCIImage:[CIImage imageWithCVPixelBuffer:pixelBuffer]];
//        m_pixelBuffer = pixelBuffer;
//        for (int i=0; i<result.count; i++) {
//            AIRecognition *inference = result[i];
//            NSLog(@"%i __%.3f__%.3f__%.3f__%.3f",result.count,inference.rect.origin.x,inference.rect.origin.y,inference.rect.size.width,inference.rect.size.height);
//        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}


@end

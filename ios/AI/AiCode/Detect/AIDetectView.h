//
//  AIDetectView.h
//  SuperMapAI
//
//  Created by zhouyuming on 2019/11/15.
//  Copyright © 2019年 wnmng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AIDetectStyle.h"
@class AIDetectViewInfo;
@class AIRecognition,AVCaptureVideoPreviewLayer;

@protocol AIDetectTouchDelegate <NSObject>

-(void)touchAIRecognition:(AIRecognition*)aIRecognition;

@end

typedef void(^getImageCallBackBlock)(UIImage *image,NSError* error);

@interface AIDetectView : UIView

@property (nonatomic,assign) long detectInterval;
@property(nonatomic,assign) id<AIDetectTouchDelegate> delegate;
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *previewLayer;
-(void)initData;
/** 设置数据 **/
-(void) setDetectInfo:(AIDetectViewInfo*) detectViewInfo;
/** 设置设置间隔时间 **/
//-(void) setDetectInterval:(long) detectInterval;
/** 开启摄像头 **/
-(void) startCameraPreview;
/** 关闭摄像头 **/
-(void) stopCameraPreview;
/** 开始识别 **/
-(void) resumeDetect;
/** 停止识别 **/
-(void) pauseDetect;
/** 设置识别框显示样式 **/
-(void) setAIDetectStyle:(AIDetectStyle*) aIDetectStyle;

//清除选中的识别对象
-(void)clearClickAIRecognition;
//截图拍照
-(void)outputImage:(getImageCallBackBlock)getImageCallback withInfo:(BOOL)bInfo;
@end

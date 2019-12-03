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
@class AIRecognition;

@protocol AIDetectTouchDelegate <NSObject>

-(void)touchAIRecognition:(AIRecognition*)aIRecognition;

@end


@interface AIDetectView : UIView

@property (nonatomic,assign) long detectInterval;
@property(nonatomic,weak) id<AIDetectTouchDelegate> delegate;

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
@end

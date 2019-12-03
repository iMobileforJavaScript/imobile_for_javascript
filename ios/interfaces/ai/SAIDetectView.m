//
//  SAIDetectView.m
//  Supermap
//
//  Created by zhouyuming on 2019/11/21.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "SAIDetectView.h"
#import "AIDetectViewInfo.h"
#import "AIDetectStyle.h"

@implementation SAIDetectView


static AIDetectView* mAIDetectView = nil;
static NSString* mLanguage=nil;
static AIDetectStyle* mAIDetectStyle=nil;   //识别框类型
static BOOL mIsDrawTitle=NO;         //是否显示title
static BOOL mIsDrawConfidence=NO;    //是否显示可信度

RCT_EXPORT_MODULE();

+(void)setInstance:(AIDetectView*)aIDetectView{
    mAIDetectView=aIDetectView;
    AIDetectViewInfo* info=[[AIDetectViewInfo alloc] init];
    
    NSString* modelPath= [[NSBundle mainBundle] pathForResource:@"detect" ofType:@"tflite"];
    NSString* labelsPath = [[NSBundle mainBundle] pathForResource:@"labelmap" ofType:@"txt"];
    info.modeFile=modelPath;
    info.lableFile=labelsPath;
    
    [mAIDetectView initData];
    [mAIDetectView setDetectInfo:info];
    mAIDetectView.detectInterval=2000;
    //设置风格
    if(!mAIDetectStyle){
        mAIDetectStyle=[[AIDetectStyle alloc] init];
        mAIDetectStyle.isDrawTitle=mIsDrawTitle;
        mAIDetectStyle.isDrawConfidence=mIsDrawConfidence;
    }
    [mAIDetectView setAIDetectStyle:mAIDetectStyle];
    
    [mAIDetectView startCameraPreview];
    [mAIDetectView resumeDetect];
    
    [mAIDetectView startCameraPreview];
}

#pragma mark ARView系统版本是否支持
RCT_REMAP_METHOD(checkIfAvailable, checkIfAvailable:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"checkIfAvailable", exception.reason, nil);
    }
}

#pragma mark ARView需要的传感器是否可用
RCT_REMAP_METHOD(checkIfSensorsAvailable, checkIfSensorsAvailable:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CMMotionManager *motionManager = [[CMMotionManager alloc] init];
        BOOL gyroAvailable = motionManager.gyroAvailable;
        resolve(@(gyroAvailable));
    } @catch (NSException *exception) {
        reject(@"checkIfSensorsAvailable", exception.reason, nil);
    }
}

#pragma mark 摄像头是否可用
RCT_REMAP_METHOD(checkIfCameraAvailable, checkIfCameraAvailable:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        BOOL result=[UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
        resolve(@(result));
    } @catch (NSException *exception) {
        reject(@"checkIfCameraAvailable", exception.reason, nil);
    }
}

#pragma mark 初始化语言
RCT_REMAP_METHOD(initAIDetect, initAIDetect:(NSString*)language resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        mLanguage=language;
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"initAIDetect", exception.reason, nil);
    }
}

#pragma mark 停止识别,回收资源
RCT_REMAP_METHOD(dispose, dispose:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        [mAIDetectView pauseDetect];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"dispose", exception.reason, nil);
    }
}

#pragma mark 设置识别框是否绘制检测名称
RCT_REMAP_METHOD(setDrawTileEnable, setDrawTileEnable:(BOOL)value resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        mIsDrawTitle=value;
        mAIDetectStyle.isDrawTitle=value;
        [mAIDetectView setAIDetectStyle:mAIDetectStyle];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setDrawTileEnable", exception.reason, nil);
    }
}

#pragma mark 获取识别框是否绘制检测名称
RCT_REMAP_METHOD(isDrawTileEnable, isDrawTileEnable:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        resolve(@(mAIDetectStyle.isDrawTitle));
    } @catch (NSException *exception) {
        reject(@"isDrawTileEnable", exception.reason, nil);
    }
}

#pragma mark 设置识别框是否绘制可信度
RCT_REMAP_METHOD(setDrawConfidenceEnable, setDrawConfidenceEnable:(BOOL)value resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        mIsDrawConfidence=value;
        mAIDetectStyle.isDrawConfidence=value;
        [mAIDetectView setAIDetectStyle:mAIDetectStyle];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setDrawConfidenceEnable", exception.reason, nil);
    }
}

#pragma mark 获取识别框是否绘制可信度
RCT_REMAP_METHOD(isDrawConfidenceEnable, isDrawConfidenceEnable:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        resolve(@(mAIDetectStyle.isDrawConfidence));
    } @catch (NSException *exception) {
        reject(@"dispose", exception.reason, nil);
    }
}





////////////////////////////////////TODO/////////////////////////////////

#pragma mark 投射模式
RCT_REMAP_METHOD(setProjectionModeEnable, checkIfCameraAvailable:(BOOL)value resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setProjectionModeEnable", exception.reason, nil);
    }
}

#pragma mark 投射模式
RCT_REMAP_METHOD(isProjectionModeEnable, isProjectionModeEnable:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        
        resolve(@(NO));
    } @catch (NSException *exception) {
        reject(@"isProjectionModeEnable", exception.reason, nil);
    }
}

#pragma mark 是否开启跟踪计数
RCT_REMAP_METHOD(getIsCountTrackedMode, getIsCountTrackedMode:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        resolve(@(NO));
    } @catch (NSException *exception) {
        reject(@"isProjectionModeEnable", exception.reason, nil);
    }
}



@end

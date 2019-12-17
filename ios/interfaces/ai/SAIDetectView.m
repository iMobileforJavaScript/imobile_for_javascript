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
#import "AIRecognition.h"
#import "RCTViewManager.h"
#import "SLanguage.h"

typedef enum {
    ASSETS_FILE,
    ABSOLUTE_FILE_PATH,
} ModelType;

//@interface SAIDetectView()<AIDetectTouchDelegate>{
//    
//}

//@end

@implementation SAIDetectView

NSString *const onArObjectClick  = @"onArObjectClick";

static AIDetectView* mAIDetectView = nil;
static NSString* mLanguage=nil;
static AIDetectStyle* mAIDetectStyle=nil;   //识别框类型
static BOOL mIsDrawTitle=YES;         //是否显示title
static BOOL mIsDrawConfidence=YES;    //是否显示可信度
static BOOL mIsDrawCount=YES;    //是否显示跟踪计数

static ModelType mModelType = ASSETS_FILE;

static NSString* MODEL_PATH=@"";
static NSString* LABEL_PATH=@"";

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents {
    return @[
             onArObjectClick
             ];
}

+(void)setInstance:(AIDetectView*)aIDetectView{
    mAIDetectView=aIDetectView;
    AIDetectViewInfo* info=[[AIDetectViewInfo alloc] init];
    
    NSString* modelPath= [[NSBundle mainBundle] pathForResource:@"detect" ofType:@"tflite"];
    NSString* labelsPath = [[NSBundle mainBundle] pathForResource:@"labelmap_cn" ofType:@"txt"];
    if([[SLanguage getLanguage] isEqualToString:@"EN"]){
        labelsPath = [[NSBundle mainBundle] pathForResource:@"labelmap" ofType:@"txt"];
    }
    info.modeFile=modelPath;
    info.lableFile=labelsPath;
    
    [mAIDetectView initData];
    [mAIDetectView setDetectInfo:info];
    mAIDetectView.detectInterval=200;
    //设置风格
    if(!mAIDetectStyle){
        mAIDetectStyle=[[AIDetectStyle alloc] init];
        mAIDetectStyle.isDrawTitle=mIsDrawTitle;
        mAIDetectStyle.isDrawConfidence=mIsDrawConfidence;
        mAIDetectStyle.aiStrokeWidth=3;
        mAIDetectStyle.isDrawCount = mIsDrawCount;
    }
    [mAIDetectView setAIDetectStyle:mAIDetectStyle];
//    mAIDetectView.delegate=self;
    
    [mAIDetectView startCameraPreview];
    [mAIDetectView resumeDetect];
    
    [mAIDetectView startCameraPreview];
}

#pragma mark 点击识别目标回调
-(void)touchAIRecognition:(AIRecognition*)aIRecognition{
    if(!aIRecognition){
        return;
    }
    
}

-(void)initDelegate{
     mAIDetectView.delegate=self;
}

+(void)saveArPreviewBitmap:(NSString*)folderPath name:(NSString*)name{
    [mAIDetectView outputImage:^(UIImage *aIImage, NSError *error) {
        if(!aIImage){
            return;
        }
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = NO;
        BOOL dataIsDir = NO;
        // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
        BOOL existed = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
        
        if ( !(isDir == YES && existed == YES) ) {//如果文件夹不存在
            [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString* imagePath=[folderPath stringByAppendingFormat:@"%@.jpg",name];
        // 保存图片到指定的路径
        NSData *data = UIImageJPEGRepresentation(aIImage,1);
        [data writeToFile:imagePath atomically:NO];
//        if(aIImage){
//            aIImage=nil;
//        }
        [mAIDetectView clearClickAIRecognition];
    } withInfo:YES];
}

#pragma mark 清除选中的对象,清除后才能再刷新界面
RCT_REMAP_METHOD(clearClickAIRecognition, clearClickAIRecognition:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [mAIDetectView clearClickAIRecognition];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"clearClickAIRecognition", exception.reason, nil);
    }
}

#pragma mark 开启摄像头
RCT_REMAP_METHOD(startCamera, startCamera:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [mAIDetectView startCameraPreview];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"startCameraPreview", exception.reason, nil);
    }
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


#pragma mark 获取模型文件等信息
RCT_REMAP_METHOD(getDetectInfo, getDetectInfo:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        NSMutableDictionary* dic=[[NSMutableDictionary alloc] init];
        if(mModelType==ABSOLUTE_FILE_PATH){
            [dic setObject:@"ABSOLUTE_FILE_PATH" forKey:@"ModelType"];
            [dic setObject:MODEL_PATH forKey:@"ModelPath"];
            [dic setObject:LABEL_PATH forKey:@"LabelPath"];
        }else{
            [dic setObject:@"ASSETS_FILE" forKey:@"ModelType"];
        }
        
        resolve(dic);
    } @catch (NSException *exception) {
        reject(@"getDetectInfo", exception.reason, nil);
    }
}

#pragma mark 设置模型文件等信息
RCT_REMAP_METHOD(setDetectInfo, setDetectInfo:(NSDictionary*)detectInfo resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        ModelType modelType;
        NSString* modelPath = @"";
        NSString* labelPath = @"";
        
        if([detectInfo objectForKey:@"ModelType"]){
            NSString* type=[detectInfo objectForKey:@"ModelType"];
            if([type isEqualToString:@"ASSETS_FILE"]){
                modelType=ASSETS_FILE;
            }else if([type isEqualToString:@"ABSOLUTE_FILE_PATH"]){
                modelType=ABSOLUTE_FILE_PATH;
            }
        }
        if([detectInfo objectForKey:@"ModelPath"]){
            modelPath=[detectInfo objectForKey:@"ModelPath"];
        }
        if([detectInfo objectForKey:@"LabelPath"]){
            labelPath=[detectInfo objectForKey:@"LabelPath"];
        }
        
        if(modelType==ABSOLUTE_FILE_PATH){
            MODEL_PATH = modelPath;
            LABEL_PATH = labelPath;
        }else if(modelType==ASSETS_FILE){
            MODEL_PATH = @"";
            LABEL_PATH = @"";
        }
        mModelType = modelType;
        
        AIDetectViewInfo* info=[[AIDetectViewInfo alloc] init];
        
        info.modeFile=modelPath;
        info.lableFile=labelPath;
        
        [mAIDetectView setDetectInfo:info];
        
        resolve(@"YES");
    } @catch (NSException *exception) {
        reject(@"getDetectInfo", exception.reason, nil);
    }
}

#pragma mark 设置识别框开始跟踪计数
RCT_REMAP_METHOD(startCountTrackedObjs, startCountTrackedObjs:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        mIsDrawCount=YES;
        mAIDetectStyle.isDrawCount=mIsDrawCount;
        [mAIDetectView setAIDetectStyle:mAIDetectStyle];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"startCountTrackedObjs", exception.reason, nil);
    }
}

#pragma mark 停止跟踪计数
RCT_REMAP_METHOD(stopCountTrackedObjs, stopCountTrackedObjs:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        mIsDrawCount=NO;
        mAIDetectStyle.isDrawCount=mIsDrawCount;
        [mAIDetectView setAIDetectStyle:mAIDetectStyle];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"stopCountTrackedObjs", exception.reason, nil);
    }
}


////////////////////////////////////TODO/////////////////////////////////


#pragma mark 返回是否聚合模式
RCT_REMAP_METHOD(isPolymerize, isPolymerize:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        
        resolve(@(NO));
    } @catch (NSException *exception) {
        reject(@"setIsPolymerize", exception.reason, nil);
    }
}

#pragma mark 设置是否聚合模式(态势检测)
RCT_REMAP_METHOD(setIsPolymerize, setIsPolymerize:(BOOL)value resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setIsPolymerize", exception.reason, nil);
    }
}

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
        resolve(@(mAIDetectStyle.isDrawCount));
    } @catch (NSException *exception) {
        reject(@"isProjectionModeEnable", exception.reason, nil);
    }
}


@end

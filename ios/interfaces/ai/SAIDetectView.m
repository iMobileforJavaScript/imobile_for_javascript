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
#import "SuperMapAI/AIDetectViewInfo.h"
#import "SuperMapAI/AIDetectStyle.h"
#import "SuperMapAI/AIRecognition.h"
#import "RCTViewManager.h"

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
static BOOL mIsDrawTitle=NO;         //是否显示title
static BOOL mIsDrawConfidence=NO;    //是否显示可信度

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
        mAIDetectStyle.aiStrokeWidth=3;
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

-(void)onclickAIObject:(AIRecognition*)aIRecognition{
//    mCurrentArObject = arrayList.get(0);
//    Log.d(REACT_CLASS, "onClickArObject: " + mCurrentArObject.getName());
//
//    //移除其他的Arobject
//    List<ArObjectList> arObjectLists = mWorld.getArObjectLists();
//    for (int i = 0; i < arObjectLists .size(); i++) {
//        ArObjectList arObjects = arObjectLists.get(i);
//        for (int j = 0; j < arObjects.size(); j++) {
//            ArObject arObject = arObjects.get(j);
//            if (mCurrentArObject.getId() != arObject.getId()) {
//                mWorld.remove(arObject);
//            }
//        }
//    }
//
//    //向JS传递ArObject的点击事件
//    WritableMap info = Arguments.createMap();
//    info.putInt("id", ((int) mCurrentArObject.getId()));
//    info.putString("name", mCurrentArObject.getName());
//    info.putString("info", mCurrentArObject.getInfo());
//    mReactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
//                                                                  mCustomRelativeLayout.getId(),
//                                                                  "onArObjectClick",
//                                                                  info
//                                                                  );
    
//    @try {
//        
//        NSMutableDictionary* info=[[NSMutableDictionary alloc] init];
//        
//        [info setValue:0 forKey:@"id"];
//        [info setValue:aIRecognition.label forKey:@"name"];
//        
//        NSMutableDictionary* arInfo=[[NSMutableDictionary alloc] init];
//        [arInfo setValue:aIRecognition.label forKey:@"mediaName"];
//        [info setValue:aIRecognition.label forKey:@"info"];
//        
////        [self sendEventWithName:onArObjectClick body:info];
//        
//        self.onArObjectClick(info);
//    } @catch (NSException *exception) {
//        NSString* reason=exception.reason;
//    }
    
    
}

+(void)saveArPreviewBitmap:(NSString*)folderPath name:(NSString*)name{
    
//    CGSize s = mAIDetectView.bounds.size;
//    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
//    [mAIDetectView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    UIImage* aIImage=[self makeImageWithView:mAIDetectView];
    
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
    NSData *data = UIImagePNGRepresentation(aIImage);
    [data writeToFile:imagePath atomically:YES];
    if(aIImage){
        aIImage=nil;
    }
}

+ (UIImage *)makeImageWithView:(UIView *)view{
    CGSize s = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
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
        
        resolve(@(NO));
    } @catch (NSException *exception) {
        reject(@"isProjectionModeEnable", exception.reason, nil);
    }
}


@end

//
//  JSCoordSysTransParameter.m
//  Supermap
//
//  Created by wnmng on 2018/8/9.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSCoordSysTransParameter.h"
#import "SuperMap/CoordSysTransParameter.h"
#import "JSObjManager.h"

@implementation JSCoordSysTransParameter
RCT_EXPORT_MODULE();

/**
 * 创建对象
 * @param promise
 */
RCT_REMAP_METHOD(createObj,createObj:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CoordSysTransParameter *param = [[CoordSysTransParameter alloc]init];
        NSInteger nsKey = (NSInteger)param;
        [JSObjManager addObj:param];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSCoordSysTransParameter",@"createObj expection",nil);
    }
}
/**
 * 对CoordSysTransParameter的clone
 *
 * @param coordSysTransParameterId
 * @param promise
 */
RCT_REMAP_METHOD(clone,clone:(NSString*)coordSysTransParamId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CoordSysTransParameter *param = [JSObjManager getObjWithKey:coordSysTransParamId];
        CoordSysTransParameter *cloneparam = [param clone];
        NSInteger nsKey = (NSInteger)cloneparam;
        [JSObjManager addObj:cloneparam];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSCoordSysTransParameter",@"clone expection",nil);
    }
}
/**
 * 释放该对象所占用的资源
 *
 * @param coordSysTransParameterId
 * @param promise
 */
RCT_REMAP_METHOD(dispose,dispose:(NSString*)coordSysTransParamId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CoordSysTransParameter *param = [JSObjManager getObjWithKey:coordSysTransParamId];
        [param dispose];
        [JSObjManager removeObj:coordSysTransParamId];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSCoordSysTransParameter",@"dispose expection",nil);
    }
}
/**
 * 根据 XML 字符串构建 CoordSysTransParameter 对象，成功返回 true
 *
 * @param coordSysTransParameterId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(fromXML,fromXML:(NSString*)coordSysTransParamId xml:(NSString*)strXML resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CoordSysTransParameter *param = [JSObjManager getObjWithKey:coordSysTransParamId];
        BOOL result = [param fromXML:strXML];
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"JSCoordSysTransParameter",@"fromXML expection",nil);
    }
}
/**
 * 返回 X 轴的旋转角度
 *
 * @param coordSysTransParameterId
 * @param promise
 */
RCT_REMAP_METHOD(getRotateX,getRotateX:(NSString*)coordSysTransParamId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CoordSysTransParameter *param = [JSObjManager getObjWithKey:coordSysTransParamId];
        double angle = [param rotateX];
        resolve([NSNumber numberWithDouble:angle]);
    } @catch (NSException *exception) {
        reject(@"JSCoordSysTransParameter",@"getRotateX expection",nil);
    }
}
/**
 * 返回 Z 轴的旋转角度
 *
 * @param coordSysTransParameterId
 * @param promise
 */
RCT_REMAP_METHOD(getRotateZ,getRotateZ:(NSString*)coordSysTransParamId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CoordSysTransParameter *param = [JSObjManager getObjWithKey:coordSysTransParamId];
        double angle = [param rotateZ];
        resolve([NSNumber numberWithDouble:angle]);
    } @catch (NSException *exception) {
        reject(@"JSCoordSysTransParameter",@"getRotateZ expection",nil);
    }
}
/**
 * 返回 Y 轴的旋转角度
 *
 * @param coordSysTransParameterId
 * @param promise
 */
RCT_REMAP_METHOD(getRotateY,getRotateY:(NSString*)coordSysTransParamId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CoordSysTransParameter *param = [JSObjManager getObjWithKey:coordSysTransParamId];
        double angle = [param rotateY];
        resolve([NSNumber numberWithDouble:angle]);
    } @catch (NSException *exception) {
        reject(@"JSCoordSysTransParameter",@"getRotateY expection",nil);
    }
}
/**
 * 返回投影比例尺差
 *
 * @param coordSysTransParameterId
 * @param promise
 */
RCT_REMAP_METHOD(getScaleDifference,getScaleDifference:(NSString*)coordSysTransParamId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CoordSysTransParameter *param = [JSObjManager getObjWithKey:coordSysTransParamId];
        double value = [param scaleDifference];
        resolve([NSNumber numberWithDouble:value]);
    } @catch (NSException *exception) {
        reject(@"JSCoordSysTransParameter",@"getScaleDifference expection",nil);
    }
}
/**
 * 返回 X 轴的坐标偏移量
 * @param coordSysTransParameterId
 * @param promise
 */
RCT_REMAP_METHOD(getTranslateX,getTranslateX:(NSString*)coordSysTransParamId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CoordSysTransParameter *param = [JSObjManager getObjWithKey:coordSysTransParamId];
        double value = [param translateX];
        resolve([NSNumber numberWithDouble:value]);
    } @catch (NSException *exception) {
        reject(@"JSCoordSysTransParameter",@"getTranslateX expection",nil);
    }
}
/**
 * 返回 Y 轴的坐标偏移量
 * @param coordSysTransParameterId
 * @param promise
 */
RCT_REMAP_METHOD(getTranslateY,getTranslateY:(NSString*)coordSysTransParamId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CoordSysTransParameter *param = [JSObjManager getObjWithKey:coordSysTransParamId];
        double value = [param translateY];
        resolve([NSNumber numberWithDouble:value]);
    } @catch (NSException *exception) {
        reject(@"JSCoordSysTransParameter",@"getTranslateY expection",nil);
    }
}
/**
 * 返回 Z 轴的坐标偏移量
 * @param coordSysTransParameterId
 * @param promise
 */
RCT_REMAP_METHOD(getTranslateZ,getTranslateZ:(NSString*)coordSysTransParamId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CoordSysTransParameter *param = [JSObjManager getObjWithKey:coordSysTransParamId];
        double value = [param translateZ];
        resolve([NSNumber numberWithDouble:value]);
    } @catch (NSException *exception) {
        reject(@"JSCoordSysTransParameter",@"getTranslateZ expection",nil);
    }
}
/**
 * 设置 X 轴的旋转角度
 * @param coordSysTransParameterId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setRotateX,setRotateX:(NSString*)coordSysTransParamId value:(double)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CoordSysTransParameter *param = [JSObjManager getObjWithKey:coordSysTransParamId];
        [param setRotateX:value];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSCoordSysTransParameter",@"setRotateX expection",nil);
    }
}
/**
 * 设置 Y 轴的旋转角度
 * @param coordSysTransParameterId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setRotateY,setRotateY:(NSString*)coordSysTransParamId value:(double)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CoordSysTransParameter *param = [JSObjManager getObjWithKey:coordSysTransParamId];
        [param setRotateY:value];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSCoordSysTransParameter",@"setRotateY expection",nil);
    }
}
/**
 * 设置 Z 轴的旋转角度
 * @param coordSysTransParameterId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setRotateZ,setRotateZ:(NSString*)coordSysTransParamId value:(double)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CoordSysTransParameter *param = [JSObjManager getObjWithKey:coordSysTransParamId];
        [param setRotateZ:value];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSCoordSysTransParameter",@"setRotateZ expection",nil);
    }
}
/**
 * 设置投影比例尺差
 * @param coordSysTransParameterId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setScaleDifference,setScaleDifference:(NSString*)coordSysTransParamId value:(double)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CoordSysTransParameter *param = [JSObjManager getObjWithKey:coordSysTransParamId];
        [param setScaleDifference:value];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSCoordSysTransParameter",@"setScaleDifference expection",nil);
    }
}
/**
 * 设置 X 轴的坐标偏移量
 * @param coordSysTransParameterId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setTranslateX,setTranslateX:(NSString*)coordSysTransParamId value:(double)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CoordSysTransParameter *param = [JSObjManager getObjWithKey:coordSysTransParamId];
        [param setTranslateX:value];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSCoordSysTransParameter",@"setTranslateX expection",nil);
    }
}
/**
 * 设置 Y 轴的坐标偏移量
 * @param coordSysTransParameterId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setTranslateY,setTranslateY:(NSString*)coordSysTransParamId value:(double)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CoordSysTransParameter *param = [JSObjManager getObjWithKey:coordSysTransParamId];
        [param setTranslateY:value];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSCoordSysTransParameter",@"setTranslateY expection",nil);
    }
}
/**
 * 设置 Z 轴的坐标偏移量
 * @param coordSysTransParameterId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setTranslateZ,setTranslateZ:(NSString*)coordSysTransParamId value:(double)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CoordSysTransParameter *param = [JSObjManager getObjWithKey:coordSysTransParamId];
        [param setTranslateZ:value];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSCoordSysTransParameter",@"setTranslateZ expection",nil);
    }
}
/**
 * 将该 CoordSysTransParameter 对象输出为 XML 字符串
 * @param coordSysTransParameterId
 * @param promise
 */
RCT_REMAP_METHOD(toXML,toXML:(NSString*)coordSysTransParamId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        CoordSysTransParameter *param = [JSObjManager getObjWithKey:coordSysTransParamId];
        NSString* strXML = [param toXML];
        resolve(strXML);
    } @catch (NSException *exception) {
        reject(@"JSCoordSysTransParameter",@"toXML expection",nil);
    }
}

@end

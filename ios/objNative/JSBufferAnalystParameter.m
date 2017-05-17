//
//  JSBufferAnalystParameter.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/17.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSBufferAnalystParameter.h"

#import "SuperMap/BufferAnalystParameter.h"
#import "JSObjManager.h"
@implementation JSBufferAnalystParameter
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj,createObjWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BufferAnalystParameter* para = [[BufferAnalystParameter alloc]init];
        NSInteger key = (NSInteger)para;
        [JSObjManager addObj:para];
        resolve(@{@"bufferAnalystParameterId":@(key).stringValue});
    } @catch (NSException *exception) {
        reject(@"BufferAnalystParameter",@"create object exception",nil);
    }
}

RCT_REMAP_METHOD(setEndType,setEndTypeById:(NSString*)paraId endType:(int)endType resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BufferAnalystParameter* para = [JSObjManager getObjWithKey:paraId];
        para.bufferEndType = endType;
        resolve(@"endType setted");
    } @catch (NSException *exception) {
        reject(@"BufferAnalystParameter",@"set EndType exception",nil);
    }
}

RCT_REMAP_METHOD(getEndType,getEndTypeById:(NSString*)paraId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BufferAnalystParameter* para = [JSObjManager getObjWithKey:paraId];
        int endType = para.bufferEndType;
        NSNumber* typeNum = [NSNumber numberWithInt:endType];
        resolve(@{@"EndType":typeNum});
    } @catch (NSException *exception) {
        reject(@"BufferAnalystParameter",@"get EndType exception",nil);
    }
}

RCT_REMAP_METHOD(setLeftDistance,setLeftDistanceById:(NSString*)paraId distance:(NSString*)distance resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BufferAnalystParameter* para = [JSObjManager getObjWithKey:paraId];
        para.leftDistance = distance;
        resolve(@"left Distance setted");
    } @catch (NSException *exception) {
        reject(@"BufferAnalystParameter",@"set left Distance exception",nil);
    }
}

RCT_REMAP_METHOD(getLeftDistance,getLeftDistanceById:(NSString*)paraId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BufferAnalystParameter* para = [JSObjManager getObjWithKey:paraId];
        NSString* distance = para.leftDistance;
        resolve(@{@"leftDistance":distance});
    } @catch (NSException *exception) {
        reject(@"BufferAnalystParameter",@"get left Distance exception",nil);
    }
}

RCT_REMAP_METHOD(setRightDistance,setRightDistanceById:(NSString*)paraId distance:(NSString*)distance resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BufferAnalystParameter* para = [JSObjManager getObjWithKey:paraId];
        para.rightDistance = distance;
        resolve(@"right Distance setted");
    } @catch (NSException *exception) {
        reject(@"BufferAnalystParameter",@"set right Distance exception",nil);
    }
}

RCT_REMAP_METHOD(getRightDistance,getRightDistanceById:(NSString*)paraId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BufferAnalystParameter* para = [JSObjManager getObjWithKey:paraId];
        NSString* distance = para.rightDistance;
        resolve(@{@"rightDistance":distance});
    } @catch (NSException *exception) {
        reject(@"BufferAnalystParameter",@"get right Distance exception",nil);
    }
}
@end

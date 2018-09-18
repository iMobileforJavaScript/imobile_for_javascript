//
//  JSWeightFieldInfo.m
//  Supermap
//
//  Created by supermap on 2018/8/8.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSWeightFieldInfo.h"
#import "JSObjManager.h"
#import "SuperMap/WeightFieldInfo.h"
@interface JSWeightFieldInfo(){
    WeightFieldInfo* m_WeightFieldInfo;
}
@end
@implementation JSWeightFieldInfo
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(createObj, createObjResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        WeightFieldInfo* weightFieldInfo = [[WeightFieldInfo alloc]init];
        NSInteger weightFieldInfoId = (NSInteger)weightFieldInfo;
        [JSObjManager addObj:weightFieldInfo];
        resolve(@(weightFieldInfoId).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSWeightFieldInfo",@"createObj expection",nil);
    }
}
/**
 * 返回正向权值字段
 * @param weightFieldInfoId
 */
RCT_REMAP_METHOD(getFTWeightField,getFTWeightFieldById:(NSString*)weightFieldInfoId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_WeightFieldInfo = [JSObjManager getObjWithKey:weightFieldInfoId];
        NSString* ftWeightField = m_WeightFieldInfo.ftWeightField;
        resolve(ftWeightField);
    } @catch (NSException *exception) {
        reject(@"JSWeightFieldInfo",@"getFTWeightField expection",nil);
    }
}
/**
 * 返回权值字段信息的名称
 * @param weightFieldInfoId
 */
RCT_REMAP_METHOD(getName,getNameById:(NSString*)weightFieldInfoId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_WeightFieldInfo = [JSObjManager getObjWithKey:weightFieldInfoId];
        NSString* name = m_WeightFieldInfo.name;
        resolve(name);
    } @catch (NSException *exception) {
        reject(@"JSWeightFieldInfo",@"getName expection",nil);
    }
}
/**
 * 返回反向权值字段
 * @param weightFieldInfoId
 */
RCT_REMAP_METHOD(getTFWeightField,getTFWeightFieldById:(NSString*)weightFieldInfoId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_WeightFieldInfo = [JSObjManager getObjWithKey:weightFieldInfoId];
        NSString* tfWeightField = m_WeightFieldInfo.tfWeightField;
        resolve(tfWeightField);
    } @catch (NSException *exception) {
        reject(@"JSWeightFieldInfo",@"getTFWeightField expection",nil);
    }
}
/**
 * 设置正向权值字段
 * @param weightFieldInfoId
 * @param value
 */
RCT_REMAP_METHOD(setFTWeightField, setFTWeightFieldById:(NSString*)weightFieldInfoId value:(NSString*)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_WeightFieldInfo = [JSObjManager getObjWithKey:weightFieldInfoId];
        m_WeightFieldInfo.ftWeightField = value;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSWeightFieldInfo",@"getTFWeightField expection",nil);
    }
}
/**
 * 设置权值字段信息的名称
 * @param weightFieldInfoId
 * @param value
 */
RCT_REMAP_METHOD(setName,setNameById:(NSString*)weightFieldInfoId value:(NSString*)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_WeightFieldInfo = [JSObjManager getObjWithKey:weightFieldInfoId];
        m_WeightFieldInfo.name = value;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSWeightFieldInfo",@"setName expection",nil);
    }
}
/**
 * 设置反向权值字段
 * @param weightFieldInfoId
 * @param value
 */
RCT_REMAP_METHOD(setTFWeightField,setTFWeightFieldById:(NSString*)weightFieldInfoId value:(NSString*)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_WeightFieldInfo = [JSObjManager getObjWithKey:weightFieldInfoId];
        m_WeightFieldInfo.tfWeightField = value;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSWeightFieldInfo",@"setTFWeightField expection",nil);
    }
}
@end

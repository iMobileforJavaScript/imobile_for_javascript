//
//  JSWeightFieldInfos.m
//  Supermap
//
//  Created by supermap on 2018/8/8.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSWeightFieldInfos.h"
#import "JSObjManager.h"
#import "SuperMap/WeightFieldInfos.h"
@interface JSWeightFieldInfos(){
    WeightFieldInfos* m_WeightFieldInfos;
}
@end
@implementation JSWeightFieldInfos
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(createObj, createObjResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        WeightFieldInfos* weightFieldInfos = [[WeightFieldInfos alloc]init];
        NSInteger weightFieldInfosId = (NSInteger)weightFieldInfos;
        [JSObjManager addObj:weightFieldInfos];
        resolve(@(weightFieldInfosId).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSWeightFieldInfos",@"createObj expection",nil);
    }
}
/**
 * 用于在权值字段信息集合中加入一个元素
 * @param weightFieldInfosId
 * @param weightFieldInfoId
 */
RCT_REMAP_METHOD(add,addById:(NSString*)weightFieldInfosId weightFieldInfoId:(NSString*)weightFieldInfoId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_WeightFieldInfos = [JSObjManager getObjWithKey:weightFieldInfosId];
        WeightFieldInfo* weightFieldInfo = [JSObjManager getObjWithKey:weightFieldInfoId];
        [m_WeightFieldInfos add:weightFieldInfo];
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSWeightFieldInfos",@"add expection",nil);
    }
}
/**
 * 用于从权值字段信息集合移除全部权值字段信息对象
 * @param weightFieldInfosId
 * @param promise
 */
RCT_REMAP_METHOD(clear,saddById:(NSString*)weightFieldInfosId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_WeightFieldInfos = [JSObjManager getObjWithKey:weightFieldInfosId];
        m_WeightFieldInfos.clear;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSWeightFieldInfos",@"clear expection",nil);
    }
}
/**
 * 根据 Index 返回权值字段信息集合对象中的权值字段信息对象
 * @param weightFieldInfosId
 * @param index
 */
RCT_REMAP_METHOD(getByIndex,getByIndexById:(NSString*)weightFieldInfosId index:(NSInteger)index resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_WeightFieldInfos = [JSObjManager getObjWithKey:weightFieldInfosId];
        WeightFieldInfo* weightFieldInfo = [m_WeightFieldInfos get:index];
        NSInteger weightFieldInfoId= (NSInteger)weightFieldInfo;
        [JSObjManager addObj:weightFieldInfo];
        resolve(@(weightFieldInfoId).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSWeightFieldInfos",@"getByIndex expection",nil);
    }
}
/**
 * 根据名称返回权值字段信息集合对象中的权值字段信息对象
 * @param weightFieldInfosId
 * @param name
 */
RCT_REMAP_METHOD(getByName,getByNameById:(NSString*)weightFieldInfosId name:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_WeightFieldInfos = [JSObjManager getObjWithKey:weightFieldInfosId];
        WeightFieldInfo* weightFieldInfo = [m_WeightFieldInfos getWithName:name];
        NSInteger weightFieldInfoId= (NSInteger)weightFieldInfo;
        [JSObjManager addObj:weightFieldInfo];
        resolve(@(weightFieldInfoId).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSWeightFieldInfos",@"getByName expection",nil);
    }
}
/**
 * 返回给定的权值字段信息集合中元素的总数
 * @param weightFieldInfosId
 */
RCT_REMAP_METHOD(getCount,getCountById:(NSString*)weightFieldInfosId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_WeightFieldInfos = [JSObjManager getObjWithKey:weightFieldInfosId];
        int count = (int)m_WeightFieldInfos.getCount;
        resolve(@(count));
    } @catch (NSException *exception) {
        reject(@"JSWeightFieldInfos",@"getCount expection",nil);
    }
}
/**
 * 根据指定的名称，返回权值字段信息对象的序号
 * @param weightFieldInfosId
 * @param name
 */
RCT_REMAP_METHOD(indexOf,indexOfById:(NSString*)weightFieldInfosId name:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_WeightFieldInfos = [JSObjManager getObjWithKey:weightFieldInfosId];
        int count =(int)[m_WeightFieldInfos indexOf:name];
        resolve(@(count));
    } @catch (NSException *exception) {
        reject(@"JSWeightFieldInfos",@"indexOf expection",nil);
    }
}
/**
 * 用于从权值字段信息集合移除指定序号的权值字段信息对象
 * @param weightFieldInfosId
 * @param index
 */
RCT_REMAP_METHOD(removeByIndex,removeByIndexById:(NSString*)weightFieldInfosId index:(NSInteger)index resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_WeightFieldInfos = [JSObjManager getObjWithKey:weightFieldInfosId];
        BOOL result =[m_WeightFieldInfos removeAt:index];
        NSNumber* number = [NSNumber numberWithBool:result];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSWeightFieldInfos",@"removeByIndex expection",nil);
    }
}
/**
 * 从权值字段信息集合中移除指定名称的项
 * @param weightFieldInfosId
 * @param name
 */
RCT_REMAP_METHOD(removeByName,removeByNameById:(NSString*)weightFieldInfosId name:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_WeightFieldInfos = [JSObjManager getObjWithKey:weightFieldInfosId];
        BOOL result =[m_WeightFieldInfos removeWithName:name];
        NSNumber* number = [NSNumber numberWithBool:result];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSWeightFieldInfos",@"add expection",nil);
    }
}
@end

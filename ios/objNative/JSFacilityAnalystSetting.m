//
//  JSFacilityAnalystSetting.m
//  Supermap
//
//  Created by supermap on 2018/8/8.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSFacilityAnalystSetting.h"
#import "JSObjManager.h"
#import "SuperMap/FacilityAnalystSetting.h"
@interface JSFacilityAnalystSetting(){
    FacilityAnalystSetting* m_FacilityAnalystSetting;
}
@end
@implementation JSFacilityAnalystSetting
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(createObj, createObjResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        FacilityAnalystSetting* facilityAnalystSetting = [[FacilityAnalystSetting alloc]init];
        NSInteger facilityAnalystSettingId = (NSInteger)facilityAnalystSetting;
        [JSObjManager addObj:facilityAnalystSetting];
        resolve(@(facilityAnalystSettingId).stringValue);    
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalystSetting",@"createObj expection",nil);
    }
}
/**
 * 返回障碍弧段的 ID 列表
 * @param facilityAnalystSettingId
 */
RCT_REMAP_METHOD(getBarrierEdges,getBarrierEdgesById:(NSString*)facilityAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalystSetting = [JSObjManager getObjWithKey:facilityAnalystSettingId];
        NSMutableArray * ids = m_FacilityAnalystSetting.barrierEdges;
        resolve(ids);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalystSetting",@"getBarrierEdges expection",nil);
    }
}
/**
 * 返回障碍结点的 ID 列表
 * @param facilityAnalystSettingId
 */
RCT_REMAP_METHOD(getBarrierNodes,getBarrierNodesById:(NSString*)facilityAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalystSetting = [JSObjManager getObjWithKey:facilityAnalystSettingId];
        NSMutableArray * ids = m_FacilityAnalystSetting.barrierNodes;
        resolve(ids);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalystSetting",@"getBarrierNodes expection",nil);
    }
}
/**
 * 返回流向字段
 * @param facilityAnalystSettingId
 * @param promise
 */
RCT_REMAP_METHOD(getDirectionField,getDirectionFieldById:(NSString*)facilityAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalystSetting = [JSObjManager getObjWithKey:facilityAnalystSettingId];
        NSString* directionField = m_FacilityAnalystSetting.directionField;
        resolve(directionField);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalystSetting",@"getDirectionField expection",nil);
    }
}
/**
 * 返回网络数据集中标识弧段 ID 的字段
 * @param facilityAnalystSettingId
 */
RCT_REMAP_METHOD(getEdgeIDField,getEdgeIDFieldById:(NSString*)facilityAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalystSetting = [JSObjManager getObjWithKey:facilityAnalystSettingId];
        NSString* edgeIDField = m_FacilityAnalystSetting.edgeIDField;
        resolve(edgeIDField);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalystSetting",@"getEdgeIDField expection",nil);
    }
}
/**
 * 返回网络数据集中标识弧段起始结点 ID 的字段
 * @param facilityAnalystSettingId
 * @param promise
 */
RCT_REMAP_METHOD(getFNodeIDField,getFNodeIDFieldById:(NSString*)facilityAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalystSetting = [JSObjManager getObjWithKey:facilityAnalystSettingId];
        NSString* fNodeIDField = m_FacilityAnalystSetting.fNodeIDField;
        resolve(fNodeIDField);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalystSetting",@"getFNodeIDField expection",nil);
    }
}
/**
 * 返回网络数据集
 * @param facilityAnalystSettingId
 */
RCT_REMAP_METHOD(getNetworkDataset,getNetworkDatasetById:(NSString*)facilityAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalystSetting = [JSObjManager getObjWithKey:facilityAnalystSettingId];
        DatasetVector* datasetVector = m_FacilityAnalystSetting.netWorkDataset;
        NSInteger datasetVectorId = (NSInteger)datasetVector;
        [JSObjManager addObj:datasetVector];
        resolve(@(datasetVectorId).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalystSetting",@"getNetworkDataset expection",nil);
    }
}
/**
 * 返回网络数据集中标识网络结点 ID 的字段
 * @param facilityAnalystSettingId
 */
RCT_REMAP_METHOD(getNodeIDField,getNodeIDFieldById:(NSString*)facilityAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalystSetting = [JSObjManager getObjWithKey:facilityAnalystSettingId];
        NSString* nodeIDField = m_FacilityAnalystSetting.nodeIDField;
        resolve(nodeIDField);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalystSetting",@"getNodeIDField expection",nil);
    }
}
/**
 * 返回网络数据集中标识弧段终止结点 ID 的字段
 * @param facilityAnalystSettingId
 */
RCT_REMAP_METHOD(getTNodeIDField,getTNodeIDFieldById:(NSString*)facilityAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalystSetting = [JSObjManager getObjWithKey:facilityAnalystSettingId];
        NSString* tNodeIDField = m_FacilityAnalystSetting.tNodeIDField;
        resolve(tNodeIDField);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalystSetting",@"getTNodeIDField expection",nil);
    }
}
/**
 * 返回点到弧段的距离容限
 * @param facilityAnalystSettingId
 */
RCT_REMAP_METHOD(getTolerance,getToleranceById:(NSString*)facilityAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalystSetting = [JSObjManager getObjWithKey:facilityAnalystSettingId];
        double tolerance = m_FacilityAnalystSetting.tolerance;
        resolve(@(tolerance));
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalystSetting",@"getTolerance expection",nil);
    }
}
/**
 * 返回权值字段信息集合对象
 * @param facilityAnalystSettingId
 */
RCT_REMAP_METHOD(getWeightFieldInfos,getWeightFieldInfosById:(NSString*)facilityAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalystSetting = [JSObjManager getObjWithKey:facilityAnalystSettingId];
        WeightFieldInfos* weightFieldInfos = m_FacilityAnalystSetting.weightFieldInfos;
        NSInteger weightFieldInfosId= (NSInteger)weightFieldInfos;
        [JSObjManager addObj:weightFieldInfos];
        resolve(@(weightFieldInfosId).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalystSetting",@"getWeightFieldInfos expection",nil);
    }
}
/**
 * 设置障碍弧段的 ID 列表
 * @param facilityAnalystSettingId
 * @param value
 */
RCT_REMAP_METHOD(setBarrierEdges,setBarrierEdgesById:(NSString*)facilityAnalystSettingId value:(NSMutableArray*)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalystSetting = [JSObjManager getObjWithKey:facilityAnalystSettingId];
        m_FacilityAnalystSetting.barrierEdges =value;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalystSetting",@"setBarrierEdges expection",nil);
    }
}
/**
 * 设置障碍结点的 ID 列表
 * @param facilityAnalystSettingId
 * @param value
 */
RCT_REMAP_METHOD(setBarrierNodes,setBarrierNodesById:(NSString*)facilityAnalystSettingId value:(NSMutableArray*)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalystSetting = [JSObjManager getObjWithKey:facilityAnalystSettingId];
        m_FacilityAnalystSetting.barrierNodes =value;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalystSetting",@"checksetBarrierNodesLoops expection",nil);
    }
}
/**
 * 设置流向字段
 * @param facilityAnalystSettingId
 * @param value
 */
RCT_REMAP_METHOD(setDirectionField,setDirectionFieldById:(NSString*)facilityAnalystSettingId value:(NSString*)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalystSetting = [JSObjManager getObjWithKey:facilityAnalystSettingId];
        m_FacilityAnalystSetting.directionField =value;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalystSetting",@"setDirectionField expection",nil);
    }
}
/**
 * 设置网络数据集中标识弧段 ID 的字段
 * @param facilityAnalystSettingId
 * @param value
 */
RCT_REMAP_METHOD(setEdgeIDField,setEdgeIDFieldById:(NSString*)facilityAnalystSettingId value:(NSString*)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalystSetting = [JSObjManager getObjWithKey:facilityAnalystSettingId];
        m_FacilityAnalystSetting.edgeIDField =value;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalystSetting",@"setEdgeIDField expection",nil);
    }
}
/**
 * 设置网络数据集中标识弧段起始结点 ID 的字段
 * @param facilityAnalystSettingId
 */
RCT_REMAP_METHOD(setFNodeIDField,setFNodeIDFieldById:(NSString*)facilityAnalystSettingId value:(NSString*)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalystSetting = [JSObjManager getObjWithKey:facilityAnalystSettingId];
        m_FacilityAnalystSetting.fNodeIDField =value;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalystSetting",@"setFNodeIDField expection",nil);
    }
}
/**
 * 设置网络数据集
 * @param facilityAnalystSettingId
 * @param datasetVectorId
 */
RCT_REMAP_METHOD(setNetworkDataset,setNetworkDatasetById:(NSString*)facilityAnalystSettingId datasetVectorId:(NSString*)datasetVectorId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalystSetting = [JSObjManager getObjWithKey:facilityAnalystSettingId];
        DatasetVector* datasetVector = [JSObjManager getObjWithKey:datasetVectorId];
        m_FacilityAnalystSetting.netWorkDataset=datasetVector;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalystSetting",@"setNetworkDataset expection",nil);
    }
}
/**
 * 设置网络数据集中标识网络结点 ID 的字段
 * @param facilityAnalystSettingId
 * @param value
 */
RCT_REMAP_METHOD(setNodeIDField,setNodeIDFieldById:(NSString*)facilityAnalystSettingId value:(NSString*)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalystSetting = [JSObjManager getObjWithKey:facilityAnalystSettingId];
        m_FacilityAnalystSetting.nodeIDField =value;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalystSetting",@"setNodeIDField expection",nil);
    }
}

/**
 * 设置网络数据集中标识弧段终止结点 ID 的字段
 * @param facilityAnalystSettingId
 * @param value
 */
RCT_REMAP_METHOD(setTNodeIDField,setTNodeIDFieldById:(NSString*)facilityAnalystSettingId value:(NSString*)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalystSetting = [JSObjManager getObjWithKey:facilityAnalystSettingId];
        m_FacilityAnalystSetting.tNodeIDField =value;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalystSetting",@"setTNodeIDField expection",nil);
    }
}
/**
 * 设置点到弧段的距离容限
 * @param facilityAnalystSettingId
 * @param value
 */
RCT_REMAP_METHOD(setTolerance,setToleranceById:(NSString*)facilityAnalystSettingId value:(double)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalystSetting = [JSObjManager getObjWithKey:facilityAnalystSettingId];
        m_FacilityAnalystSetting.tolerance =value;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalystSetting",@"setTolerance expection",nil);
    }
}
/**
 * 设置权值字段信息集合对象。
 * @param facilityAnalystSettingId
 * @param weightFieldInfosId
 */
RCT_REMAP_METHOD(setWeightFieldInfos,setWeightFieldInfosById:(NSString*)facilityAnalystSettingId weightFieldInfosId:(NSString*)weightFieldInfosId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalystSetting = [JSObjManager getObjWithKey:facilityAnalystSettingId];
        WeightFieldInfos* weightFieldInfos =[JSObjManager getObjWithKey:weightFieldInfosId];
        m_FacilityAnalystSetting.weightFieldInfos = weightFieldInfos;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalystSetting",@"setWeightFieldInfos expection",nil);
    }
}
@end

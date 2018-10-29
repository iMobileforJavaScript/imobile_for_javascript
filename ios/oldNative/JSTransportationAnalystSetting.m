//
//  JSTransportationAnalystSetting.m
//  Supermap
//
//  Created by wnmng on 2018/8/8.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSTransportationAnalystSetting.h"
#import "SuperMap/TransportationAnalystSetting.h"
#import "SuperMap/WeightFieldInfos.h"
#import "JSObjManager.h"

@implementation JSTransportationAnalystSetting
RCT_EXPORT_MODULE();

/**
 * 创建对象
 * @param promise
 */
RCT_REMAP_METHOD(createObj,createObj:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* setting = [[TransportationAnalystSetting alloc] init];
        NSInteger nsKey = (NSInteger)setting;
        [JSObjManager addObj:setting];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"createObj expection",nil);
    }
}
/**
 * 返回障碍弧段 ID 列表
 * @param transportationAnalystSettingId
 * @param promise
 */
RCT_REMAP_METHOD(getBarrierEdges,getBarrierEdges:(NSString*)transportationAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        NSArray *edgesArr = [transSetting barrierEdges];
        resolve(edgesArr);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"getBarrierEdges expection",nil);
    }
}
/**
 * 返回障碍结点 ID 列表
 * @param transportationAnalystSettingId
 * @param promise
 */
RCT_REMAP_METHOD(getBarrierNodes,getBarrierNodes:(NSString*)transportationAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        NSArray *nodesArr = [transSetting barrierNodes];
        resolve(nodesArr);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"getBarrierNodes expection",nil);
    }
}
/**
 * 返回交通网络分析中弧段过滤表达式
 * @param transportationAnalystSettingId
 * @param promise
 */
RCT_REMAP_METHOD(getEdgeFilter,getEdgeFilter:(NSString*)transportationAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        NSString *edgeFilter = [transSetting edgeFilter];
        resolve(edgeFilter);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"getEdgeFilter expection",nil);
    }
}
/**
 * 返回网络数据集中标志弧段 ID 的字段
 * @param transportationAnalystSettingId
 * @param promise
 */
RCT_REMAP_METHOD(getEdgeIDField,getEdgeIDField:(NSString*)transportationAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        NSString *edgeIDField = [transSetting edgeIDField];
        resolve(edgeIDField);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"getEdgeIDField expection",nil);
    }
}
/**
 * 返回存储弧段名称的字段
 * @param transportationAnalystSettingId
 * @param promise
 */
RCT_REMAP_METHOD(getEdgeNameField,getEdgeNameField:(NSString*)transportationAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        NSString *edgeNameField = [transSetting edgeNameField];
        resolve(edgeNameField);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"getEdgeNameField expection",nil);
    }
}
/**
 * 返回网络数据集中标志弧段起始结点 ID 的字段
 * @param transportationAnalystSettingId
 * @param promise
 */
RCT_REMAP_METHOD(getFNodeIDField,getFNodeIDField:(NSString*)transportationAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        NSString *fNodeIDField = [transSetting fNodeIDField];
        resolve(fNodeIDField);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"getFNodeIDField expection",nil);
    }
}
/**
 * 返回用于表示正向单行线的字符串的数组
 * @param transportationAnalystSettingId
 * @param promise
 */
RCT_REMAP_METHOD(getFTSingleWayRuleValues,getFTSingleWayRuleValues:(NSString*)transportationAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        NSArray *arr = [transSetting fTSingleWayRuleValues];
        resolve(arr);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"getFTSingleWayRuleValues expection",nil);
    }
}
/**
 * 返回用于分析的网络数据集
 * @param transportationAnalystSettingId
 * @param promise
 */
RCT_REMAP_METHOD( getNetworkDataset, getNetworkDataset:(NSString*)transportationAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        DatasetVector *dataset = [transSetting networkDataset];
        NSInteger nsKey = (NSInteger)dataset;
        [JSObjManager addObj:dataset];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"getFTSingleWayRuleValues expection",nil);
    }
}
/**
 * 返回网络数据集中标识结点 ID 的字段
 * @param transportationAnalystSettingId
 * @param promise
 */
RCT_REMAP_METHOD(getNodeIDField,getNodeIDField:(NSString*)transportationAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        NSString*nodeIDField = [transSetting nodeIDField];
        resolve(nodeIDField);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"getNodeIDField expection",nil);
    }
}
/**
 * 返回存储结点名称的字段的字段名
 * @param transportationAnalystSettingId
 * @param promise
 */
RCT_REMAP_METHOD(getNodeNameField,getNodeNameField:(NSString*)transportationAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        NSString*value = [transSetting nodeNameField];
        resolve(value);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"getNodeIDField expection",nil);
    }
}
/**
 * 返回用于表示禁行线的字符串的数组
 * @param transportationAnalystSettingId
 * @param promise
 */
RCT_REMAP_METHOD(getProhibitedWayRuleValues,getProhibitedWayRuleValues:(NSString*)transportationAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        NSArray* arr = [transSetting prohibitedWayRuleValues];
        resolve(arr);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"getProhibitedWayRuleValues expection",nil);
    }
}
/**
 * 返回网络数据集中表示网络弧段的交通规则的字段
 * @param transportationAnalystSettingId
 * @param promise
 */
RCT_REMAP_METHOD(getRuleField,getRuleField:(NSString*)transportationAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        NSString *value = [transSetting ruleField];
        resolve(value);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"getRuleField expection",nil);
    }
}
/**
 * 返回用于表示逆向单行线的字符串的数组
 * @param transportationAnalystSettingId
 * @param promise
 */
RCT_REMAP_METHOD(getTFSingleWayRuleValues,getTFSingleWayRuleValues:(NSString*)transportationAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        NSArray* arr = [transSetting tFSingleWayRuleValues];
        resolve(arr);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"getTFSingleWayRuleValues expection",nil);
    }
}
/**
 * 设置障碍结点 ID 列表
 * @param transportationAnalystSettingId
 * @param promise
 */
RCT_REMAP_METHOD(getTNodeIDField,getTNodeIDField:(NSString*)transportationAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        NSString *tNodeIDField = [transSetting tNodeIDField];
        resolve(tNodeIDField);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"getTNodeIDField expection",nil);
    }
}
/**
 * 返回转向表数据集
 * @param transportationAnalystSettingId
 * @param promise
 */
RCT_REMAP_METHOD(getTurnDataset, getTurnDataset:(NSString*)transportationAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        DatasetVector *dataset = [transSetting turnDataset];
        NSInteger nsKey = (NSInteger)dataset;
        [JSObjManager addObj:dataset];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"getTurnDataset expection",nil);
    }
}
/**
 * 返回转向起始弧段 ID 的字段
 * @param transportationAnalystSettingId
 * @param promise
 */
RCT_REMAP_METHOD(getTurnFEdgeIDField,getTurnFEdgeIDField:(NSString*)transportationAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        NSString *value = [transSetting turnFEdgeIDField];
        resolve(value);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"getTurnFEdgeIDField expection",nil);
    }
}
/**
 * 返回转向结点 ID 的字段
 * @param transportationAnalystSettingId
 * @param promise
 */
RCT_REMAP_METHOD(getTurnNodeIDField,getTurnNodeIDField:(NSString*)transportationAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        NSString *value = [transSetting turnNodeIDField];
        resolve(value);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"getTurnNodeIDField expection",nil);
    }
}
/**
 * 返回转向终止弧段 ID 的字段
 * @param transportationAnalystSettingId
 * @param promise
 */
RCT_REMAP_METHOD(getTurnTEdgeIDField,getTurnTEdgeIDField:(NSString*)transportationAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        NSString *value = [transSetting turnTEdgeIDField];
        resolve(value);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"getTurnTEdgeIDField expection",nil);
    }
}
/**
 * 返回转向权值字段集合
 * @param transportationAnalystSettingId
 * @param promise
 */
RCT_REMAP_METHOD(getTurnWeightFields,getTurnWeightFields:(NSString*)transportationAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        NSString *value = [transSetting turnWeightFields];
        resolve(value);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"getTurnWeightFields expection",nil);
    }
}
/**
 * 返回用于表示双向通行线的字符串的数组
 * @param transportationAnalystSettingId
 * @param promise
 */
RCT_REMAP_METHOD(getTwoWayRuleValues,getTwoWayRuleValues:(NSString*)transportationAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        NSArray *arr = [transSetting twoWayRuleValues];
        resolve(arr);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"getTwoWayRuleValues expection",nil);
    }
}
/**
 * 设置障碍结点 ID 列表
 * @param transportationAnalystSettingId
 * @param promise
 */
RCT_REMAP_METHOD(getWeightFieldInfos,getWeightFieldInfos:(NSString*)transportationAnalystSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        WeightFieldInfos* infos = [transSetting weightFieldInfos];
        NSInteger nsKey = (NSInteger)infos;
        [JSObjManager addObj:infos];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"getWeightFieldInfos expection",nil);
    }
}
/**
 * 设置障碍弧段的 ID 列表
 * @param transportationAnalystSettingId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setBarrierEdges,setBarrierEdges:(NSString*)transportationAnalystSettingId edges:(NSArray*)edgesArr resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        NSMutableArray *arrM = [[NSMutableArray alloc]initWithArray:edgesArr];
        [transSetting setBarrierEdges:arrM];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"setBarrierEdges expection",nil);
    }
}
/**
 * 设置障碍结点的 ID 列表
 * @param transportationAnalystSettingId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setBarrierNodes,setBarrierNodes:(NSString*)transportationAnalystSettingId nodes:(NSArray*)nodesArr resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        NSMutableArray *arrM = [[NSMutableArray alloc]initWithArray:nodesArr];
        [transSetting setBarrierNodes:arrM];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"setBarrierNodes expection",nil);
    }
}
/**
 * 设置交通网络分析中弧段过滤表达式
 * @param transportationAnalystSettingId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setEdgeFilter,setEdgeFilter:(NSString*)transportationAnalystSettingId filter:(NSString*)edgeFilter resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        [transSetting setEdgeFilter:edgeFilter];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"setEdgeFilter expection",nil);
    }
}
/**
 * 设置网络数据集中标志弧段 ID 的字段
 * @param transportationAnalystSettingId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setEdgeIDField,setEdgeIDField:(NSString*)transportationAnalystSettingId filterID:(NSString*)edgeFilterID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        [transSetting setEdgeIDField:edgeFilterID];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"setEdgeIDField expection",nil);
    }
}
/**
 * 设置存储弧段名称的字段
 * @param transportationAnalystSettingId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setEdgeNameField,setEdgeNameField:(NSString*)transportationAnalystSettingId filterName:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        [transSetting setEdgeNameField:name];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"setEdgeNameField expection",nil);
    }
}
/**
 * 设置网络数据集中标志弧段起始结点 ID 的字段
 * @param transportationAnalystSettingId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setFNodeIDField,setFNodeIDField:(NSString*)transportationAnalystSettingId nodeID:(NSString*)nodeID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        [transSetting setFNodeIDField:nodeID];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"setFNodeIDField expection",nil);
    }
}
/**
 * 设置用于表示正向单行线的字符串的数组
 * @param transportationAnalystSettingId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setFTSingleWayRuleValues,setFTSingleWayRuleValues:(NSString*)transportationAnalystSettingId value:(NSArray*)valueArr resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        NSMutableArray *arrM = [[NSMutableArray alloc]initWithArray:valueArr];
        [transSetting setFTSingleWayRuleValues:arrM];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"setFTSingleWayRuleValues expection",nil);
    }
}
/**
 * 设置用于分析的网络数据集
 * @param transportationAnalystSettingId
 * @param datasetVectorId
 * @param promise
 */
RCT_REMAP_METHOD(setNetworkDataset,setNetworkDataset:(NSString*)transportationAnalystSettingId dataset:(NSString*)datasetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        DatasetVector *dataset = [JSObjManager getObjWithKey:datasetId];
        [transSetting setNetworkDataset:dataset];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"etNetworkDataset expection",nil);
    }
}
/**
 * 设置网络数据集中标识结点 ID 的字段
 * @param transportationAnalystSettingId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setNodeIDField,setNodeIDField:(NSString*)transportationAnalystSettingId nodeID:(NSString*)nodeID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        [transSetting setNodeIDField:nodeID];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"setNodeIDField expection",nil);
    }
}
/**
 * 设置存储结点名称的字段的字段名
 * @param transportationAnalystSettingId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setNodeNameField,setNodeNameField:(NSString*)transportationAnalystSettingId nodeName:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        [transSetting setNodeNameField:name];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"setNodeIDField expection",nil);
    }
}
/**
 * 设置用于表示禁行线的字符串的数组
 * @param transportationAnalystSettingId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setProhibitedWayRuleValues,setProhibitedWayRuleValues:(NSString*)transportationAnalystSettingId value:(NSArray*)valueArr resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        NSMutableArray *arrM = [[NSMutableArray alloc]initWithArray:valueArr];
        [transSetting setProhibitedWayRuleValues:arrM];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"setProhibitedWayRuleValues expection",nil);
    }
}
/**
 * 设置网络数据集中表示网络弧段的交通规则的字段
 * @param transportationAnalystSettingId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setRuleField,setRuleField:(NSString*)transportationAnalystSettingId value:(NSString*)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        [transSetting setRuleField:value];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"setRuleField expection",nil);
    }
}
/**
 * 设置用于表示逆向单行线的字符串的数组
 * @param transportationAnalystSettingId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setTFSingleWayRuleValues,setTFSingleWayRuleValues:(NSString*)transportationAnalystSettingId value:(NSArray*)valueArr resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        NSMutableArray *arrM = [[NSMutableArray alloc]initWithArray:valueArr];
        [transSetting setTFSingleWayRuleValues:arrM];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"setTFSingleWayRuleValues expection",nil);
    }
}
/**
 * 设置网络数据集中标志弧段终止结点 ID 的字段
 * @param transportationAnalystSettingId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setTNodeIDField,setTNodeIDField:(NSString*)transportationAnalystSettingId nodeID:(NSString*)nodeID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        [transSetting setTNodeIDField:nodeID];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"setTNodeIDField expection",nil);
    }
}
/**
 * 设置点到弧段的距离容限
 * @param transportationAnalystSettingId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setTolerance,setTolerance:(NSString*)transportationAnalystSettingId tolerance:(double)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        [transSetting setTolerance:value];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"setTNodeIDField expection",nil);
    }
}
/**
 * 设置转向表数据集
 * @param transportationAnalystSettingId
 * @param datasetVectorId
 * @param promise
 */
RCT_REMAP_METHOD(setTurnDataset,setTurnDataset:(NSString*)transportationAnalystSettingId dataset:(NSString*)datasetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        DatasetVector *dataset = [JSObjManager getObjWithKey:datasetId];
        [transSetting setTurnDataset:dataset];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"setTurnkDataset expection",nil);
    }
}
/**
 * 设置转向起始弧段 ID 的字段
 * @param transportationAnalystSettingId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setTurnFEdgeIDField,setTurnFEdgeIDField:(NSString*)transportationAnalystSettingId edgeID:(NSString*)edgeID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        [transSetting setTurnFEdgeIDField:edgeID];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"setTurnFEdgeIDField expection",nil);
    }
}
/**
 * 设置转向结点 ID 的字段
 * @param transportationAnalystSettingId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setTurnNodeIDField,setTurnNodeIDField:(NSString*)transportationAnalystSettingId nodeID:(NSString*)nodeID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        [transSetting setTurnNodeIDField:nodeID];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"setTurnNodeIDField expection",nil);
    }
}

/**
 * 设置转向终止弧段 ID 的字段
 * @param transportationAnalystSettingId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setTurnTEdgeIDField,setTurnTEdgeIDField:(NSString*)transportationAnalystSettingId edgeID:(NSString*)edgeID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        [transSetting setTurnTEdgeIDField:edgeID];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"setTurnTEdgeIDField expection",nil);
    }
}
/**
 * 设置转向权值字段集合
 * @param transportationAnalystSettingId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setTurnWeightFields,setTurnWeightFields:(NSString*)transportationAnalystSettingId weightField:(NSArray*)valueArr resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        NSMutableArray *arrM = [[NSMutableArray alloc]initWithArray:valueArr];
        [transSetting setTurnWeightFields:arrM];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"setTurnWeightFields expection",nil);
    }
}
/**
 * 设置用于表示双向通行线的字符串的数组
 * @param transportationAnalystSettingId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setTwoWayRuleValues,setTwoWayRuleValues:(NSString*)transportationAnalystSettingId values:(NSArray*)valueArr resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        NSMutableArray *arrM = [[NSMutableArray alloc]initWithArray:valueArr];
        [transSetting setTwoWayRuleValues:arrM];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"setTwoWayRuleValues expection",nil);
    }
}
/**
 * 设置权值字段信息集合对象
 * @param transportationAnalystSettingId
 * @param weightFieldInfosId
 * @param promise
 */
RCT_REMAP_METHOD(setWeightFieldInfos,setWeightFieldInfos:(NSString*)transportationAnalystSettingId infos:(NSString*)weightFieldInfosId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystSetting* transSetting = [JSObjManager getObjWithKey:transportationAnalystSettingId];
        WeightFieldInfos* infos = [JSObjManager getObjWithKey:weightFieldInfosId];
        [transSetting setWeightFieldInfos:infos];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystSetting",@"setTwoWayRuleValues expection",nil);
    }
}



@end

//
//  JSTransportationAnalyst.m
//  Supermap
//
//  Created by wnmng on 2018/8/8.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSTransportationAnalyst.h"
#import "SuperMap/TransportationAnalyst.h"
#import "SuperMap/TransportationAnalystParameter.h"
#import "SuperMap/TransportationAnalystResult.h"
#import "SuperMap/GeoLineM.h"
#import "JSObjManager.h"
#import "JsonUtil.h"

@implementation JSTransportationAnalyst
RCT_EXPORT_MODULE();

/**
 * 创建对象
 * @param promise
 */
RCT_REMAP_METHOD(createObj,createObj:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalyst* transportationAnalyst = [[TransportationAnalyst alloc] init];
        NSInteger nsKey = (NSInteger)transportationAnalyst;
        [JSObjManager addObj:transportationAnalyst];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalyst",@"createObj expection",nil);
    }
}
/**
 * 释放此对象所占用的资源
 * @param transportationAnalystId
 * @param promise
 */
RCT_REMAP_METHOD(dispose,dispose:(NSString*)transportationAnalystId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalyst* transportationAnalyst =  [JSObjManager getObjWithKey:transportationAnalystId];
        [transportationAnalyst dispose];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalyst",@"dispose expection",nil);
    }
}
/**
 * 创建内存文件
 * @param transportationAnalystId
 * @param path
 * @param promise
 */
RCT_REMAP_METHOD(createModel,createModel:(NSString*)transportationAnalystId path:(NSString*)strPath resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalyst* transportationAnalyst =  [JSObjManager getObjWithKey:transportationAnalystId];
        //接口缺失createModel
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalyst",@"createModel expection",nil);
    }
}
/**
 * 根据指定的参数进行最近设施查找分析，事件点为结点 ID
 * @param transportationAnalystId
 * @param parameterId
 * @param eventID
 * @param facilityCount
 * @param isFromEvent
 * @param maxWeight
 * @param promise
 */
RCT_REMAP_METHOD(findClosestFacilityByNode,findClosestFacilityByNode:(NSString*)transportationAnalystId param:(NSString*)parameterId event:(int)eventID facilityCount:(int)nFacilityCount isFromEvent:(BOOL)bFromEvent maxWeight:(double)dMaxWeight resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalyst* transportationAnalyst =  [JSObjManager getObjWithKey:transportationAnalystId];
        TransportationAnalystParameter* transportationAnalystParam = [JSObjManager getObjWithKey:parameterId];
        TransportationAnalystResult* result = [transportationAnalyst findClosestFacility:transportationAnalystParam eventID:eventID facilityCount:nFacilityCount isFromEvent:bFromEvent maxWeight:dMaxWeight];
        NSDictionary *resDic = [JsonUtil transportationResultToMap:result];
        resolve(resDic);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalyst",@"findClosestFacilityByNode expection",nil);
    }
}
/**
 * 根据指定的参数进行最近设施查找分析，事件点为坐标点
 * @param transportationAnalystId
 * @param parameterId
 * @param point2DId
 * @param facilityCount
 * @param isFromEvent
 * @param maxWeight
 * @param promise
 */
RCT_REMAP_METHOD(findClosestFacilityByPoint2D,findClosestFacilityByPoint2D:(NSString*)transportationAnalystId param:(NSString*)parameterId point:(NSString*)point2DId facilityCount:(int)nFacilityCount isFromEvent:(BOOL)bFromEvent maxWeight:(double)dMaxWeight resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalyst* transportationAnalyst =  [JSObjManager getObjWithKey:transportationAnalystId];
        TransportationAnalystParameter* transportationAnalystParam = [JSObjManager getObjWithKey:parameterId];
        Point2D *pnt = [JSObjManager getObjWithKey:point2DId];
        TransportationAnalystResult* result = [transportationAnalyst findClosestFacility:transportationAnalystParam eventPoint:pnt facilityCount:nFacilityCount isFromEvent:bFromEvent maxWeight:dMaxWeight];
        NSDictionary *resDic = [JsonUtil transportationResultToMap:result];
        resolve(resDic);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalyst",@"findClosestFacilityByPoint2D expection",nil);
    }
}
/**
 * 根据给定的参数进行选址分区分析
 * @param transportationAnalystId
 * @param parameterId  LocationAnalystParameter
 * @param promise
 */
RCT_REMAP_METHOD( findLocation, findLocation:(NSString*)transportationAnalystId param:(NSString*)parameterId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalyst* transportationAnalyst =  [JSObjManager getObjWithKey:transportationAnalystId];
        TransportationAnalystParameter* transportationAnalystParam = [JSObjManager getObjWithKey:parameterId];
        // 接口缺失 findLocation locationResultToMap
        TransportationAnalystResult* result = [[TransportationAnalystResult alloc]init];
        NSDictionary *resDic = [JsonUtil transportationResultToMap:result];
        resolve(resDic);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalyst",@"findLocation expection",nil);
    }
}
/**
 * 多旅行商（物流配送）分析，配送中心为结点 ID 数组
 * @param transportationAnalystId
 * @param parameterId
 * @param centerNodes
 * @param hasLeastTotalCost
 * @param promise
 */
RCT_REMAP_METHOD( findMTSPPathByNodes, findMTSPPathByNodes:(NSString*)transportationAnalystId param:(NSString*)parameterId centerNodes:(NSArray*)arrNodes hasLeastTotalCost:(BOOL)bHasLeastTotalCost resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalyst* transportationAnalyst =  [JSObjManager getObjWithKey:transportationAnalystId];
        TransportationAnalystParameter* transportationAnalystParam = [JSObjManager getObjWithKey:parameterId];
        NSMutableArray *arrCenterNodes = [[NSMutableArray alloc]initWithArray:arrNodes];
        TransportationAnalystResult* result = [transportationAnalyst findMTSPPath:transportationAnalystParam centerNodes:arrCenterNodes hasLeastTotalCost:bHasLeastTotalCost];
        NSDictionary *resDic = [JsonUtil transportationResultToMap:result];
        resolve(resDic);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalyst",@"findMTSPPathByNodes expection",nil);
    }
}
/**
 * 多旅行商（物流配送）分析，配送中心为点坐标串
 * @param transportationAnalystId
 * @param parameterId
 * @param centerPoints
 * @param hasLeastTotalCost
 * @param promise
 */
RCT_REMAP_METHOD(findMTSPPathByPoint2Ds, findMTSPPathByPoint2Ds:(NSString*)transportationAnalystId param:(NSString*)parameterId centerPoints:(NSArray*)arrPntJson hasLeastTotalCost:(BOOL)bHasLeastTotalCost resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalyst* transportationAnalyst =  [JSObjManager getObjWithKey:transportationAnalystId];
        TransportationAnalystParameter* transportationAnalystParam = [JSObjManager getObjWithKey:parameterId];
        Point2Ds* pnt2ds = [JsonUtil jsonToPoint2Ds:arrPntJson];
        TransportationAnalystResult* result = [transportationAnalyst findMTSPPath:transportationAnalystParam centerPoints:pnt2ds hasLeastTotalCost:bHasLeastTotalCost];
        NSDictionary *resDic = [JsonUtil transportationResultToMap:result];
        resolve(resDic);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalyst",@"findMTSPPathByPoint2Ds expection",nil);
    }
}
/**
 * 最佳路径分析
 * @param transportationAnalystId
 * @param parameterId
 * @param hasLeastTotalCost
 * @param promise
 */
RCT_REMAP_METHOD(findPath, findPath:(NSString*)transportationAnalystId param:(NSString*)parameterId hasLeastTotalCost:(BOOL)bHasLeastTotalCost resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalyst* transportationAnalyst =  [JSObjManager getObjWithKey:transportationAnalystId];
        TransportationAnalystParameter* transportationAnalystParam = [JSObjManager getObjWithKey:parameterId];
        TransportationAnalystResult* result = [transportationAnalyst findPath:transportationAnalystParam hasLeastEdgeCount:bHasLeastTotalCost];
        NSDictionary *resDic = [JsonUtil transportationResultToMap:result];
        resolve(resDic);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalyst", exception.reason, nil);
    }
}
/**
 * 服务区分析
 * @param transportationAnalystId
 * @param parameterId
 * @param weights
 * @param isFromCenter
 * @param isCenterMutuallyExclusive
 * @param promise
 */
RCT_REMAP_METHOD(findServiceArea, findServiceArea:(NSString*)transportationAnalystId param:(NSString*)parameterId weights:(NSArray*)arrWeights fromCenter:(BOOL)bFromCenter centerMutuallyExclusive:(BOOL)bCenterMutuallyExclusive resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalyst* transportationAnalyst =  [JSObjManager getObjWithKey:transportationAnalystId];
        TransportationAnalystParameter* transportationAnalystParam = [JSObjManager getObjWithKey:parameterId];
        NSMutableArray *arrMWeights = [[NSMutableArray alloc]initWithArray:arrWeights];
        TransportationAnalystResult* result = [transportationAnalyst findServiceArea:transportationAnalystParam weights:arrMWeights isFromCenter:bFromCenter isCenterMutuallyExclusive:bCenterMutuallyExclusive];
        NSDictionary *resDic = [JsonUtil transportationResultToMap:result];
        resolve(resDic);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalyst",@"findServiceArea expection",nil);
    }
}
/**
 * 返回交通网络分析环境设置对象
 * @param transportationAnalystId
 * @param promise
 */
RCT_REMAP_METHOD( getAnalystSetting, getAnalystSetting:(NSString*)transportationAnalystId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalyst* transportationAnalyst =  [JSObjManager getObjWithKey:transportationAnalystId];
        TransportationAnalystSetting* setting = [transportationAnalyst analystSetting];
        NSInteger nsKey = (NSInteger)setting;
        [JSObjManager addObj:setting];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalyst",@"getAnalystSetting expection",nil);
    }
}
/**
 * 加载网络模型
 * @param transportationAnalystId
 * @param promise
 */
RCT_REMAP_METHOD(load, load:(NSString*)transportationAnalystId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalyst* transportationAnalyst =  [JSObjManager getObjWithKey:transportationAnalystId];
        BOOL bResult = [transportationAnalyst load];
        resolve([NSNumber numberWithBool:bResult]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalyst",@"load expection",nil);
    }
}
/**
 * 加载内存文件
 * @param transportationAnalystId
 * @param filePath
 * @param networkDatasetId
 * @param promise
 */
RCT_REMAP_METHOD(loadModel,loadModel:(NSString*)transportationAnalystId file:(NSString*)filePath dataset:(NSString*)networkDatasetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalyst* transportationAnalyst =  [JSObjManager getObjWithKey:transportationAnalystId];
        //接口缺失
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalyst",@"loadModel expection",nil);
    }
}
/**
 * 设置交通网络分析环境设置对象
 * @param transportationAnalystId
 * @param settingId
 * @param promise
 */
RCT_REMAP_METHOD(setAnalystSetting,setAnalystSetting:(NSString*)transportationAnalystId setting:(NSString*)settingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalyst* transportationAnalyst =  [JSObjManager getObjWithKey:transportationAnalystId];
        TransportationAnalystSetting* setting = [JSObjManager getObjWithKey:settingId];
        [transportationAnalyst setAnalystSetting:setting];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalyst",@"setAnalystSetting expection",nil);
    }
}
/**
 * 该方法用来更新弧段的权值
 * @param transportationAnalystId
 * @param edgeID
 * @param fromNodeID
 * @param toNodeID
 * @param weightName
 * @param weight
 * @param promise
 */
RCT_REMAP_METHOD(updateEdgeWeight,updateEdgeWeight:(NSString*)transportationAnalystId edge:(int)edgeID fromNode:(int) fromNodeID toNode:(int)toNodeID weightName:(NSString*)weightName  weightValue:(double)weightValue resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalyst* transportationAnalyst =  [JSObjManager getObjWithKey:transportationAnalystId];
        [transportationAnalyst updateEdgeWeight:edgeID fromNodeID:fromNodeID toNodeID:toNodeID weightName:weightName weight:weightValue];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalyst",@"updateEdgeWeight expection",nil);
    }
}
/**
 * 该方法用来更新转向结点的权值
 * @param transportationAnalystId
 * @param nodeID
 * @param fromEdgeID
 * @param toEdgeID
 * @param weightName
 * @param weight
 * @param promise
 */
RCT_REMAP_METHOD(updateTurnNodeWeight,updateTurnNodeWeight:(NSString*)transportationAnalystId node:(int)nodeID fromEdge:(int)fromEdgeID toEdge:(int)toEdgeID weightName:(NSString*)weightName  weightValue:(double)weightValue resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalyst* transportationAnalyst =  [JSObjManager getObjWithKey:transportationAnalystId];
        [transportationAnalyst updateTurnNodeWeight:nodeID fromEdgeID:fromEdgeID toEdgeID:toEdgeID turnWeightField:weightName weight:weightValue];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalyst",@"updateTurnNodeWeight expection",nil);
    }
}
                  

@end

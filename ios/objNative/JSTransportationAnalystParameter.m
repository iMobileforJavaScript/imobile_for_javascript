//
//  JSTransportationAnalystParameter.m
//  Supermap
//
//  Created by wnmng on 2018/8/8.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSTransportationAnalystParameter.h"
#import "SuperMap/TransportationAnalystParameter.h"
#import "JsonUtil.h"
#import "JSObjManager.h"

@implementation JSTransportationAnalystParameter
RCT_EXPORT_MODULE();

/**
 * 创建对象
 * @param promise
 */
RCT_REMAP_METHOD(createObj,createObj:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystParameter* transParame = [[TransportationAnalystParameter alloc] init];
        NSInteger nsKey = (NSInteger)transParame;
        [JSObjManager addObj:transParame];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystParameter",@"createObj expection",nil);
    }
}

/**
 * 返回障碍弧段 ID 列表
 * @param transportationAnalystParameterId
 * @param promise
 */
RCT_REMAP_METHOD(getBarrierEdges,getBarrierEdges:(NSString*)transportationAnalystParameterId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystParameter* transParame = [JSObjManager getObjWithKey:transportationAnalystParameterId];
        NSArray *edgesArr = [transParame barrierEdges];
        resolve(edgesArr);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystParameter",@"getBarrierEdges expection",nil);
    }
}

/**
 * 返回障碍结点 ID 列表
 * @param transportationAnalystParameterId
 * @param promise
 */
RCT_REMAP_METHOD(getBarrierPoints,getBarrierPoints:(NSString*)transportationAnalystParameterId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystParameter* transParame = [JSObjManager getObjWithKey:transportationAnalystParameterId];
        Point2Ds *pnt2ds = [transParame barrierPoints];
        NSArray *pntsArr = [JsonUtil point2DsToJson:pnt2ds];
        resolve(pntsArr);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystParameter",@"getBarrierPoints expection",nil);
    }
}

/**
 * 返回分析时途经结点 ID 的集合
 * @param transportationAnalystParameterId
 * @param promise
 */
RCT_REMAP_METHOD(getNodes,getNodes:(NSString*)transportationAnalystParameterId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystParameter* transParame = [JSObjManager getObjWithKey:transportationAnalystParameterId];
        NSArray *notesArr = [transParame nodes];
        resolve(notesArr);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystParameter",@"getNodes expection",nil);
    }
}

/**
 * 返回分析时途经点的集合
 * @param transportationAnalystParameterId
 * @param promise
 */
RCT_REMAP_METHOD(getPoints,getPoints:(NSString*)transportationAnalystParameterId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystParameter* transParame = [JSObjManager getObjWithKey:transportationAnalystParameterId];
        Point2Ds *pnts = [transParame points];
        NSArray *jsonArr = [JsonUtil point2DsToJson:pnts];
        resolve(jsonArr);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystParameter",@"getPoints expection",nil);
    }
}
/**
 * 返回转向权值字段
 * @param transportationAnalystParameterId
 * @param promise
 */
RCT_REMAP_METHOD(getTurnWeightField,getTurnWeightField:(NSString*)transportationAnalystParameterId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystParameter* transParame = [JSObjManager getObjWithKey:transportationAnalystParameterId];
        NSString* str = [transParame turnWeightField];
        resolve(str);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystParameter",@"getTurnWeightField expection",nil);
    }
}
/**
 * 返回权值字段信息的名称
 * @param transportationAnalystParameterId
 * @param promise
 */
RCT_REMAP_METHOD(getWeightName,getWeightName:(NSString*)transportationAnalystParameterId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystParameter* transParame = [JSObjManager getObjWithKey:transportationAnalystParameterId];
        NSString* str = [transParame weightName];
        resolve(str);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystParameter",@"getWeightName expection",nil);
    }
}
/**
 * 返回分析结果中是否包含途经弧段集合
 * @param transportationAnalystParameterId
 * @param promise
 */
RCT_REMAP_METHOD(isEdgesReturn,isEdgesReturn:(NSString*)transportationAnalystParameterId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystParameter* transParame = [JSObjManager getObjWithKey:transportationAnalystParameterId];
        BOOL bEdgesReturn = [transParame isEdgesReturn];
        resolve([NSNumber numberWithBool:bEdgesReturn]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystParameter",@"isEdgesReturn expection",nil);
    }
}
/**
 * 返回分析结果中是否包含途经结点的集合
 * @param transportationAnalystParameterId
 * @param promise
 */
RCT_REMAP_METHOD(isNodesReturn,isNodesReturn:(NSString*)transportationAnalystParameterId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystParameter* transParame = [JSObjManager getObjWithKey:transportationAnalystParameterId];
        BOOL bNodesReturn = [transParame isNodesReturn];
        resolve([NSNumber numberWithBool:bNodesReturn]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystParameter",@"isNodesReturn expection",nil);
    }
}
/**
 * 返回分析结果中是否包含行驶导引集合
 * @param transportationAnalystParameterId
 * @param promise
 */
RCT_REMAP_METHOD(isPathGuidesReturn,isPathGuidesReturn:(NSString*)transportationAnalystParameterId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystParameter* transParame = [JSObjManager getObjWithKey:transportationAnalystParameterId];
        BOOL bPathGuidesReturn = [transParame isPathGuidesReturn];
        resolve([NSNumber numberWithBool:bPathGuidesReturn]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystParameter",@"isPathGuidesReturn expection",nil);
    }
}
/**
 * 返回分析结果中是否包含路由（GeoLineM）对象的集合
 * @param transportationAnalystParameterId
 * @param promise
 */
RCT_REMAP_METHOD(isRoutesReturn,isRoutesReturn:(NSString*)transportationAnalystParameterId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystParameter* transParame = [JSObjManager getObjWithKey:transportationAnalystParameterId];
        BOOL bRoutesReturn = [transParame isRoutesReturn];
        resolve([NSNumber numberWithBool:bRoutesReturn]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystParameter",@"isRoutesReturn expection",nil);
    }
}
/**
 * 返回分析结果中是否要包含站点索引的集合
 * @param transportationAnalystParameterId
 * @param promise
 */
RCT_REMAP_METHOD(isStopIndexesReturn,isStopIndexesReturn:(NSString*)transportationAnalystParameterId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystParameter* transParame = [JSObjManager getObjWithKey:transportationAnalystParameterId];
        BOOL bStopReturn = [transParame isStopsReturn];
        resolve([NSNumber numberWithBool:bStopReturn]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystParameter",@"isStopIndexesReturn expection",nil);
    }
}
/**
 * 设置障碍弧段 ID 列表
 * @param transportationAnalystParameterId
 * @param arr
 * @param promise
 */
RCT_REMAP_METHOD(setBarrierNodes,setBarrierNodes:(NSString*)transportationAnalystParameterId nodes:(NSArray*)arr resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystParameter* transParame = [JSObjManager getObjWithKey:transportationAnalystParameterId];
        NSMutableArray *arrM = [[NSMutableArray alloc] initWithArray:arr];
        [transParame setNodes:arrM];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystParameter",@"setBarrierNodes expection",nil);
    }
}
/**
 * 设置障碍结点的坐标列表
 * @param transportationAnalystParameterId
 * @param points2DsJson
 * @param promise
 */
RCT_REMAP_METHOD(setBarrierPoints,setBarrierPoints:(NSString*)transportationAnalystParameterId points:(NSArray*)arr resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystParameter* transParame = [JSObjManager getObjWithKey:transportationAnalystParameterId];
        Point2Ds *pnts = [JsonUtil jsonToPoint2Ds:arr];
        [transParame setBarrierPoints:pnts];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystParameter",@"setBarrierPoints expection",nil);
    }
}
/**
 * 设置分析结果中是否包含途经弧段的集合
 * @param transportationAnalystParameterId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setEdgesReturn,setEdgesReturn:(NSString*)transportationAnalystParameterId value:(BOOL)bReturn resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystParameter* transParame = [JSObjManager getObjWithKey:transportationAnalystParameterId];
        [transParame setIsEdgesReturn:bReturn];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystParameter",@"setEdgesReturn expection",nil);
    }
}
/**
 * 设置分析时途经结点 ID 的集合
 * @param transportationAnalystParameterId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setNodes,setNodes:(NSString*)transportationAnalystParameterId nodes:(NSArray*)arr resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystParameter* transParame = [JSObjManager getObjWithKey:transportationAnalystParameterId];
        NSMutableArray *arrM = [[NSMutableArray alloc]initWithArray:arr];
        [transParame setNodes:arrM];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystParameter",@"setNodes expection",nil);
    }
}
/**
 * 设置分析结果中是否包含结点的集合
 * @param transportationAnalystParameterId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setNodesReturn,setNodesReturn:(NSString*)transportationAnalystParameterId value:(BOOL)bReturn resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystParameter* transParame = [JSObjManager getObjWithKey:transportationAnalystParameterId];
        [transParame setIsNodesReturn:bReturn];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystParameter",@"setNodesReturn expection",nil);
    }
}
/**
 * 设置分析结果中是否包含行驶导引集合
 * @param transportationAnalystParameterId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setPathGuidesReturn,setPathGuidesReturn:(NSString*)transportationAnalystParameterId value:(BOOL)bReturn resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystParameter* transParame = [JSObjManager getObjWithKey:transportationAnalystParameterId];
        [transParame setIsPathGuidesReturn:bReturn];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystParameter",@"setPathGuidesReturn expection",nil);
    }
}
/**
 * 设置分析结果中是否包含路由（GeoLineM）对象的集合。
 * @param transportationAnalystParameterId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setRoutesReturn,setRoutesReturn:(NSString*)transportationAnalystParameterId value:(BOOL)bReturn resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystParameter* transParame = [JSObjManager getObjWithKey:transportationAnalystParameterId];
        [transParame setIsRoutesReturn:bReturn];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystParameter",@"setRoutesReturn expection",nil);
    }
}
/**
 * 设置分析结果中是否要包含站点索引的集合
 * @param transportationAnalystParameterId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setStopIndexesReturn,setStopIndexesReturn:(NSString*)transportationAnalystParameterId value:(BOOL)bReturn resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystParameter* transParame = [JSObjManager getObjWithKey:transportationAnalystParameterId];
        [transParame setIsStopsReturn:bReturn];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystParameter",@"setStopIndexesReturn expection",nil);
    }
}
/**
 * 设置分析时途经点的集合
 * @param transportationAnalystParameterId
 * @param points2DsJson
 * @param promise
 */
RCT_REMAP_METHOD(setPoints,setPoints:(NSString*)transportationAnalystParameterId points:(NSArray*)arr resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystParameter* transParame = [JSObjManager getObjWithKey:transportationAnalystParameterId];
        Point2Ds *pnts = [JsonUtil jsonToPoint2Ds:arr];
        [transParame setPoints:pnts];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystParameter",@"setPoints expection",nil);
    }
}
/**
 * 设置转向权值字段
 * @param transportationAnalystParameterId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setTurnWeightField,setTurnWeightField:(NSString*)transportationAnalystParameterId field:(NSString*)strField resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystParameter* transParame = [JSObjManager getObjWithKey:transportationAnalystParameterId];
        [transParame setTurnWeightField:strField];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystParameter",@"setTurnWeightField expection",nil);
    }
}
/**
 * 设置权值字段信息的名称，即交通网络分析环境设置（TransportationAnalystSetting）中的权值字段信息集合（WeightFieldInfos）
 * 中的某一个权值字段信息对象（WeightFieldInfo）的 getName() 方法的返回值
 * @param transportationAnalystParameterId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setWeightName,setWeightName:(NSString*)transportationAnalystParameterId name:(NSString*)strName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TransportationAnalystParameter* transParame = [JSObjManager getObjWithKey:transportationAnalystParameterId];
        [transParame setWeightName:strName];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTransportationAnalystParameter",@"setWeightName expection",nil);
    }
}



@end

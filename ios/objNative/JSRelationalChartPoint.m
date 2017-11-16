//
//  JSRelationalChartPoint.m
//  Supermap
//
//  Created by 王子豪 on 2017/11/14.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSRelationalChartPoint.h"
#import "SuperMap/ChartPoint.h"
#import "JSObjManager.h"
#import "NativeUtil.h"

#import "SuperMap/Point2D.h"
#import "SuperMap/Point2Ds.h"
#import "SuperMap/PrjCoordSys.h"
#import "SuperMap/CoordSysTransParameter.h"
#import "SuperMap/CoordSysTranslator.h"
#import "SuperMap/MapControl.h"
#import "SuperMap/Map.h"
@implementation JSRelationalChartPoint
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj,createObjByWeight:(float)weight pointX:(double)pointX pointY:(double)pointY resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Point2D* point = [[Point2D alloc]initWithX:pointX Y:pointY];
        MapControl*m_mapControl = [JSObjManager getObjWithKey:@"com.supermap.mapControl"];
        //
        if ([m_mapControl.map.prjCoordSys type]!= PCST_EARTH_LONGITUDE_LATITUDE) {//若投影坐标不是经纬度坐标则进行转换
            Point2Ds *points = [[Point2Ds alloc]init];
            [points add:point];
            PrjCoordSys *srcPrjCoorSys = [[PrjCoordSys alloc]init];
            [srcPrjCoorSys setType:PCST_EARTH_LONGITUDE_LATITUDE];
            CoordSysTransParameter *param = [[CoordSysTransParameter alloc]init];
            
            //根据源投影坐标系与目标投影坐标系对坐标点串进行投影转换，结果将直接改变源坐标点串
            [CoordSysTranslator convert:points PrjCoordSys:srcPrjCoorSys PrjCoordSys:[m_mapControl.map prjCoordSys] CoordSysTransParameter:param CoordSysTransMethod:MTH_GEOCENTRIC_TRANSLATION];
            point = [points getItem:0];
        }
        
        RelationalChartPoint* cpoint = [[RelationalChartPoint alloc]initWithPoint:point weight:weight];
        [JSObjManager addObj:cpoint];
        NSInteger cPointKey = (NSInteger)cpoint;
        resolve(@{@"_chartpointId":@(cPointKey).stringValue});
    } @catch (NSException *exception) {
        reject(@"ChartPoint",@"create Object expection",nil);
    }
}

RCT_REMAP_METHOD(createObjByPoint,createObjByWeight:(float)weight pointId:(NSString*)pointId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Point2D* point = [JSObjManager getObjWithKey:pointId];
        RelationalChartPoint* cpoint = [[RelationalChartPoint alloc]initWithPoint:point weight:weight];
        [JSObjManager addObj:cpoint];
        NSInteger cPointKey = (NSInteger)cpoint;
        resolve(@{@"_chartpointId":@(cPointKey).stringValue});
    } @catch (NSException *exception) {
        reject(@"ChartPoint",@"create Object expection",nil);
    }
}
RCT_REMAP_METHOD(getRelationalName,getRelationalNameById:(NSString*)pointId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        RelationalChartPoint* point = [JSObjManager getObjWithKey:pointId];
        NSString* name = point.relationalName;
        resolve(@{@"name":name});
    } @catch (NSException *exception) {
        reject(@"RelationalChartPoint",@"get Relational Name expection",nil);
    }
}

RCT_REMAP_METHOD(setRelationalName,setRelationalNameById:(NSString*)pointId name:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        RelationalChartPoint* point = [JSObjManager getObjWithKey:pointId];
        point.relationalName = name;
        resolve([NSNumber numberWithBool:true]);
    } @catch (NSException *exception) {
        reject(@"RelationalChartPoint",@"set Relational Name expection",nil);
    }
}

RCT_REMAP_METHOD(setRelationalPoints,setRelationalPointsById:(NSString*)pointId idArr:(NSArray<NSString*>*)idArr resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        RelationalChartPoint* point = [JSObjManager getObjWithKey:pointId];
        NSMutableArray* dataArr = [NSMutableArray arrayWithCapacity:5];
        for(int i=0;i<idArr.count;i++){
            RelationalChartPoint* itemPoint = [JSObjManager getObjWithKey:idArr[i]];
            [dataArr addObject:itemPoint];
        }
        point.relationalPoints = dataArr;
        resolve([NSNumber numberWithBool:true]);
    } @catch (NSException *exception) {
        reject(@"RelationalChartPoint",@"set Relational Points expection",nil);
    }
}

RCT_REMAP_METHOD(addRelationalPoint,addRelationalPointById:(NSString*)pointId itemId:(NSString*)itemId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        RelationalChartPoint* point = [JSObjManager getObjWithKey:pointId];
        RelationalChartPoint* itemPoint = [JSObjManager getObjWithKey:itemId];
        [point.relationalPoints addObject:itemPoint];
        resolve([NSNumber numberWithBool:true]);
    } @catch (NSException *exception) {
        reject(@"RelationalChartPoint",@"set Relational Points expection",nil);
    }
}
@end

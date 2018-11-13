//
//  JSChartPoint.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/5.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSChartPoint.h"

#import "SuperMap/ChartPoint.h"
#import "SuperMap/Point2D.h"
#import "JSObjManager.h"

#import "SuperMap/Point2Ds.h"
#import "SuperMap/PrjCoordSys.h"
#import "SuperMap/CoordSysTransParameter.h"
#import "SuperMap/CoordSysTranslator.h"
#import "SuperMap/MapControl.h"
#import "SuperMap/Map.h"
@implementation JSChartPoint
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
        
        ChartPoint* cpoint = [[ChartPoint alloc]initWithPoint:point weight:weight];
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
        ChartPoint* cpoint = [[ChartPoint alloc]initWithPoint:point weight:weight];
        [JSObjManager addObj:cpoint];
        NSInteger cPointKey = (NSInteger)cpoint;
        resolve(@{@"_chartpointId":@(cPointKey).stringValue});
    } @catch (NSException *exception) {
        reject(@"ChartPoint",@"create Object expection",nil);
    }
}
@end

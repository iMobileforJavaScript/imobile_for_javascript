//
//  JSPieChart.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/5.
//  Copyright © 2017年 Facebook. All rights reserved.
//
#import "SuperMap/PieChart.h"

#import "JSPieChart.h"
#import "JSObjManager.h"

@implementation JSPieChart
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(setChartOnSelected,setChartOnSelectedById:(NSString*)chartviewId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    PieChart* pChart = [JSObjManager getObjWithKey:chartviewId];
    if (pChart) {
        pChart.deleagate = self;
    }else{
        reject(@"PieChart",@"set Chart On Selected failed",nil);
    }
}

RCT_REMAP_METHOD(setSelectedGeometryID,setSelectedGeometryIdById:(NSString*)chartviewId geoId:(int)geoId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    PieChart* pChart = [JSObjManager getObjWithKey:chartviewId];
    if (pChart) {
        [pChart setSelectedGeoID:geoId];
        resolve(@"setted");
    }else{
        reject(@"LineChart",@"set Selected Geometry ID failed",nil);
    }
}
@end

//
//  JSBarChart.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/5.
//  Copyright © 2017年 Facebook. All rights reserved.
//
#import "SuperMap/BarChart.h"

#import "JSBarChart.h"
#import "JSObjManager.h"
@implementation JSBarChart
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(setValueAlongXAxis,setValueAlongXAxisById:(NSString*)chartviewId isAlong:(bool)isAlong resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    BarChart* bChart = [JSObjManager getObjWithKey:chartviewId];
    if (bChart) {
        bChart.isValueAlongXAxis = isAlong;
        resolve(@"setted");
    }else{
        reject(@"BarChart",@"set Value Along XAxis failed",nil);
    }
}

RCT_REMAP_METHOD(isValueAlongXAxis,isValueAlongXAxisById:(NSString*)chartviewId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    BarChart* bChart = [JSObjManager getObjWithKey:chartviewId];
    if (bChart) {
        BOOL isAlong = bChart.isValueAlongXAxis;
        NSNumber* number = [NSNumber numberWithBool:isAlong];
        resolve(@{@"isAlong":number});
    }else{
        reject(@"BarChart",@"get Value Along XAxis failed",nil);
    }
}

RCT_REMAP_METHOD(setXAxisLables,setXAxisLablesById:(NSString*)chartviewId xLabels:(NSArray*)xLabels resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    BarChart* bChart = [JSObjManager getObjWithKey:chartviewId];
    if (bChart) {
        bChart.xAxisLables = xLabels;
        resolve(@"setted");
    }else{
        reject(@"BarChart",@"set XAxis Lables failed",nil);
    }
}

RCT_REMAP_METHOD(getXAxisLables,setXAxisLablesById:(NSString*)chartviewId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    BarChart* bChart = [JSObjManager getObjWithKey:chartviewId];
    if (bChart) {
        NSArray* arr = bChart.xAxisLables;
        resolve(@{@"xAxisLables":arr});
    }else{
        reject(@"BarChart",@"get XAxis Lables failed",nil);
    }
}

RCT_REMAP_METHOD(setXAxisTitle,setXAxisTitleById:(NSString*)chartviewId title:(NSString*)title resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    BarChart* bChart = [JSObjManager getObjWithKey:chartviewId];
    if (bChart) {
        bChart.xAxisTitle = title;
        resolve(@"setted");
    }else{
        reject(@"BarChart",@"set XAxis Title failed",nil);
    }
}

RCT_REMAP_METHOD(getXAxisTitle,getXAxisTitleById:(NSString*)chartviewId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    BarChart* bChart = [JSObjManager getObjWithKey:chartviewId];
    if (bChart) {
        NSString* title = bChart.xAxisTitle;
        resolve(@{@"title":title});
    }else{
        reject(@"BarChart",@"get XAxis Title failed",nil);
    }
}

RCT_REMAP_METHOD(setYAxisTitle,setYAxisTitleById:(NSString*)chartviewId title:(NSString*)title resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    BarChart* bChart = [JSObjManager getObjWithKey:chartviewId];
    if (bChart) {
        bChart.yAxisTitle = title;
        resolve(@"setted");
    }else{
        reject(@"BarChart",@"set XAxis Title failed",nil);
    }
}

RCT_REMAP_METHOD(getYAxisTitle,getYAxisTitleById:(NSString*)chartviewId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    BarChart* bChart = [JSObjManager getObjWithKey:chartviewId];
    if (bChart) {
        NSString* title = bChart.yAxisTitle;
        resolve(@{@"title":title});
    }else{
        reject(@"BarChart",@"get YAxis Title failed",nil);
    }
}
//!!!!!!!!!!!!!!!!!!!!!!!
RCT_REMAP_METHOD(setChartOnSelected,setChartOnSelectedById:(NSString*)chartviewId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    BarChart* bChart = [JSObjManager getObjWithKey:chartviewId];
    if (bChart) {
        bChart.deleagate = self;
    }else{
        reject(@"BarChart",@"set Chart On Selected failed",nil);
    }
}

RCT_REMAP_METHOD(setSelectedGeometryID,setSelectedGeometryIdById:(NSString*)chartviewId geoId:(int)geoId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    BarChart* bChart = [JSObjManager getObjWithKey:chartviewId];
    if (bChart) {
        [bChart setSelectedGeoID:geoId];
        resolve(@"setted");
    }else{
        reject(@"BarChart",@"set Selected GeometryID failed",nil);
    }
}
@end

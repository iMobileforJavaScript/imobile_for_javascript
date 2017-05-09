//
//  JSLineChart.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/5.
//  Copyright © 2017年 Facebook. All rights reserved.
//
#import "SuperMap/LineChart.h"

#import "JSLineChart.h"
#import "JSObjManager.h"

@implementation JSLineChart
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(setAllowInteraction,setAllowInteractionById:(NSString*)chartviewId isAllow:(bool)isAllow resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    LineChart* lChart = [JSObjManager getObjWithKey:chartviewId];
    if (lChart) {
        lChart.allowsUserInteraction = isAllow;
        resolve(@"setted");
    }else{
        reject(@"LineChart",@"set Allow Interaction failed",nil);
    }
}

RCT_REMAP_METHOD(isAllowInteraction,isAllowInteractionById:(NSString*)chartviewId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    LineChart* lChart = [JSObjManager getObjWithKey:chartviewId];
    if (lChart) {
        BOOL isAllow = lChart.allowsUserInteraction;
        NSNumber* number = [NSNumber numberWithBool:isAllow];
        resolve(@{@"isAllow":number});
    }else{
        reject(@"LineChart",@"get Allow Interaction failed",nil);
    }
}

RCT_REMAP_METHOD(setXAxisLables,setXAxisLablesById:(NSString*)chartviewId xLabels:(NSArray*)xLabels resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    LineChart* lChart = [JSObjManager getObjWithKey:chartviewId];
    if (lChart) {
        lChart.xAxisLables = xLabels;
        resolve(@"setted");
    }else{
        reject(@"LineChart",@"set XAxis Lables failed",nil);
    }
}

RCT_REMAP_METHOD(getXAxisLables,setXAxisLablesById:(NSString*)chartviewId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    LineChart* lChart = [JSObjManager getObjWithKey:chartviewId];
    if (lChart) {
        NSArray* arr = lChart.xAxisLables;
        resolve(@{@"xAxisLables":arr});
    }else{
        reject(@"LineChart",@"get XAxis Lables failed",nil);
    }
}

RCT_REMAP_METHOD(setXAxisTitle,setXAxisTitleById:(NSString*)chartviewId title:(NSString*)title resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    LineChart* lChart = [JSObjManager getObjWithKey:chartviewId];
    if (lChart) {
        lChart.xAxisTitle = title;
        resolve(@"setted");
    }else{
        reject(@"LineChart",@"set XAxis Title failed",nil);
    }
}

RCT_REMAP_METHOD(getXAxisTitle,getXAxisTitleById:(NSString*)chartviewId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    LineChart* lChart = [JSObjManager getObjWithKey:chartviewId];
    if (lChart) {
        NSString* title = lChart.xAxisTitle;
        resolve(@{@"title":title});
    }else{
        reject(@"LineChart",@"get XAxis Title failed",nil);
    }
}

RCT_REMAP_METHOD(setYAxisTitle,setYAxisTitleById:(NSString*)chartviewId title:(NSString*)title resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    LineChart* lChart = [JSObjManager getObjWithKey:chartviewId];
    if (lChart) {
        lChart.yAxisTitle = title;
        resolve(@"setted");
    }else{
        reject(@"LineChart",@"set XAxis Title failed",nil);
    }
}

RCT_REMAP_METHOD(getYAxisTitle,getYAxisTitleById:(NSString*)chartviewId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    LineChart* lChart = [JSObjManager getObjWithKey:chartviewId];
    if (lChart) {
        NSString* title = lChart.yAxisTitle;
        resolve(@{@"title":title});
    }else{
        reject(@"LineChart",@"get YAxis Title failed",nil);
    }
}
//!!!!!!!!!!!!!!!!!!!!!!!
RCT_REMAP_METHOD(setChartOnSelected,setChartOnSelectedById:(NSString*)chartviewId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    LineChart* lChart = [JSObjManager getObjWithKey:chartviewId];
    if (lChart) {
        lChart.deleagate = self;
    }else{
        reject(@"LineChart",@"set Chart On Selected failed",nil);
    }
}

RCT_REMAP_METHOD(setSelectedGeometryID,setSelectedGeometryIdById:(NSString*)chartviewId geoId:(int)geoId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    LineChart* lChart = [JSObjManager getObjWithKey:chartviewId];
    if (lChart) {
        [lChart setSelectedGeoID:geoId];
        resolve(@"setted");
    }else{
        reject(@"LineChart",@"set Selected Geometry ID failed",nil);
    }
}

@end

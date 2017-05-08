//
//  JSInstrumentChart.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/6.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSInstrumentChart.h"

#import "SuperMap/InstrumentChart.h"
#import "JSObjManager.h"
@implementation JSInstrumentChart
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj,createObjWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        InstrumentChart* chart = [[InstrumentChart alloc]init];
        NSInteger nsKey = (NSInteger)chart;
        [JSObjManager addObj:chart];
        resolve(@{@"instrumentChartId":@(nsKey).stringValue});
    } @catch (NSException *exception) {
        reject(@"InstrumentChart",@"create Obj expection",nil);
    }
}

RCT_REMAP_METHOD(setMinValue,setMinValueById:(NSString*)instrumentChartId minValue:(float)minValue resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        InstrumentChart* chart = [JSObjManager getObjWithKey:instrumentChartId];
        chart.minValue = minValue;
        resolve(@"setted");
    } @catch (NSException *exception) {
        reject(@"InstrumentChart",@"create Obj expection",nil);
    }
}

RCT_REMAP_METHOD(getMinValue,getMinValueById:(NSString*)instrumentChartId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        InstrumentChart* chart = [JSObjManager getObjWithKey:instrumentChartId];
        float minValue = chart.minValue;
        NSNumber* nsMinValue = [NSNumber numberWithFloat:minValue];
        resolve(@{@"minValue":nsMinValue});
    } @catch (NSException *exception) {
        reject(@"InstrumentChart",@"create Obj expection",nil);
    }
}

RCT_REMAP_METHOD(setMaxValue,setMaxValueById:(NSString*)instrumentChartId maxValue:(float)maxValue resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        InstrumentChart* chart = [JSObjManager getObjWithKey:instrumentChartId];
        chart.maxValue = maxValue;
        resolve(@"setted");
    } @catch (NSException *exception) {
        reject(@"InstrumentChart",@"create Obj expection",nil);
    }
}

RCT_REMAP_METHOD(getMaxValue,getMaxValueById:(NSString*)instrumentChartId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        InstrumentChart* chart = [JSObjManager getObjWithKey:instrumentChartId];
        float maxValue = chart.maxValue;
        NSNumber* nsMaxValue = [NSNumber numberWithFloat:maxValue];
        resolve(@{@"maxValue":nsMaxValue});
    } @catch (NSException *exception) {
        reject(@"InstrumentChart",@"create Obj expection",nil);
    }
}

RCT_REMAP_METHOD(setSegmentCount,setSegmentCountById:(NSString*)instrumentChartId count:(int)count resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        InstrumentChart* chart = [JSObjManager getObjWithKey:instrumentChartId];
        chart.splitCount = count;
        resolve(@"setted");
    } @catch (NSException *exception) {
        reject(@"InstrumentChart",@"set Segment Count expection",nil);
    }
}

RCT_REMAP_METHOD(getSegmentCount,getSegmentCountById:(NSString*)instrumentChartId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        InstrumentChart* chart = [JSObjManager getObjWithKey:instrumentChartId];
        float count = chart.splitCount;
        NSNumber* nsCount = [NSNumber numberWithFloat:count];
        resolve(@{@"count":nsCount});
    } @catch (NSException *exception) {
        reject(@"InstrumentChart",@"get Segment Count expection",nil);
    }
}

RCT_REMAP_METHOD(setColorScheme,setColorSchemeById:(NSString*)instrumentChartId colorSchemeId:(NSString*)colorSchemeId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        InstrumentChart* chart = [JSObjManager getObjWithKey:instrumentChartId];
        ColorScheme* colorScheme = [JSObjManager getObjWithKey:colorSchemeId];
        chart.gradient = colorScheme;
        resolve(@"setted");
    } @catch (NSException *exception) {
        reject(@"InstrumentChart",@"set Color Scheme expection",nil);
    }
}
@end

//
//  JSBarChartDataItem.m
//  Supermap
//
//  Created by 王子豪 on 2017/7/24.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSBarChartDataItem.h"
#import "SuperMap/ChartData.h"
#import "JSObjManager.h"

@implementation JSBarChartDataItem
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj,createObjWithValue:(double)value colorArr:(NSArray*)colorArr labelString:(NSString*)labelString id:(int)id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        value = value/15000;
        NSNumber* redNum = colorArr[0];
        float red = redNum.longValue/255.0;
        NSNumber* greenNum = colorArr[1];
        float green = greenNum.longValue/255.0;
        NSNumber* blueNum = colorArr[2];
        float blue = blueNum.longValue/255.0;
        NSNumber* alphaNum = [NSNumber numberWithFloat:1];
        if (colorArr.count>3) {
            alphaNum = colorArr[3];
        }
        float alpha = alphaNum.floatValue;
        UIColor* color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        ChartBarDataItem* chartBarDataItem = [[ChartBarDataItem alloc]initWithValue:[NSNumber numberWithDouble:value] color:color lable:labelString ID:id];
        [JSObjManager addObj:chartBarDataItem];
        NSInteger dataKey = (NSInteger)chartBarDataItem;
        resolve(@{@"_SMBarChartDataItemId":@(dataKey).stringValue});
    } @catch (NSException *exception) {
        reject(@"BarChartDataItem",@"createObj() get expection",nil);
    }
}

RCT_REMAP_METHOD(setValue,setValueById:(NSString*)barChartDataItemId value:(double)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ChartBarDataItem* chartBarDataItem = [JSObjManager getObjWithKey:barChartDataItemId];
        chartBarDataItem.value = [NSNumber numberWithBool:value];
        resolve([NSNumber numberWithBool:true]);
    } @catch (NSException *exception) {
        reject(@"BarChartDataItem",@"setValue() get expection",nil);
    }
}

RCT_REMAP_METHOD(getValue,getValueById:(NSString*)barChartDataItemId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ChartBarDataItem* chartBarDataItem = [JSObjManager getObjWithKey:barChartDataItemId];
        NSNumber* valueNum = chartBarDataItem.value;
        resolve(@{@"value":valueNum});
    } @catch (NSException *exception) {
        reject(@"BarChartDataItem",@"getValue() get expection",nil);
    }
}

RCT_REMAP_METHOD(setGeometryID,setGeometryIDById:(NSString*)barChartDataItemId id:(int)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ChartBarDataItem* chartBarDataItem = [JSObjManager getObjWithKey:barChartDataItemId];
        chartBarDataItem.geoId = Id;
        resolve([NSNumber numberWithBool:true]);
    } @catch (NSException *exception) {
        reject(@"BarChartDataItem",@"setGeometryID() get expection",nil);
    }
}

RCT_REMAP_METHOD(setLabel,setLabelById:(NSString*)barChartDataItemId label:(NSString*)label resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ChartBarDataItem* chartBarDataItem = [JSObjManager getObjWithKey:barChartDataItemId];
        chartBarDataItem.lable = label;
        resolve([NSNumber numberWithBool:true]);
    } @catch (NSException *exception) {
        reject(@"BarChartDataItem",@"setLabel() get expection",nil);
    }
}

RCT_REMAP_METHOD(getLabel,getLabelById:(NSString*)barChartDataItemId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ChartBarDataItem* chartBarDataItem = [JSObjManager getObjWithKey:barChartDataItemId];
        NSString* label = chartBarDataItem.lable;
        resolve(@{@"label":label});
    } @catch (NSException *exception) {
        reject(@"BarChartDataItem",@"getLabel() get expection",nil);
    }
}
@end

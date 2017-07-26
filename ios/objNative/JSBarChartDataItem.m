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
        NSNumber* red = colorArr[0];
        NSNumber* green = colorArr[1];
        NSNumber* blue = colorArr[2];
        NSNumber* alpha = [NSNumber numberWithFloat:1.0f];
        if (colorArr.count>3) {
            alpha = colorArr[3];
        }
        UIColor* color = [UIColor colorWithRed:red.intValue/255 green:green.intValue/255 blue:blue.intValue/255 alpha:alpha.floatValue];
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

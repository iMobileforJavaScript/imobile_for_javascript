//
//  JSBarChartData.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/5.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSBarChartData.h"

#import "SuperMap/ChartData.h"
#import "JSObjManager.h"
@implementation JSBarChartData
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj,createObjWithName:(NSString*)name values:(NSArray*)values resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ChartBarData* chartBarData = [[ChartBarData alloc]initWithItemName:name values:values];
        [JSObjManager addObj:chartBarData];
        NSInteger dataKey = (NSInteger)chartBarData;
        resolve(@{@"_barchartdataId":@(dataKey).stringValue});
    } @catch (NSException *exception) {
        reject(@"BarChartData",@"createObj get expection",nil);
    }
}

RCT_REMAP_METHOD(setValues,setValuesById:(NSString*)barChartDataId values:(NSArray*)values resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ChartBarData* chartBarData = [JSObjManager getObjWithKey:barChartDataId];
        chartBarData.values = [NSMutableArray arrayWithArray:values];
        resolve(@"values setted");
    } @catch (NSException *exception) {
        reject(@"BarChartData",@"set Values get expection",nil);
    }
}

RCT_REMAP_METHOD(getValues,getValuesById:(NSString*)barChartDataId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ChartBarData* chartBarData = [JSObjManager getObjWithKey:barChartDataId];
        NSArray* arr = chartBarData.values;
        resolve(@{@"values":arr});
    } @catch (NSException *exception) {
        reject(@"BarChartData",@"set Values get expection",nil);
    }
}

@end

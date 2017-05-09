//
//  JSLineChartData.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/5.
//  Copyright © 2017年 Facebook. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "JSLineChartData.h"

#import "SuperMap/ChartData.h"
#import "JSObjManager.h"
@implementation JSLineChartData
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj,createObjWithPara:(NSDictionary*)paraDic resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSString* name = [paraDic objectForKey:@"itemName"];
        NSArray* arr = [paraDic objectForKey:@"value"];
        NSNumber* red = [paraDic objectForKey:@"red"];
        NSNumber* green = [paraDic objectForKey:@"green"];
        NSNumber* blue = [paraDic objectForKey:@"blue"];
        NSNumber* alpha = [paraDic objectForKey:@"alpha"];
        if (alpha) {
            alpha = [NSNumber numberWithFloat:1.0f];
        }
        UIColor* color = [UIColor colorWithRed:red.floatValue/255 green:green.floatValue/255 blue:blue.floatValue/255 alpha:alpha.floatValue];
        NSNumber* geoId = [paraDic objectForKey:@"geoID"];
        ChartLineData* chartLineData = [[ChartLineData alloc]initWithItemName:name value:arr color:color ID:geoId.intValue];
        [JSObjManager addObj:chartLineData];
        NSInteger dataKey = (NSInteger)chartLineData;
        resolve(@{@"_linechartdataId":@(dataKey).stringValue});
    } @catch (NSException *exception) {
        reject(@"LineChartData",@"createObj get expection",nil);
    }
}

RCT_REMAP_METHOD(setValues,setValuesById:(NSString*)lineChartDataId values:(NSArray*)values resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ChartLineData* chartLineData = [JSObjManager getObjWithKey:lineChartDataId];
        chartLineData.values = [NSMutableArray arrayWithArray:values];
        resolve(@"value setted");
    } @catch (NSException *exception) {
        reject(@"LineChartData",@"set Values expection",nil);
    }
}

RCT_REMAP_METHOD(getValues,getValuesById:(NSString*)lineChartDataId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ChartLineData* chartLineData = [JSObjManager getObjWithKey:lineChartDataId];
        NSArray* values = chartLineData.values;
        resolve(@{@"values":values});
    } @catch (NSException *exception) {
        reject(@"LineChartData",@"get Values expection",nil);
    }
}
@end

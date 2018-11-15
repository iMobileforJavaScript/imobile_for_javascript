//
//  JSPieChartData.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/5.
//  Copyright © 2017年 Facebook. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "JSPieChartData.h"

#import "SuperMap/ChartData.h"
#import "JSObjManager.h"
@implementation JSPieChartData
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
        ChartPieData* chartPieData = [[ChartPieData alloc]initWithItemName:name value:arr color:color ID:geoId.intValue];
        [JSObjManager addObj:chartPieData];
        NSInteger dataKey = (NSInteger)chartPieData;
        resolve(@{@"_piechartdataId":@(dataKey).stringValue});
    } @catch (NSException *exception) {
        reject(@"PieChartData",@"createObj get expection",nil);
    }
}

RCT_REMAP_METHOD(setValue,setValueById:(NSString*)pieChartDataId value:(double)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ChartPieData* chartPieData = [JSObjManager getObjWithKey:pieChartDataId];
        chartPieData.value = value;
        resolve(@"value setted");
    } @catch (NSException *exception) {
        reject(@"PieChartData",@"set Value expection",nil);
    }
}

RCT_REMAP_METHOD(getValue,getValueById:(NSString*)pieChartDataId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ChartPieData* chartPieData = [JSObjManager getObjWithKey:pieChartDataId];
        double value = chartPieData.value;
        NSNumber* nsValue = [NSNumber numberWithDouble:value];
        resolve(@{@"value":nsValue});
    } @catch (NSException *exception) {
        reject(@"PieChartData",@"get Value expection",nil);
    }
}
@end

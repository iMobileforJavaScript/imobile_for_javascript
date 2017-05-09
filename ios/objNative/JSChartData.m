//
//  JSChartData.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/4.
//  Copyright © 2017年 Facebook. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SuperMap/ChartData.h"

#import "JSChartData.h"
#import "JSObjManager.h"

@implementation JSChartData
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj, createObjByLabel:(NSString*)label color:(NSDictionary*)colorDic geoId:(int)geoId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    NSArray* keyArr = [colorDic allKeys];
    if ([keyArr containsObject:@"red"]&&[keyArr containsObject:@"green"]&&[keyArr containsObject:@"blue"]) {
        NSNumber* nsRed = [colorDic  objectForKey:@"red"];
        float red = nsRed.floatValue;
        NSNumber* nsGreen = [colorDic objectForKey:@"green"];
        float green = nsGreen.floatValue;
        NSNumber* nsBlue = [colorDic objectForKey:@"blue"];
        float blue = nsBlue.floatValue;
        NSNumber* nsAlpha = [colorDic objectForKey:@"alpha"];
        float alpha = nsAlpha.floatValue;
        UIColor* color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        
        ChartData* chartData = [[ChartData alloc]initWith:label color:color ID:geoId];
        NSInteger dataKey = (NSInteger)chartData;
        [JSObjManager addObj:chartData];
        resolve(@{@"_chartdataId":@(dataKey).stringValue});
    }else{
     reject(@"chartData",@"createObj failed",nil);
    }
}

RCT_REMAP_METHOD(setGeometryID, setGeometryById:(NSString*)chartDataId geoId:(int)geoId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ChartData* chartData = [JSObjManager getObjWithKey:chartDataId];
    if (chartData) {
        chartData.geoId = geoId;
        resolve(@"setted");
    }else{
        reject(@"chartData",@"set Geometry ID failed",nil);
    }
}

RCT_REMAP_METHOD(setLabel, setLabelById:(NSString*)chartDataId label:(NSString*)label resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ChartData* chartData = [JSObjManager getObjWithKey:chartDataId];
    if (chartData) {
        chartData.lable = label;
        resolve(@"setted");
    }else{
        reject(@"chartData",@"set label failed",nil);
    }
}
@end

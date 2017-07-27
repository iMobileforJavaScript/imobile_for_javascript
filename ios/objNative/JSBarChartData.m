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
        NSMutableArray* arr = [NSMutableArray arrayWithCapacity:10];
        for (NSString* valueId in values) {
            ChartBarDataItem* item = [JSObjManager getObjWithKey:valueId];
            [arr addObject:item];
        }
        ChartBarData* chartBarData = [[ChartBarData alloc]initWithItemName:name values:(NSArray*)arr];
        [JSObjManager addObj:chartBarData];
        NSInteger dataKey = (NSInteger)chartBarData;
        resolve(@{@"_barchartdataId":@(dataKey).stringValue});
    } @catch (NSException *exception) {
        reject(@"BarChartData",@"createObj() get expection",nil);
    }
}

RCT_REMAP_METHOD(setValues,setValuesById:(NSString*)barChartDataId values:(NSArray*)values resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSMutableArray* valuesArr = [[NSMutableArray alloc]initWithCapacity:5];
        for (NSString*id in values) {
            ChartBarDataItem* item = [JSObjManager getObjWithKey:id];
            [valuesArr addObject:item];
        }
        ChartBarData* chartBarData = [JSObjManager getObjWithKey:barChartDataId];
        chartBarData.values = valuesArr;
        resolve([NSNumber numberWithBool:true]);
    } @catch (NSException *exception) {
        reject(@"BarChartData",@"setValues() get expection",nil);
    }
}

RCT_REMAP_METHOD(getValues,getValuesById:(NSString*)barChartDataId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSMutableArray* idArr = [[NSMutableArray alloc]initWithCapacity:10];
        ChartBarData* chartBarData = [JSObjManager getObjWithKey:barChartDataId];
        NSArray* arr = chartBarData.values;
        for (ChartBarDataItem* object in arr) {
            NSInteger dsVectorKey = (NSInteger)object;
            [JSObjManager addObj:object];
            [idArr addObject:@(dsVectorKey).stringValue];
        }
        resolve(@{@"values":(NSArray*)idArr});
    } @catch (NSException *exception) {
        reject(@"BarChartData",@"getValues() get expection",nil);
    }
}

@end

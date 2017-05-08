//
//  JSHotChart.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/6.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSHotChart.h"

#import "SuperMap/HotChart.h"
#import "JSObjManager.h"
@implementation JSHotChart
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj,createObjByMapControl:(NSString*)mapControlId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [JSObjManager getObjWithKey:mapControlId];
        HotChart* hotChart = [[HotChart alloc]initWithMapControl:mapControl];
        NSInteger nsHotKey = (NSInteger)hotChart;
        [JSObjManager addObj:hotChart];
        resolve(@{@"hotChartId":@(nsHotKey).stringValue});
    } @catch (NSException *exception) {
        reject(@"HotChart",@"create Obj expection",nil);
    }
}

RCT_REMAP_METHOD(setColorScheme,setColorSchemeById:(NSString*)hotChartId colorScheme:(NSString*)colorSchemeId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        HotChart* hotChart = [JSObjManager getObjWithKey:hotChartId];
        ColorScheme* colorScheme = [JSObjManager getObjWithKey:colorSchemeId];
        [hotChart setColorScheme:colorScheme];
        resolve(@"ColorScheme setted");
    } @catch (NSException *exception) {
        reject(@"HotChart",@"set ColorScheme expection",nil);
    }
}
@end

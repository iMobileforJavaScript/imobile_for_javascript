//
//  JSGridHotChart.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/6.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSGridHotChart.h"

#import "SuperMap/GridHotChart.h"
#import "JSObjManager.h"
@implementation JSGridHotChart
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj,createObjByMapControl:(NSString*)mapControlId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [JSObjManager getObjWithKey:mapControlId];
        GridHotChart* gridHotChart = [[GridHotChart alloc]initWithMapControl:mapControl];
        NSInteger nsHotKey = (NSInteger)gridHotChart;
        [JSObjManager addObj:gridHotChart];
        resolve(@{@"gridHotChartId":@(nsHotKey).stringValue});
    } @catch (NSException *exception) {
        reject(@"GridHotChart",@"create Obj expection",nil);
    }
}

RCT_REMAP_METHOD(setColorScheme,setColorSchemeById:(NSString*)hotChartId colorScheme:(NSString*)colorSchemeId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        GridHotChart* gridHotChart = [JSObjManager getObjWithKey:hotChartId];
        ColorScheme* colorScheme = [JSObjManager getObjWithKey:colorSchemeId];
        [gridHotChart setColorScheme:colorScheme];
        resolve(@"ColorScheme setted");
    } @catch (NSException *exception) {
        reject(@"GridHotChart",@"set ColorScheme expection",nil);
    }
}
@end

//
//  JSPointDensityChart.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/8.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSPointDensityChart.h"

#import "SuperMap/PointDensityChart.h"
#import "JSObjManager.h"
@implementation JSPointDensityChart
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj,createObjByMapControl:(NSString*)mapControlId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [JSObjManager getObjWithKey:mapControlId];
        PointDensityChart* pointDensityChart = [[PointDensityChart alloc]initWithMapControl:mapControl];
        NSInteger nsKey = (NSInteger)pointDensityChart;
        [JSObjManager addObj:pointDensityChart];
        resolve(@{@"pointDensityChartId":@(nsKey).stringValue});
    } @catch (NSException *exception) {
        reject(@"PointDensityChart",@"create Obj expection",nil);
    }
}

RCT_REMAP_METHOD(setColorScheme,setColorSchemeById:(NSString*)chartId colorScheme:(NSString*)colorSchemeId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PointDensityChart* pointDensityChart = [JSObjManager getObjWithKey:chartId];
        ColorScheme* colorScheme = [JSObjManager getObjWithKey:colorSchemeId];
        [pointDensityChart setColorScheme:colorScheme];
        resolve(@"ColorScheme setted");
    } @catch (NSException *exception) {
        reject(@"PointDensityChart",@"set ColorScheme expection",nil);
    }
}
@end

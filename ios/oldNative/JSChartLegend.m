//
//  JSChartLegend.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/6.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSChartLegend.h"

//#import "SuperMap/ChartLegend.h"
#import "SuperMap/Point2D.h"
#import "JSObjManager.h"
@implementation JSChartLegend
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(setOrient,setOrientById:(NSString*)chartLegendId isOrient:(BOOL)isOrient resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
//        ChartLegend* cLegend = [JSObjManager getObjWithKey:chartLegendId];
//        cLegend.orient = isOrient;
        resolve(@"orient setted");
    } @catch (NSException *exception) {
        reject(@"ChartLegend",@"set Orient expection",nil);
    }
}

RCT_REMAP_METHOD(isOrient,isOrientById:(NSString*)chartLegendId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
//        ChartLegend* cLegend = [JSObjManager getObjWithKey:chartLegendId];
//        BOOL isOrient = cLegend.orient;
//        NSNumber* nsOrient = [NSNumber numberWithBool:isOrient];
//        resolve(@{@"orient":nsOrient});
        resolve(@{@"orient":@(1)});
    } @catch (NSException *exception) {
        reject(@"ChartLegend",@"get Orient expection",nil);
    }
}
@end

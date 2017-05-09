//
//  JSChartPoint.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/5.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSChartPoint.h"

#import "SuperMap/ChartPoint.h"
#import "SuperMap/Point2D.h"
#import "JSObjManager.h"
@implementation JSChartPoint
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj,createObjByWeight:(float)weight pointX:(double)pointX pointY:(double)pointY resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Point2D* point = [[Point2D alloc]initWithX:pointX Y:pointY];
        ChartPoint* cpoint = [[ChartPoint alloc]initWithPoint:point weight:weight];
        [JSObjManager addObj:cpoint];
        NSInteger cPointKey = (NSInteger)cpoint;
        resolve(@{@"_chartpointId":@(cPointKey).stringValue});
    } @catch (NSException *exception) {
        reject(@"ChartPoint",@"create Object expection",nil);
    }
}

RCT_REMAP_METHOD(createObjByPoint,createObjByWeight:(float)weight pointId:(NSString*)pointId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Point2D* point = [JSObjManager getObjWithKey:pointId];
        ChartPoint* cpoint = [[ChartPoint alloc]initWithPoint:point weight:weight];
        [JSObjManager addObj:cpoint];
        NSInteger cPointKey = (NSInteger)cpoint;
        resolve(@{@"_chartpointId":@(cPointKey).stringValue});
    } @catch (NSException *exception) {
        reject(@"ChartPoint",@"create Object expection",nil);
    }
}
@end

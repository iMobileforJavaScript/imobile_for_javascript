//
//  JSPoint2D.m
//  HelloWorldDemo
//
//  Created by 王子豪 on 2016/11/23.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSPoint2D.h"
#import "SuperMap/Point2D.h"
#import "JSObjManager.h"

@implementation JSPoint2D
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObjByXY,createObjByX:(double)xNum Y:(double)yNum resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Point2D* point = [[Point2D alloc]initWithX:xNum Y:yNum];
        NSString* key = [JSObjManager addObj:point];
        resolve(@{@"point2DId":key});
    } @catch (NSException* exception) {
        reject(@"point", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(createObj,resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Point2D* point = [[Point2D alloc]init];
        NSString* key = [JSObjManager addObj:point];
        resolve(@{@"point2DId":key});
    } @catch (NSException* exception) {
        reject(@"point", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(getX, getXId:(NSString*)id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Point2D* point = [JSObjManager getObjWithKey:id];
    if (point) {
       
        resolve(@(point.x));
    }else{
        reject(@"point",@"getX point failed!!!",nil);
    }
}

RCT_REMAP_METHOD(getY,getYId:(NSString*)id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
     Point2D* point = [JSObjManager getObjWithKey:id];
    if (point) {
        resolve(@(point.y));
    }else{
        reject(@"point",@"create point failed!!!",nil);
    }
}
@end

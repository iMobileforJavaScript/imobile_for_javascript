//
//  JSElementPoint.m
//  Supermap
//
//  Created by imobile-xzy on 2018/8/1.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSElementPoint.h"
#import "SuperMap/ColElementPoint.h"
#import "JSObjManager.h"

@implementation JSElementPoint
RCT_EXPORT_MODULE();
/**
 * 创建对象
 * @param promise
 */
RCT_REMAP_METHOD(createObj,createObj:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ColElementPoint* elementPoint = [[ColElementPoint alloc] init];
        NSInteger nsKey = (NSInteger)elementPoint;
        [JSObjManager addObj:elementPoint];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSElementPoint",@"createObj expection",nil);
    }
}

/**
 * 通过 Geomotry 构造采集对象
 * @param collectorId
 * @param geometryId
 * @param promise
 */
RCT_REMAP_METHOD(fromGeometry,fromGeometry:(NSString*)senderId  geometry:(NSString*)geometryId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ColElementPoint* sender = [JSObjManager getObjWithKey:senderId];
        Geometry* geo = [JSObjManager getObjWithKey:geometryId];
        BOOL result = [sender fromGeometry:geo];
        resolve([NSNumber numberWithBool:result]);
        
    } @catch (NSException *exception) {
        reject(@"JSElementPoint",@"fromGeometry expection",nil);
    }
}


@end

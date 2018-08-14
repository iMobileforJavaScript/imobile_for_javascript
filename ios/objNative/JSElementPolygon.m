//
//  JSElementPolygon.m
//  Supermap
//
//  Created by imobile-xzy on 2018/8/1.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSElementPolygon.h"
#import "SuperMap/ColElementPolygon.h"
#import "JSObjManager.h"

@implementation JSElementPolygon
RCT_EXPORT_MODULE();
/**
 * 创建对象
 * @param promise
 */
RCT_REMAP_METHOD(createObj,createObj:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ColElementPolygon* elementPolygon = [[ColElementPolygon alloc] init];
        NSInteger nsKey = (NSInteger)elementPolygon;
        [JSObjManager addObj:elementPolygon];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSElementPolygon",@"createObj expection",nil);
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
        ColElementPolygon* sender = [JSObjManager getObjWithKey:senderId];
        Geometry* geo = [JSObjManager getObjWithKey:geometryId];
        BOOL result = [sender fromGeometry:geo];
        resolve([NSNumber numberWithBool:result]);
        
    } @catch (NSException *exception) {
        reject(@"JSElementPolygon",@"fromGeometry expection",nil);
    }
}

@end

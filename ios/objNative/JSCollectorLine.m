//
//  JSCollectorLine.m
//  iTablet
//
//  Created by imobile-xzy on 2018/8/1.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSCollectorLine.h"
#import "SuperMap/ColElementLine.h"
#import "JSObjManager.h"

@implementation JSCollectorLine
RCT_EXPORT_MODULE();
/**
 * 创建对象
 * @param promise
 */
RCT_REMAP_METHOD(createObj,createObj:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ColElementLine* elementLine = [[ColElementLine alloc] init];
        NSInteger nsKey = (NSInteger)elementLine;
        [JSObjManager addObj:elementLine];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSElementLine",@"createObj expection",nil);
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
        ColElementLine* sender = [JSObjManager getObjWithKey:senderId];
        Geometry* geo = [JSObjManager getObjWithKey:geometryId];
        BOOL result = [sender fromGeometry:geo];
        resolve([NSNumber numberWithBool:result]);
        
    } @catch (NSException *exception) {
        reject(@"JSElementLine",@"fromGeometry expection",nil);
    }
}


@end

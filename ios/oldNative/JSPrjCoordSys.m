//
//  JSPrjCoordSys.m
//  Supermap
//
//  Created by wnmng on 2018/8/9.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSPrjCoordSys.h"
#import "SuperMap/PrjCoordSys.h"
#import "JSObjManager.h"

@implementation JSPrjCoordSys
RCT_EXPORT_MODULE();

/**
 * 创建对象
 * @param promise
 */
RCT_REMAP_METHOD(createObj,createObj:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PrjCoordSys *prjCoordSys = [[PrjCoordSys alloc]init];
        NSInteger nsKey = (NSInteger)prjCoordSys;
        [JSObjManager addObj:prjCoordSys];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSPrjCoordSys",@"createObj expection",nil);
    }
}

RCT_REMAP_METHOD(createObjWithType,createObjWithType:(int)nType resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PrjCoordSys *prjCoordSys = [[PrjCoordSys alloc]initWithType:nType];
        NSInteger nsKey = (NSInteger)prjCoordSys;
        [JSObjManager addObj:prjCoordSys];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSPrjCoordSys",@"createObj expection",nil);
    }
}

RCT_REMAP_METHOD(getType,getType:(NSString*)prjCoordSysId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PrjCoordSys *prjCoordSys = [JSObjManager getObjWithKey:prjCoordSysId];
        PrjCoordSysType type = [prjCoordSys type];
        resolve([NSNumber numberWithInt:type]);
    } @catch (NSException *exception) {
        reject(@"JSPrjCoordSys",@"getType expection",nil);
    }
}

RCT_REMAP_METHOD(setType,setType:(NSString*)prjCoordSysId type:(int)nType resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PrjCoordSys *prjCoordSys = [JSObjManager getObjWithKey:prjCoordSysId];
        [prjCoordSys setType:nType];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSPrjCoordSys",@"setType expection",nil);
    }
}


@end

//
//  JSPointM.m
//  Supermap
//
//  Created by wnmng on 2018/8/9.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSPointM.h"
#import "SuperMap/PointM.h"
#import "JSObjManager.h"

@implementation JSPointM
RCT_EXPORT_MODULE();

/**
 * 创建对象
 * @param promise
 */
RCT_REMAP_METHOD(createObj,createObj:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PointM *pntM = [[PointM alloc]init];
        NSInteger nsKey = (NSInteger)pntM;
        [JSObjManager addObj:pntM];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSPointM",@"createObj expection",nil);
    }
}


RCT_REMAP_METHOD(createObjByXYM,createObjByXYM:(double)x y:(double)y m:(double)m resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PointM *pntM = [[PointM alloc]initWith:x y:y z:m];
        NSInteger nsKey = (NSInteger)pntM;
        [JSObjManager addObj:pntM];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSPointM",@"createObjByXYM expection",nil);
    }
}

RCT_REMAP_METHOD(getX,getX:(NSString*)pointMId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PointM* pntM = [JSObjManager getObjWithKey:pointMId];
        double x = [pntM x];
        resolve(@(x));
    } @catch (NSException *exception) {
        reject(@"JSPointM",@"getX expection",nil);
    }
}

RCT_REMAP_METHOD(getY,getY:(NSString*)pointMId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PointM* pntM = [JSObjManager getObjWithKey:pointMId];
        double y = [pntM y];
        resolve(@(y));
    } @catch (NSException *exception) {
        reject(@"JSPointM",@"getY expection",nil);
    }
}

RCT_REMAP_METHOD(getM,getM:(NSString*)pointMId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PointM* pntM = [JSObjManager getObjWithKey:pointMId];
        double m = [pntM z];
        resolve(@(m));
    } @catch (NSException *exception) {
        reject(@"JSPointM",@"getM expection",nil);
    }
}

RCT_REMAP_METHOD(setX,setX:(NSString*)pointMId x:(double)x resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PointM* pntM = [JSObjManager getObjWithKey:pointMId];
        [pntM setX:x];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSPointM",@"setX expection",nil);
    }
}

RCT_REMAP_METHOD(setY,setY:(NSString*)pointMId y:(double)y resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PointM* pntM = [JSObjManager getObjWithKey:pointMId];
        [pntM setY:y];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSPointM",@"setY expection",nil);
    }
}

RCT_REMAP_METHOD(setM,setM:(NSString*)pointMId m:(double)m resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PointM* pntM = [JSObjManager getObjWithKey:pointMId];
        [pntM setZ:m];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSPointM",@"setM expection",nil);
    }
}


/**
 * 返回当前 PointM 对象的一个拷贝
 *
 * @param pointMId
 * @param promise
 */
RCT_REMAP_METHOD(clone,clone:(NSString*)pointMId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PointM* pntM = [JSObjManager getObjWithKey:pointMId];
        PointM* clonePntM = [[PointM alloc]initWith:pntM.x y:pntM.y z:pntM.z];
        
        // 接口缺失
        
        NSInteger nsKey = (NSInteger)clonePntM;
        [JSObjManager addObj:clonePntM];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSPointM",@"clone expection",nil);
    }
}
/**
 * 指定此 PointM 结构体对象是否与指定的 PointM 有相同的 X、Y、M 值
 *
 * @param pointMId
 * @param targetId
 * @param promise
 */
RCT_REMAP_METHOD(equals,equals:(NSString*)pointMId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PointM* pntM = [JSObjManager getObjWithKey:pointMId];
        
        // 接口缺失
        
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSPointM",@"equals expection",nil);
    }
}

/**
 * 返回一个空的 PointM 对象
 *
 * @param promise
 */
RCT_REMAP_METHOD(getEMPTY,getEMPTY:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PointM* pntM = [[PointM alloc]initWith:0 y:0 z:0];
        
        // 接口缺失
        
        NSInteger nsKey = (NSInteger)pntM;
        [JSObjManager addObj:pntM];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSPointM",@"getEMPTY expection",nil);
    }
}
/**
 * 返回此 PointM 结构体对象的哈希代码
 * @param pointMId
 * @param promise
 */
RCT_REMAP_METHOD(hashCode,hashCode:(NSString*)pointMId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PointM* pntM = [JSObjManager getObjWithKey:pointMId];
        
        // 接口缺失
        
        resolve(@(99999999));
    } @catch (NSException *exception) {
        reject(@"JSPointM",@"hashCode expection",nil);
    }
}
/**
 * 返回一个值，该值指示 PointM 对象是否为空
 * @param pointMId
 * @param promise
 */
RCT_REMAP_METHOD(isEmpty,isEmpty:(NSString*)pointMId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PointM* pntM = [JSObjManager getObjWithKey:pointMId];
        
        // 接口缺失
        
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSPointM",@"isEmpty expection",nil);
    }
}
/**
 * 创建一个表示此 PointM 结构体对象的可读字符串，如 PointM(2,3,4)，返回“{X=2.0,Y=3.0,M=4.0}”
 * @param pointMId
 * @param promise
 */
RCT_REMAP_METHOD(toString,toString:(NSString*)pointMId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PointM* pntM = [JSObjManager getObjWithKey:pointMId];
        
        // 接口缺失
        
        resolve(@"接口缺失");
    } @catch (NSException *exception) {
        reject(@"JSPointM",@"toString expection",nil);
    }
}


@end

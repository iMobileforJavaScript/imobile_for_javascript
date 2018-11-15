//
//  JSTextPart.m
//  Supermap
//
//  Created by wnmng on 2018/8/7.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSTextPart.h"
#import "SuperMap/TextPart.h"
#import "JSObjManager.h"

@implementation JSTextPart
RCT_EXPORT_MODULE();

/**
 * 创建对象
 * @param promise
 */
RCT_REMAP_METHOD(createObj,createObj:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextPart* textPart = [[TextPart alloc] init];
        NSInteger nsKey = (NSInteger)textPart;
        [JSObjManager addObj:textPart];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSTextPart",@"createObj expection",nil);
    }
}

/**
 * 创建对象
 * @param text
 * @param anchorPointId
 * @param promise
 */
RCT_REMAP_METHOD(createObjWithPoint2D,createObjWithPoint2D:(NSString*)strText ancher:(NSString*)anchorPointId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Point2D * pnt2D = [JSObjManager getObjWithKey:anchorPointId];
        TextPart* textPart = [[TextPart alloc] initWithTextString:strText anchorPoint:pnt2D];
        NSInteger nsKey = (NSInteger)textPart;
        [JSObjManager addObj:textPart];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSTextPart",@"createObj expection",nil);
    }
}

/**
 * 释放此对象所占用的资源
 * @param textPartId
 * @param promise
 */
RCT_REMAP_METHOD(dispose,dispose:(NSString*)textPartId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextPart* textPart = [JSObjManager getObjWithKey:textPartId];
        [textPart dispose];
        [JSObjManager removeObj:textPartId];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTextPart",@"dispose expection",nil);
    }
}
/**
 * 返回此文本子对象实例的锚点，其类型为 Point2D
 * @param textPartId
 * @param promise
 */
RCT_REMAP_METHOD(getAnchorPoint,getAnchorPoint:(NSString*)textPartId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextPart* textPart = [JSObjManager getObjWithKey:textPartId];
        Point2D* ancherPnt2D = [textPart getAnchorPoint];
        NSInteger nsKey = (NSInteger)ancherPnt2D;
        [JSObjManager addObj:ancherPnt2D];
        resolve(@(nsKey).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSTextPart",@"getAnchorPoint expection",nil);
    }
}
/**
 * 返回此文本子对象的旋转角度
 * @param textPartId
 * @param promise
 */
RCT_REMAP_METHOD(getRotation,getRotation:(NSString*)textPartId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextPart* textPart = [JSObjManager getObjWithKey:textPartId];
        double angle = [textPart getRotation];
        resolve([NSNumber numberWithDouble:angle]);
    } @catch (NSException *exception) {
        reject(@"JSTextPart",@"getRotation expection",nil);
    }
}
/**
 * 返回此文本子对象的文本内容
 * @param textPartId
 * @param promise
 */
RCT_REMAP_METHOD(getText,getText:(NSString*)textPartId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextPart* textPart = [JSObjManager getObjWithKey:textPartId];
        NSString* strText = [textPart getText];
        resolve(strText);
    } @catch (NSException *exception) {
        reject(@"JSTextPart",@"getText expection",nil);
    }
}
/**
 * 设置此文本子对象锚点的横坐标
 * @param textPartId
 * @param promise
 */
RCT_REMAP_METHOD(getX,getX:(NSString*)textPartId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextPart* textPart = [JSObjManager getObjWithKey:textPartId];
        double x = [textPart getX];
        resolve([NSNumber numberWithDouble:x]);
    } @catch (NSException *exception) {
        reject(@"JSTextPart",@"getX expection",nil);
    }
}
/**
 * 设置此文本子对象锚点的横坐标
 * @param textPartId
 * @param promise
 */
RCT_REMAP_METHOD(getY,getY:(NSString*)textPartId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextPart* textPart = [JSObjManager getObjWithKey:textPartId];
        double y = [textPart getY];
        resolve([NSNumber numberWithDouble:y]);
    } @catch (NSException *exception) {
        reject(@"JSTextPart",@"getY expection",nil);
    }
}
/**
 * 设置此文本子对象实例的锚点，其类型为 Point2D
 * @param textPartId
 * @param point2DId
 * @param promise
 */
RCT_REMAP_METHOD(setAnchorPoint,setAnchorPoint:(NSString*)textPartId ancher:(NSString*)ancherPointId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextPart* textPart = [JSObjManager getObjWithKey:textPartId];
        Point2D* ancherPnt = [JSObjManager getObjWithKey:ancherPointId];
        [textPart setAnchorPoint:ancherPnt];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTextPart",@"setAnchorPoint expection",nil);
    }
}
/**
 * 设置此文本子对象的旋转角度
 * @param textPartId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setRotation,setRotation:(NSString*)textPartId angle:(double)dRotateAngle resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextPart* textPart = [JSObjManager getObjWithKey:textPartId];
        [textPart setRotation:dRotateAngle];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTextPart",@"setRotation expection",nil);
    }
}
/**
 * 设置此文本子对象的文本内容
 * @param textPartId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setText,setText:(NSString*)textPartId text:(NSString*)strText resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        TextPart* textPart = [JSObjManager getObjWithKey:textPartId];
        [textPart setText:strText];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSTextPart",@"setText expection",nil);
    }
}


@end

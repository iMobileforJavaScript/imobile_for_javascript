//
//  JSSize2D.m
//  HelloWorldDemo
//
//  Created by 王子豪 on 2016/11/24.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSSize2D.h"
#import "SuperMap/Size2D.h"
#import "JSObjManager.h"
@implementation JSSize2D
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj,createObjByWidth:(double)width height:(double)height resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
 
    @try {
        Size2D* size = [[Size2D alloc]initWithWidth:width Height:height];
        if(size){
            NSInteger key = (NSInteger)size;
            [JSObjManager addObj:size];
            resolve(@(key).stringValue);
        }
    } @catch (NSException *exception) {
        reject(@"size2D",@"create size2D failed!!!",nil);
    }
}
/**
 * 返回一个新的 Size2D 对象，其宽度和高度值为大于等于指定 Size2D 对象对应值的最小整数值，例如给定 Size2D(2.3,6.8)，则生成的新的对象为 Size2D(3,7)
 * @param size2DId
 * @param promise
 */
RCT_REMAP_METHOD(ceiling,ceilingId:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        Size2D* size = [JSObjManager getObjWithKey:key];
        if(size){
            Size2D* sizet = [Size2D ceiling:size];
            resolve([JSObjManager addObj:sizet]);
        }
    } @catch (NSException *exception) {
        reject(@"size2D",@"ceiling size2D failed!!!",nil);
    }
}

/**
 * 返回当前 Size2D 对象的一个拷贝
 * @param size2DId
 * @param promise
 */

RCT_REMAP_METHOD(clone,cloneId:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        Size2D* size = [JSObjManager getObjWithKey:key];
        if(size){
            Size2D* sizet = [size clone];
            resolve([JSObjManager addObj:sizet]);
        }
    } @catch (NSException *exception) {
        reject(@"size2D",@"clone size2D failed!!!",nil);
    }
}


/**
 * 判定此 Size2D 是否与指定 Size2D 有相同的坐标
 * @param size2DId1
 * @param size2DId2
 * @param promise
 */

RCT_REMAP_METHOD(equals,equalsId:(NSString*)key equalsId:(NSString*)key2 resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        Size2D* size = [JSObjManager getObjWithKey:key];
        Size2D* size2 = [JSObjManager getObjWithKey:key2];
        if(size){
            BOOL b = [size equals:size2];
            resolve(@(b));
        }
    } @catch (NSException *exception) {
        reject(@"size2D",@"equals size2D failed!!!",nil);
    }
}

/**
 * 返回此 Size2D 的垂直分量，即高度
 * @param size2DId
 * @param promise
 */
RCT_REMAP_METHOD(getHeight,getHeightId:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        Size2D* size = [JSObjManager getObjWithKey:key];
        if(size){
            double sizet = size.height;
            resolve(@(sizet));
        }
    } @catch (NSException *exception) {
        reject(@"size2D",@"getHeight size2D failed!!!",nil);
    }
}
/**
 * 返回此 Size2D 的水平分量，即宽度
 * @param size2DId
 * @param promise
 */

RCT_REMAP_METHOD(getWidth,getWidthId:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        Size2D* size = [JSObjManager getObjWithKey:key];
        if(size){
            double sizet = size.width;
            resolve(@(sizet));
        }
    } @catch (NSException *exception) {
        reject(@"size2D",@"getWidth size2D failed!!!",nil);
    }
}
/**
 * 判断当前 Size2D 对象是否为空，即是否宽度和高度均为 -1.7976931348623157e+308
 * @param size2DId
 * @param promise
 */
RCT_REMAP_METHOD(isEmpty,isEmptyId:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        Size2D* size = [JSObjManager getObjWithKey:key];
        if(size){
            BOOL b = [size isEmpty];
            resolve(@(b));
        }
    } @catch (NSException *exception) {
        reject(@"size2D",@"isEmpty size2D failed!!!",nil);
    }
}
/**
 * 返回一个新的 Size2D 对象，其宽度和高度值是通过对给定 Size2D 对象的对应值进行四舍五入得到，例如给定 Size2D(2.3,6.8)， 则四舍五入后的新的对象为 Size2D(2,7)
 * @param size2DId
 * @param promise
 */
RCT_REMAP_METHOD(round,roundId:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        Size2D* size = [JSObjManager getObjWithKey:key];
        if(size){
            Size2D* sizet = [Size2D round:size];
            resolve([JSObjManager addObj:sizet]);
        }
    } @catch (NSException *exception) {
        reject(@"size2D",@"round size2D failed!!!",nil);
    }
}
/**
 * 设置此 Size2D 的垂直分量，即高度
 * @param size2DId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setHeight,setHeightId:(NSString*)key h:(double)h resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        Size2D* size = [JSObjManager getObjWithKey:key];
        if(size){
            [size setHeight:h];
            resolve(@(YES));
        }
    } @catch (NSException *exception) {
        reject(@"size2D",@"setHeight size2D failed!!!",nil);
    }
}
/**
 * 设置此 Size2D 的水平分量，即宽度
 * @param size2DId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setWidth,setWidthId:(NSString*)key  w:(double)w resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        Size2D* size = [JSObjManager getObjWithKey:key];
        if(size){
            [size setWidth:w];
            resolve(@(YES));
        }
    } @catch (NSException *exception) {
        reject(@"size2D",@"setWidth size2D failed!!!",nil);
    }
}
/**
 * 返回一个此 Size2D 对象宽度和高度的格式化字符串
 * @param size2DId
 * @param promise
 */

RCT_REMAP_METHOD(toString,toStringId:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        Size2D* size = [JSObjManager getObjWithKey:key];
        if(size){
           // Size2D* sizet = [size ];
            resolve(@"");
        }
    } @catch (NSException *exception) {
        reject(@"size2D",@"toString size2D failed!!!",nil);
    }
}
@end

//
//  JSSymbolMarker.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/16.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSSymbolMarker.h"
#import "SuperMap/SymbolMarker.h"
#import "SuperMap/SymbolMarkerStroke.h"
#import "SuperMap/Point2D.h"
#import "JSObjManager.h"

@implementation JSSymbolMarker
RCT_EXPORT_MODULE();

#pragma mark dispose() 释放该对象所占用的资源
RCT_REMAP_METHOD(dispose, disposeById:(NSString *)symbolId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolMarker* symbol = [JSObjManager getObjWithKey:symbolId];
        [symbol dispose];
        [JSObjManager removeObj:symbolId];
        
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"SymbolMarker", exception.reason, nil);
    }
}

#pragma mark computeDisplaySize(int displaySize) 计算出传入的符号在显示时的大小
RCT_REMAP_METHOD(computeDisplaySize, computeDisplaySizeById:(NSString *)symbolId symbolSize:(int)displaySize resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolMarker* symbol = [JSObjManager getObjWithKey:symbolId];
        int size = [symbol computeDisplaySize:displaySize];
        
        resolve([NSNumber numberWithInt:size]);
    } @catch (NSException *exception) {
        reject(@"SymbolMarker", exception.reason, nil);
    }
}

#pragma mark computeSymbolSize(int symbolSize) 计算出传入的显示大小对应设置的符号大小
RCT_REMAP_METHOD(computeSymbolSize, computeSymbolSizeById:(NSString *)symbolId symbolSize:(int)symbolSize resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolMarker* symbol = [JSObjManager getObjWithKey:symbolId];
        int size = [symbol computeSymbolSize:symbolSize];
        
        resolve([NSNumber numberWithInt:size]);
    } @catch (NSException *exception) {
        reject(@"SymbolMarker", exception.reason, nil);
    }
}

#pragma mark getCount() 返回点符号对象的画笔总数
RCT_REMAP_METHOD(getCount, getCountById:(NSString *)symbolId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolMarker* symbol = [JSObjManager getObjWithKey:symbolId];
        int count = symbol.getStrokeCount;
        
        resolve([NSNumber numberWithInt:count]);
    } @catch (NSException *exception) {
        reject(@"SymbolMarker", exception.reason, nil);
    }
}

#pragma mark getOrigin() 返回符号的起始位置
RCT_REMAP_METHOD(getOrigin, getOriginById:(NSString *)symbolId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolMarker* symbol = [JSObjManager getObjWithKey:symbolId];
        Point2D* point = symbol.origin;
        double x = point.x;
        double y = point.y;
        
        resolve(@{
                  @"x": [NSNumber numberWithDouble:x],
                  @"y": [NSNumber numberWithDouble:y],
                  });
    } @catch (NSException *exception) {
        reject(@"SymbolMarker", exception.reason, nil);
    }
}

#pragma mark setOrigin(double x, double y) 设置返回符号的起始位置
RCT_REMAP_METHOD(setOrigin, setOriginById:(NSString *)symbolId x:(double)x y:(double)y resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolMarker* symbol = [JSObjManager getObjWithKey:symbolId];
        Point2D* point = [[Point2D alloc] initWithX:x Y:y];
        symbol.origin = point;
        
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"SymbolMarker", exception.reason, nil);
    }
}

#pragma mark get(int index) 返回指定索引处的画笔
//RCT_REMAP_METHOD(get, getById:(NSString *)symbolId index:(int)index resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        SymbolMarker* symbol = [JSObjManager getObjWithKey:symbolId];
//        SymbolMarkerStroke* stroke = [symbol getStroke:index];
//
//        resolve(@1);
//    } @catch (NSException *exception) {
//        reject(@"SymbolMarker", exception.reason, nil);
//    }
//}
@end

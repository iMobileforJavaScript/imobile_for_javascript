//
//  JSBufferAnalyst.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/19.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSBufferAnalyst.h"

#import "SuperMap/BufferAnalyst.h"
#import "JSObjManager.h"
@implementation JSBufferAnalyst
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(createBuffer,createBufferBySourceId:(NSString*)sourceId resultId:(NSString*)resultId bufferAnalystParaId:(NSString*)paraId isUnion:(BOOL)isUnion isAttributeRetained:(BOOL)isAttributeRetained resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        DatasetVector* sourceDataSet = [JSObjManager getObjWithKey:sourceId];
        DatasetVector* resultDataSet = [JSObjManager getObjWithKey:resultId];
        BufferAnalystParameter* para = [JSObjManager getObjWithKey:paraId];
        BOOL create = [BufferAnalyst createBufferSourceVector:sourceDataSet ResultVector:resultDataSet BufferParam:para IsUnion:isUnion IsAttributeRetained:isAttributeRetained];
        NSNumber* nsCreate = [NSNumber numberWithBool:create];
        resolve(@{@"isCreate":nsCreate});
    } @catch (NSException *exception) {
        reject(@"BufferAnalyst",@"create Buffer exception",nil);
    }
}

RCT_REMAP_METHOD(createLineOneSideMultiBuffer,createLineOneSideMultiBufferBySourceId:(NSString*)sourceId resultId:(NSString*)resultId arrBufferRadius:(NSArray*)arrBufferRadius bufferRadiusUnit:(int)bufferRadiusUnit semicircleSegment:(int)semicircleSegment isLeft:(BOOL)isLeft isUnion:(BOOL)isUnion isAttributeRetained:(BOOL)isAttributeRetained isRing:(BOOL)isRing resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        DatasetVector* sourceDataSet = [JSObjManager getObjWithKey:sourceId];
        DatasetVector* resultDataSet = [JSObjManager getObjWithKey:resultId];
        BOOL create = [BufferAnalyst createLineOneSideMultiBufferSourceVector:sourceDataSet ResultVector:resultDataSet ArrBufferRadius:arrBufferRadius BufferRadiusUnit:bufferRadiusUnit SemicircleSegment:semicircleSegment IsLeft:isLeft IsUnion:isUnion IsAttributeRetained:isAttributeRetained IsRing:isRing];
        NSNumber* nsCreate = [NSNumber numberWithBool:create];
        resolve(@{@"isCreate":nsCreate});
    } @catch (NSException *exception) {
        reject(@"BufferAnalyst",@"create Line One Side MultiBuffer exception",nil);
    }
}

RCT_REMAP_METHOD(createMultiBuffer,createMultiBufferBySourceId:(NSString*)sourceId resultId:(NSString*)resultId arrBufferRadius:(NSArray*)arrBufferRadius bufferRadiusUnit:(int)bufferRadiusUnit semicircleSegment:(int)semicircleSegment isUnion:(BOOL)isUnion isAttributeRetained:(BOOL)isAttributeRetained isRing:(BOOL)isRing resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        DatasetVector* sourceDataSet = [JSObjManager getObjWithKey:sourceId];
        DatasetVector* resultDataSet = [JSObjManager getObjWithKey:resultId];
        BOOL create = [BufferAnalyst createMultiBufferSourceVector:sourceDataSet ResultVector:resultDataSet ArrBufferRadius:arrBufferRadius BufferRadiusUnit:bufferRadiusUnit SemicircleSegment:semicircleSegment IsUnion:isUnion IsAttributeRetained:isAttributeRetained IsRing:isRing];
        NSNumber* nsCreate = [NSNumber numberWithBool:create];
        resolve(@{@"isCreate":nsCreate});
    } @catch (NSException *exception) {
        reject(@"BufferAnalyst",@"create Multi Buffer exception",nil);
    }
}
@end

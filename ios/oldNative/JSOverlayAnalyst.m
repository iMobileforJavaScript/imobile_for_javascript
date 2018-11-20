//
//  JSOverlayAnalyst.m
//  Supermap
//
//  Created by 王子豪 on 2017/4/20.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSOverlayAnalyst.h"
#import "JSObjManager.h"
#import "SuperMap/OverlayAnalyst.h"
#import "SuperMap/OverlayAnalystParameter.h"



@implementation JSOverlayAnalyst

RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(clip,clipBydsVectorId:(NSString*)dsVectorId andClipDsVectorId:(NSString*)clipDsVectorId andResult:(NSString*)resultDsVectorId andAnalystParaId:(NSString*)analystParaId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    DatasetVector* dsVector = [JSObjManager getObjWithKey:dsVectorId];
    DatasetVector* clipDsVector = [JSObjManager getObjWithKey:clipDsVectorId];
    DatasetVector* resultDsVector = [JSObjManager getObjWithKey:resultDsVectorId];
    OverlayAnalystParameter* analystPara = [JSObjManager getObjWithKey:analystParaId];
    if (dsVector&&clipDsVector&&resultDsVector) {
        BOOL clipped = [OverlayAnalyst clip:dsVector clipDataset:clipDsVector resultDataset:resultDsVector parameter:analystPara];
        NSNumber* nsBool = [NSNumber numberWithBool:clipped];
        resolve(@{@"clipped":nsBool});
    }else{
        reject(@"OverlayAnalyst",@"clip failed!!!",nil);
    }
}

RCT_REMAP_METHOD(erase,eraseBydsVectorId:(NSString*)dsVectorId andEraseDsVectorId:(NSString*)eraseDsVectorId andResult:(NSString*)resultDsVectorId andAnalystParaId:(NSString*)analystParaId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        DatasetVector* dsVector = [JSObjManager getObjWithKey:dsVectorId];
        DatasetVector* eraseDsVector = [JSObjManager getObjWithKey:eraseDsVectorId];
        DatasetVector* resultDsVector = [JSObjManager getObjWithKey:resultDsVectorId];
        OverlayAnalystParameter* analystPara = [JSObjManager getObjWithKey:analystParaId];
        if (dsVector&&eraseDsVector&&resultDsVector) {
            BOOL erased = [OverlayAnalyst erase:dsVector eraseDataset:eraseDsVector resultDataset:resultDsVector parameter:analystPara];
            NSNumber* nsBool = [NSNumber numberWithBool:erased];
            resolve(@{@"erased":nsBool});
        }
    } @catch (NSException *exception) {
        reject(@"OverlayAnalyst",@"erase failed!!!",nil);
    }
}

RCT_REMAP_METHOD(identity,identityBydsVectorId:(NSString*)dsVectorId andIdentityDsVectorId:(NSString*)identityDsVectorId andResult:(NSString*)resultDsVectorId andAnalystParaId:(NSString*)analystParaId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        DatasetVector* dsVector = [JSObjManager getObjWithKey:dsVectorId];
        DatasetVector* identityDsVector = [JSObjManager getObjWithKey:identityDsVectorId];
        DatasetVector* resultDsVector = [JSObjManager getObjWithKey:resultDsVectorId];
        OverlayAnalystParameter* analystPara = [JSObjManager getObjWithKey:analystParaId];
        if (dsVector&&identityDsVector&&resultDsVector) {
            BOOL identified = [OverlayAnalyst identity:dsVector identityDataset:identityDsVector resultDataset:resultDsVector parameter:analystPara];
            NSNumber* nsBool = [NSNumber numberWithBool:identified];
            resolve(@{@"identified":nsBool});
        }
    } @catch (NSException *exception) {
        reject(@"OverlayAnalyst",@"identity failed!!!",nil);
    }
}

RCT_REMAP_METHOD(intersect,intersectBydsVectorId:(NSString*)dsVectorId andIntersectDsVectorId:(NSString*)intersectDsVectorId andResult:(NSString*)resultDsVectorId andAnalystParaId:(NSString*)analystParaId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    DatasetVector* dsVector = [JSObjManager getObjWithKey:dsVectorId];
    DatasetVector* intersectDsVector = [JSObjManager getObjWithKey:intersectDsVectorId];
    DatasetVector* resultDsVector = [JSObjManager getObjWithKey:resultDsVectorId];
    OverlayAnalystParameter* analystPara = [JSObjManager getObjWithKey:analystParaId];
    if (dsVector&&intersectDsVector&&resultDsVector) {
        BOOL intersected = [OverlayAnalyst intersect:dsVector intersectDataset:intersectDsVector resultDataset:resultDsVector parameter:analystPara];
        NSNumber* nsBool = [NSNumber numberWithBool:intersected];
        resolve(@{@"intersected":nsBool});
    }else{
        reject(@"OverlayAnalyst",@"intersect failed!!!",nil);
    }
}

RCT_REMAP_METHOD(union,unionBydsVectorId:(NSString*)dsVectorId andUnionDsVectorId:(NSString*)unionDsVectorId andResult:(NSString*)resultDsVectorId andAnalystParaId:(NSString*)analystParaId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    DatasetVector* dsVector = [JSObjManager getObjWithKey:dsVectorId];
    DatasetVector* unionDsVector = [JSObjManager getObjWithKey:unionDsVectorId];
    DatasetVector* resultDsVector = [JSObjManager getObjWithKey:resultDsVectorId];
    OverlayAnalystParameter* analystPara = [JSObjManager getObjWithKey:analystParaId];
    if (dsVector&&unionDsVector&&resultDsVector) {
        BOOL unioned = [OverlayAnalyst union:dsVector unionDataset:unionDsVector resultDataset:resultDsVector parameter:analystPara];
        NSNumber* nsBool = [NSNumber numberWithBool:unioned];
        resolve(@{@"unioned":nsBool});
    }else{
        reject(@"OverlayAnalyst",@"union failed!!!",nil);
    }
}

RCT_REMAP_METHOD(update,updateBydsVectorId:(NSString*)dsVectorId andUpdateDsVectorId:(NSString*)updateDsVectorId andResult:(NSString*)resultDsVectorId andAnalystParaId:(NSString*)analystParaId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    DatasetVector* dsVector = [JSObjManager getObjWithKey:dsVectorId];
    DatasetVector* updateDsVector = [JSObjManager getObjWithKey:updateDsVectorId];
    DatasetVector* resultDsVector = [JSObjManager getObjWithKey:resultDsVectorId];
    OverlayAnalystParameter* analystPara = [JSObjManager getObjWithKey:analystParaId];
    if (dsVector&&updateDsVector&&resultDsVector) {
        BOOL updated = [OverlayAnalyst update:dsVector updateDataset:updateDsVector resultDataset:resultDsVector parameter:analystPara];
        NSNumber* nsBool = [NSNumber numberWithBool:updated];
        resolve(@{@"updated":nsBool});
    }else{
        reject(@"OverlayAnalyst",@"update failed!!!",nil);
    }
}

RCT_REMAP_METHOD(xOR,xORBydsVectorId:(NSString*)dsVectorId andXORDsVectorId:(NSString*)xORDsVectorId andResult:(NSString*)resultDsVectorId andAnalystParaId:(NSString*)analystParaId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    DatasetVector* dsVector = [JSObjManager getObjWithKey:dsVectorId];
    DatasetVector* xORDsVector = [JSObjManager getObjWithKey:xORDsVectorId];
    DatasetVector* resultDsVector = [JSObjManager getObjWithKey:resultDsVectorId];
    OverlayAnalystParameter* analystPara = [JSObjManager getObjWithKey:analystParaId];
    if (dsVector&&xORDsVector&&resultDsVector) {
        BOOL finished = [OverlayAnalyst xOR:dsVector xORDataset:xORDsVector resultDataset:resultDsVector parameter:analystPara];
        NSNumber* nsBool = [NSNumber numberWithBool:finished];
        resolve(@{@"finished":nsBool});
    }else{
        reject(@"OverlayAnalyst",@"update failed!!!",nil);
    }
}

@end

//
//  JSOverlayAnalystParameter.m
//  Supermap
//
//  Created by 王子豪 on 2017/4/20.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSOverlayAnalystParameter.h"
#import "SuperMap/OverlayAnalystParameter.h"
#import "JSObjManager.h"

@implementation JSOverlayAnalystParameter

RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(createObj,createOverlayAnalystParaObjByresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    OverlayAnalystParameter* overlayAnalystPara = [[OverlayAnalystParameter alloc]init];
    if (overlayAnalystPara) {
        [JSObjManager addObj:overlayAnalystPara];
        NSInteger paraKey = (NSInteger)overlayAnalystPara;
        resolve(@{@"overlayAnalystParameterId":@(paraKey).stringValue});
    }else{
        reject(@"OverlayAnalystParameter",@"createObj failed!!!",nil);
    }
}

RCT_REMAP_METHOD(setTolerance,setToleranceByOverlayAnalystParameterId:(NSString*)paraId rate:(double)rate resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    OverlayAnalystParameter* overlayAnalystPara = [JSObjManager getObjWithKey:paraId];
    if (overlayAnalystPara) {
        [overlayAnalystPara setTolerance:rate];
        resolve(@{@"overlayAnalystParameterId":@"setted"});
    }else{
        reject(@"OverlayAnalystParameter",@"setTolerance failed!!!",nil);
    }
}

RCT_REMAP_METHOD(getTolerance,getToleranceByOverlayAnalystParameterId:(NSString*)paraId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    OverlayAnalystParameter* overlayAnalystPara = [JSObjManager getObjWithKey:paraId];
    if (overlayAnalystPara) {
        double rate = [overlayAnalystPara getTolerance];
        NSNumber* nsRate = [NSNumber numberWithDouble:rate];
        resolve(@{@"tolerance":nsRate});
    }else{
        reject(@"OverlayAnalystParameter",@"getTolerance failed!!!",nil);
    }
}

RCT_REMAP_METHOD(getOperationRetainedFields,getOperationRetainedFieldsByOverlayAnalystParameterId:(NSString*)paraId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    OverlayAnalystParameter* overlayAnalystPara = [JSObjManager getObjWithKey:paraId];
    if (overlayAnalystPara) {
        NSMutableArray* operationRetainedFields = [overlayAnalystPara getOperationRetainedFields];
        resolve(@{@"fields":operationRetainedFields});
    }else{
        reject(@"OverlayAnalystParameter",@"getOperationRetainedFields failed!!!",nil);
    }
}

RCT_REMAP_METHOD(setOperationRetainedFields,setOperationRetainedFieldsByOverlayAnalystParameterId:(NSString*)paraId fields:(NSArray*)fields resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    OverlayAnalystParameter* overlayAnalystPara = [JSObjManager getObjWithKey:paraId];
    if (overlayAnalystPara) {
        NSMutableArray* mutableFields = [NSMutableArray arrayWithArray:fields];
        [overlayAnalystPara setOperationRetainedFields:mutableFields];
        resolve(@"setted");
    }else{
        reject(@"OverlayAnalystParameter",@"setOperationRetainedFields failed!!!",nil);
    }
}

RCT_REMAP_METHOD(getSourceRetainedFields,getSourceRetainedFieldsByOverlayAnalystParameterId:(NSString*)paraId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    OverlayAnalystParameter* overlayAnalystPara = [JSObjManager getObjWithKey:paraId];
    if (overlayAnalystPara) {
        NSMutableArray* sourceRetainedFields = [overlayAnalystPara getSourceRetainedFields];
        resolve(@{@"fields":sourceRetainedFields});
    }else{
        reject(@"OverlayAnalystParameter",@"getOperationRetainedFields failed!!!",nil);
    }
}

RCT_REMAP_METHOD(setSourceRetainedFields,setSourceRetainedFieldsByOverlayAnalystParameterId:(NSString*)paraId fields:(NSArray*)fields resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    OverlayAnalystParameter* overlayAnalystPara = [JSObjManager getObjWithKey:paraId];
    if (overlayAnalystPara) {
        NSMutableArray* mutableFields = [NSMutableArray arrayWithArray:fields];
        [overlayAnalystPara setSourceRetainedFields:mutableFields];
        resolve(@"setted");
    }else{
        reject(@"OverlayAnalystParameter",@"setSourceRetainedFields failed!!!",nil);
    }
}
@end

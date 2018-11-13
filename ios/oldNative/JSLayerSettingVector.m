//
//  JSLayerSettingVector.m
//  HelloWorldDemo
//
//  Created by 王子豪 on 2016/11/22.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSLayerSettingVector.h"
#import "SuperMap/LayerSettingVector.h"
#import "JSObjManager.h"
@implementation JSLayerSettingVector
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(createObj,resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  LayerSettingVector* LSV = [[LayerSettingVector alloc]init];
  if(LSV){
    NSInteger key = (NSInteger)LSV;
    [JSObjManager addObj:LSV];
    resolve(@{@"_layerSettingVectorId_":@(key).stringValue});
  }else{
    reject(@"layerSettingVector",@"create obj failed!!!",nil);
  }
}

RCT_REMAP_METHOD(getStyle,getStyleById:(NSString*)LSVId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
   LayerSettingVector* LSV = [JSObjManager getObjWithKey:LSVId];
  if(LSV.geoStyle){
    NSInteger key = (NSInteger)LSV.geoStyle;
    [JSObjManager addObj:LSV.geoStyle];
    resolve(@{@"geoStyleId":@(key).stringValue});
  }else{
    reject(@"layerSettingVector",@"get geoStyle failed!!!",nil);
  }
}

RCT_REMAP_METHOD(setStyle,setStyleById:(NSString*)LSVId geoStyleId:(NSString*)geoStyleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  LayerSettingVector* LSV = [JSObjManager getObjWithKey:LSVId];
  GeoStyle* style = [JSObjManager getObjWithKey:geoStyleId];
    if (LSV&&style) {
        LSV.geoStyle = style;
        resolve(@"style setted");
    }else{
        reject(@"layerSettingVector",@"set Style failed!!!",nil);
    }
}

RCT_REMAP_METHOD(getType,getTypeById:(NSString*)LSVId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    LayerSettingVector* LSV = [JSObjManager getObjWithKey:LSVId];
    if(LSV){
        LayerSettingType type = LSV.layerType;
        NSNumber* typeNum = [NSNumber numberWithInteger:(NSInteger)type];
        resolve(@{@"type":typeNum});
    }else{
        reject(@"layerSettingVector",@"get Type failed!!!",nil);
    }
}
@end

//
//  JSLayerSetting.m
//  HelloWorldDemo
//
//  Created by 王子豪 on 2016/11/22.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSLayerSetting.h"
#import "SuperMap/LayerSetting.h"
#import "SuperMap/LayerSettingVector.h"
#import "SuperMap/LayerSettingGrid.h"
#import "SuperMap/LayerSettingImage.h"
#import "JSObjManager.h"
@implementation JSLayerSetting
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(getType,getTypeByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  id<LayerSetting> layerSetting = [JSObjManager getObjWithKey:key];
  if ([layerSetting isKindOfClass:[LayerSettingVector class]]) {
      NSNumber* vectorNum = [NSNumber numberWithInt:0];
      resolve(vectorNum);
  }else if([layerSetting isKindOfClass:[LayerSettingGrid class]]){
      NSNumber* gridNum = [NSNumber numberWithInt:2];
      resolve(gridNum);
  }else if([layerSetting isKindOfClass:[LayerSettingImage class]]){
      NSNumber* rasterNum = [NSNumber numberWithInt:1];
      resolve(rasterNum);
  }else{
    reject(@"LayerSetting",@"get type failed!!!",nil);
  }
}

RCT_REMAP_METHOD(toLayerSettingVector,toLayerSettingVectorByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    id<LayerSetting> layerSetting = [JSObjManager getObjWithKey:key];
    LayerSettingVector* lsv = (LayerSettingVector*)  layerSetting;
    if (lsv) {
        NSInteger nsLSV = (NSInteger)lsv;
        [JSObjManager addObj:lsv];
        resolve(@{@"_layerSettingVectorId_":@(nsLSV).stringValue});
    }else{
      reject(@"LayerSetting",@"get type failed!!!",nil);
    }
}
@end

//
//  JSLayers.m
//  rnTest
//
//  Created by imobile-xzy on 16/7/5.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSLayers.h"
#import "SuperMap/Layers.h"
#import "JSObjManager.h"

@implementation JSLayers
//注册为Native模块
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(add,userKey:(NSString*)key dataSetKey:(NSString*)dataSetKey ToHead:(BOOL)toHead resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  
  Layers* layers = [JSObjManager getObjWithKey:key];
  Dataset* dataSet = [JSObjManager getObjWithKey:dataSetKey];
  if(layers && dataSet){
    
    Layer* layer = [layers addDataset:dataSet ToHead:toHead];
    NSInteger key = (NSInteger)layer;
    [JSObjManager addObj:layer];
    resolve(@{@"layerId":@(key).stringValue});
   // resolve(@(key).stringValue);
  }else
    reject(@"Layers",@"add:layers or dataset not exeist!!!",nil);
}

RCT_REMAP_METHOD(get,getKey:(NSString*)key  index:(int)index resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  
  Layers* layers = [JSObjManager getObjWithKey:key];
  if(layers){
    Layer* layer = [layers getLayerAtIndex:index];
    [JSObjManager addObj:layer];
    NSInteger key = (NSInteger)layer;
    resolve(@{@"layerId":@(key).stringValue});
  }else
    reject(@"Layers",@"get:Maps not exeist!!!",nil);
}
  
  RCT_REMAP_METHOD(getByName,getByNameKey:(NSString*)key  name:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    Layers* layers = [JSObjManager getObjWithKey:key];
    if(layers){
      Layer* layer = [layers getLayerWithName:name];
      [JSObjManager addObj:layer];
      NSInteger key = (NSInteger)layer;
      resolve(@{@"layerId":@(key).stringValue});
    }else
    reject(@"Layers",@"get:Maps not exeist!!!",nil);
  }

RCT_REMAP_METHOD(getCount,getCountByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Layers* layers = [JSObjManager getObjWithKey:key];
        int count = [layers getCount];
        NSNumber* num = [NSNumber numberWithInt:count];
        resolve(@{@"count":num});
    } @catch(NSException* exception) {
        reject(@"Layers", exception.reason, nil);
    }
}
@end

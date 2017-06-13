//
//  JSLayer.m
//  rnTest
//
//  Created by imobile-xzy on 16/7/5.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSLayer.h"
#import "JSObjManager.h"
#import "SuperMap/LayerSettingVector.h"
#import "SuperMap/Datasource.h"
#import "SuperMap/Layer.h"

@implementation JSLayer
//注册为Native模块
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(setEditable,setEditableKey:(NSString*)key editable:(BOOL)editable resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Layer* layer = [JSObjManager getObjWithKey:key];
  if(layer){
    layer.editable = editable;
    resolve(@"editable have been setted");
  }else{
    reject(@"Layer",@"set editable failed!",nil);
  }
}

RCT_REMAP_METHOD(getEditable,getEditableByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Layer* layer = [JSObjManager getObjWithKey:key];
    if(layer){
        BOOL isEditable = layer.editable;
        NSNumber* nsBool = [NSNumber numberWithBool:isEditable];
        resolve(@{@"isEditable":nsBool});
    }else{
        reject(@"Layer",@"get editable failed!",nil);
    }
}


RCT_REMAP_METHOD(getName,getNameByKey:(NSString*)key andIndex:(int)index resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Layer* layer = [JSObjManager getObjWithKey:key];
  if(layer.name){
    resolve(@{@"layerName":layer.name});
  }else{
  reject(@"Layer",@"get name failed!",nil);
  }
}

RCT_REMAP_METHOD(getDataset,getDatasetByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Layer* layer = [JSObjManager getObjWithKey:key];
  if(layer.dataset){
    NSInteger key = (NSInteger)layer.dataset;
    [JSObjManager addObj:layer.dataset];
    resolve(@{@"datasetId":@(key).stringValue});
  }else{
  reject(@"Layer",@"get dataset failed!",nil);
  }
}

RCT_REMAP_METHOD(setDataset,setDatasetByKey:(NSString*)key andDatasetId:(NSString*)datasetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Layer* layer = [JSObjManager getObjWithKey:key];
  Dataset* dataset = [JSObjManager getObjWithKey:datasetId];
  if(dataset){
    layer.editable = TRUE;
//    layer.dataset = dataset;
      // read only propety
    NSInteger key = (NSInteger)layer.dataset;
    [JSObjManager addObj:layer.dataset];
    resolve(@{@"datasetId":@(key).stringValue});
  }else
  reject(@"Layer",@"get dataset failed!!!",nil);
}

RCT_REMAP_METHOD(getSelection,getSelectionByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Layer* layer = [JSObjManager getObjWithKey:key];
  Selection* selection = [layer getSelection];
  if(selection){
    NSInteger key = (NSInteger)selection;
    [JSObjManager addObj:selection];
    resolve(@{@"selectionId":@(key).stringValue});
  }else{
  reject(@"Layer",@"get selection failed!",nil);
  }
}

RCT_REMAP_METHOD(setSelectable,setSelectableByKey:(NSString*)layerId boolBit:(BOOL)boolBit resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Layer* layer = [JSObjManager getObjWithKey:layerId];
    if(layer){
        layer.selectable = boolBit;
        resolve(@"selectable have been setted!");
    }else{
        reject(@"Layer",@"set selectable failed!",nil);
    }
}

RCT_REMAP_METHOD(isSelectable,isSelectableByKey:(NSString*)layerId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Layer* layer = [JSObjManager getObjWithKey:layerId];
    if(layer){
        BOOL selectable = layer.selectable;
        NSNumber* nsSelectable = [NSNumber numberWithBool:selectable];
        resolve(@{@"selectable":nsSelectable});
    }else{
        reject(@"Layer",@"set selectable failed!",nil);
    }
}

RCT_REMAP_METHOD(getVisible,getVisibleByKey:(NSString*)layerId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Layer* layer = [JSObjManager getObjWithKey:layerId];
    if(layer){
        BOOL isVisable = layer.visible;
        NSNumber* nsVisable = [NSNumber numberWithBool:isVisable];
        resolve(nsVisable);
    }else{
        reject(@"Layer",@"set visable failed!",nil);
    }
}

RCT_REMAP_METHOD(setVisible,setVisibleByKey:(NSString*)layerId boolBit:(BOOL)boolBit resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Layer* layer = [JSObjManager getObjWithKey:layerId];
    if(layer){
        layer.visible = boolBit;
        resolve(@"visable have been setted!");
    }else{
        reject(@"Layer",@"set visable failed!",nil);
    }
}

RCT_REMAP_METHOD(getAdditionalSetting,getAdditionalSettingByKey:(NSString*)layerId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Layer* layer = [JSObjManager getObjWithKey:layerId];
    if(layer){
        id<LayerSetting> layerSetting = layer.layerSetting;
        NSInteger nsLayerSetting = (NSInteger)layerSetting;
        [JSObjManager addObj:layerSetting];
        resolve(@{@"_layerSettingId_":@(nsLayerSetting).stringValue});
    }else{
        reject(@"Layer",@"get Additional Setting failed!",nil);
    }
}

RCT_REMAP_METHOD(setAdditionalSetting,setAdditionalSettingByKey:(NSString*)layerId andLayerSettingId:(NSString*)layerSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Layer* layer = [JSObjManager getObjWithKey:layerId];
    id<LayerSetting> layerSetting = [JSObjManager getObjWithKey:layerSettingId];
    if(layerSetting){
        layer.layerSetting = layerSetting;
        resolve(@"layerSetting setted");
    }else{
        reject(@"Layer",@"get Additional Setting failed!",nil);
    }
}
@end

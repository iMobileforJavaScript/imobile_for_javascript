/*********************************************************************************
 Copyright © SuperMap. All rights reserved.
 Author: imobile-xzy
 E-mail: pridehao@gmail.com
 Description: setDataset()接口目前无法设置，空接口
 **********************************************************************************/

#import "JSLayer.h"
#import "JSObjManager.h"
#import "SuperMap/LayerSettingVector.h"
#import "SuperMap/LayerSettingImage.h"
#import "SuperMap/LayerSettingGrid.h"
#import "SuperMap/Datasource.h"
#import "SuperMap/Layer.h"

@implementation JSLayer

RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(setEditable,setEditableKey:(NSString*)key editable:(BOOL)editable resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Layer* layer = [JSObjManager getObjWithKey:key];
        layer.editable = editable;
        NSNumber* num = [NSNumber numberWithBool:true];
        resolve(num);
    } @catch (NSException *exception) {
        reject(@"Layer",@"setEditable() failed.",nil);
    }
}

RCT_REMAP_METHOD(getEditable,getEditableByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Layer* layer = [JSObjManager getObjWithKey:key];
        BOOL isEditable = layer.editable;
        NSNumber* nsBool = [NSNumber numberWithBool:isEditable];
        resolve(@{@"isEditable":nsBool});
    } @catch (NSException *exception) {
        reject(@"Layer",@"getEditable() failed.",nil);
    }
}


RCT_REMAP_METHOD(getName,getNameByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Layer* layer = [JSObjManager getObjWithKey:key];
        resolve(@{@"layerName":layer.name});
    } @catch (NSException *exception) {
        reject(@"Layer",@"getName() failed.",nil);
    }
}

RCT_REMAP_METHOD(getDataset,getDatasetByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Layer* layer = [JSObjManager getObjWithKey:key];
        NSInteger key = (NSInteger)layer.dataset;
        [JSObjManager addObj:layer.dataset];
        resolve(@{@"datasetId":@(key).stringValue});
    } @catch (NSException *exception) {
        reject(@"Layer",@"getDataset() failed.",nil);
    }
}

RCT_REMAP_METHOD(setDataset,setDatasetByKey:(NSString*)key andDatasetId:(NSString*)datasetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSException* exception = [NSException exceptionWithName:@"com.supermap.exception" reason:@"该方法暂不支持iOS设备。" userInfo:nil];
        @throw exception;
        /*
        Layer* layer = [JSObjManager getObjWithKey:key];
        Dataset* dataset = [JSObjManager getObjWithKey:datasetId];
        layer.editable = TRUE;
        // layer.dataset = dataset;
        // read only propety
        NSInteger key = (NSInteger)layer.dataset;
        [JSObjManager addObj:layer.dataset];
        resolve(@{@"datasetId":@(key).stringValue});
         */
    } @catch (NSException *exception) {
        reject(@"Layer",@"setDataset() failed.",nil);
    }
}

RCT_REMAP_METHOD(getSelection,getSelectionByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Layer* layer = [JSObjManager getObjWithKey:key];
        Selection* selection = [layer getSelection];
        NSInteger key = (NSInteger)selection;
        [JSObjManager addObj:selection];
        resolve(@{@"selectionId":@(key).stringValue});
    } @catch (NSException *exception) {
        reject(@"Layer",@"getSelection() failed.",nil);
    }
}

RCT_REMAP_METHOD(setSelectable,setSelectableByKey:(NSString*)layerId boolBit:(BOOL)boolBit resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Layer* layer = [JSObjManager getObjWithKey:layerId];
        layer.selectable = boolBit;
        NSNumber* num = [NSNumber numberWithBool:true];
        resolve(num);
    } @catch (NSException *exception) {
        reject(@"Layer",@"setSelectable() failed.",nil);
    }
}

RCT_REMAP_METHOD(isSelectable,isSelectableByKey:(NSString*)layerId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Layer* layer = [JSObjManager getObjWithKey:layerId];
        BOOL selectable = layer.selectable;
        NSNumber* nsSelectable = [NSNumber numberWithBool:selectable];
        resolve(@{@"selectable":nsSelectable});
    } @catch (NSException *exception) {
        reject(@"Layer",@"isSelectable() failed.",nil);
    }
}

RCT_REMAP_METHOD(getVisible,getVisibleByKey:(NSString*)layerId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Layer* layer = [JSObjManager getObjWithKey:layerId];
        BOOL isVisable = layer.visible;
        NSNumber* nsVisable = [NSNumber numberWithBool:isVisable];
        resolve(nsVisable);
    } @catch (NSException *exception) {
        reject(@"Layer",@"getVisible() failed.",nil);
    }
}

RCT_REMAP_METHOD(setVisible,setVisibleByKey:(NSString*)layerId boolBit:(BOOL)boolBit resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Layer* layer = [JSObjManager getObjWithKey:layerId];
        layer.visible = boolBit;
        NSNumber* num = [NSNumber numberWithBool:true];
        resolve(num);
    } @catch (NSException *exception) {
        reject(@"Layer",@"setVisible() failed.",nil);
    }
}

RCT_REMAP_METHOD(getAdditionalSetting,getAdditionalSettingByKey:(NSString*)layerId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Layer* layer = [JSObjManager getObjWithKey:layerId];
        NSNumber* typeNum;
        id<LayerSetting> layerSetting = layer.layerSetting;
        NSInteger nsLayerSetting = (NSInteger)layerSetting;
        [JSObjManager addObj:layerSetting];
        if ([layerSetting isKindOfClass:[LayerSettingVector class]]) {
            typeNum = [NSNumber numberWithInt:0];
        }else if ([layerSetting isKindOfClass:[LayerSettingImage class]]){
            typeNum = [NSNumber numberWithInt:1];
        }else{
            typeNum = [NSNumber numberWithInt:2];
        }
        resolve(@{@"_layerSettingId_":@(nsLayerSetting).stringValue,@"type":typeNum});
    } @catch (NSException *exception) {
        reject(@"Layer",@"getAdditionalSetting() failed.",nil);
    }
}

RCT_REMAP_METHOD(setAdditionalSetting,setAdditionalSettingByKey:(NSString*)layerId andLayerSettingId:(NSString*)layerSettingId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Layer* layer = [JSObjManager getObjWithKey:layerId];
        id<LayerSetting> layerSetting = [JSObjManager getObjWithKey:layerSettingId];
        layer.layerSetting = layerSetting;
        NSNumber* num = [NSNumber numberWithBool:true];
        resolve(num);
    } @catch (NSException *exception) {
        reject(@"Layer",@"setAdditionalSetting() failed.",nil);
    }
}
@end

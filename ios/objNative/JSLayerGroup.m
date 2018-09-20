//
//  JSLayerGroup.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/9/14.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSLayerGroup.h"
#import "SuperMap/LayerGroup.h"
#import "SuperMap/Layer.h"
#import "SuperMap/Dataset.h"
#import "SuperMap/Theme.h"
#import "JSObjManager.h"

@implementation JSLayerGroup
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(add, addById:(NSString *)layerGroupId layerId:(NSString *)layerId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        LayerGroup* layerGroup = [JSObjManager getObjWithKey:layerGroupId];
        Layer* layer = [JSObjManager getObjWithKey:layerId];
        
        [layerGroup add:layer];
        
        NSNumber* number =[NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSLayerGroup", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(addGroup, addGroupById:(NSString *)layerGroupId layerGroupName:(NSString *)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        LayerGroup* layerGroup = [JSObjManager getObjWithKey:layerGroupId];
        LayerGroup* newGroup = [layerGroup addGroup:name];
        
        NSString* newId = [JSObjManager addObj:newGroup];
        
        resolve(newId);
    } @catch (NSException *exception) {
        reject(@"JSLayerGroup", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(get, getById:(NSString *)layerGroupId index:(int)index resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        LayerGroup* layerGroup = [JSObjManager getObjWithKey:layerGroupId];
        Layer* layer = [layerGroup getLayer:index];
        NSString* layerId = [JSObjManager addObj:layer];
        int themeType = (int)layer.theme.themeType;
        
        NSString* datasetName;
        if (layer.dataset.name != nil) {
            datasetName = layer.dataset.name;
        } else {
            datasetName = @"";
        }
        
        NSString* mLayerGroupId = [JSObjManager addObj:layer.parentGroup];
        NSString* mLayerGroupName = layer.parentGroup.name;
        
        NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:layerId forKey:@"id"];
        [dictionary setValue:layer.name forKey:@"name"];
        [dictionary setValue:layer.caption forKey:@"caption"];
        [dictionary setValue:layer.description forKey:@"description"];
        [dictionary setValue:[NSNumber numberWithBool:layer.editable] forKey:@"isEditable"];
        [dictionary setValue:[NSNumber numberWithBool:layer.visible] forKey:@"isVisible"];
        [dictionary setValue:[NSNumber numberWithBool:layer.selectable] forKey:@"isSelectable"];
        [dictionary setValue:[NSNumber numberWithBool:layer.isSnapable] forKey:@"isSnapable"];
        [dictionary setValue:mLayerGroupId forKey:@"layerGroupId"];
        [dictionary setValue:mLayerGroupName forKey:@"groupName"];
        [dictionary setValue:@(themeType) forKey:@"themeType"];
        [dictionary setValue:[NSNumber numberWithFloat:index] forKey:@"index"];
        
        if (layer.dataset != nil) {
            [dictionary setValue:[NSNumber numberWithInteger:layer.dataset.datasetType] forKey:@"type"];
            [dictionary setValue:datasetName forKey:@"datasetName"];
        } else {
            [dictionary setValue:@"layerGroup" forKey:@"type"];
        }
        
        resolve(dictionary);
    } @catch (NSException *exception) {
        reject(@"JSLayerGroup", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(getCount, getCountById:(NSString *)layerGroupId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        LayerGroup* layerGroup = [JSObjManager getObjWithKey:layerGroupId];
        if([layerGroup isKindOfClass:[LayerGroup class]]){
            NSUInteger count = [layerGroup getCount];
            resolve([NSNumber numberWithUnsignedInteger:count]);
        }else{
            resolve(@(0));
        }
        
    } @catch (NSException *exception) {
        reject(@"JSLayerGroup getCount", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(indexOf, indexOf:(NSString *)layerGroupId layerId:(NSString *)layerId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        LayerGroup* layerGroup = [JSObjManager getObjWithKey:layerGroupId];
        Layer* layer = [JSObjManager getObjWithKey:layerId];
        NSUInteger count = [layerGroup indexOfLayer:layer];
        
        resolve([NSNumber numberWithUnsignedInteger:count]);
    } @catch (NSException *exception) {
        reject(@"JSLayerGroup getCount", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(insert, insertById:(NSString *)layerGroupId index:(int)index layerId:(NSString *)layerId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        LayerGroup* layerGroup = [JSObjManager getObjWithKey:layerGroupId];
        Layer* layer = [JSObjManager getObjWithKey:layerId];
        BOOL result = [layerGroup insert:index Layer:layer];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"JSLayerGroup getCount", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(insertGroup, insertGroupById:(NSString *)layerGroupId index:(int)index groupName:(NSString *)groupName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        LayerGroup* layerGroup = [JSObjManager getObjWithKey:layerGroupId];
        BOOL result = [layerGroup insertGroup:index name:groupName];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"JSLayerGroup getCount", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(remove, removeById:(NSString *)layerGroupId layerId:(NSString *)layerId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        LayerGroup* layerGroup = [JSObjManager getObjWithKey:layerGroupId];
        Layer* layer = [JSObjManager getObjWithKey:layerId];
        BOOL result = [layerGroup removeLayer:layer];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"JSLayerGroup getCount", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(removeGroup, removeGroupById:(NSString *)layerGroupId groupId:(NSString *)groupId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        LayerGroup* layerGroup = [JSObjManager getObjWithKey:layerGroupId];
        LayerGroup* removeGroup = [JSObjManager getObjWithKey:groupId];
        BOOL result = [layerGroup removeGroup:removeGroup];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"JSLayerGroup getCount", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(ungroup, ungroupById:(NSString *)layerGroupId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        LayerGroup* layerGroup = [JSObjManager getObjWithKey:layerGroupId];
        BOOL result = [layerGroup unGroup];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"JSLayerGroup getCount", exception.reason, nil);
    }
}


@end

//
//  SLayerManager.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/11/16.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "SLayerManager.h"

@implementation SLayerManager
RCT_EXPORT_MODULE();
#pragma mark 获取制定类型的图层, type = -1 为所有类型
RCT_REMAP_METHOD(getLayersByType, getLayersByType:(int)type path:(NSString *)path resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSArray* layers = [SMLayer getLayersByType:type path:path];
        resolve(layers);
    } @catch (NSException *exception) {
        reject(@"LayerManager", exception.reason, nil);
    }
}

#pragma mark 获取指定名字的LayerGroup
RCT_REMAP_METHOD(getLayersByGroupPath, getLayersByGroupPath:(NSString *)path resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if (path == nil || [path isEqualToString:@""]) reject(@"MapControl", @"Group name can not be empty", nil);
        NSArray* layers = [SMLayer getLayersByGroupPath:path];
        resolve(layers);
    } @catch (NSException *exception) {
        reject(@"LayerManager", exception.reason, nil);
    }
}

#pragma mark 设置制定名字图层是否可见
RCT_REMAP_METHOD(setLayerVisible, setLayerVisible:(NSString *)path value:(BOOL)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Map* map = [SMap singletonInstance].smMapWC.mapControl.map;
        [SMLayer setLayerVisible:path value:value];
        [map refresh];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"LayerManager", exception.reason, nil);
    }
}
@end

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

#pragma mark 设置制定名字图层是否可见
RCT_REMAP_METHOD(getLayerIndex, getLayerIndex:(NSString *)name value:(BOOL)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Map* map = [SMap singletonInstance].smMapWC.mapControl.map;
        int index = [map.layers indexOf:name];
        resolve([NSNumber numberWithInt:index]);
    } @catch (NSException *exception) {
        reject(@"LayerManager", exception.reason, nil);
    }
}

#pragma mark 获取图层属性
RCT_REMAP_METHOD(getLayerAttribute, getLayerAttribute:(NSString *)layerPath resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSDictionary* dic = [SMLayer getLayerAttribute:layerPath];
        resolve(dic);
    } @catch (NSException *exception) {
        reject(@"LayerManager", exception.reason, nil);
    }
}

#pragma mark - 获取Selection中对象的属性
RCT_REMAP_METHOD(getSelectionAttributeByLayer, getSelectionAttributeByLayer:(NSString *)layerPath resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSDictionary* dic = [SMLayer getSelectionAttributeByLayer:layerPath];
        resolve(dic);
    } @catch (NSException *exception) {
        reject(@"LayerManager", exception.reason, nil);
    }
}

#pragma mark - 根据数据源序号和数据集序号，添加图层
RCT_REMAP_METHOD(addLayerByIndex, addLayerByIndex:(int)datasourceIndex datasetIndex:(int)datasetIndex resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SMap* sMap = [SMap singletonInstance];
        Datasources* dataSources = sMap.smMapWC.workspace.datasources;
        BOOL result = NO;
        if (dataSources && dataSources.count > datasourceIndex) {
            Datasets* dss = [dataSources get:datasourceIndex].datasets;
            if (dss.count > datasetIndex) {
                Dataset* ds = [dss get:datasetIndex];
                Layer* layer = [sMap.smMapWC.mapControl.map.layers addDataset:ds ToHead:YES];
                sMap.smMapWC.mapControl.map.isVisibleScalesEnabled = NO;
                result = layer != nil;
            }
        }
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"LayerManager", exception.reason, nil);
    }
}

#pragma mark - 根据数据源名称和数据集序号，添加图层
RCT_REMAP_METHOD(addLayerByName, addLayerByName:(NSString *)datasourceName datasetIndex:(int)datasetIndex resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SMap* sMap = [SMap singletonInstance];
        Datasources* dataSources = sMap.smMapWC.workspace.datasources;
        BOOL result = NO;
        if (dataSources && [dataSources getAlias:datasourceName]) {
            Datasets* dss = [dataSources getAlias:datasourceName].datasets;
            if (dss.count > datasetIndex) {
                Dataset* ds = [dss get:datasetIndex];
                Layer* layer = [sMap.smMapWC.mapControl.map.layers addDataset:ds ToHead:YES];
                sMap.smMapWC.mapControl.map.isVisibleScalesEnabled = NO;
                result = layer != nil;
            }
        }
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"LayerManager", exception.reason, nil);
    }
}
@end

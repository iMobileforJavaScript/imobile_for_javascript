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

#pragma mark 设置制定名字图层是否可编辑
RCT_REMAP_METHOD(setLayerEditable, setLayerEditable:(NSString *)path value:(BOOL)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Map* map = [SMap singletonInstance].smMapWC.mapControl.map;
        [SMLayer setLayerEditable:path value:value];
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

#pragma mark - 根据图层路径，找到对应的图层并修改指定recordset中的FieldInfo
RCT_REMAP_METHOD(setLayerFieldInfo, setLayerFieldByLayerPath:(NSString *)layerPath fieldInfos:(NSArray *)fieldInfos index:(int)index resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Layer* layer = [SMLayer findLayerByPath:layerPath];
        
        if (layer) {
            DatasetVector* dsVector = (DatasetVector *)layer.dataset;
            Recordset* recordset = [dsVector recordset:false cursorType:DYNAMIC];
            
            index = index >= 0 ? index : (recordset.recordCount - 1);
            [recordset moveTo:index];
            [recordset edit];
            
            for (int i = 0; i < fieldInfos.count; i++) {
                NSDictionary* info = fieldInfos[i];
                
                NSString* name = [info objectForKey:@"name"];
                NSObject* value = [info objectForKey:@"value"];
                FieldInfo* fieldInfo = [recordset.fieldInfos getName:name];
                
                if (!fieldInfo) continue;
                
                switch (fieldInfo.fieldType) {
                    case FT_BOOLEAN: {
                        BOOL boolValue = NO;
                        if ([value isEqual:@"YES"] || [value isEqual:@"true"]) {
                            boolValue = YES;
                        }
                        [recordset setBOOLWithName:name BOOLValue:boolValue];
                        break;
                    }
                    case FT_BYTE:
                        [recordset setByteWithName:name ByteValue: (Byte)[[(NSString *)value dataUsingEncoding: NSUTF8StringEncoding] bytes]];
                        break;
                    case FT_INT16: {
                        short shortValue = (short)((NSNumber *)value).intValue;
                        [recordset setInt16WithName:name shortValue:shortValue];
                        break;
                    }
                    case FT_INT32:
                        [recordset setInt32WithName:name value:((NSNumber *)value).intValue];
                        break;
                    case FT_INT64:
                        [recordset setInt64WithName:name value:((NSNumber *)value).intValue];
                        break;
                    case FT_SINGLE:
                        [recordset setSingleWithName:name value:((NSNumber *)value).floatValue];
                        break;
                    case FT_DOUBLE:
                        [recordset setDoubleWithName:name DoubleValue:((NSNumber *)value).doubleValue];
                        break;
                    case FT_DATE:
                        break;
                    case FT_LONGBINARY:
                    case FT_TEXT:
                    default:
                        [recordset setFieldValueWithString:name Obj:value];
                        break;
                }
            }
            
            [recordset update];
            [recordset dispose];
            recordset = nil;
        }
        resolve([NSNumber numberWithBool:YES]);
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

#pragma mark 根据图层名称移除图层
RCT_REMAP_METHOD(removeLayerWithName, removeLayerWithNameByParams:(NSString*)layerName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SMap* sMap = [SMap singletonInstance];
        BOOL result = [sMap.smMapWC.mapControl.map.layers removeWithName:layerName];
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 根据索引移除图层
RCT_REMAP_METHOD(removeLayerWithIndex, removeLayerWithIndexByParams:(int)index resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SMap* sMap = [SMap singletonInstance];
        BOOL result = [sMap.smMapWC.mapControl.map.layers removeAt:index];
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 根据索引移除图层
RCT_REMAP_METHOD(removeAllLayer, removeAllLayerWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SMap* sMap = [SMap singletonInstance];
        [sMap.smMapWC.mapControl.map.layers clear];
        [sMap.smMapWC.mapControl.map refresh];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 修改图层名
RCT_REMAP_METHOD(renameLayer, renameLayerWithNameByParams:(NSString*)layerName relayerName:(NSString*)relayerName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SMap* sMap = [SMap singletonInstance];
        Layer* layer = [sMap.smMapWC.mapControl.map.layers getLayerWithName:layerName];
        [layer setCaption:relayerName];
        resolve([NSNumber numberWithBool:true]);
    } @catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 向上移动图层
RCT_REMAP_METHOD(moveUpLayer, moveUpLayerWithIndexByParams:(NSString*)layerName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SMap* sMap = [SMap singletonInstance];
        int index = [sMap.smMapWC.mapControl.map.layers indexOf:layerName];
        bool result =  false;
        result = [sMap.smMapWC.mapControl.map.layers moveUp:index];
        [sMap.smMapWC.mapControl.map refresh];
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 向下移动图层
RCT_REMAP_METHOD(moveDownLayer, moveDownLayerWithResolver:(NSString*)layerName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SMap* sMap = [SMap singletonInstance];
        int index = [sMap.smMapWC.mapControl.map.layers indexOf:layerName];
        bool result =  false;
        result = [sMap.smMapWC.mapControl.map.layers moveDown:index];
        [sMap.smMapWC.mapControl.map refresh];
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 移动到顶层
RCT_REMAP_METHOD(moveToTop, moveToTopWithResolver:(NSString*)layerName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SMap* sMap = [SMap singletonInstance];
        int index = [sMap.smMapWC.mapControl.map.layers indexOf:layerName];
        bool result =  false;
        result = [sMap.smMapWC.mapControl.map.layers moveTop:index];
        [sMap.smMapWC.mapControl.map refresh];
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 移动到底层
RCT_REMAP_METHOD(moveToBottom, moveToBottomWithResolver:(NSString*)layerName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SMap* sMap = [SMap singletonInstance];
        int index = [sMap.smMapWC.mapControl.map.layers indexOf:layerName];
        bool result =  false;
        result = [sMap.smMapWC.mapControl.map.layers moveBottom:index];
        [sMap.smMapWC.mapControl.map refresh];
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}
@end

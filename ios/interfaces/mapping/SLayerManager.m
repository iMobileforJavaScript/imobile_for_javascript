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
RCT_REMAP_METHOD(getLayerAttribute, getLayerAttribute:(NSString *)layerPath page:(int)page size:(int)size resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSDictionary* dic = [SMLayer getLayerAttribute:layerPath page:page size:size];
        resolve(dic);
    } @catch (NSException *exception) {
        reject(@"LayerManager", exception.reason, nil);
    }
}

#pragma mark - 获取Selection中对象的属性
RCT_REMAP_METHOD(getSelectionAttributeByLayer, getSelectionAttributeByLayer:(NSString *)layerPath page:(int)page size:(int)size resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSDictionary* dic = [SMLayer getSelectionAttributeByLayer:layerPath page:page size:size];
        resolve(dic);
    } @catch (NSException *exception) {
        reject(@"LayerManager", exception.reason, nil);
    }
}

#pragma mark - 获取指定图层和ID的对象的属性
RCT_REMAP_METHOD(getAttributeByLayer, getAttributeByLayer:(NSString *)layerPath ids:(NSArray *)ids resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSDictionary* dic = [SMLayer getAttributeByLayer:layerPath ids:ids];
        resolve(dic);
    } @catch (NSException *exception) {
        reject(@"LayerManager", exception.reason, nil);
    }
}

#pragma mark - 搜索指定图层匹配对象的属性
RCT_REMAP_METHOD(searchLayerAttribute, searchLayerAttribute:(NSString *)layerPath params:(NSDictionary *)params page:(int *)page size:(int *)size resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSArray* arr = [SMLayer searchLayerAttribute:layerPath params:params page:page size:size];
        resolve(arr);
    } @catch (NSException *exception) {
        reject(@"LayerManager", exception.reason, nil);
    }
}

#pragma mark - 搜索指定图层中Selection匹配对象的属性
RCT_REMAP_METHOD(searchSelectionAttribute, searchSelectionAttribute:(NSString *)layerPath searchKey:(NSString *)searchKey page:(int *)page size:(int *)size resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSArray* arr = [SMLayer searchSelectionAttribute:layerPath searchKey:searchKey page:page size:size];
        resolve(arr);
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
RCT_REMAP_METHOD(setLayerFieldInfo, setLayerFieldByLayerPath:(NSString *)layerPath fieldInfos:(NSArray *)fieldInfos params:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Layer* layer = [SMLayer findLayerByPath:layerPath];
        
        Layers* layers = [SMap singletonInstance].smMapWC.mapControl.map.layers;
        Layer* editableLayer = nil;
        
        if (layer) {
            
            // 找到原来可编辑图层并记录
            // 三种情况：1.目标图层即为可编辑图层；2.目标图层不为可编辑图层，且layers中不存在编辑图层；3.layers中存在可编辑图层，但不是目标图层
            int status = 1;
            if (!layer.editable) {
                for (int i = 0; i < layers.getCount; i++) {
                    if ([layers getLayerAtIndex:i].editable) {
                        editableLayer = [layers getLayerAtIndex:i];
                        status = 3;
                        break;
                    }
                }
                
                layer.editable = YES;
                if (!editableLayer) {
                    status = 2;
                }
            }
            
            DatasetVector* dsVector = (DatasetVector *)layer.dataset;
            Recordset* recordset;
            
            if ([params objectForKey:@"filter"]) {
                NSString* filter = [params objectForKey:@"filter"];
                CursorType cursorType = DYNAMIC;
                if ([params objectForKey:@"cursorType"]) {
                    NSNumber* cType = [params objectForKey:@"cursorType"];
                    cursorType = cType.intValue;
                }
                
                QueryParameter* queryParams = [[QueryParameter alloc] init];
                [queryParams setAttriButeFilter:filter];
                [queryParams setCursorType:cursorType];
                recordset = [dsVector query:queryParams];
            } else {
                recordset = [dsVector recordset:false cursorType:DYNAMIC];
                if ([params objectForKey:@"index"] >= 0){
                    NSNumber* indexNum = [params objectForKey:@"index"];
                    long index = indexNum.longValue;
                    index = index >= 0 ? index : (recordset.recordCount - 1);
                    [recordset moveTo:index];
                }
            }
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
            
            // 还原编辑之前的图层可编辑状态
            switch (status) {
                case 2:
                    layer.editable = NO;
                    break;
                case 3:
                    editableLayer.editable = YES;
                    break;
                case 1:
                default:
                    break;
            }
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
        if(index != 0){
            Layer *layer = [sMap.smMapWC.mapControl.map.layers getLayerAtIndex:index-1];
            if(![layer.name containsString:@"Label"]){
                [sMap.smMapWC.mapControl.map.layers moveUp:index];
                [sMap.smMapWC.mapControl.map refresh];
            }
        }
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 向下移动图层
RCT_REMAP_METHOD(moveDownLayer, moveDownLayerWithResolver:(NSString*)layerName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSArray *netLayers = @[@"roadmap@GoogleMaps",
                               @"satellite@GoogleMaps",
                               @"terrain@GoogleMaps",
                               @"hybrid@GoogleMaps",
                               @"vec@TD",
                               @"cva@TDWZ",
                               @"img@TDYXM",
                               @"TrafficMap@BaiduMap",
                               @"Standard@OpenStreetMaps",
                               @"CycleMap@OpenStreetMaps",
                               @"TransportMap@OpenStreetMaps",
                               @"quanguo@SuperMapCloud"];
        SMap* sMap = [SMap singletonInstance];
        int index = [sMap.smMapWC.mapControl.map.layers indexOf:layerName];
        int next = index + 1;
        Layer *nextLayer = [sMap.smMapWC.mapControl.map.layers getLayerAtIndex:next];
        BOOL move = YES;
        for(int i = 0; i < netLayers.count; i++){
            if([nextLayer.name isEqualToString:netLayers[i]]){
                move = false;
            }
        }
        if(move){
            [sMap.smMapWC.mapControl.map.layers moveDown:index];
            [sMap.smMapWC.mapControl.map refresh];
        }
        resolve(@(YES));
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
        reject(@"SMap", exception.reason, nil);
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
        reject(@"SMap", exception.reason, nil);
    }
}

#pragma mark 选中指定图层中的对象
RCT_REMAP_METHOD(selectObj, selectObjWith:(NSString *)layerPath ids:(NSArray *)ids resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SMap* sMap = [SMap singletonInstance];
        Layer* layer = [SMLayer findLayerByPath:layerPath];
        Selection* selection = [layer getSelection];
        [selection clear];
        
        NSMutableArray* arr = [[NSMutableArray alloc] init];
        
        BOOL selectable = layer.selectable;
        
        if (ids.count > 0) {
            if (!layer.selectable) {
                layer.selectable = YES;
            } else {
                
            }
            
            for (int i = 0; i < ids.count; i++) {
                NSNumber* _ID = ids[i];
                [selection add:_ID.intValue];
                
                Recordset* rs = [selection toRecordset];
                [rs moveTo:i];
                Point2D* point2D = [rs.geometry getInnerPoint];
                
                NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
                [dic setObject:_ID forKey:@"id"];
                [dic setObject:[NSNumber numberWithDouble:point2D.x] forKey:@"x"];
                [dic setObject:[NSNumber numberWithDouble:point2D.y] forKey:@"y"];
                
                [arr addObject:dic];
            }
        }
        
        if (!selectable) {
            layer.selectable = NO;
        }
        
        [sMap.smMapWC.mapControl.map refresh];
        resolve(arr);
    } @catch (NSException *exception) {
        reject(@"SMap", exception.reason, nil);
    }
}

#pragma mark 选中多个图层中的对象
RCT_REMAP_METHOD(selectObjs, selectObjsWith:(NSArray *)data resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SMap* sMap = [SMap singletonInstance];
        NSMutableArray* arr = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < data.count; i++) {
            NSDictionary* item = data[i];
            NSString* layerPath = [item objectForKey:@"layerPath"];
            NSArray* ids = [item objectForKey:@"ids"];
            Layer* layer = [SMLayer findLayerByPath:layerPath];
            Selection* selection = [layer getSelection];
            Recordset* rs = nil;
            [selection clear];
            
            BOOL selectable = layer.selectable;
            
            if (ids.count > 0) {
                if (!layer.selectable) {
                    layer.selectable = YES;
                } else {
                    
                }
                
                for (int j = 0; j < ids.count; j++) {
                    NSNumber* _ID = ids[j];
                    [selection add:_ID.intValue];
                    
                    rs = [selection toRecordset];
                    [rs moveTo:i];
                    Point2D* point2D = [rs.geometry getInnerPoint];
                    
                    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:_ID forKey:@"id"];
                    [dic setObject:[NSNumber numberWithDouble:point2D.x] forKey:@"x"];
                    [dic setObject:[NSNumber numberWithDouble:point2D.y] forKey:@"y"];
                    [arr addObject:dic];
                }
            }
            
            if (!selectable) {
                layer.selectable = NO;
            }
            if (rs != nil) {
                [rs moveFirst];
            }
        }
        
        [sMap.smMapWC.mapControl.map refresh];
        resolve(arr);
    } @catch (NSException *exception) {
        reject(@"SMap", exception.reason, nil);
    }
}
@end

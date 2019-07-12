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


RCT_REMAP_METHOD(setLayerSelectable, setSelectableByLayerPath:(NSString*)layerPath selectable:(BOOL)selectable resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Layer* layer = [SMLayer findLayerByPath:layerPath];
        layer.selectable = selectable;
        NSNumber* num = [NSNumber numberWithBool:true];
        resolve(num);
    } @catch (NSException *exception) {
        reject(@"Layer",@"setSelectable() failed.",nil);
    }
}

RCT_REMAP_METHOD(setLayerSnapable, setSnapableByLayerPath:(NSString*)layerPath snapable:(BOOL)snapable resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Layer* layer = [SMLayer findLayerByPath:layerPath];
        layer.isSnapable = snapable;
        NSNumber* num = [NSNumber numberWithBool:true];
        resolve(num);
    } @catch (NSException *exception) {
        reject(@"Layer",@"setSnapable() failed.",nil);
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

#pragma mark - 根据数据源名称和数据集序号，添加图层
RCT_REMAP_METHOD(addLayerByName, addLayerByName:(NSString *)datasourceName datasetIndex:(int)datasetIndex resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Layer* layer = [SMLayer addLayerByName:datasourceName datasetIndex:datasetIndex];
        resolve([NSNumber numberWithBool:layer != nil]);
    } @catch (NSException *exception) {
        reject(@"LayerManager", exception.reason, nil);
    }
}

#pragma mark - 根据数据源序号和数据集序号，添加图层
RCT_REMAP_METHOD(addLayerByIndex, addLayerByIndex:(int)datasourceIndex datasetIndex:(int)datasetIndex resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Layer* layer = [SMLayer addLayerByIndex:datasourceIndex datasetIndex:datasetIndex];
        resolve([NSNumber numberWithBool:layer != nil]);
    } @catch (NSException *exception) {
        reject(@"LayerManager", exception.reason, nil);
    }
}

#pragma mark 根据图层名获取对应xml
RCT_REMAP_METHOD(getLayerAsXML, getLayerAsXML: (NSString *) layerName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Layer* layer = [SMLayer findLayerWithName:layerName];
        
        resolve(layer.toXML);
    } @catch (NSException *exception) {
        reject(@"LayerManager", exception.reason, nil);
    }
}

#pragma mark 将xml图层插入到当前地图
RCT_REMAP_METHOD(insertXMLLayer, insertXMLLayer:(int)index xml:(NSString *)xml resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
        SMap* sMap = [SMap singletonInstance];
        [sMap.smMapWC.mapControl.map.layers insertLayer:index withXML:xml];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"LayerManager", exception.reason, nil);
    }
}

#pragma mark - 根据图层路径，找到对应的图层并修改指定recordset中的FieldInfo
RCT_REMAP_METHOD(setLayerFieldInfo, setLayerFieldByLayerPath:(NSString *)layerPath fieldInfos:(NSArray *)fieldInfos params:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Layer* layer = [SMLayer findLayerByPath:layerPath];
        BOOL result = [SMLayer setLayerFieldInfo:layer fieldInfos:fieldInfos params:params];
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"LayerManager", exception.reason, nil);
    }
}

#pragma mark - 根据图层名称，找到对应的图层并修改指定recordset中的FieldInfo
RCT_REMAP_METHOD(setLayerFieldInfoByName, setLayerFieldInfoByName:(NSString *)layerName fieldInfos:(NSArray *)fieldInfos params:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Layer* layer = [SMLayer findLayerWithName:layerName];
        BOOL result = [SMLayer setLayerFieldInfo:layer fieldInfos:fieldInfos params:params];
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"LayerManager", exception.reason, nil);
    }
}

#pragma mark 根据图层名称移除图层
RCT_REMAP_METHOD(removeLayerWithName, removeLayerWithNameByParams:(NSString*)layerName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SMap* sMap = [SMap singletonInstance];
        Layer* layer = nil;LayerGroup* layerGroup = nil;
        [SMLayer findLayerAndGroupByPath:layerName layer:&layer group:&layerGroup];
        
        BOOL result = false;
        if(layerGroup!=nil){
            if(layer!=nil){
                result = [layerGroup removeLayer:layer];
            }
        }else{
            if(layer!=nil){
               result = [sMap.smMapWC.mapControl.map.layers remove:layer];
            }
        }
//        BOOL result = [sMap.smMapWC.mapControl.map.layers removeWithName:layerName];
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
        
        Layer* layer = [SMLayer findLayerByPath:layerName];// [sMap.smMapWC.mapControl.map.layers getLayerWithName:layerName];
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
        
        Layer* layer = nil;LayerGroup* layerGroup = nil;
        [SMLayer findLayerAndGroupByPath:layerName layer:&layer group:&layerGroup];
        
        BOOL result = false;
        if(layerGroup!=nil){
            if(layer!=nil){
               int nInsert = [layerGroup indexOfLayer:layer] - 1;
                if(nInsert>=0){
                    [layerGroup insert:nInsert Layer:layer];
                }
            }
        }else{
            if(layer!=nil){
                int index = [sMap.smMapWC.mapControl.map.layers indexOf:layerName];
                if(index != 0){
                    Layer *layer = [sMap.smMapWC.mapControl.map.layers getLayerAtIndex:index-1];
                    if(![layer.name containsString:@"Label"]){
                        [sMap.smMapWC.mapControl.map.layers moveUp:index];
                        [sMap.smMapWC.mapControl.map refresh];
                    }
                }
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
            
            Layer* layer = nil;LayerGroup* layerGroup = nil;
            [SMLayer findLayerAndGroupByPath:layerName layer:&layer group:&layerGroup];
            BOOL result = false;
            if(layerGroup!=nil){
                if(layer!=nil){
                    int nInsert = [layerGroup indexOfLayer:layer] + 1;
                    if(nInsert<=[layerGroup getCount]){
                       result = [layerGroup insert:nInsert Layer:layer];
                    }
                }
            }else{
                if(layer!=nil){
                    [sMap.smMapWC.mapControl.map.layers moveDown:index];
                    [sMap.smMapWC.mapControl.map refresh];
                }
            }
            
           
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
        
        Layer* layer = nil;LayerGroup* layerGroup = nil;
        [SMLayer findLayerAndGroupByPath:layerName layer:&layer group:&layerGroup];
        if(layerGroup!=nil){
            if(layer!=nil){
                int nInsert = 0;
                if(nInsert<=[layerGroup getCount]){
                   [layerGroup insert:nInsert Layer:layer];
                }
            }
        }else{
            if(layer!=nil){
                int index = [sMap.smMapWC.mapControl.map.layers indexOf:layerName];
                
               [sMap.smMapWC.mapControl.map.layers moveTop:index];
            }
        }
        
        [sMap.smMapWC.mapControl.map refresh];
        resolve([NSNumber numberWithBool:1]);
    } @catch (NSException *exception) {
        reject(@"SMap", exception.reason, nil);
    }
}

#pragma mark 移动到底层
RCT_REMAP_METHOD(moveToBottom, moveToBottomWithResolver:(NSString*)layerName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SMap* sMap = [SMap singletonInstance];
        Layer* layer = nil;LayerGroup* layerGroup = nil;
        [SMLayer findLayerAndGroupByPath:layerName layer:&layer group:&layerGroup];
        if(layerGroup!=nil){
            if(layer!=nil){
                int nInsert = [layerGroup getCount];
                if(nInsert<=[layerGroup getCount]){
                    [layerGroup insert:nInsert Layer:layer];
                }
            }
        }else{
            if(layer!=nil){
                int index = [sMap.smMapWC.mapControl.map.layers indexOf:layerName];
                [sMap.smMapWC.mapControl.map.layers moveBottom:index];
            }
        }
        
       
        [sMap.smMapWC.mapControl.map refresh];
        resolve([NSNumber numberWithBool:1]);
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

#pragma mark 选中多个图层中的对象
RCT_REMAP_METHOD(setLayerStyle, setLayerStyleWithLayerName:(NSString *)layerName style:(NSString *)styleJson resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SMap* sMap = [SMap singletonInstance];
        Layer* layer = [sMap.smMapWC.mapControl.map.layers findLayerWithName:layerName];
        
        if (layer && styleJson) {
            GeoStyle* style = [[GeoStyle alloc] init];
            [style fromJson:styleJson];
            [style setMarkerSize:[[Size2D alloc]initWithWidth:8 Height:8 ]];
            ((LayerSettingVector *)layer.layerSetting).geoStyle = style;
        }
        
        [sMap.smMapWC.mapControl.map refresh];
        resolve(@(1));
    }@catch (NSException *exception) {
        reject(@"SMap", exception.reason, nil);
    }
}
#pragma mark 把多个图层中的对象放到追踪层
RCT_REMAP_METHOD(setTrackingLayer, setTrackingLayerWith:(NSArray *)data isClear:(BOOL)isClear resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SMap* sMap = [SMap singletonInstance];
        Map* map = sMap.smMapWC.mapControl.map;
        TrackingLayer* trackingLayer = map.trackingLayer;
        
        if (isClear) {
            [trackingLayer clear];
        }
        
        NSMutableArray* arr = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < data.count; i++) {
            NSDictionary* item = data[i];
            NSString* layerPath = [item objectForKey:@"layerPath"];
            NSArray* ids = [item objectForKey:@"ids"];
            Layer* layer = [SMLayer findLayerByPath:layerPath];
            
            Recordset* recordset = [((DatasetVector *)layer.dataset) queryWithID:ids Type:STATIC];
            
            [recordset moveFirst];
            
            while (![recordset isEOF]) {
                NSString* geoStyleJSON = [item objectForKey:@"style"];
                GeoStyle* geoStyle = nil;
                if (geoStyleJSON) {
                    geoStyle = [[GeoStyle alloc] init];
                    [geoStyle fromJson:geoStyleJSON];
                }
                
                Geometry* geometry = recordset.geometry;
                if (geoStyle) {
                    [geometry setStyle:geoStyle];
                }
                
                if (ids.count > 0) {
                    for (int j = 0; j < ids.count; j++) {
                        NSNumber* _ID = ids[j];
                        Point2D* point2D = [geometry getInnerPoint];
                        
                        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
                        [dic setObject:_ID forKey:@"id"];
                        [dic setObject:[NSNumber numberWithDouble:point2D.x] forKey:@"x"];
                        [dic setObject:[NSNumber numberWithDouble:point2D.y] forKey:@"y"];
                        [arr addObject:dic];
                    }
                }
                
                [trackingLayer addGeometry:geometry WithTag:@""];
                
                [recordset moveNext];
            }
        }
        
        [sMap.smMapWC.mapControl.map refresh];
        resolve(arr);
    } @catch (NSException *exception) {
        reject(@"SMap", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(clearTrackingLayer, clearTrackingLayerWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SMap* sMap = [SMap singletonInstance];
        Map* map = sMap.smMapWC.mapControl.map;
        TrackingLayer* trackingLayer = map.trackingLayer;
        
        [trackingLayer clear];
        [sMap.smMapWC.mapControl.map refresh];
        NSNumber* num = [NSNumber numberWithBool:true];
        resolve(num);
    } @catch (NSException *exception) {
        reject(@"Layer",@"setEditable() failed.",nil);
    }
}

//RCT_REMAP_METHOD(setEditable, setEditableByLayerPath:(NSString*)layerPath editable:(BOOL)editable resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        Layer* layer = [SMLayer findLayerByPath:layerPath];
//        layer.editable = editable;
//        NSNumber* num = [NSNumber numberWithBool:true];
//        resolve(num);
//    } @catch (NSException *exception) {
//        reject(@"Layer",@"setEditable() failed.",nil);
//    }
//}
//
//RCT_REMAP_METHOD(setVisible, setVisibleByLayerPath:(NSString*)layerPath visible:(BOOL)visible resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        Layer* layer = [SMLayer findLayerByPath:layerPath];
//        layer.visible = visible;
//        NSNumber* num = [NSNumber numberWithBool:true];
//        resolve(num);
//    } @catch (NSException *exception) {
//        reject(@"Layer",@"setVisible() failed.",nil);
//    }
//}

//RCT_REMAP_METHOD(setSelectable, setSelectableByLayerPath:(NSString*)layerPath selectable:(BOOL)selectable resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        Layer* layer = [SMLayer findLayerByPath:layerPath];
//        layer.selectable = selectable;
//        NSNumber* num = [NSNumber numberWithBool:true];
//        resolve(num);
//    } @catch (NSException *exception) {
//        reject(@"Layer",@"setSelectable() failed.",nil);
//    }
//}
//
//RCT_REMAP_METHOD(setSnapable, setSnapableByLayerPath:(NSString*)layerPath snapable:(BOOL)snapable resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        Layer* layer = [SMLayer findLayerByPath:layerPath];
//        layer.isSnapable = snapable;
//        NSNumber* num = [NSNumber numberWithBool:true];
//        resolve(num);
//    } @catch (NSException *exception) {
//        reject(@"Layer",@"setSnapable() failed.",nil);
//    }
//}

//RCT_REMAP_METHOD(addCallout, addCallout:(NSDictionary *)point imagePath:(NSString *)imagePath resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        long longitude = [(NSNumber *)[point objectForKey:@"x"] longValue];
//        long latitude = [(NSNumber *)[point objectForKey:@"y"] longValue];
//        
//        NSString* imagePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", imagePath];
//        
//        [SMLayer addCallOutWithLongitude:longitude latitude:latitude image:imagePath];
//        resolve(@(YES));
//    } @catch (NSException *exception) {
//        reject(@"Layer",@"setSnapable() failed.",nil);
//    }
//}
@end

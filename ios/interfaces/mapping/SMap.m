//
//  SMap.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/26.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "SMap.h"
static SMap *sMap = nil;
@interface SMap()
{
    Point2D* defaultMapCenter;
}
@end
@implementation SMap
RCT_EXPORT_MODULE();
- (NSArray<NSString *> *)supportedEvents
{
    return @[
             MEASURE_LENGTH,
             MEASURE_AREA,
             MEASURE_ANGLE,
             COLLECTION_SENSOR_CHANGE,
             MAP_LONG_PRESS,
             MAP_SINGLE_TAP,
             MAP_DOUBLE_TAP,
             MAP_TOUCH_BEGAN,
             MAP_TOUCH_END,
             MAP_SCROLL,
             MAP_GEOMETRY_MULTI_SELECTED,
             MAP_GEOMETRY_SELECTED,
             MAP_SCALE_CHANGED,
             MAP_BOUNDS_CHANGED,
             ];
}

+ (instancetype)singletonInstance{
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sMap = [[self alloc] init];
    });
    
    if (sMap.smMapWC == nil) {
        sMap.smMapWC = [[SMMapWC alloc] init];
    }
    
    if (sMap.smMapWC.workspace == nil) {
        sMap.smMapWC.workspace = [[Workspace alloc] init];
    }
    
    return sMap;
}

+ (void)setInstance:(MapControl*) mapControl {
    sMap = [self singletonInstance];
    if (sMap.smMapWC == nil) {
        sMap.smMapWC = [[SMMapWC alloc] init];
    }
    sMap.smMapWC.mapControl = mapControl;
}

- (void)setDelegate {
    sMap.smMapWC.mapControl.mapMeasureDelegate = self;
    sMap.smMapWC.mapControl.delegate = self;
    sMap.smMapWC.mapControl.geometrySelectedDelegate = self;
}

#pragma mark getEnvironmentStatus 获取许可文件状态
RCT_REMAP_METHOD(getEnvironmentStatus, getEnvironmentStatusWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        LicenseStatus* status = [Environment getLicenseStatus];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        
        [dic setObject:[NSNumber numberWithBool:status.isActivated] forKey:@"isActivated"];
        [dic setObject:[NSNumber numberWithBool:status.isLicenseValid] forKey:@"isLicenseValid"];
        [dic setObject:[NSNumber numberWithBool:status.isLicenseExsit] forKey:@"isLicenseExist"];
        [dic setObject:[NSNumber numberWithBool:status.isTrailLicense] forKey:@"isTrailLicense"];
        [dic setObject:status.startDate forKey:@"startDate"];
        [dic setObject:status.expireDate forKey:@"expireDate"];
        [dic setObject:[NSString stringWithFormat:@"%ld", status.version] forKey:@"version"];
        
        resolve(dic);
    } @catch (NSException *exception) {
        reject(@"unZipFile", exception.reason, nil);
    }
}

#pragma mark 刷新地图
RCT_REMAP_METHOD(refreshMap, refreshMapWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        [sMap.smMapWC.mapControl.map refresh];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"SMap", exception.reason, nil);
    }
}

#pragma mark 打开工作空间
RCT_REMAP_METHOD(openWorkspace, openWorkspaceByInfo:(NSDictionary*)infoDic resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        BOOL result = [sMap.smMapWC openWorkspace:infoDic];
        if (result) {
            [sMap.smMapWC.mapControl.map setWorkspace:sMap.smMapWC.workspace];
        }
        sMap.smMapWC.mapControl.map.isVisibleScalesEnabled = NO;
        sMap.smMapWC.mapControl.isMagnifierEnabled = YES;
        sMap.smMapWC.mapControl.map.isAntialias = YES;
        [sMap.smMapWC.mapControl.map refresh];
        [self openGPS];
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}

//#pragma mark 导入工作空间
//RCT_REMAP_METHOD(openWorkspace, inputWKPath:(NSString*)inPutWorkspace resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        sMap = [SMap singletonInstance];
//        Workspace* wk = [[Workspace alloc]init];
//        WorkspaceConnectionInfo* wkInfo = [[WorkspaceConnectionInfo alloc]init];
//        NSString* exten = [inPutWorkspace pathExtension];
//        if([exten.uppercaseString isEqualToString:@"SMWU"]){
//            wkInfo.type = SM_SMWU;
//        }else if ([exten.uppercaseString isEqualToString:@"SXWU"]){
//            wkInfo.type = SM_SXWU;
//        }
//
//        wkInfo.server = inPutWorkspace;
//        BOOL bOPen = [wk open:wkInfo];
//        if(bOPen){
////            wk.maps;
////            NSMutableArray* mapArr = [NSMutableArray array];
////            for(int i=0;i<wk.maps.count;i++){
////                Map* map = [wk.maps get:i] ;
////                map
////            }
//        }
//
//
////        BOOL result = [sMap.smMapWC openWorkspace:infoDic];
////        if (result) {
////            [sMap.smMapWC.mapControl.map setWorkspace:sMap.smMapWC.workspace];
////        }
////        sMap.smMapWC.mapControl.map.isVisibleScalesEnabled = NO;
////        [sMap.smMapWC.mapControl.map refresh];
////        [self openGPS];
////        resolve([NSNumber numberWithBool:result]);
//    } @catch (NSException *exception) {
//        reject(@"workspace", exception.reason, nil);
//    }
//}


#pragma mark 关闭工作空间
RCT_REMAP_METHOD(closeWorkspace, closeWorkspaceWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        [sMap.smMapWC.mapControl.map close];
        [sMap.smMapWC.mapControl.map dispose];
        //        [sMap.smMapWC.mapControl dispose];
        [sMap.smMapWC.workspace close];
        defaultMapCenter = nil;
        //        [sMap.smMapWC.workspace dispose];
        
        //        sMap.smMapWC.mapControl = nil;
        //        sMap.smMapWC.workspace = nil;
        
        resolve([NSNumber numberWithBool:YES]);
    }@catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}


#pragma mark 以数据源形式打开工作空间, 默认根据Map 图层索引显示图层
RCT_REMAP_METHOD(openDatasourceWithIndex, openDatasourceByParams:(NSDictionary*)params defaultIndex:(int)defaultIndex toHead:(BOOL)toHead visible:(BOOL)visible resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        Datasource* dataSource = [sMap.smMapWC openDatasource:params];
        [sMap.smMapWC.mapControl.map setWorkspace:sMap.smMapWC.workspace];
        
        if (dataSource && defaultIndex >= 0 && dataSource.datasets.count > 0) {
            Dataset* ds = [dataSource.datasets get:defaultIndex];
            Layer* layer = [sMap.smMapWC.mapControl.map.layers addDataset:ds ToHead:toHead];
            layer.visible = visible;
            sMap.smMapWC.mapControl.map.isVisibleScalesEnabled = NO;
        }
        [sMap.smMapWC.mapControl.map refresh];
        [self openGPS];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 以数据源形式打开工作空间, 默认根据Map 图层名称显示图层
RCT_REMAP_METHOD(openDatasourceWithName, openDatasourceByParams:(NSDictionary*)params defaultName:(NSString *)defaultName toHead:(BOOL)toHead visible:(BOOL)visible resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        if(params){
            Datasource* dataSource = [sMap.smMapWC openDatasource:params];
            [sMap.smMapWC.mapControl.map setWorkspace:sMap.smMapWC.workspace];
            
            if (defaultName != nil && defaultName.length > 0) {
                Dataset* ds = [dataSource.datasets getWithName:defaultName];
                Layer* layer = [sMap.smMapWC.mapControl.map.layers addDataset:ds ToHead:toHead];
                layer.visible = visible;
                sMap.smMapWC.mapControl.map.isVisibleScalesEnabled = NO;
            }
            [self openGPS];
            [sMap.smMapWC.mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        }
    } @catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 工作空间是否被修改
RCT_REMAP_METHOD(workspaceIsModified, workspaceIsModifiedWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BOOL result = sMap.smMapWC.workspace.isModified;
        resolve([NSNumber numberWithBool:result]);
    }@catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 保存工作空间
RCT_REMAP_METHOD(saveWorkspace, saveWorkspaceWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        BOOL result = [sMap.smMapWC saveWorkspace];
        resolve([NSNumber numberWithBool:result]);
    }@catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 根据工作空间连接信息保存工作空间
RCT_REMAP_METHOD(saveWorkspaceWithInfo, saveWorkspaceWithInfoWithInfo:(NSDictionary *)info resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        BOOL result = [sMap.smMapWC saveWorkspaceWithInfo:info];
        resolve([NSNumber numberWithBool:result]);
    }@catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 关闭地图控件
RCT_REMAP_METHOD(closeMapControl, closeMapControlWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        if (sMap.smMapWC.mapControl.map) {
            [sMap.smMapWC.mapControl.map close];
            [sMap.smMapWC.mapControl.map dispose];
        }
        //        [sMap.smMapWC.mapControl dispose];
        if (sMap.smMapWC.mapControl) {
//            [sMap.smMapWC.mapControl dispose];
        }
        if (sMap.smMapWC.workspace) {
            [sMap.smMapWC.workspace close];
//            [sMap.smMapWC.workspace dispose];
        }
        
        defaultMapCenter = nil;
//        sMap.smMapWC.mapControl = nil;
//        sMap.smMapWC.workspace = nil;
        
        resolve([NSNumber numberWithBool:YES]);
    }@catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 根据工作空间名字获取地图
RCT_REMAP_METHOD(getMapsByFile, getMapsByFile:(NSString*)path resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSString* type = [path pathExtension];
        WorkspaceType workspaceType;
        
        if ( [type isEqualToString:@"sxw"] ) {
            workspaceType = SM_SXW;
        }else if( [type isEqualToString:@"smw"] ){
            workspaceType = SM_SMW;
        }else if( [type isEqualToString:@"sxwu"] ){
            workspaceType = SM_SXWU;
        }else if( [type isEqualToString:@"smwu"] ){
            workspaceType = SM_SMWU;
        }
        
        Workspace* ws = [[Workspace alloc] init];
        WorkspaceConnectionInfo* wsInfo = [[WorkspaceConnectionInfo alloc] init];
        wsInfo.server = path;
        wsInfo.type = workspaceType;
        
        BOOL result = [ws open:wsInfo];
        
        NSMutableArray* mapArr = [[NSMutableArray alloc] init];
        if (result && ws.maps.count > 0) {
            for (int i = 0; i < ws.maps.count; i++) {
                [mapArr addObject:[ws.maps get:i]];
            }
        }
        
        [ws close];
        [wsInfo dispose];
        [ws dispose];
        
        resolve(mapArr);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 根据名字显示图层
RCT_REMAP_METHOD(openMapByName, openMapByName:(NSString*)name viewEntire:(BOOL)viewEntire center:(NSDictionary *)center resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Map* map = sMap.smMapWC.mapControl.map;
        Maps* maps = sMap.smMapWC.workspace.maps;
        
        BOOL isOpen = NO;
        
        if (![map.name isEqualToString:name] && maps.count > 0) {
            NSString* mapName = name;
            
            if ([name isEqualToString:@""]) {
                NSString* mapName = [maps get:0];
                [map open: mapName];
            }
            if (![name isKindOfClass:[NSNull class]] && name.length) {
                isOpen = [map open: mapName];
            } else if (viewEntire == YES) {
                [map viewEntire];
            }
            
            if (isOpen) {
                if (center != nil && ![center isKindOfClass:[NSNull class]] && center.count > 0) {
                    NSNumber* x = [center objectForKey:@"x"];
                    NSNumber* y = [center objectForKey:@"y"];
                    Point2D* point = [[Point2D alloc] init];
                    point.x = x.doubleValue;
                    point.y = y.doubleValue;
                    [map setCenter:point];
                }
                
                defaultMapCenter = map.center;
                [sMap.smMapWC.mapControl setAction:PAN];
                sMap.smMapWC.mapControl.map.isVisibleScalesEnabled = NO;
                [map refresh];
            }
        }
        
        resolve([NSNumber numberWithBool:isOpen]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 根据序号显示图层
RCT_REMAP_METHOD(openMapByIndex, openMapByIndex:(int)index viewEntire:(BOOL)viewEntire center:(NSDictionary *)center resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Map* map = sMap.smMapWC.mapControl.map;
        Maps* maps = sMap.smMapWC.workspace.maps;
        
        BOOL isOpen = YES;
        
        if (maps.count > 0 && index >= 0) {
            if (index >= maps.count) index = maps.count - 1;
            NSString* mapName = [maps get:index];
            isOpen = [map open: mapName];
            
            if (isOpen) {
                if (viewEntire == YES) {
                    [map viewEntire];
                }
                
                if (center != nil && ![center isKindOfClass:[NSNull class]] && center.count > 0) {
                    NSNumber* x = [center objectForKey:@"x"];
                    NSNumber* y = [center objectForKey:@"y"];
                    Point2D* point = [[Point2D alloc] init];
                    point.x = x.doubleValue;
                    point.y = y.doubleValue;
                    [map setCenter:point];
                }
                defaultMapCenter = map.center;
                [sMap.smMapWC.mapControl setAction:PAN];
                sMap.smMapWC.mapControl.map.isVisibleScalesEnabled = NO;
                [map refresh];
            }
        }
        resolve([NSNumber numberWithBool:isOpen]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 获取工作空间地图列表
RCT_REMAP_METHOD(getMaps, getMapsWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Maps* maps = sMap.smMapWC.workspace.maps;
        NSMutableArray* mapList = [NSMutableArray array];
        for (int i = 0; i < maps.count; i++) {
            NSString* mapName = [maps get:i];
            NSMutableDictionary* mapInfo = [[NSMutableDictionary alloc] init];
            [mapInfo setObject:mapName forKey:@"title"];
            [mapList addObject:mapInfo];
        }
        resolve(mapList);
    }@catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 获取地图信息
RCT_REMAP_METHOD(getMapInfo, getMapInfoWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Map* map = sMap.smMapWC.mapControl.map;
        NSMutableDictionary* mapInfo = [[NSMutableDictionary alloc] init];
        [mapInfo setObject:map.name forKey:@"name"];
        [mapInfo setObject:map.description forKey:@"description"];
        [mapInfo setObject:@(map.isModified) forKey:@"isModified"];
        resolve(mapInfo);
    }@catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark MapControl的closeMap
RCT_REMAP_METHOD(closeMap, closeMapWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl* mapControl = sMap.smMapWC.mapControl;
        if (mapControl) {
            [[mapControl map] close];
        }
        defaultMapCenter = nil;
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 获取UDB数据源的数据集列表
RCT_REMAP_METHOD(getUDBName, getUDBName:(NSString*)path resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        path = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString* udbName = [[path lastPathComponent] stringByDeletingPathExtension ];
        Datasource* datasource;
        Workspace* workspace;
        sMap = [SMap singletonInstance];
        DatasourceConnectionInfo* datasourceConnectionInfo=[[DatasourceConnectionInfo alloc] init];
        
        if(!sMap.smMapWC.mapControl){
            workspace=[[Workspace alloc] init];
            [datasourceConnectionInfo setEngineType:ET_UDB];
            [datasourceConnectionInfo setServer:path];
            [datasourceConnectionInfo setAlias:udbName];
            datasource=[workspace.datasources open:datasourceConnectionInfo];
        }else{
            [sMap.smMapWC.mapControl.map setWorkspace:sMap.smMapWC.workspace];
            if ([sMap.smMapWC.mapControl.map.workspace.datasources indexOf:udbName] != -1) {
                datasource=[sMap.smMapWC.mapControl.map.workspace.datasources getAlias:udbName];
            }else{
                [datasourceConnectionInfo setEngineType:ET_UDB];
                [datasourceConnectionInfo setServer:path];
                [datasourceConnectionInfo setAlias:udbName];
                datasource=[sMap.smMapWC.mapControl.map.workspace.datasources open:datasourceConnectionInfo];
            }
        }
        Datasets* datasets=datasource.datasets;
        NSUInteger count=datasets.count;
        
        NSMutableArray* array = [[NSMutableArray alloc]init];
        for(int i = 0; i < count; i++)
        {
            Dataset* dataset=[datasets get:i];
            NSString* name=dataset.name;
            NSMutableDictionary* info = [[NSMutableDictionary alloc] init];
            [info setObject:(name) forKey:(@"title")];
            [array addObject:info];
        }
        if(workspace){
            [workspace dispose];
        }
        [datasourceConnectionInfo dispose];
        resolve(array);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 设置MapControl的Action
RCT_REMAP_METHOD(setAction, setActionByActionType:(int)actionType resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        sMap.smMapWC.mapControl.action = actionType;
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark /************************************** 设置绘制对象时画笔样式 START****************************************/
#pragma mark 设置MapControl的Action
RCT_REMAP_METHOD(setStrokeColor, setStrokeColor:(int)strokeColor resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
//        sMap.smMapWC.mapControl.strokeColor = strokeColor;
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark MapControl的undo
RCT_REMAP_METHOD(undo, undoWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl* mapControl = sMap.smMapWC.mapControl;
        [mapControl undo];
//        [[mapControl map] refresh];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark MapControl的redo
RCT_REMAP_METHOD(redo, redoWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl* mapControl = sMap.smMapWC.mapControl;
        [mapControl redo];
//        [[mapControl map] refresh];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 添加量算监听
RCT_REMAP_METHOD(addMeasureListener, addMeasureListenerWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        if (mapControl.mapMeasureDelegate == nil) {
            mapControl.mapMeasureDelegate = self;
        }
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 移除量算监听
RCT_REMAP_METHOD(removeMeasureListener, removeMeasureListenerWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        mapControl.mapMeasureDelegate = nil;
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 量算监听
-(void)getMeasureResult:(double)result lastPoint:(Point2D *)lastPoint type:(int)type{
    NSNumber *nsResult = [NSNumber numberWithDouble:result];
    double x = lastPoint.x;
    double y = lastPoint.y;
    NSNumber* nsX = [NSNumber numberWithDouble:x];
    NSNumber* nsY = [NSNumber numberWithDouble:y];
    
    if(type == 0){
        [self sendEventWithName:MEASURE_LENGTH
                           body:@{@"curResult":nsResult,
                                  @"curPoint":@{@"x":nsX,@"y":nsY}
                                  }];
    }
    
    if(type == 1){
        [self sendEventWithName:MEASURE_AREA
                           body:@{@"curResult":nsResult,
                                  @"curPoint":@{@"x":nsX,@"y":nsY}
                                  }];
    }
    
    if(type == 2){
        [self sendEventWithName:MEASURE_ANGLE
                           body:@{@"curAngle":nsResult,
                                  @"curPoint":@{@"x":nsX,@"y":nsY}
                                  }];
    }
}

#pragma mark /******************************************** 地图工具 *****************************************************/
#pragma mark 将地图放大缩小到指定比例
RCT_REMAP_METHOD(zoom, zoomByScale:(double)scale resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [mapControl.map zoom:scale];
        [mapControl.map refresh];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 设置比例尺
RCT_REMAP_METHOD(setScale, setScale:(double)scale resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [mapControl.map setScale:scale];
        [mapControl.map refresh];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 设置地图手势旋转是否可用
RCT_REMAP_METHOD(enableRotateTouch, enableRotateTouch:(BOOL)enable resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [mapControl enableRotateTouch:enable];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 设置地图手势俯仰是否可用
RCT_REMAP_METHOD(enableSlantTouch, enableSlantTouch:(BOOL)enable resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [mapControl enableSlantTouch:enable];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 移动到当前位置
RCT_REMAP_METHOD(moveToCurrent, moveToCurrentWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        Collector* collector = [mapControl getCollector];
        dispatch_async(dispatch_get_main_queue(), ^{
//            [collector moveToCurrentPos];
            BOOL isMove = NO;
            Point2D* pt = [[Point2D alloc]initWithPoint2D:[collector getGPSPoint]];
            if ([mapControl.map.prjCoordSys type] != PCST_EARTH_LONGITUDE_LATITUDE) {//若投影坐标不是经纬度坐标则进行转换
                Point2Ds *points = [[Point2Ds alloc]init];
                [points add:pt];
                PrjCoordSys *srcPrjCoorSys = [[PrjCoordSys alloc]init];
                [srcPrjCoorSys setType:PCST_EARTH_LONGITUDE_LATITUDE];
                CoordSysTransParameter *param = [[CoordSysTransParameter alloc]init];
                
                //根据源投影坐标系与目标投影坐标系对坐标点串进行投影转换，结果将直接改变源坐标点串
                [CoordSysTranslator convert:points PrjCoordSys:srcPrjCoorSys PrjCoordSys:[mapControl.map prjCoordSys] CoordSysTransParameter:param CoordSysTransMethod:(CoordSysTransMethod)9603];
                pt = [points getItem:0];
            }
            
            if ([mapControl.map.bounds containsPoint2D:pt]) {
                mapControl.map.center = pt;
                isMove = YES;
            } else {
//                Point2D* p2d = mapControl.map.bounds.center;
//                mapControl.map.center = p2d;
//
                if(defaultMapCenter){
                    mapControl.map.center = defaultMapCenter;
                }
                  //  [mapControl panTo:defaultMapCenter time:200];
            }
            
            [mapControl.map refresh];
            resolve([NSNumber numberWithBool:isMove]);
        });
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 移动到指定位置
RCT_REMAP_METHOD(moveToPoint, moveToPointWithPoint:(NSDictionary *)point resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if (![[point allKeys] containsObject:@"x"] || !![[point allKeys] containsObject:@"y"]){
            resolve([NSNumber numberWithBool:NO]);
            return;
        }
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [collector moveToCurrentPos];
            BOOL isMove = NO;
            NSNumber* x = [point objectForKey:@"x"];
            NSNumber* y = [point objectForKey:@"y"];
            Point2D* pt = [[Point2D alloc] initWithX:x.doubleValue Y:y.doubleValue];
            if ([mapControl.map.prjCoordSys type] != PCST_EARTH_LONGITUDE_LATITUDE) {//若投影坐标不是经纬度坐标则进行转换
                Point2Ds *points = [[Point2Ds alloc]init];
                [points add:pt];
                PrjCoordSys *srcPrjCoorSys = [[PrjCoordSys alloc]init];
                [srcPrjCoorSys setType:PCST_EARTH_LONGITUDE_LATITUDE];
                CoordSysTransParameter *param = [[CoordSysTransParameter alloc]init];

                //根据源投影坐标系与目标投影坐标系对坐标点串进行投影转换，结果将直接改变源坐标点串
                [CoordSysTranslator convert:points PrjCoordSys:srcPrjCoorSys PrjCoordSys:[mapControl.map prjCoordSys] CoordSysTransParameter:param CoordSysTransMethod:(CoordSysTransMethod)9603];
                pt = [points getItem:0];
            }
            
            if ([mapControl.map.bounds containsPoint2D:pt]) {
                mapControl.map.center = pt;
                isMove = YES;
            } else {
                if(defaultMapCenter){
                    mapControl.map.center = defaultMapCenter;
                }
            }
            
            [mapControl.map refresh];
            resolve([NSNumber numberWithBool:isMove]);
        });
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

-(void)openGPS {
    MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
    Collector* collector = [mapControl getCollector];
    [collector openGPS];
}

#pragma mark 提交
RCT_REMAP_METHOD(submit, submitWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        bool result = [mapControl submit];
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 保存地图 autoNaming为true的话若有相同名字的地图则自动命名
RCT_REMAP_METHOD(saveMap, saveMapWithName:(NSString *)name autoNaming:(BOOL)autoNaming resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BOOL mapSaved = NO;
        BOOL wsSaved = NO;
        NSString* _name = name;
        Map* map = [SMap singletonInstance].smMapWC.mapControl.map;
        if (_name == nil || [_name isEqualToString:@""]) {
            if (map.name && ![map.name isEqualToString:@""]) {
                mapSaved = [map save];
            } else if (map.layers.getCount > 0) {
                Layer* layer = [map.layers getLayerAtIndex:map.layers.getCount - 1];
                NSArray* nameArr = [layer.name componentsSeparatedByString:@"@"];
                _name = nameArr[0];
                if (autoNaming) {
                    int i = 0;
                    while (!mapSaved) {
                        _name = i == 0 ? name : [NSString stringWithFormat:@"%@#%d", name, i];
                        mapSaved = [map save:_name];
                        i++;
                    }
                } else {
                    mapSaved = [map save:_name];
                }
            }
        } else {
            mapSaved = [map save:_name];
        }
        wsSaved = [[SMap singletonInstance].smMapWC.workspace save];
        
        if (mapSaved && wsSaved) {
            resolve(_name);
        } else {
            resolve([NSNumber numberWithBool:mapSaved && wsSaved]);
        }
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 移除指定位置的地图
RCT_REMAP_METHOD(removeMapByIndex, removeMapWithIndex:(int)index resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BOOL result = NO;
        Maps* maps = SMap.singletonInstance.smMapWC.workspace.maps;
        if (maps.count > 0 && index < maps.count) {
            if (index < 0) {
                for (int i = maps.count - 1; i >= 0; i--) {
                    NSString* name = [maps get:i];
                    result = [maps removeMapAtIndex:i] && result;
                    [SMap.singletonInstance.smMapWC.workspace.resources.markerLibrary.rootGroup.childSymbolGroups removeGroupWith:name isUpMove:NO];
                    [SMap.singletonInstance.smMapWC.workspace.resources.lineLibrary.rootGroup.childSymbolGroups removeGroupWith:name isUpMove:NO];
                    [SMap.singletonInstance.smMapWC.workspace.resources.fillLibrary.rootGroup.childSymbolGroups removeGroupWith:name isUpMove:NO];
                }
            } else {
                NSString* name = [maps get:index];
                result = [maps removeMapAtIndex:index];
                [SMap.singletonInstance.smMapWC.workspace.resources.markerLibrary.rootGroup.childSymbolGroups removeGroupWith:name isUpMove:NO];
                [SMap.singletonInstance.smMapWC.workspace.resources.lineLibrary.rootGroup.childSymbolGroups removeGroupWith:name isUpMove:NO];
                [SMap.singletonInstance.smMapWC.workspace.resources.fillLibrary.rootGroup.childSymbolGroups removeGroupWith:name isUpMove:NO];
            }
        }
        
        resolve([NSNumber numberWithBool:result]);///test test
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 移除指定名称的地图
RCT_REMAP_METHOD(removeMapByName, removeMapWithName:(NSString *)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BOOL result = NO;
        Maps* maps = SMap.singletonInstance.smMapWC.workspace.maps;
        if (maps.count > 0 && (name == nil || [name isEqualToString:@""])) {
            for (int i = 0; i < maps.count; i++) {
                NSString* _name = [maps get:i];
                result = [maps removeMapAtIndex:i] && result;
                [SMap.singletonInstance.smMapWC.workspace.resources.markerLibrary.rootGroup.childSymbolGroups removeGroupWith:_name isUpMove:NO];
                [SMap.singletonInstance.smMapWC.workspace.resources.lineLibrary.rootGroup.childSymbolGroups removeGroupWith:_name isUpMove:NO];
                [SMap.singletonInstance.smMapWC.workspace.resources.fillLibrary.rootGroup.childSymbolGroups removeGroupWith:_name isUpMove:NO];
            }
        } else if (maps.count > 0 && [maps indexOf:name] >= 0) {
            result = [maps removeMapName:name];
            [SMap.singletonInstance.smMapWC.workspace.resources.markerLibrary.rootGroup.childSymbolGroups removeGroupWith:name isUpMove:NO];
            [SMap.singletonInstance.smMapWC.workspace.resources.lineLibrary.rootGroup.childSymbolGroups removeGroupWith:name isUpMove:NO];
            [SMap.singletonInstance.smMapWC.workspace.resources.fillLibrary.rootGroup.childSymbolGroups removeGroupWith:name isUpMove:NO];
        }
        
        resolve([NSNumber numberWithBool:result]);///test test
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 地图另存为
RCT_REMAP_METHOD(saveAsMap, saveAsMapWithName:(NSString *)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BOOL result = NO;
        if (name != nil && ![name isEqualToString:@""]) {
            result = [[SMap singletonInstance].smMapWC.mapControl.map saveAs:name];
            result = result && [[SMap singletonInstance].smMapWC.workspace save];
        }
        
        resolve([NSNumber numberWithBool:result]);///test test
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 检查地图是否有改动
RCT_REMAP_METHOD(mapIsModified, mapIsModifiedWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BOOL result = [SMap singletonInstance].smMapWC.mapControl.map.isModified;
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 根据地图名称获取地图的index, 若name为空，则返回当前地图的index
RCT_REMAP_METHOD(getMapIndex, getMapIndexWithName:(NSString *)name Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        long index = -1;
        if (name == nil || [name isEqualToString:@""]) {
            if ([SMap singletonInstance].smMapWC.mapControl.map) {
                index = [[SMap singletonInstance].smMapWC.workspace.maps indexOf:[SMap singletonInstance].smMapWC.mapControl.map.name];
            }
        } else {
            index = [[SMap singletonInstance].smMapWC.workspace.maps indexOf:name];
        }
        
        resolve([NSNumber numberWithLong:index]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 设置手势监听
RCT_REMAP_METHOD(setGestureDetector, setGestureDetectorByResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [SMap singletonInstance].smMapWC.mapControl.delegate = self;
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 去除手势监听
RCT_REMAP_METHOD(deleteGestureDetector,deleteGestureDetectorById:(NSString*)mapControlId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        mapControl.delegate = nil;
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(addGeometrySelectedListener, addGeometrySelectedListenerByResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        mapControl.geometrySelectedDelegate = self;
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 去除手势监听
RCT_REMAP_METHOD(removeGeometrySelectedListener, resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        mapControl.geometrySelectedDelegate = nil;
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 指定可编辑图层
RCT_REMAP_METHOD(appointEditGeometry, appointEditGeometryByGeoId:(int)geoId layerName:(NSString*)layerName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        Layer* layer = [mapControl.map.layers getLayerWithName:layerName];
        bool result = [mapControl appointEditGeometryWithID:geoId Layer:layer];
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 获取指定SymbolGroup中所有的group
RCT_REMAP_METHOD(getSymbolGroups, getSymbolGroupsByType:(NSString *)type path:(NSString *)path resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Resources* resoures = [SMap singletonInstance].smMapWC.workspace.resources;
        NSArray* groups = [SMSymbol getSymbolGroups:resoures type:type path:path];
        
        resolve(groups);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 获取指定SymbolGroup中所有的symbol
RCT_REMAP_METHOD(findSymbolsByGroups, findSymbolsByGroups:(NSString *)type path:(NSString *)path resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Resources* resoures = [SMap singletonInstance].smMapWC.workspace.resources;
        NSArray* symbols = [SMSymbol findSymbolsByGroups:resoures type:type path:path];
        
        resolve(symbols);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 导入工作空间
RCT_REMAP_METHOD(importWorkspace, importWorkspaceInfo:(NSDictionary*)wInfo toFile:(NSString*)strFilePath  datasourceReplace:(BOOL)breplaceDatasource resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        sMap = [SMap singletonInstance];
        BOOL result = [sMap.smMapWC importWorkspaceInfo:wInfo withFileDirectory:strFilePath isDatasourceReplace:breplaceDatasource isSymbolsReplace:YES];
        
         resolve(@(result));
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

/**
 * 获取统一标签专题图的字段表达式
 *
 * @param layerName 图层名称
 */

RCT_REMAP_METHOD(addDatasetToMap, addDatasetToMapWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        Layer *layer = nil;
        NSString* datastourceName = @"";
        NSString* datasetName = @"";
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"DatasourceName"]) {
            datastourceName = [dataDic objectForKey:@"DatasourceName"];
        }
        if ([array containsObject:@"DatasetName"]) {
            datasetName = [dataDic objectForKey:@"DatasetName"];
        }
        Workspace* workspace = sMap.smMapWC.workspace;
        if(![datastourceName isEqualToString:@""] && ![datasetName isEqualToString:@""]){
            Datasource* datasource = [workspace.datasources getAlias:datastourceName];
            Dataset* dataset = [datasource.datasets getWithName:datasetName];
            Layer* newLayer = [sMap.smMapWC.mapControl.map.layers addDataset:dataset ToHead:true];
            [sMap.smMapWC.mapControl.map refresh];
            resolve([NSNumber numberWithBool:newLayer != nil]);
        }
        else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 导出地图为工作空间
// strMapName 地图名字（不含后缀）
// ofModule 模块名（默认传空）
// isPrivate 是否是用户数据
// exportWorkspacePath 导出的工作空间绝对路径（含后缀）
RCT_REMAP_METHOD(exportWorkspaceByMap, exportWorkspaceByMap:(NSString*)strMapName ofModule:(NSString *)nModule isPrivate:(BOOL)bPrivate exportWorkspacePath:(NSString *)exportWorkspacePath resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        sMap = [SMap singletonInstance];
        // 先把地图导入大工作空间
        BOOL openResult = [sMap.smMapWC openMapName:strMapName toWorkspace:sMap.smMapWC.workspace ofModule:nModule isPrivate:bPrivate];
        BOOL exportResult = NO;
        if (openResult) {
            // 先把地图导出
            NSArray* exportMaps = [NSArray arrayWithObject:strMapName];
            exportResult = [sMap.smMapWC exportMapNamed:exportMaps toFile:exportWorkspacePath isReplaceFile:YES extra:nil];
            
            // 关闭所有地图
            Maps* maps = sMap.smMapWC.workspace.maps;
            [maps clear];
            // 清除符号库
            [SMap.singletonInstance.smMapWC.workspace.resources.markerLibrary.rootGroup.childSymbolGroups removeGroupWith:strMapName isUpMove:NO];
            [SMap.singletonInstance.smMapWC.workspace.resources.lineLibrary.rootGroup.childSymbolGroups removeGroupWith:strMapName isUpMove:NO];
            [SMap.singletonInstance.smMapWC.workspace.resources.fillLibrary.rootGroup.childSymbolGroups removeGroupWith:strMapName isUpMove:NO];
            // 删除数据源
            [sMap.smMapWC.workspace.datasources closeAll];
        }
        
        resolve(@(exportResult));
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 导出工作空间
RCT_REMAP_METHOD(exportWorkspace, exportWorkspace:(NSArray*)arrMapnames toFile:(NSString*)strFileName fileReplace:(BOOL)bFileReplace extra:(NSDictionary*)extraDic resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        sMap = [SMap singletonInstance];
        BOOL result = [sMap.smMapWC exportMapNamed:arrMapnames toFile:strFileName isReplaceFile:bFileReplace extra:extraDic];
        
        resolve(@(result));
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 导出地图为xml
RCT_REMAP_METHOD(saveMapName, saveMapName:(NSString *)name ofModule:(NSString *)nModule withAddition:(NSDictionary *)withAddition isNew:(BOOL)isNew bResourcesModified:(BOOL)bResourcesModified resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BOOL mapSaved = NO;
        sMap = [SMap singletonInstance];
//        BOOL bNew = name == nil || [name isEqualToString:@""] || [sMap.smMapWC.workspace.maps indexOf:name] == -1;
        BOOL bNew = YES;
        Map* map = sMap.smMapWC.mapControl.map;
        if (map.name && ![map.name isEqualToString:@""]) {
            bNew = NO;
        }
        
        NSString* oldName = map.name;
        
        if (name == nil || [name isEqualToString:@""]) {
            if (map.name && ![map.name isEqualToString:@""]) {
                bNew = NO;
                mapSaved = [map save];
                name = map.name;
            } else if (map.layers.getCount > 0) {
                bNew = YES;
                Layer* layer = [map.layers getLayerAtIndex:map.layers.getCount - 1];
                name = layer.name;
                int i = 0;
                while (!mapSaved) {
                    name = i == 0 ? name : [NSString stringWithFormat:@"%@#%d", name, i];
                    mapSaved = [map save:name];
                    i++;
                }
            }
        } else {
            if ([name isEqualToString:map.name]) {
                bNew = NO;
                mapSaved = [map save];
                name = map.name;
            } else {
                bNew = YES;
                mapSaved = isNew ? [map saveAs:name] : [map save:name];
            }
        }
//        BOOL bResourcesModified = sMap.smMapWC.workspace.maps.count > 1;
        NSString* mapName = @"";
        if (mapSaved) {
            mapName = [sMap.smMapWC saveMapName:name fromWorkspace:sMap.smMapWC.workspace ofModule:nModule withAddition:withAddition isNewMap:(isNew || bNew) isResourcesModyfied:bResourcesModified];
        }
        
        // isNew为true，另存为后保证当前地图是原地图
        BOOL isOpen = NO;
        if (oldName && ![oldName isEqualToString:@""] && ![oldName isEqualToString:mapName] && isNew) {
            isOpen = [map open:oldName];
            if (isOpen && [sMap.smMapWC.workspace.maps indexOf:mapName] >= 0) {
                [sMap.smMapWC.workspace.maps removeMapName:mapName];
            }
            [map refresh];
        }
        
        resolve(mapName);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 导入文件工作空间到程序目录
RCT_REMAP_METHOD(importWorkspaceInfo, importWorkspaceInfo:(NSDictionary *)infoDic toModule:(NSString *)nModule resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        sMap = [SMap singletonInstance];
        NSArray* mapsInfo = [sMap.smMapWC importWorkspaceInfo:infoDic toModule:nModule];
        
        resolve(mapsInfo);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 大工作空间打开本地地图
RCT_REMAP_METHOD(openMapName, openMapName:(NSString*)strMapName ofModule:(NSString *)nModule isPrivate:(BOOL)bPrivate resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        sMap = [SMap singletonInstance];
        BOOL result = [sMap.smMapWC openMapName:strMapName toWorkspace:sMap.smMapWC.workspace ofModule:nModule isPrivate:bPrivate];
        
        resolve(@(result));
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 设置地图反走样式
RCT_REMAP_METHOD(setAntialias, setAntialias:(int)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        sMap = [SMap singletonInstance];
        [sMap.smMapWC.mapControl.map setIsAntialias:value];
        [sMap.smMapWC.mapControl.map refresh];
        resolve([NSNumber numberWithBool:true]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 获取是否反走样
RCT_REMAP_METHOD(isAntialias, isAntialias:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        bool result = [sMap.smMapWC.mapControl.map isAntialias];
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 设置固定比例尺
RCT_REMAP_METHOD(setVisibleScalesEnabled, setVisibleScalesEnabled:(int)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        [sMap.smMapWC.mapControl.map setIsVisibleScalesEnabled:value];
        [sMap.smMapWC.mapControl.map refresh];
        resolve([NSNumber numberWithBool:true]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 获取是否固定比例尺
RCT_REMAP_METHOD(isVisibleScalesEnabled, isVisibleScalesEnabled:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        bool result = [sMap.smMapWC.mapControl.map isVisibleScalesEnabled];
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 检查是否有打开的地图
RCT_REMAP_METHOD(isAnyMapOpened, isAnyMapOpened:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        int count = sMap.smMapWC.mapControl.map.layers.getCount;
        bool isAny = true;
        if (count <= 0) {
            isAny = false;
        }
        resolve([NSNumber numberWithBool:isAny]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 导入符号库
RCT_REMAP_METHOD(importSymbolLibrary, importSymbolLibraryWithPath:(NSString *)path isReplace:(BOOL)isReplace :(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        BOOL result = [sMap.smMapWC appendFromFile:sMap.smMapWC.workspace.resources path:path isReplace:isReplace];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 批量添加图层
RCT_REMAP_METHOD(addLayers, addLayers:(NSArray*)datasetNames dataSourceName:(NSString*)dataSourceName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if (datasetNames == nil || datasetNames.count == 0 || [dataSourceName isEqualToString:@""] || dataSourceName == nil) {
            resolve([NSNumber numberWithBool:false]);
            return;
        }
        sMap = [SMap singletonInstance];
        Datasource* datasource = [sMap.smMapWC.workspace.datasources getAlias:dataSourceName];
        Layers* layers = sMap.smMapWC.mapControl.map.layers;
        
        NSMutableArray* dataset_Point = [[NSMutableArray alloc] init];
        NSMutableArray* dataset_Line = [[NSMutableArray alloc] init];
        NSMutableArray* dataset_Region = [[NSMutableArray alloc] init];
        NSMutableArray* dataset_Text = [[NSMutableArray alloc] init];
        NSMutableArray* dataset_Else = [[NSMutableArray alloc] init];
        NSInteger count = datasetNames.count;
        for (int i = 0; i < count; i++) {
            NSString* datasetName = [datasetNames objectAtIndex:i];
            Dataset* dataset = [datasource.datasets getWithName:datasetName];
            if (dataset.datasetType == REGION || dataset.datasetType == RegionZ) {
                [dataset_Region addObject:dataset];
            }
            else if (dataset.datasetType == LINE || dataset.datasetType == Network || dataset.datasetType == NETWORK3D|| dataset.datasetType == LineZ) {
                [dataset_Line addObject:dataset];
            }
            else if (dataset.datasetType == POINT || dataset.datasetType == PointZ) {
                [dataset_Point addObject:dataset];
            }
            else if (dataset.datasetType == TEXT) {
                [dataset_Text addObject:dataset];
            }
            else{
                [dataset_Else addObject:dataset];
            }
        }
        NSMutableArray* datasets = [[NSMutableArray alloc] init];
        [datasets addObjectsFromArray:dataset_Region];
        [datasets addObjectsFromArray:dataset_Line];
        [datasets addObjectsFromArray:dataset_Point];
        [datasets addObjectsFromArray:dataset_Text];
        [datasets addObjectsFromArray:dataset_Else];
        
        if (datasets.count > 0) {
            MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
            [[mapControl getEditHistory] addMapHistory];
            
            for (int i = 0; i < datasets.count; i++) {
                [layers addDataset:[datasets objectAtIndex:i] ToHead:true];
            }
            [mapControl.map refresh];
        }
    
        resolve([NSNumber numberWithBool:true]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 设置是否压盖
RCT_REMAP_METHOD(setOverlapDisplayed, setOverlapDisplayed:(BOOL)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Map* map = sMap.smMapWC.mapControl.map;
        [map setIsOverlapDisplay:value];
        [map refresh];
        resolve([NSNumber numberWithBool:true]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 是否已经开启压盖
RCT_REMAP_METHOD(isOverlapDisplayed, isOverlapDisplayed:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Map* map = sMap.smMapWC.mapControl.map;
        bool result = [map IsOverlapDisplay];
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 显示全幅
RCT_REMAP_METHOD(viewEntire, viewEntireWithResolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Map* map = sMap.smMapWC.mapControl.map;
        [map viewEntire];
        [map refresh];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}
#pragma mark /************************************** 选择集操作 BEGIN****************************************/
#pragma mark 设置Selection样式
RCT_REMAP_METHOD(setSelectionStyle, setSelectionStyleWithLayerPath:(NSString *)path style:(NSString *)styleJson resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Layer* layer = [SMLayer findLayerByPath:path];
        Selection* selection = [layer getSelection];
        GeoStyle* style = [[GeoStyle alloc] init];
        [style fromJson:styleJson];
        [selection setStyle:style];
        
        [sMap.smMapWC.mapControl.map refresh];
        
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 清除Selection
RCT_REMAP_METHOD(clearSelection, clearSelectionWithResolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Layers* layers = sMap.smMapWC.mapControl.map.layers;
        for (int i = 0; i < layers.getCount; i++) {
            Selection* selection = [[layers getLayerAtIndex:i] getSelection];
            [selection clear];
            [selection dispose];
            
            [sMap.smMapWC.mapControl.map refresh];
        }
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark /************************************** 地图编辑历史操作 BEGIN****************************************/
#pragma mark 把对地图操作记录到历史
RCT_REMAP_METHOD(addMapHistory, addMapHistoryWithResolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl* mapControl = sMap.smMapWC.mapControl;
        [[mapControl getEditHistory] addMapHistory];
        
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 获取地图操作记录数量
RCT_REMAP_METHOD(getMapHistoryCount, getMapHistoryCountWithResolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl* mapControl = sMap.smMapWC.mapControl;
        int count = [[mapControl getEditHistory] getCount];
        
        resolve([NSNumber numberWithInt:count]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 获取当前地图操作记录index
RCT_REMAP_METHOD(getMapHistoryCurrentIndex, getMapHistoryCurrentIndexWithResolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl* mapControl = sMap.smMapWC.mapControl;
        int index = [[mapControl getEditHistory] getCurrentIndex];
        
        resolve([NSNumber numberWithInt:index]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 地图操作记录重做到index
RCT_REMAP_METHOD(redo, redoWithIndex:(int)index resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl* mapControl = sMap.smMapWC.mapControl;
        BOOL result = [[mapControl getEditHistory] Redo:index];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 地图操作记录撤销到index
RCT_REMAP_METHOD(undo, undoWithIndex:(int)index resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl* mapControl = sMap.smMapWC.mapControl;
        BOOL result = [[mapControl getEditHistory] Undo:index];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 地图操作记录移除两个index之间的记录
RCT_REMAP_METHOD(removeRange, removeRangeWithStartIndex:(int)start endIndex:(int)endIndex resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl* mapControl = sMap.smMapWC.mapControl;
        BOOL result = [[mapControl getEditHistory] RemoveRange:start count:endIndex];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 地图操作记录移除index位置的记录
RCT_REMAP_METHOD(remove, removeWithIndex:(int)index resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl* mapControl = sMap.smMapWC.mapControl;
        BOOL result = [[mapControl getEditHistory] Remove:index];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 清除地图操作记录
RCT_REMAP_METHOD(clear, clearWithResolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl* mapControl = sMap.smMapWC.mapControl;
        BOOL result = [[mapControl getEditHistory] Clear];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}
#pragma mark /************************************** 地图编辑历史操作 END****************************************/

#pragma mark /************************************************ 监听事件 ************************************************/
#pragma mark 监听事件
-(void) boundsChanged:(Point2D*) newMapCenter{
    double x = newMapCenter.x;
    NSNumber* nsX = [NSNumber numberWithDouble:x];
    double y = newMapCenter.y;
    NSNumber* nsY = [NSNumber numberWithDouble:y];
    [self sendEventWithName:MAP_BOUNDS_CHANGED
                       body:@{@"x":nsX,
                              @"y":nsY
                              }];
}

-(void) scaleChanged:(double) newscale{
    NSNumber* nsNewScale = [NSNumber numberWithDouble:newscale];
    [self sendEventWithName:MAP_SCALE_CHANGED
                       body:@{@"scale":nsNewScale
                              }];
}


- (void)longpress:(CGPoint)pressedPos{
    CGFloat x = pressedPos.x;
    CGFloat y = pressedPos.y;
    NSNumber* nsX = [NSNumber numberWithFloat:x];
    NSNumber* nsY = [NSNumber numberWithFloat:y];
    [self sendEventWithName:MAP_LONG_PRESS
                       body:@{@"x":nsX,
                              @"y":nsY
                              }];
}

- (void)onDoubleTap:(CGPoint)onDoubleTapPos{
    CGFloat x = onDoubleTapPos.x;
    CGFloat y = onDoubleTapPos.y;
    NSNumber* nsX = [NSNumber numberWithFloat:x];
    NSNumber* nsY = [NSNumber numberWithFloat:y];
    [self sendEventWithName:MAP_DOUBLE_TAP
                       body:@{@"x":nsX,
                              @"y":nsY
                              }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    CGFloat x = point.x;
    CGFloat y = point.y;
    NSNumber* nsX = [NSNumber numberWithFloat:x];
    NSNumber* nsY = [NSNumber numberWithFloat:y];
    [self sendEventWithName:MAP_TOUCH_BEGAN
                       body:@{@"x":nsX,
                              @"y":nsY
                              }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    CGFloat x = point.x;
    CGFloat y = point.y;
    NSNumber* nsX = [NSNumber numberWithFloat:x];
    NSNumber* nsY = [NSNumber numberWithFloat:y];
    
    [self sendEventWithName:MAP_TOUCH_END
                       body:@{@"x":nsX,
                              @"y":nsY
                              }];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch1 = [touches anyObject];
    CGPoint startPoint = [touch1 locationInView:[touch1 view]];
    CGFloat x = startPoint.x;
    CGFloat y = startPoint.y;
    NSNumber* nsX = [NSNumber numberWithFloat:x];
    NSNumber* nsY = [NSNumber numberWithFloat:y];
    
    [self sendEventWithName:MAP_SCROLL
                       body:@{@"local":@{@"x":nsX,@"y":nsY}
                              }];
}

-(void)geometrySelected:(int)geometryID Layer:(Layer*)layer{
    NSNumber* nsId = [NSNumber numberWithInt:geometryID];
    //    NSInteger nsLayer = (NSInteger)layer;
    NSMutableDictionary *layerInfo = [[NSMutableDictionary alloc] init];
    [layerInfo setObject:layer.name forKey:@"name"];
    [layerInfo setObject:layer.caption forKey:@"caption"];
    [layerInfo setObject:[NSNumber numberWithBool:layer.editable] forKey:@"editable"];
    [layerInfo setObject:[NSNumber numberWithBool:layer.visible] forKey:@"visible"];
    [layerInfo setObject:[NSNumber numberWithBool:layer.selectable] forKey:@"selectable"];
    [layerInfo setObject:[NSNumber numberWithInteger:layer.dataset.datasetType] forKey:@"type"];
    [layerInfo setObject:[SMLayer getLayerPath:layer] forKey:@"path"];
    
//    Recordset* r = [layer.getSelection.getDataset recordset:NO cursorType:STATIC];
//    NSMutableDictionary* dic = [NativeUtil recordsetToDictionary:r count:0 size:1];
//    [SMap singletonInstance].selection = [layer getSelection];
    
    [self sendEventWithName:MAP_GEOMETRY_SELECTED body:@{@"layerInfo":layerInfo,
                                                         @"id":nsId,
                                                         }];
}

-(void)geometryMultiSelected:(NSArray*)layersAndIds{
    NSMutableArray* layersIdAndIds = [[NSMutableArray alloc] init];
    for (id layerAndId in layersAndIds) {
        if ([layerAndId isKindOfClass:[NSArray class]] && [layerAndId[0] isKindOfClass:[Layer class]]) {
            Layer* layer = layerAndId[0];
            Dataset* dataset = layer.dataset;
            int type = (int)dataset.datasetType;
            NSMutableDictionary *layerInfo = [[NSMutableDictionary alloc] init];
            [layerInfo setObject:layer.name forKey:@"name"];
            [layerInfo setObject:[NSNumber numberWithBool:layer.editable] forKey:@"editable"];
            [layerInfo setObject:[NSNumber numberWithBool:layer.visible] forKey:@"visible"];
            [layerInfo setObject:[NSNumber numberWithBool:layer.selectable] forKey:@"selectable"];
            [layerInfo setObject:[SMLayer getLayerPath:layer] forKey:@"path"];
            [layerInfo setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
            
            NSMutableDictionary* layerData = [[NSMutableDictionary alloc] init];
            [layerData setObject:layerInfo forKey:@"layerInfo"];
            [layerData setObject:layerAndId[1] forKey:@"ids"];
            
            [layersIdAndIds addObject:layerData];
        }
    }
    [self sendEventWithName:MAP_GEOMETRY_MULTI_SELECTED body:@{@"geometries":(NSArray*)layersIdAndIds}];
}

-(void)measureState{
    
}

@end

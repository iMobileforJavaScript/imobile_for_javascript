//
//  SMap.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/26.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "SMap.h"
#import "Constants.h"
#import "JSMapView.h"
#import "SuperMap/Dataset.h"
#import "SuperMap/Datasets.h"
#import "SuperMap/Layers.h"
#import "SuperMap/Maps.h"
#import "SuperMap/Point2D.h"
static SMap *sMap = nil;

@implementation SMap
RCT_EXPORT_MODULE();
- (NSArray<NSString *> *)supportedEvents
{
    return @[
             MEASURE_LENGTH,
             MEASURE_AREA,
             MEASURE_ANGLE,
             COLLECTION_SENSOR_CHANGE,
             ];
}

+ (instancetype)singletonInstance{
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sMap = [[self alloc] init];
    });
    
    return sMap;
}

+ (void)setInstance:(MapControl*) mapControl {
    sMap = [self singletonInstance];
    if (sMap.smMapWC == nil) {
        sMap.smMapWC = [[SMMapWC alloc] init];
    }
    sMap.smMapWC.mapControl = mapControl;
    if (sMap.smMapWC.workspace == nil) {
        sMap.smMapWC.workspace = [[Workspace alloc] init];
    }
    
    [sMap setDelegate];
}

- (void)setDelegate {
    sMap.smMapWC.mapControl.mapMeasureDelegate = self;
    sMap.smMapWC.mapControl.delegate = self;
    sMap.smMapWC.mapControl.geometrySelectedDelegate = self;
}

#pragma mark 打开工作空间
RCT_REMAP_METHOD(openWorkspace, openWorkspaceByInfo:(NSDictionary*)infoDic resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        BOOL result = [sMap.smMapWC openWorkspace:infoDic];
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"Resources", exception.reason, nil);
    }
}

#pragma mark 以数据源形式打开工作空间, 默认根据Map 图层索引显示图层
RCT_REMAP_METHOD(openDatasourceWithIndex, openDatasourceByParams:(NSDictionary*)params defaultIndex:(int)defaultIndex resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try{
        Datasource* dataSource = [sMap.smMapWC openDatasource:params];
        [sMap.smMapWC.mapControl.map setWorkspace:sMap.smMapWC.workspace];
        
        if (dataSource && defaultIndex >= 0) {
            Dataset* ds = [dataSource.datasets get:defaultIndex];
            [sMap.smMapWC.mapControl.map.layers addDataset:ds ToHead:YES];
        }
        
        resolve([NSNumber numberWithBool:YES]);
    }@catch (NSException *exception) {
        
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 以数据源形式打开工作空间, 默认根据Map 图层名称显示图层
RCT_REMAP_METHOD(openDatasourceWithName, openDatasourceByParams:(NSDictionary*)params defaultName:(NSString *)defaultName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try{
        if(params){
            Datasource* dataSource = [sMap.smMapWC openDatasource:params];
            [sMap.smMapWC.mapControl.map setWorkspace:sMap.smMapWC.workspace];
            
            if (defaultName != nil && defaultName.length > 0) {
                Dataset* ds = [dataSource.datasets getWithName:defaultName];
                [sMap.smMapWC.mapControl.map.layers addDataset:ds ToHead:YES];
            }
            
            resolve([NSNumber numberWithBool:YES]);
        }
    }@catch (NSException *exception) {
        
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 关闭工作空间及地图控件
RCT_REMAP_METHOD(closeWorkspace, closeWorkspaceWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try{
        [sMap.smMapWC.mapControl.map close];
        [sMap.smMapWC.mapControl.map dispose];
        [sMap.smMapWC.mapControl dispose];
        [sMap.smMapWC.workspace close];
        [sMap.smMapWC.workspace dispose];
        
        sMap.smMapWC.mapControl = nil;
        sMap.smMapWC.workspace = nil;
        
        resolve([NSNumber numberWithBool:YES]);
    }@catch (NSException *exception) {
        
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 根据名字显示图层
RCT_REMAP_METHOD(openMapByName, openMapByName:(NSString*)name viewEntire:(BOOL)viewEntire center:(NSDictionary *)center resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Map* map = sMap.smMapWC.mapControl.map;
        Maps* maps = sMap.smMapWC.workspace.maps;
        
        if (maps.count > 0) {
            NSString* mapName = name;
            if ([name isEqualToString:@""]) {
                NSString* mapName = [maps get:0];
                [map open: mapName];
            }
            if (![name isKindOfClass:[NSNull class]] && name.length) {
                [map open: mapName];
            }
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
            
            [sMap.smMapWC.mapControl setAction:PAN];
            [map refresh];
        }
        
        
        resolve([NSNumber numberWithBool:YES]);
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
        
        if (maps.count > 0) {
            NSString* mapName = [maps get:index];
            [map open: mapName];
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
            
            [sMap.smMapWC.mapControl setAction:PAN];
            [map refresh];
            
            resolve([NSNumber numberWithBool:YES]);
        } else {
            reject(@"MapControl", @"没有地图",nil);
        }
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
        
    }
}

#pragma mark 设置MapControl的Action
RCT_REMAP_METHOD(setAction, setActionByActionType:(int)actionType resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl* mapControl = sMap.smMapWC.mapControl;
        mapControl.action = actionType;
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

@end

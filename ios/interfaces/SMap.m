//
//  SMap.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/26.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "SMap.h"
#import "JSMapView.h"
#import "SuperMap/Dataset.h"
#import "SuperMap/Datasets.h"
#import "SuperMap/Layers.h"
#import "SuperMap/Maps.h"
#import "SuperMap/Point2D.h"
static SMap *sMap = nil;

@implementation SMap
RCT_EXPORT_MODULE();

+ (instancetype)singletonInstance{
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sMap = [[self alloc] init];
    });
    
    return sMap;
}

+ (void)setInstance:(MapControl*) mapControl {
    sMap = [self singletonInstance];
    if (sMap.smWorkspace == nil) {
        sMap.smWorkspace = [[SMWorkspace alloc] init];
    }
    sMap.smWorkspace.mapControl = mapControl;
    if (sMap.smWorkspace.workspace == nil) {
        sMap.smWorkspace.workspace = [[Workspace alloc] init];
    }
    
    [sMap setDelegate];
}

- (void)setDelegate {
    sMap.smWorkspace.mapControl.mapMeasureDelegate = self;
    sMap.smWorkspace.mapControl.delegate = self;
    sMap.smWorkspace.mapControl.geometrySelectedDelegate = self;
}

#pragma mark 打开工作空间
RCT_REMAP_METHOD(openWorkspace, openWorkspaceByInfo:(NSDictionary*)infoDic resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        BOOL result = [sMap.smWorkspace openWorkspace:infoDic];
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"Resources", exception.reason, nil);
    }
}

#pragma mark 以数据源形式打开工作空间, 默认根据Map 图层索引显示图层
RCT_REMAP_METHOD(openDatasourceWithIndex, openDatasourceByParams:(NSDictionary*)params defaultIndex:(int)defaultIndex resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try{
        Datasource* dataSource = [sMap.smWorkspace openDatasource:params];
        [sMap.smWorkspace.mapControl.map setWorkspace:sMap.smWorkspace.workspace];
        
        if (dataSource && defaultIndex >= 0) {
            Dataset* ds = [dataSource.datasets get:defaultIndex];
            [sMap.smWorkspace.mapControl.map.layers addDataset:ds ToHead:YES];
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
            Datasource* dataSource = [sMap.smWorkspace openDatasource:params];
            [sMap.smWorkspace.mapControl.map setWorkspace:sMap.smWorkspace.workspace];
            
            if (defaultName != nil && defaultName.length > 0) {
                Dataset* ds = [dataSource.datasets getWithName:defaultName];
                [sMap.smWorkspace.mapControl.map.layers addDataset:ds ToHead:YES];
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
        [sMap.smWorkspace.mapControl dispose];
        [sMap.smWorkspace.workspace close];
        [sMap.smWorkspace.workspace dispose];
        
        sMap.smWorkspace.mapControl = nil;
        sMap.smWorkspace.workspace = nil;
        
        resolve([NSNumber numberWithBool:YES]);
    }@catch (NSException *exception) {
        
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 根据名字显示图层
RCT_REMAP_METHOD(openMapByName, openMapByName:(NSString*)name viewEntire:(BOOL)viewEntire center:(NSDictionary *)center resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Map* map = sMap.smWorkspace.mapControl.map;
        Maps* maps = sMap.smWorkspace.workspace.maps;
        
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
            
            [sMap.smWorkspace.mapControl setAction:PAN];
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
        Map* map = sMap.smWorkspace.mapControl.map;
        Maps* maps = sMap.smWorkspace.workspace.maps;
        
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
            
            [sMap.smWorkspace.mapControl setAction:PAN];
            [map refresh];
            
            resolve([NSNumber numberWithBool:YES]);
        } else {
            reject(@"MapControl", @"没有地图",nil);
        }
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
        
    }
}
@end

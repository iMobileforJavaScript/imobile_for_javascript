//
//  JSMapView.m
//  rnTest
//
//  Created by imobile-xzy on 16/7/12.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import <React/RCTEventDispatcher.h>

#import "JSMapView.h"
#import "JSObjManager.h"
#import "SuperMap/Map.h"
#import "SuperMap/Maps.h"
#import "SuperMap/Action.h"
#import "SuperMap/Point2D.h"
#import "SuperMap/WorkspaceConnectionInfo.h"
#import "SuperMap/DatasourceConnectionInfo.h"
#import "SuperMap/Datasources.h"
#import "SuperMap/Datasource.h"
#import "SuperMap/Datasets.h"
#import "SuperMap/Layers.h"

@implementation JSMapView

@synthesize bridge = _bridge;
static JSMapView *singletonInstance = nil;

RCT_EXPORT_MODULE();

+ (instancetype)singletonInstance{
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        singletonInstance = [[self alloc] init];
    });
    
    return singletonInstance;
}

+ (void)setInstance:(MapControl*) mapControl {
    JSMapView* mapView = [self singletonInstance];
    mapView.mapControl = mapControl;
    mapView.workspace = [[Workspace alloc] init];
    
}

//RCT_REMAP_METHOD(getMapControl,getMapControlKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//  MapControl* mapcontrol = [JSObjManager getObjWithKey:key];
//  if(mapcontrol){
//      mapcontrol.mapMeasureDelegate = self;
//      mapcontrol.delegate = self;
//      mapcontrol.geometrySelectedDelegate = self;
//      NSInteger key = (NSInteger)mapcontrol;
//      resolve(@{@"mapControlId":@(key).stringValue});
//  }else
//      reject(@"MapControl", exception.reason, nil);
//}

- (Workspace *)createWorkspace {
    
    if (_workspace == nil) {
        _workspace = [[Workspace alloc] init];
    }
    return _workspace;
}

RCT_REMAP_METHOD(openWorkspace, openWorkspaceByInfo:(NSDictionary*)infoDic resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        singletonInstance.mapControl.mapMeasureDelegate = self;
        singletonInstance.mapControl.delegate = self;
        singletonInstance.mapControl.geometrySelectedDelegate = self;
        
        if (_workspace == nil) {
           _workspace = [[Workspace alloc] init];
        }
        
        WorkspaceConnectionInfo* info = [[WorkspaceConnectionInfo alloc] init];
        if ([infoDic objectForKey:@"name"]) {
            info.name = [infoDic objectForKey:@"name"];
        }
        if ([infoDic objectForKey:@"password"]) {
            info.password = [infoDic objectForKey:@"password"];
        }
        if ([infoDic objectForKey:@"server"]) {
            info.server = [infoDic objectForKey:@"server"];
        }
        if ([infoDic objectForKey:@"type"]) {
            NSNumber* type = [infoDic objectForKey:@"type"];
            info.type = (int)type.integerValue;
        }
        if ([infoDic objectForKey:@"user"]) {
            info.user = [infoDic objectForKey:@"user"];
        }
        if ([infoDic objectForKey:@"version"]) {
            NSNumber* version = [infoDic objectForKey:@"version"];
            info.version = (int)version.integerValue;
        }
        
        bool openWsResult = [_workspace open:info];
        [singletonInstance.mapControl.map setWorkspace:_workspace];
        
        resolve([NSNumber numberWithBool:openWsResult]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);

    }
}

RCT_REMAP_METHOD(openMapByName, openMapByName:(NSString*)name viewEntire:(BOOL)viewEntire center:(NSDictionary *)center resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if (singletonInstance.mapControl == nil) {
            
        }
        Map* map = singletonInstance.mapControl.map;
        Maps* maps = _workspace.maps;
        NSString* mapName = name;
        if ([name isEqualToString:@""] && maps.count > 0) {
            [maps get:0];
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
        
        [singletonInstance.mapControl setAction:PAN];
        [map refresh];
        
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
        
    }
}

RCT_REMAP_METHOD(openMapByIndex, openMapByIndex:(int)index viewEntire:(BOOL)viewEntire center:(NSDictionary *)center resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if (singletonInstance.mapControl == nil) {
            
        }
        Map* map = singletonInstance.mapControl.map;
        Maps* maps = _workspace.maps;
        
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
            
            [singletonInstance.mapControl setAction:PAN];
            [map refresh];
            
            resolve([NSNumber numberWithBool:YES]);
        } else {
            reject(@"MapControl", @"没有地图",nil);
        }
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
        
    }
}

RCT_REMAP_METHOD(openDatasourceWithIndex, openDatasourceByParams:(NSDictionary*)params defaultIndex:(int)defaultIndex resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try{
        if(params){
            Datasource* dataSource = [self openDatasource:params];
            
            if (defaultIndex >= 0) {
                Dataset* ds = [dataSource.datasets get:defaultIndex];
                [singletonInstance.mapControl.map.layers addDataset:ds ToHead:YES];
            }
            
            resolve([NSNumber numberWithBool:YES]);
        }
    }@catch (NSException *exception) {
        
        reject(@"workspace", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(openDatasourceWithName, openDatasourceByParams:(NSDictionary*)params defaultName:(NSString *)defaultName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try{
        if(params){
            Datasource* dataSource = [self openDatasource:params];
            
            if (defaultName != nil && defaultName.length > 0) {
                Dataset* ds = [dataSource.datasets getWithName:defaultName];
                [singletonInstance.mapControl.map.layers addDataset:ds ToHead:YES];
            }
            
            resolve([NSNumber numberWithBool:YES]);
        }
    }@catch (NSException *exception) {
        
        reject(@"workspace", exception.reason, nil);
    }
}

- (Datasource*)openDatasource:(NSDictionary*)params {
    
    singletonInstance.mapControl.mapMeasureDelegate = self;
    singletonInstance.mapControl.delegate = self;
    singletonInstance.mapControl.geometrySelectedDelegate = self;
    
    if (_workspace == nil) {
        _workspace = [[Workspace alloc] init];
    }
    Datasources* dataSources = _workspace.datasources;
    DatasourceConnectionInfo* info = [[DatasourceConnectionInfo alloc]init];
    if(params&&info){
        NSArray* keyArr = [params allKeys];
        BOOL bDefault = YES;
        if ([keyArr containsObject:@"alias"]){
            info.alias = [params objectForKey:@"alias"];
            bDefault = NO;
        }
        if ([keyArr containsObject:@"engineType"]){
            NSNumber* num = [params objectForKey:@"engineType"];
            long type = num.floatValue;
            info.engineType = (EngineType)type;
        }
        if ([keyArr containsObject:@"server"]){
            NSString* path = [params objectForKey:@"server"];
            info.server = path;
            if(bDefault){
                info.alias = [[path lastPathComponent] stringByDeletingPathExtension];
            }
        }
        if([_workspace.datasources indexOf:info.alias]!=-1){
            [_workspace.datasources closeAlias:info.alias];
        }
        if ([keyArr containsObject:@"driver"]) info.driver = [params objectForKey:@"driver"];
        if ([keyArr containsObject:@"user"]) info.user = [params objectForKey:@"user"];
        if ([keyArr containsObject:@"readOnly"]) info.readOnly = ((NSNumber*)[params objectForKey:@"readOnly"]).boolValue;
        if ([keyArr containsObject:@"password"]) info.password = [params objectForKey:@"password"];
        if ([keyArr containsObject:@"webCoordinate"]) info.webCoordinate = [params objectForKey:@"webCoordinate"];
        if ([keyArr containsObject:@"webVersion"]) info.webVersion = [params objectForKey:@"webVersion"];
        if ([keyArr containsObject:@"webFormat"]) info.webFormat = [params objectForKey:@"webFormat"];
        if ([keyArr containsObject:@"webVisibleLayers"]) info.webVisibleLayers = [params objectForKey:@"webVisibleLayers"];
        if ([keyArr containsObject:@"webExtendParam"]) info.webExtendParam = [params objectForKey:@"webExtendParam"];
        if ([keyArr containsObject:@"webBBox"]){
            Rectangle2D* rect2d = [JSObjManager getObjWithKey:[params objectForKey:@"webBBox"]];
            info.webBBox = rect2d;
        }
        Datasource* dataSource = [dataSources open:info];
        return dataSource;
    }
    return nil;
}

@end

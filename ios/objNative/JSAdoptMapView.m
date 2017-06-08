//
//  JSAdoptMapView.m
//  GeometryInfo
//
//  Created by 王子豪 on 2017/1/4.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSAdoptMapView.h"
#import "JSObjManager.h"
#import "SuperMap/Geometry.h"
#import "SuperMap/Layer.h"
#import "SuperMap/Point2D.h"
@implementation JSAdoptMapView
RCT_EXPORT_MODULE(JSMapControl);

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"Supermap.MapControl.MapParamChanged.BoundsChanged", @"Supermap.MapControl.MapParamChanged.ScaleChanged",
        @"com.supermap.RN.JSMapcontrol.scroll_event",
        @"com.supermap.RN.JSMapcontrol.long_press_event",
        @"com.supermap.RN.JSMapcontrol.geometry_selected",
        @"com.supermap.RN.JSMapcontrol.geometry_multi_selected"];
}

-(void) boundsChanged:(Point2D*) newMapCenter{
    double x = newMapCenter.x;
    NSNumber* nsX = [NSNumber numberWithDouble:x];
    double y = newMapCenter.y;
    NSNumber* nsY = [NSNumber numberWithDouble:y];
    [self sendEventWithName:@"Supermap.MapControl.MapParamChanged.BoundsChanged"
                       body:@{@"x":nsX,
                              @"y":nsY
                              }];
}

-(void) scaleChanged:(double) newscale{
    NSNumber* nsNewScale = [NSNumber numberWithDouble:newscale];
    [self sendEventWithName:@"Supermap.MapControl.MapParamChanged.ScaleChanged"
                       body:@{@"scale":nsNewScale
                              }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self sendEventWithName:@"com.supermap.RN.JSMapcontrol.scroll_event"
                       body:@{@"body":@"listener undefine"
                              }];
}

- (void)longpress:(CGPoint)pressedPos{
    CGFloat x = pressedPos.x;
    CGFloat y = pressedPos.y;
    NSNumber* nsX = [NSNumber numberWithFloat:x];
    NSNumber* nsY = [NSNumber numberWithFloat:y];
    [self sendEventWithName:@"com.supermap.RN.JSMapcontrol.long_press_event"
                       body:@{@"x":nsX,
                              @"y":nsY
                              }];
}

-(void)geometrySelected:(int)geometryID Layer:(Layer*)layer{
    NSNumber* nsId = [NSNumber numberWithInt:geometryID];
    NSInteger nsLayer = (NSInteger)layer;
    [JSObjManager addObj:layer];
    [self sendEventWithName:@"com.supermap.RN.JSMapcontrol.geometry_selected" body:@{@"layerId":@(nsLayer).stringValue,
                                                                                     @"id":nsId
                                                                                     }];
}

-(void)geometryMultiSelected:(NSArray*)layersAndIds{
    NSMutableArray* layersIdAndIds = [[NSMutableArray alloc]initWithCapacity:10];
    for (id layerAndId in layersAndIds) {
        if ([layerAndId isKindOfClass:[NSArray class]]&&[layerAndId[0]isKindOfClass:[Layer class]]) {
            Layer*layer = layerAndId[0];
            [JSObjManager addObj:layer];
            NSInteger nslayer = (NSInteger)layer;
            [layersIdAndIds addObject:@[@(nslayer).stringValue,layerAndId[1]]];
        }
    }
    [self sendEventWithName:@"com.supermap.RN.JSMapcontrol.geometry_multi_selected" body:@{@"geometries":(NSArray*)layersIdAndIds}];
}
/*此处对应三种回调
-(double)getMeasureResult:(double)result lastPoint:(Point2D*)lastPoint{
    [self sendEventWithName:@"" body:@{@"":@""}];
    return result;
}
*/

RCT_REMAP_METHOD(getMap,geMapKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  MapControl* mapcontrol = [JSObjManager getObjWithKey:key];
  if(mapcontrol){
    Map* map = mapcontrol.map;
    [JSObjManager addObj:map];
    NSInteger key = (NSInteger)map;
    resolve(@{@"mapId":@(key).stringValue});
  }else
    reject(@"MapControl",@"getMap:mapcontrol not exeist!!!",nil);
}

RCT_REMAP_METHOD(setAction,mapControlId:(NSString*)Id actionType:(int)type resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    MapControl* mapControl = [JSObjManager getObjWithKey:Id];
    if (mapControl) {
        mapControl.action = type;
        resolve(@"1");
    }else{
        reject(@"mapControl",@"setAction failed!!!",nil);
    }
}

RCT_REMAP_METHOD(submit,submitByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    MapControl* mapControl = [JSObjManager getObjWithKey:key];
    if (mapControl) {
        [mapControl submit];
        resolve(@"submit successful");
    }else{
        reject(@"mapControl",@"submit failed!!!",nil);
    }
}

RCT_REMAP_METHOD(setGestureDetector,setGestureDetectorById:(NSString*)mapControlId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    MapControl* mapCtrl = [JSObjManager getObjWithKey:mapControlId];
    if(mapCtrl){
        mapCtrl.delegate =self;
        NSNumber* nsTrue = [NSNumber numberWithBool:TRUE];
        resolve(nsTrue);
    }else{
        reject(@"mapControl",@"set GestureDetector failed!!!",nil);
    }
}

RCT_REMAP_METHOD(deleteGestureDetector,deleteGestureDetectorById:(NSString*)mapControlId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    MapControl* mapCtrl = [JSObjManager getObjWithKey:mapControlId];
    if(mapCtrl){
        mapCtrl.delegate = nil;
        NSNumber* nsTrue = [NSNumber numberWithBool:TRUE];
        resolve(nsTrue);
    }else{
        reject(@"mapControl",@"delete GestureDetector failed!!!",nil);
    }
}

RCT_REMAP_METHOD(setMapParamChangedListener,setMapParamChangedListenerByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    MapControl* mapCtrl = [JSObjManager getObjWithKey:key];
    Map* map = mapCtrl.map;
    if(map){
        map.delegate =self;
        NSNumber* nsTrue = [NSNumber numberWithBool:TRUE];
        resolve(nsTrue);
    }else{
        reject(@"mapControl",@"set MapParamChangedListener failed!!!",nil);
    }
}

RCT_REMAP_METHOD(getNavigation2,getNavigation2BymapControlId:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  MapControl* mapControl = [JSObjManager getObjWithKey:Id];
  Navigation2* navi2 = [mapControl getNavigation2];
  if(navi2){
    NSInteger key = (NSInteger)navi2;
    [JSObjManager addObj:navi2];
    resolve(@{@"navigation2Id":@(key).stringValue});
  }else{
    reject(@"mapControl",@"get navi2 failed!!!",nil);
  }
}

RCT_REMAP_METHOD(getTraditionalNavi,getTraditionalNaviBymapControlId:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    MapControl* mapControl = [JSObjManager getObjWithKey:Id];
    Navigation* navi = [mapControl getNavigation];
    if(navi){
        NSInteger key = (NSInteger)navi;
        [JSObjManager addObj:navi];
        resolve(@{@"traditionalNaviId":@(key).stringValue});
    }else{
        reject(@"mapControl",@"get traditionalNavi failed!!!",nil);
    }
}

RCT_REMAP_METHOD(getCurrentGeometry,getCurrentGeometryById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  MapControl* mapControl = [JSObjManager getObjWithKey:Id];
  Geometry *geo = [mapControl getCurrentGeometry];
    if (geo) {
      GeometryType type = [geo getType];
        NSString* typeStr = nil;
        switch (type) {
            case GT_GEOPOINT:
                typeStr = @"GeoPoint";
                break;
            case GT_GEOREGION:
                typeStr = @"GeoRegion";
                break;
            case GT_GEOLINE:
                typeStr = @"GeoLine";
                break;
            default:
                typeStr = @"otherGeoType";
                break;
        }
      NSInteger key = (NSInteger)geo;
      [JSObjManager addObj:geo];
      resolve(@{@"geometryId":@(key).stringValue,@"geoType":typeStr});
    }else{
        reject(@"mapControl",@"getCurrentGeometry failed!!!",nil);
    }
}

RCT_REMAP_METHOD(getAction,getActionById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    if (Id) {
        MapControl* mapControl = [JSObjManager getObjWithKey:Id];
        int action = (int)mapControl.action;
        NSNumber* nsAction = [NSNumber numberWithInt:action];
        resolve(@{@"actionType":nsAction});
    }else{
        reject(@"mapControl",@"get Action failed!!!",nil);
    }
}

RCT_REMAP_METHOD(redo,redoById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    if (Id) {
        MapControl* mapControl = [JSObjManager getObjWithKey:Id];
        [mapControl redo];
        NSNumber* nsTrue = [NSNumber numberWithBool:YES];
        resolve(@{@"redone":nsTrue});
    }else{
        reject(@"mapControl",@"redo failed!!!",nil);
    }
}

RCT_REMAP_METHOD(undo,undoById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    if (Id) {
        MapControl* mapControl = [JSObjManager getObjWithKey:Id];
        [mapControl undo];
        NSNumber* nsTrue = [NSNumber numberWithBool:YES];
        resolve(@{@"undone":nsTrue});
    }else{
        reject(@"mapControl",@"undo failed!!!",nil);
    }
}

RCT_REMAP_METHOD(cancel,cancelById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    if (Id) {
        MapControl* mapControl = [JSObjManager getObjWithKey:Id];
        [mapControl cancel];
        NSNumber* nsTrue = [NSNumber numberWithBool:YES];
        resolve(@{@"canceled":nsTrue});
    }else{
        reject(@"mapControl",@"canceled failed!!!",nil);
    }
}

RCT_REMAP_METHOD(deleteCurrentGeometry,deleteCurrentGeometryById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    if (Id) {
        MapControl* mapControl = [JSObjManager getObjWithKey:Id];
        [mapControl deleteCurrentGeometry];
        NSNumber* nsTrue = [NSNumber numberWithBool:YES];
        resolve(@{@"deleted":nsTrue});
    }else{
        reject(@"mapControl",@"deleteCurrentGeometry failed!!!",nil);
    }
}
 /*
RCT_REMAP_METHOD(getEditLayer,getEditLayerById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    if (Id) {
        MapControl* mapControl = [JSObjManager getObjWithKey:Id];
        [mapControl deleteCurrentGeometry];
        NSNumber* nsTrue = [NSNumber numberWithBool:YES];
        resolve(@{@"deleted":nsTrue});
    }else{
        reject(@"mapControl",@"deleteCurrentGeometry failed!!!",nil);
    }
}
  */
/*
RCT_REMAP_METHOD(addGeometryAddedListener,addGeometryAddedListenerById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    MapControl* mapControl = [JSObjManager getObjWithKey:Id];
    if (mapControl) {
        mapControl.mapEditdelegate = self;
        NSNumber* nsTrue = [NSNumber numberWithBool:YES];
        resolve(nsTrue);
    }else{
        reject(@"mapControl",@"add GeometryAddedListener failed!!!",nil);
    }
}

RCT_REMAP_METHOD(removeGeometryAddedListener,removeGeometryAddedListenerById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    MapControl* mapControl = [JSObjManager getObjWithKey:Id];
    if (mapControl) {
        mapControl.mapEditdelegate = nil;
        NSNumber* nsTrue = [NSNumber numberWithBool:YES];
        resolve(nsTrue);
    }else{
        reject(@"mapControl",@"add GeometryAddedListener failed!!!",nil);
    }
} */

RCT_REMAP_METHOD(addGeometrySelectedListener,addGeometrySelectedListenerById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    MapControl* mapControl = [JSObjManager getObjWithKey:Id];
    if (mapControl) {
        mapControl.geometrySelectedDelegate = self;
        NSNumber* nsTrue = [NSNumber numberWithBool:YES];
        resolve(nsTrue);
    }else{
        reject(@"mapControl",@"add GeometryAddedListener failed!!!",nil);
    }
}

RCT_REMAP_METHOD(removeGeometrySelectedListener,removeGeometrySelectedListenerById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    MapControl* mapControl = [JSObjManager getObjWithKey:Id];
    if (mapControl) {
        mapControl.geometrySelectedDelegate = nil;
        NSNumber* nsTrue = [NSNumber numberWithBool:YES];
        resolve(nsTrue);
    }else{
        reject(@"mapControl",@"add GeometryAddedListener failed!!!",nil);
    }
}

RCT_REMAP_METHOD(addMeasureListener,addMeasureListenerById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    MapControl* mapControl = [JSObjManager getObjWithKey:Id];
    if (mapControl) {
        mapControl.mapMeasureDelegate = self;
        NSNumber* nsTrue = [NSNumber numberWithBool:YES];
        resolve(nsTrue);
    }else{
        reject(@"mapControl",@"add MeasureListener failed!!!",nil);
    }
}

RCT_REMAP_METHOD(removeMeasureListener,removeMeasureListenerById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    MapControl* mapControl = [JSObjManager getObjWithKey:Id];
    if (mapControl) {
        mapControl.mapMeasureDelegate = nil;
        NSNumber* nsTrue = [NSNumber numberWithBool:YES];
        resolve(nsTrue);
    }else{
        reject(@"mapControl",@"add MeasureListener failed!!!",nil);
    }
}

RCT_REMAP_METHOD(setRefreshListener,setRefreshListenerById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    if (Id) {
        resolve(@"1");
    }else{
        reject(@"mapControl",@"setRefreshListener failed!!!",nil);
    }
}
    
    RCT_REMAP_METHOD(addPlotLibrary,addPlotLibraryById:(NSString*)Id url:(NSString*)url resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
        MapControl* mapControl = [JSObjManager getObjWithKey:Id];
        if (mapControl) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue,^(void){
                int libId = [mapControl addPlotLibrary: [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/%@",@"TY.plot"]];
                NSNumber* num = [NSNumber numberWithInt:libId];
                resolve(num);
            });
        }else{
            reject(@"mapControl",@"add PlotLibrary failed!!!",nil);
        }
    }
    
    RCT_REMAP_METHOD(setPlotSymbol,setPlotSymbolById:(NSString*)Id libId:(int)libId symbolCode:(int)symbolCode resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
        MapControl* mapControl = [JSObjManager getObjWithKey:Id];
        if (mapControl) {
            [mapControl setPlotSymbol:libId symbolCode:symbolCode];
        }else{
            reject(@"mapControl",@"add PlotLibrary failed!!!",nil);
        }
    }
@end

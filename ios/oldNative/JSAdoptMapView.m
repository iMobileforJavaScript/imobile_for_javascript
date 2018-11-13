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
#import "SuperMap/Action.h"
#import "SuperMap/Rectangle2D.h"

@implementation JSAdoptMapView
RCT_EXPORT_MODULE(JSMapControl);
        
- (NSArray<NSString *> *)supportedEvents
{
    return @[@"Supermap.MapControl.MapParamChanged.BoundsChanged",
             @"Supermap.MapControl.MapParamChanged.ScaleChanged",
             @"com.supermap.RN.JSMapcontrol.scroll_event",
             @"com.supermap.RN.JSMapcontrol.single_tap_event",
             @"com.supermap.RN.JSMapcontrol.double_tap_event",
             @"com.supermap.RN.JSMapcontrol.touch_began_event",
             @"com.supermap.RN.JSMapcontrol.touch_end_event",
             @"com.supermap.RN.JSMapcontrol.long_press_event",
             @"com.supermap.RN.JSMapcontrol.length_measured",
             @"com.supermap.RN.JSMapcontrol.area_measured",
             @"com.supermap.RN.JSMapcontrol.angle_measured",
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

- (void)onDoubleTap:(CGPoint)onDoubleTapPos{
    CGFloat x = onDoubleTapPos.x;
    CGFloat y = onDoubleTapPos.y;
    NSNumber* nsX = [NSNumber numberWithFloat:x];
    NSNumber* nsY = [NSNumber numberWithFloat:y];
    [self sendEventWithName:@"com.supermap.RN.JSMapcontrol.double_tap_event"
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
    [self sendEventWithName:@"com.supermap.RN.JSMapcontrol.touch_began_event"
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
    
    [self sendEventWithName:@"com.supermap.RN.JSMapcontrol.touch_end_event"
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

    [self sendEventWithName:@"com.supermap.RN.JSMapcontrol.scroll_event"
                       body:@{@"local":@{@"x":nsX,@"y":nsY}
                              }];
}

-(void)geometrySelected:(int)geometryID Layer:(Layer*)layer{
    NSNumber* nsId = [NSNumber numberWithInt:geometryID];
//    NSInteger nsLayer = (NSInteger)layer;
    NSString* nsLayer = [JSObjManager addObj:layer];
    [self sendEventWithName:@"com.supermap.RN.JSMapcontrol.geometry_selected" body:@{@"layerId":nsLayer,
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

-(void)measureState{
    
}
-(double)getMeasureResult:(double)result lastPoint:(Point2D*)lastPoint type:(int)type{
    NSNumber *nsResult = [NSNumber numberWithDouble:result];
    double x = lastPoint.x;
    double y = lastPoint.y;
    NSNumber* nsX = [NSNumber numberWithDouble:x];
    NSNumber* nsY = [NSNumber numberWithDouble:y];
    
    //MapControl*mapCtrl = [JSObjManager getObjWithKey:@"com.supermap.mapControl"];
    //Action action = mapCtrl.action;
    if(type == 0){
        [self sendEventWithName:@"com.supermap.RN.JSMapcontrol.length_measured"
                           body:@{@"curResult":nsResult,
                                  @"curPoint":@{@"x":nsX,@"y":nsY}
                                  }];
    }
    
    if(type == 1){
        [self sendEventWithName:@"com.supermap.RN.JSMapcontrol.area_measured"
                           body:@{@"curResult":nsResult,
                                  @"curPoint":@{@"x":nsX,@"y":nsY}
                                  }];
    }
    
    if(type == 2){
        [self sendEventWithName:@"com.supermap.RN.JSMapcontrol.angle_measured"
                           body:@{@"curAngle":nsResult,
                                  @"curPoint":@{@"x":nsX,@"y":nsY}
                                  }];
    }
    
    return result;
}


RCT_REMAP_METHOD(getMap,geMapKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  MapControl* mapcontrol = [JSObjManager getObjWithKey:key];
  if(mapcontrol){
    Map* map = mapcontrol.map;
    [JSObjManager addObj:map];
    NSInteger key = (NSInteger)map;
    resolve(@{@"mapId":@(key).stringValue});
  }else
    reject(@"MapControl",@"getMap() failed.",nil);
}

RCT_REMAP_METHOD(setAction,mapControlId:(NSString*)Id actionType:(int)type resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    MapControl* mapControl = [JSObjManager getObjWithKey:Id];
    if (mapControl) {
        mapControl.action = type;
        resolve(@"1");
    }else{
        reject(@"MapControl",@"setAction() failed.",nil);
    }
}

RCT_REMAP_METHOD(submit,submitByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [JSObjManager getObjWithKey:key];
//        BOOL result = [mapControl submit];
//        resolve([NSNumber numberWithBool:result]);
        
        [mapControl submit];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl",@"submit() failed.",nil);
    }
//    MapControl* mapControl = [JSObjManager getObjWithKey:key];
//    if (mapControl) {
//        BOOL result = [mapControl submit];
//        resolve([NSNumber numberWithBool:result]);
//    }else{
//        reject(@"MapControl",@"submit() failed.",nil);
//    }
}

RCT_REMAP_METHOD(setGestureDetector,setGestureDetectorById:(NSString*)mapControlId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    MapControl* mapCtrl = [JSObjManager getObjWithKey:mapControlId];
    if(mapCtrl){
        mapCtrl.delegate =self;
        NSNumber* nsTrue = [NSNumber numberWithBool:TRUE];
        resolve(nsTrue);
    }else{
        reject(@"MapControl",@"setGestureDetector() failed.",nil);
    }
}

RCT_REMAP_METHOD(deleteGestureDetector,deleteGestureDetectorById:(NSString*)mapControlId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    MapControl* mapCtrl = [JSObjManager getObjWithKey:mapControlId];
    if(mapCtrl){
        mapCtrl.delegate = nil;
        NSNumber* nsTrue = [NSNumber numberWithBool:TRUE];
        resolve(nsTrue);
    }else{
        reject(@"MapControl",@"deleteGestureDetector() failed.",nil);
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
        reject(@"MapControl",@"setMapParamChangedListener() failed.",nil);
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
    reject(@"MapControl",@"getNavigation2() failed.",nil);
  }
}

RCT_REMAP_METHOD(outputMap,outputMapId:(NSString*)Id mapViewId:(NSString*)Id w:(int)width h:(int)height q:(int)quality type:(NSString*) type resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    MapControl* mapControl = [JSObjManager getObjWithKey:Id];
    
    // = [NSHomeDirectory() stringByAppendingString:@"/tmp"];
    if(mapControl){
        
        int64_t delayInSeconds = 2;      // 延迟的时间
        /*
         *@parameter 1,时间参照，从此刻开始计时
         *@parameter 2,延时多久，此处为秒级，还有纳秒等。10ull * NSEC_PER_MSEC
         */
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // do something
            NSString* imagePath;
            int w = width;
            int h = height;
            if(w > mapControl.frame.size.width*[UIScreen mainScreen].scale){
                w = mapControl.frame.size.width*[UIScreen mainScreen].scale;
            }
            if(h > mapControl.frame.size.height*[UIScreen mainScreen].scale){
                h = mapControl.frame.size.height*[UIScreen mainScreen].scale;
            }
//            NSString* name = mapControl.map.name;
//            NSString* ds = mapControl.map.description;
            Rectangle2D* bounds =mapControl.map.viewBounds;
            CGPoint point = [mapControl.map mapToPixel:mapControl.map.center];
            //            CGPoint point1 = [mapControl.map mapToPixel:[[Point2D alloc] initWithX:bounds.left Y:bounds.bottom]];
            //            CGPoint point2 = [mapControl.map mapToPixel:[[Point2D alloc] initWithX:bounds.right Y:bounds.bottom]];
            //            CGPoint point3 = [mapControl.map mapToPixel:[[Point2D alloc] initWithX:bounds.right Y:bounds.bottom]];
            
            CGImageRef im = [mapControl outputMap:CGRectMake(point.x-200, point.y-200, 400, 400)];
            UIImage* image = [[UIImage alloc]initWithCGImage:im];
            // UIImageView* iv = [[UIImageView alloc]initWithImage:image];
            //[mapControl addSubview:iv];
            NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
            
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
            if([type isEqualToString:@"jpeg"] || [type isEqualToString:@"jpg"]){
                imagePath = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/%@.jpg",timeSp];
                [UIImageJPEGRepresentation(image, quality/100.0) writeToFile:imagePath atomically:YES];
            }else{
                imagePath = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/%@.png",timeSp];
                [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
            }
            if(imagePath)
                resolve(@{@"result":@(1),@"uri":imagePath});
            else{
                resolve(@{@"result":@(0),@"uri":@""});
            }

        });
    }else{
        reject(@"MapControl",@"getCollector() failed.",nil);
    }
}

RCT_REMAP_METHOD(getCollector,getCollectorId:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    MapControl* mapControl = [JSObjManager getObjWithKey:Id];
    Collector* collector = [mapControl getCollector];
    if(collector){
        NSString* key = @("Collector");
        [JSObjManager addObjWithKey:collector key:key];
        resolve([JSObjManager addObj:collector]);
    }else{
        reject(@"MapControl",@"getCollector() failed.",nil);
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
        reject(@"MapControl",@"getTraditionalNavi() failed.",nil);
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
        reject(@"MapControl",@"getCurrentGeometry() failed.",nil);
    }
}

RCT_REMAP_METHOD(getAction,getActionById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    if (Id) {
        MapControl* mapControl = [JSObjManager getObjWithKey:Id];
        int action = (int)mapControl.action;
        NSNumber* nsAction = [NSNumber numberWithInt:action];
        resolve(@{@"actionType":nsAction});
    }else{
        reject(@"MapControl",@"getAction() failed.",nil);
    }
}

RCT_REMAP_METHOD(redo,redoById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    if (Id) {
        MapControl* mapControl = [JSObjManager getObjWithKey:Id];
        [mapControl redo];
        NSNumber* nsTrue = [NSNumber numberWithBool:YES];
        resolve(@{@"redone":nsTrue});
    }else{
        reject(@"MapControl",@"redo() failed.",nil);
    }
}

RCT_REMAP_METHOD(undo,undoById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    if (Id) {
        MapControl* mapControl = [JSObjManager getObjWithKey:Id];
        [mapControl undo];
        NSNumber* nsTrue = [NSNumber numberWithBool:YES];
        resolve(@{@"undone":nsTrue});
    }else{
        reject(@"MapControl",@"undo() failed.",nil);
    }
}

RCT_REMAP_METHOD(cancel,cancelById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    if (Id) {
        MapControl* mapControl = [JSObjManager getObjWithKey:Id];
        [mapControl cancel];
        NSNumber* nsTrue = [NSNumber numberWithBool:YES];
        resolve(@{@"canceled":nsTrue});
    }else{
        reject(@"MapControl",@"cancel() failed.",nil);
    }
}

RCT_REMAP_METHOD(deleteCurrentGeometry,deleteCurrentGeometryById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    if (Id) {
        MapControl* mapControl = [JSObjManager getObjWithKey:Id];
        [mapControl deleteCurrentGeometry];
        NSNumber* nsTrue = [NSNumber numberWithBool:YES];
        resolve(@{@"deleted":nsTrue});
    }else{
        reject(@"MapControl",@"deleteCurrentGeometry() failed.",nil);
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
        reject(@"MapControl",@"getEditLayer() failed.",nil);
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
        reject(@"MapControl",@"addGeometryAddedListener() failed.",nil);
    }
}

RCT_REMAP_METHOD(removeGeometryAddedListener,removeGeometryAddedListenerById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    MapControl* mapControl = [JSObjManager getObjWithKey:Id];
    if (mapControl) {
        mapControl.mapEditdelegate = nil;
        NSNumber* nsTrue = [NSNumber numberWithBool:YES];
        resolve(nsTrue);
    }else{
        reject(@"MapControl",@"removeGeometryAddedListener() failed.",nil);
    }
} */

RCT_REMAP_METHOD(addGeometrySelectedListener,addGeometrySelectedListenerById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    MapControl* mapControl = [JSObjManager getObjWithKey:Id];
    if (mapControl) {
        mapControl.geometrySelectedDelegate = self;
        NSNumber* nsTrue = [NSNumber numberWithBool:YES];
        resolve(nsTrue);
    }else{
        reject(@"MapControl",@"addGeometrySelectedListener() failed.",nil);
    }
}

RCT_REMAP_METHOD(removeGeometrySelectedListener,removeGeometrySelectedListenerById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    MapControl* mapControl = [JSObjManager getObjWithKey:Id];
    if (mapControl) {
        mapControl.geometrySelectedDelegate = nil;
        NSNumber* nsTrue = [NSNumber numberWithBool:YES];
        resolve(nsTrue);
    }else{
        reject(@"MapControl",@"removeGeometrySelectedListener() failed.",nil);
    }
}

RCT_REMAP_METHOD(addMeasureListener,addMeasureListenerById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    MapControl* mapControl = [JSObjManager getObjWithKey:Id];
    if (mapControl) {
        mapControl.mapMeasureDelegate = self;
        NSNumber* nsTrue = [NSNumber numberWithBool:YES];
        resolve(nsTrue);
    }else{
        reject(@"MapControl",@"addMeasureListener() failed.",nil);
    }
}

RCT_REMAP_METHOD(removeMeasureListener,removeMeasureListenerById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    MapControl* mapControl = [JSObjManager getObjWithKey:Id];
    if (mapControl) {
        mapControl.mapMeasureDelegate = nil;
        NSNumber* nsTrue = [NSNumber numberWithBool:YES];
        resolve(nsTrue);
    }else{
        reject(@"MapControl",@"removeMeasureListener() failed.",nil);
    }
}

RCT_REMAP_METHOD(setRefreshListener,setRefreshListenerById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    if (Id) {
        resolve(@"1");
    }else{
        reject(@"MapControl",@"setRefreshListener() failed.",nil);
    }
}

RCT_REMAP_METHOD(addPlotLibrary,addPlotLibraryById:(NSString*)Id url:(NSString*)url resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [JSObjManager getObjWithKey:Id];
        int libId = [mapControl addPlotLibrary:url];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue,^(void){
            /*
             int libId = [mapControl addPlotLibrary: [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/%@",@"TY.plot"]];
             */
            NSNumber* num = [NSNumber numberWithInt:libId];
            resolve(num);
        });
    } @catch (NSException *exception) {
        reject(@"MapControl",@"addPlotLibrary() failed.",nil);
    }
}

RCT_REMAP_METHOD(removePlotLibrary,removePlotLibraryById:(NSString*)Id libId:(int)libId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [JSObjManager getObjWithKey:Id];
        [mapControl removePlotLibrary:libId];
        NSNumber* num = [NSNumber numberWithBool:true];
        resolve(num);
    } @catch (NSException *exception) {
        reject(@"MapControl",@"removePlotLibrary() failed.",nil);
    }
}
    
RCT_REMAP_METHOD(setPlotSymbol,setPlotSymbolById:(NSString*)Id libId:(int)libId symbolCode:(int)symbolCode resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [JSObjManager getObjWithKey:Id];
        [mapControl setPlotSymbol:libId symbolCode:symbolCode];
        NSNumber* num = [NSNumber numberWithBool:true];
        resolve(num);
    } @catch (NSException *exception) {
        reject(@"MapControl",@"setPlotSymbol() failed.",nil);
    }
}

RCT_REMAP_METHOD(appointEditGeometry,appointEditGeometryById:(NSString*)Id geoId:(int)geoId layerId:(NSString*)layerId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [JSObjManager getObjWithKey:Id];
        Layer* layer = [JSObjManager getObjWithKey:layerId];
        bool result = [mapControl appointEditGeometryWithID:geoId Layer:layer];
        NSNumber* num = [NSNumber numberWithBool:result];
        resolve(num);
    } @catch (NSException *exception) {
        reject(@"MapControl",@"setPlotSymbol() failed.",nil);
    }
}

RCT_REMAP_METHOD(dispose, disposeById:(NSString*)Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [JSObjManager getObjWithKey:Id];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [mapControl dispose];
            [JSObjManager removeObj:Id];
        });
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl",@"setPlotSymbol() failed.",nil);
    }
}
@end

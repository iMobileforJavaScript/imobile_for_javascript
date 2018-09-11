//
//  JSMap.m
//  rnTest
//
//  Created by imobile-xzy on 16/7/5.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSMap.h"
#import "SuperMap/Layers.h"
#import "SuperMap/Layer.h"
#import "SuperMap/Dataset.h"
#import "SuperMap/Rectangle2D.h"
#import "SuperMap/Point2D.h"
#import "JSObjManager.h"
#import "JSRectangle2D.h"
#import "JSPoint.h"
#import "SuperMap/Theme.h"

@implementation JSMap
//所有导出方法名
- (NSArray<NSString *> *)supportedEvents
{
    return @[@"com.supermap.RN.JSMap.map_loaded", @"com.supermap.RN.JSMap.map_opened", @"com.supermap.RN.JSMap.map_closed"];
}
//地图册第一次加载完毕代理方法
-(void) onMapLoaded{
    [self sendEventWithName:@"com.supermap.RN.JSMap.map_loaded"
                       body:@{@"body":@"this delegate no body"
                              }];
}
-(void) mapOpened{
    [self sendEventWithName:@"com.supermap.RN.JSMap.map_opened"
                       body:@{@"body":@"this delegate no body"
                              }];
}

-(void) mapClosed{
    [self sendEventWithName:@"com.supermap.RN.JSMap.map_closed"
                       body:@{@"body":@"this delegate no body"
                              }];
}
//注册为Native模块
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(setWorkspace,userKey:(NSString*)key workSpaceKey:(NSString*)workSpaceKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Map* map = [JSObjManager getObjWithKey:key];
  Workspace* workspace = [JSObjManager getObjWithKey:workSpaceKey];
  if(map && workspace){
    [map setWorkspace:workspace];
    resolve(@"set workspace seccessfully");
  }else
    reject(@"Map",@"setWorkspace: Map or workspace not exeist!!!",nil);
}

RCT_REMAP_METHOD(refresh,userKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Map* map = [JSObjManager getObjWithKey:key];
  if(map){
    [map refresh];
    resolve(@"map refresh successfully");
  }else
    reject(@"Map",@"refresh:Map or workspace not exeist!!!",nil);
}

#pragma mark - 原Layers类方法
/**
 根据图层序号获取图层

 @param key get description
 @param index map键值
 @return promise
 */
RCT_REMAP_METHOD(getLayer,getLayerByKey:(NSString*)key andlayerIndex:(int)index resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    if(map){
        Layers* layers = map.layers;
        Layer* layer = [layers getLayerAtIndex:index];
        NSInteger key = (NSInteger)layer;
        [JSObjManager addObj:layer];
        resolve(@{@"layerId":@(key).stringValue});
    }else
        reject(@"Map",@"getLayer:get layer failed !",nil);
}

RCT_REMAP_METHOD(getLayerByName,getLayerByKey:(NSString*)key andName:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    @try {
        if(map){
            Layers* layers = map.layers;
            Layer* layer = [layers getLayerWithName:name];
            NSInteger key = (NSInteger)layer;
            [JSObjManager addObj:layer];
            resolve(@{@"layerId":@(key).stringValue});
        }
    } @catch (NSException *exception) {
        reject(@"Map",@"getLayerByName:get layer failed !",nil);
    }
}

RCT_REMAP_METHOD(getName,getNameByKey:(NSString*)key  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    if(map){
        
        NSString* mapName = map.name;
        resolve(mapName);
    }else
        reject(@"Map",@"getLayerByName:get layer failed !",nil);
}

RCT_REMAP_METHOD(insert,insertKey:(NSString*)key  index:(int)index layerId:(NSString*)layerId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    Layer* layer = [JSObjManager getObjWithKey:layerId];
    if(map){
        
        NSString* mapName = map.name;
        resolve(mapName);
    }else
        reject(@"Map",@"getLayerByName:get layer failed !",nil);
}

RCT_REMAP_METHOD(isModified,isModifiedKey:(NSString*)key  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    if(map){
    
        resolve(@(map.isModified));
    }else
        reject(@"Map",@"getLayerByName:get layer failed !",nil);
}

RCT_REMAP_METHOD(getLayersByType, getLayersByTypeyKey:(NSString*)key  type:(int)type resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    if(map){
        
        Layers* layers = map.layers;
        int count = [layers getCount];
        NSMutableArray* arr = [[NSMutableArray alloc]initWithCapacity:5];
        for (int i = 0; i < count; i++) {
            Layer* layer = [layers getLayerAtIndex:i];
            Dataset* dataset = layer.dataset;
            
            DatasetType dType = dataset.datasetType;
            if ( dType == type || type == -1) {
                NSString* layerId = [JSObjManager addObj:layer];
               
                Theme* theme = layer.theme;
                int themeType = 0;
                themeType = theme.themeType;
                NSString* datasetName;
                if (dataset.name != nil) {
                    datasetName = dataset.name;
                } else {
                    datasetName = @"";
                }
                NSDictionary* wMap = @{@"id":layerId,
                                       @"type":@(dType),
                                       @"themeType":@(themeType),
                                       @"index":@(i),
                                       @"name": layer.name,
                                       @"caption": layer.caption,
                                       @"description": layer.description,
                                       @"datasetName": datasetName,
                                       @"isEditable": @(layer.editable),
                                       @"isVisible": @(layer.visible),
                                       @"isSelectable": @(layer.selectable),
                                       @"isSnapable": @(layer.isSnapable)
                                       };
              
                [arr addObject:wMap];
            }
        }
        resolve(arr);
    }else
        reject(@"Map",@"getLayerByName:get layer failed !",nil);
}

RCT_REMAP_METHOD(getLayersWithType, ggetLayersWithTypeKey:(NSString*)key  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    if(map){
        
        Layers* layers = map.layers;
        int count = [layers getCount];
        
        NSMutableDictionary* temp = [[NSMutableDictionary alloc]initWithCapacity:5];
        NSMutableArray* arr = nil;//[[NSMutableArray alloc]initWithCapacity:5];
        for (int i = 0; i < count; i++) {
            Layer* layer = [layers getLayerAtIndex:i];
            Dataset* dataset = layer.dataset;
            
            DatasetType dType = dataset.datasetType;
            if ( ![temp.allKeys containsObject:@(dType)]) {
                arr = [[NSMutableArray alloc]initWithCapacity:5];
                temp[@(dType)] = arr;
            }
            arr = temp[@(dType)];
            NSString* layerId = [JSObjManager addObj:layer];
            NSDictionary* wMap = @{@"id":layerId,
                                   @"type":@(dType),
                                   @"index":@(i),
                                   @"name": layer.name,
                                   @"caption": layer.caption,
                                   @"description": layer.description,
                                   @"datasetName": dataset.name,
                                   @"isEditable": @(layer.editable),
                                   @"isVisible": @(layer.visible),
                                   @"isSelectable": @(layer.selectable),
                                   @"isSnapable": @(layer.isSnapable)
                                   };
            
            [arr addObject:wMap];
        }
        NSMutableArray* resultArr = [NSMutableArray array];
        for(NSNumber* key in temp.allKeys){
            [resultArr addObject:[NSString stringWithFormat:@"%@",key]];
            [resultArr addObject:temp[key]];
        }
        resolve(resultArr);
    }else
        reject(@"Map",@"Map getLayersWithType:get layer failed !",nil);
}


RCT_REMAP_METHOD(containsCaption,acontainsCaptionKey:(NSString*)key cation:(NSString*)cation datasourceName:(NSString*)datasourceName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    
    if(map){
        int count = [map.layers getCount];
        BOOL isContain = false;
        
        for(int i = 0; i < count; i++) {
            
            NSString* layerCaption = [map.layers getLayerAtIndex:i].caption;
            
            if ([layerCaption containsString:[NSString stringWithFormat:@"%@@%@",cation,datasourceName]]) {
                isContain = true;
                break;
            }
        }
        
        resolve(@{@"isContain":@(isContain)});
    }else
        reject(@"Map",@"containsCaption:Map or Dataset not exeist!",nil);
}

RCT_REMAP_METHOD(addDataset,addDatasetByKey:(NSString*)key andDataSetId:(NSString*)id withHeadBool:(BOOL)ToHead resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    Dataset* dataset = [JSObjManager getObjWithKey:id];
    if(map&&dataset){
        Layers* layers = map.layers;
        [layers addDataset:dataset ToHead:ToHead];
        resolve(@"successfully add dataset!");
    }else
        reject(@"Map",@"addDataset:Map or Dataset not exeist!",nil);
}

RCT_REMAP_METHOD(getLayers,getLayersUserKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Map* map = [JSObjManager getObjWithKey:key];
  if(map){
    Layers* layers = map.layers;
    NSInteger key = (NSInteger)layers;
    [JSObjManager addObj:layers];
    resolve(@{@"layersId":@(key).stringValue});
  }else
    reject(@"Map",@"getLayers:Map not exeist!!!",nil);
}

RCT_REMAP_METHOD(getLayersCount,getLayersCountByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    if(map){
        Layers* layers = map.layers;
        int layerCount = [layers getCount];
        NSNumber* nsLayerCount = [NSNumber numberWithInt:layerCount];
        resolve(@{@"count":nsLayerCount});
    }else
        reject(@"Map",@"getLayersCount:Map not exeist!",nil);
}

#pragma mark - map方法

RCT_REMAP_METHOD(open,openKey:(NSString*)key mapName:(NSString*)mapName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  
  Map* map = [JSObjManager getObjWithKey:key];
  if(map){
    if(![map open:mapName]){
      NSLog(@"OPen map %@ failed",mapName);
    }
     resolve(@"1");
  }else
    reject(@"Map",@"open:Map object do not exeist!!!",nil);
}

RCT_REMAP_METHOD(close,closeByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    Map* map = [JSObjManager getObjWithKey:key];
    if(map){
        [map close];
        resolve(@"closed");
    }else
        reject(@"Map",@"close:Map not exeist!!!",nil);
}

RCT_REMAP_METHOD(pixelToMap,pixelToMapByKey:(NSString*)key andPointId:(NSString*)pointId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    NSDictionary* pointDic = [JSObjManager getObjWithKey:pointId];
    if(map&&pointDic){
        //抽出根据pointId构造cgpoint方法
        NSNumber* nsX = [pointDic objectForKey:@"x"];
        NSNumber* nsY = [pointDic objectForKey:@"y"];
        double pointX = nsX.doubleValue;
        double pointY = nsY.doubleValue;
        CGPoint point = CGPointMake(pointX, pointY);
        Point2D* point2D = [map pixelTomap:point];
        NSNumber* nsPointX = [NSNumber numberWithDouble:point2D.x];
        NSNumber* nsPointY = [NSNumber numberWithDouble:point2D.y];
        NSInteger key = (NSInteger)point2D;
        [JSObjManager addObj:point2D];
        resolve(@{@"point2DId":@(key).stringValue,@"x":nsPointX,@"y":nsPointY});
    }else{
        reject(@"Map",@"pixelToMap failed!!!",nil);
    }
}

RCT_REMAP_METHOD(mapToPixel,mapToPixelByKey:(NSString*)key andPoint2DId:(NSString*)point2DId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    Point2D* point2d = [JSObjManager getObjWithKey:point2DId];
    if(map&&point2d){
        CGPoint point = [map mapToPixel:point2d];
        NSNumber* nsX = [NSNumber numberWithDouble:point.x];
        NSNumber* nsY = [NSNumber numberWithDouble:point.y];
        NSString* jsPointId = [JSPoint createObjWithX:point.x Y:point.y];
        resolve(@{@"pointId":jsPointId,@"x":nsX,@"y":nsY});
    }else{
        reject(@"Map",@"mapToPixel failed!!!",nil);
    }
}

RCT_REMAP_METHOD(getCenter,getCenterByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    if(map){
        Point2D* point = map.center;
        [JSObjManager addObj:point];
        double x = point.x;
        NSNumber* nsX = [NSNumber numberWithDouble:x];
        double y = point.y;
        NSNumber* nsY = [NSNumber numberWithDouble:y];
        NSInteger nsPoint = (NSInteger)point;
        resolve(@{@"point2DId":@(nsPoint).stringValue,@"x":nsX,@"y":nsY});
    }else{
        reject(@"Map",@"get Center failed!!!",nil);
    };
}

RCT_REMAP_METHOD(setCenter,setCenterKey:(NSString*)key point2DId:(NSString*)point2DId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Map* map = [JSObjManager getObjWithKey:key];
  Point2D* point = [JSObjManager getObjWithKey:point2DId];
  if(map&&point){
    map.center = point;
    resolve(@"1");
  }else{
    reject(@"Map",@"setCenter failed!!!",nil);
  };
}

RCT_REMAP_METHOD(getTrackingLayer,getTrackingLayerKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Map* map = [JSObjManager getObjWithKey:key];
  if(map.trackingLayer){
    NSInteger trackingKey = (NSInteger)map.trackingLayer;
    [JSObjManager addObj:map.trackingLayer];
    resolve(@{@"trackingLayerId":@(trackingKey).stringValue});
  }else{
    reject(@"Map",@"getTrackingLayer failed!!!",nil);
  }
}

RCT_REMAP_METHOD(saveAs,saveAsByKey:(NSString*)key andName:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    if(map){
        BOOL saved = [map saveAs:name];
        NSNumber* nsSaved = [NSNumber numberWithBool:saved];
        resolve(@{@"saved":nsSaved});
    }else{
        reject(@"Map",@"saveAsName failed!!!",nil);
    }
}

RCT_REMAP_METHOD(save,saveByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    if(map){
        BOOL saved = [map save];
        NSNumber* nsSaved = [NSNumber numberWithBool:saved];
        resolve(@{@"saved":nsSaved});
    }else{
        reject(@"Map",@"save failed!!!",nil);
    }
}

RCT_REMAP_METHOD(getBounds,getBoundsByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    if(map){
        Rectangle2D* bounds = map.bounds;
        NSDictionary* dic = [JSRectangle2D reactangle2DToDic:bounds];
        resolve(@{@"bound":dic});
    }else{
        reject(@"Map",@"getBounds failed!!!",nil);
    }
}

RCT_REMAP_METHOD(getViewBounds,getViewBoundsByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    if(map){
        Rectangle2D* bounds = map.viewBounds;
        NSDictionary* dic = [JSRectangle2D reactangle2DToDic:bounds];
        resolve(@{@"bound":dic});
    }else{
        reject(@"Map",@"getBounds failed!!!",nil);
    }
}

RCT_REMAP_METHOD(setViewBounds,setViewBoundsByKey:(NSString*)key andBounds:(NSDictionary*)boundsDic resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    if(map){
        
        Rectangle2D* bounds = [JSRectangle2D dicToReactangle2D:boundsDic];
        map.viewBounds = bounds;
        resolve(@"setted");
    }else{
        reject(@"Map",@"getBounds failed!!!",nil);
    }
}
/* ios端暂无此接口
RCT_REMAP_METHOD(isDynamicProjection,isDynamicProjectionByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    if(map){
        Rectangle2D* bounds = map.viewBounds;
        NSDictionary* dic = [JSRectangle2D reactangle2DToDic:bounds];
        resolve(@{@"bound":dic});
    }else{
        reject(@"Map",@"getBounds failed!!!",nil);
    }
}
 */

RCT_REMAP_METHOD(setDynamicProjection,setDynamicProjectionByKey:(NSString*)key andValue:(BOOL)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    if(map){
        [map setDynamicProjection:value];
        resolve(@"setted");
    }else{
        reject(@"Map",@"setDynamicProjection failed!!!",nil);
    }
}

RCT_REMAP_METHOD(setMapLoadedListener,setMapLoadedListenerByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    if(map){
        map.mapLoadDelegate =self;
        NSNumber* nsTrue = [NSNumber numberWithBool:TRUE];
        resolve(nsTrue);
    }else{
        reject(@"Map",@"setMapLoadedListener failed!!!",nil);
    }
}

RCT_REMAP_METHOD(setMapOperateListener,setMapOperateListenerByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    if(map){
        map.delegate =self;
        NSNumber* nsTrue = [NSNumber numberWithBool:TRUE];
        resolve(nsTrue);
    }else{
        reject(@"Map",@"setMapOperateListener failed!!!",nil);
    }
}

RCT_REMAP_METHOD(pan,panByKey:(NSString*)key andOffsetX:(double)offsetX andOffsetY:(double)offsetY resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    if(map){
        [map panOffsetX:offsetX offsetY:offsetY];
        resolve(@"panned");
    }else{
        reject(@"Map",@"pan failed!!!",nil);
    }
}

RCT_REMAP_METHOD(viewEntire,viewEntireByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    if(map){
        [map viewEntire];
        resolve(@"viewEntire");
    }else{
        reject(@"Map",@"viewEntire failed!!!",nil);
    }
}

RCT_REMAP_METHOD(zoom,zoomByKey:(NSString*)key andRatio:(double)ratio resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    if(map){
        [map zoom:ratio];
        resolve(@"zoomed");
    }else{
        reject(@"Map",@"zoom failed!!!",nil);
    }
}

RCT_REMAP_METHOD(getScale,getScaleByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    if(map){
        double scale = map.scale;
        NSNumber* nsScale = [NSNumber numberWithDouble:scale];
        resolve(@{@"scale":nsScale});
    }else{
        reject(@"Map",@"zoom failed!!!",nil);
    }
}

RCT_REMAP_METHOD(setScale,map:(NSString*)key setScale:(double)scale resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    if(map){
        map.scale = scale;
        resolve([NSNumber numberWithBool:true]);
    }else{
        reject(@"Map",@"zoom failed!!!",nil);
    }
}

RCT_REMAP_METHOD(addLayer,addLayerById:(NSString*)mapId andDatasetId:(NSString*)dsId andHead:(BOOL)head resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:mapId];
    Dataset* dataset = [JSObjManager getObjWithKey:dsId];
  if(map&&dataset){
      Layers* layers = map.layers;
      Layer* addingLayer = [layers addDataset:dataset ToHead:head];
    NSInteger layerKey = (NSInteger)addingLayer;
    [JSObjManager addObj:addingLayer];
    resolve(@{@"layerId":@(layerKey).stringValue});
  }else{
    reject(@"Map",@"addLayer failed!!!",nil);
  }
}

RCT_REMAP_METHOD(removeLayerByName,removeLayerById:(NSString*)mapId andName:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:mapId];
    Layers* layers = map.layers;
    Layer* removingLayer = [layers getLayerWithName:name];
    BOOL isRemove = [layers removeWithName:name];
    if(isRemove){
        NSInteger layerKey = (NSInteger)removingLayer;
        [JSObjManager addObj:removingLayer];
        resolve(@{@"layerId":@(layerKey).stringValue});
    }else{
        reject(@"Map",@"remove Layer By Name failed!!!",nil);
    }
}

RCT_REMAP_METHOD(removeLayerByIndex,removeLayerById:(NSString*)mapId andIndex:(int)index resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:mapId];
    Layers* layers = map.layers;
    Layer* removingLayer = [layers getLayerAtIndex:index];
    BOOL isRemove = [layers removeAt:index];
    if(isRemove){
        NSInteger layerKey = (NSInteger)removingLayer;
        [JSObjManager addObj:removingLayer];
        resolve(@{@"layerId":@(layerKey).stringValue});
    }else{
        reject(@"Map",@"remove Layer By Index failed!!!",nil);
    }
}

RCT_REMAP_METHOD(contains,containsById:(NSString*)mapId andName:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:mapId];
    Layers* layers = map.layers;
    if(layers){
        int index = [layers indexOf:name];
        NSNumber* result = nil;
        if (index ==-1) {
            result = [NSNumber numberWithBool:false];
        }else{
            result = [NSNumber numberWithBool:true];
        }
        resolve(@{@"isContain":result});
    }else{
        reject(@"Map",@"remove Layer By Index failed!!!",nil);
    }
}

RCT_REMAP_METHOD(moveDown,moveDownById:(NSString*)mapId andName:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:mapId];
    Layers* layers = map.layers;
    int count = [layers getCount];
    int index = [layers indexOf:name];
    if(layers && index<=count-2 && index>=0){
        BOOL isMove = [layers moveTo:index desIndex:index+1];
        NSNumber* nsIsMove = [NSNumber numberWithBool:isMove];
        resolve(@{@"moved":nsIsMove});
    }else{
        reject(@"Map",@"move down By name failed!!!",nil);
    }
}

RCT_REMAP_METHOD(moveUp,moveUpById:(NSString*)mapId andName:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:mapId];
    Layers* layers = map.layers;
    int count = [layers getCount];
    int index = [layers indexOf:name];
    if(layers && index<=count-1 && index>0){
        BOOL isMove = [layers moveTo:index desIndex:index-1];
        NSNumber* nsIsMove = [NSNumber numberWithInt:isMove];
        resolve(@{@"moved":nsIsMove});
    }else{
        reject(@"Map",@"move down By name failed!!!",nil);
    }
}

RCT_REMAP_METHOD(addThemeLayer,addThemeLayerById:(NSString*)mapId datasetId:(NSString*)datasetId themeId:(NSString*)themeId toHead:(BOOL)isHead resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:mapId];
    Dataset* dataset = [JSObjManager getObjWithKey:datasetId];
    Theme* theme = [JSObjManager getObjWithKey:themeId];
    Layers* layers = map.layers;
    if(layers){
        Layer* themeLayer = [layers addDataset:dataset Theme:theme ToHead:isHead];
        NSInteger themeLayerKey = (NSInteger)themeLayer;
        [JSObjManager addObj:themeLayer];
        resolve(@{@"layerId":@(themeLayerKey).stringValue});
    }else{
        reject(@"Map",@"add Theme Layer failed!!!",nil);
    }
}

RCT_REMAP_METHOD(isModified,mapId:(NSString*)mapId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:mapId];
  
    if(map){
        BOOL b = map.isModified;
        resolve(@{@"isModified":@(b)});
    }else{
        reject(@"Map",@"isModified Layer failed!!!",nil);
    }
}


// 此接口未开出
RCT_REMAP_METHOD(getPrjCoordSys,getPrjCoordSysKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Map* map = [JSObjManager getObjWithKey:key];
    if(map.prjCoordSys){
        NSInteger projKey = (NSInteger)map.prjCoordSys;
        [JSObjManager addObj:map.prjCoordSys];
        resolve(@(projKey).stringValue);
    }else{
        reject(@"Map",@"getProjSys failed!!!",nil);
    }
}
 

@end

//
//  JSNavigation2.m
//  HelloWorldDemo
//
//  Created by 王子豪 on 2016/11/23.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "SuperMap/Map.h"
#import "SuperMap/CoordSysTranslator.h"
#import "SuperMap/Navigation2.h"
#import "SuperMap/Point2D.h"
#import "SuperMap/Point2Ds.h"
#import "JSObjManager.h"
#import "JSNavigation2.h"

@implementation JSNavigation2
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(setPathVisible,setPathVisibleById:(NSString*)nav2Id visible:(BOOL)visible resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Navigation2* nav = [JSObjManager getObjWithKey:nav2Id];
  if (nav) {
    [nav setPathVisible:visible];
    resolve(@"path visible setted");
  }else{
    reject(@"Nav2",@"setPathVisible failed!!!",nil);
  }
}

RCT_REMAP_METHOD(setNetworkDataset,setNetworkDatasetById:(NSString*)nav2Id datasetId:(NSString*)datasetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Navigation2* nav = [JSObjManager getObjWithKey:nav2Id];
  DatasetVector* dsVector = [JSObjManager getObjWithKey:datasetId];
  if (nav&&dsVector) {
    [nav setNetworkDataset:dsVector];
    resolve(@"network dataset setted");
  }else{
    reject(@"Nav2",@"setNetworkDataset failed!!!",nil);
  }
}

RCT_REMAP_METHOD(loadModel,loadModelById:(NSString*)nav2Id filePath:(NSString*)path resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation2* nav = [JSObjManager getObjWithKey:nav2Id];
    if(nav){
        [nav loadModel:path];
        resolve(@"model loaded");
    }else{
        reject(@"Nav2",@"loadModel failed!!!",nil);
    }
}

RCT_REMAP_METHOD(setStartPoint,setStartPointById:(NSString*)nav2Id xPoint:(double)xPoint yPoint:(double)yPoint andMapId:(NSString*)mapId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation2* nav = [JSObjManager getObjWithKey:nav2Id];
    Map* map = [JSObjManager getObjWithKey:mapId];
    PrjCoordSys* prj = map.prjCoordSys;
    Point2D* point = [[Point2D alloc]initWithX:xPoint Y:yPoint];
    Point2Ds* points = [[Point2Ds alloc]initWithPoint2DsArray:[NSMutableArray arrayWithArray:@[point]]];
    [CoordSysTranslator inverse:points PrjCoordSys:prj];
    /*
    Point2Ds* points = [[Point2Ds alloc]initWithPoint2DsArray:@[point]];
    BOOL isTranslate = [CoordSysTranslator inverse:points PrjCoordSys:prj];
     */
    if (nav) {
        Point2D* translatedPoint = nil;
        if ([points getCount]==0) {
            translatedPoint = point;
        }else{
            translatedPoint = [points getItem:0];
        }
        [nav setStartPoint:translatedPoint.x sPointY:translatedPoint.y];
        resolve(@"StartPoint setted");
    }else{
        reject(@"Nav2",@"set startPoint failed!!!",nil);
    }
}

RCT_REMAP_METHOD(setDestinationPoint,setDestinationPointById:(NSString*)nav2Id xPoint:(double)xPoint yPoint:(double)yPoint andMapId:(NSString*)mapId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation2* nav = [JSObjManager getObjWithKey:nav2Id];
    Map* map = [JSObjManager getObjWithKey:mapId];
    PrjCoordSys* prj = map.prjCoordSys;
    Point2D* point = [[Point2D alloc]initWithX:xPoint Y:yPoint];
    /*
    Point2Ds* points = [[Point2Ds alloc]initWithPoint2DsArray:@[point]];
    BOOL isTranslate = [CoordSysTranslator inverse:points PrjCoordSys:prj];
     */
    Point2Ds* points = [[Point2Ds alloc]initWithPoint2DsArray:[NSMutableArray arrayWithArray:@[point]]];
    [CoordSysTranslator inverse:points PrjCoordSys:prj];
    if (nav) {
        Point2D* translatedPoint = nil;
        if ([points getCount]==0) {
            translatedPoint = point;
        }else{
            translatedPoint = [points getItem:0];
        }
        [nav setDestinationPoint:translatedPoint.x dPointY:translatedPoint.y];
        resolve(@"DestinationPoint setted");
    }else{
        reject(@"Nav2",@"set DestinationPoint failed!!!",nil);
    }
}

RCT_REMAP_METHOD(routeAnalyst,routeAnalystById:(NSString*)nav2Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation2* nav = [JSObjManager getObjWithKey:nav2Id];
    if (nav) {
        BOOL analystBit = [nav routeAnalyst];
        NSNumber *num = [NSNumber numberWithBool:analystBit];
        resolve(@{@"finished":num});
    }else{
        reject(@"Nav2",@"routeAnalyst failed!!!",nil);
    }
}

RCT_REMAP_METHOD(startGuide,startGuideById:(NSString*)nav2Id andMode:(int)mode resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation2* nav = [JSObjManager getObjWithKey:nav2Id];
    if (nav) {
        BOOL isStart = [nav startGuide:mode];
        NSNumber* nsIsStart = [NSNumber numberWithBool:isStart];
        resolve(@{@"isGuiding":nsIsStart});
    }else{
        reject(@"Nav2",@"start Guide failed!!!",nil);
    }
}

RCT_REMAP_METHOD(setTurnDataset,setTurnDatasetById:(NSString*)nav2Id datasetId:(NSString*)datasetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation2* nav = [JSObjManager getObjWithKey:nav2Id];
    DatasetVector* dsVector = [JSObjManager getObjWithKey:datasetId];
  if (nav&&dsVector) {
    [nav setTurnDataset:dsVector];
    resolve(@"setted");
  }else{
    reject(@"Nav2",@"set TurnDataset failed!!!",nil);
  }
}

RCT_REMAP_METHOD(setAltimetricPointDataset,setAltimetricPointDatasetById:(NSString*)nav2Id datasetId:(NSString*)datasetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation2* nav = [JSObjManager getObjWithKey:nav2Id];
    DatasetVector* dsVector = [JSObjManager getObjWithKey:datasetId];
    if (nav&&dsVector) {
        [nav setDatasetPoint:dsVector];
        resolve(@"setted");
    }else{
        reject(@"Nav2",@"set AltimetricPointDataset failed!!!",nil);
    }
}

RCT_REMAP_METHOD(getRoute,getRouteById:(NSString*)nav2Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation2* nav = [JSObjManager getObjWithKey:nav2Id];
    if (nav) {
        GeoLine* line = [nav getRoute];
        NSInteger key = (NSInteger)line;
        [JSObjManager addObj:line];
        resolve(@{@"geoLineId":@(key).stringValue});
    }else{
        reject(@"Nav2",@"get Route failed!!!",nil);
    }
}

RCT_REMAP_METHOD(cleanPath,cleanPathById:(NSString*)nav2Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation2* nav = [JSObjManager getObjWithKey:nav2Id];
    if (nav) {
        [nav cleanPath];
        resolve(@"clean path");
    }else{
        reject(@"Nav2",@"cleanPath failed!!!",nil);
    }
}
/*
RCT_REMAP_METHOD(pauseGuide,pauseGuideById:(NSString*)nav2Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation2* nav = [JSObjManager getObjWithKey:nav2Id];
    if (nav) {
        [nav pauseGuide];
        resolve(@"clean path");
    }else{
        reject(@"Nav2",@"cleanPath failed!!!",nil);
    }
}
*/

/*
RCT_REMAP_METHOD(resumeGuide,resumeGuideById:(NSString*)nav2Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation2* nav = [JSObjManager getObjWithKey:nav2Id];
    if (nav) {
        [nav resumeGuide];
        resolve(@"clean path");
    }else{
        reject(@"Nav2",@"cleanPath failed!!!",nil);
    }
}
 */

RCT_REMAP_METHOD(stopGuide,stopGuideById:(NSString*)nav2Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation2* nav = [JSObjManager getObjWithKey:nav2Id];
    if (nav) {
        BOOL isStop = [nav stopGuide];
        NSNumber *num = [NSNumber numberWithBool:isStop];
        resolve(@{@"stoped":num});
    }else{
        reject(@"Nav2",@"stopGuide failed!!!",nil);
    }
}

RCT_REMAP_METHOD(isGuiding,isGuidingById:(NSString*)nav2Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation2* nav = [JSObjManager getObjWithKey:nav2Id];
    if (nav) {
        BOOL isGuiding = [nav isGuiding];
        NSNumber *num = [NSNumber numberWithBool:isGuiding];
        resolve(@{@"yes":num});
    }else{
        reject(@"Nav2",@"isGuiding failed!!!",nil);
    }
}

RCT_REMAP_METHOD(enablePanOnGuide,enablePanOnGuideById:(NSString*)nav2Id andPan:(BOOL)pan resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation2* nav = [JSObjManager getObjWithKey:nav2Id];
    if (nav) {
        [nav enablePanOnGuide:pan];
        resolve(@"setted");
    }else{
        reject(@"Nav2",@"set pan onGuide failed!!!",nil);
    }
}

/*
RCT_REMAP_METHOD(locateMap,locateMapById:(NSString*)nav2Id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation2* nav = [JSObjManager getObjWithKey:nav2Id];
    if (nav) {
        [nav locateMap];
        resolve(@"setted");
    }else{
        reject(@"Nav2",@"set pan onGuide failed!!!",nil);
    }
}
 */

RCT_REMAP_METHOD(setIsAutoNavi,setIsAutoNaviById:(NSString*)nav2Id withIsAudo:(BOOL)isAudo resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation2* nav = [JSObjManager getObjWithKey:nav2Id];
    if (nav) {
        [nav setIsAutoNavi:isAudo];
        resolve(@"set Audo");
    }else{
        reject(@"Nav2",@"set IsAutoNavi failed!!!",nil);
    }
}
/*GPSdata结构
RCT_REMAP_METHOD(setGPSData,setGPSDataById:(NSString*)nav2Id andData:(BOOL)Data resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation2* nav = [JSObjManager getObjWithKey:nav2Id];
    if (nav) {
        [nav enablePanOnGuide:pan];
        resolve(@"setted");
    }else{
        reject(@"Nav2",@"set pan onGuide failed!!!",nil);
    }
}
 */

@end

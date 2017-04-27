//
//  JSNavigation.m
//  Supermap
//
//  Created by 王子豪 on 2017/3/15.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSNavigation.h"
#import "JSObjManager.h"
#import "SuperMap/Map.h"
#import "SuperMap/CoordSysTranslator.h"
#import "SuperMap/Point2D.h"
#import "SuperMap/Point2Ds.h"
@implementation JSNavigation
RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"com.supermap.RN.JSNavigation2.start_navi", @"com.supermap.RN.JSNavigation2.navi_info_update", @"com.supermap.RN.JSNavigation2.arrived_destination",
        @"com.supermap.RN.JSNavigation2.stop_navi"];
}

-(void)onNaviInfoUpdate:(NaviInfo*)naviInfo{
    [self sendEventWithName:@"com.supermap.RN.JSNavigation2.navi_info_update"
                       body:@{@"body":@"this delegate no body"
                              }];
}
-(void)onStartNavi{
    [self sendEventWithName:@"com.supermap.RN.JSNavigation2.start_navi"
                       body:@{@"body":@"this delegate no body"
                              }];
}
-(void)onAarrivedDestination{
    [self sendEventWithName:@"com.supermap.RN.JSNavigation2.arrived_destination"
                       body:@{@"body":@"this delegate no body"
                              }];
}
-(void)onStopNavi{
    [self sendEventWithName:@"com.supermap.RN.JSNavigation2.stop_navi"
                       body:@{@"body":@"this delegate no body"
                              }];
}

RCT_REMAP_METHOD(connectNaviData,connectNaviDataById:(NSString*)naviId withDataPath:(NSString*)path resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation* navi = [JSObjManager getObjWithKey:naviId];
    if(navi){
        BOOL success = [navi connectNaviData:path];
        NSNumber* nsSuccess = [NSNumber numberWithBool:success];
        resolve(@{@"success":nsSuccess});
    }else{
        reject(@"Navigation",@"connect NaviData failed!!!",nil);
    }
}

RCT_REMAP_METHOD(routeAnalyst,routeAnalystById:(NSString*)naviId withMode:(int)mode resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation* navi = [JSObjManager getObjWithKey:naviId];
    if(navi){
        int success = [navi routeAnalyst:mode];
        NSNumber* nsSuccess = [NSNumber numberWithInt:success];
        resolve(@{@"result":nsSuccess});
    }else{
        reject(@"Navigation",@"routeAnalyst failed!!!",nil);
    }
}

RCT_REMAP_METHOD(setStartPoint,setStartPointById:(NSString*)naviId withPointX:(double)pointX withPointY:(double)pointY withMapId:(NSString*)mapId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation* navi = [JSObjManager getObjWithKey:naviId];
    Map* map = [JSObjManager getObjWithKey:mapId];
    PrjCoordSys* prj = map.prjCoordSys;
    Point2D* point = [[Point2D alloc]initWithX:pointX Y:pointY];
    Point2Ds* points = [[Point2Ds alloc]initWithPoint2DsArray:[NSMutableArray arrayWithArray:@[point]]];
    BOOL isTranslate = [CoordSysTranslator inverse:points PrjCoordSys:prj];
    if(navi&&isTranslate){
        Point2D* translatedPoint = [points getItem:0];
        [navi setStartPoint:translatedPoint.x sPointY:translatedPoint.y];
        resolve(@"startPoint setted");
    }else{
        reject(@"Navigation",@"set StartPoint failed!!!",nil);
    }
}

RCT_REMAP_METHOD(setDestinationPoint,setDestinationPointById:(NSString*)naviId withPointX:(double)pointX withPointY:(double)pointY withMapId:(NSString*)mapId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation* navi = [JSObjManager getObjWithKey:naviId];
    Map* map = [JSObjManager getObjWithKey:mapId];
    PrjCoordSys* prj = map.prjCoordSys;
    Point2D* point = [[Point2D alloc]initWithX:pointX Y:pointY];
    Point2Ds* points = [[Point2Ds alloc]initWithPoint2DsArray:[NSMutableArray arrayWithArray:@[point]]];
    BOOL isTranslate = [CoordSysTranslator inverse:points PrjCoordSys:prj];
    if(navi&&isTranslate){
        Point2D* translatedPoint = [points getItem:0];
        [navi setDestinationPoint:translatedPoint.x dPointY:translatedPoint.y];
        resolve(@"destinationPoint setted");
    }else{
        reject(@"Navigation",@"set destinationPoint failed!!!",nil);
    }
}

RCT_REMAP_METHOD(startGuide,startGuideById:(NSString*)naviId withStatus:(int)status resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation* navi = [JSObjManager getObjWithKey:naviId];
    if(navi){
        BOOL start = [navi startGuide:status];
        NSNumber* nsStart = [NSNumber numberWithBool:start];
        resolve(@{@"guiding":nsStart});
    }else{
        reject(@"Navigation",@"start Guide failed!!!",nil);
    }
}

RCT_REMAP_METHOD(addWayPoint,addWayPointById:(NSString*)naviId withPointX:(double)pointX withPointY:(double)pointY resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation* navi = [JSObjManager getObjWithKey:naviId];
    if(navi){
        BOOL isAdd = [navi addWayPoint:pointX Y:pointY];
        NSNumber* nsAdd = [NSNumber numberWithBool:isAdd];
        resolve(@{@"added":nsAdd});
    }else{
        reject(@"Navigation",@"add WayPoint failed!!!",nil);
    }
}

RCT_REMAP_METHOD(stopGuide,stopGuideById:(NSString*)naviId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation* navi = [JSObjManager getObjWithKey:naviId];
    if(navi){
        BOOL isStop = [navi stopGuide];
        NSNumber* stopped = [NSNumber numberWithBool:isStop];
        resolve(@{@"added":stopped});
    }else{
        reject(@"Navigation",@"stop Guide failed!!!",nil);
    }
}
/*播报引导信息接口暂未开放
RCT_REMAP_METHOD(setSpeechParam,setSpeechParamById:(NSString*)naviId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation* navi = [JSObjManager getObjWithKey:naviId];
    if(navi){
        BOOL isStop = [navi stopGuide];
        NSNumber* stopped = [NSNumber numberWithBool:isStop];
        resolve(@{@"added":stopped});
    }else{
        reject(@"Navigation",@"stop Guide failed!!!",nil);
    }
}
 */
/*gps data 格式
RCT_REMAP_METHOD(setGPSData,setGPSDataById:(NSString*)naviId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation* navi = [JSObjManager getObjWithKey:naviId];
    if(navi){
        BOOL isStop = [navi stopGuide];
        NSNumber* stopped = [NSNumber numberWithBool:isStop];
        resolve(@{@"added":stopped});
    }else{
        reject(@"Navigation",@"stop Guide failed!!!",nil);
    }
}
*/

RCT_REMAP_METHOD(locateMap,locateMapById:(NSString*)naviId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation* navi = [JSObjManager getObjWithKey:naviId];
    if(navi){
        [navi locateMap];
        resolve(@"locateMap setted");
    }else{
        reject(@"Navigation",@"locateMap failed!!!",nil);
    }
}

RCT_REMAP_METHOD(isGuiding,isGuidingById:(NSString*)naviId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation* navi = [JSObjManager getObjWithKey:naviId];
    if(navi){
        BOOL isGuiding = [navi isGuiding];
        NSNumber* nsGuide = [NSNumber numberWithBool:isGuiding];
        resolve(@{@"guiding":nsGuide});
    }else{
        reject(@"Navigation",@"isGuiding failed!!!",nil);
    }
}

/*剩余导航时间接口未开出
RCT_REMAP_METHOD(getTimeToDestination,getTimeToDestinationById:(NSString*)naviId withSpeed:(double)speed resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation* navi = [JSObjManager getObjWithKey:naviId];
    if(navi){
        BOOL isGuiding = [navi isGuiding];
        NSNumber* nsGuide = [NSNumber numberWithBool:isGuiding];
        resolve(@{@"guiding":nsGuide});
    }else{
        reject(@"Navigation",@"isGuiding failed!!!",nil);
    }
}
 */

RCT_REMAP_METHOD(getRoute,getRouteById:(NSString*)naviId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation* navi = [JSObjManager getObjWithKey:naviId];
    if(navi){
        GeoLine* path = [navi getRoute];
        NSInteger nsPath = (NSInteger)path;
        [JSObjManager addObj:path];
        resolve(@{@"geoLineId":@(nsPath).stringValue});
    }else{
        reject(@"Navigation",@"get Route failed!!!",nil);
    }
}

RCT_REMAP_METHOD(enablePanOnGuide,enablePanOnGuideById:(NSString*)naviId withPan:(BOOL)pan resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation* navi = [JSObjManager getObjWithKey:naviId];
    if(navi){
        [navi enablePanOnGuide:pan];
        resolve(@"pan setted");
    }else{
        reject(@"Navigation",@"enable Pan On Guide failed!!!",nil);
    }
}

RCT_REMAP_METHOD(cleanPath,cleanPathById:(NSString*)naviId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation* navi = [JSObjManager getObjWithKey:naviId];
    if(navi){
        [navi cleanPath];
        resolve(@"path cleanned");
    }else{
        reject(@"Navigation",@"clean Path failed!!!",nil);
    }
}
/*iOS无对应接口
RCT_REMAP_METHOD(getNaviPath,getNaviPathById:(NSString*)naviId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation* navi = [JSObjManager getObjWithKey:naviId];
    if(navi){
        [navi cleanPath];
        resolve(@"path cleanned");
    }else{
        reject(@"Navigation",@"clean Path failed!!!",nil);
    }
}
 */

RCT_REMAP_METHOD(addNaviInfoListener,addNaviInfoListenerById:(NSString*)naviId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Navigation* navi = [JSObjManager getObjWithKey:naviId];
    if(navi){
        navi.navDelegate = self;
        NSNumber* nsTrue = [NSNumber numberWithBool:TRUE];
        resolve(nsTrue);
    }else{
        reject(@"Navigation",@"addNaviInfoListener failed!!!",nil);
    }
}

@end

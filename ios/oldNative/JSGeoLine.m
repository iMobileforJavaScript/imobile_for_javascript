//
//  JSGeoLine.m
//  mapSearchDemoProject
//
//  Created by 王子豪 on 2016/12/19.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSGeoLine.h"
#import "SuperMap/GeoLine.h"
#import "JSObjManager.h"

@implementation JSGeoLine
RCT_EXPORT_MODULE();
  
  RCT_REMAP_METHOD(createObj,createObjByresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    GeoLine* line = [[GeoLine alloc]init];
    if(line){
      NSInteger key = (NSInteger)line;
      [JSObjManager addObj:line];
      resolve(@{@"geoLineId":@(key).stringValue});
    }else{
      reject(@"geoLine",@"create GeoLine failed!!!",nil);
    }
  }
  
//  RCT_REMAP_METHOD(createObjByPts,createObjByPtsAndresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    GeoLine* geo = [JSObjManager getObjWithKey:geometryId];
//    Point2D* p2D = [geo getInnerPoint];
//    if(p2D){
//      NSInteger key = (NSInteger)p2D;
//      [JSObjManager addObj:p2D];
//      resolve(@{@"point2DId":@(key).stringValue});
//    }else{
//      reject(@"geometry",@"getInnerPoint failed!!!",nil);
//    }
//  }
@end

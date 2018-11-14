//
//  JSGeoPoint.m
//  HelloWorldDemo
//
//  Created by 王子豪 on 2016/11/22.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSGeoPoint.h"
#import "SuperMap/GeoPoint.h"
#import "JSObjManager.h"

@implementation JSGeoPoint
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(createObjByXY,createObjByX:(double)xNum andY:(double)yNUm resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  GeoPoint* point = [[GeoPoint alloc]initWithX:xNum Y:yNUm];
  if(point){
    NSInteger key = (NSInteger)point;
    [JSObjManager addObj:point];
    resolve(@{@"geoPointId":@(key).stringValue});
  }else{
    reject(@"GeoPoint",@"createObjByXY failed!!!",nil);
  }
}

RCT_REMAP_METHOD(createObj,createObjWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  GeoPoint* point = [[GeoPoint alloc]init];
  if(point){
    NSInteger key = (NSInteger)point;
    [JSObjManager addObj:point];
    resolve(@{@"geoPointId":@(key).stringValue});
  }else{
    reject(@"GeoPoint",@"createObj failed!!!",nil);
  }
}

RCT_REMAP_METHOD(getX,getXByPointId:(NSString*)pointId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  GeoPoint* point = [JSObjManager getObjWithKey:pointId];
  double xNum = [point getX];
  if(xNum){
    NSInteger key = (NSInteger)xNum;
    resolve(@{@"coordsX":@(key).stringValue});
  }else{
    reject(@"GeoPoint",@"getX failed!!!",nil);
  }
}

RCT_REMAP_METHOD(getY,getYByPointId:(NSString*)pointId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  GeoPoint* point = [JSObjManager getObjWithKey:pointId];
  double YNum = [point getY];
  if(YNum){
    NSInteger key = (NSInteger)YNum;
    resolve(@{@"coordsY":@(key).stringValue});
  }else{
    reject(@"GeoPoint",@"getY failed!!!",nil);
  }
}
@end

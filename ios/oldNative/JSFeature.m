//
//  JSFeature.m
//  HelloWorldDemo
//
//  Created by 王子豪 on 2016/11/22.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSFeature.h"
#import "SuperMap/Feature.h"
#import "JSObjManager.h"

@implementation JSFeature
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj,fieldNames:(NSArray*)fieldNames fieldValues:(NSArray*)fieldValues geometryId:(NSString*)geometryId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Geometry* geo = [JSObjManager getObjWithKey:geometryId];
  NSMutableArray* names = [NSMutableArray arrayWithArray:fieldNames];
  NSMutableArray* values = [NSMutableArray arrayWithArray:fieldValues];
  Feature* feature = [[Feature alloc]initWithFeature:names fieldValue:values geometry:geo];
  if(feature){
    NSInteger key = (NSInteger)feature;
    [JSObjManager addObj:feature];
    resolve(@{@"_featureId_":@(key).stringValue});
  }else{
    reject(@"feature",@"create feature failed!!!",nil);
  }
}

RCT_REMAP_METHOD(getFieldNames,featureId:(NSString*)featureId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Feature* feature = [JSObjManager getObjWithKey:featureId];
  NSMutableArray* muArr = [feature getFieldNames];
  if(muArr){
    resolve(muArr);
  }else{
    reject(@"feature",@"getFieldNames failed!!!",nil);
  }
}

RCT_REMAP_METHOD(getFieldValues,getFieldValuesByFeatureId:(NSString*)featureId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Feature* feature = [JSObjManager getObjWithKey:featureId];
  NSMutableArray* muArr = [feature getFieldValues];
  if(muArr){
    resolve(muArr);
  }else{
    reject(@"feature",@"getFieldValues failed!!!",nil);
  }
}

RCT_REMAP_METHOD(getGeometry,getGeometryByFeatureId:(NSString*)featureId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Feature* feature = [JSObjManager getObjWithKey:featureId];
  Geometry* geo = [feature getGeometry];
  if(geo){
    NSInteger key = (NSInteger)geo;
    [JSObjManager addObj:geo];
    resolve(@{@"geometryId":@(key).stringValue});
  }else{
    reject(@"feature",@"getGeometry failed!!!",nil);
  }
}

RCT_REMAP_METHOD(toJson,toJsonByFeatureId:(NSString*)featureId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Feature* feature = [JSObjManager getObjWithKey:featureId];
  NSString* json = [feature toJson];
  if(json){
    resolve(json);
  }else{
    reject(@"feature",@"toJson failed!!!",nil);
  }
}
@end

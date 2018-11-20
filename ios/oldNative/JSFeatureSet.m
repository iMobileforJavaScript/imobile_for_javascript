//
//  JSFeatureSet.m
//  HelloWorldDemo
//
//  Created by 王子豪 on 2016/11/22.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSFeatureSet.h"
#import "SuperMap/FeatureSet.h"
#import "JSObjManager.h"

@implementation JSFeatureSet
RCT_EXPORT_MODULE();
//RCT_REMAP_METHOD(deleteAll,deleteAllByFeatureSetId:(NSString*)featureSetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//  FeatureSet* featureSet = [JSObjManager getObjWithKey:featureSetId];
//  NSMutableArray* muArr = [feature getFieldNames];
//  if(muArr){
//    resolve(muArr);
//  }else{
//    reject(@"feature",@"getFieldNames failed!!!",nil);
//  }
//}

RCT_REMAP_METHOD(getFeatureCount,getFeatureCountByFeatureSetId:(NSString*)featureSetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  FeatureSet* featureSet = [JSObjManager getObjWithKey:featureSetId];
  int count = [featureSet recordCount];
  if(count){
    NSNumber* num = [NSNumber numberWithInt:count];
    resolve(num);
  }else{
    reject(@"featureSet",@"getFeatureCount failed!!!",nil);
  }
}

RCT_REMAP_METHOD(getFieldValue,getFieldValueByFeatureSetId:(NSString*)featureSetId fieldName:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  FeatureSet* featureSet = [JSObjManager getObjWithKey:featureSetId];
  NSObject* value = [featureSet getFieldValueWithString:name];
  if(value){
    resolve(value);
  }else{
    reject(@"featureSet",@"getFieldValue failed!!!",nil);
  }
}

RCT_REMAP_METHOD(getGeometry,getGeometryByFeatureSetId:(NSString*)featureSetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  FeatureSet* featureSet = [JSObjManager getObjWithKey:featureSetId];
  Geometry* geo = [featureSet getGeometry];
  if(geo){
    NSInteger key = (NSInteger)geo;
    [JSObjManager addObj:geo];
    resolve(@{@"geometryId":@(key).stringValue});
  }else{
    reject(@"featureSet",@"getGeometry failed!!!",nil);
  }
}

//RCT_REMAP_METHOD(isReadOnly,isReadOnlyByFeatureSetId:(NSString*)featureSetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//  FeatureSet* featureSet = [JSObjManager getObjWithKey:featureSetId];
//  Geometry* geo = [featureSet getGeometry];
//  if(geo){
//    NSInteger key = (NSInteger)geo;
//    [JSObjManager addObj:geo];
//    resolve(@{@"geometryId":@(key).stringValue});
//  }else{
//    reject(@"featureSet",@"getGeometry failed!!!",nil);
//  }
//}

RCT_REMAP_METHOD(moveFirst,moveFirstByFeatureSetId:(NSString*)featureSetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  FeatureSet* featureSet = [JSObjManager getObjWithKey:featureSetId];
  BOOL done = [featureSet moveFirst];
  if(done){
    resolve(@"done");
  }else{
    reject(@"featureSet",@"moveFirst failed!!!",nil);
  }
}

RCT_REMAP_METHOD(moveLast,moveLastByFeatureSetId:(NSString*)featureSetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  FeatureSet* featureSet = [JSObjManager getObjWithKey:featureSetId];
  BOOL done = [featureSet moveLast];
  if(done){
    resolve(@"done");
  }else{
    reject(@"featureSet",@"moveLast failed!!!",nil);
  }
}

RCT_REMAP_METHOD(moveNext,moveNextByFeatureSetId:(NSString*)featureSetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  FeatureSet* featureSet = [JSObjManager getObjWithKey:featureSetId];
  BOOL done = [featureSet moveNext];
  if(done){
    resolve(@"done");
  }else{
    reject(@"featureSet",@"moveNext failed!!!",nil);
  }
}

RCT_REMAP_METHOD(movePrev,movePrevByFeatureSetId:(NSString*)featureSetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  FeatureSet* featureSet = [JSObjManager getObjWithKey:featureSetId];
  BOOL done = [featureSet movePrev];
  if(done){
    resolve(@"done");
  }else{
    reject(@"featureSet",@"movePrev failed!!!",nil);
  }
}
@end

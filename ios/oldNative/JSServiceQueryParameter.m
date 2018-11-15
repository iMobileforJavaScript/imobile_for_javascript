//
//  JSServiceQueryParameter.m
//  HelloWorldDemo
//
//  Created by 王子豪 on 2016/11/24.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSServiceQueryParameter.h"
#import "SuperMap/ServiceQueryParameter.h"
#import "SuperMap/Rectangle2D.h"
#import "JSObjManager.h"
@implementation JSServiceQueryParameter
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj,resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  ServiceQueryParameter* para = [[ServiceQueryParameter alloc]init];
  if(para){
    NSInteger key = (NSInteger)para;
    [JSObjManager addObj:para];
    resolve(@{@"_serviceQueryParameterId_":@(key).stringValue});
  }else{
    reject(@"serviceQueryParameter",@"create serviceQueryParameter failed!!!",nil);
  }
}

#pragma mark - 父类QueryParameter类方法

RCT_REMAP_METHOD(setQueryBounds,setQueryBoundsByKey:(NSString*)key rectangle2DId:(NSString*)rectangle2DId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  ServiceQueryParameter* para = [JSObjManager getObjWithKey:key];
  Rectangle2D* rectangle = [JSObjManager getObjWithKey:rectangle2DId];
  if(para&&rectangle){
    para.queryBounds = rectangle;
    resolve(@"set QueryBounds successful");
  }else{
    reject(@"serviceQueryParameter",@"create feature failed!!!",nil);
  }
}

RCT_REMAP_METHOD(getQueryBounds,getQueryBoundsByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ServiceQueryParameter* para = [JSObjManager getObjWithKey:key];
    Rectangle2D* rectangle = para.queryBounds;
    if(rectangle){
        NSInteger rectangleId = (NSInteger)rectangle;
        [JSObjManager addObj:rectangle];
        resolve(@{@"rectangle2DId":@(rectangleId).stringValue});
    }else{
        reject(@"serviceQueryParameter",@"get queryBounds failed!",nil);
    }
}

#pragma mark - 属性设置／获取方法

RCT_REMAP_METHOD(setQueryDistance,setQueryDistanceByKey:(NSString*)key andDistance:(double)distance resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ServiceQueryParameter* para = [JSObjManager getObjWithKey:key];
    if(para){
        para.mDistance = distance;
        resolve(@"set queryDistance successful");
    }else{
        reject(@"serviceQueryParameter",@"set queryDistance failed!",nil);
    }
}

RCT_REMAP_METHOD(getQueryDistance,getQueryDistanceByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ServiceQueryParameter* para = [JSObjManager getObjWithKey:key];
    if(para){
        double distance = para.mDistance;
        NSNumber* nsDistance = [NSNumber numberWithDouble:distance];
        resolve(nsDistance);
    }else{
        reject(@"serviceQueryParameter",@"get queryDistance failed!",nil);
    }
}

RCT_REMAP_METHOD(getQueryGeometry,getQueryGeometryByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ServiceQueryParameter* para = [JSObjManager getObjWithKey:key];
    Geometry* geo = para.m_pGeometry;
    if(geo){
        NSInteger geoKey = (NSInteger)geo;
        [JSObjManager addObj:geo];
        resolve(@{@"geometryId":@(geoKey).stringValue});
    }else{
        reject(@"serviceQueryParameter",@"get queryGeometry failed!",nil);
    }
}

RCT_REMAP_METHOD(setQueryGeometry,setQueryGeometryByKey:(NSString*)key andGeometryId:(NSString*)geoId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ServiceQueryParameter* para = [JSObjManager getObjWithKey:key];
    Geometry* geo = [JSObjManager getObjWithKey:geoId];
    if(geo){
        para.m_pGeometry = geo;
        resolve(@"set queryGeometry successful");
    }else{
        reject(@"serviceQueryParameter",@"set queryGeometry failed!",nil);
    }
}

RCT_REMAP_METHOD(getQueryLayerName,getQueryLayerNameByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ServiceQueryParameter* para = [JSObjManager getObjWithKey:key];
    NSString* layerName = para.mQueryLayerName;
    if(layerName){
        resolve(layerName);
    }else{
        reject(@"serviceQueryParameter",@"get QueryLayerName failed!",nil);
    }
}

RCT_REMAP_METHOD(setQueryLayerName,getQueryLayerNameByKey:(NSString*)key andNameStr:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ServiceQueryParameter* para = [JSObjManager getObjWithKey:key];
    if(para){
        para.mQueryLayerName = name;
        resolve(@"set QueryLayerName successful");
    }else{
        reject(@"serviceQueryParameter",@"set QueryLayerName failed!",nil);
    }
}

RCT_REMAP_METHOD(getQueryMapName,getQueryMapNameByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ServiceQueryParameter* para = [JSObjManager getObjWithKey:key];
    NSString* mapName = para.mMapName;
    if(mapName){
        resolve(mapName);
    }else{
        reject(@"serviceQueryParameter",@"get QueryMapName failed!",nil);
    }
}

RCT_REMAP_METHOD(setQueryMapName,setQueryMapNameByKey:(NSString*)key andNameStr:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ServiceQueryParameter* para = [JSObjManager getObjWithKey:key];
    if(para){
        para.mMapName = name;
        resolve(@"set QueryMapName successful");
    }else{
        reject(@"serviceQueryParameter",@"get QueryMapName failed!",nil);
    }
}

RCT_REMAP_METHOD(getQueryOption,getQueryOptionByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ServiceQueryParameter* para = [JSObjManager getObjWithKey:key];
    QueryOption opt = para.nqueryOption;
    if(para){
        resolve(@(opt).stringValue);
    }else{
        reject(@"serviceQueryParameter",@"get QueryMapName failed!",nil);
    }
}

RCT_REMAP_METHOD(setQueryOption,setQueryOptionByKey:(NSString*)key andType:(int)type resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ServiceQueryParameter* para = [JSObjManager getObjWithKey:key];
    if(para){
        para.nqueryOption = type;
        resolve(@"set QueryOption successful");
    }else{
        reject(@"serviceQueryParameter",@"set QueryOption failed!",nil);
    }
}

RCT_REMAP_METHOD(getExpectRecordCount,getExpectRecordCountByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ServiceQueryParameter* para = [JSObjManager getObjWithKey:key];
    if(para){
        int count = para.mRecordCount;
        NSNumber* nsCount = [NSNumber numberWithInt:count];
        resolve(nsCount);
    }else{
        reject(@"serviceQueryParameter",@"get ExpectRecordCount failed!",nil);
    }
}

RCT_REMAP_METHOD(setExpectRecordCount,setExpectRecordCountByKey:(NSString*)key andCount:(int)count resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ServiceQueryParameter* para = [JSObjManager getObjWithKey:key];
    if(para){
        para.mRecordCount = count;
        resolve(@"set ExpectRecordCount successful");
    }else{
        reject(@"serviceQueryParameter",@"set ExpectRecordCount failed!",nil);
    }
}

RCT_REMAP_METHOD(getQueryServiceName,getQueryServiceNameByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ServiceQueryParameter* para = [JSObjManager getObjWithKey:key];
    if(para){
        NSString* serviceName = para.mServiceName;
        resolve(serviceName);
    }else{
        reject(@"serviceQueryParameter",@"get QueryServiceName failed!",nil);
    }
}

RCT_REMAP_METHOD(setQueryServiceName,setQueryServiceNameByKey:(NSString*)key andName:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ServiceQueryParameter* para = [JSObjManager getObjWithKey:key];
    if(para){
        para.mServiceName = name;
        resolve(@"set QueryServiceName successful");
    }else{
        reject(@"serviceQueryParameter",@"set QueryServiceName failed!",nil);
    }
}

RCT_REMAP_METHOD(toJson,toJsonByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    ServiceQueryParameter* para = [JSObjManager getObjWithKey:key];
    if(para){
        NSString* jsonPara = [para toJson];
        resolve(jsonPara);
    }else{
        reject(@"serviceQueryParameter",@"to json failed!",nil);
    }
}


@end

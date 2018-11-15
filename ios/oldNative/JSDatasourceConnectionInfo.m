//
//  JSDatasourceConnectionInfo.m
//  rnTest
//
//  Created by imobile-xzy on 16/7/11.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSDatasourceConnectionInfo.h"
#import "SuperMap/DatasourceConnectionInfo.h"
#import "JSObjManager.h"

@implementation JSDatasourceConnectionInfo
//注册为Native模块
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(createObj,resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  DatasourceConnectionInfo* info = [[DatasourceConnectionInfo alloc]init];
  if(info){
    NSInteger key = (NSInteger)info;
    [JSObjManager addObj:info];
    //resolve(@(key).stringValue);
    resolve(@{@"datasourceConnectionInfoId":@(key).stringValue});
  }else{
    reject(@"DatasourceConnectionInfo",@"create DatasourceConnectionInfo failed!!!",nil);
  }
}

RCT_REMAP_METHOD(getServer,getServerKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  DatasourceConnectionInfo* info = [JSObjManager getObjWithKey:key];
  if(info){
    resolve(info.server);
  }else
    reject(@"DatasourceConnectionInfo",@"DatasourceConnectionInfo not exeist!!!",nil);
}

RCT_REMAP_METHOD(setServer,setServerKey:(NSString*)key server:(NSString*)server  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  DatasourceConnectionInfo* info = [JSObjManager getObjWithKey:key];
  if(info){
    info.server = server;
    resolve(@"1");
  }else
    reject(@"DatasourceConnectionInfo",@"setServer failed!!!",nil);
}

RCT_REMAP_METHOD(setServerByFilePath,setServerByFilePathKey:(NSString*)key server:(NSString*)server  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  DatasourceConnectionInfo* info = [JSObjManager getObjWithKey:key];
  if(info){
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [[paths objectAtIndex:0] stringByAppendingPathComponent:server];
    [info setServer:fileName];
    resolve(@"1");
  }else
  reject(@"DatasourceConnectionInfo",@"setServer failed!!!",nil);
}

RCT_REMAP_METHOD(getEngineType,getEngineTypeKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  DatasourceConnectionInfo* info = [JSObjManager getObjWithKey:key];
  if(info){
    resolve(@(info.engineType).stringValue);
  }else
    reject(@"DatasourceConnectionInfo",@"DatasourceConnectionInfo not exeist!!!",nil);
}

RCT_REMAP_METHOD(setEngineType,setEngineTypeKey:(NSString*)key engineType:(int)engineType  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  DatasourceConnectionInfo* info = [JSObjManager getObjWithKey:key];
  if(info){
    info.engineType = engineType;
    resolve(@"1");
  }else
    reject(@"DatasourceConnectionInfo",@"setEngineType failed!!!",nil);
}

RCT_REMAP_METHOD(getAlias,getAliasKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  DatasourceConnectionInfo* info = [JSObjManager getObjWithKey:key];
  if(info){
    resolve(info.alias);
  }else
    reject(@"DatasourceConnectionInfo",@"DatasourceConnectionInfo not exeist!!!",nil);
}

RCT_REMAP_METHOD(setAlias,getAliasKey:(NSString*)key alias:(NSString*)alias  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  DatasourceConnectionInfo* info = [JSObjManager getObjWithKey:key];
  if(info){
    info.alias = alias;
    resolve(@"1");
  }else
    reject(@"DatasourceConnectionInfo",@"setAlias failed!!!",nil);
}


@end

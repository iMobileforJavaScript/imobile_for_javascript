//
//  JSDatasources.m
//  rnTest
//
//  Created by imobile-xzy on 16/7/5.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSDatasources.h"
#import "SuperMap/Datasources.h"
#import "SuperMap/Datasource.h"
#import "JSObjManager.h"

@implementation JSDatasources
//注册为Native模块
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(open,userKey:(NSString*)key  infoKey:(NSString*)infoKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Datasources* datasources = [JSObjManager getObjWithKey:key];
  DatasourceConnectionInfo* info = [JSObjManager getObjWithKey:infoKey];
  if(datasources && info){
    Datasource*  datasource = [datasources open:info];
    if(datasource){
      [JSObjManager addObj:datasource];
      resolve(@{@"datasourceId":@( (NSInteger)datasource).stringValue});
    }else{
      NSLog(@"open datasource failed");
      resolve(@"0");
    }
 
  }else
    reject(@"datasources",@"open:datasources or DatasourceConnectionInfo not exeist!!!",nil);
}

RCT_REMAP_METHOD(get,userKey:(NSString*)key index:(NSInteger)index resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Datasources* datasources = [JSObjManager getObjWithKey:key];
  Datasource* gettingDS = [datasources get:index];
  if(gettingDS){
    NSInteger DSkey = (NSInteger)gettingDS;
    [JSObjManager addObj:gettingDS];
    resolve(@{@"datasourceId":@(DSkey).stringValue});
  }else{
    reject(@"datasources",@"get Datasource failed",nil);
  }
}

RCT_REMAP_METHOD(renameDatasource,renameDatasourceKey:(NSString*)key oldName:(NSString*)oldName newName:(NSString*)newName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Datasources* datasources = [JSObjManager getObjWithKey:key];
  
  if(datasources){
      [datasources RenameDatasource:oldName with:newName];
      resolve(@(1));
  }else{
    reject(@"datasources",@"renameDatasource Datasource by alias failed",nil);
  }
}
RCT_REMAP_METHOD(getByName,userKey:(NSString*)key alias:(NSString*)alias resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Datasources* datasources = [JSObjManager getObjWithKey:key];
    Datasource* gettingDS = [datasources getAlias:alias];
    if(gettingDS){
        NSInteger DSkey = (NSInteger)gettingDS;
        [JSObjManager addObj:gettingDS];
        resolve(@{@"datasourceId":@(DSkey).stringValue});
    }else{
        reject(@"datasources",@"get Datasource by alias failed",nil);
    }
}
RCT_REMAP_METHOD(getCount,getCountByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Datasources* datasources = [JSObjManager getObjWithKey:key];
        NSInteger count = datasources.count;
        NSNumber* countNum = [NSNumber numberWithInteger:count];
        resolve(@{@"count":countNum});
    } @catch (NSException *exception) {
        reject(@"datasources",@"get count failed",nil);
    }
}

RCT_REMAP_METHOD(getAlias,getAliasByKey:(NSString*)key index:(int)index resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Datasources* datasources = [JSObjManager getObjWithKey:key];
        Datasource* datasource = [datasources get:index];
        NSString* alias = datasource.alias;
        resolve(@{@"alias":alias});
    } @catch (NSException *exception) {
        reject(@"datasources",@"get alias failed",nil);
    }
}
@end

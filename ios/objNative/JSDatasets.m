//
//  JSDatasets.m
//  rnTest
//
//  Created by imobile-xzy on 16/7/5.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSDatasets.h"
#import "SuperMap/Datasets.h"
#import "JSObjManager.h"

@implementation JSDatasets
//注册为Native模块
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(get,getUserKey:(NSString*)key index:(NSInteger)index resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Datasets* datasets = [JSObjManager getObjWithKey:key];
  Dataset* dataset = [datasets get:index];
  if(dataset){
    NSInteger key = (NSInteger)dataset;
    [JSObjManager addObj:dataset];
    //resolve(@(key).stringValue);
    resolve(@{@"datasetId":@(key).stringValue});

  }else
    reject(@"dataset",@"get:dataset not exeist!!!",nil);
}

RCT_REMAP_METHOD(getByName, getByNameByKey:(NSString*)key index:(NSString *)index resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Datasets* datasets = [JSObjManager getObjWithKey:key];
    Dataset* dataset = [datasets getWithName:index];
    if(dataset){
        NSInteger key = (NSInteger)dataset;
        [JSObjManager addObj:dataset];
        //resolve(@(key).stringValue);
        resolve(@{@"datasetId":@(key).stringValue});
        
    }else
        reject(@"dataset",@"get:dataset not exeist!!!",nil);
}

RCT_REMAP_METHOD(getAvailableDatasetName,userKey:(NSString*)key getAvailableDatasetName:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Datasets* datasets = [JSObjManager getObjWithKey:key];
  NSString* gettingName = [datasets availableDatasetName:name];
  if (gettingName) {
    resolve(@{@"datasetName":gettingName});
  }else{
    reject(@"datasets",@"get available name failed",nil);
  }
}

RCT_REMAP_METHOD(create,userKey:(NSString*)key create:(NSString*)DSVectorInfoKey resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Datasets* datasets = [JSObjManager getObjWithKey:key];
  DatasetVectorInfo* DSVectorInfo = [JSObjManager getObjWithKey:DSVectorInfoKey];
   DatasetVector* DSVector = [datasets create:DSVectorInfo];
  if (DSVector) {
    NSInteger DSVectorkey = (NSInteger)DSVector;
    [JSObjManager addObj:DSVector];
    resolve(@{@"datasetVectorId":@(DSVectorkey).stringValue});
  }else{
    reject(@"datasets",@"create datasetVector failed",nil);
  }
}

RCT_REMAP_METHOD(getWithName,getWithNameByUserKey:(NSString*)key name:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Datasets* datasets = [JSObjManager getObjWithKey:key];
  DatasetVector* DSVector = (DatasetVector*)[datasets getWithName:name];
  if (DSVector) {
    NSInteger DSVectorkey = (NSInteger)DSVector;
    [JSObjManager addObj:DSVector];
    resolve(@{@"datasetVectorId":@(DSVectorkey).stringValue});
  }else{
    reject(@"datasets",@"get datasetVector by name failed",nil);
  }
}


RCT_REMAP_METHOD(getCount,getCountrKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Datasets* datasets = [JSObjManager getObjWithKey:key];
   
    if (datasets) {
        int n = datasets.count;
        resolve(@{@"count":@(n)});
    }else{
        reject(@"datasets",@"getCountrKey by name failed",nil);
    }
}

@end

//
//  JSDataset.m
//  rnTest
//
//  Created by imobile-xzy on 16/7/5.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "SuperMap/Dataset.h"
#import "SuperMap/DatasetVector.h"
#import "JSDataset.h"
#import "JSObjManager.h"

@implementation JSDataset
//注册为Native模块
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createJSObj,resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Dataset* dataset = [[Dataset alloc]init];
  if(dataset){
    NSInteger key = (NSInteger)dataset;
    [JSObjManager addObj:dataset];
    resolve(@{@"dataSetId":@(key).stringValue});
  }else{
    reject(@"Dataset",@"create Dataset failed!!!",nil);
  }
}

#pragma mark - 类方法

RCT_REMAP_METHOD(toDatasetVector, userKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  DatasetVector* dataset = [JSObjManager getObjWithKey:key];
  if(dataset){
    NSInteger dsVectorKey = (NSInteger)dataset;
    [JSObjManager removeObj:key];
    [JSObjManager addObj:dataset];
    resolve(@{@"datasetVectorId":@(dsVectorKey).stringValue});
  }else{
    reject(@"Dataset",@"create Dataset failed!!!",nil);
  }
}

RCT_REMAP_METHOD(getPrjCoordSys,key:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Dataset* dataset = [JSObjManager getObjWithKey:key];
  PrjCoordSys* proj = dataset.prjCoordSys;
  if (proj) {
    NSInteger projSys = (NSInteger)proj;
    [JSObjManager addObj:proj];
    resolve(@{@"prjCoordSysId":@(projSys).stringValue});
  }else{
    reject(@"dataset",@"get dataset projSys failed",nil);
  }
}

RCT_REMAP_METHOD(openDataset,openDatasetByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Dataset* dataset = [JSObjManager getObjWithKey:key];
    BOOL openBit = [dataset open];
    if (openBit) {
        NSNumber* NSOpen = [NSNumber numberWithBool:openBit];
        resolve(@{@"opened":NSOpen});
    }else{
        reject(@"dataset",@"open dataset failed",nil);
    }
}


RCT_REMAP_METHOD(setName,setNameKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Dataset* dataset = [JSObjManager getObjWithKey:key];
    if(dataset){
        dataset.name = key;
        resolve(@(YES));
    }else{
        reject(@"dataset",@"dataset setName  failed",nil);
    }
}

RCT_REMAP_METHOD(setReadOnly,setReadOnlyKey:(NSString*)key b:(BOOL)bValue resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Dataset* dataset = [JSObjManager getObjWithKey:key];
    if(dataset){
        [dataset setReadOnly:bValue];
        resolve(@(YES));
    }else{
        reject(@"dataset",@"setReadOnly setName  failed",nil);
    }
}

RCT_REMAP_METHOD(isopen,isOpenJudgingByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Dataset* dataset = [JSObjManager getObjWithKey:key];
    BOOL openBit = [dataset isOpen];
    if (openBit) {
        NSNumber* NSOpen = [NSNumber numberWithBool:openBit];
        resolve(@{@"opened":NSOpen});
    }else{
        reject(@"dataset",@"isOpen judge failed",nil);
    }
}

#pragma mark - 属性获取方法

RCT_REMAP_METHOD(isReadOnly,isReadOnlyKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        Dataset* dataset = [JSObjManager getObjWithKey:key];
        
        if (dataset) {
            BOOL type = dataset.isReadOnly;
           // NSNumber * nsTypeNum = [NSNumber numberWithInt:(int)type];
            resolve(@(type));
        }
    } @catch (NSException *exception) {
        reject(@"dataset",@"isReadOnly get type failed",nil);
    }
}

RCT_REMAP_METHOD(getType,getTypeByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        Dataset* dataset = [JSObjManager getObjWithKey:key];
       
        if (dataset) {
            DatasetType type = dataset.datasetType;
            NSNumber * nsTypeNum = [NSNumber numberWithInt:(int)type];
            resolve(@{@"type":nsTypeNum});
        }
    } @catch (NSException *exception) {
        reject(@"dataset",@"dataset get type failed",nil);
    }
}
RCT_REMAP_METHOD(getDatasource,getDatasourceByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Dataset* dataset = [JSObjManager getObjWithKey:key];
    Datasource* dataSource = dataset.datasource;
    if (dataSource) {
        NSInteger dsKey = (NSInteger)dataSource;
        [JSObjManager addObj:dataSource];
        resolve(@{@"datasourceId":@(dsKey).stringValue});
    }else{
        reject(@"dataset",@"get datasource failed",nil);
    }
}

RCT_REMAP_METHOD(getEncodeType,getEncodeTypeByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Dataset* dataset = [JSObjManager getObjWithKey:key];
    EncodeType codeType = dataset.encodeType;
    if (codeType) {
        NSNumber * nsTypeNum = [NSNumber numberWithInt:(int)codeType];
        resolve(@{@"type":nsTypeNum});
    }else{
        reject(@"dataset",@"get encodeType failed",nil);
    }
}

RCT_REMAP_METHOD(DSgetName,getNameByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Dataset* dataset = [JSObjManager getObjWithKey:key];
    NSString* name = dataset.name;
    if (name) {
        resolve(@{@"name":name});
    }else{
        reject(@"dataset",@"get name failed",nil);
    }
}
@end

//
//  JSDatasource.m
//  rnTest
//
//  Created by imobile-xzy on 16/7/5.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSDatasource.h"
#import "SuperMap/Datasource.h"
#import "SuperMap/Datasets.h"
#import "SuperMap/DatasetVectorInfo.h"
#import "JSObjManager.h"

@implementation JSDatasource
//注册为Native模块
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(copyDataset,copyDatasetByKey:(NSString*)key withSrcDSId:(NSString*)DSId withDesDSName:(NSString*)name withEncodeType:(int)type resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Datasource* datasource = [JSObjManager getObjWithKey:key];
    Dataset* srcDataset = [JSObjManager getObjWithKey:DSId];
    Dataset* dataset = [datasource copyDataset:srcDataset desDatasetName:name encodeType:type];
    if(dataset){
        NSInteger datasetKey = (NSInteger)dataset;
        [JSObjManager addObj:dataset];
        resolve(@{@"datasetId":@(datasetKey).stringValue});
    }else{
        reject(@"dataSource",@"copy Dataset failed",nil);
    }
}
/*
RCT_REMAP_METHOD(changepassword,changepasswordByKey:(NSString*)key withOldPassword:(NSString*)old withNewPassword:(NSString*)new withType:(int)type resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Datasource* datasource = [JSObjManager getObjWithKey:key];
    BOOL changed = [datasource changePassword:old nwePasswd:new type:type];
    if(changed){
        NSNumber* nsChanged = [NSNumber numberWithBool:changed];
        resolve(@{@"changed":nsChanged});
    }else{
        reject(@"dataSource",@"copy Dataset failed",nil);
    }
}*/

#pragma mark - 属性获取方法

RCT_REMAP_METHOD(getDatasets,getUserKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Datasource* datasource = [JSObjManager getObjWithKey:key];
  Datasets* datasets = datasource.datasets;
  if(datasets){
    NSInteger key = (NSInteger)datasets;
    [JSObjManager addObj:datasets];
    resolve(@{@"datasetsId":@(key).stringValue});
  }else{
    reject(@"dataSource",@"get datasets failed",nil);
  }
}

RCT_REMAP_METHOD(getPrjCoordSys,getPrjCoordSysByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Datasource* datasource = [JSObjManager getObjWithKey:key];
    PrjCoordSys* prj = datasource.prjCoordSys;
    if(prj){
        NSInteger prjKey = (NSInteger)prj;
        [JSObjManager addObj:prj];
        resolve(@{@"prjCoordSysId":@(prjKey).stringValue});
    }else{
        reject(@"dataSource",@"get PrjCoordSys failed",nil);
    }
}

#pragma mark - 原Datasets类方法

RCT_REMAP_METHOD(getDataset,getDatasetByKey:(NSString*)key andNum:(int)num resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Datasource* datasource = [JSObjManager getObjWithKey:key];
    Datasets* datasets = datasource.datasets;
    Dataset* dataset = [datasets get:num];
    if(dataset){
        NSInteger key = (NSInteger)dataset;
        [JSObjManager addObj:dataset];
        resolve(@{@"datasetId":@(key).stringValue});
    }else{
        reject(@"dataSource",@"get dataset failed",nil);
    }
}

RCT_REMAP_METHOD(getDatasetByName,getDatasetByKey:(NSString*)key andName:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Datasource* datasource = [JSObjManager getObjWithKey:key];
    Datasets* datasets = datasource.datasets;
    Dataset* dataset = [datasets getWithName:name];
    if(dataset){
        NSInteger key = (NSInteger)dataset;
        [JSObjManager addObj:dataset];
        resolve(@{@"datasetId":@(key).stringValue});
    }else{
        reject(@"dataSource",@"get dataset failed",nil);
    }
}

RCT_REMAP_METHOD(getAvailableDatasetName,getAvailableNameByKey:(NSString*)key andName:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Datasource* datasource = [JSObjManager getObjWithKey:key];
    Datasets* datasets = datasource.datasets;
    NSString* outPutName = [datasets availableDatasetName:name];
    if(outPutName){
        resolve(@{@"datasetName":outPutName});
    }else{
        reject(@"dataSource",@"get dataset failed",nil);
    }
}

RCT_REMAP_METHOD(containDataset,containDatasetByKey:(NSString*)key andName:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Datasource* datasource = [JSObjManager getObjWithKey:key];
    Datasets* datasets = datasource.datasets;
    if(datasets){
        BOOL contain = [datasets contain:name];
        NSNumber* nsContain = [NSNumber numberWithBool:contain];
        resolve(@{@"contain":nsContain});
    }else{
        reject(@"dataSource",@"contain Dataset failed",nil);
    }
}

RCT_REMAP_METHOD(deleteDataset,deleteDatasetByKey:(NSString*)key andName:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Datasource* datasource = [JSObjManager getObjWithKey:key];
    Datasets* datasets = datasource.datasets;
    if(datasets){
        BOOL deleted = [datasets deleteName:name];
        NSNumber* nsDeleted = [NSNumber numberWithBool:deleted];
        resolve(@{@"deleted":nsDeleted});
    }else{
        reject(@"dataSource",@"delete Dataset failed",nil);
    }
}

RCT_REMAP_METHOD(getDatasetCount,getDatasetCountByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Datasource* datasource = [JSObjManager getObjWithKey:key];
    Datasets* datasets = datasource.datasets;
    if(datasets){
        NSInteger count = [datasets count];
        NSNumber* nsCount = [NSNumber numberWithInteger:count];
        resolve(@{@"count":nsCount});
    }else{
        reject(@"dataSource",@"get DatasetCount failed",nil);
    }
}

#pragma mark - 原datasetVectorInfo类方法

RCT_REMAP_METHOD(createDatasetVector,createDatasetVectorByKey:(NSString*)key andDSVectorInfoId:(NSString*)DSVectorInfoId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Datasource* datasource = [JSObjManager getObjWithKey:key];
    DatasetVectorInfo* info = [JSObjManager getObjWithKey:DSVectorInfoId];
    Datasets* datasets = datasource.datasets;
    if(datasets&&info){
        DatasetVector* dsVector = [datasets create:info];
        NSInteger dsVectorKey = (NSInteger)dsVector;
        [JSObjManager addObj:dsVector];
        resolve(@{@"datasetVectorId":@(dsVectorKey).stringValue});
    }else{
        reject(@"dataSource",@"create DatasetVector failed",nil);
    }
}

RCT_REMAP_METHOD(createDatasetVectorDirectly,createDatasetVectorDirectlyByKey:(NSString*)key withName:(NSString*)name withDatasetType:(int)dsType withEncodeType:(int)eType resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Datasource* datasource = [JSObjManager getObjWithKey:key];
    Datasets* datasets = datasource.datasets;
    DatasetVectorInfo* info = [[DatasetVectorInfo alloc]initWithName:name datasetType:dsType];
    info.encodeType = eType;
    if(datasets&&info){
        DatasetVector* dsVector = [datasets create:info];
        NSInteger dsVectorKey = (NSInteger)dsVector;
        [JSObjManager addObj:dsVector];
        resolve(@{@"datasetVectorId":@(dsVectorKey).stringValue});
    }else{
        reject(@"dataSource",@"create DatasetVector failed",nil);
    }
}

@end

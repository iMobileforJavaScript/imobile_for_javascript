//
//  JSDataDownloadService.m
//  HelloWorldDemo
//
//  Created by 王子豪 on 2016/11/21.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSDataDownloadService.h"
#import "SuperMap/DataDownloadService.h"

#import "JSObjManager.h"
@implementation JSDataDownloadService
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(createObj,url:(NSString*)url resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  DataDownloadService* DDS = [[DataDownloadService alloc]init];
  if(DDS){
    NSInteger key = (NSInteger)DDS;
    [JSObjManager addObj:DDS];
    resolve(@{@"_dataDownloadServiceId_":@(key).stringValue});
  }else{
    reject(@"dataDownloadService",@"create dataDownloadService failed!!!",nil);
  }
}

RCT_REMAP_METHOD(download,DDSId:(NSString*)DDSId fullURL:(NSString*)fullURL fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    DataDownloadService* DDS = [JSObjManager getObjWithKey:DDSId];
    FeatureSet* set = [DDS downLoadUrl:fullURL fromIndex:(int)fromIndex toIndex:(int)toIndex];
  if(set){
    resolve(@"done");
  }else{
    reject(@"dataDownloadService",@"download failed!!!",nil);
  }
}


RCT_REMAP_METHOD(downloadByName,DDSId:(NSString*)DDSId URL:(NSString*)url serviceName:(NSString*)serviceName datasourceName:(NSString*)datasourceName datasetName:(NSString*)datasetName fromIndex:(int)fromIndex toIndex:(int)toIndex resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        DataDownloadService* DDS = [JSObjManager getObjWithKey:DDSId];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [DDS download:url serviceName:serviceName datasourceName:datasourceName datasetName:datasetName fromIndex:fromIndex toIndex:toIndex];
        });
    } @catch (NSException *exception) {
        reject(@"dataDownloadService",@"download failed!!!",nil);
    }
}

RCT_REMAP_METHOD(downloadAll,DDSId:(NSString*)DDSId URL:(NSString*)URL resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    DataDownloadService* DDS = [JSObjManager getObjWithKey:DDSId];
    FeatureSet* set = [DDS downLoadUrlAll:URL];
    if(set){
      resolve(@"done");
    }else{
      reject(@"dataDownloadService",@"download failed!!!",nil);
    }
}

RCT_REMAP_METHOD(downloadAllByName,DDSId:(NSString*)DDSId URL:(NSString*)url serviceName:(NSString*)serviceName datasourceName:(NSString*)datasourceName datasetName:(NSString*)datasetName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        DataDownloadService* DDS = [JSObjManager getObjWithKey:DDSId];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [DDS downloadAll:url serviceName:serviceName dsName:datasourceName datasetName:datasetName];
        });
    } @catch (NSException *exception) {
        reject(@"dataDownloadService",@"download failed!!!",nil);
    }
}

RCT_REMAP_METHOD(downloadDataset,DDSId:(NSString*)DDSId urlDatset:(NSString*)urlDatset datasourceId:(NSString*)datasourceId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    DataDownloadService* DDS = [JSObjManager getObjWithKey:DDSId];
    Datasource* datasource = [JSObjManager getObjWithKey:datasourceId];
    [DDS downloadDatasetFrom:urlDatset toDatasource:datasource];
}

RCT_REMAP_METHOD(updateDataset,DDSId:(NSString*)DDSId urlDatset:(NSString*)urlDatset datasetId:(NSString*)datasetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    DataDownloadService* DDS = [JSObjManager getObjWithKey:DDSId];
    DatasetVector* dataset = [JSObjManager getObjWithKey:datasetId];
    [DDS updateDatasetFrom:urlDatset toDatasetVector:dataset];
}
@end

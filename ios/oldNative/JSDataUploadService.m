//
//  JSDataUploadService.m
//  HelloWorldDemo
//
//  Created by 王子豪 on 2016/11/22.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSDataUploadService.h"
#import "SuperMap/DataUploadService.h"
#import "JSObjManager.h"

@implementation JSDataUploadService
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj,url:(NSString*)url resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  DataUploadService* DUS = [[DataUploadService alloc]init];
  if(DUS){
    NSInteger key = (NSInteger)DUS;
    [JSObjManager addObj:DUS];
    resolve(@{@"_dataUploadServiceId_":@(key).stringValue});
  }else{
    reject(@"dataUploadService",@"create dataUploadService failed!!!",nil);
  }
}

RCT_REMAP_METHOD(addDataset,DUSId:(NSString*)DUSId fullURL:(NSString*)fullURL datasetName:(NSString*)datasetName datasetType:(DatasetType)datasetType resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  DataUploadService* DUS = [JSObjManager getObjWithKey:DUSId];
  [DUS addDataset:fullURL datasetName:datasetName datasetType:datasetType];
}

//RCT_REMAP_METHOD(cloneDataset,DUSId:(NSString*)DUSId serviceName:(NSString*)serviceName datasourceName:(NSString*)datasourceName destDatasetName:(NSString*)destDatasetName srcDatasourceName:(NSString*)srcDatasourceName srcDatasetName:(NSString*)srcDatasetName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//  DataUploadService* DUS = [JSObjManager getObjWithKey:DUSId];
//  [DUS addDataset:<#(NSString *)#> serviceName:<#(NSString *)#> datasourceName:<#(NSString *)#> destDatasetName:<#(NSString *)#> srcDatasourceName:<#(NSString *)#> srcDatasetName:<#(NSString *)#>]
//}
@end

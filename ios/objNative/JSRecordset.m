//
//  JSRecordset.m
//
//  Created by 王子豪 on 2017/9/21.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSRecordset.h"
#import "SuperMap/Recordset.h"
#import "JSObjManager.h"
@implementation JSRecordset
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(getRecordCount,getRecordCountById:(NSString*)recordsetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Recordset* recordSet = [JSObjManager getObjWithKey:recordsetId];
  NSInteger count = recordSet.recordCount;
  if (count) {
    NSNumber* num = [NSNumber numberWithInteger:count];
    resolve(@{@"recordCount":num});
  }else{
    reject(@"recordset",@"get recordcount failed!!!",nil);
  }
}

RCT_REMAP_METHOD(dispose,disposeById:(NSString*)recordsetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Recordset* recordSet = [JSObjManager getObjWithKey:recordsetId];
  [recordSet dispose];
}

RCT_REMAP_METHOD(getGeometry,getGeometryById:(NSString*)recordsetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Recordset* recordSet = [JSObjManager getObjWithKey:recordsetId];
  Geometry* geo = recordSet.geometry;
  if (geo) {
    NSInteger key = (NSInteger)geo;
    [JSObjManager addObj:geo];
    resolve(@{@"geometryId":@(key).stringValue});
  }else{
    reject(@"recordset",@"get geometry failed!!!",nil);
  }
}

RCT_REMAP_METHOD(isEOF,isEOFById:(NSString*)recordsetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Recordset* recordSet = [JSObjManager getObjWithKey:recordsetId];
  if (recordSet) {
    BOOL isEOF = recordSet.isEOF;
    NSNumber* num = [NSNumber numberWithBool:isEOF];
    resolve(num);
  }else{
    reject(@"recordset",@"get isEOF failed!!!",nil);
  }
}

RCT_REMAP_METHOD(getDataset,getDatasetById:(NSString*)recordsetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Recordset* recordSet = [JSObjManager getObjWithKey:recordsetId];
  DatasetVector* DSVector = recordSet.datasetVector;
  if (DSVector) {
    NSInteger key = (NSInteger)DSVector;
    [JSObjManager addObj:DSVector];
    resolve(@{@"datasetId":@(key).stringValue});
  }else{
    reject(@"recordset",@"get dataset failed!!!",nil);
  }
}

RCT_REMAP_METHOD(addNew,addNewById:(NSString*)recordsetId geoId:(NSString*)geoId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Recordset* recordSet = [JSObjManager getObjWithKey:recordsetId];
  Geometry* geo = [JSObjManager getObjWithKey:geoId];
  [recordSet addNew:geo];
}

RCT_REMAP_METHOD(moveNext,moveNextById:(NSString*)recordsetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Recordset* recordSet = [JSObjManager getObjWithKey:recordsetId];
  [recordSet moveNext];
}

RCT_REMAP_METHOD(update,updateById:(NSString*)recordsetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Recordset* recordSet = [JSObjManager getObjWithKey:recordsetId];
  [recordSet update];
}
@end

//
//  JSSelection.m
//  HelloWorldDemo
//
//  Created by 王子豪 on 2016/11/24.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSSelection.h"
#import "SuperMap/Selection.h"
#import "JSObjManager.h"
@implementation JSSelection
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(fromRecordset,fromRecordsetById:(NSString*)selectionId recordSetId:(NSString*)recordSetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Selection* selection = [JSObjManager getObjWithKey:selectionId];
  Recordset* record = [JSObjManager getObjWithKey:recordSetId];
  BOOL isDone = [selection fromRecordset:record];
  if (isDone) {
    NSNumber* num = [NSNumber numberWithBool:isDone];
    resolve(@{@"fromRecordset":num});
  }else{
    reject(@"selection",@"fromRecordSet failed!!!",nil);
  }
}

RCT_REMAP_METHOD(setStyle,setStyleById:(NSString*)selectionId geoStyleId:(NSString*)geoStyleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Selection* selection = [JSObjManager getObjWithKey:selectionId];
  GeoStyle* style = [JSObjManager getObjWithKey:geoStyleId];
  if (selection) {
      selection.style = style;
    resolve(@"1");
  }else{
    reject(@"selection",@"clear failed!!!",nil);
  }
}

RCT_REMAP_METHOD(clear,clearById:(NSString*)selectionId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Selection* selection = [JSObjManager getObjWithKey:selectionId];
  if (selection) {
      [selection clear];
      resolve(@"1");
  }else{
      reject(@"selection",@"clear failed!!!",nil);
  }
}

RCT_REMAP_METHOD(toRecordset,toRecordsetById:(NSString*)selectionId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Selection* selection = [JSObjManager getObjWithKey:selectionId];
  Recordset* record = [selection toRecordset];
  if (record) {
    NSInteger key = (NSInteger)record;
    [JSObjManager addObj:record];
    resolve(@{@"recordsetId":@(key).stringValue});
  }else{
    reject(@"selection",@"toRecordSet failed!!!",nil);
  }
}
@end

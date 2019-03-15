//
//  JSRecordset.m
//
//  Created by 王子豪 on 2017/9/21.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSRecordset.h"
#import "JSObjManager.h"
#import "SuperMap/Recordset.h"
#import "SuperMap/FieldInfos.h"
#import "SuperMap/FieldInfo.h"
#import "NativeUtil.h"
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
    [JSObjManager removeObj:recordsetId];
    resolve(@(1));
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
    resolve(@(1));
}

RCT_REMAP_METHOD(moveNext,moveNextById:(NSString*)recordsetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Recordset* recordSet = [JSObjManager getObjWithKey:recordsetId];
  [recordSet moveNext];
    resolve(@(1));
}
RCT_REMAP_METHOD(moveFirst,moveFirstId:(NSString*)recordsetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Recordset* recordSet = [JSObjManager getObjWithKey:recordsetId];
    [recordSet moveFirst];
    resolve(@(1));
}
RCT_REMAP_METHOD(moveLast,moveLastId:(NSString*)recordsetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Recordset* recordSet = [JSObjManager getObjWithKey:recordsetId];
    [recordSet moveLast];
    resolve(@(1));
}
RCT_REMAP_METHOD(movePrev,movePrevId:(NSString*)recordsetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Recordset* recordSet = [JSObjManager getObjWithKey:recordsetId];
    [recordSet movePrev];
    resolve(@(1));
}

RCT_REMAP_METHOD(moveTo,moveToId:(NSString*)recordsetId index:(int)n resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Recordset* recordSet = [JSObjManager getObjWithKey:recordsetId];
    [recordSet moveTo:n];
    resolve(@(1));
}


RCT_REMAP_METHOD(update,updateById:(NSString*)recordsetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Recordset* recordSet = [JSObjManager getObjWithKey:recordsetId];
  [recordSet update];
    resolve(@(1));
}
// add lucd
RCT_REMAP_METHOD(getFieldCount,getFieldCountById:(NSString*)recordsetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try { Recordset* recordSet = [JSObjManager getObjWithKey:recordsetId];
        int count = (int)[recordSet fieldCount];
        if (count) {
            NSNumber* num = [NSNumber numberWithInteger:count];
            resolve(@{@"count":num});
        }else{
            reject(@"getFieldCount",@"get fieldCount failed!!!",nil);
        }
    }
    @catch(NSException *exception){
         reject(@"JSRecordset",@"getFieldCount expection",nil);
    }
}
RCT_REMAP_METHOD(getFieldInfosArray,getFieldInfosArrayById:(NSString*)recordsetId count:(NSInteger)count size:(NSInteger)size resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
//        Recordset* recordset = [JSObjManager getObjWithKey:recordsetId];
//        [recordset moveFirst];
//        NSMutableArray* recordsetArray = [NativeUtil recordsetToDictionary:recordset page:count size:size];
//        resolve(recordsetArray);
    }
    @catch(NSException *exception){
        reject(@"JSRecordset",@"JSRecordset getFieldInfosArray expection",nil);
    }
}
RCT_REMAP_METHOD(getFieldInfo,getFieldInfoById:(NSString*)recordsetId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
//        Recordset* recordset = [JSObjManager getObjWithKey:recordsetId];
//        [recordset moveFirst];
//        NSMutableArray* recordsetArray = [NativeUtil recordsetToDictionary:recordset page:0 size:1];
//        resolve(recordsetArray);
    }
    @catch(NSException *exception){

        reject(@"JSRecordset", [NSString stringWithFormat:@"name: %@ | reason:%@", exception.name, exception.reason], nil);

    }
}

RCT_REMAP_METHOD(setFieldValueByIndex,setFieldValueByIndexById:(NSString*)recordsetId info:(NSMutableDictionary *)dic resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{  Recordset* recordSet = [JSObjManager getObjWithKey:recordsetId];
        BOOL result = NO;
        BOOL editResult ;
        BOOL updateResult ;
        [recordSet moveFirst];
        editResult = [recordSet edit];
        
        int count = (int)[dic count];
        NSArray* keys = dic.allKeys;
        NSArray* values = dic.allValues;
        for(int i = 0;i < count;i++){
            NSString* sKey = keys[i];
            int index = [sKey intValue];
            if(values[i] == nil){
                result = [recordSet setFieldValueNULL:index];
            }else{
                result = [recordSet setFieldValue:index Obj:values[i]];
            }
        }
        updateResult = [recordSet update];
        resolve(@{@"result":@(result),
                  @"editResult":@(editResult),
                  @"updateResult":@(updateResult)
                  });
    }
    @catch(NSException *exception){

        reject(@"JSRecordset",@"JSRecordset setFieldValueByIndex expection",nil);
    }
}
RCT_REMAP_METHOD(setFieldValueByName,setFieldValueByNameById:(NSString*)recordsetId position:(int)position info:(NSDictionary *)dic resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
        Recordset* recordSet = [JSObjManager getObjWithKey:recordsetId];
        BOOL result = NO;
        BOOL editResult ;
        BOOL updateResult ;
        
        if (position >= 0) {
            [recordSet move:position];
        }
        
        editResult = [recordSet edit];
        
        int count = (int)[dic count];
        NSArray* keys = dic.allKeys;
        NSArray* values = dic.allValues;
        for(int i = 0;i < count;i++){
            NSString* name = (NSString*)keys[i];
            if(values[i] == nil){
                result = [recordSet setFieldValueNULLWithString:name];
            }else{
                result = [recordSet setFieldValueWithString:name Obj:values[i]];
            }
        }
        updateResult = [recordSet update];
        resolve(@{@"result":@(result),
                  @"editResult":@(editResult),
                  @"updateResult":@(updateResult)
                  });
    }
    @catch(NSException *exception){
        reject(@"JSRecordset",@"JSRecordset setFieldValueByName expection",nil);
    }
}
RCT_REMAP_METHOD(addFieldInfo,addFieldInfoById:(NSString*)recordsetId info:(NSMutableDictionary *)dic resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
        Recordset* recordSet = [JSObjManager getObjWithKey:recordsetId];
        
        BOOL editResult ;
        BOOL updateResult ;
        [recordSet moveFirst];
        editResult = [recordSet edit];
        
        FieldInfos* fieldInfos = recordSet.fieldInfos;
        FieldInfo* fieldInfo = [[FieldInfo alloc] init];
        
        int count = (int)[dic count];
        NSArray* keys = dic.allKeys;
        NSArray* values = dic.allValues;
        for(int i = 0;i < count;i++){
            NSString* key = (NSString *)keys[i];
            if([key containsString:@"caption"]){
                fieldInfo.caption = (NSString*)values[i];
            }
            else if([key containsString:@"name"]){
                fieldInfo.name = (NSString*)values[i];
            }
            else if([key containsString:@"type"]){
                fieldInfo.fieldType =(FieldType)[((NSString*)values[i]) intValue];
            }
            else if([key containsString:@"maxLength"]){
                fieldInfo.maxLength = [((NSString*)values[i]) intValue];
            }
            else if([key containsString:@"defaultValue"]){
                fieldInfo.defaultValue = (NSString*)values[i];
            }
            else if([key containsString:@"isRequired"]){
                fieldInfo.required = [((NSString*)values[i]) boolValue];
            }
            else if([key containsString:@"isZeroLengthAllowed"]){
                fieldInfo.zeroLengthAllowed = [((NSString*)values[i]) boolValue];
            }
        }
        int index = [fieldInfos add:fieldInfo];
        updateResult = [recordSet update];
        
        resolve(@{@"index":@(index),
                  @"editResult":@(editResult),
                  @"updateResult":@(updateResult)
                  });
    }
    @catch(NSException *exception){

        reject(@"JSRecordset",@"JSRecordset addFieldInfo expection",nil);

    }
}
RCT_REMAP_METHOD(deleteById, deleteById:(NSString*)recordsetId targetId:(int)id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
        Recordset* recordset = [JSObjManager getObjWithKey:recordsetId];
        [recordset seekID:id];
        bool result = [recordset delete];
        NSNumber* num = [NSNumber numberWithBool:result];
        resolve(num);
    }
    @catch(NSException *exception){
        reject(@"JSRecordset deleteById", exception.reason,nil);
    }
}
RCT_REMAP_METHOD(addNew, addNewById:(NSString*)recordsetId geometryId:(NSString *)geometryId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
        Recordset* recordset = [JSObjManager getObjWithKey:recordsetId];
        Geometry* geo = [JSObjManager getObjWithKey:geometryId];
        bool reuslt = [recordset addNew:geo];
        [recordset update];
        
        NSNumber* num = [NSNumber numberWithBool:reuslt];
        resolve(num);
    }
    @catch(NSException *exception){
        reject(@"JSRecordset deleteById", exception.reason,nil);
    }
}
@end

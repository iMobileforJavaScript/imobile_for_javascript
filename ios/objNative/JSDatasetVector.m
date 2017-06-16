//
//  JSDatasetVector.m
//  HelloWorldDemo
//
//  Created by 王子豪 on 2016/11/21.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSDatasetVector.h"
#import "SuperMap/DatasetVector.h"
#import "SuperMap/Rectangle2D.h"
#import "SuperMap/Geometry.h"
#import "SuperMap/Point2D.h"
#import "SuperMap/Recordset.h"
#import "JSObjManager.h"

@implementation JSDatasetVector
RCT_EXPORT_MODULE();


/**
 对应底层queryWithBounds方法
 
 @param datasetVectorId dsVector键值
 @param rectangle2DId rectangle2D键值
 @param cursorType
 @return {Promise.<Recordset>}
 */
RCT_REMAP_METHOD(queryInBuffer,queryWithDatasetVectorId:(NSString*)datasetVectorId andRectangle2DId:(NSString*)rectangle2DId andCursorType:(int)cursorType resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    DatasetVector* datasetVector = [JSObjManager getObjWithKey:datasetVectorId];
    Rectangle2D* rectangle = [JSObjManager getObjWithKey:rectangle2DId];
    Recordset* record = [datasetVector queryWithBounds:rectangle Type:cursorType];
    if(record){
        NSInteger key = (NSInteger)record;
        [JSObjManager addObj:record];
        resolve(@{@"recordsetId":@(key).stringValue});
    }else{
        reject(@"datasetVector",@"quaryInBuffer failed!!!",nil);
    }
}

RCT_REMAP_METHOD(getRecordset,getRecordsetByDatasetVectorId:(NSString*)datasetVectorId isEmptyRecordset:(BOOL)isEmptyRecordset cursorType:(int)cursorType resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
      DatasetVector* datasetVector = [JSObjManager getObjWithKey:datasetVectorId];
      Recordset* recordSet = [datasetVector recordset:isEmptyRecordset cursorType:cursorType];
      if(recordSet){
        NSInteger key = (NSInteger)recordSet;
        [JSObjManager addObj:recordSet];
        resolve(@{@"recordsetId":@(key).stringValue});
      }else{
        reject(@"datasetVector",@"get recordSet failed!!!",nil);
      }
}

RCT_REMAP_METHOD(query,queryWithDatasetVectorId:(NSString*)datasetVectorId andQueryParameterId:(NSString*)QueryParameterId withSize:(int)size withBatch:(int)batch resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    DatasetVector* datasetVector = [JSObjManager getObjWithKey:datasetVectorId];
    QueryParameter* para = [JSObjManager getObjWithKey:QueryParameterId];
    Recordset* record = [datasetVector query:para];
    if(record){
        NSInteger nsRecord = (NSInteger)record;
        [JSObjManager addObj:record];
        int recordCount = (int)record.recordCount;
        NSNumber* nsCount = [NSNumber numberWithInt:recordCount];
        NSNumber* nsBatch = [NSNumber numberWithInt:batch];
        NSNumber* nsSize = [NSNumber numberWithInt:size];
        
        if (size>10 ||size<=0) size = 10;
        int maxBatch = (recordCount/size)+ceil(recordCount%size);
        if (batch<=0) batch =1;
        if (batch>maxBatch) batch = maxBatch;
        
        BOOL isMove = [record moveTo:size*(batch-1)];
        NSString* geoJson = [record toGeoJSON:YES count:size];
        NSDictionary* dic =@{@"geoJson":geoJson,@"queryParameterId":QueryParameterId,@"counts":nsCount,@"batch":nsBatch,@"size":nsSize,@"recordsetId":@(nsRecord).stringValue};
        resolve(dic);
    }else{
        reject(@"datasetVector",@"query failed!!!",nil);
    }
}

RCT_REMAP_METHOD(buildSpatialIndex,buildSpatialIndexWithId:(NSString*)datasetVectorId spatialIndexType:(int)type resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    DatasetVector* datasetVector = [JSObjManager getObjWithKey:datasetVectorId];
    if(datasetVector){
        BOOL isBuild = [datasetVector buildSpatialIndexWithType:type];
        NSNumber * nsIsBuild = [NSNumber numberWithBool:isBuild];
        resolve(@{@"built":nsIsBuild});
    }else{
        reject(@"datasetVector",@"build SpatialIndex failed!!!",nil);
    }
}

RCT_REMAP_METHOD(dropSpatialIndex,dropSpatialIndexWithId:(NSString*)datasetVectorId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    DatasetVector* datasetVector = [JSObjManager getObjWithKey:datasetVectorId];
    if(datasetVector){
        BOOL isDrop = [datasetVector dropSpatialIndex];
        NSNumber * nsIsDrop = [NSNumber numberWithBool:isDrop];
        resolve(@{@"dropped":nsIsDrop});
    }else{
        reject(@"datasetVector",@"drop SpatialIndex failed!!!",nil);
    }
}

RCT_REMAP_METHOD(getSpatialIndexType,getSpatialIndexTypeWithId:(NSString*)datasetVectorId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    DatasetVector* datasetVector = [JSObjManager getObjWithKey:datasetVectorId];
    if(datasetVector){
        SpatialIndexType type = [datasetVector getSpatialIndexType];
        NSNumber * nsType = [NSNumber numberWithInt:(int)type];
        resolve(@{@"type":nsType});
    }else{
        reject(@"datasetVector",@"get SpatialIndex type failed!!!",nil);
    }
}

RCT_REMAP_METHOD(computeBounds,computeBoundsWithId:(NSString*)datasetVectorId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    DatasetVector* datasetVector = [JSObjManager getObjWithKey:datasetVectorId];
    if(datasetVector){
        Rectangle2D* rectangle2D = [datasetVector computeBounds];
        NSNumber* nsTop = [NSNumber numberWithDouble:rectangle2D.top];
        NSNumber* nsBottom = [NSNumber numberWithDouble:rectangle2D.bottom];
        NSNumber* nsLeft = [NSNumber numberWithDouble:rectangle2D.left];
        NSNumber* nsRight = [NSNumber numberWithDouble:rectangle2D.right];
        NSNumber* nsHeight = [NSNumber numberWithDouble:rectangle2D.height];
        NSNumber* nsWidth = [NSNumber numberWithDouble:rectangle2D.width];
        Point2D* center = rectangle2D.center;
        NSNumber* nsX = [NSNumber numberWithDouble:center.x];
        NSNumber* nsY = [NSNumber numberWithDouble:center.y];
        NSDictionary* dic = @{@"centerMap":@{@"x":nsX,@"y":nsY},@"top":nsTop,@"bottom":nsBottom,@"left":nsLeft,@"height":nsHeight,@"width":nsWidth,@"right":nsRight};
        resolve(@{@"bounds":dic});
    }else{
        reject(@"datasetVector",@"computeBounds failed!!!",nil);
    }
}

RCT_REMAP_METHOD(toGeoJSON,toGeoJSONWithId:(NSString*)datasetVectorId formStartId:(int)startId toEndId:(int)endId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    DatasetVector* datasetVector = [JSObjManager getObjWithKey:datasetVectorId];
    if(datasetVector){
        NSString* jsonStr = [datasetVector toGeoJSON:YES startID:startId endID:endId];
        resolve(@{@"geoJSON":jsonStr});
    }else{
        reject(@"datasetVector",@"translate to geoJSON failed!!!",nil);
    }
}

RCT_REMAP_METHOD(fromGeoJSON,fromGeoJSONWithId:(NSString*)datasetVectorId andJSONString:(NSString*)JSONString resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    DatasetVector* datasetVector = [JSObjManager getObjWithKey:datasetVectorId];
    if(datasetVector){
        BOOL isSuccess = [datasetVector fromGeoJSON:JSONString];
        NSNumber* nsSuccess = [NSNumber numberWithBool:isSuccess];
        resolve(@{@"done":nsSuccess});
    }else{
        reject(@"datasetVector",@"translate from geoJSON failed!!!",nil);
    }
}
/*
RCT_REMAP_METHOD(queryByFilter,queryByFilterWithId:(NSString*)datasetVectorId withAttributeFilter:(NSString*)attributeFilter resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    DatasetVector* datasetVector = [JSObjManager getObjWithKey:datasetVectorId];
    if(datasetVector){
        BOOL* isSuccess = [datasetVector fromGeoJSON:JSONString];
        NSNumber* nsSuccess = [NSNumber numberWithBool:isSuccess];
        resolve(@{@"done":nsSuccess});
    }else{
        reject(@"datasetVector",@"translate from geoJSON failed!!!",nil);
    }
}
 */

  /**
   @deprecated - 弃用

   @param datasetVectorId
   @param geometryId 
   @param distance
   @param cursorType
   @return
   */
  RCT_REMAP_METHOD(queryWithGeometry,queryWithGeometryByDatasetVectorId:(NSString*)datasetVectorId geometryId:(NSString*)geometryId bufferDistance:(double)distance cursorType:(int)cursorType resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    DatasetVector* datasetVector = [JSObjManager getObjWithKey:datasetVectorId];
    Geometry* geo = [JSObjManager getObjWithKey:geometryId];
    Recordset* record = [datasetVector queryWithGeometry:geo BufferDistance:distance Type:cursorType];
    if(record){
      NSInteger key = (NSInteger)record;
      [JSObjManager addObj:record];
      resolve(@{@"recordsetId":@(key).stringValue});
    }else{
      reject(@"datasetVector",@"quary failed!!!",nil);
    }
  }

RCT_REMAP_METHOD(getSMID, getSMIDById:(NSString*)dsVectorId SQL:(NSString*)SQL resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSMutableArray* smArr = [[NSMutableArray alloc]initWithCapacity:20];
        
        DatasetVector* dsVector = [JSObjManager getObjWithKey:dsVectorId];
        Recordset* recordSet = [dsVector queryWithFilter:SQL Type:STATIC];
        
        NSInteger count = recordSet.recordCount;
        for (NSInteger num = 0; num<count; num++) {
            if ([recordSet moveTo:num]) {
                int SmID = (int)[recordSet getFieldValueWithString:@"SMID"];
                NSNumber* num = [NSNumber numberWithInt:SmID];
                [smArr addObject:num];
            }
        }
        resolve(@{@"result":(NSArray*)smArr});
    } @catch (NSException *exception) {
        reject(@"datasetVector",@"getSMID failed!!!",nil);
    }
}

RCT_REMAP_METHOD(getFieldValue, getFieldValueById:(NSString*)dsVectorId SQL:(NSString*)SQL fieldName:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSMutableArray* smArr = [[NSMutableArray alloc]initWithCapacity:20];
        
        DatasetVector* dsVector = [JSObjManager getObjWithKey:dsVectorId];
        Recordset* recordSet = [dsVector queryWithFilter:SQL Type:STATIC];
        
        NSInteger count = recordSet.recordCount;
        for (NSInteger num = 0; num<count; num++) {
            if ([recordSet moveTo:num]) {
                id fieldValue = [recordSet getFieldValueWithString:name];
                if ([fieldValue isKindOfClass:[NSString class]] || [fieldValue isKindOfClass:[NSNumber class]]) {
                    [smArr addObject:fieldValue];
                }
            }
        }
        resolve(@{@"result":(NSArray*)smArr});
    } @catch (NSException *exception) {
        reject(@"datasetVector",@"getfieldValue failed!!!",nil);
    }
}

RCT_REMAP_METHOD(getGeoInnerPoint, getGeoInnerPointById:(NSString*)dsVectorId SQL:(NSString*)SQL resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSMutableArray* Arr = [[NSMutableArray alloc]initWithCapacity:20];
        
        DatasetVector* dsVector = [JSObjManager getObjWithKey:dsVectorId];
        Recordset* recordSet = [dsVector queryWithFilter:SQL Type:STATIC];
        
        NSInteger count = recordSet.recordCount;
        for (NSInteger num = 0; num<count; num++) {
            if ([recordSet moveTo:num]) {
                Geometry* geo = recordSet.geometry;
                Point2D* point = [geo getInnerPoint];
                
                NSNumber* xNum = [NSNumber numberWithDouble:point.x];
                NSNumber* yNum = [NSNumber numberWithDouble:point.y];
                NSArray* pointArr = @[xNum,yNum];
                [Arr addObject:pointArr];
            }
        }
        resolve(@{@"result":(NSArray*)Arr});
    } @catch (NSException *exception) {
        reject(@"datasetVector",@"get Geo Inner Point failed!!!",nil);
    }
}
@end

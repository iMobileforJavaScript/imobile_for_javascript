//
//  JSBufferAnalyst.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/19.
//  Copyright © 2017年 Facebook. All rights reserved.
//
#import "JSBufferAnalyst.h"
#import "SuperMap/BufferAnalyst.h"
#import "SuperMap/Map.h"
#import "SuperMap/Selection.h"
#import "SuperMap/TrackingLayer.h"
#import "SuperMap/Recordset.h"
#import "SuperMap/PrjCoordSys.h"
#import "SuperMap/DatasetVector.h"
#import "SuperMap/BufferAnalystParameter.h"
#import "SuperMap/BufferAnalystGeometry.h"
#import "SuperMap/GeoStyle.h"
#import "SuperMap/Color.h"
#import "SuperMap/Size2D.h"
#import "SuperMap/GeoRegion.h"
#import "SuperMap/Layer.h"


#import "JSObjManager.h"
@implementation JSBufferAnalyst
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(createBuffer,createBufferBySourceId:(NSString*)sourceId resultId:(NSString*)resultId bufferAnalystParaId:(NSString*)paraId isUnion:(BOOL)isUnion isAttributeRetained:(BOOL)isAttributeRetained resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        DatasetVector* sourceDataSet = [JSObjManager getObjWithKey:sourceId];
        DatasetVector* resultDataSet = [JSObjManager getObjWithKey:resultId];
        BufferAnalystParameter* para = [JSObjManager getObjWithKey:paraId];
        BOOL create = [BufferAnalyst createBufferSourceVector:sourceDataSet ResultVector:resultDataSet BufferParam:para IsUnion:isUnion IsAttributeRetained:isAttributeRetained];
        NSNumber* nsCreate = [NSNumber numberWithBool:create];
        resolve(@{@"isCreate":nsCreate});
    } @catch (NSException *exception) {
        reject(@"BufferAnalyst",@"create Buffer exception",nil);
    }
}

RCT_REMAP_METHOD(createLineOneSideMultiBuffer,createLineOneSideMultiBufferBySourceId:(NSString*)sourceId resultId:(NSString*)resultId arrBufferRadius:(NSArray*)arrBufferRadius bufferRadiusUnit:(int)bufferRadiusUnit semicircleSegment:(int)semicircleSegment isLeft:(BOOL)isLeft isUnion:(BOOL)isUnion isAttributeRetained:(BOOL)isAttributeRetained isRing:(BOOL)isRing resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        DatasetVector* sourceDataSet = [JSObjManager getObjWithKey:sourceId];
        DatasetVector* resultDataSet = [JSObjManager getObjWithKey:resultId];
        BOOL create = [BufferAnalyst createLineOneSideMultiBufferSourceVector:sourceDataSet ResultVector:resultDataSet ArrBufferRadius:arrBufferRadius BufferRadiusUnit:bufferRadiusUnit SemicircleSegment:semicircleSegment IsLeft:isLeft IsUnion:isUnion IsAttributeRetained:isAttributeRetained IsRing:isRing];
        NSNumber* nsCreate = [NSNumber numberWithBool:create];
        resolve(@{@"isCreate":nsCreate});
    } @catch (NSException *exception) {
        reject(@"BufferAnalyst",@"create Line One Side MultiBuffer exception",nil);
    }
}

RCT_REMAP_METHOD(createMultiBuffer,createMultiBufferBySourceId:(NSString*)sourceId resultId:(NSString*)resultId arrBufferRadius:(NSArray*)arrBufferRadius bufferRadiusUnit:(int)bufferRadiusUnit semicircleSegment:(int)semicircleSegment isUnion:(BOOL)isUnion isAttributeRetained:(BOOL)isAttributeRetained isRing:(BOOL)isRing resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        DatasetVector* sourceDataSet = [JSObjManager getObjWithKey:sourceId];
        DatasetVector* resultDataSet = [JSObjManager getObjWithKey:resultId];
        BOOL create = [BufferAnalyst createMultiBufferSourceVector:sourceDataSet ResultVector:resultDataSet ArrBufferRadius:arrBufferRadius BufferRadiusUnit:bufferRadiusUnit SemicircleSegment:semicircleSegment IsUnion:isUnion IsAttributeRetained:isAttributeRetained IsRing:isRing];
        NSNumber* nsCreate = [NSNumber numberWithBool:create];
        resolve(@{@"isCreate":nsCreate});
    } @catch (NSException *exception) {
        reject(@"BufferAnalyst",@"create Multi Buffer exception",nil);
    }
}

RCT_REMAP_METHOD(analyst, analystByMapId:(NSString*)mapId layerId:(NSString*)layerId params:(NSDictionary*)params  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Map* map = [JSObjManager getObjWithKey:mapId];
        Layer* layer = [JSObjManager getObjWithKey:layerId];
        Selection* selection = [layer getSelection];
        Recordset* recordset = [selection toRecordset];
        TrackingLayer* trackingLayer = map.trackingLayer;
        
        [trackingLayer clear];
        
        while (!recordset.isEOF) {
            Geometry* geoForBuffer = recordset.geometry;
            DatasetVector* queryDataset = recordset.datasetVector;
            
            PrjCoordSys* prj = queryDataset.prjCoordSys;
            
            GeoStyle* geoStyle = [[GeoStyle alloc] init];
            BufferAnalystParameter* bufferAnalystParameter = [[BufferAnalystParameter alloc] init];
            NSDictionary* parameter = [params objectForKey:@"parameter"];
            if (parameter) {
                if ([parameter objectForKey:@"endType"]) {
                    bufferAnalystParameter.bufferEndType = (int)[parameter objectForKey:@"endType"];
                }
                if ([parameter objectForKey:@"leftDistance"]) {
                    NSNumber* leftDistance = [parameter objectForKey:@"leftDistance"];
                    bufferAnalystParameter.leftDistance = [leftDistance stringValue];
                }
                if ([parameter objectForKey:@"rightDistance"]) {
                    NSNumber* rightDistance = [parameter objectForKey:@"rightDistance"];
                    bufferAnalystParameter.rightDistance = [rightDistance stringValue];
                }
            }
            NSDictionary* geoStyleDic = [params objectForKey:@"geoStyle"];
            if (geoStyleDic) {
                if ([geoStyleDic objectForKey:@"lineWidth"]) {
                    NSNumber* lineWidthObj = [geoStyleDic objectForKey:@"lineWidth"];
                    [geoStyle setLineWidth: lineWidthObj.doubleValue];
                }
                if ([geoStyleDic objectForKey:@"fillForeColor"]) {
                    NSDictionary* fillForeColor = [geoStyleDic objectForKey:@"fillForeColor"];
                    NSNumber* r = [fillForeColor objectForKey:@"r"];
                    NSNumber* g = [fillForeColor objectForKey:@"g"];
                    NSNumber* b = [fillForeColor objectForKey:@"b"];
                    NSNumber* a = [fillForeColor objectForKey:@"a"];
                    
                    if (!a) {
                        [geoStyle setFillForeColor:[[Color alloc] initWithR:r.intValue G:g.intValue B:b.intValue]];
                    } else {
                        [geoStyle setFillForeColor:[[Color alloc] initWithR:r.intValue G:g.intValue B:b.intValue A:a.intValue]];
                    }
                    
                }
                if ([geoStyleDic objectForKey:@"lineColor"]) {
                    NSDictionary* lineColor = [geoStyleDic objectForKey:@"lineColor"];
                    NSNumber* r = [lineColor objectForKey:@"r"];
                    NSNumber* g = [lineColor objectForKey:@"g"];
                    NSNumber* b = [lineColor objectForKey:@"b"];
                    NSNumber* a = [lineColor objectForKey:@"a"];
                    
                    if (!a) {
                        [geoStyle setLineColor:[[Color alloc] initWithR:r.intValue G:g.intValue B:b.intValue]];
                    } else {
                        [geoStyle setLineColor:[[Color alloc] initWithR:r.intValue G:g.intValue B:b.intValue A:a.intValue]];
                    }
                }
                if ([geoStyleDic objectForKey:@"lineSymbolID"]) {
                    NSNumber* lineSymbolID = [geoStyleDic objectForKey:@"lineSymbolID"];
                    [geoStyle setLineSymbolID:lineSymbolID.intValue];
                }
                if ([geoStyleDic objectForKey:@"markerSymbolID"]) {
                    NSNumber* markerSymbolID = [geoStyleDic objectForKey:@"markerSymbolID"];
                    [geoStyle setLineSymbolID:markerSymbolID.intValue];
                }
                if ([geoStyleDic objectForKey:@"markerSize"]) {
                    NSDictionary* markerSize = [geoStyleDic objectForKey:@"markerSize"];
                    NSNumber* w = [markerSize objectForKey:@"w"];
                    NSNumber* h = [markerSize objectForKey:@"h"];
                    
                    Size2D* size2D = [[Size2D alloc] initWithWidth:w.doubleValue Height:h.doubleValue];
                    [geoStyle setMarkerSize:size2D];
                }
                if ([geoStyleDic objectForKey:@"fillOpaqueRate"]) {
                    NSNumber* fillOpaqueRate = [geoStyleDic objectForKey:@"fillOpaqueRate"];
                    [geoStyle setFillOpaqueRate:fillOpaqueRate.intValue];
                }
            }
            GeoRegion* geoRegion = [BufferAnalystGeometry CreateBufferSourceGeometry:geoForBuffer BufferParam:bufferAnalystParameter prjCoordSys:prj];
            [geoRegion setStyle:geoStyle];
            
            [trackingLayer addGeometry:geoRegion WithTag:@""];
            [recordset moveNext];
        }
        
        [recordset dispose];
        [map refresh];
        
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"BufferAnalyst", exception.reason, nil);
    }
}
@end

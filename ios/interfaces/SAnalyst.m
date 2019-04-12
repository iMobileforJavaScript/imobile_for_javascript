//
//  SAnalyst.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/30.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "SAnalyst.h"

@interface SAnalyst()<Analysis3DDelegate>

@end

@implementation SAnalyst
RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents
{
    return @[
                ANALYST_MEASURELINE,
                ANALYST_MEASURESQUARE,
             ];
}

RCT_REMAP_METHOD(analystBuffer, analystBufferByLayerPath:(NSString*)layerPath params:(NSDictionary*)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Map* map = [SMap singletonInstance].smMapWC.mapControl.map;
        Layer* layer = [SMLayer findLayerByPath:layerPath];
        Selection* selection = [layer getSelection];
        Recordset* recordset = [selection toRecordset];
        TrackingLayer* trackingLayer = map.trackingLayer;
        
        [trackingLayer clear];
        
        while (!recordset.isEOF) {
            Geometry* geoForBuffer = recordset.geometry;
            DatasetVector* queryDataset = recordset.datasetVector;
            
            PrjCoordSys* prj = queryDataset.prjCoordSys;
            
            NSDictionary* parameter = [params objectForKey:@"parameter"];
            BufferAnalystParameter* bufferAnalystParameter = [SAnalyst getBufferAnalystParameterByDictionary:parameter];
            
            NSDictionary* geoStyleDic = [params objectForKey:@"geoStyle"];
            GeoStyle* geoStyle = [SAnalyst getGeoStyleByDictionary:geoStyleDic];
            
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

RCT_REMAP_METHOD(createBuffer, createBufferWithSourceData:(NSDictionary *)sourceData resultData:(NSDictionary *)resultData bufferParameter:(NSDictionary *)bufferParameter isUnion:(BOOL)isUnion isAttributeRetained:(BOOL)isAttributeRetained optionParameter:(NSDictionary *)optionParameter withResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Map* map = [SMap singletonInstance].smMapWC.mapControl.map;
        Dataset* sourceDataset = [SAnalyst getDatasetByDictionary:sourceData];
        Dataset* resultDataset = [SAnalyst getDatasetByDictionary:resultData];
        
        BOOL result = NO;
        
        if (sourceData && resultDataset) {
            BufferAnalystParameter* parameter = [SAnalyst getBufferAnalystParameterByDictionary:bufferParameter];
            if (parameter) {
                result = [BufferAnalyst createBufferSourceVector:(DatasetVector *)sourceDataset ResultVector:(DatasetVector *)resultDataset BufferParam:parameter IsUnion:isUnion IsAttributeRetained:isAttributeRetained];
            }
        }
        
        if (result) {
            BOOL showResult = [optionParameter objectForKey:@"showResult"];
            
            if (showResult) {
                NSDictionary* geoStyleDic = [optionParameter objectForKey:@"geoStyle"];
                GeoStyle* geoStyle = [SAnalyst getGeoStyleByDictionary:geoStyleDic];
                TrackingLayer* trackingLayer = map.trackingLayer;
                
//                Recordset* recordset = resultDataset toRecor
            }
        }
        
        
        resolve(@(result));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}


/**
 * 三维量算分析
 *
 * @param promise
 */
RCT_REMAP_METHOD(setMeasureLineAnalyst, setMeasureLineAnalystResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SceneControl* sceneControl = [[[SScene singletonInstance]smSceneWC] sceneControl];
        [[AnalysisHelper3D sharedInstance] initializeWithSceneControl:sceneControl];
        [AnalysisHelper3D sharedInstance].delegate = self;
        [[AnalysisHelper3D sharedInstance] startMeasureAnalysis];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}
-(void)distanceResult:(double)distance{
    [self sendEventWithName:ANALYST_MEASURELINE body:@(distance)];
}

/**
 * 三维面积分析
 *
 * @param promise
 */
RCT_REMAP_METHOD(setMeasureSquareAnalyst, setMeasureSquareAnalystResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SceneControl* sceneControl = [[[SScene singletonInstance]smSceneWC] sceneControl];
        [[AnalysisHelper3D sharedInstance] initializeWithSceneControl:sceneControl];
        [AnalysisHelper3D sharedInstance].delegate = self;
        [[AnalysisHelper3D sharedInstance] startSureArea];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}
-(void)areaResult:(double)area{
    [self sendEventWithName:ANALYST_MEASURESQUARE body:@(area)];
}

/**
 * 关闭所有分析
 *
 * @param promise
 */
RCT_REMAP_METHOD( closeAnalysis,  closeAnalysisResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SceneControl* sceneControl = [[[SScene singletonInstance]smSceneWC] sceneControl];
        [[AnalysisHelper3D sharedInstance] initializeWithSceneControl:sceneControl];
        [AnalysisHelper3D sharedInstance].delegate = nil;
        [[AnalysisHelper3D sharedInstance] closeAnalysis];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"SScene", exception.reason, nil);
    }
}






/**************************************************************************原生方法分割线**********************************************************************************************/
+ (Dataset *)getDatasetByDictionary:(NSDictionary *)dic {
    Dataset* dataset = nil;
    Datasources* datasources = [SMap singletonInstance].smMapWC.workspace.datasources;
    Datasource* datacourse = nil;
    if (dic) {
        if ([dic objectForKey:@"datasouce"]) {
            NSString* alias = [dic objectForKey:@"datasouce"];
            datacourse = [datasources getAlias:alias];
            if (datacourse && [dic objectForKey:@"dateset"]) {
                dataset = [datacourse.datasets getWithName:[dic objectForKey:@"dateset"]];
            }
        }
    }
    return dataset;
}

+ (Dataset *)createDatasetByDictionary:(NSDictionary *)dic {
    Dataset* dataset = nil;
    Datasources* datasources = [SMap singletonInstance].smMapWC.workspace.datasources;
    Datasource* datacourse = nil;
    if (dic) {
        if ([dic objectForKey:@"datasouce"]) {
            NSString* alias = [dic objectForKey:@"datasouce"];
            datacourse = [datasources getAlias:alias];
            if (datacourse && [dic objectForKey:@"datesetName"]) {
                NSString* datasetType = REGION;
                if ([dic objectForKey:@"datesetType"]) {
                    datasetType = [dic objectForKey:@"datesetType"];
                }
                EncodeType* encodeType = NONE;
                if ([dic objectForKey:@"encodeType"]) {
                    encodeType = [dic objectForKey:@"encodeType"];
                }
                
                DatasetVectorInfo* dsInfo = [[DatasetVectorInfo alloc] init];
                [dsInfo setDatasetType:datasetType];
                [dsInfo setName:[dic objectForKey:@"datesetName"]];
                [dsInfo setEncodeType:encodeType];
                dataset = [datacourse.datasets create:dsInfo];
            }
        }
    }
    return dataset;
}

+ (GeoStyle *)getGeoStyleByDictionary:(NSDictionary *)geoStyleDic {
    GeoStyle* geoStyle = [[GeoStyle alloc] init];
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
    return geoStyle;
}

+ (BufferAnalystParameter *)getBufferAnalystParameterByDictionary:(NSDictionary *)parameter {
    BufferAnalystParameter* bufferAnalystParameter = [[BufferAnalystParameter alloc] init];
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
    return bufferAnalystParameter;
}
@end

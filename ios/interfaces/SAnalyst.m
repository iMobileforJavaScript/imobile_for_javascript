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
            if (geoStyle) {
                [geoRegion setStyle:geoStyle];
            }
            
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

#pragma mark 缓冲区分析
RCT_REMAP_METHOD(createBuffer, createBufferWithSourceData:(NSDictionary *)sourceData resultData:(NSDictionary *)resultData bufferParameter:(NSDictionary *)bufferParameter isUnion:(BOOL)isUnion isAttributeRetained:(BOOL)isAttributeRetained optionParameter:(NSDictionary *)optionParameter withResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Map* map = [SMap singletonInstance].smMapWC.mapControl.map;
        if (map.workspace == nil) {
            map.workspace = [SMap singletonInstance].smMapWC.workspace;
        }
        Dataset* sourceDataset = [SAnalyst getDatasetByDictionary:sourceData];
        Dataset* resultDataset = nil;
        
        DatasetVectorInfo* info = [[DatasetVectorInfo alloc] init];
        if ([resultData objectForKey:@"dataset"] != nil) {
            [info setName:[resultData objectForKey:@"dataset"]];
            [info setDatasetType:REGION];
            
            resultDataset = [SAnalyst createDatasetByDictionary:resultData];
        }
        
        BOOL result = NO;
        NSString* errorMsg = @"";
        
        if (sourceDataset && resultDataset) {
            BufferAnalystParameter* parameter = [SAnalyst getBufferAnalystParameterByDictionary:bufferParameter];
            if (parameter) {
                result = [BufferAnalyst createBufferSourceVector:(DatasetVector *)sourceDataset ResultVector:(DatasetVector *)resultDataset BufferParam:parameter IsUnion:isUnion IsAttributeRetained:isAttributeRetained];
                if (!result) errorMsg = @"分析失败";
            } else {
                errorMsg = @"缺少分析参数";
            }
        } else {
            if (sourceDataset == nil) {
                errorMsg = @"数据源不存在";
            } else if (sourceData == nil) {
                errorMsg = @"数据集已存在";
            }
        }
        
        NSDictionary* geoStyleDic = [optionParameter objectForKey:@"geoStyle"];
        GeoStyle* geoStyle = [SAnalyst getGeoStyleByDictionary:geoStyleDic];
        
        if (geoStyle) {
            resultDataset.description = [NSString stringWithFormat:@"{\"geoStyle\":%@}", [geoStyle toJson]];
        }
        
        if (result) {
            NSNumber* showResult = [optionParameter objectForKey:@"showResult"];
            
            if (showResult.boolValue) {
                Layer* layer = [map.layers addDataset:resultDataset ToHead:YES];
                if (geoStyle) {
                    [((LayerSettingVector *)layer.layerSetting) setGeoStyle:geoStyle];
                }
                
                [map refresh];
            }
        }
        
        if (result) {
            resolve(@{
                      @"result": @(result),
                      });
        } else {
            Datasource* ds = [SAnalyst getDatasourceByDictionary:resultData];
            long resultDatasetIndex = [ds.datasets indexOf:[resultData objectForKey:@"dataset"]];
            if (resultDatasetIndex >= 0) {
                [ds.datasets delete:resultDatasetIndex];
            }
            
            resolve(@{
                      @"result": @(result),
                      @"errorMsg": errorMsg,
                      });
        }
    } @catch (NSException *exception) {
        Datasource* ds = [SAnalyst getDatasourceByDictionary:resultData];
        long resultDatasetIndex = [ds.datasets indexOf:[resultData objectForKey:@"dataset"]];
        if (resultDatasetIndex >= 0) {
            [ds.datasets delete:resultDatasetIndex];
        }
        reject(@"SAnalyst", exception.reason, nil);
    }
}

#pragma mark 多重缓冲区分析
RCT_REMAP_METHOD(createMultiBuffer, createMultiBufferWithSourceData:(NSDictionary *)sourceData resultData:(NSDictionary *)resultData bufferRadiuses:(NSArray *)bufferRadiuses bufferRadiusUnit:(NSString *)bufferRadiusUnit semicircleSegments:(int)semicircleSegments isUnion:(BOOL)isUnion isAttributeRetained:(BOOL)isAttributeRetained isRing:(BOOL)isRing optionParameter:(NSDictionary *)optionParameter withResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Map* map = [SMap singletonInstance].smMapWC.mapControl.map;
        if (map.workspace == nil) {
            map.workspace = [SMap singletonInstance].smMapWC.workspace;
        }
        Dataset* sourceDataset = [SAnalyst getDatasetByDictionary:sourceData];
        Dataset* resultDataset = nil;
        
        if ([resultData objectForKey:@"dataset"] != nil) {
            resultDataset = [SAnalyst createDatasetByDictionary:resultData];
        }
        
        BOOL result = NO;
        NSString* errorMsg = @"";
        
        if (sourceDataset && resultDataset) {
            BufferRadiusUnit unit = [SAnalyst getBufferRadiusUnit:bufferRadiusUnit];
            
            result = [BufferAnalyst createMultiBufferSourceVector:(DatasetVector *)sourceDataset ResultVector:(DatasetVector *)resultDataset ArrBufferRadius:bufferRadiuses BufferRadiusUnit:unit SemicircleSegment:semicircleSegments IsUnion:isUnion IsAttributeRetained:isAttributeRetained IsRing:isRing];
            if (!result) errorMsg = @"分析失败";
        } else {
            if (sourceDataset == nil) {
                errorMsg = @"数据源不存在";
            } else if (sourceData == nil) {
                errorMsg = @"数据集已存在";
            }
        }
        
        NSDictionary* geoStyleDic = [optionParameter objectForKey:@"geoStyle"];
        GeoStyle* geoStyle = [SAnalyst getGeoStyleByDictionary:geoStyleDic];
        
        if (geoStyle) {
            resultDataset.description = [NSString stringWithFormat:@"{\"geoStyle\":%@}", [geoStyle toJson]];
        }
        
        if (result) {
            NSNumber* showResult = [optionParameter objectForKey:@"showResult"];
            
            if (showResult.boolValue) {
                Layer* layer = [map.layers addDataset:resultDataset ToHead:YES];
                if (geoStyle) {
                    [((LayerSettingVector *)layer.layerSetting) setGeoStyle:geoStyle];
                }
                
//                [recordset dispose];
                [map refresh];
            }
        }
        
        if (result) {
            resolve(@{
                      @"result": @(result),
                      });
        } else {
            Datasource* ds = [SAnalyst getDatasourceByDictionary:resultData];
            long resultDatasetIndex = [ds.datasets indexOf:[resultData objectForKey:@"dataset"]];
            if (resultDatasetIndex >= 0) {
                [ds.datasets delete:resultDatasetIndex];
            }
            resolve(@{
                      @"result": @(result),
                      @"errorMsg": errorMsg,
                      });
        }
    } @catch (NSException *exception) {
        Datasource* ds = [SAnalyst getDatasourceByDictionary:resultData];
        long resultDatasetIndex = [ds.datasets indexOf:[resultData objectForKey:@"dataset"]];
        if (resultDatasetIndex >= 0) {
            [ds.datasets delete:resultDatasetIndex];
        }
        reject(@"SAnalyst", exception.reason, nil);
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
        reject(@"SAnalyst", exception.reason, nil);
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
        reject(@"SAnalyst", exception.reason, nil);
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
        reject(@"SAnalyst", exception.reason, nil);
    }
}






/**************************************************************************原生方法分割线**********************************************************************************************/
+ (Datasource *)getDatasourceByDictionary:(NSDictionary *)dic {
    Datasources* datasources = [SMap singletonInstance].smMapWC.workspace.datasources;
    Datasource* datasource = nil;
    if (dic) {
        if ([dic objectForKey:@"datasource"]) {
            NSString* alias = [dic objectForKey:@"datasource"];
            datasource = [datasources getAlias:alias];
        }
    }
    return datasource;
}

+ (Dataset *)getDatasetByDictionary:(NSDictionary *)dic {
    Dataset* dataset = nil;
    Datasources* datasources = [SMap singletonInstance].smMapWC.workspace.datasources;
    Datasource* datasource = nil;
    if (dic) {
        if ([dic objectForKey:@"datasource"]) {
            NSString* alias = [dic objectForKey:@"datasource"];
            datasource = [datasources getAlias:alias];
            if (datasource && [dic objectForKey:@"dataset"]) {
                dataset = [datasource.datasets getWithName:[dic objectForKey:@"dataset"]];
            }
        }
    }
    return dataset;
}

+ (Dataset *)createDatasetByDictionary:(NSDictionary *)dic {
    Dataset* dataset = nil;
    Datasources* datasources = [SMap singletonInstance].smMapWC.workspace.datasources;
    Datasource* datasource = nil;
    if (dic) {
        if ([dic objectForKey:@"datasource"]) {
            NSString* alias = [dic objectForKey:@"datasource"];
            datasource = [datasources getAlias:alias];
            if (datasource && [dic objectForKey:@"dataset"]) {
                int datasetType = REGION;
                if ([dic objectForKey:@"datasetType"]) {
                    datasetType = ((NSNumber *)[dic objectForKey:@"datasetType"]).intValue;
                }
                int encodeType = NONE;
                if ([dic objectForKey:@"encodeType"]) {
                    encodeType = ((NSNumber *)[dic objectForKey:@"encodeType"]).intValue;
                }
                
                DatasetVectorInfo* dsInfo = [[DatasetVectorInfo alloc] init];
                [dsInfo setDatasetType:datasetType];
                [dsInfo setName:[dic objectForKey:@"dataset"]];
                [dsInfo setEncodeType:encodeType];
                dataset = [datasource.datasets create:dsInfo];
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
    } else {
        [geoStyle setLineColor:[[Color alloc] initWithR:0 G:100 B:255]];
        [geoStyle setFillForeColor:[[Color alloc] initWithR:0 G:255 B:0]];
        Size2D* size2D = [[Size2D alloc] initWithWidth:5 Height:5];
        [geoStyle setMarkerSize:size2D];
    }
    return geoStyle;
}

+ (BufferAnalystParameter *)getBufferAnalystParameterByDictionary:(NSDictionary *)parameter {
    BufferAnalystParameter* bufferAnalystParameter = nil;
    if (parameter) {
        bufferAnalystParameter = [[BufferAnalystParameter alloc] init];
        NSNumber* leftDistance = [parameter objectForKey:@"leftDistance"];
        NSNumber* rightDistance = [parameter objectForKey:@"rightDistance"];
        NSNumber* semicircleSegments = [parameter objectForKey:@"semicircleSegments"];
        if ([parameter objectForKey:@"endType"] != nil) {
            NSNumber* endType = [parameter objectForKey:@"endType"];
            bufferAnalystParameter.bufferEndType = endType.intValue;
        }
        if (leftDistance != nil && leftDistance.intValue > 0) {
            bufferAnalystParameter.leftDistance = [leftDistance stringValue];
        }
        if (rightDistance != nil && rightDistance.intValue > 0) {
            bufferAnalystParameter.rightDistance = [rightDistance stringValue];
        }
        if (semicircleSegments != nil && semicircleSegments.intValue > 0) {
            bufferAnalystParameter.semicircleLineSegment = [semicircleSegments intValue];
        }
    }
    return bufferAnalystParameter;
}

+ (BufferRadiusUnit)getBufferRadiusUnit:(NSString *)unitStr {
    if ([unitStr isEqualToString:@"MiliMeter"]) {
        return MiliMeter;
    } else if ([unitStr isEqualToString:@"CentiMeter"]) {
        return CentiMeter;
    } else if ([unitStr isEqualToString:@"DeciMeter"]) {
        return DeciMeter;
    } else if ([unitStr isEqualToString:@"KiloMeter"]) {
        return KiloMeter;
    } else if ([unitStr isEqualToString:@"Yard"]) {
        return Yard;
    } else if ([unitStr isEqualToString:@"Inch"]) {
        return Inch;
    } else if ([unitStr isEqualToString:@"Foot"]) {
        return Foot;
    } else if ([unitStr isEqualToString:@"Mile"]) {
        return Mile;
    } else {
        return Meter;
    }
}
@end

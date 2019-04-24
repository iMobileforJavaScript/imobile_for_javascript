//
//  SAnalyst.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/30.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "SAnalyst.h"
#import "SMAnalyst.h"

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
/******************************************************************************缓冲区分析*****************************************************************************************/
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
            BufferAnalystParameter* bufferAnalystParameter = [SMAnalyst getBufferAnalystParameterByDictionary:parameter];
            
            NSDictionary* geoStyleDic = [params objectForKey:@"geoStyle"];
            GeoStyle* geoStyle = [SMAnalyst getGeoStyleByDictionary:geoStyleDic];
            
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
        Dataset* sourceDataset = [SMAnalyst getDatasetByDictionary:sourceData];
        Dataset* resultDataset = nil;
        
        DatasetVectorInfo* info = [[DatasetVectorInfo alloc] init];
        if ([resultData objectForKey:@"dataset"] != nil) {
            [info setName:[resultData objectForKey:@"dataset"]];
            [info setDatasetType:REGION];
            
            resultDataset = [SMAnalyst createDatasetByDictionary:resultData];
        }
        
        BOOL result = NO;
        NSString* errorMsg = @"";
        
        if (sourceDataset && resultDataset) {
            BufferAnalystParameter* parameter = [SMAnalyst getBufferAnalystParameterByDictionary:bufferParameter];
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
        
        NSNumber* showResult = [optionParameter objectForKey:@"showResult"];
        NSDictionary* geoStyleDic = [optionParameter objectForKey:@"geoStyle"];
        GeoStyle* geoStyle = [SMAnalyst getGeoStyleByDictionary:geoStyleDic];
        
        if (geoStyle) {
            resultDataset.description = [NSString stringWithFormat:@"{\"geoStyle\":%@}", [geoStyle toJson]];
        }
        
        if (result && showResult.boolValue) {
            [SMAnalyst displayResult:resultDataset style:geoStyle];
        }
        
        if (result) {
            resolve(@{
                      @"result": @(result),
                      });
        } else {
            [SMAnalyst deleteDataset:resultData];
            
            resolve(@{
                      @"result": @(result),
                      @"errorMsg": errorMsg,
                      });
        }
    } @catch (NSException *exception) {
        [SMAnalyst deleteDataset:resultData];
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
        Dataset* sourceDataset = [SMAnalyst getDatasetByDictionary:sourceData];
        Dataset* resultDataset = nil;
        
        if ([resultData objectForKey:@"dataset"] != nil) {
            resultDataset = [SMAnalyst createDatasetByDictionary:resultData];
        }
        
        BOOL result = NO;
        NSString* errorMsg = @"";
        
        if (sourceDataset && resultDataset) {
            BufferRadiusUnit unit = [SMAnalyst getBufferRadiusUnit:bufferRadiusUnit];
            
            result = [BufferAnalyst createMultiBufferSourceVector:(DatasetVector *)sourceDataset ResultVector:(DatasetVector *)resultDataset ArrBufferRadius:bufferRadiuses BufferRadiusUnit:unit SemicircleSegment:semicircleSegments IsUnion:isUnion IsAttributeRetained:isAttributeRetained IsRing:isRing];
            if (!result) errorMsg = @"分析失败";
        } else {
            if (sourceDataset == nil) {
                errorMsg = @"数据源不存在";
            } else if (sourceData == nil) {
                errorMsg = @"数据集已存在";
            }
        }
        
        NSNumber* showResult = [optionParameter objectForKey:@"showResult"];
        NSDictionary* geoStyleDic = [optionParameter objectForKey:@"geoStyle"];
        GeoStyle* geoStyle = [SMAnalyst getGeoStyleByDictionary:geoStyleDic];
        
        if (geoStyle) {
            resultDataset.description = [NSString stringWithFormat:@"{\"geoStyle\":%@}", [geoStyle toJson]];
        }
        
        if (result && showResult.boolValue) {
            [SMAnalyst displayResult:resultDataset style:geoStyle];
        }
        
        if (result) {
            resolve(@{@"result": @(result)});
        } else {
            [SMAnalyst deleteDataset:resultData];
            resolve(@{
                      @"result": @(result),
                      @"errorMsg": errorMsg,
                      });
        }
    } @catch (NSException *exception) {
        [SMAnalyst deleteDataset:resultData];
        reject(@"SAnalyst", exception.reason, nil);
    }
}

/********************************************************************************叠加分析**************************************************************************************/
#pragma mark 叠加分析-裁剪
RCT_REMAP_METHOD(clip, clipBydsWithSourceData:(NSDictionary *)sourceData targetData:(NSDictionary *)targetData resultData:(NSDictionary *)resultData optionParameter:(NSDictionary *)optionParameter resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BOOL result = [SMAnalyst overlayerAnalystWithType:@"clip" sourceData:sourceData targetData:targetData resultData:resultData optionParameter:optionParameter];
        resolve(@(result));
    } @catch (NSException *exception) {
        [SMAnalyst deleteDataset:resultData];
        reject(@"OverlayAnalyst", exception.description, nil);
    }
}

#pragma mark 叠加分析-擦除
RCT_REMAP_METHOD(erase, eraseByWithSourceData:(NSDictionary *)sourceData targetData:(NSDictionary *)targetData resultData:(NSDictionary *)resultData optionParameter:(NSDictionary *)optionParameter resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BOOL result = [SMAnalyst overlayerAnalystWithType:@"erase" sourceData:sourceData targetData:targetData resultData:resultData optionParameter:optionParameter];
        resolve(@(result));
    } @catch (NSException *exception) {
        [SMAnalyst deleteDataset:resultData];
        reject(@"OverlayAnalyst", exception.description, nil);
    }
}

#pragma mark 叠加分析-同一
RCT_REMAP_METHOD(identity, identityWithSourceData:(NSDictionary *)sourceData targetData:(NSDictionary *)targetData resultData:(NSDictionary *)resultData optionParameter:(NSDictionary *)optionParameter resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BOOL result = [SMAnalyst overlayerAnalystWithType:@"identity" sourceData:sourceData targetData:targetData resultData:resultData optionParameter:optionParameter];
        resolve(@(result));
    } @catch (NSException *exception) {
        [SMAnalyst deleteDataset:resultData];
        reject(@"OverlayAnalyst", exception.description, nil);
    }
}

#pragma mark 叠加分析-相交
RCT_REMAP_METHOD(intersect, intersectWithSourceData:(NSDictionary *)sourceData targetData:(NSDictionary *)targetData resultData:(NSDictionary *)resultData optionParameter:(NSDictionary *)optionParameter resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    @try {
        BOOL result = [SMAnalyst overlayerAnalystWithType:@"intersect" sourceData:sourceData targetData:targetData resultData:resultData optionParameter:optionParameter];
        resolve(@(result));
    } @catch (NSException *exception) {
        [SMAnalyst deleteDataset:resultData];
        reject(@"OverlayAnalyst", exception.description, nil);
    }
}

#pragma mark 叠加分析-合并
RCT_REMAP_METHOD(union, unionWithSourceData:(NSDictionary *)sourceData targetData:(NSDictionary *)targetData resultData:(NSDictionary *)resultData optionParameter:(NSDictionary *)optionParameter resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BOOL result = [SMAnalyst overlayerAnalystWithType:@"union" sourceData:sourceData targetData:targetData resultData:resultData optionParameter:optionParameter];
        resolve(@(result));
    } @catch (NSException *exception) {
        [SMAnalyst deleteDataset:resultData];
        reject(@"OverlayAnalyst", exception.description, nil);
    }
}

#pragma mark 叠加分析-更新
RCT_REMAP_METHOD(update, updateWithSourceData:(NSDictionary *)sourceData targetData:(NSDictionary *)targetData resultData:(NSDictionary *)resultData optionParameter:(NSDictionary *)optionParameter resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BOOL result = [SMAnalyst overlayerAnalystWithType:@"update" sourceData:sourceData targetData:targetData resultData:resultData optionParameter:optionParameter];
        resolve(@(result));
    } @catch (NSException *exception) {
        [SMAnalyst deleteDataset:resultData];
        reject(@"OverlayAnalyst", exception.description, nil);
    }
}

#pragma mark 叠加分析-对称差
RCT_REMAP_METHOD(xOR, xORWithSourceData:(NSDictionary *)sourceData targetData:(NSDictionary *)targetData resultData:(NSDictionary *)resultData optionParameter:(NSDictionary *)optionParameter resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BOOL result = [SMAnalyst overlayerAnalystWithType:@"xOR" sourceData:sourceData targetData:targetData resultData:resultData optionParameter:optionParameter];
        resolve(@(result));
    } @catch (NSException *exception) {
        [SMAnalyst deleteDataset:resultData];
        reject(@"OverlayAnalyst", exception.description, nil);
    }
}


/********************************************************************************三维分析**************************************************************************************/

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

@end

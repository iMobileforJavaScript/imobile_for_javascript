//
//  SMAnalyst.m
//  Supermap
//
//  Created by Shanglong Yang on 2019/4/24.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "SMAnalyst.h"

@implementation SMAnalyst
+ (Layer *)displayResult:(Dataset *)ds style:(GeoStyle *)style {
    Map* map = [SMap singletonInstance].smMapWC.mapControl.map;
    Layer* layer = [map.layers addDataset:ds ToHead:YES];
    if (style) {
        [((LayerSettingVector *)layer.layerSetting) setGeoStyle:style];
    }
    
    [map refresh];
    return layer;
}

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

+ (BOOL)overlayerAnalystWithType:(NSString *)type sourceData:(NSDictionary *)sourceData targetData:(NSDictionary *)targetData resultData:(NSDictionary *)resultData optionParameter:(NSDictionary *)optionParameter {
    Map* map = [SMap singletonInstance].smMapWC.mapControl.map;
    if (map.workspace == nil) {
        map.workspace = [SMap singletonInstance].smMapWC.workspace;
    }
    Dataset* sourceDataset = [SMAnalyst getDatasetByDictionary:sourceData];
    Dataset* targetDataset = [SMAnalyst getDatasetByDictionary:targetData];
    Dataset* resultDataset = nil;
    
    if ([resultData objectForKey:@"dataset"] != nil) {
        resultDataset = [SMAnalyst createDatasetByDictionary:resultData];
    }
    
    BOOL result = NO;
    
    OverlayAnalystParameter* analystPara = [[OverlayAnalystParameter alloc] init];
    [analystPara setTolerance:0.001];
    if (sourceDataset && targetDataset && resultDataset) {
        
        if ([type isEqualToString:@"clip"]) {
            result = [OverlayAnalyst clip:(DatasetVector *)sourceDataset clipDataset:(DatasetVector *)targetDataset resultDataset:(DatasetVector *)resultDataset parameter:analystPara];
        } else if ([type isEqualToString:@"erase"]) {
            result = [OverlayAnalyst erase:(DatasetVector *)sourceDataset eraseDataset:(DatasetVector *)targetDataset resultDataset:(DatasetVector *)resultDataset parameter:analystPara];
        } else if ([type isEqualToString:@"identity"]) {
            result = [OverlayAnalyst identity:(DatasetVector *)sourceDataset identityDataset:(DatasetVector *)targetDataset resultDataset:(DatasetVector *)resultDataset parameter:analystPara];
        } else if ([type isEqualToString:@"intersect"]) {
            result = [OverlayAnalyst intersect:(DatasetVector *)sourceDataset intersectDataset:(DatasetVector *)targetDataset resultDataset:(DatasetVector *)resultDataset parameter:analystPara];
        } else if ([type isEqualToString:@"union"]) {
            result = [OverlayAnalyst union:(DatasetVector *)sourceDataset unionDataset:(DatasetVector *)targetDataset resultDataset:(DatasetVector *)resultDataset parameter:analystPara];
        } else if ([type isEqualToString:@"update"]) {
            result = [OverlayAnalyst update:(DatasetVector *)sourceDataset updateDataset:(DatasetVector *)targetDataset resultDataset:(DatasetVector *)resultDataset parameter:analystPara];
        } else if ([type isEqualToString:@"xOR"]) {
            result = [OverlayAnalyst xOR:(DatasetVector *)sourceDataset xORDataset:(DatasetVector *)targetDataset resultDataset:(DatasetVector *)resultDataset parameter:analystPara];
        } else {
            return NO;
        }
        
        if (result) {
            NSNumber* showResult = [optionParameter objectForKey:@"showResult"];
            NSDictionary* geoStyleDic = [optionParameter objectForKey:@"geoStyle"];
            GeoStyle* geoStyle = [SMAnalyst getGeoStyleByDictionary:geoStyleDic];
            
            if (geoStyle) {
                resultDataset.description = [NSString stringWithFormat:@"{\"geoStyle\":%@}", [geoStyle toJson]];
            }
            
            if (showResult.boolValue) {
                [SMAnalyst displayResult:resultDataset style:geoStyle];
            }
        } else {
            // 分析失败，删除结果数据集
            [SMAnalyst deleteDataset:resultData];
        }
    }
    
    return result;
}

+ (void)deleteDataset:(NSDictionary *)dsInfo {
    Datasource* ds = [SMAnalyst getDatasourceByDictionary:dsInfo];
    long resultDatasetIndex = [ds.datasets indexOf:[dsInfo objectForKey:@"dataset"]];
    if (resultDatasetIndex >= 0) {
        [ds.datasets delete:resultDatasetIndex];
    }
}
@end

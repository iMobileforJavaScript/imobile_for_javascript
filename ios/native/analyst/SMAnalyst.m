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
            NSString* datasetName =  [dic objectForKey:@"dataset"];
            if (datasource && datasetName) {
                if ([datasource.datasets getWithName:datasetName]) {
                    @throw [[NSException alloc] initWithName:@"Create Dataset Error" reason:@"dataset is exist" userInfo:nil];
                }
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
                [dsInfo setName:datasetName];
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
        NSError * error = nil;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:geoStyleDic options:NSJSONWritingPrettyPrinted error:&error];
        NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [geoStyle fromJson:jsonStr];
        
//        if ([geoStyleDic objectForKey:@"lineWidth"]) {
//            NSNumber* lineWidthObj = [geoStyleDic objectForKey:@"lineWidth"];
//            [geoStyle setLineWidth: lineWidthObj.doubleValue];
//        }
//        if ([geoStyleDic objectForKey:@"fillForeColor"]) {
//            NSDictionary* fillForeColor = [geoStyleDic objectForKey:@"fillForeColor"];
//            NSNumber* r = [fillForeColor objectForKey:@"r"];
//            NSNumber* g = [fillForeColor objectForKey:@"g"];
//            NSNumber* b = [fillForeColor objectForKey:@"b"];
//            NSNumber* a = [fillForeColor objectForKey:@"a"];
//
//            if (!a) {
//                [geoStyle setFillForeColor:[[Color alloc] initWithR:r.intValue G:g.intValue B:b.intValue]];
//            } else {
//                [geoStyle setFillForeColor:[[Color alloc] initWithR:r.intValue G:g.intValue B:b.intValue A:a.intValue]];
//            }
//
//        }
//
//        if ([geoStyleDic objectForKey:@"lineColor"]) {
//            NSDictionary* lineColor = [geoStyleDic objectForKey:@"lineColor"];
//            NSNumber* r = [lineColor objectForKey:@"r"];
//            NSNumber* g = [lineColor objectForKey:@"g"];
//            NSNumber* b = [lineColor objectForKey:@"b"];
//            NSNumber* a = [lineColor objectForKey:@"a"];
//
//            if (!a) {
//                [geoStyle setLineColor:[[Color alloc] initWithR:r.intValue G:g.intValue B:b.intValue]];
//            } else {
//                [geoStyle setLineColor:[[Color alloc] initWithR:r.intValue G:g.intValue B:b.intValue A:a.intValue]];
//            }
//        }
//
//        if ([geoStyleDic objectForKey:@"lineSymbolID"]) {
//            NSNumber* lineSymbolID = [geoStyleDic objectForKey:@"lineSymbolID"];
//            [geoStyle setLineSymbolID:lineSymbolID.intValue];
//        }
//        if ([geoStyleDic objectForKey:@"markerSymbolID"]) {
//            NSNumber* markerSymbolID = [geoStyleDic objectForKey:@"markerSymbolID"];
//            [geoStyle setLineSymbolID:markerSymbolID.intValue];
//        }
//        if ([geoStyleDic objectForKey:@"markerSize"]) {
//            NSDictionary* markerSize = [geoStyleDic objectForKey:@"markerSize"];
//            NSNumber* w = [markerSize objectForKey:@"w"];
//            NSNumber* h = [markerSize objectForKey:@"h"];
//
//            Size2D* size2D = [[Size2D alloc] initWithWidth:w.doubleValue Height:h.doubleValue];
//            [geoStyle setMarkerSize:size2D];
//        }
//
//        if ([geoStyleDic objectForKey:@"fillOpaqueRate"]) {
//            NSNumber* fillOpaqueRate = [geoStyleDic objectForKey:@"fillOpaqueRate"];
//            [geoStyle setFillOpaqueRate:fillOpaqueRate.intValue];
//        }
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

+ (TransportationAnalystParameter *)getTransportationAnalystParameterByDictionary:(NSDictionary *)params {
    TransportationAnalystParameter* parameter = [[TransportationAnalystParameter alloc] init];
    if (params) {
        if ([params objectForKey:@"barrierEdges"] != nil) {
            parameter.barrierEdges = [params objectForKey:@"barrierEdges"];
        }
        if ([params objectForKey:@"barrierNodes"] != nil) {
            parameter.barrierNodes = [params objectForKey:@"barrierNodes"];
        }
        if ([params objectForKey:@"barrierPoints"] != nil) {
            NSArray* points =  [params objectForKey:@"barrierPoints"];
            Point2Ds* barrierPoints = [[Point2Ds alloc] init];
            for (int i = 0; i < points.count; i++) {
                double x = [(NSNumber *) [points[i] objectForKey:@"x"] doubleValue];
                double y = [(NSNumber *) [points[i] objectForKey:@"y"] doubleValue];
                
                [barrierPoints add:[[Point2D alloc] initWithX:x Y:y]];
            }
            parameter.barrierPoints = barrierPoints;
        }
        if ([params objectForKey:@"isEdgesReturn"] != nil) {
            parameter.isEdgesReturn = [(NSNumber *)[params objectForKey:@"isEdgesReturn"] boolValue];
        } else {
            parameter.isEdgesReturn = YES;
        }
        if ([params objectForKey:@"nodes"] != nil) {
            parameter.nodes = [params objectForKey:@"nodes"];
        }
        if ([params objectForKey:@"isNodesReturn"] != nil) {
            parameter.isNodesReturn = [(NSNumber *)[params objectForKey:@"isNodesReturn"] boolValue];
        } else {
            parameter.isNodesReturn = YES;
        }
        if ([params objectForKey:@"isPathGuidesReturn"] != nil) {
            parameter.isPathGuidesReturn = [(NSNumber *)[params objectForKey:@"isPathGuidesReturn"] boolValue];
        } else {
            parameter.isPathGuidesReturn = YES;
        }
        if ([params objectForKey:@"points"] != nil) {
            NSArray* points =  [params objectForKey:@"points"];
            Point2Ds* ps = [[Point2Ds alloc] init];
            for (int i = 0; i < points.count; i++) {
                double x = [(NSNumber *) [points[i] objectForKey:@"x"] doubleValue];
                double y = [(NSNumber *) [points[i] objectForKey:@"y"] doubleValue];
                
                [ps add:[[Point2D alloc] initWithX:x Y:y]];
            }
            parameter.points = ps;
        }
        if ([params objectForKey:@"isRoutesReturn"] != nil) {
            parameter.isRoutesReturn = [(NSNumber *)[params objectForKey:@"isRoutesReturn"] boolValue];
        } else {
            parameter.isRoutesReturn = YES;
        }
        if ([params objectForKey:@"isStopsReturn"] != nil) {
            parameter.isStopsReturn = [(NSNumber *)[params objectForKey:@"isStopsReturn"] boolValue];
        }
        if ([params objectForKey:@"turnWeightField"] != nil) {
            parameter.turnWeightField = [params objectForKey:@"turnWeightField"];
        }
        if ([params objectForKey:@"weightName"] != nil) {
            parameter.weightName = [params objectForKey:@"weightName"];
        }
    }
    return parameter;
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
        @try {
            resultDataset = [SMAnalyst createDatasetByDictionary:resultData];
        } @catch (NSException *exception) {
            @throw exception;
        }
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

+ (int)selectPoint:(NSDictionary *)point layer:(Layer *)layer geoStyle:(GeoStyle *)geoStyle {
    int ID = -1;
    double x = [(NSNumber *)[point objectForKey:@"x"] doubleValue];
    double y = [(NSNumber *)[point objectForKey:@"y"] doubleValue];
    CGPoint p = CGPointMake(x, y);
    Selection* hitSelection = [layer hitTestEx:p With:20];
    
    if (hitSelection && hitSelection.getCount > 0) {
        Recordset* rs = hitSelection.toRecordset;
        GeoPoint* gPoint = (GeoPoint *)rs.geometry;
        ID = [(NSNumber *)[rs getFieldValueWithString:@"SMNODEID"] intValue];
        
        GeoStyle* style = geoStyle;
        if (!style) {
            style = [[GeoStyle alloc] init];
            [style setMarkerSymbolID:3614];
        }
        [gPoint setStyle:style];
        
        TrackingLayer* trackingLayer = [SMap singletonInstance].smMapWC.mapControl.map.trackingLayer;
        [trackingLayer addGeometry:gPoint WithTag:@""];
        [[SMap singletonInstance].smMapWC.mapControl.map refresh];
        
        [gPoint dispose];
        [rs close];
        [rs dispose];
    }
    return ID;
}

+ (FacilityAnalystSetting *)setFacilitySetting:(NSDictionary *)data {
    FacilityAnalystSetting* setting = [[FacilityAnalystSetting alloc] init];
    //    if ([data objectForKey:@"networkDataset"]) {
    //        Layer* layer = [SMLayer findLayerByDatasetName:[data objectForKey:@"networkDataset"]];
    //        setting.netWorkDataset = (DatasetVector *)layer.dataset;
    //    } else if ([data objectForKey:@"networkLayer"]) {
    //        Layer* layer = [SMLayer findLayerWithName:[data objectForKey:@"networkLayer"]];
    //        setting.netWorkDataset = (DatasetVector *)layer.dataset;
    //    } else {
    //        return nil;
    //    }
    
    if ([data objectForKey:@"weightFieldInfos"]) {
        NSArray* infos = [data objectForKey:@"weightFieldInfos"];
        WeightFieldInfos* weightFieldInfos = [[WeightFieldInfos alloc] init];
        for (int i = 0; i < [infos count]; i++) {
            WeightFieldInfo* info = [SMAnalyst setWeightFieldInfo:infos[i]];
            [weightFieldInfos add:info];
        }
        setting.weightFieldInfos = weightFieldInfos;
    }
    
    if ([data objectForKey:@"barrierEdges"]) setting.barrierEdges = [data objectForKey:@"barrierEdges"];
    if ([data objectForKey:@"barrierNodes"]) setting.barrierNodes = [data objectForKey:@"barrierNodes"];
    if ([data objectForKey:@"directionField"]) setting.directionField = [data objectForKey:@"directionField"];
    if ([data objectForKey:@"edgeIDField"]) setting.edgeIDField = [data objectForKey:@"edgeIDField"];
    if ([data objectForKey:@"fNodeIDField"]) setting.fNodeIDField = [data objectForKey:@"fNodeIDField"];
    if ([data objectForKey:@"nodeIDField"]) setting.nodeIDField = [data objectForKey:@"nodeIDField"];
    if ([data objectForKey:@"tNodeIDField"]) setting.tNodeIDField = [data objectForKey:@"tNodeIDField"];
    if ([data objectForKey:@"tolerance"] != nil) setting.tolerance = [(NSNumber *)[data objectForKey:@"tolerance"] integerValue];
    
    return setting;
}

+ (TransportationAnalystSetting *)setTransportSetting:(NSDictionary *)data {
    TransportationAnalystSetting* setting = [[TransportationAnalystSetting alloc] init];
    if ([data objectForKey:@"weightFieldInfos"]) {
        NSArray* infos = [data objectForKey:@"weightFieldInfos"];
        WeightFieldInfos* weightFieldInfos = [[WeightFieldInfos alloc] init];
        for (int i = 0; i < [infos count]; i++) {
            WeightFieldInfo* info = [SMAnalyst setWeightFieldInfo:infos[i]];
            [weightFieldInfos add:info];
        }
        setting.weightFieldInfos = weightFieldInfos;
    }
    
    if ([data objectForKey:@"barrierEdges"]) setting.barrierEdges = [data objectForKey:@"barrierEdges"];
    if ([data objectForKey:@"barrierNodes"]) setting.barrierNodes = [data objectForKey:@"barrierNodes"];
    if ([data objectForKey:@"edgeFilter"]) setting.edgeFilter = [data objectForKey:@"edgeFilter"];
    if ([data objectForKey:@"edgeIDField"]) setting.edgeIDField = [data objectForKey:@"edgeIDField"];
    if ([data objectForKey:@"edgeNameField"]) setting.edgeNameField = [data objectForKey:@"edgeNameField"];
    if ([data objectForKey:@"fTSingleWayRuleValues"]) setting.fTSingleWayRuleValues = [data objectForKey:@"fTSingleWayRuleValues"];
    if ([data objectForKey:@"fNodeIDField"]) setting.fNodeIDField = [data objectForKey:@"fNodeIDField"];
    if ([data objectForKey:@"nodeIDField"]) setting.nodeIDField = [data objectForKey:@"nodeIDField"];
    if ([data objectForKey:@"nodeNameField"]) setting.nodeNameField = [data objectForKey:@"nodeNameField"];
    if ([data objectForKey:@"prohibitedWayRuleValues"]) setting.prohibitedWayRuleValues = [data objectForKey:@"prohibitedWayRuleValues"];
    if ([data objectForKey:@"ruleField"]) setting.ruleField = [data objectForKey:@"ruleField"];
    if ([data objectForKey:@"tFSingleWayRuleValues"]) setting.tFSingleWayRuleValues = [data objectForKey:@"tFSingleWayRuleValues"];
    if ([data objectForKey:@"tNodeIDField"]) setting.tNodeIDField = [data objectForKey:@"tNodeIDField"];
    if ([data objectForKey:@"tolerance"] != nil) setting.tolerance = [(NSNumber *)[data objectForKey:@"tolerance"] integerValue];
//    if ([data objectForKey:@"turnDataset"]) setting.turnDataset = [data objectForKey:@"turnDataset"];
    if ([data objectForKey:@"turnFEdgeIDField"]) setting.turnFEdgeIDField = [data objectForKey:@"turnFEdgeIDField"];
    if ([data objectForKey:@"turnNodeIDField"]) setting.turnNodeIDField = [data objectForKey:@"turnNodeIDField"];
    if ([data objectForKey:@"turnTEdgeIDField"]) setting.turnTEdgeIDField = [data objectForKey:@"turnTEdgeIDField"];
    if ([data objectForKey:@"turnWeightFields"]) setting.turnWeightFields = [data objectForKey:@"turnWeightFields"];
    if ([data objectForKey:@"twoWayRuleValues"]) setting.twoWayRuleValues = [data objectForKey:@"twoWayRuleValues"];
    
    return setting;
}

+ (WeightFieldInfo *)setWeightFieldInfo:(NSDictionary *)data {
    WeightFieldInfo* info = [[WeightFieldInfo alloc] init];
    if ([data objectForKey:@"name"]) info.name = [data objectForKey:@"name"];
    if ([data objectForKey:@"ftWeightField"]) info.ftWeightField = [data objectForKey:@"ftWeightField"];
    if ([data objectForKey:@"tfWeightField"]) info.tfWeightField = [data objectForKey:@"tfWeightField"];
    
    return info;
}
@end

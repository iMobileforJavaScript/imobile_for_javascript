//
//  SAnalyst.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/30.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "SAnalyst.h"
#import "SMap.h"
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
#import "SuperMap/Layers.h"

@implementation SAnalyst
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(analystBuffer, analystBufferByLayerName:(NSString*)layerName params:(NSDictionary*)params  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Map* map = [SMap singletonInstance].smWorkspace.mapControl.map;
        Layer* layer = [map.layers getLayerWithName:layerName];
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

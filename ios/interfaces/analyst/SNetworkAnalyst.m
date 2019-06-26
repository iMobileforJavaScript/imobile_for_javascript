//
//  SNetworkAnalyst.m
//  Supermap
//
//  Created by Shanglong Yang on 2019/6/24.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "SNetworkAnalyst.h"

@implementation SNetworkAnalyst
RCT_EXPORT_MODULE();

- (GeoStyle *)getGeoStyle:(Size2D *)size2D color:(Color *)color {
    GeoStyle* style = [[GeoStyle alloc] init];
    [style setMarkerSize:size2D];
    [style setLineColor:color];
    [style setLineWidth:1];
    return style;
}

- (void)displayResult:(NSArray *)ids {
    if (selection) {
        TrackingLayer* trackingLayer = [SMap singletonInstance].smMapWC.mapControl.map.trackingLayer;
        for (int i = 0; i < ids.count; i++) {
            [selection add:[(NSNumber *)ids[i] intValue]];
        }
        Recordset* recordset = [selection toRecordset];
        [recordset moveFirst];
        while (![recordset isEOF]) {
            Geometry* geometry = recordset.geometry;
            GeoStyle* style = [self getGeoStyle:[[Size2D alloc] initWithWidth:10 Height:10] color:[[Color alloc] initWithR:255 G:105 B:0]];
            [geometry setStyle:style];
            [trackingLayer addGeometry:geometry WithTag:@""];
            [recordset moveNext];
        }
        [[SMap singletonInstance].smMapWC.mapControl.map refresh];
    }
}

RCT_REMAP_METHOD(clear, clearWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if (selection) {
            [selection clear];
        }
        [[SMap singletonInstance].smMapWC.mapControl.map.trackingLayer clear];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}
@end

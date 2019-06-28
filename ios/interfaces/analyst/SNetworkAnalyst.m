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

- (void)displayResult:(NSArray *)ids selection:(Selection *)selection {
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

- (void)clear:(Selection *)selection {
    if (selection) {
        [selection clear];
    }
    [[SMap singletonInstance].smMapWC.mapControl.map.trackingLayer clear];
}

- (int)selectPoint:(NSDictionary *)point layer:(Layer *)nodeLayer geoStyle:(GeoStyle *)geoStyle tag:(NSString *)tag {
    int ID = -1;
//    if (!elementIDs) {
//        elementIDs = [[NSMutableArray alloc] init];
//    }
    double x = [(NSNumber *)[point objectForKey:@"x"] doubleValue];
    double y = [(NSNumber *)[point objectForKey:@"y"] doubleValue];
    CGPoint p = CGPointMake(x, y);
    Selection* hitSelection = [nodeLayer hitTestEx:p With:20];
    
    if (hitSelection && hitSelection.getCount > 0) {
        Recordset* rs = hitSelection.toRecordset;
        GeoPoint* gPoint = (GeoPoint *)rs.geometry;
        ID = (int)rs.ID;
//        [elementIDs addObject:@(ID)];
        
        GeoStyle* style = geoStyle;
        if (!style) {
            style = [[GeoStyle alloc] init];
            [style setMarkerSize:[[Size2D alloc] initWithWidth:10 Height:10]];
            [style setLineColor:[[Color alloc] initWithR:255 G:105 B:0]];
            [style setMarkerSymbolID:3614];
        }
        [gPoint setStyle:style];
        
        TrackingLayer* trackingLayer = [SMap singletonInstance].smMapWC.mapControl.map.trackingLayer;
        [trackingLayer addGeometry:gPoint WithTag:tag];
        [[SMap singletonInstance].smMapWC.mapControl.map refresh];
        
        [gPoint dispose];
        [rs close];
        [rs dispose];
    }
    return ID;
}

- (Point2D *)selectByPoint:(NSDictionary *)point layer:(Layer *)nodeLayer geoStyle:(GeoStyle *)geoStyle tag:(NSString *)tag {
    Point2D* point2D = nil;
    //    if (!elementIDs) {
    //        elementIDs = [[NSMutableArray alloc] init];
    //    }
    double x = [(NSNumber *)[point objectForKey:@"x"] doubleValue];
    double y = [(NSNumber *)[point objectForKey:@"y"] doubleValue];
    CGPoint p = CGPointMake(x, y);
    Selection* hitSelection = [nodeLayer hitTestEx:p With:20];
    
    if (hitSelection && hitSelection.getCount > 0) {
        Recordset* rs = hitSelection.toRecordset;
        GeoPoint* gPoint = (GeoPoint *)rs.geometry;
        point2D = gPoint.getInnerPoint;
        //        [elementIDs addObject:@(ID)];
        
        GeoStyle* style = geoStyle;
        if (!style) {
            style = [[GeoStyle alloc] init];
            [style setMarkerSize:[[Size2D alloc] initWithWidth:10 Height:10]];
            [style setLineColor:[[Color alloc] initWithR:255 G:105 B:0]];
            [style setMarkerSymbolID:3614];
        }
        [gPoint setStyle:style];
        
        TrackingLayer* trackingLayer = [SMap singletonInstance].smMapWC.mapControl.map.trackingLayer;
        [trackingLayer addGeometry:gPoint WithTag:tag];
        [[SMap singletonInstance].smMapWC.mapControl.map refresh];
        
        [gPoint dispose];
        [rs close];
        [rs dispose];
    }
    return point2D;
}

- (void)removeTagFromTrackingLayer:(NSString *)tag {
    TrackingLayer* trackingLayer = [SMap singletonInstance].smMapWC.mapControl.map.trackingLayer;
    for (int i = 0; i < trackingLayer.count; i++) {
        NSString* currentTag = [trackingLayer getTagAt:i];
        if ([currentTag isEqualToString:tag]) {
            [trackingLayer removeAt:i];
            break;
        }
    }
}
@end

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

- (int)selectNode:(NSDictionary *)point layer:(Layer *)nodeLayer geoStyle:(GeoStyle *)geoStyle tag:(NSString *)tag {
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

- (Point2D *)selectPoint:(NSDictionary *)point layer:(Layer *)nodeLayer geoStyle:(GeoStyle *)geoStyle tag:(NSString *)tag {
//    int ID = -1;
    //    if (!elementIDs) {
    //        elementIDs = [[NSMutableArray alloc] init];
    //    }
    double x = [(NSNumber *)[point objectForKey:@"x"] doubleValue];
    double y = [(NSNumber *)[point objectForKey:@"y"] doubleValue];
    CGPoint p = CGPointMake(x, y);
    Selection* hitSelection = [nodeLayer hitTestEx:p With:20];
    
//    if (!hitSelection || hitSelection.getCount == 0) {
//        Point2D* pt = [[SMap singletonInstance].smMapWC.mapControl.map pixelTomap:p];
//        SMap* sMap = [SMap singletonInstance];
//        if ([sMap.smMapWC.mapControl.map.prjCoordSys type] != PCST_EARTH_LONGITUDE_LATITUDE) {//若投影坐标不是经纬度坐标则进行转换
//            Point2Ds *points = [[Point2Ds alloc] init];
//            [points add:pt];
//            PrjCoordSys *srcPrjCoorSys = [[PrjCoordSys alloc]init];
//            [srcPrjCoorSys setType:PCST_EARTH_LONGITUDE_LATITUDE];
//            CoordSysTransParameter *param = [[CoordSysTransParameter alloc]init];
//
//            //根据源投影坐标系与目标投影坐标系对坐标点串进行投影转换，结果将直接改变源坐标点串
//            [CoordSysTranslator convert:points PrjCoordSys:[sMap.smMapWC.mapControl.map prjCoordSys] PrjCoordSys:srcPrjCoorSys CoordSysTransParameter:param CoordSysTransMethod:MTH_GEOCENTRIC_TRANSLATION];
//            pt = [points getItem:0];
//        }
//        hitSelection = [nodeLayer hitTest:pt With:20];
//    }
    
    NSMutableDictionary* pDic = nil;
    Point2D* p2D = nil;
    
    if (hitSelection && hitSelection.getCount > 0) {
        pDic = [[NSMutableDictionary alloc] init];
        Recordset* rs = hitSelection.toRecordset;
        GeoPoint* gPoint = (GeoPoint *)rs.geometry;
//        ID = (int)rs.ID;
        //        [elementIDs addObject:@(ID)];
        
        p2D = [[Point2D alloc] initWithX:gPoint.getX Y:gPoint.getY];
//        CGPoint cgp = [SMap.singletonInstance.smMapWC.mapControl.map mapToPixel:[[Point2D alloc] initWithX:gPoint.getX Y:gPoint.getY]];
//        [pDic setObject:@(cgp.x) forKey:@"x"];
//        [pDic setObject:@(cgp.y) forKey:@"y"];
        
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
    return p2D;
}

- (int)setText:(NSString *)text point:(Point2D *)point textStyle:(TextStyle *)textStyle tag:(NSString *)tag {
    NSString* mText = [NSString stringWithFormat:@" %@", text];
    TextPart* textPart = [[TextPart alloc] initWithTextString:mText anchorPoint:point];
    GeoText* geoText = [[GeoText alloc] initWithTextPart:textPart];
    if (textStyle == nil) {
        textStyle = [[TextStyle alloc]init];
        [textStyle setFontWidth:6];
        [textStyle setFontHeight:8];
        [textStyle setForeColor:[[Color alloc]initWithR:0 G:0 B:0]];
    }
    [geoText setTextStyle:textStyle];
    
    TrackingLayer* trackingLayer = [SMap singletonInstance].smMapWC.mapControl.map.trackingLayer;
    int index = [trackingLayer addGeometry:geoText WithTag:tag];
    [[SMap singletonInstance].smMapWC.mapControl.map refresh];
    return index;
}

//- (Point2D *)selectByPoint:(NSDictionary *)point layer:(Layer *)nodeLayer geoStyle:(GeoStyle *)geoStyle tag:(NSString *)tag {
//    Point2D* point2D = nil;
//    //    if (!elementIDs) {
//    //        elementIDs = [[NSMutableArray alloc] init];
//    //    }
//    double x = [(NSNumber *)[point objectForKey:@"x"] doubleValue];
//    double y = [(NSNumber *)[point objectForKey:@"y"] doubleValue];
//    CGPoint p = CGPointMake(x, y);
//    Selection* hitSelection = [nodeLayer hitTestEx:p With:20];
//    
//    if (hitSelection && hitSelection.getCount > 0) {
//        Recordset* rs = hitSelection.toRecordset;
//        GeoPoint* gPoint = (GeoPoint *)rs.geometry;
//        point2D = gPoint.getInnerPoint;
//        //        [elementIDs addObject:@(ID)];
//        
//        GeoStyle* style = geoStyle;
//        if (!style) {
//            style = [[GeoStyle alloc] init];
//            [style setMarkerSize:[[Size2D alloc] initWithWidth:10 Height:10]];
//            [style setLineColor:[[Color alloc] initWithR:255 G:105 B:0]];
//            [style setMarkerSymbolID:3614];
//        }
//        [gPoint setStyle:style];
//        
//        TrackingLayer* trackingLayer = [SMap singletonInstance].smMapWC.mapControl.map.trackingLayer;
//        [trackingLayer addGeometry:gPoint WithTag:tag];
//        [[SMap singletonInstance].smMapWC.mapControl.map refresh];
//        
//        [gPoint dispose];
//        [rs close];
//        [rs dispose];
//    }
//    return point2D;
//}

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

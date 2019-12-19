//
//  SNetworkAnalyst.m
//  Supermap
//
//  Created by Shanglong Yang on 2019/6/24.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "SNetworkAnalyst.h"

@implementation History : NSObject

-(id)init {
    self = [super init];
    _history = [[NSMutableArray alloc] init];
    return self;
}
-(int)getCount {
    return _history.count;
}
-(NSArray *)getHistory {
    return [_history subarrayWithRange:NSMakeRange(0, _currentIndex)];
}
-(NSDictionary *)get:(int)index {
    return _history[index];
}
-(void)addHistory:(NSDictionary *)obj {
    if (_currentIndex < (NSInteger)_history.count - 1) {
        NSArray* temp = [_history subarrayWithRange:NSMakeRange(0, _currentIndex + 1)];
        _history = [[NSMutableArray alloc] initWithArray:temp];
    }
    [_history addObject:obj];
    _currentIndex = (NSInteger)_history.count - 1;
}
-(void)removeObjectAtIndex:(int)index {
    [_history removeObjectAtIndex:index];
    _currentIndex--;
}
-(void)removeObject:(NSObject *)obj {
    [_history removeObject:obj];
    _currentIndex--;
}
-(void)clear {
    [_history removeAllObjects];
    _currentIndex = -1;
}
-(int)undo {
    int preIndex = _currentIndex >= 0 ? _currentIndex : -1;
    if (_currentIndex > -1) {
        _currentIndex--;
    }
    return preIndex;
}
-(int)redo {
    int historyCount = (NSInteger)_history.count;
    int preIndex = _currentIndex < historyCount - 1 ? _currentIndex : (historyCount - 1);
    if (_currentIndex < historyCount - 1) {
        _currentIndex++;
    }
    return preIndex;
}
@end

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
        [recordset dispose];
        [[SMap singletonInstance].smMapWC.mapControl.map refresh];
    }
}

- (void)clear {
    if (selection) {
        [selection clear];
    }
    [[SMap singletonInstance].smMapWC.mapControl.map.trackingLayer clear];
}

- (void)clearRoutes:(Selection *)selection {
    if (selection) {
        [selection clear];
    }
    TrackingLayer* trackingLayer = [SMap singletonInstance].smMapWC.mapControl.map.trackingLayer;
    int routeIndex = [trackingLayer indexof:@"route"];
    while (routeIndex >= 0) {
        [trackingLayer removeAt:routeIndex];
        routeIndex = [trackingLayer indexof:@"route"];
    }
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
        Point2D* p2D = [[Point2D alloc] initWithX:gPoint.getX Y:gPoint.getY];
        ID = (int)rs.ID;
//        [elementIDs addObject:@(ID)];

        BOOL isExsit = [self pointIsExist:p2D];
        if (isExsit) return -1;
        
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
        
//        NSMutableDictionary* nodeData = [[NSMutableDictionary alloc] init];
//        [nodeData setObject:tag forKey:@"tag"];
//        [nodeData setObject:point forKey:@"node"];
//        if (history == nil) {
//            history = [[History alloc] init];
//        }
//        [history addHistory:nodeData];
        
        [gPoint dispose];
        [rs close];
        [rs dispose];
    }
    return ID;
}

- (NSDictionary *)selectNodeWithPoint:(NSDictionary *)point layer:(Layer *)nodeLayer geoStyle:(GeoStyle *)geoStyle tag:(NSString *)tag {
    int ID = -1;
    Point2D* p2D = nil;
    double x = [(NSNumber *)[point objectForKey:@"x"] doubleValue];
    double y = [(NSNumber *)[point objectForKey:@"y"] doubleValue];
    CGPoint p = CGPointMake(x, y);
    Selection* hitSelection = [nodeLayer hitTestEx:p With:20];
    
    if (hitSelection && hitSelection.getCount > 0) {
        Recordset* rs = hitSelection.toRecordset;
        GeoPoint* gPoint = (GeoPoint *)rs.geometry;
        ID = (int)rs.ID;
        p2D = [[Point2D alloc] initWithX:gPoint.getX Y:gPoint.getY];
        
        BOOL isExsit = [self pointIsExist:p2D];
        if (isExsit) return nil;
        
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
        
//        NSMutableDictionary* nodeData = [[NSMutableDictionary alloc] init];
//        [nodeData setObject:tag forKey:@"tag"];
//        [nodeData setObject:point forKey:@"node"];
//        if (history == nil) {
//            history = [[History alloc] init];
//        }
//        [history addHistory:nodeData];
        
        [gPoint dispose];
        [rs close];
        [rs dispose];
    }
    return @{
        @"ID": @(ID),
        @"point": p2D,
    };
}

- (Point2D *)selectPoint:(NSDictionary *)point layer:(Layer *)nodeLayer geoStyle:(GeoStyle *)geoStyle tag:(NSString *)tag {
//    int ID = -1;
    double x = [(NSNumber *)[point objectForKey:@"x"] doubleValue];
    double y = [(NSNumber *)[point objectForKey:@"y"] doubleValue];
    CGPoint p = CGPointMake(x, y);
    Selection* hitSelection = [nodeLayer hitTestEx:p With:20];
    NSMutableDictionary* pDic = nil;
    Point2D* p2D = nil;
    
    if (hitSelection && hitSelection.getCount > 0) {
        pDic = [[NSMutableDictionary alloc] init];
        Recordset* rs = hitSelection.toRecordset;
        GeoPoint* gPoint = (GeoPoint *)rs.geometry;
        
        p2D = [[Point2D alloc] initWithX:gPoint.getX Y:gPoint.getY];
        
        BOOL isExsit = [self pointIsExist:p2D];
        if (isExsit) return nil;

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
        [textStyle setOutline:YES];
        [textStyle setFontWidth:6];
        [textStyle setFontHeight:8];
        [textStyle setForeColor:[[Color alloc]initWithR:0 G:0 B:0]];
    }
    [textStyle setOutline:YES];
    [textStyle setBackColor:[[Color alloc] initWithR:255 G:255 B:255]];
    [textStyle setBold:YES];
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

- (BOOL)pointIsExist:(Point2D *)point {
    if (!points) points = [[Point2Ds alloc] init];
    if (!barrierPoints) barrierPoints = [[Point2Ds alloc] init];
    for (int i = 0; i < barrierPoints.getCount; i++) {
        Point2D* pt = [barrierPoints getItem:i];
        if (pt.x == point.x && pt.y == point.y) {
            return YES;
        }
    }
    for (int i = 0; i < points.getCount; i++) {
        Point2D* pt = [points getItem:i];
        if (pt.x == point.x && pt.y == point.y) {
            return YES;
        }
    }
    if (startPoint && startPoint.x == point.x && startPoint.y == point.y) {
        return YES;
    }
    if (endPoint && endPoint.x == point.x && endPoint.y == point.y) {
        return YES;
    }
    return NO;
}
@end

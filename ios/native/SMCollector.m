//
//  SMCollector.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/30.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "SMCollector.h"
#import "SCollectorType.h"
#import "SuperMap/CollectorElement.h"
#import "SuperMap/Action.h"
#import "SuperMap/MapControl.h"
#import "SuperMap/SnapSetting.h"

@implementation SMCollector
static SnapSetting *snapSeting = nil;
+ (BOOL)setCollector:(Collector *)collector mapControl:(MapControl *)mapControl type:(int)type {
    BOOL result = NO;
    switch (type) {
        case POINT_GPS: // POINT_GPS
            result = [collector createElement:COL_POINT];
            [collector setIsSingleTapEnable:NO];
            break;
        case POINT_HAND: // POINT_HAND
//            result = [collector createElement:COL_POINT];
//            [collector setIsSingleTapEnable:YES];
            [mapControl setAction:CREATEPOINT];
            result = YES;
            break;
        case LINE_GPS_POINT: // LINE_GPS_POINT
            result = [collector createElement:COL_LINE];
            [collector setIsSingleTapEnable:NO];
            break;
        case LINE_GPS_PATH: // LINE_GPS_PATH
            result = [collector createElement:COL_LINE];
            [collector setIsSingleTapEnable:NO];
            break;
        case LINE_HAND_POINT: // LINE_HAND_POINT
//            result = [collector createElement:COL_LINE];
//            [collector setIsSingleTapEnable:YES];
            [mapControl setAction:CREATEPOLYLINE];
            result = YES;
            break;
        case LINE_HAND_PATH: // LINE_HAND_PATH
            [mapControl setAction:CREATE_FREE_DRAW];
            result = YES;
            break;
        case REGION_GPS_POINT: // REGION_GPS_POINT
            result = [collector createElement:COL_POLYGON];
            [collector setIsSingleTapEnable:NO];
            break;
        case REGION_GPS_PATH: // REGION_GPS_PATH
            result = [collector createElement:COL_POLYGON];
            [collector setIsSingleTapEnable:NO];
            break;
        case REGION_HAND_POINT: // REGION_HAND_POINT
//            result = [collector createElement:COL_POLYGON];
//            [collector setIsSingleTapEnable:YES];
            [mapControl setAction:CREATEPOLYGON];
            result = YES;
            break;
        case REGION_HAND_PATH: // REGION_HAND_PATH
            [mapControl setAction:CREATE_FREE_DRAWPOLYGON];
            result = YES;
            break;
        default:
            result = NO;
            break;
    }
    if(!snapSeting){
        snapSeting = [[SnapSetting alloc] init];
//    [snapSeting setMode:POINT_ON_ENDPOINT bValue:YES];
//    [snapSeting setMode:POINT_ON_POINT bValue:YES];
        [snapSeting openAll ];
        [mapControl setSnapSetting:snapSeting];
    }
    return result;
}

+ (BOOL)stopCollector:(Collector *)collector mapControl:(MapControl *)mapControl type:(int)type {
    BOOL result = NO;
    switch (type) {
        case POINT_GPS: // POINT_GPS
        case POINT_HAND: // POINT_HAND
        case LINE_GPS_POINT: // LINE_GPS_POINT
        case LINE_GPS_PATH: // LINE_GPS_PATH
        case LINE_HAND_POINT: // LINE_HAND_POINT
        case REGION_GPS_POINT: // REGION_GPS_POINT
        case REGION_GPS_PATH: // REGION_GPS_PATH
        case REGION_HAND_POINT: // REGION_HAND_POINT
            [collector setIsSingleTapEnable:NO];
            result = YES;
            break;
        case LINE_HAND_PATH: // LINE_HAND_PATH
        case REGION_HAND_PATH: // REGION_HAND_PATH
            [mapControl setAction:PAN];
            result = YES;
            break;
        default:
            result = NO;
            break;
    }
    return result;
}
+ (void)openGPS:(Collector *)collector {
    [collector openGPS];
}

+ (void)closeGPS:(Collector *)collector {
    [collector closeGPS];
}


@end

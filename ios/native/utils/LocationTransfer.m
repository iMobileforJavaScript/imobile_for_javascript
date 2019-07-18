//
//  LocationTransfer.m
//  Supermap
//
//  Created by Shanglong Yang on 2019/7/18.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "LocationTransfer.h"

@implementation LocationTransfer
+ (Point2D *)mapCoordToLatitudeAndLongitudeByPoint:(Point2D *)point2D {
    Point2Ds *points = [[Point2Ds alloc]init];
    [points add:point2D];
    PrjCoordSys *srcPrjCoorSys = [[PrjCoordSys alloc]init];
    [srcPrjCoorSys setType:PCST_EARTH_LONGITUDE_LATITUDE];
    CoordSysTransParameter *param = [[CoordSysTransParameter alloc]init];
    
    [CoordSysTranslator convert:points PrjCoordSys:[[SMap singletonInstance].smMapWC.mapControl.map prjCoordSys] PrjCoordSys:srcPrjCoorSys CoordSysTransParameter:param CoordSysTransMethod:(CoordSysTransMethod)9603];
    point2D = [points getItem:0];
    
    return point2D;
}

+ (Point2Ds *)mapCoordToLatitudeAndLongitudeByPoints:(Point2Ds *)point2Ds {
    PrjCoordSys *srcPrjCoorSys = [[PrjCoordSys alloc]init];
    [srcPrjCoorSys setType:PCST_EARTH_LONGITUDE_LATITUDE];
    CoordSysTransParameter *param = [[CoordSysTransParameter alloc]init];
    
    [CoordSysTranslator convert:point2Ds PrjCoordSys:[[SMap singletonInstance].smMapWC.mapControl.map prjCoordSys] PrjCoordSys:srcPrjCoorSys CoordSysTransParameter:param CoordSysTransMethod:(CoordSysTransMethod)9603];
    
    return point2Ds;
}

+ (Point2D *)latitudeAndLongitudeToMapCoordByPoint:(Point2D *)point2D {
    Point2Ds *points = [[Point2Ds alloc]init];
    [points add:point2D];
    PrjCoordSys *srcPrjCoorSys = [[PrjCoordSys alloc]init];
    [srcPrjCoorSys setType:PCST_EARTH_LONGITUDE_LATITUDE];
    CoordSysTransParameter *param = [[CoordSysTransParameter alloc]init];
    
    [CoordSysTranslator convert:points PrjCoordSys:srcPrjCoorSys PrjCoordSys:[[SMap singletonInstance].smMapWC.mapControl.map prjCoordSys] CoordSysTransParameter:param CoordSysTransMethod:(CoordSysTransMethod)9603];
    point2D = [points getItem:0];

    return point2D;
}

+ (Point2Ds *)latitudeAndLongitudeToMapCoordByPoints:(Point2Ds *)point2Ds {
    PrjCoordSys *srcPrjCoorSys = [[PrjCoordSys alloc]init];
    [srcPrjCoorSys setType:PCST_EARTH_LONGITUDE_LATITUDE];
    CoordSysTransParameter *param = [[CoordSysTransParameter alloc]init];
    
    [CoordSysTranslator convert:point2Ds PrjCoordSys:srcPrjCoorSys PrjCoordSys:[[SMap singletonInstance].smMapWC.mapControl.map prjCoordSys] CoordSysTransParameter:param CoordSysTransMethod:(CoordSysTransMethod)9603];
    
    return point2Ds;
}
@end

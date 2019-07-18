//
//  LocationTransfer.h
//  Supermap
//
//  Created by Shanglong Yang on 2019/7/18.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperMap/Point2D.h"
#import "SuperMap/Datasource.h"
#import "SuperMap/Dataset.h"
#import "SuperMap/Datasets.h"
#import "SuperMap/DatasetVector.h"
#import "SuperMap/FieldInfo.h"
#import "SuperMap/FieldInfos.h"
#import "SuperMap/DatasetVectorInfo.h"
#import "SuperMap/PrjCoordSys.h"
#import "SuperMap/GeoPoint.h"
#import "SuperMap/GeoPoint.h"
#import "SuperMap/Recordset.h"
#import "SuperMap/GeoStyle.h"
#import "SuperMap/Size2D.h"
#import "SMap.h"

@interface LocationTransfer : NSObject

+ (Point2D *)mapCoordToLatitudeAndLongitudeByPoint:(Point2D *)point2D;
+ (Point2Ds *)mapCoordToLatitudeAndLongitudeByPoints:(Point2Ds *)point2Ds;
+ (Point2D *)latitudeAndLongitudeToMapCoordByPoint:(Point2D *)point2D;
+ (Point2Ds *)latitudeAndLongitudeToMapCoordByPoints:(Point2Ds *)point2Ds;

@end

//
//  GeoPlacemark.h
//  LibUGC
//
//  Created by LK on 15/11/9.
//  Copyright © 2015年 beijingchaotu. All rights reserved.
//

#import "Geometry3D.h"

@class Geometry, TextStyle;


@interface GeoPlacemark : Geometry3D
{
    Geometry *_geometry;
    TextStyle *_nameStyle;
    BOOL _isGeometryChanged;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) Geometry *geometry;
@property (nonatomic, strong) TextStyle *nameStyle;
@property (nonatomic, assign) BOOL isGeometryChanged;

/* 初始化 */
- (instancetype)initWithGeoPlacemark:(GeoPlacemark *)geoPlacemark;
- (instancetype)initWithName:(NSString *)name andGeomentry:(Geometry *)geometry;

/* clone */
- (Geometry *)clone;

@end

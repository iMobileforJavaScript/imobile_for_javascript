//
//  GeoCircle.h
//  LibUGC
//
//  Created by zyd on 16/11/21.
//  Copyright © 2016年 beijingchaotu. All rights reserved.
//

#import "Geometry.h"

@class Point2D;
@class GeoLine,GeoRegion;
@interface GeoCircle : Geometry

/**
 * @brief 获取或设置圆的圆心。
 *
 * @return 圆的圆心。
 */
@property (strong, nonatomic) Point2D *center;

/**
 * @brief 获取或设置圆的半径。
 *
 * @return 圆的半径。
 */
@property (assign, nonatomic) double radius;

/**
 * @brief 根据圆心和半径构造圆对象。
 * @param center 指定的 圆心。
 * @param radius 指定的 半径。
 */
- (id)initWithCenter:(Point2D *)center radius:(double)radius;

-(id)initWithGeoCircle:(GeoCircle *)geoCircle;
/**
 根据两个点创建一个圆，两个点分别为圆直径的两个端点
 */
- (id)initWithPoint:(Point2D *)point1 point2:(Point2D *)point2;
/**
  根据三点创建一个圆.
  根据几何学知识，由三点可确定一个圆，创建三点圆时，这三个点均为弧上的点，因此不能在同一直线上
 */
- (id)initWithPoint2:(Point2D *)point1 point2:(Point2D *)point2 point3:(Point2D *)point3;


-(GeoCircle *)clone;
/**
 转换为线对象
 */
-(GeoLine *)convertToLine:(int) segmentCount;
/**
 转换为面对象
 */
-(GeoRegion *)convertToRegion:(int) segmentCount;

-(void)dispose;
/**
 返回椭圆饼的面积。
 */
-(double) getArea;

-(double)getPerimeter;

@end

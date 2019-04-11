//
//  GeoPoint3D.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import "Geometry3D.h"
#import "Point3D.h"

@class Geometry3D;
/**三维点几何对象类
 <p>该类继承自 Geometry3D类。 Point3D和GeoPoint3D都可用来表示三维点，所不同的是GeoPoint3D描述的是地理实体，而 Point3D描述的是一个位置点；当赋予GeoPoint3D不同的几何风格，即可用于表示不同的地物实体，而 Point3D则是广泛用于定位的坐标点
 */
@interface GeoPoint3D : Geometry3D
/**@brief 根据指定的参数来构造一个 GeoPoint3D 对象
 @param x - X 坐标，单位为经纬度
 @param y - Y 坐标，单位为经纬度
 @param z - Z 坐标，单位为米
 @return 三维点几何对象
 */
- (id)initWithX:(double)x Y:(double)y Z:(double)z;

/**@brief 根据指定的 GeoPoint3D 对象构造一个与其完全相同的新对象
 @param point3D - 指定的 GeoPoint3D 对象
 @return 三维点几何对象
 */
- (id)initWithGeoPoint3D:(GeoPoint3D *)point3D;

/**@brief 根据指定的参数来构造一个 GeoPoint3D 对象
 @param point - 指定的三维点对象
 @return 三维点几何对象
 */
- (id)initWithPoint3D:(Point3D)point;

/// 三维点几何对象的 X 坐标，单位为经纬度
@property(nonatomic)double x;
/// 三维点几何对象的 Y 坐标，单位为经纬度
@property(nonatomic)double y;
/// 三维点几何对象的 Z 坐标，单位为米
@property(nonatomic)double z;
@end

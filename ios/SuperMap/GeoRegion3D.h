//
//  GeoRegion3D.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import "Geometry3D.h"


@class Point3Ds,GeoLine3D;
/**三维面几何对象类
 <p>三维面几何对象由一个或多个部分组成，每个部分称为三维面几何对象的一个子对象，每个子对象用一个有序三维坐标点集合来表示，其起始点和终止点重合。对子对象可以进行添加，删除，修改等操作
 */
@interface GeoRegion3D : Geometry3D

/// 获取三维面几何对象的面积，单位为平方米
@property(nonatomic,readonly)double area;

/// 获取三维面几何对象的子对象个数，默认值为0。三维面几何对象清空后，其子对象的个数为0
@property(nonatomic,readonly)NSInteger partCount;

/** 构造一个新的 GeoRegion3D 对象
 @return  GeoRegion3D对象
 */
- (id)init;

/** 构造一个新的 GeoRegion3D 对象
 @param  region3D 根据给定的 GeoRegion3D 对象来构造一个与其完全相同的新对象
 @return  GeoRegion3D对象
 */
- (id)initWithGeoRegion3D:(GeoRegion3D*)region3D;

/** 构造一个新的 GeoRegion3D 对象
 @param  points 根据指定的参数来构造一个 GeoRegion3D 的新对象
 @return  GeoRegion3D对象
 */
- (id)initWithPoint3Ds:(Point3Ds *)points;

/** 向三维面几何对象中添加一个子对象
 @param  point3Ds  组成区域子对象的点串
 @return  添加成功则返回新添加子对象索引，否则返回-1
 */
- (NSInteger)addPart:(Point3Ds *)point3Ds;

/// 当前对象的拷贝
- (GeoRegion3D *)clone;

/// 将一个三维面几何对象转换生成一个三维线对象
- (GeoLine3D *)convertToLine;

/** 获取指定的子对象在此三维面几何对象中的索引
 @param  index  子对象索引
 @return  返回指定索引子对象
 */
- (Point3Ds*)partOfIndex:(NSInteger)index;

@end

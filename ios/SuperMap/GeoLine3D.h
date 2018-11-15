//
//  GeoLine3D.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import "Geometry3D.h"

@class Point3Ds,GeoRegion3D;
/// 三维线几何对象类。该类继承自 Geometry3D类。三维线几何对象是由三维点串构成的线对象，这些点可以不在同一平面上。
@interface GeoLine3D : Geometry3D

/**
     * @brief 获取三维线几何对象的子对象个数。
     * @return 三维线几何对象的子对象个数。
     */
@property(nonatomic,readonly)NSInteger partCount;

 /**
     * @brief 根据指定的 GeoLine3D 对象构造一个与其完全相同的新对象。
	 * @param geoLine3D - 指定的 GeoLine3D 对象
     * @return GeoLine3D对象。
     */
- (id)initWithGeoLine3D:(GeoLine3D *)geoLine3D;

/**
	@brief 根据指定的参数来构造一个 GeoLine3D 的新对象
	* @param point3Ds - 指定的三维点对象
	* @return GeoLine3D对象。
 */
- (id)initWithPoint3Ds:(Point3Ds*)point3Ds;

/**
	@brief 向三维线几何对象追加一个子对象。
	* @param point3Ds - 指定的三维点对象
	* @return  如果成功，返回添加子对象的序号。
 */
- (NSInteger)addPart:(Point3Ds *)point3Ds;

/**
	@brief 删除三维线几何对象中指定序号的子对象。
	* @param index - 指定的序号。
	* @return  如果成功，返回true，否则返回false。
 */  
- (BOOL)removePart:(NSInteger)index;

/**
	@brief 返回三维线几何对象中指定序号的子对象的三维点对象集合。
	* @param index - 指定的序号。
	* @return  如果成功，返回指定序号。
 */  
- (Point3Ds *)getPart:(NSInteger)index;

/**
	@brief 用于往三维线几何对象中的指定位置插入一个子对象，成功则返回 true，否则返回 false。
	@ param index - 指定的序号。
	@ return  如果成功，返回true，否则返回false。
 */  
- (BOOL)insertPart:(Point3Ds *)part forIndex:(NSInteger)index;

/**
	@brief 修改三维线几何对象指定序号的子对象，即用新的三维点串来替换原来子对象的三维点串。
	@ param index - 指定的序号。
	@ return  如果成功，返回true，否则返回false。
 */ 
- (BOOL)setPart:(Point3Ds *)part forIndex:(NSInteger)index;

/**
	@brief 返回指定三维点串所表示的子对象在此三维线几何对象中的序号。
	@ param part - 指定三维点串。
	@return  如果成功，返回指定序号。
 */ 
- (NSInteger)indexOfPart:(Point3Ds*)part;
  
/**@brief 将该三维线几何对象转换为三维面几何对象，成功返回面几何对象。对于没有封闭的三维线几何对象，转换为三维面几何对象时，会把首尾自动连起来。
  @return  转换成功返回三维面几何对象。
 */ 
- (GeoRegion3D *)convertToRegion;

/**@brief 将该三维线几何对象转换为三维面几何对象，成功返回面几何对象。对于没有封闭的三维线几何对象，转换为三维面几何对象时，会把首尾自动连起来。
  @return  返回当前 GeoLine3D 对象的一个拷贝。
 */ 
- (GeoLine3D *)clone;
@end

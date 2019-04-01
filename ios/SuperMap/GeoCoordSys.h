//
//  GeoCoordSys.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "GeoCoordSysType.h"
#import "GeoSpatialRefType.h"
#import "Unit.h"
@class GeoDatum, GeoPrimeMeridian,GeoPrimeMeridian;

/** 地理坐标系类。
 *  
 * <p> 地理坐标系由大地参照系、中央子午线、坐标单位组成。在地理坐标系中，单位一般用度来表示，也可以用度分秒表示。东西向（水平方向）的范围为-180度至180度。
 *  <p>南北向（垂直方向）的范围为-90度至90度。
 * <p> 地理坐标是用经纬度表示地面点位置的球面坐标。在球形系统中，赤道面的平行面同地球椭球面相交所截的圈称为纬圈，也叫纬线，表示东西方向，
 * 通过地球旋转轴的面与椭球面相交所截的圈为子午圈，也称经线，表示南北方向，这些包围着地球的网格称为经纬格网。
 * <p>经纬线一般用度来表示（必要时也用度分秒表示）。经度是指地面上某点所在的经线面与本初子午面所成的二面角，规定本初子午线的经度为0度，从本初子午线向东 0 到 180 度为 “东经”，以“E”表示，向西
 *  0 到 -180 度为“西经”，以字母“W”表示；纬度是指地面上某点与地球球心的连线和赤道面所成的线面角，规定赤道的纬度为 0 度，从赤道向北 0 到 90 度为“北纬”，以字母“N”表示，向南 0 到 -90 度为“南纬”，以字母“S”表示。</p>
 * 
 */
@interface GeoCoordSys : NSObject{
    @private
    GeoDatum * _geoDatum;
    GeoPrimeMeridian * _geoPrimeMeridian;
}

/**
 * @brief 获取或设置地理坐标系对象的名称。
 * 
 * @return 地理坐标系对象的名称。
 */
@property(nonatomic,copy)NSString *name; 

/**
  * @brief 获取或设置地理坐标系类型。
  * <p>
  * 当地理坐标系的类型为自定义时，用户需另外指定大地参照系、中央经线；其余的值为 SuperMap Object Java
  * 系统预定义，用户不必指定半长径和扁率。本系统中，地理坐标系单位可以是度分妙；系统预定义的地理坐标系的常量为
  * GeoCoordSysType 。
  * </p>
  * 
  * @return 地理坐标系类型。
 */
@property(nonatomic)GeoCoordSysType geoCoordSysType;

/**
  * @brief  获取或设置空间坐标系类型。
  * 
  * @return 空间坐标系类型。
 */
@property(nonatomic)GeoSpatialRefType geoSpatialRefType;

/**
 * @brief  获取或设置大地参照系对象。
 * 
* @return 大地参照系对象。
 */
@property(nonatomic)GeoDatum* geoDatum;

/**
 *  @brief 获取或设置中央子午线对象。
* 
 * @return 中央子午线对象。
*/
@property(nonatomic)GeoPrimeMeridian* geoPrimeMeridian;

/**
 *   @brief 获取或设置地理坐标系的单位。
* 
* @return 地理坐标系的单位。
 */
@property(nonatomic)Unit coodUnit;

/**
 * @brief  根据指定的参数来构造一个 GeoCoordSys 的新对象。
* 
 * @param type  地理坐标系类型。
 * @param spatialRefType   空间坐标系类型，用以区分平面坐标系、地理坐标系、投影坐标系。
 */
-(id)initWithGeoCoordSysType:(GeoCoordSysType)type GeoSpatialRefType:(GeoSpatialRefType)spatialRefType;

/**
* @brief 根据指定的参数来构造一个 GeoCoordSys 的新对象。
* 
 * @param geoDatum  大地参照系。
 * @param primeMeridian  中央经线。
* @param spatialRefType  空间坐标系类型。
 * @param unit   坐标单位。
 * @param name   地理坐标系名称。
 */
-(id)initWithGeoDatum:(GeoDatum *)geoDatum GeoPrimeMeridian:(GeoPrimeMeridian *)primeMeridian SpatialRefType:(GeoSpatialRefType)spatialRefType Uint:(Unit)unit Name:(NSString *)name;

/**
 * @brief 根据给定的 GeoCoordSys 对象构造一个与其完全相同的新对象。
* 
 * @param geoCoordSys  指定 GeoCoordSys 对象。
 */
-(id)initWithGeoCoordSys:(GeoCoordSys*)geoCoordSys;

/**
*  @brief 从指定的 XML 字符串中构建地理坐标系类的对象，成功返回 true。
 * 
* @param xml   指定的 XML 字符串。
* @return 如果构建成功返回 true，否则返回 false。
 */
-(BOOL)fromXML:(NSString*)xml;

/**
 *  @brief  将地理坐标系类的对象转换为 XML 格式的字符串。
 * 
* @return 表示地理坐标系类的对象转换为 XML 格式的字符串。
 */
-(NSString *)toXML;

/**
* @brief 对GeoCoorSys进行clone。
*
 * @return GeoCoorSys的clone对象
 */
-(GeoCoordSys *)clone;

/**
*  @brief  释放该对象所占用的资源。当调用该方法之后，此对象不再可用。
*/
-(void)dispose;
@end

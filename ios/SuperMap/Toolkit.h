//
//  Toolkit.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import "Geometry.h"
#import "EncodeType.h"
@class Geometry;
@class GeoRegion,GeoLine;
@class Workspace;
@class PrjCoordSys;
@class Point2Ds;
//@class UIImage;
extern const double DBL_MAX_VALUE ;

extern const double DBL_MIN_VALUE ;

extern const float FLT_MAX_VALUE ;

extern const  float FLT_MIN_VALUE ;

/**   工具包类。
*
* <P>提供一些辅助计算功能。例如：判断给定值是否为零的重载方法等。</p>
*/
@interface Toolkit : NSObject

/** 判断 value 是否为零值， 使用  <Environment> 里设定的容限。
* 
* <P>其中 <Environment>  类中定义的判断精度有零值判断精度和默认零值判断精度，这里使用的是默认零值判断精度，就是系统给定的零值判断精度。详细信息请参见 <Environment>  类型。</p>
* @param value 要测试的值。
* @return 如果 value 为零值，返回 true;否则返回 false。
*/
+(BOOL)isZero:(double)value;

/**
* 判断给定的value是否为零值，使用 precision 做为判断精度。
* @param value 要测试的值。
* @param precision 用户给定的零值判断精度。
* @return 一个布尔值，true 表示 value 值为零值，false 表示为非零值。
*/
+(BOOL)isZero:(double)value Precision:(double)precision; 

/**
* 判断 value 是否为零值，使用最小判断精度（minPrecision）和最大判断精度（maxPrecision）作为判断容限。
* @param value 要测试的值。
* @param minPrecision 指定的最小判断精度，即左判断精度，为判断容限的下限。
* @param maxPrecision 指定的最大判断精度，即右判断精度，为判断容限是上限。
* @return 一个布尔值，true 表示 value 值为零值，false 表示为非零值。
*/
+(BOOL)isZero:(double)value Min:(double)minPrecision Max:(double)maxPrecision;

//+(UIImage *)draw:(Geometry *)geometry Workspace:(Workspace *)workspace ImageSize:(CGSize)imagesize;

+(BOOL) isValidEncodeType:(BOOL)isVector encodeType:(EncodeType)encodeType;

//计算p1 p2 p3之间夹，p2是拐点。 顺时针 线段夹角 三个点需要在同一坐标系
+(double)calcAngle:(Point2D*)p1 pos2:(Point2D*)p2 pos3:(Point2D*)p3;

/**
 * 计算点串间的总距离
 * @param points 点串
 * @param prj 当前地图的投影坐标系
 * @return
 */
+(double)calcLength:(Point2Ds*)points prj:(PrjCoordSys*)prj;

/**
 * 计算点串间围为的地理面积
 * @param points 点串
 * @param prj 当前地图的投影坐标系
 * @return
 */
+(double)calcArea:(Point2Ds*)points prj:(PrjCoordSys*)prj;

//! \brief 判断两个面是否交叠
+(BOOL)isOverlap:(GeoRegion*)geo1 geo2:(GeoRegion*)geo2;

//! \brief 判断是否自相交
//! -1:数据错误或异常 1：数据存在自相交 0：数据不存在自相交
+(int)IsSelfIntersect:(Geometry*)geo;

//获取当前长度
+(double)getCurrentLength:(GeoLine*)geo prj:(PrjCoordSys*)prj;
//获取当前面积
+(double)getCurrentArea:(GeoRegion*)geo prj:(PrjCoordSys*)prj;
+(NSString*)getLanguage;
+(void)setLanguage:(NSString*)language;
@end

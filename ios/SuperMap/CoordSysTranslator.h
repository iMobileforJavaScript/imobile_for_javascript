//
//  CoordSysTranslator.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

#import "CoordSysTransMethod.h"
@class Point2Ds;
@class PrjCoordSys;
@class CoordSysTransParameter;
@class Geometry;

/** 投影转换类。
 * 
 * <p> 主要用于投影坐标和地理坐标（经纬度）之间及投影坐标系之间的转换。
 *
 * <p>投影转换一般有三种工作方式：地理（经纬度）坐标和投影坐标之间的转换使用forward() 方法、投影坐标和地理（经纬度）坐标之间的转换使用inverse() 方法 、两种投影坐标系之间的转换使用convert() 方法。
 * <p>注意：当前版本不支持光栅数据的投影转换。即在同一数据源中，投影转换只转换矢量数据部分。地理坐标系（Geographic Coordinate System）也称为地理坐标系统，是以经纬度为地图的存储单位的。很明显，地理坐标系是球面坐标系统。如果将地球上的数字化信息存放到球面坐标系统上，就需要有这样的椭球体具有如下特点：可以量化计算的，具有长半轴（Semimajor Axis），短半轴（Semiminor Axis），偏心率（Flattening），中央子午线（prime meridian）及大地基准面（datum）。投影坐标系统（Projection coordinate system）实质上便是平面坐标系统，其地图单位通常为米。将球面坐标转化为平面坐标的过程便称为投影。所以每一个投影坐标系统都必定会有地理坐标系统（Geographic Coordinate System）参数。 因此就存在着投影坐标之间的转换以及投影坐标系之间的转换。
 * <p>在进行投影转换时，对文本对象（GeoText）投影转换后，文本对象的字高和角度会相应的转换，如果用户不需要这样的改变，需要对转换后的文本对象修正其字高和角度。
 */
@interface CoordSysTranslator : NSObject

  /**
     * @brief 在同一地理坐标系下，该方法用于将指定的 Point2Ds  类的点对象的地理坐标转换到投影坐标。
     * @param points 指定的被转换的 Point2Ds  类的对象。
     * @param prjCoordSys 对象所在的投影坐标系。
     * @return 如果转换成功返回 true，否则返回 false。
     */
+(BOOL)forward:(Point2Ds *)points PrjCoordSys:(PrjCoordSys*)prjCoordSys;

 /**
     * @brief 在同一投影坐标系下，该方法用于将指定的 Point2Ds  类的点对象的投影坐标转换到地理坐标。
     * @param points 被转换的 Point2Ds  对象。
     * @param prjCoordSys 指定的对象所在的投影坐标系。
     * @return 如果坐标转换成功，返回 true，否则返回 false。
     */
+(BOOL)inverse:(Point2Ds *)points PrjCoordSys:(PrjCoordSys*)prjCoordSys;

 /**
     * @brief 根据源投影坐标系与目标投影坐标系对坐标点串进行投影转换，结果将直接改变源坐标点串。
     * @param points 被转换的 Points2Ds 类的点串。
     * @param srcPrjCoordSys 源投影坐标系。
     * @param desPrjCoordSys 目标投影坐标系。
     * @param coordSysTransParameter 投影坐标系转换参数。包括坐标的平移量、旋转角度、投影比例尺差，详情请参见 CoordSysTransParameter 类。
     * @param coordSysTransMethod 投影转换所使用的方法。详情请参见 CoordSysTransMethod 。
     * @return 如果转换成功返回 true，否则返回 false。
     */
+(BOOL)convert:(Point2Ds *)points PrjCoordSys:(PrjCoordSys*)srcPrjCoordSys PrjCoordSys:(PrjCoordSys*)desPrjCoordSys CoordSysTransParameter:(CoordSysTransParameter*)coordSysTransParameter CoordSysTransMethod:(CoordSysTransMethod)coordSysTransMethod;

+(BOOL)convert2:(Geometry *)geometry PrjCoordSys:(PrjCoordSys*)srcPrjCoordSys PrjCoordSys:(PrjCoordSys*)desPrjCoordSys CoordSysTransParameter:(CoordSysTransParameter*)coordSysTransParameter CoordSysTransMethod:(CoordSysTransMethod)coordSysTransMethod;

@end

//
//  Geometry.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "GeometryType.h"

@class Point2D, GeoStyle,Rectangle2D;

/**  所有具体几何类型（ <GeoPoint> ,  <GeoLine> ,  <GeoRegion> 等）的基类，提供了基本的几何类型的方法。
 *
 * <p>该类用于表示地理实体的空间特征，并提供相关的处理方法。根据地理实体的空间特征不同，分别用点    <  GeoPoint >   ，线 < GeoLine> ，面   <G  eoRegion>   等加以描述。当该类的子类的对象实例被 dispose 后，再调用该类的方法会抛出 ObjectDisposedException。</p>
 * <p>用户自己创建的 <Geometry> 对象，例如 <GeoPoint> 、<GeoLine> 、 <GeoRegion>   等对象，在执行完系列操作后，需要对其进行释放。
 */
@interface Geometry : NSObject{
@private
    GeoStyle* _geoStyle;
    bool      _setStyle;
}

 /**
     * @brief 返回几何对象的最小外接矩形。点对象的最小外接矩形退化为一个点，即矩形的左边界坐标值等于其右边界坐标值，上边界坐标值等于其下边界的坐标值，分别为该点的 x 坐标和 y 坐标。
     *
     * @return 一个  <Rectangle2D> 对象表示几何对象的最小外接矩形。
     * <p> 请参见 <Rectangle2D>
     */
- (Rectangle2D *)getBounds;

/**
     * @brief  返回几何对象的内点。对于不同的几何对象，其位置不同。
     *  1. 点对象的内点是该点本身；
     * 2. 线对象的内点是线对象的第一个子对象的内点（当线对象只有一个子对象时，取该子对象的内点），当该子对象有奇数个节点时，取中间一个节点为内点，当该子对象有偶数个节点时（多于两个节点的情况），取中间两个节点之后者，当该子对象有两个节点时，取两节点之中心为内点；
     * 3. 面对象的内点是在几何对象的内部，并靠近中央的点；
     * 4. 文本对象的内点是该文本对象的第一个子对象的锚点。
     * <p>内点可以在很多情况下被使用。
     * @return 几何对象的内点。
     */
- (Point2D *)getInnerPoint;

 /**
     * @brief 返回几何对象的标识符，此标识符用于唯一标识该几何对象。
     *
     * @return 该几何对象的标识符。
     */
-(int)getID;

 /**
     * @brief 判断几何对象是否为空值，不同的几何对象的是否为空的条件各异，请参见各具体几何类型的该方法。
     * @return 一个布尔值指定几何对象是否为空。
     */
- (bool)isEmpty;

/**
     * @brief 返回几何对象的几何风格。几何风格是用于定义几何对象在显示时的符号、线型、填充模式等信息。
     *
     * @return 几何对象的风格。
     */
- (GeoStyle *)getStyle;

/**
     *@brief  设置几何对象的风格。几何风格是用于定义几何对象在显示时的符号、线型、填充模式等信息。
     *
     * @param value 用来设置几何对象风格的 <GeoStyle>  对象。
     */
- (void)setStyle:(GeoStyle *)value;

/**
     * @brief 返回几何对象的类型。该方法的返回值为  <GeometryType>  类所定义的常量值之一，具体请参见  <GeometryType>  类。
     * @return 几何对象的类型。
     * <p> 请参见 <GeometryType> 
     */
- (GeometryType)getType;

 /**
     * @brief 返回当前对象的一个拷贝。
     * @return 通过克隆操作得到的一个新的几何对象。
     */
- (Geometry *)clone;

/**
     * @brief 测试在指定容限允许的范围内，指定的点是否在几何对象的范围内。
     * <p>即判断以测试点为圆心，以指定的容限为半径的圆是否与该几何对象有交集，若有交集，则返回 true；否则返回 false。</p>
     *
     * @param point 测试点。
     * @param tolerance 容限值，单位与数据集的单位相同。
     * @return 测试结果，点中了该几何对象返回 true；否则返回 false。
     * <p> 请参见  <Point2D> 
     */
- (bool)hitTest:(Point2D *)point With:(double)tolerance;

/**
     *@brief  将此几何对象偏移指定的量。
     *
     * @param dx 偏移 X 坐标的量。
     * @param dy 偏移 Y 坐标的量。
     */
- (void)offsetX:(double)dx Y:(double)dy;

 /**
     * @brief 缩放此几何对象，使其最小外接矩形等于指定的矩形对象。
     * <p>对于几何点，该方法只改变其位置，将其移动到指定的矩形的中心点；对于文本对象，该方法将缩放文本大小。</p>
     * <p>改变几何对象的大小 当宽度为负数时对象水平翻转，当高度为负数时，对象垂直翻转。</p>
     * <p>当传入的矩形对象的面积为0时，抛出异常 ArgumentInvalid。</p>
     *
     * @param bounds 调整大小后几何对象的范围。
     * @exception ArgumentInvalid 如果 bounds 的面积为0。
     */
- (void)resize:(Rectangle2D *)bounds;

/**
     * @brief 以指定点为基点将此几何对象旋转指定角度，逆时针方向为正方向，角度以度为单位。</p>
     *
     * @param basePoint 旋转的基点。
     * @param angle 旋转的角度，单位为度。
     */
- (void)rotate:(Point2D *)basePoint Angle:(double)angle;

/**
     *   @brief 清空几何对象中的空间数据，但几何对象的标识符和几何风格保持不变。
     */
- (void)setEmpty;

/**
     * @brief 释放该对象所占用的资源。当调用该方法之后，此对象不再可用。
     */
- (void)dispose;

/**
 * @brief 将Geometry对象转换成Json串。
 * @return Geometry对象转换的Json串。
 */
-(NSString*) toJson;

/**
* @brief 将Json串转换成Geometry对象。
* @param JSONData id类型的Json串。
* @return 一个布尔值，转换成功返回true,否则返回false。
*/
-(BOOL) fromJson:(id) JSONData;

/**
 * 将Geometry转换成GeoJSON格式的字符串;具体实现由子类完成
 * @return      返回GeoJSON字符串
 */
-(NSString*)toGeoJson;

/**
 * 从GeoJSON格式的字符串中获取Geometry;具体实现由子类完成
 * @param geoJSON  GeoJSON字符串
 * @return         返回是否转换成功
 */
-(BOOL)fromGeoJson:(NSString*)geoJSON;

-(NSString*)toXML;
-(BOOL)fromXML:(NSString*)xml;

@end

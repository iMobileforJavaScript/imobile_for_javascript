//
//  GeoPoint.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import "Geometry.h"

/** 点几何对象类，派生于  <Geometry>  类。
 *
 * 该类一般用于描述点状地理实体。
 * <p>  <Point2D> 和 <GeoPoint> 都可用来表示二维点，所不同的是 <GeoPoint> 描述的是地物实体，而 <Point2D> 描述的是一个位置点；当赋予 <GeoPoint> 不同的几何风格，即可用于表示不同的地物实体，而 <Point2D> 则是广泛用于定位的坐标点。当该类的实例对象已被 dispose() 方法释放后，再调用对象的方法，则会抛出 ObjectDisposedException。
 */
@interface GeoPoint : Geometry{
    
}
/**
     * @brief  根据指定的参数来构造一个 GeoPoint 的新对象。
     * @param x 指定点几何对象的 X 坐标值。
     * @param y 指定点几何对象的 Y 坐标值。
 */
- (id)initWithX:(double)x Y:(double)y;

 /**
     *@brief   根据给定的 GeoPoint 对象构造一个与其完全相同的新对象。
     * @param point 指定的 GeoPoint 对象。
 */
- (id)initWithPoint:(GeoPoint*)point;

 /**
     *@brief 根据指定的参数来构造一个 GeoPoint 的新对象。
     * @param point 指定的二维点对象。
 */
- (id)initWithPoint2D:(Point2D*)point;

/**
     *@brief 释放该对象所占用的资源。调用该方法之后，此对象不再可用。
 */
- (void)dispose;

 /**
     * @brief 返回此点几何对象的 X 坐标。使用无参构造函数构造的点对象的 X 坐标值为默认值。
     * @return 此点几何对象的 X 坐标。
 */
- (double)getX;

/**
     * @brief 返回此点几何对象的 Y 坐标。使用无参构造函数构造的点对象的 Y 坐标值为默认值。
     * @return 此点几何对象的 Y 坐标。
 */
- (double)getY;

/**
     * @brief 设置此点几何对象的 X 坐标。
     *
     * @param x 用以设置此点几何对象的 X 坐标。
 */
- (void)setX:(double)x;

 /**
     * @brief 设置此点几何对象的 Y 坐标。使用无参构造函数构造的点对象的 Y 坐标值为默认值。
     * @param y 用以设置此点几何对象的 Y 坐标。
 */
- (void)setY:(double)y;

/**
     * @brief 判断当前点几何是否为空，即其 X 和 Y 坐标是否均为-1.7976931348623157e+308。使用的判断精度为零值判断精度。
     * @return 如果当前点几何为空则返回 true；否则返回 false。
 */
-(bool)isEmpty;

/**
     * @brief 返回当前 GeoPoint 对象的一个拷贝。
     *
     * @return 通过克隆操作得到的 GeoPoint 对象。
 */
- (GeoPoint *)clone;

/**
 * @brief 将点几何对象转换成Json串。
 * @return 点几何对象转换的Json串。
 */
-(NSString*) toJson;

/**
* @brief 将Json串转换成点几何对象。
* @param JSONData id类型的Json串。
* @return 一个布尔值，转换成功返回true,否则返回false。
*/
-(BOOL) fromJson:(id) JSONData;

@end

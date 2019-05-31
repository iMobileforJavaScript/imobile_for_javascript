//
//  Point2D.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

/**  点类。
 <p> 点类的的实例为点对象，用于表示坐标值为双精度的点对象，即其坐标值的范围为±5.0*1e-324到±1.7*1e308，有效位为15-16位。
 <p>点对象是各种几何对象的基础，如几何线对象实际就是一串  <Point2D> 的点串，而几何面则是一串起始点和结束点相同的点串，因而在描绘几何对象的位置和形状上，点对象是一个很重要的角色。</p>
 <p>当使用默认构造函数创建一个 <Point2D> 的新实例时，其 x,y 坐标均为-1.7976931348623157e+308；还可以使用给定 x,y 坐标的方式，和创建已有点对象的拷贝的方式来构造一个新的点对象。</p>
 <p>该类除提供返回和设置点的坐标值的方法外，还提供了对已有点的坐标采取各种形式的取整来创建新的坐标值为整数的点对象的方法，以及平移该点对象的方法。</p>
 */

@interface Point2D : NSObject
{@private
    double _x;
    double _y;
}
#pragma mark Property

/**@brief  获取或设置此点对象的 X 坐标。
 <p>  默认值为 -1.79769313486232E+308。
 @return  此二维点对象的 X 坐标。
 */
@property (nonatomic,readwrite) double x;


 /**@brief 获取或设置此点对象的 Y 坐标。
 <p> 默认值为 -1.79769313486232E+308。
 @return  此点对象的 Y 坐标。
 */
@property (nonatomic, readwrite) double y;

#pragma mark Construct

/**@brief  根据指定的参数来构造一个 Point2D 的新对象。
 @param  x Point2D 的 X 坐标值。
 @param  y Point2D 的 Y 坐标值。
 */
-(id)initWithX:(double)x Y:(double)y;

/**@brief  根据给定的 Point2D 对象构造一个与其完全相同的新对象。
 @param  point2D 指定的 Point2D 对象。
 */
-(id)initWithPoint2D:(Point2D *)point2D;

#pragma mark Method

 /**@brief 返回当前 Point2D 对象的一个拷贝。
 @return  通过克隆操作得到的 Point2D 对象。
 */
-(Point2D *)clone;

/**@brief 判定此 Point2D 是否与指定的 Point2D 相等，即有相同的坐标值。注意其判定精度为零值判断精度。关于更多零值判断精度的信息，请参见 Environment 类。
 @param  point2D 要与此 Point2D 相比较的二维点对象。
 @return  如果 point2D 与此 Point2D 相同返回 true，否则返回 false。
 */
-(BOOL)equals:(Point2D *)point2D;

/**@brief 将此点对象的坐标平移指定的量。
 @param  x X 坐标的偏移量。
 @param  y Y 坐标的偏移量。
 */
-(void)offsetX:(double)x Y:(double)y;

/**@brief  返回一个表示此点对象的坐标的格式化字符串，如点(2,3)，则返回的格式化的字符串为“{X=2.0,Y=3.0}”。
 @return  表示此 <Point2D> 的字符串。
 */
-(NSString *)toString;

/**@brief 将 Point2D 对象转换成Json串。
 @return  Point2D 对象转换的Json串。
 */
-(NSString*) toJson;

/**@brief 将Json串转换成 Point2D 对象。
 @param  JSONData id类型的Json串。
 @return  一个布尔值，转换成功返回true,否则返回false。
*/
-(BOOL) fromJson:(id) JSONData;

/**
 * 通过将 Point2D 的坐标值舍入到与其接近的较大整数值，并以整数值构造一个新的Point2D返回
 * @param pt Point2D 需要转换的二维点对象
 * @return Point 转换后的二维点对象
 */
+(Point2D *) ceiling:(Point2D *) point2D;
/**
 * 返回小于或等于比pt坐标值的最大整数对构造的Point2D
 * @param pt Point2D 需要转换的二维点对象
 * @return Point 转换后的二维点对象
 */
+(Point2D *) floor:(Point2D *) point2D;

/**
 * 返回空的点对象
 * @return Point2D
 */
+(Point2D *) getEMPTY;
/**
 * 通过将 Point2D 的坐标值舍入到最接近的整数值，并以整数值为坐标构造一个新的Point2D返回
 * @param pt Point2D 需要转换的二维点对象
 * @return Point 转换后的二维点对象
 */
+(Point2D *) round:(Point2D *) point2D;
/**
 * 判断是否为空的Point2D对象
 * @return boolean
 */
-(BOOL) isEmpty;


@end

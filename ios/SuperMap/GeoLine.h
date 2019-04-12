//
//  GeoLine.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "Geometry.h"

@class Point2Ds;

/** 线几何对象类，派生于  <Geometry>  类。
 <p>该类用于描述线状地理实体，如河流，道路，等值线等，一般用一个或多个有序坐标点集合来表示。线的方向决定于有序坐标点的顺序，也可以通过调用 reverse 方法来改变线的方向。线对象由一个或多个部分组成，每个部分称为线对象的一个子对象，每个子对象用一个有序坐标点集合来表示。可以对子对象进行添加，删除，修改等操作。</p>
 */
@interface GeoLine :Geometry {
    @private
    NSMutableArray * _geoLineParts; //???孿?point2Ds
}
/**@brief  用指定的 GeoLine 对象构造一个与其完全相同的新对象。
 @param  geoLine 指定的GeoLine 对象。
 @exception  ObjectDisposedException 如果作为拷贝源的线对象已调用dispose方法。
 */
- (id)initWithGeoLine:(GeoLine *)geoLine;

/**@brief 根据指定的参数来构造一个 GeoLine 的新对象。
 @param  points 构成线的有序点集合。
 @exception  IllegalArgumentException 如果 points 中的点的总数小于2。
 */
- (id)initWithPoint2Ds:(Point2Ds *)points;

/**@brief 获取或设置线几何对象是否为空，即其子对象个数是否为零。
 @return  如果线几何对象为空则返回 true，否则返回 false。
 */
- (BOOL)isEmpty;

/** @brief  返回当前 GeoLine 对象的一个拷贝。
 @return  通过克隆操作得到的 GeoLine 对象。
 */
- (GeoLine *)clone;

///释放该对象所占用的资源。调用该方法之后，此对象不再可用。
- (void)dispose;

/**@brief  返回线几何对象的长度，其值为各个子对象长度之和。
 @return  线几何对象的长度。
 */
- (double)getLength;

/** @brief  返回线几何对象的子对象个数。
 <p> 线几何对象清空后，其子对象的个数为0。
 @return  该线几何对象的子对象个数。
 */
- (int)getPartCount;

/**@brief  向此线几何对象追加一个子对象。
 @param  points  一个有序点集合。
 @return  成功返回添加的子对象的序号。
 @exception  IllegalArgumentException 如果 points 中的点的个数小于2。
 */
- (int)addPart:(Point2Ds *)points;


/**@brief  删除此线几何对象中的指定序号的子对象。
 @param  index   指定的子对象的序号。
 @return  成功则返回 true，否则返回 false。
 @exception  IndexOutOfBoundsException 如果序号大于等于子对象的个数或序号小于0。
 */
-(BOOL)removePart:(int)index;

/**@brief  在线上以指定的距离找点，查找的起始点为线的起始点。
 1. 当 distance 大于 Length 时，返回线最后一个子对象的终点。
 2. 当 distance=0 时，返回线几何对象的起始点；
 3. 当线几何对象具有多个子对象的时候，按照子对象的序号依次查找。
 @param  distance 要找点的距离
 @return  查找成功返回要找的点，否则返回 null。
 @exception  IllegalArgumentException 如果传入的距离为负值。
 */
- (Point2D *)findPointOnLineByDistance:(double)distance;

/**@brief  返回此线几何对象中指定序号的子对象，以有序点集合的方式返回该子对象。
 @param  index 子对象的序号。
 @return  成功返回   <Point2Ds> 对象，失败返回空值。
 */
- (Point2Ds *)getPart:(int)index;

/**@brief  往此线几何对象中的指定位置插入一个子对象。
 @param  index 插入的位置。
 @param  points  插入的有序点集合。
 @return  成功则返回 true，否则返回 false。
 @exception  IndexOutOfBoundsException 如果 index 大于该线几何对象的子对象总数或 index 为负。
 @exception  IllegalArgumentException 如果 points 中的点的总数小于2。
 */
- (BOOL)insertPart:(int)index Points:(Point2Ds *)points;

/**@brief  修改此线几何对象指定序号的子对象，即用新的有序点集合来替换原子对象的有序点集合。
 @param  index 被修改的子对象的序号。
 @param  points 有序点的集合。
 @return  成功返回 true，否则返回 false。
 @exception  IndexOutOfBoundsException 如果 index 不小于子对象的个数或 index 为负。
 @exception  IllegalArgumentException 如果 points 中的点的个数小于2。
 */
-(BOOL)setPart:(int)index Point2Ds:(Point2Ds *)points;

/**@brief  旋转几何对象。
 @param  point  旋转基点。
 @param  angle  旋转角度。
 */
- (void)rotate:(Point2D *)point Angle:(double)angle;

/**@brief 将线几何对象转换成Json串。
@return  线几何对象转换的Json串。
 */
-(NSString*) toJson;

/**@brief 将Json串转换成线几何对象。
 @param  JSONData id类型的Json串。
 @return  一个布尔值，转换成功返回true,否则返回false。
*/
-(BOOL) fromJson:(id) JSONData;
@end

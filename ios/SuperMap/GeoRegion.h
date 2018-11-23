//
//  GeoRegion.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import "Geometry.h"

@class Point2Ds,GeoLine;

/**  面几何对象类，派生于 <Geometry>  类。
 *  该类用于描述面状地理实体，如行政区域，湖泊，居民地等，一般用一个或多个有序坐标点集合来表示。面几何对象由一个或多个部分组成，每个部分称为面几何对象的一个子对象，每个子对象用一个有序坐标点集合来表示，其起始点和终止点重合。可以对子对象进行添加，删除，修改等操作。
 */
@interface GeoRegion : Geometry

 /**
     * @brief 根据给定的 GeoRegion 对象构造一个与其完全相同的新对象。
     * @param geoRegion 指定的 GeoRegion 对象。
 */
- (id)initWithGeoRegion:(GeoRegion *)geoRegion;

/**
     * @brief 根据指定的参数来构造一个 GeoRegion 的新对象。
     * @param points 用来创建面几何对象的有序点集合。
     * @exception IllegalArgumentException 如果有序点集合中的点的个数小于3。
 */
- (id)initWithPoint2Ds:(Point2Ds *)points;

/**
     * @brief 向此面几何对象追加一个子对象。
     *
     * @param points 组成面子对象的有序点集合。
     * @return 添加成功则返回新添加子对象序号，否则返回-1。
     * @exception IllegalArgumentException 如果有序点集合中的点的个数小于3。
 */
- (int) addPart:(Point2Ds *)points;

/**
     * @brief  将此面几何对象转换为线几何对象。成功返回线几何对象。
     *
     * @return 转换成功则返回新生成的线几何对象。
 */
- (GeoLine *)convertToLine;

 /**
     * @brief  返回此面几何对象中指定序号的子对象，以有序点集合的方式返回该子对象。
     *
     * @param index 子对象的序号。
     * @return 组成子对象的有序点集合。
     * @exception IndexOutOfBoundsException 如果序号越界。
 */
- (Point2Ds *)getPart:(int)index;

/**
     * @brief  往此面几何对象中的指定位置插入一个子对象。成功则返回 true，否则返回 false。插入有序点集合的副本，因此插入后对源有序点集合的修改不会影响面几何对象，如需修改面几何对象，请用 setPart()  方法。
     *
     * @param index 插入子对象的位置。
     * @param points 组成要插入的子对象的有序点集合。
     * @return 插入子对象成功返回 true，否则返回 false。
     * @exception IllegalArgumentException 如果有序点集合中的点的个数小于3。
     * @exception IndexOutOfBoundsException 如果序号越界。
 */
- (BOOL)insertPart:(Point2Ds *)points At:(int)index;

/**
     * @brief  删除此面几何对象中的指定序号的子对象。
     *
     * @param index 被删除的子对象的序号。
     * @return 删除成功返回 true，否则返回 false。
     * @exception IndexOutOfBoundsException 如果序号越界。
 */
- (BOOL)removePartAt:(int)index;

 /**
     * @brief  修改此面几何对象指定序号的子对象。即用新的有序点集合来替换原子对象的有序点集合。
     *
     * @param points 组成用以替换的面子对象的有序点的集合。
     * @param index 被替换的子对象的序号。
     * @return 替换成功返回 true，否则返回 false。
     * @exception IllegalArgumentException 如果有序点集合中点的个数小于3。
     * @exception IndexOutOfBoundsException 如果序号越界。
 */
- (BOOL)setPart:(Point2Ds *)points At:(int)index;

 /**
     * @brief  返回此面几何对象的面积。
     * <p> 如果面几何对象有多个子对象时，面几何对象的面积为其多个子对象之和。
     *
     * @return 此面几何对象的面积。
 */
- (double)getArea;

 /**
     * @brief  返回此面几何对象的子对象个数。面几何对象清空后，其子对象的个数为0。
     *
     * @return 此面几何对象的子对象个数。
 */
- (int)getPartCount;

/**
     * @brief 返回此面几何对象的周长，其值为各子对象周长之和。
     *
     * @return 此面几何对象的周长。
 */
- (double)getPerimeter;

 /**
     * @brief 返回当前 GeoRegion 对象的一个拷贝。 
     * @return  通过克隆操作得到的 GeoRegion 对象。
 */
- (GeoRegion *)clone;

/**
     * @brief  返回此面几何对象是否为空，即其子对象个数是否为零。关于子对象个数的详细信息请参见  <getPartCount > 方法。
     *
     * @return 如果对象为空，则返回 true；否则返回 false。
 */
- (BOOL)isEmpty;

 /**
     * @brief  释放当前对象所占用的资源。调用该方法之后，此对象不再可用。
 */
- (void)dispose;

/**
 * @brief 将面几何对象转换成Json串。
 * @return 面几何对象转换的Json串。
 */
-(NSString*) toJson;

/**
* @brief 将Json串转换成面几何对象。
* @param JSONData id类型的Json串。
* @return 一个布尔值，转换成功返回true,否则返回false。
*/
-(BOOL) fromJson:(id) JSONData;
@end

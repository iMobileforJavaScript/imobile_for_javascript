//
//  Point2Ds.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
//写文档时，用途不明，暂时注释

@class GeoLine;
@class GeoRegion;
@class Point2D;

/** 点集合对象。
 * <p>此类管理线对象或线对象的子对象上的所有节点。由于线对象或线对象的子对象都是有向的，所以其点集合对象为有序的点的集合。 </p>
 */
@interface Point2Ds : NSObject {
@private
    NSMutableArray *_point2Ds;
    GeoLine *_geoLine;
    GeoRegion *_geoRegion;
	// 写文档时，用途不明，暂时注释
    //UserType _userType;
}

  /**
     * @brief 构造一个新的 Point2Ds 对象。
     */
-(id)init;

  /**
     * @brief 根据指定的参数来构造一个 Point2Ds 的新对象。
     * @param point2DsArray 指定的点对象的数组。
     */
-(id)initWithPoint2DsArray:(NSMutableArray *)point2DsArray;

/**
     * @brief 根据给定的 Point2Ds 对象构造一个与其完全相同的新对象。
     * @param point2Ds 指定的 Point2Ds 对象。
     */
-(id)initWithPoint2Ds:(Point2Ds *)point2Ds;

/**
* @brief 根据给定的 Point2Ds 对象和线几何对象构造一个新的点集合对象。
* @param point2Ds 给定的 Point2Ds 对象。
* @param geoLine 给定的线几何对象。
*/
-(id)initWithPoint2Ds:(Point2Ds *)point2Ds GeoLine:(GeoLine *) geoLine;

/**
* @brief 根据给定的 Point2Ds 对象和面几何对象构造一个新的点集合对象。
* @param point2Ds 给定的 Point2Ds 对象。
* @param geoRegion 给定的面几何对象。
*/
-(id)initWithPoint2Ds:(Point2Ds *)point2Ds GeoRegion:(GeoRegion *)geoRegion;

/**
     * @brief 返回此点集合对象中所包含的点对象的总数。
     * <p>默认值为 0。
     *@return 此点集合对象中所包含的点对象的总数。
     */
-(NSInteger)getCount;

/**
     * @brief 返回此点集合对象中指定序号的点对象。
     * @param index 指定的序号。
     * @return 此点集合对象中指定序号的点对象。
     */
-(Point2D *)getItem:(NSInteger)index;

 /**
     * @brief  设置此点集合对象中指定序号的点对象。
     * @param index 指定的序号。
     * @param point2D 指定点集合对象中指定序号的点对象。
     */
-(void)setItem:(NSInteger)index Point2D:(Point2D *)point2D;

  /**
     * @brief 返回当前 Point2Ds 对象的一个拷贝。 
     * @return  通过克隆操作得到的 Point2Ds 对象。
     */
-(Point2Ds *)clone;

 /**
     * @brief  将指定的点对象添加到点集合对象的末尾。
     * @param point2D 要添加到此点集合对象中的点对象。
     * @return 添加的点对象的序号。
     */
-(NSInteger)add:(Point2D *)point2D;

/**
     * @brief 将指定的多个点对象添加到此点集合对象的末尾。
     * @param point2DsArray 要添加到此点集合对象中的多个点对象。
     * @return 添加的多个点对象的个数。
     */
-(NSInteger)addRange:(NSMutableArray *)point2DsArray;

/**
     * @brief 将指定的点对象添加到此点集合的指定序号处。
     * @param index 要添加到的序号。
     * @param point2D 指定要添加的点对象。
     * @return 添加成功，返回 true；否则，返回 false。
     */
-(BOOL)insertIndex:(NSInteger)index Point2D:(Point2D *)point2D;

/**
     * @brief 将指定的多个点对象添加到此点集合中，从指定的序号开始依次添加。
     * @param index 添加对象的起始序号。
     * @param point2DArray 要添加的多个点对象。
     * @return 添加的点对象的个数。
     */
-(NSInteger)insertRange:(NSInteger)index Point2DArray:(NSMutableArray *)point2DArray;

/**
     * @brief  将此点集合对象中指定序号处的点对象删除。
     * @param index 要删除的点对象的序号。
     * @return 删除成功，返回 true；否则返回 false。
     */
-(BOOL)remove:(NSInteger)index;

/**
     *  @brief  将此点集合对象中从指定序号开始的指定个数的多个点对象删除。
     * @param index 删除对象的起始序号。
     * @param count 要删除的点对象的个数。
     * @return 删除的点对象的个数。
     */
-(NSInteger)removeRange:(NSInteger)index Count:(NSInteger)count;

/**
     * @brief  清除当前点集合对象中的所有元素。
     */
-(void)clear;
/**
 * @brief  将此点集合对象转换成为一个点对象的数组。
 */
-(NSMutableArray *)toArray;

@end

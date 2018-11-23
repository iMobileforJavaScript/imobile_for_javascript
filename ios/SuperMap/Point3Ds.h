//
//  Point3Ds.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#include "Point3D.h"
/// 用于表示精度为Double的三维点对象集合。 
@interface Point3Ds : NSObject

/// 获取三维点对象集合中对象的个数。 
@property(nonatomic,readonly)NSInteger count;

/// 构造一个新的 Point3Ds 对象。
- (id)init;

/**@brief 根据给定的 Point3Ds 对象构造一个与其完全相同的新对象。
 @param point3Ds - 给定的 Point3Ds 对象
 */
- (id)initWithPoint3Ds:(Point3Ds *)point3Ds;

/**@brief 根据指定的参数来构造一个 Point3Ds 的新对象。
 @param point3DArray - 给定的 Point3Ds 对象
 */
- (id)initWithPoint3DArray:(NSArray *)point3DArray;

/**@brief 根据指定的参数来构造一个 Point3Ds 的新对象。
 @param point3D - 给定的 Point3Ds 对象
 @return 向集合中添加三维点对象，添加成功返回被添加对象的序号。
 */
- (NSInteger)addPoint3D:(Point3D)point3D;

/**@brief 根据指定的参数来构造一个 Point3Ds 的新对象。
 @param point3DArray - 给定的 Point3Ds 对象
 */
- (void)addRange:(NSArray *)point3DArray;

/**@brief 将三维点集合对象转换为三维点对象数组。
 @return 此三维点集合对象转换得到的三维点对象的数组。
 */
- (NSArray *)toArray;

/**@brief 获取指定索引的三维点对象。
 * @param  index 指定的三维场景索引。
 * @return 指定索引的三维点对象。
 */
- (Point3D)itemofIndex:(NSInteger)index;
@end

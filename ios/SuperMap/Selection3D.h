//
//  Selection3D.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

@class Feature3D;


 ///三维选择集类。
@interface Selection3D : NSObject {
    Feature3D *_feature3D;
}

///将三维选择集清空，被选中的对象将全部恢复到未选中状态。
- (void)clear;

/**@brief 将三维图层中所选中的对象转换成三维要素对象。
 @return  三维要素对象。
 */
- (Feature3D *)toFeature3D;
/**@brief 返回三维选择集个数。
 @return  返回三维选择集个数。
 */
- (int)count;

/**
 *  @brief 向三维选择集中加入指定的对象，该对象从非选中状态变为选中状态
 *
 *  @param selectId 对象的ID
 *
 *  @return 返回对象在选择集中的索引
 */
- (int)add:(int)selectId;

/**
 *  @brief 根据给定的对象的系统ID值数组，向三维选择集中批量加入对象，这些对象将从非选中状态变为选中状态。
 *
 *  @param selectIds 对象ID数组
 *
 *  @return 新添加对象的个数
 */
- (int)addRange:(NSArray *)selectIds;

/**
 *  移除三维选择集中指定系统ID值的对象，该对象由原来的选中状态变为非选中状态。
 *
 *  @param selectId 对象的ID
 *
 *  @return 成功返回true，否则返回false
 */
- (BOOL)remove:(int)selectId;

- (int)getIDWithIndex:(NSInteger)index;

/*
** 刷新selection
*/
-(void)updateData;

@end

//
//  WeightFieldInfos.h
//  prjTest
//
//  Created by imobile on 14-2-12.
//  Copyright (c) 2014年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 权值字段信息集合类
 */
@class WeightFieldInfo,TransportationAnalystSetting,FacilityAnalystSetting;
@interface WeightFieldInfos : NSObject{

    NSMutableArray *m_weightFields;
    TransportationAnalystSetting *m_owner;
    FacilityAnalystSetting *m_owner2;
}

/**
 * @brief 根据给定的 WeightFieldInfos 对象构造一个与其完全相同的新对象。
 * @param weightInfos 指定的权值字段信息集合。
 */
-(id)initWith:(WeightFieldInfos *)weightFieldInfos;

/**
 * @brief 用于从权值字段信息集合移除全部权值字段信息对象。
 */
-(void)clear;

/**
 * @brief 用于在权值字段信息集合中加入一个元素。
 * @param value 要加入的权值字段信息对象。
 * @return 新添元素的序号。
 */
-(NSInteger)add:(WeightFieldInfo *)value;

/**
 * @brief 从权值字段信息集合中移除指定名称的项,被移除的项将被释放。
 * @param value 将要删除权值字段信息对象的名称。
 * @return 一个布尔值，若删除成功返回 true；否则返回 false。
 */
-(BOOL)removeWithName:(NSString *)value;

/**
 * @brief 用于从权值字段信息集合移除指定序号的权值字段信息对象。被移除的项将被释放。
 * @param index 将要删除元素的序号。
 * @return 一个布尔值，若删除成功返回 true；否则返回 false。
 */
-(BOOL)removeAt:(NSInteger)index;

/**
 * @brief 根据指定的名称，返回权值字段信息对象的序号。
 * @param name 要索引的 WeightFieldInfo 的名称。
 * @return 指定名称的权值字段信息对象在权值字段信息集合中的序号。
 */
-(NSInteger)indexOf:(NSString *)name;

/**
 * @brief 返回给定的权值字段信息集合中元素的总数。
 * @return 给定的权值字段信息集合中元素的总数。
 */
-(NSUInteger)getCount;

/**
 * @brief 根据 Index 返回权值字段信息集合对象中的权值字段信息对象。
 * @param index 指定的序号值，序号从0开始。
 * @return 权值字段信息集合对象中的权值字段信息对象。
 */
-(WeightFieldInfo *)get:(NSInteger)index;

/**
 * @brief 根据名称返回权值字段信息集合对象中的权值字段信息对象。
 * @param name 指定的名称。
 * @return 权值字段信息集合对象中的权值字段信息对象。
 */
-(WeightFieldInfo *)getWithName:(NSString *)name;

@end

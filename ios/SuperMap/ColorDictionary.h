//
//  ColorDictionary.h
//  LibUGC
//
//  Created by zyd on 16/11/30.
//  Copyright © 2016年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Color;

@interface ColorDictionary : NSObject

/* 获取所有键值 */
@property (nonatomic, readonly, copy) NSArray *allKeys;

/* 获取所有颜色 */
@property (nonatomic, readonly, copy) NSArray *allColors;

/* 获取颜色对照表中高程值与颜色值的对照项数量 */
@property (nonatomic, readonly, assign) NSInteger count;

/**
 @brief   初始化方法
 @return  本类的实例对象
 */
- (instancetype)init;

/**
 @brief   获取对照表项中key值对应的颜色值
 @param   键值
 @return  键值对应的颜色
 */
- (Color *)colorForKey:(double)key;

/**
 @brief   修改对照表项中key值对应的颜色值
 @param   color 颜色值, key 键值
 */
- (void)setColor:(Color *)color forKey:(double)key;

/**
 @brief   在对照表项中移除值为key的项
 @param   键值
 */
- (void)removeColorForKey:(double)key;

/**
 @brief   清空对照表项
 */
- (void)clear;

@end

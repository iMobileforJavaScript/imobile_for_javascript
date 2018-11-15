//
//  HypsometricSetting.h
//  LibUGC
//
//  Created by zyd on 16/11/30.
//  Copyright © 2016年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HypsometricSettingDisplayMode.h"

@class Geometry;
@class ColorDictionary;

@interface HypsometricSetting : NSObject

/* 获取或设置线的间隔 */
@property (nonatomic, assign) double interval;

/* 获取或设置绘制的多边形区域, 支持任意多边形 */
@property (nonatomic, strong) Geometry *region;

/* 获取或设置不透明度 */
@property (nonatomic, assign) double opacity;

/* 获取或设置显示风格 */
@property (nonatomic, assign) HypsometricSettingDisplayMode displayMode;

/* 获取或设置最小可见值 */
@property (nonatomic, assign) double minVisibleValue;

/* 获取或设置最大可见值 */
@property (nonatomic, assign) double maxVisibleValue;

/* 获取或设置颜色对照表 */
@property (nonatomic, strong) ColorDictionary *colorDictionary;

/**
 @brief   初始化方法
 @return  本类的实例化对象
 */
- (instancetype)init;

@end

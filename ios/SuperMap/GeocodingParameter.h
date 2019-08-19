//
//  GeocodingParameter.h
//  LibUGC
//
//  Created by wnmng on 2017/9/14.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CoordinateType.h"

@interface GeocodingParameter : NSObject

/**
 * 地理编码分析描述 必设参数
 */
@property (nonatomic,strong) NSString* landmark;

/**
 * 地理编码分析城市范围
 */
@property (nonatomic,strong) NSString* city;

/**
 * 返回匹配结果数量
 */
@property (nonatomic,assign) int maxResult;

/**
 * 获取坐标类型
 */
@property (nonatomic,assign) CoordinateType type;

@end

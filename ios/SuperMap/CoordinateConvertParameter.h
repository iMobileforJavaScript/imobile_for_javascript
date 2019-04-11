//
//  CoordinateConvertParameter.h
//  LibUGC
//
//  Created by wnmng on 2017/9/14.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoordinateType.h"

@class Point2Ds;

@interface CoordinateConvertParameter : NSObject

/**
 * 必设参数
 * 预转化的坐标，支持批量转换。
 * 批量支持坐标个数以HTTP GET 方法请求上限为准
 * @param locationList
 */
@property (nonatomic,strong) Point2Ds *point2Ds;

/**
 * 必设参数
 * 输入的Point2D的坐标类型
 * @param srcType
 */
@property (nonatomic,assign) CoordinateType srcType;

/**
 * 必设参数
 * 转换的目标坐标类型
 * @param desType
 */
@property (nonatomic,assign) CoordinateType desType;


@end

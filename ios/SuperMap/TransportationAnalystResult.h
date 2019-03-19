//
//  TransportationAnalystResult.h
//  LibUGC
//
//  Created by esupermap on 14-2-27.
//  Copyright (c) 2014年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransportationAnalystResult : NSObject

/**
 * @brief 返回分析结果的途经弧段集合。
 */
@property(nonatomic,retain,readonly)NSMutableArray *edges;

/**
 * @brief 返回分析结果的途经结点集合。
 */
@property(nonatomic,retain,readonly)NSMutableArray *nodes;

/**
 * @brief  返回站点索引的二维数组，该数组反映了站点在分析后的排列顺序。
 */
@property(nonatomic,retain,readonly)NSMutableArray *stops;

/**
 * @brief  返回分析结果的路由对象集合（GeoLineM 的集合）。
 */
@property(nonatomic,retain,readonly)NSMutableArray *routes;

/**
 * @brief  返回行驶导引集合。
 */
@property(nonatomic,retain,readonly)NSMutableArray *pathGuides;

/**
 * @brief  返回代表花费的权值数组。
 */
@property(nonatomic,retain,readonly)NSMutableArray *weights;

/**
 * @brief  返回根据站点索引对站点排序后，站点间的花费（权值）。
 */
@property(nonatomic,retain,readonly)NSMutableArray *stopWeights;

-(void)dispose;
@end

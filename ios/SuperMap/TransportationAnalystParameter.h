//
//  TransportationAnalystParameter.h
//  LibUGC
//
//  Created by esupermap on 14-2-27.
//  Copyright (c) 2014年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Point2Ds;
@interface TransportationAnalystParameter : NSObject

/**
 * @brief 获取或设置分析时途经结点 ID 的集合。
 */
@property(nonatomic,retain)NSMutableArray *nodes;
/**
 * @brief 获取或设置分析时途经点的集合。
 */
@property(nonatomic,retain)Point2Ds *points;
/**
 * @brief 获取或设置权值字段信息的名称。
 */
@property(nonatomic,retain)NSString *weightName;
/**
 * @brief 获取或设置障碍结点 ID 列表。
 */
@property(nonatomic,retain)NSMutableArray *barrierNodes;
/**
 * @brief 获取或设置障碍弧段 ID 列表。
 */
@property(nonatomic,retain)NSMutableArray *barrierEdges;
/**
 * @brief 获取或设置障碍结点的坐标列表。
 */
@property(nonatomic,retain)Point2Ds *barrierPoints;
/**
 * @brief 获取或设置转向权值字段。
 */
@property(nonatomic,retain)NSString *turnWeightField;
/**
 * @brief 获取或设置分析结果中是否包含路由（GeoLineM）对象的集合。
 */
@property(nonatomic)BOOL isRoutesReturn;
/**
 * @brief 获取或设置分析结果中是否包含途经结点的集合。
 */
@property(nonatomic)BOOL isNodesReturn;
/**
 * @brief 获取或设置分析结果中是否包含途经弧段集合。
 */
@property(nonatomic)BOOL isEdgesReturn;
/**
 * @brief 获取或设置分析结果中是否包含行驶导引集合。
 */
@property(nonatomic)BOOL isPathGuidesReturn;
/**
 * @brief 获取或设置分析结果中是否要包含站点索引的集合。
 */
@property(nonatomic)BOOL isStopsReturn;

/**
 * @brief 根据给定的 TransportationAnalystParameter 对象构造一个与其完全相同的新对象。
 */
-(id)initWith:(TransportationAnalystParameter *)transportationAnalystParameter;

-(void)dispose;

@end

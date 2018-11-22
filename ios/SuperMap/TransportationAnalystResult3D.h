//
//  TransportationAnalystResult3D.h
//  DynamicView
//
//  Created by imobile-xzy on 16/3/26.
//  Copyright © 2016年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GeoLine3D;
@interface TransportationAnalystResult3D : NSObject

/**
 * 返回分析结果的路线对象集合（GeoLineM的集合）
 * @return GeoLineM[]
 */
-(NSArray*)getRoutes;

/**
 * 返回分析结果的经过节点的Id集合。二维Int32数组
 * @return int[][]
 */
-(NSArray*)getNodes;

/**
 * 返回分析结果的经过弧段的集合。二维Int32数组
 * @return int[][]
 */
-(NSArray*)getEdges;

/**
 * 返回站点索引的集合，二维Int32数组
 * @return int[][]
 */
-(NSArray*)getStopIndexes;

/**
 * 返回分析经过站点的花费
 * @return
 */
-(NSArray*)getStopWeights;

/**
 * 返回分析花费的集合
 * @return double[]
 */
-(NSArray*)getWeights;

-(void)dispose;
@end

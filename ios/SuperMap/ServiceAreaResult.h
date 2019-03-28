//
//  ServiceAreaResult.h
//  LibUGC
//
//  Created by esupermap on 14-2-27.
//  Copyright (c) 2014年 beijingchaotu. All rights reserved.
//

#import "TransportationAnalystResult.h"

@interface ServiceAreaResult : TransportationAnalystResult

/**
 * @brief 返回分析结果的服务区面对象集合。
 * @return 分析结果的服务区面对象集合。
 */
-(NSMutableArray *)getServiceRegions;
/**
 * @brief 返回服务区分析结果中的每个服务区的 Route 个数的一个数组。数组元素的顺序与中心点的指定顺序一致。
 * @return 每个服务区的 Route 个数的一个数组。
 */
-(NSMutableArray *)getServiceRouteCounts;

-(void)dispose;

@end

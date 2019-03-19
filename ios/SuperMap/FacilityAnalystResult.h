//
//  FacilityAnalystResult.h
//  prjTest
//
//  Created by imobile on 14-2-12.
//  Copyright (c) 2014年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 设施网络分析结果类,该类用于获取查找源和汇、上下游追踪以及查找路径等设施网络分析的结果
 */
@interface FacilityAnalystResult : NSObject

/**
 * 获取结果路径经过的节点ID数组
 */
@property(nonatomic,retain,readonly)NSArray *nodes;

/**
 * 获取结果路径经过的弧段ID数组
 */
@property(nonatomic,retain,readonly)NSArray *edges;

/**
 * 获取结果路径经过的总耗费值
 */
@property(nonatomic,readonly)double dCost;

-(id)initWith:(NSArray *)nodes edges:(NSArray *)edges cost:(double)cost;
@end

//
//  PolymerOnlineChart.h
//  HotMap
//
//  Created by imobile-xzy on 17/7/3.
//  Copyright © 2017年 imobile-xzy. All rights reserved.
//

#import "DistributeAnalyst.h"
@class Rectangle2D;
/**
*  在线聚合分析类
*/
@interface AggreatePointsOnline : DistributeAnalyst
/**
 * 网格大小
 */
@property(nonatomic)double resolution;
/**
 * 统计模式
 *<p>统计模式支持：max 最大值,min 最小值,average 平均值,sum 求和,variance 方差,stdDeviation 标准差。“统计模式”个数应与“权重值字段”个数一致</p>
 */
@property(nonatomic,strong)NSString* statisticModes;
/**
 * 权值索引
 */
@property(nonatomic)NSString* weight;
/**
 * 网络面类型
 * <p>网格面类型支持四边形网格和六边形网格。其中0：代表四边形网格 1：代表六边形网格。</p>
 */
@property(nonatomic)int meshType;
/**
 * 网格单位
 *<p>网格大小单位有：Meter(默认),Kilometer,Yard,Foot,Mile</p>
 */
@property(nonatomic,strong)NSString* meshSizeUnit;

/**
 * 聚合类型。
 * <p>聚合类型支持 "SUMMARYMESH" 网格面聚合、"SUMMARYREGION" 多边形聚合。</p>
 */
@property(nonatomic,strong)NSString* aggregateType;

/**
 * 聚合面数据集。
 */
@property(nonatomic,strong)NSString* regionDataset;

/**
 * 数据路径
 */
@property(nonatomic,strong)NSString* dataPath;
/**
 * 分析范围
 */
@property(nonatomic,strong)Rectangle2D* bounds;
/**
 * 数字精度 默认为 1
 */
@property(nonatomic)NSInteger numericPrecision;

@end

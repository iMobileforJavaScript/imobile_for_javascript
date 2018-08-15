//
//  FeatureJoinOnline.h
//  900bSources_ugc2_92
//
//  Created by lucd on 2018/2/23.
//  Copyright © 2018年 supermap. All rights reserved.
//
#import "DistributeAnalyst.h"
/**
 * 在线要素连接
 */
@interface FeatureJoinOnline : DistributeAnalyst
/**
 * 设置/获取源数据集
 */
@property (nonatomic,strong)NSString *datasetSource;
/**
 * 设置/获取需要连接数据集
 */
@property (nonatomic,strong)NSString *datasetFeatureJoin;
/**
 * 设置/获取连接方式
 * <p>JOINONETOONE(一对一)、JOINONETOMANY(一对多)</p>
 */
@property (nonatomic,strong)NSString *joinOperation;
/**
 * 设置/获取连接字段
 *
 */
@property (nonatomic,strong)NSString *joinFields;
/**
 * 设置/获取数字精度 默认为1
 *
 */
@property (nonatomic)NSInteger numericPrecision;
/**
 * 设置/获取容限
 *
 */
@property (nonatomic)NSInteger tolerance;
/**
 * 设置属性统计字段和属性统计模式
 * @param summaryFields 属性统计字段
 * @param summaryMode 属性统计模式
 * <p>统计模式有：max,min,average,sum,variance,stdDeviation </p>
 */
-(void) setSummaryFields:(NSString *) summaryFields summaryMode:(NSString *)summaryMode;
/**
 * 设置空间关联条件
 * @param spatialRelationshipMode 空间关联条件
 * <p>空间关联条件有：NEAR邻近 CONTAIN包含 CROSS交叉 INTERSECT相交 OVERLAP重叠 TOUCH邻接 DISJOINT不相交 IDENTITY同一 WITHIN被包含 </p>
 */
-(void) setSpatialRelationshipMode:(NSString *)spatialRelationshipMode;
/**
 * 设置空间距离单位 默认为KILOMETER
 * @param spatialDistanceUnit 空间距离单位
 * <p>空间距离单位有：KILOMETER千米 METER米 FOOT英尺 MILE英里 YARD码 </p>
 */
-(void) setSpatialDistanceUnit:(NSString *)spatialDistanceUnit;
/**
 * 设置空间距离
 * @param spatialDistance 空间距离
 */
-(void) setSpatialDistance:(NSInteger)spatialDistance;
/**
 * 设置时间关联条件
 * @param temporalRelationshipMode 时间关联条件
 * <p>时间关联条件有：NEAR邻近 AFTER之后 BEFORE之前 CONTAINS包含 DURING期间 FINISHES终止 MEETS相接 FINISHEDBY被终止 METBY被相接 OVERLAPS重叠 OVERLAPPEDBY被重叠 STARTS起始 STARTEDBY被起始 EQUALS相同</p>
 */
-(void) setTemporalRelationshipMode:(NSString *)temporalRelationshipMode;
/**
 * 设置时间距离单位 默认为HOURS
 * @param temporalDistanceUnit 时间距离单位
 * <p>时间距离单位有：HOUR小时 MILLISECOND毫秒 SECOND秒 MINUTE分钟 DAY天  WEEK周 MONTH月 YEAR年</p>
 */
-(void) setTemporalDistanceUnit:(NSString *)temporalDistanceUnit;
/**
 * 设置时间距离
 * @param temporalDistance 时间距离
 */
-(void) setTemporalDistance:(NSInteger)temporalDistance;
/**
 * 设置数据源集时间属性字段和连接数据集时间属性字段
 * @param datasetSource 数据源集时间属性字段
 * @param featureJoin 连接数据集时间属性字段
 */
-(void) setTemporalSpecFieldsWithDataset:(NSString *)datasetSource featureJoin:(NSString *)featureJoin;
/**
 * 设置属性关联字段和属性关联模式
 * @param attributeRelationshipFields 属性关联字段
 * @param attributeMode 属性关联模式
 * <p>属性关联模式有：EQUAL相等 NOTEQUAL不相等</p>
 */
-(void) setAttributeRelationshipFields:(NSString *)attributeRelationshipFields attributeMode:(NSString *)attributeMode;
@end

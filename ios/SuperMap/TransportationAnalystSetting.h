//
//  TransportationAnalystSetting.h
//  prjTest
//
//  Created by imobile on 14-2-13.
//  Copyright (c) 2014年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 交通网络分析环境设置类。该类用于提供交通网络分析时所需要的所有参数信息
 */

@class DatasetVector,WeightFieldInfos;
@interface TransportationAnalystSetting : NSObject

/**
 * @brief 获取或设置用于分析的网络数据集。
 */
@property(nonatomic,retain)DatasetVector *networkDataset;

/**
 * @brief 获取或设置障碍结点的ID列表。
 */
@property(nonatomic,retain)NSMutableArray *barrierNodes;

/**
 * @brief 获取或设置障碍弧段的ID列表。
 */
@property(nonatomic,retain)NSMutableArray *barrierEdges;

/**
 * @brief 获取或设置交通网络分析中弧段过滤表达式。
 */
@property(nonatomic,retain)NSString *edgeFilter;

/**
 * @brief 获取或设置网络数据集中标志弧段ID的字段。
 */
@property(nonatomic,retain)NSString *edgeIDField;

/**
 * @brief 获取或设置存储弧段名称的字段。
 */
@property(nonatomic,retain)NSString *edgeNameField;

/**
 * @brief 获取或设置网络数据集中标志弧段起始结点ID的字段。
 */
@property(nonatomic,retain)NSString *fNodeIDField;

/**
 * @brief 获取或设置用于表示正向单行线的字符串的数组。
 */
@property(nonatomic,retain)NSMutableArray *fTSingleWayRuleValues;

/**
 * @brief 获取或设置网络数据集中标识结点ID的字段。
 */
@property(nonatomic,retain)NSString *nodeIDField;

/**
 * @brief 获取或设置存储结点名称的字段的字段名。
 */
@property(nonatomic,retain)NSString *nodeNameField;

/**
 * @brief 获取或设置用于表示禁行线的字符串的数组。
 */
@property(nonatomic,retain)NSMutableArray *prohibitedWayRuleValues;

/**
 * @brief 获取或设置网络数据集中表示网络弧段的交通规则的字段。
 */
@property(nonatomic,retain)NSString *ruleField;

/**
 * @brief 获取或设置用于表示逆向单行线的字符串的数组。
 */
@property(nonatomic,retain)NSMutableArray *tFSingleWayRuleValues;

/**
 * @brief 获取或设置网络数据集中标志弧段终止结点ID的字段。
 */
@property(nonatomic,retain)NSString *tNodeIDField;

/**
 * @brief 获取或设置点到弧段的距离容限。
 */
@property(nonatomic)double tolerance;

/**
 * @brief 获取或设置转向表数据集。
 */
@property(nonatomic,retain)DatasetVector *turnDataset;

/**
 * @brief 获取或设置转向起始弧段ID的字段。
 */
@property(nonatomic,retain)NSString *turnFEdgeIDField;

/**
 * @brief 获取或设置转向结点ID的字段。
 */
@property(nonatomic,retain)NSString *turnNodeIDField;

/**
 * @brief 获取或设置转向终止弧段ID的字段。
 */
@property(nonatomic,retain)NSString *turnTEdgeIDField;

/**
 * @brief 获取或设置转向权值字段集合。
 */
@property(nonatomic,retain)NSMutableArray *turnWeightFields;

/**
 * @brief 获取或设置用于表示双向通行线的字符串的数组。
 */
@property(nonatomic,retain)NSMutableArray *twoWayRuleValues;

/**
 * @brief 获取或设置权值字段信息集合对象。
 */
@property(nonatomic,retain)WeightFieldInfos *weightFieldInfos;

/**
 * @brief 构造一个新的交通网络分析环境设置对象。
 */
-(id)init;

/**
 * @brief 根据给定的交通网络分析环境设置对象构造一个与其完全相同的新对象。
 * @param networkAnalystSetting 给定的交通网络分析环境设置对象。
 */
-(id)initWith:(TransportationAnalystSetting *)networkAnalystSetting;
@end

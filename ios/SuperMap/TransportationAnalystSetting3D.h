//
//  TransportationAnalystSetting3D.h
//  DynamicView
//
//  Created by imobile-xzy on 16/3/26.
//  Copyright © 2016年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>


@class DatasetVector,WeightFieldInfos3D;

@interface TransportationAnalystSetting3D : NSObject


-(id)initWith:(TransportationAnalystSetting3D*)networkAnalystSetting;

/**
 * 返回网络数据集
 * @return DatasetVector
 */
@property(nonatomic,strong)DatasetVector* networkDataset;

/**
 * 返回节点ID字段
 * @return String
 */
@property(nonatomic,strong)NSString* nodeIDField;

/**
 * 返回弧段ID字段
 * @return String
 */
@property(nonatomic,strong)NSString* edgeIDField;

/**
 * 返回弧段起始结点ID的字段
 * @return String
 */
@property(nonatomic,strong)NSString* fNodeIDField;

/**
 * 返回弧段终止结点ID的字段
 * @return String
 */
@property(nonatomic,strong)NSString* tNodeIDField;

/**
 * 返回权值信息集合对象,类型为WeightFieldInfos，该属性的设置是为了使分析支持多线程
 * @return WeightFieldInfos
 */
@property(nonatomic,strong)WeightFieldInfos3D* weightFieldInfos;

/**
 * 返回点到弧段的距离容限
 * @return double
 */
@property(nonatomic)double tolerance;

/**
 * 返回障碍节点ID列表
 * @return int[]
 */
@property(nonatomic,strong)NSArray* barrierNodes;

/**
 * 返回障碍弧段ID列表
 * @return int[]
 */
@property(nonatomic,strong)NSArray* barrierEdges;

/**
 * 返回转向表数据集
 * @return DatasetVector
 */
@property(nonatomic,strong)DatasetVector* turnDataset;

/**
 * 返回转向节点ID字段
 * @return String
 */
@property(nonatomic,strong)NSString* turnNodeIDField;

/**
 * 返回转向起始弧段ID字段
 * @return String
 */
@property(nonatomic,strong)NSString* turnFEdgeIDField;

/**
 * 返回转向终止弧段ID字段
 * @return String
 */
@property(nonatomic,strong)NSString* turnTEdgeIDField;

/**
 * 返回转向花费字段集合
 * @return String[]
 */
@property(nonatomic,strong)NSArray* turnWeightFields;

/**
 * 返回节点的Name字段名称
 * @return String
 */
@property(nonatomic,strong)NSString* nodeNameField;

/**
 * 返回弧段的Name字段名称
 * @return String
 */
@property(nonatomic,strong)NSString* edgeNameField;

/**
 * 返回交通规则字段名称
 * @return String
 */
@property(nonatomic,strong)NSString* ruleField;

/**
 * 返回用于表示正向单行线的字符串的数组,
 * 即RuleField字段的值是数组其中的一项的值的时候，表示的是正向单行线。
 * @return String[]
 */
@property(nonatomic,strong)NSArray* ftSingleWayRuleValues;

/**
 * 返回/设置用于表示逆向单行线的字符串的数组，
 * 即RuleField字段的值是数组其中的一项的值的时候，表示的是逆向单行线。
 * @return String[]
 */
@property(nonatomic,strong)NSArray* tfSingleWayRuleValues;

/**
 * 返回/设置用于表示禁行线的字符串的数组，
 * 即RuleField字段的值是数组其中的一项的值的时候，表示的是禁行线。
 * @return String[]
 */
@property(nonatomic,strong)NSArray* prohibitedWayRuleValues;

/**
 * 返回/设置用于表示双向通行线的字符串的数组,
 * 即RuleField字段的值是数组其中的一项的值的时候，表示的是双向通行线。
 * @return String[]
 */
@property(nonatomic,strong)NSArray* twoWayRuleValues;

@property(nonatomic,strong)NSString* edgeFilter;

@property(nonatomic)BOOL needSet;
@property(nonatomic)BOOL needLoadModel;
@property(nonatomic)BOOL needLoadTurnModel;

-(void)copyFrom:(TransportationAnalystSetting3D*) value;
@end

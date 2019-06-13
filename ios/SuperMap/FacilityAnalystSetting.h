//
//  FacilityAnalystSetting.h
//  prjTest
//
//  Created by imobile on 14-2-12.
//  Copyright (c) 2014年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 设施网络分析环境设置类,该类用于提供设施网络分析时所需要的所有参数信息
 */

@class DatasetVector,WeightFieldInfos;
@interface FacilityAnalystSetting : NSObject

/**
 * @brief 获取或设置网络数据集。
 */
@property(nonatomic,retain)DatasetVector *netWorkDataset;

/**
 * @brief 获取或设置网络数据集中标识网络结点ID的字段。
 */
@property(nonatomic,retain)NSString *nodeIDField;

/**
 * @brief 获取或设置网络数据集中标识弧段ID的字段。
 */
@property(nonatomic,retain)NSString *edgeIDField;

/**
 * @brief 获取或设置网络数据集中标识弧段起始结点ID的字段。
 */
@property(nonatomic,retain)NSString *fNodeIDField;

/**
 * @brief 获取或设置网络数据集中标识弧段终止结点ID的字段。
 */
@property(nonatomic,retain)NSString *tNodeIDField;

/**
 * @brief 获取或设置点到弧段的距离容限。
 */
@property(nonatomic)double tolerance;

/**
 * @brief 获取或设置障碍结点的ID列表。
 */
@property(nonatomic,retain)NSMutableArray *barrierNodes;

/**
 * @brief 获取或设置障碍弧段的ID列表。
 */
@property(nonatomic,retain)NSMutableArray *barrierEdges;

/**
 * @brief 获取或设置流向字段。
 */
@property(nonatomic,retain)NSString *directionField;

/**
 * @brief 获取或设置权值字段信息集合对象。
 */
@property(nonatomic,retain)WeightFieldInfos *weightFieldInfos;

/**
 * @brief 构造一个新的设施网络分析环境设置对象。
 */
-(id)init;

/**
 * @brief 根据给定的设施网络分析环境设置对象构造一个与其完全相同的新对象。
 * @param facilityAnalystSetting 给定的设施网络分析环境设置对象。
 */
-(id)initWith:(FacilityAnalystSetting *)facilityAnalystSetting;

@end

//
//  TransportationAnalyst.h
//  LibUGC
//
//  Created by esupermap on 14-2-27.
//  Copyright (c) 2014年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TransportationAnalystSetting,TransportationAnalystResult,TransportationAnalystParameter,Point2D,Point2Ds,ServiceAreaResult,TransportationAnalystCheckResult;
@class DatasetVector;  
@interface TransportationAnalyst : NSObject

/**
 * @brief 设置或获取交通网络分析环境设置对象。
 */
@property(nonatomic,retain)TransportationAnalystSetting *analystSetting;

/**
 * @brief 加载网络模型。
 */
-(BOOL)load;
/**
 * @brief 更新弧段的权值。
 */
-(double)updateEdgeWeight:(NSInteger)edgeID fromNodeID:(NSInteger)fromNodeID toNodeID:(NSInteger)toNodeID weightName:(NSString *)weightName weight:(double)weight;
/**
 * @brief 更新转向节点的权值。
 */
-(double)updateTurnNodeWeight:(NSInteger)nodeID fromEdgeID:(NSInteger)fromEdgeID toEdgeID:(NSInteger)toEdgeID turnWeightField:(NSString *)turnWeightField weight:(double)weight;
/**
 * @brief 最佳路径分析。
 */
-(TransportationAnalystResult *)findPath:(TransportationAnalystParameter *)parameter hasLeastEdgeCount:(BOOL)hasLeastEdgeCount;
/**
 * @brief  旅行商分析。
 */
-(TransportationAnalystResult *)findTSPPath:(TransportationAnalystParameter *)parameter isEndNodeAssigned:(BOOL)isEndNodeAssigned;
/**
 * @brief  根据指定的参数进行最近设施查找分析，事件点为结点 ID。
 */
-(TransportationAnalystResult *)findClosestFacility:(TransportationAnalystParameter *)parameter eventID:(NSInteger)eventID facilityCount:(NSInteger)facilityCount isFromEvent:(BOOL)isFromEvent maxWeight:(double)maxWeight;
/**
 * @brief 根据指定的参数进行最近设施查找分析，事件点为坐标点。
 */
-(TransportationAnalystResult *)findClosestFacility:(TransportationAnalystParameter *)parameter eventPoint:(Point2D *)eventPoint facilityCount:(NSInteger)facilityCount isFromEvent:(BOOL)isFromEvent maxWeight:(double)maxWeight;
/**
 * @brief  多旅行商（物流配送）分析，配送中心为结点 ID 数组。
 */
-(TransportationAnalystResult *)findMTSPPath:(TransportationAnalystParameter *)parameter centerNodes:(NSMutableArray *)centerNodes hasLeastTotalCost:(BOOL)hasLeastTotalCost;
/**
 * @brief  多旅行商（物流配送）分析，配送中心为点坐标串。
 */
-(TransportationAnalystResult *)findMTSPPath:(TransportationAnalystParameter *)parameter centerPoints:(Point2Ds *)centerPoints hasLeastTotalCost:(BOOL)hasLeastTotalCost;
/**
 * @brief 服务区分析。
 */
-(ServiceAreaResult *)findServiceArea:(TransportationAnalystParameter *)parameter weights:(NSMutableArray *)weights isFromCenter:(BOOL)isFromCenter isCenterMutuallyExclusive:(BOOL)isCenterMutuallyExclusive;
/**
 * @brief 返回距离矩阵。
 */
-(NSMutableArray *)computeWeightMatrix:(TransportationAnalystParameter *)parameter;
/**
 * @brief 对交通网络数据集和转向表进行数据检查，返回交通网络分析数据检查结果对象。
 */
-(TransportationAnalystCheckResult *)check;

-(void)dispose;

-(BOOL) createModel:(NSString *)fileName;

-(BOOL) loadModelWithFilePath:(NSString *)filePath datasetVector:(DatasetVector *)networkDataset;

@end

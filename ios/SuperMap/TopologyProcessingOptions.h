//
//  TopologyProcessingOptions.h
//  Objects_iOS
//
//  Created by zhouyuming on 2019/10/8.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Recordset;

typedef enum{
   
    AVF_NONE = 1,
    AVF_ARC = 2,
    AVF_VERTEX = 3,
    AVF_ARC_AND_VERTEX = 4,
    AVF_ARC_OR_VERTEX = 5,
}ArcAndVertexFilterMode;

@interface TopologyProcessingOptions : NSObject

/**
 *是否去除假节点
 */
@property(nonatomic,readwrite)BOOL pseudoNodesCleaned;
/**
 *是否去除短悬线
 */
@property(nonatomic,readwrite)BOOL overshootsCleaned;
/**
 *是否去除冗余点
 */
@property(nonatomic,readwrite)BOOL redundantVerticesCleaned;
/**
 *是否进行长悬线延伸
 */
@property(nonatomic,readwrite)BOOL undershootsExtended;
/**
 *是否去除重复线
 */
@property(nonatomic,readwrite)BOOL duplicatedLinesCleaned;
/**
 *是否进行弧段求交
 */
@property(nonatomic,readwrite)BOOL linesIntersected;
/**
 *是否进行邻近端点合并
 */
@property(nonatomic,readwrite)BOOL adjacentEndpointsMerged;
/**
 *
 */
@property(nonatomic,readwrite)double overshootsTolerance;
/**
 *
 */
@property(nonatomic,readwrite)double undershootsTolerance;
/**
 *节点容限
 */
@property(nonatomic,readwrite)double nodeTolerance;
/**
 *非打断线点记录集
 */
@property(nonatomic,readwrite)Recordset* filterVertexRecordset;
/**
 *非打断线过滤条件
 */
@property(nonatomic,readwrite)NSString* arcFilterString;
/**
 *非打断线过滤条件
 */
@property(nonatomic,readwrite)ArcAndVertexFilterMode filterMode;

- (id)init;

- (id)initWithTopologyProcessingOptions:(TopologyProcessingOptions*) options;

@end

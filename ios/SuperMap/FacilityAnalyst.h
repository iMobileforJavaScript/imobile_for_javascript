//
//  FacilityAnalyst.h
//  prjTest
//
//  Created by imobile on 14-2-12.
//  Copyright (c) 2014年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 设施网络分析类，主要用于进行各类连通性分析和追踪分析
 */
@class FacilityAnalystSetting,FacilityAnalystResult;
@interface FacilityAnalyst : NSObject

@property(nonatomic,retain)FacilityAnalystSetting *analystSetting;

/**
 * 加载网络模型。根据分析环境对象中的环境参数，加载网络模型，该方法在设置完AnalystSetting后调用
 * @return boolean
 */
-(BOOL)load;
/**
 * 根据节点ID数组查找与节点连接的环路，返回环路ID数组
 *
 * @param nodeIDs 传入的节点ID数组
 * @return 返回环路弧段ID数组
 */
-(NSMutableArray *)findLoopsFromNodes:(NSMutableArray *)nodeIDs;

/**
 * 根据弧段ID数组查找与弧段连接的环路，返回环路ID数组
 * @param edgeIDs
 */
-(NSMutableArray *)findLoopsFromEdges:(NSMutableArray *)edgeIDs;

/**
 * 传入节点ID数组，查找与节点相连通的弧段ID数组
 */
-(NSMutableArray *)findConnectedEdgesFromNodes:(NSMutableArray *)nodeIDs;

/**
 * 传入弧段ID数组，查找与弧段相连通的弧段ID数组
 */
-(NSMutableArray *)findConnectedEdgesFromEdges:(NSMutableArray *)edgeIDs;

/**
 * 传入节点ID数组，查找与节点不相连通的弧段ID数组
 */
-(NSMutableArray *)findUnconnectedEdgesFromNodes:(NSMutableArray *)nodeIDs;

/**
 * 传入弧段ID数组，查找与弧段不相连通的弧段ID数组
 */
-(NSMutableArray *)findUnconnectedEdgesFromEdges:(NSMutableArray *)edgeIDs;

/**
 * 传入节点ID数组，返回这些节点的共同上游弧段ID数组
 */
-(NSMutableArray *)findCommonAncestorsFromNodes:(NSMutableArray *)nodeIDs isUncertainDirectionValid:(BOOL)isUncertainDirectionValid;

/**
 * 传入弧段ID数组，返回这些弧段的共同上游弧段ID数组
 */
-(NSMutableArray *)findCommonAncestorsFromEdges:(NSMutableArray *)edgeIDs isUncertainDirectionValid:(BOOL)isUncertainDirectionValid;

/**
 * 传入节点ID数组，返回这些节点的共同下游弧段ID数组
 */
-(NSMutableArray *)findCommonCatchmentsFromNodes:(NSMutableArray *)nodeIDs isUncertainDirectionValid:(BOOL)isUncertainDirectionValid;

/**
 * 传入弧段ID数组，返回这些弧段的共同下游弧段ID数组
 */
-(NSMutableArray *)findCommonCatchmentsFromEdges:(NSMutableArray *)edgeIDs isUncertainDirectionValid:(BOOL)isUncertainDirectionValid;
/**
 * 基于节点查找源头，传入节点ID，返回从节点到源头之间的弧段ID数组
 */
-(FacilityAnalystResult *)findSourceFromNode:(NSInteger) nodeID weightName:(NSString *)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid;

/**
 * 基于弧段查找源头，传入弧段ID，返回从分析弧段到源头之间的弧段ID数组
 */
-(FacilityAnalystResult *)findSourceFromEdge:(NSInteger)edgeID weightName:(NSString *)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid;

/**
 * 基于节点查找交汇，传入节点ID，返回从节点到交汇之间的弧段ID数组
 */
-(FacilityAnalystResult *)findSinkFromNode:(NSInteger) nodeID weightName:(NSString *)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid;
/**
 * 基于弧段查找交汇，传入弧段ID，返回从分析弧段到交汇之间的弧段ID数组
 */
-(FacilityAnalystResult *)findSinkFromEdge:(NSInteger)edgeID weightName:(NSString *)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid;

/**
 * 上游追踪，返回从分析点上游追踪所流经弧段ID数组
 */
-(FacilityAnalystResult *)traceUpFromNode:(NSInteger) nodeID weightName:(NSString *)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid;

/**
 * 基于弧段上游追踪，返回上游追踪流经的弧段ID数组
 */
-(FacilityAnalystResult *)traceUpFromEdge:(NSInteger)edgeID weightName:(NSString *)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid;

/**
 * 下游追踪，返回从分析点下游追踪所流经弧段ID数组
 */
-(FacilityAnalystResult *)traceDownFromNode:(NSInteger) nodeID weightName:(NSString *)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid;
/**
 * 基于弧段下游追踪，返回下游追踪流经的弧段ID数组
 */
-(FacilityAnalystResult *)traceDownFromEdge:(NSInteger)edgeID weightName:(NSString *)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid;

/**
 * 检查网络环路，返回环路弧段ID数组
 */
-(NSMutableArray *)checkLoops;

/**
 * 设施网络路径分析，传入起始和终止节点ID。
 */
-(FacilityAnalystResult *)findPathFromNodes:(NSInteger)startNodeID endNodeID:(NSInteger)endNodeID weightName:(NSString *)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid;
/**
 * 设施网络路径分析，传入起始和终止弧段ID，查询最短路径（或弧段数最少）。
 */
-(FacilityAnalystResult *)findPathFromEdges:(NSInteger)startEdgeID endEdgeID:(NSInteger)endEdgeID weightName:(NSString *)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid;

/**
 * 设施网络上游路径分析，传入查询节点ID，沿上游查询最短路径（或弧段数最少）。
 */
-(FacilityAnalystResult *)findPathUpFromNode:(NSInteger)nodeID weightName:(NSString *)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid;

/**
 * 设施网络上游路径分析，传入查询弧段ID，沿上游查询最短路径（或弧段数最少）。
 */
-(FacilityAnalystResult *)findPathUpFromEdge:(NSInteger)edgeID weightName:(NSString *)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid;

/**
 * 设施网络下游路径分析，传入查询节点ID，沿下游查询最短路径（或弧段数最少）。
 */
-(FacilityAnalystResult *)findPathDownFromNode:(NSInteger)nodeID weightName:(NSString *)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid;

/**
 * 设施网络下游路径分析，传入查询弧段ID，沿下游游查询最短路径（或弧段数最少）。
 */
-(FacilityAnalystResult *)findPathDownFromEdge:(NSInteger)edgeID weightName:(NSString *)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid;

-(void)dispose;

@end

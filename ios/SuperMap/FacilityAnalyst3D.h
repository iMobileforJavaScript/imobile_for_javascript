//
//  FacilityAnalyst3D.h
//  DynamicView
//
//  Created by imobile-xzy on 16/3/26.
//  Copyright © 2016年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacilityAnalystSetting3D.h"
#import "FacilityAnalystCheckResult3d.h"
#import "FacilityAnalystResult3D.h"

@interface FacilityAnalyst3D : NSObject

/**
 * 分析环境设置对象
 */
@property (nonatomic,strong) FacilityAnalystSetting3D* analystSetting;

/**
 * 加载网络模型。根据分析环境对象中的环境参数，加载网络模型，该方法在设置完AnalystSetting后调用
 * @return BOOL
 */
-(BOOL)load;

-(FacilityAnalystCheckResult3d *)check;

/**
 * 根据节点ID数组查找与节点连接的环路，返回环路ID数组
 *
 * @param nodeIDs 传入的ID数组
 * @return 返回环路弧段ID数组
 */
-(NSArray *)findLoopsFromNodes:(NSArray *)nodeIDs;
/**
 * 根据弧段ID数组查找与节点或弧段连接的环路，返回环路ID数组
 *
 * @param edgeIDs 传入的ID数组
 * @return 返回环路弧段ID数组
 */
-(NSArray *)findLoopFromEdges:(NSArray *)edgeIDs;
/**
 * 传入节点数组，查找与节点或弧段相连通的弧段ID数组
 *
 * @param nodeIDs
 */
-(NSArray *)findConnectedEdgesFromNodes:(NSArray *)nodeIDs;
/**
 * 传入弧段ID数组，查找与节点或弧段相连通的弧段ID数组
 *
 * @param edgeIDs
 */
-(NSArray *)findConnectedEdgesFromEdges:(NSArray *)edgeIDs;
/**
 * 传入节点ID数组，查找与节点或弧段不相连通的弧段ID数组
 *
 * @param nodeIDs
 */
-(NSArray *)findUnConnectedEdgesFromNodes:(NSArray *)nodeIDs;
/**
 * 传入弧段ID数组，查找与节点或弧段不相连通的弧段ID数组
 *
 * @param edgeIDs
 */
-(NSArray *)findUnConnectedEdgesFromEdges:(NSArray *)edgeIDs;
/**
 * 传入节点或弧段ID数组，返回这些节点或弧段的共同上游弧段ID数组
 *
 * @param nodeIDs 传入的ID数组
 * @param weightName 权值字段信息名称
 * @param isUncertainDirectionValid 环路是否有效
 * @return int[]
 */
-(NSArray *)findCommonAncestorsFromNodes:(NSArray *)nodeIDs isUncertainDirectionValid:(BOOL)bUncertainDirectionValid;
/**
 * 传入节点或弧段ID数组，返回这些节点或弧段的共同上游弧段ID数组
 *
 * @param edgeIDs 传入的ID数组
 * @param weightName 权值字段信息名称
 * @param isUncertainDirectionValid 环路是否有效
 *
 */
-(NSArray*)findCommonAncestorsFromEdges:(NSArray *)edgeIDs isUncertainDirectionValid:(BOOL)bUncertainDirectionValid;
/**
 * 传入弧段ID数组，返回这些节点或弧段的共同下游弧段ID数组
 *
 * @param nodeIDs 传入的ID数组
 * @param weightName 权值字段信息名称
 * @param isUncertainDirectionValid  环路是否有效
 */
-(NSArray *)findCommonCatchmentsFromNodes:(NSArray *)nodeIDs isUncertainDirectionValid:(BOOL)bUncertainDirectionValid;
/**
 * 传入弧段ID数组，返回这些节点或弧段的共同下游弧段ID数组
 *
 * @param edgeIDs 传入的ID数组
 * @param weightName 权值字段信息名称
 * @param isUncertainDirectionValid 环路是否有效
 */
-(NSArray *)findCommonCatchmentsFromEdges:(NSArray *)edgeIDs isUncertainDirectionValid:(BOOL)bUncertainDirectionValid;
/**
 * 基于节点查找源头，传入弧段ID，返回从弧段到源头之间的弧段ID数组
 *
 * @param nodeID 传入ID
 * @param weightName  权值字段信息名称
 * @param isUncertainDirectionValid 环路是否有效
 * @return FacilityResultResult3D
 */
-(FacilityAnalystResult3D*)findSourceFromNode:(int)nodeID weightName:(NSString *)weightName isUncertainDirectionValid:(BOOL)bUncertainDirectionValid;
/**
 * 基于弧段查找源头，传入弧段ID，返回从弧段到源头之间的弧段ID数组
 *
 * @param edgeID 传入ID
 * @param weightName 权值字段信息名称
 * @param isUncertainDirectionValid 环路是否有效
 * @return FacilityAnalystResult3D
 */
-(FacilityAnalystResult3D *)findSourceFromEdge:(int)edgeID weightName:(NSString *)weightName isUncertainDirectionValid:(BOOL)bUncertainDirectionValid;
/**
 * 基于节点查找交汇，传入节点ID，返回从节点到交汇之间的弧段ID数组
 *
 * @param nodeID  传入ID
 * @param weightName  权值字段信息名称
 * @param isUncertainDirectionValid 环路是否有效
 * @return FacilityAnalystResult3D
 */
-(FacilityAnalystResult3D*)findSinkFromNode:(int)nodeID weightName:(NSString *)weightName isUncertainDirectionValid:(BOOL)bUncertainDirectionValid;
/**
 * 基于弧段查找交汇，传入弧段ID，返回从弧段到交汇之间的弧段ID数组
 *
 * @param edgeID 传入ID
 * @param weightName 权值字段信息名称
 * @param isUncertainDirectionValid 环路是否有效
 * @return FacilityAnalystResult3D
 */
-(FacilityAnalystResult3D*) findSinkFromEdge:(int)edgeID weightName:(NSString *)weightName isUncertainDirectionValid:(BOOL)bUncertainDirectionValid;
/**
 * 上游追踪，返回从分析点上游追踪所流经弧段ID数组
 *
 * @param nodeID 传入ID
 * @param weightName 权值字段信息名称
 * @param isUncertainDirectionValid 环路是否有效
 * @return FacilityAnalystResult3D
 */
-(FacilityAnalystResult3D*) traceUpFromNode:(int)nodeID weightName:(NSString *)weightName isUncertainDirectionValid:(BOOL)bUncertainDirectionValid;
/**
 * 上游追踪，返回从弧段上游追踪所流经弧段ID数组
 *
 * @param edgeID 传入ID
 * @param weightName 权值字段信息名称
 * @param isUncertainDirectionValid 环路是否有效
 * @return FacilityAnalystResult3D
 */
-(FacilityAnalystResult3D*)traceUpFromEdge:(int)edgeID weightName:(NSString *)weightName isUncertainDirectionValid:(BOOL)bUncertainDirectionValid;
/**
 * 下游追踪，返回从分析点下游追踪所流经弧段ID数组
 *
 * @param nodeID 传入ID
 * @param weightName 权值字段信息名称
 * @param isUncertainDirectionValid 环路是否有效
 * @return FacilityTraceResult3D
 */
-(FacilityAnalystResult3D*) traceDownFromNode:(int)nodeID weightName:(NSString *)weightName isUncertainDirectionValid:(BOOL)bUncertainDirectionValid;
/**
 * 下游追踪，返回从分析点或弧段下游追踪所流经弧段ID数组
 *
 * @param edgeID  传入ID
 * @param weightName 权值字段信息名称
 * @param isUncertainDirectionValid 环路是否有效
 * @return FacilityAnalystResult3D
 */
-(FacilityAnalystResult3D *)traceDownFromEdge:(int)edgeID weightName:(NSString *)weightName isUncertainDirectionValid:(BOOL)bUncertainDirectionValid;
/**
 * 检查网络环路，返回环路弧段ID数组
 *
 */
-(NSArray *) checkLoops;
/**
 * 设施网络路径分析，传入起始和终止节点或弧段ID
 *
 * @param startNodeID 起始ID
 * @param endNodeID 终止ID
 * @param weightName 权值字段信息名称
 * @param hasLeastEdgeCount 是否弧段数量最少
 * @return FacilityPathResult
 */
-(FacilityAnalystResult3D*)findPathFromNode:(int)startNodeID toNode:(int)endNodeID withWeight:(NSString*)weightName;
/**
 * 设施网络路径分析，传入起始和终止弧段ID
 *
 * @param startEdgeID  起始ID
 * @param endEdgeID 终止ID
 * @param weightName 权值字段信息名称
 * @param hasLeastEdgeCount 是否弧段数量最少
 * @return FacilityAnalystResult3D
 */
-(FacilityAnalystResult3D*)findPathFromEdge:(int)startID toNode:(int)endID withWeight:(NSString*)weightName;
/**
 * 设施网络上游分析，找出上游最近设施结点，用户可以指定一个结点或弧段ID，从满足条件的结点数组中找到上游最近的设施结点
 *
 * @param sourceNodeIDs
 *            int[]
 *            传入的满足条件的结点ID数组，分析得到的结果是此数组sourceNodeIDs的一个子集，如果传入数组为空，则查询所有的结点
 *
 * @param nodeID
 *            int 传入的ID
 * @return FacilityPathResult
 */
-(FacilityAnalystResult3D*)findCriticalFacilitiesUp:(NSArray *)sourceNodeIDs fromNode:(int)nodeID isUncertainDirectionValid:(BOOL)bUncertainDirectionValid;
/**
 * 设施网络上游分析，找出上游最近设施结点，用户可以指定一个结点或弧段ID，从满足条件的结点数组中找到上游最近的设施结点
 *
 * @param sourceNodeIDs
 *            int[] 传入的满足条件的结点ID数组，分析得到的结果是此数组nodeIDs的一个子集，如果传入数组为空，则查询所有的结点
 *
 * @param edgeID
 *            int 传入的ID
 * @return FacilityPathResult
 */
-(FacilityAnalystResult3D*) findCriticalFacilitiesUp:(NSArray *)sourceNodeIDs fromEdge:(int)edgeID isUncertainDirectionValid:(BOOL)bUncertainDirectionValid;
/**
 * 设施网络上游分析，找出上游最近设施结点，用户可以指定一个结点或弧段ID，从满足条件的结点数组中找到上游最近的设施结点
 *
 * @param sourceNodeIDs
 *            int[]
 *            传入的满足条件的结点ID数组，分析得到的结果是此数组sourceNodeIDs的一个子集，如果传入数组为空，则查询所有的结点
 *
 * @param nodeID
 *            int 传入的ID
 * @return FacilityPathResult
 */
-(FacilityAnalystResult3D*)findCriticalFacilitiesDown:(NSArray *)sourceNodeIDs fromNode:(int)nodeID isUncertainDirectionValid:(BOOL)bUncertainDirectionValid;
/**
 * 设施网络上游分析，找出上游最近设施结点，用户可以指定一个结点或弧段ID，从满足条件的结点数组中找到上游最近的设施结点
 *
 * @param sourceNodeIDs
 *            int[] 传入的满足条件的结点ID数组，分析得到的结果是此数组nodeIDs的一个子集，如果传入数组为空，则查询所有的结点
 *
 * @param edgeID
 *            int 传入的ID
 * @return FacilityPathResult
 */
-(FacilityAnalystResult3D*) findCriticalFacilitiesDown:(NSArray *)sourceNodeIDs fromEdge:(int)edgeID isUncertainDirectionValid:(BOOL)bUncertainDirectionValid;
/**
 * 释放对象
 */
-(void) dispose;

@end

//
//  JSFacilityAnalyst.m
//  Supermap
//
//  Created by supermap on 2018/8/8.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSFacilityAnalyst.h"
#import "JSObjManager.h"
#import "SuperMap/FacilityAnalyst.h"
#import "SuperMap/FacilityAnalystResult.h"
#import "SuperMap/FacilityAnalystSetting.h"

@interface JSFacilityAnalyst(){
    FacilityAnalyst* m_FacilityAnalyst;
}

@end
@implementation JSFacilityAnalyst
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(createObj, createObjResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        FacilityAnalyst* facilityAnalyst = [[FacilityAnalyst alloc]init];
        NSInteger facilityAnalystId = (NSInteger)facilityAnalyst;
        [JSObjManager addObj:facilityAnalyst];
        resolve(@(facilityAnalystId).stringValue);
        
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"createObj expection",nil);
    }
}
/**
 * 检查网络环路，返回构成环路的弧段 ID 数组
 * @param ficilityAnalystId
 */
RCT_REMAP_METHOD(checkLoops,checkLoopsById:(NSString*)ficilityAnalystId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        NSMutableArray * ids = [m_FacilityAnalyst checkLoops];
        resolve(ids);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"checkLoops expection",nil);
    }
}
RCT_REMAP_METHOD(dispose,disposeById:(NSString*)ficilityAnalystId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        [m_FacilityAnalyst dispose];
        [JSObjManager removeObj:ficilityAnalystId];
        NSNumber* number = [NSNumber numberWithBool:YES];
        
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"dispose expection",nil);
    }
}
/**
 * 根据给定的弧段 ID 数组，查找这些弧段的共同上游弧段，返回弧段 ID 数组
 * @param ficilityAnalystId
 * @param edgeIDs
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findCommonAncestorsFromEdges,findCommonAncestorsFromEdgesById:(NSString*)ficilityAnalystId edgeIDs:(NSMutableArray*)edgeIDs isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        NSMutableArray* ids =[m_FacilityAnalyst findCommonAncestorsFromEdges:edgeIDs isUncertainDirectionValid:isUncertainDirectionValid];
        resolve(ids);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"findCommonAncestorsFromEdges expection",nil);
    }
}
/**
 * 根据给定的结点 ID 数组，查找这些结点的共同上游弧段，返回弧段 ID 数组
 * @param ficilityAnalystId
 * @param nodeIDs
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findCommonAncestorsFromNodes,findCommonAncestorsFromNodesById:(NSString*)ficilityAnalystId nodeIDs:(NSMutableArray*)nodeIDs isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        NSMutableArray* ids =[m_FacilityAnalyst findCommonAncestorsFromNodes:nodeIDs isUncertainDirectionValid:isUncertainDirectionValid];
        resolve(ids);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"findCommonAncestorsFromNodes expection",nil);
    }
}
/**
 * 根据给定的弧段 ID 数组，查找这些弧段的共同下游弧段，返回弧段 ID 数组
 * @param ficilityAnalystId
 * @param edgeIDs
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findCommonCatchmentsFromEdges,findCommonCatchmentsFromEdgesById:(NSString*)ficilityAnalystId edgeIDs:(NSMutableArray*)edgeIDs isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        NSMutableArray* ids =[m_FacilityAnalyst findCommonCatchmentsFromEdges:edgeIDs isUncertainDirectionValid:isUncertainDirectionValid];
        resolve(ids);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"findCommonCatchmentsFromEdges expection",nil);
    }
}
/**
 * 根据指定的结点 ID 数组，查找这些结点的共同下游弧段，返回弧段 ID 数组
 * @param ficilityAnalystId
 * @param nodeIDs
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findCommonCatchmentsFromNodes,findCommonCatchmentsFromNodesById:(NSString*)ficilityAnalystId nodeIDs:(NSMutableArray*)nodeIDs isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        NSMutableArray* ids =[m_FacilityAnalyst findCommonCatchmentsFromNodes:nodeIDs isUncertainDirectionValid:isUncertainDirectionValid];
        resolve(ids);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"findCommonCatchmentsFromNodes expection",nil);
    }
}
/**
 * 根据给定的弧段 ID 数组，查找与这些弧段相连通的弧段，返回弧段 ID 数组
 * @param ficilityAnalystId
 * @param edgeIDs
 */
RCT_REMAP_METHOD(findConnectedEdgesFromEdges,findConnectedEdgesFromEdgesById:(NSString*)ficilityAnalystId edgeIDs:(NSMutableArray*)edgeIDs resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        NSMutableArray* ids =[m_FacilityAnalyst findConnectedEdgesFromEdges:edgeIDs];
        resolve(ids);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"findConnectedEdgesFromEdges expection",nil);
    }
}
/**
 * 根据给定的结点 ID 数组，查找与这些结点相连通弧段，返回弧段 ID 数组
 * @param ficilityAnalystId
 * @param nodeIDs
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findConnectedEdgesFromNodes,findConnectedEdgesFromNodesById:(NSString*)ficilityAnalystId nodeIDs:(NSMutableArray*)nodeIDs isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        NSMutableArray* ids =[m_FacilityAnalyst findConnectedEdgesFromNodes:nodeIDs];
        resolve(ids);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"findConnectedEdgesFromNodes expection",nil);
    }
}
/**
 * 根据给定的弧段 ID 数组查找与这些弧段相连接的环路，返回构成环路的弧段 ID 数组
 * @param ficilityAnalystId
 * @param edgeIDs
 */
RCT_REMAP_METHOD(findLoopsFromEdges,findLoopsFromEdgesById:(NSString*)ficilityAnalystId edgeIDs:(NSMutableArray*)edgeIDs resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        NSMutableArray* ids =[m_FacilityAnalyst findLoopsFromEdges:edgeIDs];
        resolve(ids);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"findLoopsFromEdges expection",nil);
    }
}

/**
 * 根据给定的结点 ID 数组查找与这些结点相连接的环路，返回构成环路的弧段 ID 数组
 * @param ficilityAnalystId
 * @param nodeIDs
 */
RCT_REMAP_METHOD(findLoopsFromNodes,findLoopsFromNodesById:(NSString*)ficilityAnalystId nodeIDs:(NSMutableArray*)nodeIDs resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        NSMutableArray* ids =[m_FacilityAnalyst findLoopsFromNodes:nodeIDs];
        resolve(ids);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"findLoopsFromNodes expection",nil);
    }
}
/**
 * 设施网络下游路径分析，根据给定的参与分析的弧段 ID，查询该弧段下游耗费最小的路径，返回该路径包含的弧段、结点及耗费
 * @param ficilityAnalystId
 * @param edgeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findPathDownFromEdge,findPathDownFromEdgeById:(NSString*)ficilityAnalystId edgeID:(NSInteger)edgeID weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        FacilityAnalystResult* result= [m_FacilityAnalyst findPathDownFromEdge:edgeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
        double cost = result.dCost;
        NSArray* edges = result.edges;
        NSArray* nodes = result.nodes;
        
        resolve(@{@"coast":@(cost),
                  @"edges":edges,
                  @"nodes":nodes
                  });
        
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"findPathDownFromEdge expection",nil);
    }
}
/**
 * 设施网络下游路径分析，根据给定的参与分析的结点 ID，查询该结点下游耗费最小的路径，返回该路径包含的弧段、结点及耗费
 * @param ficilityAnalystId
 * @param nodeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findPathDownFromNode,findPathDownFromNodeById:(NSString*)ficilityAnalystId nodeID:(NSInteger)nodeID weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        FacilityAnalystResult* result= [m_FacilityAnalyst findPathDownFromNode:nodeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
        double cost = result.dCost;
        NSArray* edges = result.edges;
        NSArray* nodes = result.nodes;
        
        resolve(@{@"coast":@(cost),
                  @"edges":edges,
                  @"nodes":nodes
                  });
        
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"findPathDownFromNode expection",nil);
    }
}
/**
 * 设施网络路径分析，即根据给定的起始和终止弧段 ID，查找其间耗费最小的路径，返回该路径包含的弧段、结点及耗费
 * @param ficilityAnalystId
 * @param startEdgeID
 * @param endEdgeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findPathFromEdges,findPathFromEdgesById:(NSString*)ficilityAnalystId startEdgeID:(NSInteger)startEdgeID endEdgeID:(NSInteger)endEdgeID weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        FacilityAnalystResult* result= [m_FacilityAnalyst findPathFromEdges:startEdgeID endEdgeID:endEdgeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
        double cost = result.dCost;
        NSArray* edges = result.edges;
        NSArray* nodes = result.nodes;
        
        resolve(@{@"coast":@(cost),
                  @"edges":edges,
                  @"nodes":nodes
                  });
        
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"findPathFromEdges expection",nil);
    }
}
/**
 * 设施网络路径分析，即根据给定的起始和终止结点 ID，查找其间耗费最小的路径，返回该路径包含的弧段、结点及耗费。
 * @param ficilityAnalystId
 * @param startNodeID
 * @param endNodeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findPathFromNodes,findPathFromNodesById:(NSString*)ficilityAnalystId startNodeID:(NSInteger)startNodeID endNodeID:(NSInteger)endNodeID weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        FacilityAnalystResult* result= [m_FacilityAnalyst findPathFromNodes:startNodeID endNodeID:endNodeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
       
        if(result != nil){
            double cost = result.dCost;
            NSArray* edges = result.edges;
            NSArray* nodes = result.nodes;
            
            resolve(@{@"coast":@(cost),
                      @"edges":edges,
                      @"nodes":nodes
                      });
            
        }else{
            resolve(@{@"message":@"FacilityAnalystResult is null"});
        }
        
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"findPathFromNodes expection",nil);
    }
}
/**
 * 设施网络上游路径分析，根据给定的弧段 ID，查询该弧段上游耗费最小的路径，返回该路径包含的弧段、结点及耗费
 * @param ficilityAnalystId
 * @param edgeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findPathUpFromEdge,findPathUpFromEdgeById:(NSString*)ficilityAnalystId edgeID:(NSInteger)edgeID weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        FacilityAnalystResult* result= [m_FacilityAnalyst findPathUpFromEdge:edgeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
        if(result != nil){
            double cost = result.dCost;
            NSArray* edges = result.edges;
            NSArray* nodes = result.nodes;
            
            resolve(@{@"coast":@(cost),
                      @"edges":edges,
                      @"nodes":nodes
                      });
            
        }else{
            resolve(@{@"message":@"FacilityAnalystResult is null"});
        }
        
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"findPathUpFromEdge expection",nil);
    }
}
/**
 * 设施网络上游路径分析，根据给定的结点 ID，查询该结点上游耗费最小的路径，返回该路径包含的弧段、结点及耗费
 * @param ficilityAnalystId
 * @param nodeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findPathUpFromNode,findPathUpFromNodeById:(NSString*)ficilityAnalystId nodeID:(NSInteger)nodeID weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        FacilityAnalystResult* result= [m_FacilityAnalyst findPathUpFromNode:nodeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
        if(result != nil){
            double cost = result.dCost;
            NSArray* edges = result.edges;
            NSArray* nodes = result.nodes;
            
            resolve(@{@"coast":@(cost),
                      @"edges":edges,
                      @"nodes":nodes
                      });
            
        }else{
            resolve(@{@"message":@"FacilityAnalystResult is null"});
        }
        
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"findPathUpFromNode expection",nil);
    }
}
/**
 * 根据给定的弧段 ID 查找汇，即从给定弧段出发，根据流向查找流出该弧段的下游汇点，并返回给定弧段到达该汇的最小耗费路径所包含的弧段、结点及耗费
 * @param ficilityAnalystId
 * @param edgeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findSinkFromEdge,findSinkFromEdgeById:(NSString*)ficilityAnalystId edgeID:(NSInteger)edgeID weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        FacilityAnalystResult* result= [m_FacilityAnalyst findSinkFromEdge:edgeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
        if(result != nil){
            double cost = result.dCost;
            NSArray* edges = result.edges;
            NSArray* nodes = result.nodes;
            
            resolve(@{@"coast":@(cost),
                      @"edges":edges,
                      @"nodes":nodes
                      });
            
        }else{
            resolve(@{@"message":@"FacilityAnalystResult is null"});
        }
        
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"findSinkFromEdge expection",nil);
    }
}
/**
 * 根据给定的结点 ID 查找汇，即从给定结点出发，根据流向查找流出该结点的下游汇点，并返回给定结点到达该汇的最小耗费路径所包含的弧段、结点及耗费
 * @param ficilityAnalystId
 * @param nodeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findSinkFromNode,findSinkFromNodeById:(NSString*)ficilityAnalystId nodeID:(NSInteger)nodeID weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        FacilityAnalystResult* result= [m_FacilityAnalyst findSinkFromNode:nodeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
        if(result != nil){
            double cost = result.dCost;
            NSArray* edges = result.edges;
            NSArray* nodes = result.nodes;
            
            resolve(@{@"coast":@(cost),
                      @"edges":edges,
                      @"nodes":nodes
                      });
            
        }else{
            resolve(@{@"message":@"FacilityAnalystResult is null"});
        }
        
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"findSinkFromNode expection",nil);
    }
}
/**
 * 根据给定的弧段 ID 查找源，即从给定弧段出发，根据流向查找流向该弧段的网络源头，并返回该源到达给定弧段的最小耗费路径所包含的弧段、结点及耗费
 * @param ficilityAnalystId
 * @param edgeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findSourceFromEdge,findSourceFromEdgeById:(NSString*)ficilityAnalystId edgeID:(NSInteger)edgeID weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        FacilityAnalystResult* result= [m_FacilityAnalyst findSourceFromEdge:edgeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
        if(result != nil){
            double cost = result.dCost;
            NSArray* edges = result.edges;
            NSArray* nodes = result.nodes;
            
            resolve(@{@"coast":@(cost),
                      @"edges":edges,
                      @"nodes":nodes
                      });
            
        }else{
            resolve(@{@"message":@"FacilityAnalystResult is null"});
        }
        
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"findSourceFromEdge expection",nil);
    }
}
/**
 * 根据给定的结点 ID 查找源，即从给定结点出发，根据流向查找流向该结点的网络源头，并返回该源到达给定结点的最小耗费路径所包含的弧段、结点及耗费
 * @param ficilityAnalystId
 * @param nodeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findSourceFromNode,findSourceFromNodeById:(NSString*)ficilityAnalystId edgeID:(NSInteger)edgeID weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        FacilityAnalystResult* result= [m_FacilityAnalyst findSourceFromNode:edgeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
        if(result != nil){
            double cost = result.dCost;
            NSArray* edges = result.edges;
            NSArray* nodes = result.nodes;
            
            resolve(@{@"coast":@(cost),
                      @"edges":edges,
                      @"nodes":nodes
                      });
            
        }else{
            resolve(@{@"message":@"FacilityAnalystResult is null"});
        }
        
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"findSourceFromNode expection",nil);
    }
}
/**
 * 根据给定的弧段 ID 数组，查找与这些弧段不相连通的弧段，返回弧段 ID 数组
 * @param ficilityAnalystId
 * @param edgeIDs
 */
RCT_REMAP_METHOD(findUnconnectedEdgesFromEdges,findUnconnectedEdgesFromEdgesById:(NSString*)ficilityAnalystId edgeIDs:(NSMutableArray*)edgeIDs  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
       
        NSMutableArray* unconnectedEdges = [m_FacilityAnalyst findUnconnectedEdgesFromEdges:edgeIDs];
        resolve(unconnectedEdges);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"findUnconnectedEdgesFromEdges expection",nil);
    }
}
/**
 * 根据给定的结点 ID 数组，查找与这些结点不相连通的弧段，返回弧段 ID 数组
 * @param ficilityAnalystId
 * @param nodeIDs
 */
RCT_REMAP_METHOD(findUnconnectedEdgesFromNodes,findUnconnectedEdgesFromNodesById:(NSString*)ficilityAnalystId nodeIDs:(NSMutableArray*)nodeIDs  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        
        NSMutableArray* unconnectedEdges = [m_FacilityAnalyst findUnconnectedEdgesFromNodes:nodeIDs];
        resolve(unconnectedEdges);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"findUnconnectedEdgesFromNodes expection",nil);
    }
}
/**
 * 根据给定的弧段 ID 进行下游追踪，即查找给定弧段的下游，返回下游包含的弧段、结点及总耗费
 * @param ficilityAnalystId
 * @param edgeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(traceDownFromEdge,traceDownFromEdgeById:(NSString*)ficilityAnalystId edgeID:(NSInteger)edgeID weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        
        FacilityAnalystResult* result= [m_FacilityAnalyst traceDownFromEdge:edgeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
        if(result != nil){
            double cost = result.dCost;
            NSArray* edges = result.edges;
            NSArray* nodes = result.nodes;
            
            resolve(@{@"coast":@(cost),
                      @"edges":edges,
                      @"nodes":nodes
                      });
            
        }else{
            resolve(@{@"message":@"FacilityAnalystResult is null"});
        }
        
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"traceDownFromEdge expection",nil);
    }
}
/**
 * 根据给定的结点 ID 进行下游追踪，即查找给定结点的下游，返回下游包含的弧段、结点及总耗费
 * @param ficilityAnalystId
 * @param nodeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(traceDownFromNode,traceDownFromNodeById:(NSString*)ficilityAnalystId nodeID:(NSInteger)nodeID weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        
        FacilityAnalystResult* result= [m_FacilityAnalyst traceDownFromNode:nodeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
        if(result != nil){
            double cost = result.dCost;
            NSArray* edges = result.edges;
            NSArray* nodes = result.nodes;
            
            resolve(@{@"coast":@(cost),
                      @"edges":edges,
                      @"nodes":nodes
                      });
            
        }else{
            resolve(@{@"message":@"FacilityAnalystResult is null"});
        }
        
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"traceDownFromNode expection",nil);
    }
}
/**
 * 根据给定的弧段 ID 进行上游追踪，即查找给定弧段的上游，返回上游包含的弧段、结点及总耗费
 * @param ficilityAnalystId
 * @param edgeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(traceUpFromEdge,traceUpFromEdgeById:(NSString*)ficilityAnalystId edgeID:(NSInteger)edgeID weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        
        FacilityAnalystResult* result= [m_FacilityAnalyst traceUpFromEdge:edgeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
        if(result != nil){
            double cost = result.dCost;
            NSArray* edges = result.edges;
            NSArray* nodes = result.nodes;
            
            resolve(@{@"coast":@(cost),
                      @"edges":edges,
                      @"nodes":nodes
                      });
            
        }else{
            resolve(@{@"message":@"FacilityAnalystResult is null"});
        }
        
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"traceUpFromEdge expection",nil);
    }
}
/**
 * 根据给定的结点 ID 进行上游追踪，即查找给定结点的上游，返回上游包含的弧段、结点及总耗费
 * @param ficilityAnalystId
 * @param nodeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(traceUpFromNode,traceUpFromNodeById:(NSString*)ficilityAnalystId nodeID:(NSInteger)nodeID weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        
        FacilityAnalystResult* result= [m_FacilityAnalyst traceUpFromNode:nodeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
        if(result != nil){
            double cost = result.dCost;
            NSArray* edges = result.edges;
            NSArray* nodes = result.nodes;
            
            resolve(@{@"coast":@(cost),
                      @"edges":edges,
                      @"nodes":nodes
                      });
            
        }else{
            resolve(@{@"message":@"FacilityAnalystResult is nil"});
        }
        
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"traceUpFromNode expection",nil);
    }
}
/**
 * 设置设施网络分析的环境
 * @param ficilityAnalystId
 * @param facilityAnalystSettingId
 */
RCT_REMAP_METHOD(setAnalystSetting,setAnalystSettingById:(NSString*)ficilityAnalystId facilityAnalystSettingId:(NSString*)facilityAnalystSettingId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        FacilityAnalystSetting* setting = [JSObjManager getObjWithKey:facilityAnalystSettingId];
        m_FacilityAnalyst.analystSetting = setting;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"setAnalystSetting expection",nil);
    }
}
/**
 * 返回设施网络分析的环境
 * @param ficilityAnalystId
 */
RCT_REMAP_METHOD(getAnalystSetting,getAnalystSettingById:(NSString*)ficilityAnalystId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        FacilityAnalystSetting* setting = m_FacilityAnalyst.analystSetting;
        resolve(setting);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"getAnalystSetting expection",nil);
    }
}
/**
 * 根据设施网络分析环境设置加载设施网络模型
 * @param ficilityAnalystId
 */
RCT_REMAP_METHOD(load,loadById:(NSString*)ficilityAnalystId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        BOOL result = m_FacilityAnalyst.load;
        NSNumber* number = [NSNumber numberWithBool:result];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"load expection",nil);
    }
}


RCT_REMAP_METHOD(loadModel, loadModelById:(NSString*)ficilityAnalystId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        m_FacilityAnalyst = [JSObjManager getObjWithKey:ficilityAnalystId];
        BOOL result = m_FacilityAnalyst.load;
        NSNumber* number = [NSNumber numberWithBool:result];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSFacilityAnalyst",@"load expection",nil);
    }
}
@end

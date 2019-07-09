//
//  SFacilityAnalyst.m
//  Supermap
//
//  Created by Shanglong Yang on 2019/6/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "SFacilityAnalyst.h"

static FacilityAnalyst* facilityAnalyst = nil;
//static Selection* selection = nil;

@implementation SFacilityAnalyst
RCT_EXPORT_MODULE();

- (FacilityAnalyst *)getFacilityAnalyst{
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        facilityAnalyst = [[FacilityAnalyst alloc] init];
    });
    
    return facilityAnalyst;
}

#pragma mark 加载设施网络分析模型
RCT_REMAP_METHOD(load, loadByDatasource:(NSDictionary *)datasourceInfo facilitySetting:(NSDictionary *)facilitySetting resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Workspace* workspace = [SMap singletonInstance].smMapWC.workspace;
        Layers* layers = [SMap singletonInstance].smMapWC.mapControl.map.layers;
        FacilityAnalystSetting* setting = nil;
        Dataset* ds = nil;
        
        if ([datasourceInfo objectForKey:@"server"]) {
            DatasourceConnectionInfo* connectInfo = [SMDatasource convertDicToInfo:datasourceInfo];
            Datasources* dss = [SMap singletonInstance].smMapWC.workspace.datasources;
            Datasource* datasource = [dss getAlias:[datasourceInfo objectForKey:@"alias"]];
            if (!datasource) {
                datasource = [workspace.datasources open:connectInfo];
            }
            
            NSString* datasetName = [facilitySetting objectForKey:@"networkDataset"];
            if (datasetName) {
                ds = [datasource.datasets getWithName:datasetName];
                layer = [SMLayer findLayerByDatasetName:ds.name];
                if (!layer) {
                    layer = [layers addDataset:ds ToHead:YES];
                    layer.selectable = NO;
                }
                
                Dataset* nodeDataset = ((DatasetVector *)ds).childDataset;
                if (nodeDataset) {
                    nodeLayer = [SMLayer findLayerByDatasetName:nodeDataset.name];
                    if (!nodeLayer) {
                        nodeLayer = [layers addDataset:nodeDataset ToHead:YES];
                        nodeLayer.selectable = YES;
                        nodeLayer.visible = YES;
                    }
                }
            }
            
        } else {
            if ([facilitySetting objectForKey:@"networkDataset"]) {
                layer = [SMLayer findLayerByDatasetName:[facilitySetting objectForKey:@"networkDataset"]];
            }
        }
        
        if (layer) {
            ds = layer.dataset;
            selection = [layer getSelection];
            
            facilityAnalyst = [self getFacilityAnalyst];
            
            setting = [SMAnalyst setFacilitySetting:facilitySetting];
            setting.netWorkDataset = (DatasetVector *)ds;
            [facilityAnalyst setAnalystSetting:setting];
            
            BOOL result = [facilityAnalyst load];
            NSNumber* number = [NSNumber numberWithBool:result];
            
            [[SMap singletonInstance].smMapWC.mapControl setAction:PAN];
            
            NSMutableDictionary* layerInfo = [SMLayer getLayerInfo:layer path:@""];
            
            resolve(@{
                      @"result": number,
                      @"layerInfo": layerInfo,
                      });
        } else {
            reject(@"SFacilityAnalyst", @"No networkDataset", nil);
        }
        
        
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(setStartPoint, setStartPoint:(NSDictionary *)point resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSString* nodeTag = @"startNode";
        if (startNodeID > 0) {
            [self removeTagFromTrackingLayer:nodeTag];
            startNodeID = -1;
        }
        if (nodeLayer) {
            GeoStyle* style = [[GeoStyle alloc] init];
            [style setMarkerSize:[[Size2D alloc] initWithWidth:10 Height:10]];
            [style setLineColor:[[Color alloc] initWithR:255 G:105 B:0]];
            [style setMarkerSymbolID:3614];
            startNodeID = [self selectNode:point layer:nodeLayer geoStyle:style tag:nodeTag];
        }
        
        resolve(@(startNodeID));
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(setEndPoint, setEndPoint:(NSDictionary *)point resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSString* nodeTag = @"endNode";
        if (endNodeID > 0) {
            [self removeTagFromTrackingLayer:nodeTag];
            endNodeID = -1;
        }
        if (nodeLayer) {
            GeoStyle* style = [[GeoStyle alloc] init];
            [style setMarkerSize:[[Size2D alloc] initWithWidth:10 Height:10]];
            [style setLineColor:[[Color alloc] initWithR:105 G:255 B:0]];
            [style setMarkerSymbolID:3614];
            endNodeID = [self selectNode:point layer:nodeLayer geoStyle:style tag:nodeTag];
        }
        
        resolve(@(endNodeID));
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}

/**
 * 根据给定的弧段 ID 数组，查找这些弧段的共同上游弧段，返回弧段 ID 数组
 * @param edgeIDs
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findCommonAncestorsFromEdges,findCommonAncestorsFromEdgesById:(NSMutableArray*)edgeIDs isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        facilityAnalyst = [self getFacilityAnalyst];
        NSMutableArray* ids = [facilityAnalyst findCommonAncestorsFromEdges:edgeIDs isUncertainDirectionValid:isUncertainDirectionValid];
        [self displayResult:ids selection:selection];
        resolve(ids);
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}
/**
 * 根据给定的结点 ID 数组，查找这些结点的共同上游弧段，返回弧段 ID 数组
 * @param nodeIDs
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findCommonAncestorsFromNodes,findCommonAncestorsFromNodesById:(NSMutableArray*)nodeIDs isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        facilityAnalyst = [self getFacilityAnalyst];
        NSMutableArray* ids =[facilityAnalyst findCommonAncestorsFromNodes:nodeIDs isUncertainDirectionValid:isUncertainDirectionValid];
        [self displayResult:ids selection:selection];
        resolve(ids);
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}
/**
 * 根据给定的弧段 ID 数组，查找这些弧段的共同下游弧段，返回弧段 ID 数组
 * @param edgeIDs
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findCommonCatchmentsFromEdges,findCommonCatchmentsFromEdgesById:(NSMutableArray*)edgeIDs isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        facilityAnalyst = [self getFacilityAnalyst];
        NSMutableArray* ids =[facilityAnalyst findCommonCatchmentsFromEdges:edgeIDs isUncertainDirectionValid:isUncertainDirectionValid];
        [self displayResult:ids selection:selection];
        resolve(ids);
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}
/**
 * 根据指定的结点 ID 数组，查找这些结点的共同下游弧段，返回弧段 ID 数组
 * @param nodeIDs
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findCommonCatchmentsFromNodes,findCommonCatchmentsFromNodesById:(NSMutableArray*)nodeIDs isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        facilityAnalyst = [self getFacilityAnalyst];
        NSMutableArray* ids =[facilityAnalyst findCommonCatchmentsFromNodes:nodeIDs isUncertainDirectionValid:isUncertainDirectionValid];
        [self displayResult:ids selection:selection];
        resolve(ids);
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}
/**
 * 根据给定的弧段 ID 数组，查找与这些弧段相连通的弧段，返回弧段 ID 数组
 * @param edgeIDs
 */
RCT_REMAP_METHOD(findConnectedEdgesFromEdges,findConnectedEdgesFromEdgesById:(NSMutableArray*)edgeIDs resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        facilityAnalyst = [self getFacilityAnalyst];
        NSMutableArray* ids =[facilityAnalyst findConnectedEdgesFromEdges:edgeIDs];
        [self displayResult:ids selection:selection];
        resolve(ids);
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}
/**
 * 根据给定的结点 ID 数组，查找与这些结点相连通弧段，返回弧段 ID 数组
 * @param nodeIDs
 */
RCT_REMAP_METHOD(findConnectedEdgesFromNodes,findConnectedEdgesFromNodesById:(NSArray*)nodeIDs resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSMutableArray* IDs = [[NSMutableArray alloc] initWithArray:nodeIDs];
        if (IDs.count == 0) {
            [IDs addObject:@(startNodeID)];
            if (middleNodeIDs.count > 0) [IDs addObjectsFromArray:middleNodeIDs];
            [IDs addObject:@(endNodeID)];
        }
        facilityAnalyst = [self getFacilityAnalyst];
        NSMutableArray* ids = [facilityAnalyst findConnectedEdgesFromNodes:IDs];
        [self displayResult:ids selection:selection];
        resolve(ids);
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}
/**
 * 根据给定的弧段 ID 数组查找与这些弧段相连接的环路，返回构成环路的弧段 ID 数组
 * @param edgeIDs
 */
RCT_REMAP_METHOD(findLoopsFromEdges,findLoopsFromEdgesById:(NSMutableArray*)edgeIDs resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        facilityAnalyst = [self getFacilityAnalyst];
        NSMutableArray* ids =[facilityAnalyst findLoopsFromEdges:edgeIDs];
        [self displayResult:ids selection:selection];
        resolve(ids);
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}

/**
 * 根据给定的结点 ID 数组查找与这些结点相连接的环路，返回构成环路的弧段 ID 数组
 * @param nodeIDs
 */
RCT_REMAP_METHOD(findLoopsFromNodes,findLoopsFromNodesById:(NSMutableArray*)nodeIDs resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        facilityAnalyst = [self getFacilityAnalyst];
        NSMutableArray* ids =[facilityAnalyst findLoopsFromNodes:nodeIDs];
        [self displayResult:ids selection:selection];
        resolve(ids);
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}
/**
 * 设施网络下游路径分析，根据给定的参与分析的弧段 ID，查询该弧段下游耗费最小的路径，返回该路径包含的弧段、结点及耗费
 * @param edgeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findPathDownFromEdge,findPathDownFromEdgeById:(NSInteger)edgeID weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        facilityAnalyst = [self getFacilityAnalyst];
        FacilityAnalystResult* result= [facilityAnalyst findPathDownFromEdge:edgeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
        double cost = result.dCost;
        NSArray* edges = result.edges;
        NSArray* nodes = result.nodes;
        
        NSArray* resultIds = [edges arrayByAddingObjectsFromArray:nodes];
        [self displayResult:resultIds selection:selection];
        
        resolve(@{@"coast":@(cost),
                  @"edges":edges,
                  @"nodes":nodes
                  });
        
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}
/**
 * 设施网络下游路径分析，根据给定的参与分析的结点 ID，查询该结点下游耗费最小的路径，返回该路径包含的弧段、结点及耗费
 * @param nodeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findPathDownFromNode,findPathDownFromNodeById:(NSInteger)nodeID weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        facilityAnalyst = [self getFacilityAnalyst];
        FacilityAnalystResult* result= [facilityAnalyst findPathDownFromNode:nodeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
        double cost = result.dCost;
        NSArray* edges = result.edges;
        NSArray* nodes = result.nodes;
        
        NSArray* resultIds = [edges arrayByAddingObjectsFromArray:nodes];
        [self displayResult:resultIds selection:selection];
        
        resolve(@{@"coast":@(cost),
                  @"edges":edges,
                  @"nodes":nodes
                  });
        
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}
/**
 * 设施网络路径分析，即根据给定的起始和终止弧段 ID，查找其间耗费最小的路径，返回该路径包含的弧段、结点及耗费
 * @param startEdgeID
 * @param endEdgeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findPathFromEdges,findPathFromEdgesById:(NSInteger)startID endEdgeID:(NSInteger)endID weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        facilityAnalyst = [self getFacilityAnalyst];
        
        NSInteger mStartID = startID;
        NSInteger mEndID = endID;
        if (mStartID < 0) {
            mStartID = startNodeID;
        }
        if (endID < 0) {
            mEndID = endNodeID;
        }
        if (weightName == nil || [weightName isEqualToString:@""]) {
            weightName = @"Length";
        }
        
        FacilityAnalystResult* result = [facilityAnalyst findPathFromEdges:mStartID endEdgeID:mEndID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
        double cost = result.dCost;
        NSArray* edges = result.edges;
        NSArray* nodes = result.nodes;
        
        NSArray* resultIds = [edges arrayByAddingObjectsFromArray:nodes];
        [self displayResult:resultIds selection:selection];
        
        resolve(@{@"coast":@(cost),
                  @"edges":edges,
                  @"nodes":nodes
                  });
        
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}
/**
 * 设施网络路径分析，即根据给定的起始和终止结点 ID，查找其间耗费最小的路径，返回该路径包含的弧段、结点及耗费。
 * @param startNodeID
 * @param endNodeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findPathFromNodes,findPathFromNodesById:(NSInteger)startID endNodeID:(NSInteger)endID weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        facilityAnalyst = [self getFacilityAnalyst];
        
        NSInteger mStartID = startID;
        NSInteger mEndID = endID;
        if (mStartID <= 0) {
            mStartID = startNodeID;
        }
        if (endID <= 0) {
            mEndID = endNodeID;
        }
        if (weightName == nil || [weightName isEqualToString:@""]) {
            weightName = @"Length";
        }
        
        FacilityAnalystResult* result= [facilityAnalyst findPathFromNodes:mStartID endNodeID:mEndID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
        
        if(result != nil){
            double cost = result.dCost;
            NSArray* edges = result.edges;
            NSArray* nodes = result.nodes;
            
            [self displayResult:edges selection:selection];
            
            resolve(@{@"coast":@(cost),
                      @"edges":edges,
                      @"nodes":nodes
                      });
            
        }else{
            resolve(@{@"message":@"FacilityAnalystResult is null"});
        }
        
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}
/**
 * 设施网络上游路径分析，根据给定的弧段 ID，查询该弧段上游耗费最小的路径，返回该路径包含的弧段、结点及耗费
 * @param edgeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findPathUpFromEdge,findPathUpFromEdgeById:(NSInteger)edgeID weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        facilityAnalyst = [self getFacilityAnalyst];
        FacilityAnalystResult* result= [facilityAnalyst findPathUpFromEdge:edgeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
        if(result != nil){
            double cost = result.dCost;
            NSArray* edges = result.edges;
            NSArray* nodes = result.nodes;
            
            NSArray* resultIds = [edges arrayByAddingObjectsFromArray:nodes];
            [self displayResult:resultIds selection:selection];
            
            resolve(@{@"coast":@(cost),
                      @"edges":edges,
                      @"nodes":nodes
                      });
            
        }else{
            resolve(@{@"message":@"FacilityAnalystResult is null"});
        }
        
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}
/**
 * 设施网络上游路径分析，根据给定的结点 ID，查询该结点上游耗费最小的路径，返回该路径包含的弧段、结点及耗费
 * @param nodeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findPathUpFromNode,findPathUpFromNodeById:(NSInteger)nodeID weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        facilityAnalyst = [self getFacilityAnalyst];
        FacilityAnalystResult* result= [facilityAnalyst findPathUpFromNode:nodeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
        if(result != nil){
            double cost = result.dCost;
            NSArray* edges = result.edges;
            NSArray* nodes = result.nodes;
            
            NSArray* resultIds = [edges arrayByAddingObjectsFromArray:nodes];
            [self displayResult:resultIds selection:selection];
            
            resolve(@{@"coast":@(cost),
                      @"edges":edges,
                      @"nodes":nodes
                      });
            
        }else{
            resolve(@{@"message":@"FacilityAnalystResult is null"});
        }
        
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}
/**
 * 根据给定的弧段 ID 查找汇，即从给定弧段出发，根据流向查找流出该弧段的下游汇点，并返回给定弧段到达该汇的最小耗费路径所包含的弧段、结点及耗费
 * @param edgeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findSinkFromEdge,findSinkFromEdgeById:(NSInteger)edgeID weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        facilityAnalyst = [self getFacilityAnalyst];
        FacilityAnalystResult* result= [facilityAnalyst findSinkFromEdge:edgeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
        if(result != nil){
            double cost = result.dCost;
            NSArray* edges = result.edges;
            NSArray* nodes = result.nodes;
            
            NSArray* resultIds = [edges arrayByAddingObjectsFromArray:nodes];
            [self displayResult:resultIds selection:selection];
            
            resolve(@{@"coast":@(cost),
                      @"edges":edges,
                      @"nodes":nodes
                      });
            
        }else{
            resolve(@{@"message":@"FacilityAnalystResult is null"});
        }
        
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}
/**
 * 根据给定的结点 ID 查找汇，即从给定结点出发，根据流向查找流出该结点的下游汇点，并返回给定结点到达该汇的最小耗费路径所包含的弧段、结点及耗费
 * @param nodeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findSinkFromNode,findSinkFromNodeById:(NSInteger)nodeID weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        facilityAnalyst = [self getFacilityAnalyst];
        FacilityAnalystResult* result= [facilityAnalyst findSinkFromNode:nodeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
        if(result != nil){
            double cost = result.dCost;
            NSArray* edges = result.edges;
            NSArray* nodes = result.nodes;
            
            NSArray* resultIds = [edges arrayByAddingObjectsFromArray:nodes];
            [self displayResult:resultIds selection:selection];
            
            resolve(@{@"coast":@(cost),
                      @"edges":edges,
                      @"nodes":nodes
                      });
            
        }else{
            resolve(@{@"message":@"FacilityAnalystResult is null"});
        }
        
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}
/**
 * 根据给定的弧段 ID 查找源，即从给定弧段出发，根据流向查找流向该弧段的网络源头，并返回该源到达给定弧段的最小耗费路径所包含的弧段、结点及耗费
 * @param edgeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findSourceFromEdge,findSourceFromEdgeById:(NSInteger)edgeID weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        facilityAnalyst = [self getFacilityAnalyst];
        FacilityAnalystResult* result= [facilityAnalyst findSourceFromEdge:edgeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
        if(result != nil){
            double cost = result.dCost;
            NSArray* edges = result.edges;
            NSArray* nodes = result.nodes;
            
            NSArray* resultIds = [edges arrayByAddingObjectsFromArray:nodes];
            [self displayResult:resultIds selection:selection];
            
            resolve(@{@"coast":@(cost),
                      @"edges":edges,
                      @"nodes":nodes
                      });
            
        }else{
            resolve(@{@"message":@"FacilityAnalystResult is null"});
        }
        
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}
/**
 * 根据给定的结点 ID 查找源，即从给定结点出发，根据流向查找流向该结点的网络源头，并返回该源到达给定结点的最小耗费路径所包含的弧段、结点及耗费
 * @param nodeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(findSourceFromNode,findSourceFromNodeById:(NSInteger)edgeID weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        facilityAnalyst = [self getFacilityAnalyst];
        FacilityAnalystResult* result= [facilityAnalyst findSourceFromNode:edgeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
        if(result != nil){
            double cost = result.dCost;
            NSArray* edges = result.edges;
            NSArray* nodes = result.nodes;
            
            NSArray* resultIds = [edges arrayByAddingObjectsFromArray:nodes];
            [self displayResult:resultIds selection:selection];
            
            resolve(@{@"coast":@(cost),
                      @"edges":edges,
                      @"nodes":nodes
                      });
            
        }else{
            resolve(@{@"message":@"FacilityAnalystResult is null"});
        }
        
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}
/**
 * 根据给定的弧段 ID 数组，查找与这些弧段不相连通的弧段，返回弧段 ID 数组
 * @param edgeIDs
 */
RCT_REMAP_METHOD(findUnconnectedEdgesFromEdges,findUnconnectedEdgesFromEdgesById:(NSMutableArray*)edgeIDs  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        facilityAnalyst = [self getFacilityAnalyst];
        
        NSMutableArray* unconnectedEdges = [facilityAnalyst findUnconnectedEdgesFromEdges:edgeIDs];
        [self displayResult:unconnectedEdges selection:selection];
        
        resolve(unconnectedEdges);
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}
/**
 * 根据给定的结点 ID 数组，查找与这些结点不相连通的弧段，返回弧段 ID 数组
 * @param nodeIDs
 */
RCT_REMAP_METHOD(findUnconnectedEdgesFromNodes,findUnconnectedEdgesFromNodesById:(NSMutableArray*)nodeIDs  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        facilityAnalyst = [self getFacilityAnalyst];
        
        NSMutableArray* unconnectedEdges = [facilityAnalyst findUnconnectedEdgesFromNodes:nodeIDs];
        [self displayResult:unconnectedEdges selection:selection];
        
        resolve(unconnectedEdges);
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}
/**
 * 根据给定的弧段 ID 进行下游追踪，即查找给定弧段的下游，返回下游包含的弧段、结点及总耗费
 * @param edgeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(traceDownFromEdge,traceDownFromEdgeById:(NSArray *)edgeIDs weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        facilityAnalyst = [self getFacilityAnalyst];
        
        NSArray* resultIds = [[NSArray alloc] init];
        NSMutableArray* resultArr = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < edgeIDs.count; i++) {
            int edgeID = [(NSNumber *)edgeIDs[i] intValue];
            FacilityAnalystResult* result = [facilityAnalyst traceDownFromEdge:edgeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
            
            double cost = result.dCost;
            NSArray* edges = result.edges;
            NSArray* nodes = result.nodes;
            
            resultIds = [resultIds arrayByAddingObjectsFromArray:edges];
            
            [resultArr addObject:@{@"coast":@(cost),
                                   @"edges":edges,
                                   @"nodes":nodes
                                   }];
        }
        [self displayResult:resultIds selection:selection];
        
        resolve(resultArr);
        
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}
/**
 * 根据给定的结点 ID 进行下游追踪，即查找给定结点的下游，返回下游包含的弧段、结点及总耗费
 * @param nodeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(traceDownFromNode,traceDownFromNodeById:(NSArray *)nodeIDs weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        facilityAnalyst = [self getFacilityAnalyst];
        
        NSArray* resultIds = [[NSArray alloc] init];
        NSMutableArray* resultArr = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < nodeIDs.count; i++) {
            int nodeID = [(NSNumber *)nodeIDs[i] intValue];
            FacilityAnalystResult* result = [facilityAnalyst traceDownFromNode:nodeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
            
            double cost = result.dCost;
            NSArray* edges = result.edges;
            NSArray* nodes = result.nodes;
            
            resultIds = [resultIds arrayByAddingObjectsFromArray:edges];
            
            [resultArr addObject:@{@"coast":@(cost),
                                   @"edges":edges,
                                   @"nodes":nodes
                                   }];
        }
        [self displayResult:resultIds selection:selection];
        
        resolve(resultArr);
        
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}
/**
 * 根据给定的弧段 ID 进行上游追踪，即查找给定弧段的上游，返回上游包含的弧段、结点及总耗费
 * @param edgeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(traceUpFromEdge,traceUpFromEdgeById:(NSArray *)edgeIDs weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        facilityAnalyst = [self getFacilityAnalyst];
        
        NSArray* resultIds = [[NSArray alloc] init];
        NSMutableArray* resultArr = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < edgeIDs.count; i++) {
            int edgeID = [(NSNumber *)edgeIDs[i] intValue];
            FacilityAnalystResult* result = [facilityAnalyst traceUpFromEdge:edgeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
            
            double cost = result.dCost;
            NSArray* edges = result.edges;
            NSArray* nodes = result.nodes;
            
            resultIds = [resultIds arrayByAddingObjectsFromArray:edges];
            
            [resultArr addObject:@{@"coast":@(cost),
                                   @"edges":edges,
                                   @"nodes":nodes
                                   }];
        }
        [self displayResult:resultIds selection:selection];
        
        resolve(resultArr);
        
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}
/**
 * 根据给定的结点 ID 进行上游追踪，即查找给定结点的上游，返回上游包含的弧段、结点及总耗费
 * @param nodeID
 * @param weightName
 * @param isUncertainDirectionValid
 */
RCT_REMAP_METHOD(traceUpFromNode,traceUpFromNodeById:(NSArray *)nodeIDs weightName:(NSString*)weightName isUncertainDirectionValid:(BOOL)isUncertainDirectionValid resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        facilityAnalyst = [self getFacilityAnalyst];
        
        NSArray* resultIds = [[NSArray alloc] init];
        NSMutableArray* resultArr = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < nodeIDs.count; i++) {
            int nodeID = [(NSNumber *)nodeIDs[i] intValue];
            FacilityAnalystResult* result = [facilityAnalyst traceDownFromNode:nodeID weightName:weightName isUncertainDirectionValid:isUncertainDirectionValid];
            
            double cost = result.dCost;
            NSArray* edges = result.edges;
            NSArray* nodes = result.nodes;
            
            resultIds = [resultIds arrayByAddingObjectsFromArray:edges];
            
            [resultArr addObject:@{@"coast":@(cost),
                                   @"edges":edges,
                                   @"nodes":nodes
                                   }];
        }
        [self displayResult:resultIds selection:selection];
        resolve(resultArr);
        
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(clear, clearWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if (selection) {
            [selection clear];
        }
        startNodeID = -1;
        endNodeID = -1;
        startPoint = nil;
        endPoint = nil;
        [middleNodeIDs removeAllObjects];
        [[SMap singletonInstance].smMapWC.mapControl.map.trackingLayer clear];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}
@end

//
//  STransportationAnalyst.m
//  Supermap
//
//  Created by Shanglong Yang on 2019/6/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "STransportationAnalyst.h"

static TransportationAnalyst* transportationAnalyst = nil;
static Selection* selection = nil;

@implementation STransportationAnalyst
RCT_EXPORT_MODULE();

- (TransportationAnalyst *)getTransportationAnalyst{
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        transportationAnalyst = [[TransportationAnalyst alloc] init];
    });
    
    return transportationAnalyst;
}

#pragma mark - 设置起点
RCT_REMAP_METHOD(setStartPoint, setStartPoint:(NSDictionary *)point text:(NSString *)text resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSString* nodeTag = @"startNode";
        NSString* textTag = @"startNodeText";
        int pointID = 3614;
        GeoStyle* style = [[GeoStyle alloc] init];
        [style setMarkerSize:[[Size2D alloc] initWithWidth:10 Height:10]];
        [style setLineColor:[[Color alloc] initWithR:255 G:105 B:0]];
        [style setMarkerSymbolID:pointID];
        Point2D* tempPoint = [self selectPoint:point layer:nodeLayer geoStyle:style tag:nodeTag];
        if (tempPoint) {
            if (startPoint) {
                [self removeTagFromTrackingLayer:nodeTag];
                [self removeTagFromTrackingLayer:textTag];
                startPoint = nil;
                
                int i = 0;
                while (i < history.getCount) {
                    NSDictionary* item = [history get:i];
                    if (
                        [[item objectForKey:@"tag"] isEqualToString:@"startNode"] ||
                        [[item objectForKey:@"tag"] isEqualToString:@"startNodeText"]
                        ) {
                        [history removeObjectAtIndex:i];
                    } else {
                        i++;
                    }
                }
            }
            if (nodeLayer) {
                startPoint = tempPoint;
                Color* labelColor = [[Color alloc] initWithR:255 G:105 B:0];
                TextStyle* textStyle = [[TextStyle alloc]init];
                [textStyle setOutline:YES];
                [textStyle setFontWidth:6];
                [textStyle setFontHeight:8];
                [textStyle setForeColor:labelColor];
                [self setText:text point:startPoint textStyle:textStyle tag:textTag];
                
                NSMutableDictionary* nodeData = [[NSMutableDictionary alloc] init];
                [nodeData setObject:nodeTag forKey:@"tag"];
                [nodeData setObject:textTag forKey:@"labelTag"];
                [nodeData setObject:text forKey:@"label"];
                [nodeData setObject:startPoint forKey:@"point"];
                [nodeData setObject:@(pointID) forKey:@"pointID"];
                [nodeData setObject:style forKey:@"pointStyle"];
                [nodeData setObject:textStyle forKey:@"labelStyle"];
                if (history == nil) {
                    history = [[History alloc] init];
                }
                [history addHistory:nodeData];
            }
            [[SMap singletonInstance].smMapWC.mapControl.map refresh];
            
            resolve(@(startNodeID));
        } else {
            resolve(@(-1));
        }
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}

#pragma mark - 设置终点
RCT_REMAP_METHOD(setEndPoint, setEndPoint:(NSDictionary *)point text:(NSString *)text resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSString* nodeTag = @"endNode";
        NSString* textTag = @"endNodeText";
        int pointID = 3614;
        GeoStyle* style = [[GeoStyle alloc] init];
        [style setMarkerSize:[[Size2D alloc] initWithWidth:10 Height:10]];
        [style setLineColor:[[Color alloc] initWithR:105 G:255 B:0]];
        [style setMarkerSymbolID:pointID];
        Point2D* tempPoint = [self selectPoint:point layer:nodeLayer geoStyle:style tag:nodeTag];
        if (tempPoint) {
            if (endPoint) {
                [self removeTagFromTrackingLayer:nodeTag];
                [self removeTagFromTrackingLayer:textTag];
                endPoint = nil;
                
                int i = 0;
                while (i < history.getCount) {
                    NSDictionary* item = [history get:i];
                    if (
                        [[item objectForKey:@"tag"] isEqualToString:@"endNode"] ||
                        [[item objectForKey:@"tag"] isEqualToString:@"endNodeText"]
                        ) {
                        [history removeObjectAtIndex:i];
                    } else {
                        i++;
                    }
                }
            }
            if (nodeLayer) {
                endPoint = tempPoint;
                TextStyle* textStyle = [[TextStyle alloc]init];
                [textStyle setOutline:YES];
                [textStyle setFontWidth:6];
                [textStyle setFontHeight:8];
                [textStyle setForeColor:[[Color alloc] initWithR:105 G:255 B:0]];
                [self setText:text point:endPoint textStyle:textStyle tag:textTag];
                
                NSMutableDictionary* nodeData = [[NSMutableDictionary alloc] init];
                [nodeData setObject:nodeTag forKey:@"tag"];
                [nodeData setObject:textTag forKey:@"labelTag"];
                [nodeData setObject:text forKey:@"label"];
                [nodeData setObject:endPoint forKey:@"point"];
                [nodeData setObject:@(pointID) forKey:@"pointID"];
                [nodeData setObject:style forKey:@"pointStyle"];
                [nodeData setObject:textStyle forKey:@"labelStyle"];
                if (history == nil) {
                    history = [[History alloc] init];
                }
                [history addHistory:nodeData];
            }
            [[SMap singletonInstance].smMapWC.mapControl.map refresh];
            
            resolve(@(endNodeID));
        } else {
            resolve(@(-1));
        }
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}

#pragma mark - 添加障碍点
RCT_REMAP_METHOD(addBarrierNode, addBarrierNode:(NSDictionary *)point text:(NSString *)text resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSString* nodeTag = [NSString stringWithFormat:@"barrier_node_%ld", (long)[[NSDate date] timeIntervalSince1970]];
        int pointID = 3614;
        int node = -1;
        if (nodeLayer) {
            GeoStyle* style = [[GeoStyle alloc] init];
            [style setMarkerSize:[[Size2D alloc] initWithWidth:10 Height:10]];
            [style setLineColor:[[Color alloc] initWithR:255 G:0 B:0]];
            [style setMarkerSymbolID:3614];
//            node = [self selectNode:point layer:nodeLayer geoStyle:style tag:nodeTag];
            
//            Point2D* p2D = [self selectPoint:point layer:nodeLayer geoStyle:style tag:nodeTag];
            NSDictionary* dic = [self selectNodeWithPoint:point layer:nodeLayer geoStyle:style tag:nodeTag];
            Point2D* p2D = [dic objectForKey:@"point"];
            node = [[dic objectForKey:@"ID"] intValue];;
            
            if (!barrierNodes) barrierNodes = [[NSMutableArray alloc] init];
            if (node > 0) [barrierNodes addObject:@(node)];
            
            if (p2D) {
                [self addBarrierPoints:p2D];
                
                TextStyle* textStyle = [[TextStyle alloc]init];
                [textStyle setOutline:YES];
                [textStyle setFontWidth:6];
                [textStyle setFontHeight:8];
                [textStyle setForeColor:[[Color alloc] initWithR:255 G:0 B:0]];
                NSString* label = [NSString stringWithFormat:@"%@%d", text, barrierPoints.getCount];
                [self setText:label point:p2D textStyle:textStyle tag:nodeTag];
            
                NSMutableDictionary* nodeData = [[NSMutableDictionary alloc] init];
                [nodeData setObject:nodeTag forKey:@"tag"];
                [nodeData setObject:nodeTag forKey:@"labelTag"];
                [nodeData setObject:label forKey:@"label"];
                [nodeData setObject:p2D forKey:@"point"];
                [nodeData setObject:@(node) forKey:@"nodeID"];
                [nodeData setObject:@(pointID) forKey:@"pointID"];
                [nodeData setObject:style forKey:@"pointStyle"];
                [nodeData setObject:textStyle forKey:@"labelStyle"];
                if (history == nil) {
                    history = [[History alloc] init];
                }
                [history addHistory:nodeData];
            }
            [[SMap singletonInstance].smMapWC.mapControl.map refresh];
        }
        
//        resolve(@(node));
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}

#pragma mark - 添加结点
RCT_REMAP_METHOD(addNode, addNode:(NSDictionary *)point text:(NSString *)text resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSString* nodeTag = [NSString stringWithFormat:@"node_%ld", (long)[[NSDate date] timeIntervalSince1970]];
//        int node = -1;
        int pointID = 3614;
        if (nodeLayer) {
            GeoStyle* style = [[GeoStyle alloc] init];
            [style setMarkerSize:[[Size2D alloc] initWithWidth:10 Height:10]];
            [style setLineColor:[[Color alloc] initWithR:212 G:161 B:70]];
            [style setMarkerSymbolID:pointID];
//            node = [self selectNode:point layer:nodeLayer geoStyle:style tag:nodeTag];
//            if (!nodes) nodes = [[NSMutableArray alloc] init];
//            if (node > 0) [nodes addObject:@(node)];
            
            Point2D* p2D = [self selectPoint:point layer:nodeLayer geoStyle:style tag:nodeTag];
            if (p2D) {
                [self addPoint:p2D];
                
                TextStyle* textStyle = [[TextStyle alloc]init];
                [textStyle setOutline:YES];
                [textStyle setFontWidth:6];
                [textStyle setFontHeight:8];
                [textStyle setForeColor:[[Color alloc] initWithR:212 G:161 B:70]];
                NSString* label = [NSString stringWithFormat:@"%@%d", text, points.getCount];
                [self setText:label point:p2D textStyle:textStyle tag:nodeTag];
            
                NSMutableDictionary* nodeData = [[NSMutableDictionary alloc] init];
                [nodeData setObject:nodeTag forKey:@"tag"];
                [nodeData setObject:nodeTag forKey:@"labelTag"];
                [nodeData setObject:label forKey:@"label"];
                [nodeData setObject:p2D forKey:@"point"];
                [nodeData setObject:@(pointID) forKey:@"pointID"];
                [nodeData setObject:style forKey:@"pointStyle"];
                [nodeData setObject:textStyle forKey:@"labelStyle"];
                if (history == nil) {
                    history = [[History alloc] init];
                }
                [history addHistory:nodeData];
            }
            [[SMap singletonInstance].smMapWC.mapControl.map refresh];
        }
        
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}

#pragma mark - 清除记录
RCT_REMAP_METHOD(clear, clearWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if (selection) {
            [selection clear];
        }
        startNodeID = -1;
        endNodeID = -1;
        startPoint = nil;
        endPoint = nil;
        if (nodes) [nodes removeAllObjects];
        if (barrierNodes) [barrierNodes removeAllObjects];
        if (points) [points clear];
        if (barrierPoints) [barrierPoints clear];
        if (history) [history clear];
        [[SMap singletonInstance].smMapWC.mapControl.map.trackingLayer clear];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}

#pragma mark - 清除记录
RCT_REMAP_METHOD(clearRoutes, clearRoutesWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [self clearRoutes:selection];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}

#pragma mark 加载设施网络分析模型
RCT_REMAP_METHOD(load, loadByDatasource:(NSDictionary *)datasourceInfo setting:(NSDictionary *)settingDic resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Workspace* workspace = [SMap singletonInstance].smMapWC.workspace;
        Layers* layers = [SMap singletonInstance].smMapWC.mapControl.map.layers;
        TransportationAnalystSetting* setting = nil;
        Dataset* ds = nil;
        
        if ([datasourceInfo objectForKey:@"server"]) {
            DatasourceConnectionInfo* connectInfo = [SMDatasource convertDicToInfo:datasourceInfo];
            Datasources* dss = workspace.datasources;
            Datasource* datasource = [dss getAlias:[datasourceInfo objectForKey:@"alias"]];
            if (!datasource) {
                datasource = [dss open:connectInfo];
            }
            
            NSString* datasetName = [settingDic objectForKey:@"networkDataset"];
            if (datasetName) {
                ds = [datasource.datasets getWithName:datasetName];
                NSString* layerName = [NSString stringWithFormat:@"%@@%@", ds.name, datasource.alias];
                layer = [SMLayer findLayerWithName:layerName];
                if (!layer) {
//                    [[SMap singletonInstance].smMapWC.mapControl.map setDynamicProjection:YES];
                    layer = [layers addDataset:ds ToHead:YES];
                    layer.selectable = NO;
                    
                    Dataset* nodeDataset = ((DatasetVector *)ds).childDataset;
                    if (nodeDataset) {
                        nodeLayer = [layers addDataset:nodeDataset ToHead:YES];
                        nodeLayer.selectable = YES;
                        nodeLayer.visible = YES;
                    }
                } else {
                    NSRange range = [layer.name rangeOfString:@"@"];
                    NSString* name = [layer.name substringToIndex:range.location];
                    NSString* dsName = [layer.name substringFromIndex:NSMaxRange(range)];
                    if (![name isEqualToString:@""] && ![dsName isEqualToString:@""]) {
                        NSString* nodeLayerName = [NSString stringWithFormat:@"%@_Node@%@", name, dsName];
                        nodeLayer = [SMLayer findLayerWithName:nodeLayerName];
                    }
                }
            }
            
        } else {
            if ([settingDic objectForKey:@"networkDataset"]) {
                layer = [SMLayer findLayerByDatasetName:[settingDic objectForKey:@"networkDataset"]];
            }
        }
        
        if (layer) {
            ds = layer.dataset;
            selection = [layer getSelection];
            
            if (transportationAnalyst) {
                [transportationAnalyst dispose];
                transportationAnalyst = NULL;
            }
            transportationAnalyst = [[TransportationAnalyst alloc] init];
            
            setting = [SMAnalyst setTransportSetting:settingDic];
            setting.networkDataset = (DatasetVector *)ds;
            [transportationAnalyst setAnalystSetting:setting];
            
            BOOL result = [transportationAnalyst load];
            NSNumber* number = [NSNumber numberWithBool:result];
            
            [[SMap singletonInstance].smMapWC.mapControl setAction:PAN];
            
            NSMutableDictionary* layerInfo = [SMLayer getLayerInfo:layer path:@""];
            
            resolve(@{
                      @"result": number,
                      @"layerInfo": layerInfo,
                      });
        } else {
            reject(@"STransportationAnalyst", @"No networkDataset", nil);
        }
    } @catch (NSException *exception) {
        reject(@"STransportationAnalyst", exception.reason, nil);
    }
}

#pragma mark - 最佳路径分析
RCT_REMAP_METHOD(findPath,findPath:(NSDictionary*)params hasLeastEdgeCount:(BOOL)hasLeastEdgeCount resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
//        transportationAnalyst = [self getTransportationAnalyst];
        if (!params) params = [[NSDictionary alloc] init];
        TransportationAnalystParameter* paramter = [SMAnalyst getTransportationAnalystParameterByDictionary:params];
        
//        if (paramter.nodes.count <= 0) {
//            NSMutableArray* mNodes;
//            if (nodes && nodes.count > 0) {
//                mNodes = [NSMutableArray arrayWithArray:nodes];
//            } else {
//                mNodes = [[NSMutableArray alloc] init];
//            }
//            if (startNodeID > 0) {
//                [mNodes insertObject:@(startNodeID) atIndex:0];
//            }
//            if (endNodeID > 0) {
//                [mNodes addObject:@(endNodeID)];
//            }
//            paramter.nodes = mNodes;
//        }

        if (paramter.barrierNodes.count <= 0) {
            paramter.barrierNodes = barrierNodes;
        }
        
        if (paramter.points.getCount <= 0) {
            if (!points) points = [[Point2Ds alloc] init];
            Point2Ds* ps = [[Point2Ds alloc] initWithPoint2Ds:points];
            if (startPoint) {
                [ps insertIndex:0 Point2D:startPoint];
            }
            if (endPoint > 0) {
                [ps add:endPoint];
            }
            paramter.points = ps;
        }
        
        if (paramter.barrierPoints.getCount <= 0 && barrierPoints && [barrierPoints getCount] > 0) {
            paramter.barrierPoints = barrierPoints;
        }
        
        TransportationAnalystResult* result = [transportationAnalyst findPath:paramter hasLeastEdgeCount:hasLeastEdgeCount];
        NSArray* edges = result.edges;
        NSArray* nodes = result.nodes;
//        NSMutableArray* pathGuides = result.pathGuides;
        NSMutableArray* routes = result.routes;
//        NSMutableArray* stops = result.stops;
//        NSMutableArray* stopWeights = result.stopWeights;
//        NSMutableArray* weights = result.weights;
        
        long routesCount = 0;
        if (routes) {
            routesCount = [routes count];
            [self displayRoutes:routes];
        }
        
        resolve(@{@"edges":edges ? edges : @[],
                  @"nodes":nodes ? nodes : @[],
                  @"routesCount": @(routesCount),
//                  @"pathGuides":pathGuides,
//                  @"routes":routes,
//                  @"stops":stops,
//                  @"stopWeights":stopWeights,
//                  @"weights":weights,
                  });
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}

#pragma mark - 旅行商分析
RCT_REMAP_METHOD(findTSPPath, findTSPPath:(NSDictionary*)params isEndNodeAssigned:(BOOL)isEndNodeAssigned resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
//        transportationAnalyst = [self getTransportationAnalyst];
        if (!params) params = [[NSDictionary alloc] init];
        TransportationAnalystParameter* paramter = [SMAnalyst getTransportationAnalystParameterByDictionary:params];
        
//        if (paramter.nodes.count <= 0) {
//            NSMutableArray* mNodes;
//            if (nodes && nodes.count > 0) {
//                mNodes = [NSMutableArray arrayWithArray:nodes];
//            } else {
//                mNodes = [[NSMutableArray alloc] init];
//            }
//            if (startNodeID > 0) {
//                [mNodes insertObject:@(startNodeID) atIndex:0];
//            }
//            if (endNodeID > 0) {
//                [mNodes addObject:@(endNodeID)];
//            }
//            paramter.nodes = mNodes;
//        }

        if (paramter.barrierNodes.count <= 0) {
            paramter.barrierNodes = barrierNodes;
        }
        
        if (paramter.points.getCount <= 0) {
            if (!points) points = [[Point2Ds alloc] init];
            Point2Ds* ps = [[Point2Ds alloc] initWithPoint2Ds:points];
            if (startPoint) {
                [ps insertIndex:0 Point2D:startPoint];
            }
            if (endPoint > 0) {
                [ps add:endPoint];
            }
            paramter.points = ps;
        }
        
        if (paramter.barrierPoints.getCount <= 0) {
            paramter.barrierPoints = barrierPoints;
        }
        
        TransportationAnalystResult* result = [transportationAnalyst findTSPPath:paramter isEndNodeAssigned:isEndNodeAssigned];
        NSArray* edges = result.edges;
        NSArray* nodes = result.nodes;
//        NSMutableArray* pathGuides = result.pathGuides;
        NSMutableArray* routes = result.routes;
//        NSMutableArray* stops = result.stops;
//        NSMutableArray* stopWeights = result.stopWeights;
//        NSMutableArray* weights = result.weights;
        
        long routesCount = 0;
        if (routes) {
            routesCount = [routes count];
            [self displayRoutes:routes];
        }
        
        resolve(@{@"edges":edges ? edges : @[],
                  @"nodes":nodes ? nodes : @[],
                  @"routesCount":@(routesCount),
//                  @"pathGuides":pathGuides,
//                  @"routes":routes,
//                  @"stops":stops,
//                  @"stopWeights":stopWeights,
//                  @"weights":weights,
                  });
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}

#pragma mark - 分析撤销
RCT_REMAP_METHOD(undo, undoWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        int preIndex = [history undo];
        if (preIndex == -1) {
            resolve(@(NO));
        } else {
            NSDictionary* node = [history get:preIndex];
            
            NSString* tag = [node objectForKey:@"tag"];
            NSString* labelTag = [node objectForKey:@"labelTag"];
            
            if ([tag containsString:@"barrier_node_"] && barrierNodes != nil && barrierNodes.count > 0) {
//                [barrierPoints remove:barrierPoints.getCount - 1];
                [barrierNodes removeLastObject];
            } else if ([tag containsString:@"node_"] && barrierPoints != nil) {
                [points remove:points.getCount - 1];
            } else if ([tag isEqualToString:@"startNode"]) {
                startPoint = nil;
            } else if ([tag isEqualToString:@"endNode"]) {
                endPoint = nil;
            }
            TrackingLayer* trackingLayer = [SMap singletonInstance].smMapWC.mapControl.map.trackingLayer;

            if ([trackingLayer indexof:tag] >= 0) [trackingLayer removeAt:[trackingLayer indexof:tag]];
            if ([trackingLayer indexof:labelTag] >= 0) [trackingLayer removeAt:[trackingLayer indexof:labelTag]];

            [[SMap singletonInstance].smMapWC.mapControl.map refresh];
            resolve(@(YES));
        }
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}

#pragma mark - 分析回退
RCT_REMAP_METHOD(redo, redoWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        int preIndex = [history redo];
        if (preIndex == history.getCount - 1) {
            resolve(@(NO));
        } else {
            NSDictionary* node = [history get:history.currentIndex];
            
            NSString* tag = [node objectForKey:@"tag"];
            NSString* labelTag = [node objectForKey:@"labelTag"];
            NSString* label = [node objectForKey:@"label"];
            TextStyle* labelStyle = (TextStyle *)[node objectForKey:@"labelStyle"];
            GeoStyle* pointStyle = (GeoStyle *)[node objectForKey:@"pointStyle"];
            int pointID = [[node objectForKey:@"pointID"] intValue];
            Point2D* point2D = [node objectForKey:@"point"];
            
            if ([tag containsString:@"barrier_node_"] && barrierNodes != nil && [[node objectForKey:@"nodeID"] intValue] >= 0) {
                int nodeID = [[node objectForKey:@"nodeID"] intValue];
                [barrierNodes addObject:@(nodeID)];
            } else if ([tag containsString:@"node_"] && points != nil) {
                [points add:point2D];
            } else if ([tag isEqualToString:@"startNode"]) {
                startPoint = point2D;
            } else if ([tag isEqualToString:@"endNode"]) {
                endPoint = point2D;
            }
            TrackingLayer* trackingLayer = [SMap singletonInstance].smMapWC.mapControl.map.trackingLayer;
            GeoPoint* geoPoint = [[GeoPoint alloc] initWithX:point2D.x Y:point2D.y];
            if (pointStyle == nil) {
                pointID = pointID > 0 ? pointID : 3614;
                [pointStyle setMarkerID:[NSString stringWithFormat:@"%d", pointID]];
            }
            [geoPoint setStyle:pointStyle];
            
            [trackingLayer addGeometry:geoPoint WithTag:tag];
            [self setText:label point:point2D textStyle:labelStyle tag:labelTag];
            
            [geoPoint dispose];

            [[SMap singletonInstance].smMapWC.mapControl.map refresh];
            resolve(@(YES));
        }
    } @catch (NSException *exception) {
        reject(@"SFacilityAnalyst", exception.reason, nil);
    }
}

- (void)displayRoutes:(NSMutableArray *)routesArr {
    for (int i = 0; i < routesArr.count; i++) {
        GeoLineM* line = routesArr[i];
        GeoStyle* style = [self getGeoStyle:[[Size2D alloc] initWithWidth:10 Height:10] color:[[Color alloc] initWithR:255 G:80 B:0]];
        [line setStyle:style];
        TrackingLayer* trackingLayer = [SMap singletonInstance].smMapWC.mapControl.map.trackingLayer;
        [trackingLayer addGeometry:line WithTag:@"route"];
    }
    [[SMap singletonInstance].smMapWC.mapControl.map refresh];
}

- (void)addPoint:(Point2D *)point {
    if (!points) points = [[Point2Ds alloc] init];
    BOOL isExist = NO;
    for (int i = 0; i < points.getCount; i++) {
        Point2D* pt = [points getItem:i];
        if (pt.x == point.x && pt.y == point.y) {
            isExist = YES;
            break;
        }
    }
    if (!isExist) {
        Map* map = [SMap singletonInstance].smMapWC.mapControl.map;
        if ([map.prjCoordSys type] != transportationAnalyst.analystSetting.networkDataset.prjCoordSys.type) {//若投影坐标不是经纬度坐标则进行转换
            Point2Ds *points = [[Point2Ds alloc] init];
            [points add:point];
            PrjCoordSys *srcPrjCoorSys = [[PrjCoordSys alloc]init];
            [srcPrjCoorSys setType:[map.prjCoordSys type]];
            CoordSysTransParameter *param = [[CoordSysTransParameter alloc]init];
            
            //根据源投影坐标系与目标投影坐标系对坐标点串进行投影转换，结果将直接改变源坐标点串
            [CoordSysTranslator convert:points PrjCoordSys:srcPrjCoorSys PrjCoordSys:[map prjCoordSys] CoordSysTransParameter:param CoordSysTransMethod:(CoordSysTransMethod)9603];
            point = [points getItem:0];
        }
        [points add:point];
    }
}

- (void)addBarrierPoints:(Point2D *)point {
    if (!barrierPoints) barrierPoints = [[Point2Ds alloc] init];
    BOOL isExist = NO;
    for (int i = 0; i < barrierPoints.getCount; i++) {
        Point2D* pt = [barrierPoints getItem:i];
        if (pt.x == point.x && pt.y == point.y) {
            isExist = YES;
            break;
        }
    }
    if (!isExist) {
        Map* map = [SMap singletonInstance].smMapWC.mapControl.map;
        if ([map.prjCoordSys type] != transportationAnalyst.analystSetting.networkDataset.prjCoordSys.type) {//若投影坐标不是经纬度坐标则进行转换
            Point2Ds *points = [[Point2Ds alloc] init];
            [points add:point];
            PrjCoordSys *srcPrjCoorSys = [[PrjCoordSys alloc]init];
            [srcPrjCoorSys setType:transportationAnalyst.analystSetting.networkDataset.prjCoordSys.type];
            CoordSysTransParameter *param = [[CoordSysTransParameter alloc]init];
            
            //根据源投影坐标系与目标投影坐标系对坐标点串进行投影转换，结果将直接改变源坐标点串
            [CoordSysTranslator convert:points PrjCoordSys:srcPrjCoorSys PrjCoordSys:[map prjCoordSys] CoordSysTransParameter:param CoordSysTransMethod:(CoordSysTransMethod)9603];
            point = [points getItem:0];
        }
        
        [barrierPoints add:point];
    }
}
@end

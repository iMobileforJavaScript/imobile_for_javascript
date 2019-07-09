//
//  SNetworkAnalyst.h
//  Supermap
//
//  Created by Shanglong Yang on 2019/6/24.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import "SuperMap/FacilityAnalyst.h"
#import "SuperMap/FacilityAnalystResult.h"
#import "SuperMap/FacilityAnalystSetting.h"
#import "SuperMap/WeightFieldInfos.h"
#import "SuperMap/WeightFieldInfo.h"
#import "SuperMap/Workspace.h"
#import "SuperMap/Dataset.h"
#import "SuperMap/Datasets.h"
#import "SuperMap/DatasetVector.h"
#import "SuperMap/Datasource.h"
#import "SuperMap/Datasources.h"
#import "SuperMap/DatasourceConnectionInfo.h"
#import "SuperMap/Selection.h"
#import "SuperMap/TrackingLayer.h"
#import "SuperMap/Layers.h"
#import "SuperMap/Layer.h"
#import "SuperMap/Recordset.h"
#import "SuperMap/Geometry.h"
#import "SuperMap/GeoStyle.h"
#import "SuperMap/Size2D.h"
#import "SuperMap/Color.h"
#import "SuperMap/GeoPoint.h"
#import "SMap.h"
#import "SMLayer.h"
#import "SMDatasource.h"
#import "SMParameter.h"

@interface SNetworkAnalyst : NSObject<RCTBridgeModule> {
@public
    Layer* layer;
    Layer* nodeLayer;
    Selection* selection;
    NSMutableArray* elementIDs;
    int startNodeID;
    int endNodeID;
    Point2D* startPoint;
    Point2D* endPoint;
    NSMutableArray* middleNodeIDs;
}
- (void)displayResult:(NSArray *)ids selection:(Selection *)selection;
- (GeoStyle *)getGeoStyle:(Size2D *)size2D color:(Color *)color;
- (void)clear:(Selection *)selection;
- (int)selectNode:(NSDictionary *)point layer:(Layer *)layer geoStyle:(GeoStyle *)geoStyle tag:(NSString *)tag;
- (Point2D *)selectPoint:(NSDictionary *)point layer:(Layer *)layer geoStyle:(GeoStyle *)geoStyle tag:(NSString *)tag;
//- (Point2D *)selectByPoint:(NSDictionary *)point layer:(Layer *)nodeLayer geoStyle:(GeoStyle *)geoStyle tag:(NSString *)tag;
- (void)removeTagFromTrackingLayer:(NSString *)tag;
@end

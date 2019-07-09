//
//  STransportationAnalyst.h
//  Supermap
//
//  Created by Shanglong Yang on 2019/6/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import "SuperMap/TransportationAnalyst.h"
#import "SuperMap/TransportationAnalystResult.h"
#import "SuperMap/TransportationAnalystSetting.h"
#import "SuperMap/TransportationAnalystParameter.h"
#import "SuperMap/WeightFieldInfos.h"
#import "SuperMap/WeightFieldInfo.h"
#import "SuperMap/Workspace.h"
#import "SuperMap/Dataset.h"
#import "SuperMap/DatasetVector.h"
#import "SuperMap/Datasource.h"
#import "SuperMap/Datasources.h"
#import "SuperMap/DatasourceConnectionInfo.h"
#import "SuperMap/Selection.h"
#import "SuperMap/TrackingLayer.h"
#import "SuperMap/Recordset.h"
#import "SuperMap/Geometry.h"
#import "SuperMap/GeoStyle.h"
#import "SuperMap/Size2D.h"
#import "SuperMap/Color.h"
#import "SuperMap/Point2Ds.h"
#import "SuperMap/GeoLineM.h"
#import "SMap.h"
#import "SMDatasource.h"
#import "SMAnalyst.h"
#import "SNetworkAnalyst.h"

@interface STransportationAnalyst : SNetworkAnalyst {
@public
    NSMutableArray* nodes;
    NSMutableArray* barrierNodes;
    Point2Ds* points;
    Point2Ds* barrierPoints;
}
- (TransportationAnalyst *)getTransportationAnalyst;

@end

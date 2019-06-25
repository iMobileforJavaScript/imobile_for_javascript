//
//  SFacilityAnalyst.h
//  Supermap
//
//  Created by Shanglong Yang on 2019/6/19.
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
#import "SuperMap/Recordset.h"
#import "SuperMap/Geometry.h"
#import "SuperMap/GeoStyle.h"
#import "SuperMap/Size2D.h"
#import "SuperMap/Color.h"
#import "SMap.h"
#import "SMLayer.h"
#import "SMDatasource.h"
#import "SMParameter.h"
#import "SNetworkAnalyst.h"

@interface SFacilityAnalyst : SNetworkAnalyst
- (FacilityAnalyst *)getFacilityAnalyst;
//- (GeoStyle *)getGeoStyle:(Size2D *)size2D color:(Color *)color;
//- (void)displayResult:(NSArray *)ids;
@end

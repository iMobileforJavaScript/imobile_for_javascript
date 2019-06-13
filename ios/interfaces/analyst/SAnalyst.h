//
//  SAnalyst.h
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/30.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import "SMap.h"
#import "JSBufferAnalyst.h"
#import "SuperMap/BufferAnalyst.h"
#import "SuperMap/Map.h"
#import "SuperMap/Selection.h"
#import "SuperMap/TrackingLayer.h"
#import "SuperMap/Recordset.h"
#import "SuperMap/PrjCoordSys.h"
#import "SuperMap/DatasetVector.h"
#import "SuperMap/BufferAnalystParameter.h"
#import "SuperMap/BufferAnalystGeometry.h"
#import "SuperMap/GeoStyle.h"
#import "SuperMap/Color.h"
#import "SuperMap/Size2D.h"
#import "SuperMap/GeoRegion.h"
#import "SuperMap/Layer.h"
#import "SuperMap/Layers.h"
#import "SuperMap/Datasources.h"
#import "SuperMap/Datasource.h"
#import "SuperMap/Dataset.h"
#import "SuperMap/DatasetType.h"
#import "SuperMap/encodeType.h"
#import "SuperMap/Datasets.h"
#import "SuperMap/DatasetVectorInfo.h"
#import "SuperMap/BufferRadiusUnit.h"
#import "SuperMap/LayerSettingVector.h"
#import "SuperMap/OverlayAnalyst.h"
#import "SuperMap/DensityAnalystOnline.h"
#import "SuperMap/AggreatePointsOnline.h"
#import "SuperMap/Rectangle2D.h"

#import "Constants.h"
#import "SScene.h"
#import "SMSceneWC.h"
#import "AnalysisHelper3D.h"
#import "SMLayer.h"

@interface SAnalyst : RCTEventEmitter<RCTBridgeModule, DistributeAnalystDelegate>
@end

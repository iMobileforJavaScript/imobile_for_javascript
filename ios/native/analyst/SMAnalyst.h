//
//  SMAnalyst.h
//  Supermap
//
//  Created by Shanglong Yang on 2019/4/24.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
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
#import "SuperMap/TransportationAnalystParameter.h"
#import "SuperMap/Point2Ds.h"
#import "SuperMap/Point2D.h"
#import "SuperMap/FacilityAnalystSetting.h"
#import "SuperMap/WeightFieldInfo.h"
#import "SuperMap/WeightFieldInfos.h"
#import "SuperMap/TransportationAnalystSetting.h"
#import "SuperMap/InterpolationParameter.h"
#import "SuperMap/InterpolationKrigingParameter.h"
#import "SuperMap/InterpolationDensityParameter.h"
#import "SuperMap/InterpolationIDWParameter.h"
#import "SuperMap/InterpolationRBFParameter.h"
#import "SuperMap/Rectangle2D.h"

#import "Constants.h"
#import "SScene.h"
#import "SMSceneWC.h"
#import "AnalysisHelper3D.h"
#import "SMLayer.h"
#import "SMDatasource.h"

@interface SMAnalyst : NSObject
+ (Datasource *)getDatasourceByDictionary:(NSDictionary *)dic;
+ (Datasource *)getDatasourceByDictionary:(NSDictionary *)dic createIfNotExist:(BOOL)isCreate;
+ (GeoStyle *)getGeoStyleByDictionary:(NSDictionary *)geoStyleDic;
+ (BufferAnalystParameter *)getBufferAnalystParameterByDictionary:(NSDictionary *)parameter;
+ (Dataset *)getDatasetByDictionary:(NSDictionary *)dic;
+ (Dataset *)createDatasetByDictionary:(NSDictionary *)dic;
+ (BufferRadiusUnit)getBufferRadiusUnit:(NSString *)unitStr;
+ (Layer *)displayResult:(Dataset *)ds style:(GeoStyle *)style;
+ (BOOL)overlayerAnalystWithType:(NSString *)type sourceData:(NSDictionary *)sourceData targetData:(NSDictionary *)targetData resultData:(NSDictionary *)resultData optionParameter:(NSDictionary *)optionParameter;
+ (void)deleteDataset:(NSDictionary *)dsInfo;
+ (int)selectPoint:(NSDictionary *)point layer:(Layer *)layer geoStyle:(GeoStyle *)geoStyle;
+ (TransportationAnalystParameter *)getTransportationAnalystParameterByDictionary:(NSDictionary *)params;
+ (FacilityAnalystSetting *)setFacilitySetting:(NSDictionary *)data;
+ (TransportationAnalystSetting *)setTransportSetting:(NSDictionary *)data;
+ (WeightFieldInfo *)setWeightFieldInfo:(NSDictionary *)data;
+ (InterpolationParameter *)getInterpolationParameter:(NSDictionary *)data;
@end

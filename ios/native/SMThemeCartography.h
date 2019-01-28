//
//  SMThemeCartography.h
//  Supermap
//
//  Created by xianglong li on 2018/12/6.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "SuperMap/SuperMap.h"

@interface SMThemeCartography : NSObject
+(void)setGeoStyleColor:(DatasetType)type geoStyle:(GeoStyle*)geoStyle color:(Color*)color;
+(NSMutableArray*)getLastThemeColors:(Layer* )layer;
+(NSString*)getThemeColorSchemeName:(Layer* )layer;
+(Dataset* )getDataset:(NSString* ) datasetName datasourceIndex:(int) datasourceIndex;
+(Dataset* )getDataset:(NSString* ) datasetName datasourceAlias:(NSString* )datasourceAlias;
+(Dataset* )getDataset:(NSString* ) datasetName data:(NSDictionary *)data;
+(Layer* )getLayerByIndex:(int) layerIndex;
+(Layer* )getLayerByName:(NSString* )layerName;
+(GeoStyle* )getThemeUniqueGeoStyle:(GeoStyle*)style data:(NSDictionary* )data;
+(NSMutableDictionary* )getThemeUniqueDefaultStyle:(GeoStyle* )style;
+(ColorGradientType) getColorGradientType:(NSString*) type;
+(RangeMode)getRangeMode:(NSString*) strMode;
+(NSString*)rangeModeToStr:(RangeMode) mode;
+(NSString*)getFieldType:(FieldInfo*) info;
+(NSString*)getGeoCoordSysType:(GeoCoordSysType) type;
+(NSString*)getPrjCoordSysType:(PrjCoordSysType) type;
+(LabelBackShape)getLabelBackShape:(NSString*) shape;
+(NSString*)getLabelBackShapeString:(LabelBackShape) shape;
+(NSArray*)getColorList;
+(NSMutableDictionary*)getRangeColors:(NSString* )colorType;
+(NSMutableDictionary*)getUniqueColors:(NSString* )colorType;
+(NSString*)datasetTypeToString:(DatasetType)datasetType;
@end

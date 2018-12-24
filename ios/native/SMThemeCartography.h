//
//  SMThemeCartography.h
//  Supermap
//
//  Created by xianglong li on 2018/12/6.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "SuperMap/SuperMap.h"

@interface SMThemeCartography : NSObject

+(Dataset* )getDataset:(NSString* ) datasetName datasourceIndex:(int) datasourceIndex;
+(Dataset* )getDataset:(NSString* ) datasetName datasourceAlias:(NSString* )datasourceAlias;
+(Dataset* )getDataset:(NSString* ) datasetName data:(NSDictionary *)data;
+(Layer* )getLayerByIndex:(int) layerIndex;
+(Layer* )getLayerByName:(NSString* )layerName;
+(GeoStyle* )getThemeUniqueGeoStyle:(GeoStyle*)style data:(NSDictionary* )data;
+(NSMutableDictionary* )getThemeUniqueDefaultStyle:(GeoStyle* )style;
+(ColorGradientType) getColorGradientType:(NSString*) type;
+(LabelBackShape)getLabelBackShape:(NSString*) shape;
+(NSString*)getLabelBackShapeString:(LabelBackShape) shape;
+(NSArray*)getColorList;

@end

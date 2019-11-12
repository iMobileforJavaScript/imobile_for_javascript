//
//  SMThemeCartography.h
//  Supermap
//
//  Created by xianglong li on 2018/12/6.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "SuperMap/SuperMap.h"
#import "SuperMap/ThemeGraph.h"
#import "SuperMap/ThemeGridUnique.h"
#import "SuperMap/ThemeGridRange.h"
#import "SuperMap/ThemeGraduatedSymbol.h"
#import "SuperMap/ThemeDotDensity.h"
#import "SuperMap/LayerHeatmap.h"

@interface SMThemeCartography : NSObject
+(void)setGeoStyleColor:(DatasetType)type geoStyle:(GeoStyle*)geoStyle color:(Color*)color;
+(Color*)getGeoStyleColor:(DatasetType)type geoStyle:(GeoStyle*)geoStyle;
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
+(NSString*)getFieldType:(NSString*)language info:(FieldInfo*) info;
+(NSString*)getFieldTypeStr:(FieldInfo*)info;
+(NSString*)getGeoCoordSysType:(GeoCoordSysType) type;
+(NSString*)getPrjCoordSysType:(PrjCoordSysType) type;
+(LabelBackShape)getLabelBackShape:(NSString*) shape;
+(NSString*)getLabelBackShapeString:(LabelBackShape) shape;
+(NSArray*)getColorList;
+(NSArray*)getAggregationColors:(NSString* )colorType;
+(NSArray*)getRangeColors:(NSString* )colorType;
+(NSArray*)getUniqueColors:(NSString* )colorType;
+(NSArray*)getGraphColors:(NSString* )colorType;
+(NSString*)datasetTypeToString:(DatasetType)datasetType;
//新增统计专题图子项
+(BOOL)addGraphItem:(ThemeGraph*)themeGraph graphExpression:(NSString*)graphExpression colors:(Colors*)colors;
//获取统计专题图类型
+(ThemeGraphType)getThemeGraphType:(NSString*)type;
//获取统计专题图,等级符号专题图分级模式
+(GraduatedMode)getGraduatedMode:(NSString*)type;
+(BOOL)itemExist:(ThemeGraphItem*) item existItems:(NSArray*) existItems;
+(NSString*)getCaption:(NSString*)graphExpression;
+(BOOL)isDarkR:(int)r G:(int)g B:(int)b;
+(double)getMaxValue:(DatasetVector*)datasetVector dotExpression:(NSString*)dotExpression;
+(ThemeGraduatedSymbol*)getThemeGraduatedSymbol:(NSDictionary*)data;
+(ThemeDotDensity*) getThemeDotDensity:(NSDictionary*)data;
+(void)getGraphSizeMax:(double*)dMax min:(double*)dMin;

/**
 * 创建统计专题图
 * @param dataset
 * @param graphExpressions
 * @param themeGraphType
 * @param colors
 * @return
 */
+(BOOL)createThemeGraphMap:(Dataset*)dataset graphExpressions:(NSArray*)graphExpressions type:(ThemeGraphType)themeGraphType colors:(NSArray*)colors;
/**
 * 创建栅格单值专题图
 * @param dataset
 * @param colors
 * @return
 */
+(NSDictionary*)createThemeGridUniqueMap:(Dataset*)dataset colors:(NSArray*)colors;
/**
 * 创建栅格分段专题图
 * @param dataset
 * @param colors
 * @return
 */
+(NSDictionary*)createThemeGridRangeMap:(Dataset*)dataset colors:(NSArray*)colors;

/**
 * 修改栅格单值专题图
 * @param layer
 * @param newColors
 * @param specialValue
 * @param defaultColor
 * @param specialValueColor
 * @param isParams
 * @param isTransparent
 * @return
 */
+(BOOL)modifyThemeGridUniqueMap:(Layer*)layer colors:(NSArray*)newColors specialValue:(int)specialValue defaultColor:(Color*)defaultColor specialValueColor:(Color*)specialValueColor isParams:(BOOL)isParams  isTransparent:(BOOL)isTransparent;

/**
 * 修改栅格分段专题图
 * @param layer
 * @param rangeMode
 * @param rangeParameter
 * @param newColors
 * @return
 */
+(BOOL)modifyThemeGridRangeMap:(Layer*)layer rangeMode:(RangeMode)rangeMode  rangeParameter:(double)rangeParameter newColors:(NSArray*)newColors;

/**
 * 创建热力图
 * @param dataset
 * @param KernelRadius
 * @param FuzzyDegree
 * @param Intensity
 * @param colors
 * @return
 */
+(NSDictionary*)createLayerHeatMap:(Dataset*)dataset radius:(int)KernelRadius fuzzyDegree:(double)FuzzyDegree intensity:(double)Intensity colors:(NSArray *)colors;
@end

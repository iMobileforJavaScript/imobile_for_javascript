//
//  SMCartography.h
//  Supermap
//
//  Created by xianglong li on 2018/12/3.
//  Copyright © 2018 Facebook. All rights reserved.
//
#import "SuperMap/SuperMap.h"

@interface SMCartography : NSObject
+(TextAlignment )getTextAlignment:(NSString*)alignmentText;
+(Geometry *)getGeoText:(Recordset *)recordset;
+(Recordset *)getRecordset:(int )geometryID layerName:(NSString *)layerName;
+(LayerSettingGrid *)getLayerSettingGrid:(NSString*)layerName;
+(LayerSettingVector *)getLayerSettingVector:(NSString*)layerName;
+(Layer *)getLayerByName:(NSString*)layerName;
+(Layer *)getLayerByIndex:(int)layerIndex;

@end

//
//  SLayerManager.h
//  Supermap
//
//  Created by Yang Shang Long on 2018/11/16.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import "SMap.h"
#import "SMLayer.h"
#import <SuperMap/DatasetVector.h>
#import <SuperMap/FieldInfos.h>
#import <SuperMap/FieldInfo.h>
#import <SuperMap/QueryParameter.h>
#import <SuperMap/CursorType.h>
#import <SuperMap/Geometry.h>
#import <SuperMap/Recordset.h>
#import <SuperMap/LayerSettingVector.h>
#import <SuperMap/TrackingLayer.h>
#import <SuperMap/GeoLine.h>
#import <SuperMap/GeoRegion.h>
#import <SuperMap/GeoPoint.h>

@interface SLayerManager : NSObject<RCTBridgeModule>

@end

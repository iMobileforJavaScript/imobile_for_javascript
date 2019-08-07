//
//  SMap.h
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/26.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import "Constants.h"
#import "JSMapView.h"
#import "SuperMap/Environment.h"
#import "SuperMap/LicenseStatus.h"
#import "SuperMap/Dataset.h"
#import "SuperMap/Datasets.h"
#import "SuperMap/Layers.h"
#import "SuperMap/Maps.h"
#import "SuperMap/ThemeRange.h"
#import "SuperMap/Point2D.h"
#import "SuperMap/Point2Ds.h"
#import "SuperMap/Collector.h"
#import "SuperMap/CoordSysTransParameter.h"
#import "SuperMap/CoordSysTranslator.h"
#import "SuperMap/CoordSysTransMethod.h"
#import "SuperMap/PrjCoordSys.h"
#import "SuperMap/Collector.h"
#import "SuperMap/Layer.h"
#import "SuperMap/MapControl.h"
#import "SuperMap/Workspace.h"
#import "SuperMap/Resources.h"
#import "SuperMap/SymbolFillLibrary.h"
#import "SuperMap/SymbolLineLibrary.h"
#import "SuperMap/SymbolMarkerLibrary.h"
#import "SuperMap/Selection.h"
#import "SuperMap/Rectangle2D.h"
#import "SuperMap/EditHistory.h"
#import "SuperMap/GeoStyle.h"
#import "SuperMap/GeoRegion.h"
#import "SuperMap/TrackingLayer.h"
#import "SuperMap/GeoPoint.h"
#import "SuperMap/TextPart.h"
#import "SuperMap/TextStyle.h"
#import "SuperMap/GeoText.h"
#import "SuperMap/Legend.h"
#import "SuperMap/LegendItem.h"
#import "SuperMap/Size2D.h"
#import "SuperMap/Callout.h"
#import "SuperMap/Point2D.h"
#import "SuperMap/LayerSettingVector.h"
#import "JSMapControl.h"
#import "SMMapWC.h"
#import "SMSymbol.h"
#import "SMLayer.h"
#import "SOrientation.h"
#import "ScaleViewHelper.h"
#import "POISearchHelper2D.h"
#import "SMMap.h"
@interface SMap : RCTEventEmitter<RCTBridgeModule, MapMeasureDelegate, GeometrySelectedDelegate, MapEditDelegate, TouchableViewDelegate,AfterGeometryAddedDelegate,LegendContentDelegate,MapParameterChangedDelegate,PoiSearch2DDelegate>
@property (strong, nonatomic) SMMapWC* smMapWC;
@property (strong, nonatomic) Selection* selection;
@property (strong, nonatomic) ScaleViewHelper* scaleViewHelper;
@property (strong, nonatomic) POISearchHelper2D* poiSearchHelper2D;
///定时器
@property (nonatomic,strong) dispatch_source_t timer;

+ (instancetype)singletonInstance;
+ (void)setInstance:(MapControl *)mapControl;

@end

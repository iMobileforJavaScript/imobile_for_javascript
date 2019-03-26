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
#import "JSMapControl.h"
#import "SMMapWC.h"
#import "SMSymbol.h"
#import "SMLayer.h"

@interface SMap : RCTEventEmitter<RCTBridgeModule, MapMeasureDelegate, GeometrySelectedDelegate, MapEditDelegate, TouchableViewDelegate>
@property (strong, nonatomic) SMMapWC* smMapWC;
@property (strong, nonatomic) Selection* selection;

+ (instancetype)singletonInstance;
+ (void)setInstance:(MapControl *)mapControl;

@end

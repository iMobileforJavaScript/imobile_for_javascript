//
//  JSAdoptMapView.h
//  GeometryInfo
//
//  Created by 王子豪 on 2017/1/4.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import "SuperMap/MapControl.h"
#import "SuperMap/Map.h"
@interface JSAdoptMapView : RCTEventEmitter<RCTBridgeModule,MapParameterChangedDelegate,TouchableViewDelegate,MapEditDelegate,GeometrySelectedDelegate,MapMeasureDelegate>

@end

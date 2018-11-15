//
//  JSMapView.h
//  rnTest
//
//  Created by imobile-xzy on 16/7/12.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import "SuperMap/MapControl.h"
#import "SuperMap/Workspace.h"
@interface JSMapView  : NSObject<RCTBridgeModule,MapMeasureDelegate,GeometrySelectedDelegate,MapEditDelegate,TouchableViewDelegate>
@property (strong, nonatomic) Workspace* workspace;
@property (strong, nonatomic) MapControl* mapControl;

+ (instancetype)singletonInstance;
+ (void)setInstance:(MapControl*) mapControl;
@end

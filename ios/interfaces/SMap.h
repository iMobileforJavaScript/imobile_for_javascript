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
#import "SuperMap/MapControl.h"
#import "SuperMap/Workspace.h"
#import "JSMapControl.h"
#import "SMMapWC.h"

@interface SMap : RCTEventEmitter<RCTBridgeModule,MapMeasureDelegate,GeometrySelectedDelegate,MapEditDelegate,TouchableViewDelegate>
@property (strong, nonatomic) SMMapWC* smMapWC;
//@property (strong, nonatomic) MapControl* mapControl;

+ (instancetype)singletonInstance;
+ (void)setInstance:(MapControl *)mapControl;

@end

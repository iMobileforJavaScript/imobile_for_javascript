//
//  SPlot.h
//  Supermap
//
//  Created by zhouyuming on 2019/9/9.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>

#import <Foundation/Foundation.h>
#import "SuperMap/AnimationManager.h"
#import "SuperMap/AnimationGroup.h"
#import "SuperMap/AnimationGO.h"
#import "SuperMap/GeoGraphicObject.h"
#import "SuperMap/AnimationBlink.h"
#import "SuperMap/AnimationAttribute.h"
#import "SuperMap/AnimationShow.h"
#import "SuperMap/AnimationRotate.h"
#import "SuperMap/AnimationScale.h"
#import "SuperMap/AnimationGrow.h"
#import "SuperMap/AnimationWay.h"
#import "SuperMap/Point3D.h"
#import "SuperMap/GeoLine.h"
#import "SMap.h"
#import "SuperMap/Dataset.h"
#import "SuperMap/Datasets.h"
#import "SuperMap/Layer.h"
#import "SuperMap/Layers.h"
#import "FileUtils.h"

@interface SPlot : NSObject<RCTBridgeModule>
///定时器
@property (nonatomic,strong) dispatch_source_t timer;

@end

//
//  SScene.h
//  Supermap
//
//  Created by Yang Shang Long on 2018/11/9.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import "SuperMap/SceneControl.h"
#import "SuperMap/Scenes.h"
#import "SuperMap/Layer3Ds.h"
#import "SuperMap/Layer3D.h"
#import "SuperMap/Layer3DType.h"
#import "SuperMap/TerrainLayers.h"
#import "SuperMap/TerrainLayer.h"
#import "SuperMap/Scene.h"
#import "SuperMap/Selection3D.h"
#import "SuperMap/LocationManagePlugin.h"
#import "NativeUtil.h"
#import "SuperMap/GeoBox.h"
#import "SuperMap/Size2D.h"
#import <math.h>
@class SMSceneWC;
@interface SScene : RCTEventEmitter<RCTBridgeModule,SceneControlTouchDelegate>
@property (strong, nonatomic) SMSceneWC* smSceneWC;
//@property (strong, nonatomic) MapControl* mapControl;

+(void)setActionHelper:(Action3D)action;
+ (instancetype)singletonInstance;
+ (void)setInstance:(SceneControl *)sceneControl;
@end

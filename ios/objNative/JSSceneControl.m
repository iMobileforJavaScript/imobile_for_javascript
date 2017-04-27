//
//  JSSceneControl.m
//  Supermap
//
//  Created by 王子豪 on 2017/4/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//
#import <React/UIView+React.h>

#import "JSSceneControl.h"
#import "SuperMap/SceneControl.h"
#import "JSObjManager.h"

@implementation JSSceneControl
@synthesize bridge = _bridge;
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(getScene, getSceneByID:(NSString*)sceneControlId resolver:(RCTPromiseResolveBlock)resolve rejrcter:(RCTPromiseRejectBlock)reject){
    SceneControl* sceneCtr = [JSObjManager getObjWithKey:sceneControlId];
    Scene* scene = sceneCtr.scene;
    if (scene) {
        NSInteger nsSceneKey = (NSInteger)scene;
        [JSObjManager addObj:scene];
        resolve(@{@"sceneId":@(nsSceneKey).stringValue});
    }else{
        reject(@"sceneControl",@"getScene failed",nil);
    }
}

RCT_REMAP_METHOD(initWithViewCtrl, initByID:(NSString*)sceneControlId reactTag:(NSNumber*)tag resolver:(RCTPromiseResolveBlock)resolve rejrcter:(RCTPromiseRejectBlock)reject){
    SceneControl* sceneCtr = [JSObjManager getObjWithKey:sceneControlId];
    Scene* scene = sceneCtr.scene;
    if (scene) {
        NSInteger nsSceneKey = (NSInteger)scene;
        [JSObjManager addObj:scene];
        resolve(@{@"sceneId":@(nsSceneKey).stringValue});
    }else{
        reject(@"sceneControl",@"getScene failed",nil);
    }
}
@end

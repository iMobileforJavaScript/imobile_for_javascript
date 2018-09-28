//
//  JSScene.m
//  Supermap
//
//  Created by 王子豪 on 2017/4/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSScene.h"
#import "SuperMap/Scene.h"
#import "JSObjManager.h"
#import "SceneViewManager.h"
#import "JSSceneView.h"

@implementation JSScene

RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(setWorkspace,setWorkspaceBySceneId:(NSString*)sceneId workSpaceId:(NSString*)workSpaceId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Scene* scene = [JSObjManager getObjWithKey:sceneId];
    Workspace* workspace = [JSObjManager getObjWithKey:workSpaceId];
    if (scene&&workspace) {
        [scene setWorkspace:workspace];
        resolve(@"setted");
    }else
        reject(@"scene",@"scene setWorkSpace failed",nil);
}

RCT_REMAP_METHOD(getWorkspace,getWorkspaceBySceneId:(NSString*)sceneId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Scene* scene = [JSObjManager getObjWithKey:sceneId];
    if (scene) {
        Workspace* workspace = scene.workspace;
        NSInteger nsWorkspace = (NSInteger)workspace;
        [JSObjManager addObj:workspace];
        resolve(@{@"workspaceId":@(nsWorkspace).stringValue});
    }else
        reject(@"scene",@"scene getWorkSpace failed",nil);
}

static BOOL bMapOPen = false;
RCT_REMAP_METHOD(open, openBySceneId:(NSString*)sceneId sceneName:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Scene* scene = [JSObjManager getObjWithKey:sceneId];
    if(bMapOPen){
        resolve(@{@"opened":@(1)});
    }
    if (scene) {
        BOOL isOpen = [scene open:name];
        if(isOpen){
            JSSceneView* view = [SceneViewManager getSceneControl];
            view.sceneCtrl.isRender = true;
        }
        bMapOPen = isOpen;
        NSNumber* nsBool = [NSNumber numberWithBool:isOpen];
        resolve(@{@"opened":nsBool});
    }else{
        reject(@"scene",@"scene open failed",nil);
    }
}

RCT_REMAP_METHOD(open2, openBySceneId:(NSString*)sceneId url:(NSString*)url name:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    if(bMapOPen){
        resolve(@{@"opened":@(1)});
    }
    Scene* scene = [JSObjManager getObjWithKey:sceneId];
    if (scene) {
        BOOL isOpen = [scene openSceneWithUrl:url Name:name Password:nil];
        bMapOPen = isOpen;
        if(isOpen){
            JSSceneView* view = [SceneViewManager getSceneControl];
            view.sceneCtrl.isRender = true;
        }
        NSNumber* nsBool = [NSNumber numberWithBool:isOpen];
        resolve(@{@"opened":nsBool});
    }else{
        reject(@"scene",@"open2 failed",nil);
    }
}

RCT_REMAP_METHOD(open3, openBySceneId:(NSString*)sceneId url:(NSString*)url name:(NSString*)name passWord:(NSString*)passWord resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    if(bMapOPen){
        resolve(@{@"opened":@(1)});
    }
    Scene* scene = [JSObjManager getObjWithKey:sceneId];
    if (scene) {
        BOOL isOpen = [scene openSceneWithUrl:url Name:name Password:passWord];
        NSNumber* nsBool = [NSNumber numberWithBool:isOpen];
        bMapOPen = isOpen;
        if(isOpen){
            JSSceneView* view = [SceneViewManager getSceneControl];
            view.sceneCtrl.isRender = true;
        }
        resolve(@{@"opened":nsBool});
    }else{
        reject(@"scene",@"open2 failed",nil);
    }
}

//RCT_REMAP_METHOD(ensureVisible, ensureVisible){
//}

RCT_REMAP_METHOD(refresh, refreshBySceneId:(NSString*)sceneId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Scene* scene = [JSObjManager getObjWithKey:sceneId];
    if (scene) {
        [scene refresh];
        resolve(@"refreshed");
    }else{
        reject(@"scene",@"refresh failed",nil);
    }
}

RCT_REMAP_METHOD(pan, panBySceneId:(NSString*)sceneId longitude:(double)lon latitude:(double)lat resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Scene* scene = [JSObjManager getObjWithKey:sceneId];
    if (scene) {
        [scene panWithOffsetLongitude:lon offsetLatitude:lat];
        resolve(@"panned");
    }else{
        reject(@"scene",@"pan failed",nil);
    }
}

RCT_REMAP_METHOD(viewEntire, viewEntireBySceneId:(NSString*)sceneId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Scene* scene = [JSObjManager getObjWithKey:sceneId];
    if (scene) {
        [scene viewEntire];
        resolve(@"done");
    }else{
        reject(@"scene",@"set viewEntire failed",nil);
    }
}

RCT_REMAP_METHOD(zoom, zoomBySceneId:(NSString*)sceneId ratio:(double)ratio resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Scene* scene = [JSObjManager getObjWithKey:sceneId];
    if (scene) {
        [scene zoom:ratio];
        resolve(@"done");
    }else{
        reject(@"scene",@"set zoom failed",nil);
    }
}

RCT_REMAP_METHOD(close, closeBySceneId:(NSString*)sceneId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){

    @try {
        Scene* scene = [JSObjManager getObjWithKey:sceneId];
        JSSceneView* view = [SceneViewManager getSceneControl];
        view.sceneCtrl.isRender = false;
        [scene close];
        bMapOPen = false;
        resolve(@"done");
    } @catch (NSException *exception) {
        reject(@"scene", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(dispose, disposeBySceneId:(NSString*)sceneId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Scene* scene = [JSObjManager getObjWithKey:sceneId];
    if (scene) {
        [JSObjManager removeObj:sceneId];
        [scene dispose];
        resolve(@"done");
    }else{
        reject(@"scene",@"dispose failed",nil);
    }
}
@end

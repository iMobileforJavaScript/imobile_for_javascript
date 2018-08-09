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

@implementation JSScene

RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(setWorkspace,setWorkspaceBySceneId:(NSString*)sceneId workSpaceId:(NSString*)workSpaceId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Scene* scene = [JSObjManager getObjWithKey:sceneId];
    Workspace* workspace = [JSObjManager getObjWithKey:workSpaceId];
    if (scene&&workspace) {
        [scene setWorkspace:workspace];
        resolve(@"setted");
    }else
        reject(@"scene",@"setWorkSpace failed",nil);
}

RCT_REMAP_METHOD(getWorkspace,getWorkspaceBySceneId:(NSString*)sceneId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Scene* scene = [JSObjManager getObjWithKey:sceneId];
    if (scene) {
        Workspace* workspace = scene.workspace;
        NSInteger nsWorkspace = (NSInteger)workspace;
        [JSObjManager addObj:workspace];
        resolve(@{@"workspaceId":@(nsWorkspace).stringValue});
    }else
        reject(@"scene",@"getWorkSpace failed",nil);
}

RCT_REMAP_METHOD(open, openBySceneId:(NSString*)sceneId sceneName:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Scene* scene = [JSObjManager getObjWithKey:sceneId];
    if (scene) {
        BOOL isOpen = [scene open:name];
        NSNumber* nsBool = [NSNumber numberWithBool:isOpen];
        resolve(@{@"opened":nsBool});
    }else{
        reject(@"scene",@"open failed",nil);
    }
}

RCT_REMAP_METHOD(open2, openBySceneId:(NSString*)sceneId url:(NSString*)url name:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Scene* scene = [JSObjManager getObjWithKey:sceneId];
    if (scene) {
        BOOL isOpen = [scene openSceneWithUrl:url Name:name Password:nil];
        NSNumber* nsBool = [NSNumber numberWithBool:isOpen];
        resolve(@{@"opened":nsBool});
    }else{
        reject(@"scene",@"open2 failed",nil);
    }
}

RCT_REMAP_METHOD(open3, openBySceneId:(NSString*)sceneId url:(NSString*)url name:(NSString*)name passWord:(NSString*)passWord resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Scene* scene = [JSObjManager getObjWithKey:sceneId];
    if (scene) {
        BOOL isOpen = [scene openSceneWithUrl:url Name:name Password:passWord];
        NSNumber* nsBool = [NSNumber numberWithBool:isOpen];
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
    Scene* scene = [JSObjManager getObjWithKey:sceneId];
    if (scene) {
        [scene close];
        resolve(@"done");
    }else{
        reject(@"scene",@"scene close failed",nil);
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

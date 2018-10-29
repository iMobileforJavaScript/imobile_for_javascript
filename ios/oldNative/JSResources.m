//
//  JSResources.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/16.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSResources.h"
#import "SuperMap/Resources.h"
//#import "SuperMap/SymbolFillLibrary.h"
//#import "SuperMap/SymbolLineLibrary.h"
//#import "SuperMap/SymbolMarkerLibrary.h"
#import "JSObjManager.h"

@implementation JSResources
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(createObj,createObjWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Resources* res = [[Resources alloc]init];
        NSString* key = [JSObjManager addObj:res];
        resolve(key);
    } @catch (NSException *exception) {
        reject(@"Resources", exception.reason, nil);
    }
}

#pragma mark dispose() 释放该对象所占用的资源
RCT_REMAP_METHOD(dispose, disposeById:(NSString *)resId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Resources* res = [JSObjManager getObjWithKey:resId];
        [res dispose];
        [JSObjManager removeObj:resId];
        
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"Resources", exception.reason, nil);
    }
}

#pragma mark getFillLibrary() 返回资源库中的填充库对象
RCT_REMAP_METHOD(getFillLibrary, getFillLibraryById:(NSString *)resId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Resources* res = [JSObjManager getObjWithKey:resId];
        SymbolFillLibrary* lib = res.fillLibrary;
        NSString* libId = [JSObjManager addObj:lib];
        
        resolve(libId);
    } @catch (NSException *exception) {
        reject(@"Resources", exception.reason, nil);
    }
}

#pragma mark getLineLibrary() 返回资源库中的线型库对象
RCT_REMAP_METHOD(getLineLibrary, getLineLibraryById:(NSString *)resId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Resources* res = [JSObjManager getObjWithKey:resId];
        SymbolLineLibrary* lib = res.lineLibrary;
        NSString* libId = [JSObjManager addObj:lib];
        
        resolve(libId);
    } @catch (NSException *exception) {
        reject(@"Resources", exception.reason, nil);
    }
}

#pragma mark getMarkerLibrary() 返回资源库中的点状符号库对象
RCT_REMAP_METHOD(getMarkerLibrary, getMarkerLibraryById:(NSString *)resId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Resources* res = [JSObjManager getObjWithKey:resId];
        SymbolMarkerLibrary* lib = res.markerLibrary;
        NSString* libId = [JSObjManager addObj:lib];
        
        resolve(libId);
    } @catch (NSException *exception) {
        reject(@"Resources", exception.reason, nil);
    }
}

#pragma mark getWorkspace() 返回该资源库所关联的工作空间对象
RCT_REMAP_METHOD(getWorkspace, getWorkspaceById:(NSString *)resId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Resources* res = [JSObjManager getObjWithKey:resId];
        Workspace* ws = res.workspace;
        NSString* wsId = [JSObjManager addObj:ws];
        
        resolve(wsId);
    } @catch (NSException *exception) {
        reject(@"Resources", exception.reason, nil);
    }
}
@end

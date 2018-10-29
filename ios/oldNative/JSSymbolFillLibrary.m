//
//  JSSymbolFillLibrary.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/16.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSSymbolFillLibrary.h"
#import "SuperMap/SymbolFillLibrary.h"
#import "JSObjManager.h"

@implementation JSSymbolFillLibrary
RCT_EXPORT_MODULE();

#pragma mark dispose() 释放该对象所占用的资源
RCT_REMAP_METHOD(dispose, disposeById:(NSString *)libId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolFillLibrary* lib = [JSObjManager getObjWithKey:libId];
        [lib dispose];
        [JSObjManager removeObj:libId];
        
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"SymbolMarker", exception.reason, nil);
    }
}

@end

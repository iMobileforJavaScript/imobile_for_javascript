//
//  JSSymbolLineLibrary.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/16.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSSymbolLineLibrary.h"
#import "SuperMap/SymbolLineLibrary.h"
#import "JSObjManager.h"

@implementation JSSymbolLineLibrary
RCT_EXPORT_MODULE();

#pragma mark dispose() 释放该对象所占用的资源
RCT_REMAP_METHOD(dispose, disposeById:(NSString *)libId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolLineLibrary* lib = [JSObjManager getObjWithKey:libId];
        [lib dispose];
        [JSObjManager removeObj:libId];
        
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"SymbolMarker", exception.reason, nil);
    }
}
@end

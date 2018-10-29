//
//  JSSymbolLine.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/16.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSSymbolLine.h"
#import "SuperMap/SymbolLine.h"
#import "JSObjManager.h"

@implementation JSSymbolLine
RCT_EXPORT_MODULE();

#pragma mark dispose() 释放该对象所占用的资源
RCT_REMAP_METHOD(dispose, disposeById:(NSString *)symbolId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolLine* symbol = [JSObjManager getObjWithKey:symbolId];
        [symbol dispose];
        [JSObjManager removeObj:symbolId];
        
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"SymbolLine", exception.reason, nil);
    }
}
@end

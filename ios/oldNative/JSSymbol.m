//
//  JSSymbol.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/15.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSSymbol.h"
#import "SuperMap/Symbol.h"
#import "SuperMap/GeoStyle.h"
#import "JSObjManager.h"

@implementation JSSymbol
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(dispose, disposeById:(NSString *)symbolId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
//        Symbol* symbol = [JSObjManager getObjWithKey:symbolId];
//       [symbol dispose];
        [JSObjManager removeObj:symbolId];
        
        NSNumber* number =[NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSSymbol", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(draw, drawById:(NSString *)symbolId width:(int)width height:(int)height resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Symbol* symbol = [JSObjManager getObjWithKey:symbolId];
//        CGImageRef imgRef = [symbol drawBmpWidth:width height:height];
//
//        NSNumber* number;
//        if (imgRef) {
//            number = [NSNumber numberWithBool:YES];
//        } else {
//            number = [NSNumber numberWithBool:NO];
//        }
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSLayerGroup", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(getID, getIDById:(NSString *)symbolId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Symbol* symbol = [JSObjManager getObjWithKey:symbolId];
        int sID = [symbol getID];
        
        resolve([NSNumber numberWithInt:sID]);
    } @catch (NSException *exception) {
        reject(@"JSLayerGroup", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(getName, getNameById:(NSString *)symbolId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Symbol* symbol = [JSObjManager getObjWithKey:symbolId];
        NSString* name = [symbol getName];
        
        resolve(name);
    } @catch (NSException *exception) {
        reject(@"JSLayerGroup", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(setSymbolStyle, setSymbolStyleById:(NSString *)symbolId styleId:(NSString *)styleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Symbol* symbol = [JSObjManager getObjWithKey:symbolId];
        GeoStyle* style = [JSObjManager getObjWithKey:styleId];
        
        [symbol setSymbolStyle:style];
        
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSLayerGroup", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(toString, toStringById:(NSString *)symbolId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Symbol* symbol = [JSObjManager getObjWithKey:symbolId];
        
        NSString* str = [symbol toString];
        
        resolve(str);
    } @catch (NSException *exception) {
        reject(@"JSLayerGroup", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(getType, getTypeById:(NSString *)symbolId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Symbol* symbol = [JSObjManager getObjWithKey:symbolId];
        SymbolType type = [symbol getType];
        NSNumber * sType = [NSNumber numberWithInt:(int)type];
        resolve(sType);
    } @catch (NSException *exception) {
        reject(@"JSLayerGroup", exception.reason, nil);
    }
}
@end

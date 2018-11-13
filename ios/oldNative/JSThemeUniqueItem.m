//
//  JSThemeUniqueItem.m
//  Supermap
//
//  Created by supermap on 2018/8/9.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSThemeUniqueItem.h"
#import "JSObjManager.h"
#import "SuperMap/ThemeUniqueItem.h"
@implementation JSThemeUniqueItem
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj, createObjResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeUniqueItem* item = [[ThemeUniqueItem alloc]init];
        NSInteger itemId = (NSInteger)item;
        [JSObjManager addObj:item];
        resolve(@(itemId).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSThemeUniqueItem",@"createObj expection",nil);
    }
}
/**
 * 返回单值专题图子项的名称
 * @param themeUniqueItemId
 */
RCT_REMAP_METHOD(getCaption,getCaptionById:(NSString*)themeUniqueItemId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeUniqueItem* themeUniqueItem = [JSObjManager getObjWithKey:themeUniqueItemId];
        NSString* caption = themeUniqueItem.mCaption;
        resolve(caption);
    } @catch (NSException *exception) {
        reject(@"JSThemeUniqueItem",@"getCaption expection",nil);
    }
}

/**
 * 返回单值专题图子项所对应的显示风格
 * @param themeUniqueItemId
 */
RCT_REMAP_METHOD(getStyle,getStyleById:(NSString*)themeUniqueItemId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeUniqueItem* themeUniqueItem = [JSObjManager getObjWithKey:themeUniqueItemId];
        GeoStyle* style = themeUniqueItem.mStyle;
        NSInteger styleId = (NSInteger)style;
        [JSObjManager addObj:style];
        resolve(@(styleId).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSThemeUniqueItem",@"getStyle expection",nil);
    }
}
/**
 * 返回单值专题图子项的单值
 * @param themeUniqueItemId
 */
RCT_REMAP_METHOD(getUnique,getUniqueById:(NSString*)themeUniqueItemId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeUniqueItem* themeUniqueItem = [JSObjManager getObjWithKey:themeUniqueItemId];
        NSString* value = themeUniqueItem.mUnique;
        resolve(value);
    } @catch (NSException *exception) {
        reject(@"JSThemeUniqueItem",@"getUnique expection",nil);
    }
}

/**
 * 返回单值专题图子项是否可见
 * @param themeUniqueItemId
 */

RCT_REMAP_METHOD(isVisible,isVisibleById:(NSString*)themeUniqueItemId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeUniqueItem* themeUniqueItem = [JSObjManager getObjWithKey:themeUniqueItemId];
        BOOL visible = themeUniqueItem.mIsVisible;
        NSNumber* number = [NSNumber numberWithBool:visible];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeUniqueItem",@"isVisible expection",nil);
    }
}
/**
 * 设置单值专题图子项的名称
 * @param themeUniqueItemId
 * @param value
 */
RCT_REMAP_METHOD(setCaption,setCaptionById:(NSString*)themeUniqueItemId value:(NSString*)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeUniqueItem* themeUniqueItem = [JSObjManager getObjWithKey:themeUniqueItemId];
        themeUniqueItem.mCaption = value;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeUniqueItem",@"setCaption expection",nil);
    }
}

/**
 * 设置单值专题图子项所对应的显示风格
 * @param themeUniqueItemId
 * @param styleId
 */
RCT_REMAP_METHOD(setStyle,setStyleById:(NSString*)themeUniqueItemId styleId:(NSString*)styleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeUniqueItem* themeUniqueItem = [JSObjManager getObjWithKey:themeUniqueItemId];
        GeoStyle *style = [JSObjManager getObjWithKey:styleId];
        themeUniqueItem.mStyle = style;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeUniqueItem",@"setStyle expection",nil);
    }
}
/**
 * 设置单值专题图子项的单值
 * @param themeUniqueItemId
 * @param value
 */
RCT_REMAP_METHOD(setUnique,setUniqueById:(NSString*)themeUniqueItemId value:(NSString*)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeUniqueItem* themeUniqueItem = [JSObjManager getObjWithKey:themeUniqueItemId];
        themeUniqueItem.mUnique = value;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeUniqueItem",@"setUnique expection",nil);
    }
}

/**
 * 设置单值专题图子项是否可见
 * @param themeUniqueItemId
 * @param value
 */
RCT_REMAP_METHOD(setVisible,setVisibleById:(NSString*)themeUniqueItemId value:(BOOL)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeUniqueItem* themeUniqueItem = [JSObjManager getObjWithKey:themeUniqueItemId];
        themeUniqueItem.mIsVisible = value;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeUniqueItem",@"setVisible expection",nil);
    }
}
/**
 * 返回单值专题图子项格式化字符串
 * @param themeUniqueItemId
 */
RCT_REMAP_METHOD(toString,toStringById:(NSString*)themeUniqueItemId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeUniqueItem* themeUniqueItem = [JSObjManager getObjWithKey:themeUniqueItemId];
        NSString* string = themeUniqueItem.toString;
        resolve(string);
    } @catch (NSException *exception) {
        reject(@"JSThemeUniqueItem",@"toString expection",nil);
    }
}
@end

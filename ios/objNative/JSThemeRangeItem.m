//
//  JSThemeRangeItem.m
//  Supermap
//
//  Created by supermap on 2018/8/9.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSThemeRangeItem.h"
#import "JSObjManager.h"
#import "SuperMap/ThemeRangeItem.h"
@implementation JSThemeRangeItem
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj, createObjResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRangeItem* item = [[ThemeRangeItem alloc]init];
        NSInteger itemId = (NSInteger)item;
        [JSObjManager addObj:item];
        resolve(@(itemId).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSThemeRangeItem",@"createObj expection",nil);
    }
}
/**
 * 返回分段专题图子项的名称
 * @param themeRangeItemId
 */
RCT_REMAP_METHOD(getCaption,getCaptionById:(NSString*)themeRangeItemId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRangeItem* themeRangeItem = [JSObjManager getObjWithKey:themeRangeItemId];
        NSString* caption = themeRangeItem.mCaption;
        resolve(caption);
    } @catch (NSException *exception) {
        reject(@"JSThemeRangeItem",@"getCaption expection",nil);
    }
}

/**
 * 返回分段专题图子项的分段终止值
 * @param themeRangeItemId
 */
RCT_REMAP_METHOD(getEnd,getEndById:(NSString*)themeRangeItemId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRangeItem* themeRangeItem = [JSObjManager getObjWithKey:themeRangeItemId];
        double end = themeRangeItem.mEnd;
        resolve(@(end));
    } @catch (NSException *exception) {
        reject(@"JSThemeRangeItem",@"getEnd expection",nil);
    }
}
/**
 * 返回分段专题图子项的分段起始值
 * @param themeRangeItemId
 */
RCT_REMAP_METHOD(getStart,getStartById:(NSString*)themeRangeItemId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRangeItem* themeRangeItem = [JSObjManager getObjWithKey:themeRangeItemId];
        double start = themeRangeItem.mStart;
        resolve(@(start));
    } @catch (NSException *exception) {
        reject(@"JSThemeRangeItem",@"getStart expection",nil);
    }
}
/**
 * 返回分段专题图子项所对应的显示风格
 * @param themeRangeItemId
 */
RCT_REMAP_METHOD(getStyle,getStyleById:(NSString*)themeRangeItemId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRangeItem* themeRangeItem = [JSObjManager getObjWithKey:themeRangeItemId];
        GeoStyle* style = themeRangeItem.mStyle;
        NSInteger styleId = (NSInteger)style;
        [JSObjManager addObj:style];
        resolve(@(styleId).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSThemeRangeItem",@"getStyle expection",nil);
    }
}
/**
 * 返回分段专题图子项是否可见
 * @param themeRangeItemId
 */
RCT_REMAP_METHOD(isVisible,isVisibleById:(NSString*)themeRangeItemId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRangeItem* themeRangeItem = [JSObjManager getObjWithKey:themeRangeItemId];
        BOOL visible = themeRangeItem.mIsVisible;
        NSNumber* number = [NSNumber numberWithBool:visible];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeRangeItem",@"isVisible expection",nil);
    }
}
/**
 * 设置分段专题图子项的名称
 * @param themeRangeItemId
 * @param value
 */
RCT_REMAP_METHOD(setCaption,setCaptionById:(NSString*)themeRangeItemId value:(NSString*)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRangeItem* themeRangeItem = [JSObjManager getObjWithKey:themeRangeItemId];
        themeRangeItem.mCaption = value;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeRangeItem",@"setCaption expection",nil);
    }
}
/**
 * 设置分段专题图子项的分段终止值
 * @param themeRangeItemId
 * @param value
 */
RCT_REMAP_METHOD(setEnd,setEndById:(NSString*)themeRangeItemId value:(double)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRangeItem* themeRangeItem = [JSObjManager getObjWithKey:themeRangeItemId];
        themeRangeItem.mEnd = value;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeRangeItem",@"setEnd expection",nil);
    }
}
/**
 * 设置分段专题图子项的分段起始值
 * @param themeRangeItemId
 * @param value
 */
RCT_REMAP_METHOD(setStart,setStartById:(NSString*)themeRangeItemId value:(double)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRangeItem* themeRangeItem = [JSObjManager getObjWithKey:themeRangeItemId];
        themeRangeItem.mStart = value;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeRangeItem",@"setStart expection",nil);
    }
}
/**
 * 设置分段专题图子项所对应的显示风格
 * @param themeRangeItemId
 * @param styleId
 */
RCT_REMAP_METHOD(setStyle,setStyleById:(NSString*)themeRangeItemId styleId:(NSString*)styleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRangeItem* themeRangeItem = [JSObjManager getObjWithKey:themeRangeItemId];
        GeoStyle *style = [JSObjManager getObjWithKey:styleId];
        themeRangeItem.mStyle = style;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeRangeItem",@"setStyle expection",nil);
    }
}
/**
 * 设置分段专题图子项是否可见
 * @param themeRangeItemId
 * @param value
 */
RCT_REMAP_METHOD(setVisible,setVisibleById:(NSString*)themeRangeItemId value:(BOOL)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRangeItem* themeRangeItem = [JSObjManager getObjWithKey:themeRangeItemId];
        themeRangeItem.mIsVisible = value;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeRangeItem",@"setVisible expection",nil);
    }
}
/**
 * 返回分段专题图子项格式化字符串
 * @param themeRangeItemId
 */
RCT_REMAP_METHOD(toString,toStringById:(NSString*)themeRangeItemId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRangeItem* themeRangeItem = [JSObjManager getObjWithKey:themeRangeItemId];
        NSString* string = themeRangeItem.toString;
        resolve(string);
    } @catch (NSException *exception) {
        reject(@"JSThemeRangeItem",@"toString expection",nil);
    }
}
@end

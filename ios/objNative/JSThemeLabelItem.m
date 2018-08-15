//
//  JSThemeLabelItem.m
//  Supermap
//
//  Created by supermap on 2018/8/9.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSThemeLabelItem.h"
#import "JSObjManager.h"
#import "SuperMap/ThemeLabelItem.h"

@implementation JSThemeLabelItem
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj, createObjResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabelItem* item = [[ThemeLabelItem alloc]init];
        NSInteger itemId = (NSInteger)item;
        [JSObjManager addObj:item];
        resolve(@(itemId).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSThemeLabelItem",@"createObj expection",nil);
    }
}
/**
 * 返回标签专题图子项的名称
 * @param themeLabelItemId
 */
RCT_REMAP_METHOD(getCaption,getCaptionById:(NSString*)themeLabelItemId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabelItem* themeLabelItem = [JSObjManager getObjWithKey:themeLabelItemId];
        NSString* caption = themeLabelItem.mCaption;
        resolve(caption);
    } @catch (NSException *exception) {
        reject(@"JSThemeLabelItem",@"getCaption expection",nil);
    }
}

/**
 * 返回标签专题图子项的分段终止值
 * @param themeLabelItemId
 * @param promise
 */
RCT_REMAP_METHOD(getEnd,getEndById:(NSString*)themeLabelItemId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabelItem* themeLabelItem = [JSObjManager getObjWithKey:themeLabelItemId];
        double end = themeLabelItem.mEnd;
        resolve(@(end));
    } @catch (NSException *exception) {
        reject(@"JSThemeLabelItem",@"getEnd expection",nil);
    }
}
/**
 * 返回标签专题图子项的分段起始值
 * @param themeLabelItemId
 */
RCT_REMAP_METHOD(getStart,getStartById:(NSString*)themeLabelItemId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabelItem* themeLabelItem = [JSObjManager getObjWithKey:themeLabelItemId];
        double start = themeLabelItem.mStart;
        resolve(@(start));
    } @catch (NSException *exception) {
        reject(@"JSThemeLabelItem",@"getStart expection",nil);
    }
}
/**
 * 返回标签专题图子项所对应的显示风格
 * @param themeLabelItemId
 * @param promise
 */
RCT_REMAP_METHOD(getStyle,getStyleById:(NSString*)themeLabelItemId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabelItem* themeLabelItem = [JSObjManager getObjWithKey:themeLabelItemId];
        TextStyle* style = themeLabelItem.mTextStyle;
        NSInteger styleId = (NSInteger)style;
        [JSObjManager addObj:style];     
        resolve(@(styleId).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSThemeLabelItem",@"getStyle expection",nil);
    }
}
/**
 * 返回标签专题图子项是否可见
 * @param themeLabelItemId
 */
RCT_REMAP_METHOD(isVisible,isVisibleById:(NSString*)themeLabelItemId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabelItem* themeLabelItem = [JSObjManager getObjWithKey:themeLabelItemId];
        BOOL visible = themeLabelItem.mVisible;
        NSNumber* number = [NSNumber numberWithBool:visible];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeLabelItem",@"isVisible expection",nil);
    }
}
/**
 * 设置标签专题图子项的名称
 * @param themeLabelItemId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setCaption,setCaptionById:(NSString*)themeLabelItemId value:(NSString*)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabelItem* themeLabelItem = [JSObjManager getObjWithKey:themeLabelItemId];
        themeLabelItem.mCaption = value;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeLabelItem",@"setCaption expection",nil);
    }
}
/**
 * 设置标签专题图子项的分段终止值
 * @param themeLabelItemId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setEnd,setEndById:(NSString*)themeLabelItemId value:(double)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabelItem* themeLabelItem = [JSObjManager getObjWithKey:themeLabelItemId];
        themeLabelItem.mEnd = value;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeLabelItem",@"setEnd expection",nil);
    }
}
/**
 * 设置标签专题图子项的分段起始值
 * @param themeLabelItemId
 * @param value
 */
RCT_REMAP_METHOD(setStart,setStartById:(NSString*)themeLabelItemId value:(double)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabelItem* themeLabelItem = [JSObjManager getObjWithKey:themeLabelItemId];
        themeLabelItem.mStart = value;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeLabelItem",@"setStart expection",nil);
    }
}
/**
 * 设置标签专题图子项所对应的显示风格
 * @param themeLabelItemId
 * @param styleId
 */
RCT_REMAP_METHOD(setStyle,setStyleById:(NSString*)themeLabelItemId styleId:(NSString*)styleId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabelItem* themeLabelItem = [JSObjManager getObjWithKey:themeLabelItemId];
        TextStyle *style = [JSObjManager getObjWithKey:styleId];
        themeLabelItem.mTextStyle = style;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeLabelItem",@"setStyle expection",nil);
    }
}
/**
 * 设置标签专题图子项是否可见
 * @param themeLabelItemId
 * @param value
 */
RCT_REMAP_METHOD(setVisible,setVisibleById:(NSString*)themeLabelItemId value:(BOOL)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabelItem* themeLabelItem = [JSObjManager getObjWithKey:themeLabelItemId];
        themeLabelItem.mVisible = value;
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeLabelItem",@"setVisible expection",nil);
    }
}
/**
 * 返回标签专题图子项格式化字符串
 * @param themeLabelItemId
 */
RCT_REMAP_METHOD(toString,toStringById:(NSString*)themeLabelItemId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabelItem* themeLabelItem = [JSObjManager getObjWithKey:themeLabelItemId];
        NSString* string = themeLabelItem.toString;
        resolve(string);
    } @catch (NSException *exception) {
        reject(@"JSThemeLabelItem",@"toString expection",nil);
    }
}
@end

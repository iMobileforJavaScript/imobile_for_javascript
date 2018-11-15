//
//  JSThemeUnique.m
//  Supermap
//
//  Created by supermap on 2018/8/9.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSThemeUnique.h"
#import "JSObjManager.h"
#import "SuperMap/ThemeUnique.h"
#import "SuperMap/Color.h"
@implementation JSThemeUnique
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj, createObjResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeUnique* item = [[ThemeUnique alloc]init];
        NSInteger itemId = (NSInteger)item;
        [JSObjManager addObj:item];
        resolve(@(itemId).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSThemeUnique",@"createObj expection",nil);
    }
}

RCT_REMAP_METHOD(createObjClone,createObjCloneById:(NSString*)themeUniqueId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeUnique* old = [JSObjManager getObjWithKey:themeUniqueId];
        ThemeUnique* theme = (ThemeUnique *)[Theme clone:old];
        NSInteger themeId = (NSInteger)theme;
        [JSObjManager addObj:theme];
        resolve(@(themeId).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSThemeUnique",@"createObjClone expection",nil);
    }
}

RCT_REMAP_METHOD(dispose,disposeById:(NSString*)themeUniqueId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeUnique* theme = [JSObjManager getObjWithKey:themeUniqueId];
        [theme dispose];
        [JSObjManager removeObj:themeUniqueId];
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeUnique",@"dispose expection",nil);
    }
}
/**
 * 添加单值专题图子项
 * @param themeUniqueId
 * @param themeUniqueItemId
 */
RCT_REMAP_METHOD(add,addById:(NSString*)themeUniqueId themeUniqueItemId:(NSString*)themeUniqueItemId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeUnique* theme = [JSObjManager getObjWithKey:themeUniqueId];
        ThemeUniqueItem* themeItem = [JSObjManager getObjWithKey:themeUniqueItemId];
        int index = [theme addItem:themeItem];
        resolve(@(index));
    } @catch (NSException *exception) {
        reject(@"JSThemeUnique",@"add expection",nil);
    }
}
/**
 * 删除一个指定序号的单值专题图子项
 * @param themeUniqueId
 * @param index
 */
RCT_REMAP_METHOD(remove,removeById:(NSString*)themeUniqueId index:(int)index resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeUnique* theme = [JSObjManager getObjWithKey:themeUniqueId];
        BOOL result = [theme remove:index];
        NSNumber* number = [NSNumber numberWithBool:result];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeUnique",@"remove expection",nil);
    }
}
/**
 * 将给定的单值专题图子项插入到指定序号的位置
 * @param themeUniqueId
 * @param index
 * @param themeUniqueItemId
 */
RCT_REMAP_METHOD(insert,insertById:(NSString*)themeUniqueId index:(int)index themeUniqueItemId:(NSString*)themeUniqueItemId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeUnique* theme = [JSObjManager getObjWithKey:themeUniqueId];
        ThemeUniqueItem* themeItem = [JSObjManager getObjWithKey:themeUniqueItemId];
        BOOL result = [theme insert:index Item:themeItem];
        NSNumber* number = [NSNumber numberWithBool:result];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeUnique",@"insert expection",nil);
    }
}
/**
 * 根据给定的矢量数据集、单值专题图字段表达式和颜色渐变模式生成默认的单值专题图
 * @param datasetVectorId
 * @param expression
 * @param promise
 */
RCT_REMAP_METHOD(makeDefault,makeDefaultById:(NSString*)datasetVectorId expression:(NSString*)expression resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        DatasetVector* datasetVector = [JSObjManager getObjWithKey:datasetVectorId];
        ThemeUnique* theme = [ThemeUnique makeDefault:datasetVector uniqueExpression:expression];
        NSInteger themeId = (NSInteger)theme;
        [JSObjManager addObj:theme];
        resolve(@(themeId).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSThemeUnique",@"makeDefault expection",nil);
    }
}
/**
 * 根据给定的矢量数据集、单值专题图字段表达式和颜色渐变模式生成默认的单值专题图
 * @param datasetVectorId
 * @param expression
 * @param colorGradientType
 */
RCT_REMAP_METHOD(makeDefaultWithColorGradient,makeDefaultWithColorGradientById:(NSString*)datasetVectorId expression:(NSString*)expression colorGradientType:(int)colorGradientType resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        DatasetVector* datasetVector = [JSObjManager getObjWithKey:datasetVectorId];
        ColorGradientType colorGType =  (ColorGradientType)colorGradientType;
        ThemeUnique* theme = [ThemeUnique makeDefault:datasetVector uniqueExpression:expression colorType:colorGType];
        NSInteger themeId = (NSInteger)theme;
        [JSObjManager addObj:theme];
        resolve(@(themeId).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSThemeUnique",@"makeDefaultWithColorGradient expection",nil);
    }
}
/**
 * 根据指定的面数据集、颜色字段名称、颜色生成默认的四色单值专题图
 * @param datasetVectorId
 * @param expression
 * @param colors
 */
RCT_REMAP_METHOD(makeDefaultWithColors,makeDefaultWithColorsById:(NSString*)datasetVectorId expression:(NSString*)expression colors:(NSMutableArray*)colors resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        DatasetVector* datasetVector = [JSObjManager getObjWithKey:datasetVectorId];
        Colors *colors1 = [[Colors alloc]init];
//        for(int i = 0;i < [colors count];i++){
////            Color* color = [Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//
//        }
        [colors1 addRange:colors];
        ThemeUnique* theme = [ThemeUnique makeDefault:datasetVector colorField:expression colors:colors1 ];
        NSInteger themeId = (NSInteger)theme;
        [JSObjManager addObj:theme];
        resolve(@(themeId).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSThemeUnique",@"makeDefaultWithColors expection",nil);
    }
}
/**
 * 删除单值专题图的子项
 * @param themeUniqueId
 */
RCT_REMAP_METHOD(clear,clearById:(NSString*)themeUniqueId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeUnique* theme = [JSObjManager getObjWithKey: themeUniqueId];
        [theme clear];
        NSNumber* number =[NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeUnique",@"clear expection",nil);
    }
}
/**
 * 返回单值专题图中分段的个数
 * @param themeUniqueId
 */
RCT_REMAP_METHOD(getCount,getCountById:(NSString*)themeUniqueId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeUnique* theme = [JSObjManager getObjWithKey: themeUniqueId];
        int value = [theme getCount];
        resolve(@(value));
    } @catch (NSException *exception) {
        reject(@"JSThemeUnique",@"getCount expection",nil);
    }
}
/**
 * 返回指定序号的单值专题图中单值专题图子项
 * @param themeUniqueId
 * @param value
 */
RCT_REMAP_METHOD(getItem,getItemById:(NSString*)themeUniqueId value:(int)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeUnique* theme = [JSObjManager getObjWithKey: themeUniqueId];
        ThemeUniqueItem* themeItem = [theme getItem:value];
        NSInteger themeItemId = (NSInteger)themeItem;
        [JSObjManager addObj:themeItem];
        resolve(@(themeItemId).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSThemeUnique",@"getItem expection",nil);
    }
}
/**
 * 返回单值专题图中指定分段字段值在当前分段序列中的序号
 * @param themeUniqueId
 * @param value
 */
RCT_REMAP_METHOD(indexOf,indexOfById:(NSString*)themeUniqueId value:(NSString*)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeUnique* theme = [JSObjManager getObjWithKey: themeUniqueId];
        int index = [theme indexOf:value];
        resolve(@(index));
    } @catch (NSException *exception) {
        reject(@"JSThemeUnique",@"indexOf expection",nil);
    }
}
/**
 * 返回单值专题图的默认风格
 * @param themeUniqueId
 */
RCT_REMAP_METHOD(getDefaultStyle,getDefaultStyleById:(NSString*)themeUniqueId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeUnique* theme = [JSObjManager getObjWithKey: themeUniqueId];
        GeoStyle* style = theme.mDefaultStyle;
        NSInteger styleId = (NSInteger)style;
        [JSObjManager addObj:style];
        resolve(@(styleId).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSThemeUnique",@"getDefaultStyle expection",nil);
    }
}
/**
 * 设置单值专题图字段表达式
 * @param themeUniqueId
 * @param expression
 */
RCT_REMAP_METHOD(setUniqueExpression,setUniqueExpressionById:(NSString*)themeUniqueId expression:(NSString*)expression resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeUnique* theme = [JSObjManager getObjWithKey: themeUniqueId];
        [theme setUniqueExpression:expression];
        NSNumber* number =[NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeUnique",@"setUniqueExpression expection",nil);
    }
}
/**
 * 返回单值专题图字段表达式
 * @param themeUniqueId
 */
RCT_REMAP_METHOD(getUniqueExpression,getUniqueExpressionById:(NSString*)themeUniqueId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeUnique* theme = [JSObjManager getObjWithKey: themeUniqueId];
        NSString* value = [theme getUniqueExpression];
        resolve(value);
    } @catch (NSException *exception) {
        reject(@"JSThemeUnique",@"getUniqueExpression expection",nil);
    }
}
@end

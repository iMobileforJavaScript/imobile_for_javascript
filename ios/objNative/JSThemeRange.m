//
//  JSThemeRange.m
//  Supermap
//
//  Created by supermap on 2018/8/9.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSThemeRange.h"
#import "JSObjManager.h"
#import "SuperMap/ThemeRange.h"
@implementation JSThemeRange
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj, createObjResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRange* item = [[ThemeRange alloc]init];
        NSInteger itemId = (NSInteger)item;
        [JSObjManager addObj:item];
        resolve(@(itemId).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSThemeRange",@"createObj expection",nil);
    }
}

//RCT_REMAP_METHOD(createObjClone,createObjCloneById:(NSString*)themeRangeId withResolver(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        ThemeRange* oldTheme = [JSObjManager getObjWithKey:themeRangeId];
//        ThemeRange* theme = [[ThemeRange alloc] clone:oldTheme];
//        NSString* key = [JSObjManager addObj:theme];
//        resolve(key);
//    } @catch (NSException *exception) {
//        reject(@"colorScheme",@"ThemeLabel create Obj expection",nil);
//    }
//}

RCT_REMAP_METHOD(dispose,disposeById:(NSString*)themeRangeId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRange* theme = [JSObjManager getObjWithKey:themeRangeId];
        [theme dispose];
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeRange",@"dispose expection",nil);
    }
}
/**
 * 删除分段专题图的子项
 * @param themeRangeId
 * @param promise
 */
RCT_REMAP_METHOD(clear,clearById:(NSString*)themeRangeId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRange* theme = [JSObjManager getObjWithKey: themeRangeId];
        [theme clear];
        NSNumber* number =[NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeRange",@"clear expection",nil);
    }
}
/**
 * 设置分段字段表达式
 * @param themeLabelId
 * @param expression
 */
RCT_REMAP_METHOD(setRangeExpression,setRangeExpressionById:(NSString*)themeRangeId expression:(NSString*)expression resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRange* theme = [JSObjManager getObjWithKey: themeRangeId];
        [theme setRangeExpression:expression];
        NSNumber* number =[NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeRange",@"setRangeExpression expection",nil);
    }
}
/**
 * 设置范围分段专题图的舍入精度
 * @param themeLabelId
 * @param value
 */
RCT_REMAP_METHOD(setPrecision,setPrecisionById:(NSString*)themeRangeId value:(double)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRange* theme = [JSObjManager getObjWithKey: themeRangeId];
        [theme setPrecision:value];
        NSNumber* number =[NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeRange",@"setPrecision expection",nil);
    }
}
/**
 * 返回分段字段表达式
 * @param themeLabelId
 */
RCT_REMAP_METHOD(getRangeExpression,getRangeExpressionById:(NSString*)themeRangeId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRange* theme = [JSObjManager getObjWithKey: themeRangeId];
        NSString * value = [theme getRangeExpression];
        resolve(value);
    } @catch (NSException *exception) {
        reject(@"JSThemeRange",@"getRangeExpression expection",nil);
    }
}
/**
 * 把一个分段专题图子项添加到分段列表的开头
 * @param themeLabelId
 * @param themeLabelItemId
 */
RCT_REMAP_METHOD(addToHead,addToHeadById:(NSString*)themeRangeId themeLabelItemId:(NSString*)themeLabelItemId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRange* theme = [JSObjManager getObjWithKey: themeRangeId];
        ThemeRangeItem* themeItem = [JSObjManager getObjWithKey: themeLabelItemId];
        BOOL result = [theme addToHead:themeItem];
        NSNumber* number =[NSNumber numberWithBool:result];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeRange",@"addToHead expection",nil);
    }
}
/**
 * 把一个分段专题图子项添加到分段列表的尾部
 * @param themeLabelId
 * @param themeLabelItemId
 */
RCT_REMAP_METHOD(addToTail,addToTailById:(NSString*)themeRangeId themeLabelItemId:(NSString*)themeLabelItemId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRange* theme = [JSObjManager getObjWithKey: themeRangeId];
        ThemeRangeItem* themeItem = [JSObjManager getObjWithKey: themeLabelItemId];
        BOOL result = [theme addToTail:themeItem];
        NSNumber* number =[NSNumber numberWithBool:result];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeRange",@"addToTail expection",nil);
    }
}
/**
 * 返回分段专题图中分段的个数
 * @param themeRangeId
 */
RCT_REMAP_METHOD(getCount,getCountById:(NSString*)themeRangeId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRange* theme = [JSObjManager getObjWithKey: themeRangeId];
        int value = [theme getCount];
        resolve(@(value));
    } @catch (NSException *exception) {
        reject(@"JSThemeRange",@"getCount expection",nil);
    }
}
/**
 * 返回指定序号的分段专题图中分段专题图子项
 * @param themeRangeId
 * @param value
 */
RCT_REMAP_METHOD(getItem,getItemById:(NSString*)themeRangeId value:(int)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRange* theme = [JSObjManager getObjWithKey: themeRangeId];
        ThemeRangeItem* themeItem = [theme getItem:value];
        NSInteger themeItemId = (NSInteger)themeItem;
        [JSObjManager addObj:themeItem];
        resolve(@(themeItemId).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSThemeRange",@"getItem expection",nil);
    }
}
/**
 * 返回分段专题图中指定分段字段值在当前分段序列中的序号
 * @param themeRangeId
 * @param value
 */
RCT_REMAP_METHOD(indexOf,indexOfById:(NSString*)themeRangeId value:(int)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRange* theme = [JSObjManager getObjWithKey: themeRangeId];
        int index = [theme indexOf:value];
        resolve(@(index));
    } @catch (NSException *exception) {
        reject(@"JSThemeRange",@"indexOf expection",nil);
    }
}
/**
 * 根据给定的矢量数据集、分段字段表达式、分段模式和相应的分段参数生成默认的分段专题图
 * @param datasetVectorId
 * @param expression
 * @param rangeMode
 * @param rangeParameter
 */
RCT_REMAP_METHOD(makeDefault,makeDefaultById:(NSString*)datasetVectorId expression:(NSString*)expression rangeMode:(int)rangeMode rangeParameter:(double)rangeParameter resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        DatasetVector* datasetVector =[JSObjManager getObjWithKey: datasetVectorId];
        RangeMode rm =(RangeMode)rangeMode;
        
        ThemeRange* theme = [ThemeRange makeDefaultDataSet:datasetVector RangeExpression:expression RangeMode:rm RangeParameter:rangeParameter];
        NSInteger themeId = (NSInteger)theme;
        [JSObjManager addObj:theme];
        resolve(@(themeId).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSThemeRange",@"makeDefault expection",nil);
    }
}
/**
 * 根据给定的矢量数据集、分段字段表达式、分段模式、相应的分段参数和颜色渐变模式生成默认的分段专题图
 * @param datasetVectorId
 * @param expression
 * @param rangeMode
 * @param rangeParameter
 * @param colorGradientType
 */
RCT_REMAP_METHOD(makeDefaultWithColorGradient,makeDefaultWithColorGradientById:(NSString*)datasetVectorId expression:(NSString*)expression rangeMode:(int)rangeMode rangeParameter:(double)rangeParameter colorGradientType:(int)colorGradientType resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        DatasetVector* datasetVector =[JSObjManager getObjWithKey: datasetVectorId];
        ColorGradientType colorGType = (ColorGradientType)colorGradientType;
        RangeMode rm =(RangeMode)rangeMode;
        
        ThemeRange* theme = [ThemeRange makeDefaultDataSet:datasetVector RangeExpression:expression RangeMode:rm RangeParameter:rangeParameter ColorGradientType:colorGType];
        NSInteger themeId = (NSInteger)theme;
        [JSObjManager addObj:theme];
        resolve(@(themeId).stringValue);
    } @catch (NSException *exception) {
        reject(@"JSThemeRange",@"makeDefaultWithColorGradient expection",nil);
    }
}
/**
 * 对分段专题图中分段的风格进行反序显示
 * @param themeRangeId
 */
RCT_REMAP_METHOD(reverseStyle,reverseStyleById:(NSString*)themeRangeId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRange* theme = [JSObjManager getObjWithKey: themeRangeId];
        [theme reverseStyle];
        NSNumber* number =[NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeRange",@"reverseStyle expection",nil);
    }
}
/**
 * 设置是否固定偏移量
 * @param themeRangeId
 * @param value
 */
RCT_REMAP_METHOD(setOffsetFixed,setOffsetFixedById:(NSString*)themeRangeId value:(BOOL)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRange* theme = [JSObjManager getObjWithKey: themeRangeId];
        [theme setOffsetFixed:value];
        NSNumber* number =[NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeRange",@"setOffsetFixed expection",nil);
    }
}

/**
 * 设置X偏移量
 * @param themeRangeId
 * @param value
 */
RCT_REMAP_METHOD(setOffsetX,setOffsetXById:(NSString*)themeRangeId value:(NSString*)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRange* theme = [JSObjManager getObjWithKey: themeRangeId];
        [theme setOffsetX:value];
        NSNumber* number =[NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeRange",@"setOffsetX expection",nil);
    }
}
/**
 * 返回X偏移量
 * @param themeRangeId
 */
RCT_REMAP_METHOD(getOffsetX,getOffsetXById:(NSString*)themeRangeId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRange* theme = [JSObjManager getObjWithKey: themeRangeId];
        NSString* value = [theme getOffsetX];
        resolve(value);
    } @catch (NSException *exception) {
        reject(@"JSThemeRange",@"getOffsetX expection",nil);
    }
}
/**
 * 设置Y偏移量
 * @param themeRangeId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setOffsetY,setOffsetYById:(NSString*)themeRangeId value:(NSString*)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRange* theme = [JSObjManager getObjWithKey: themeRangeId];
        [theme setOffsetY:value];
        NSNumber* number =[NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeRange",@"setOffsetY expection",nil);
    }
}
/**
 * 返回Y偏移量
 * @param themeRangeId
 * @param promise
 */
RCT_REMAP_METHOD(getOffsetY,getOffsetYById:(NSString*)themeRangeId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRange* theme = [JSObjManager getObjWithKey: themeRangeId];
        NSString* value = [theme getOffsetY];
        resolve(value);
    } @catch (NSException *exception) {
        reject(@"JSThemeRange",@"getOffsetY expection",nil);
    }
}
/**
 * 根据给定的拆分分段值将一个指定序号的分段专题图子项拆分成两个具有各自风格和名称的分段专题图子项
 * @param themeRangeId
 * @param index
 * @param splitValue
 * @param style1Id
 * @param caption1
 * @param style2Id
 * @param caption2
 */
RCT_REMAP_METHOD(split,splitById:(NSString*)themeRangeId index:(int)index splitValue:(double)splitValue style1Id:(NSString*)style1Id caption1:(NSString*)caption1 style2Id:(NSString*)style2Id caption2:(NSString*)caption2 resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRange* theme = [JSObjManager getObjWithKey: themeRangeId];
        GeoStyle* style1 = [JSObjManager getObjWithKey: style1Id];
        GeoStyle* style2 = [JSObjManager getObjWithKey: style2Id];
        BOOL result = [theme splitIndex:index SplitValue:splitValue Style1:style1 Caption1:caption1 Style2:style2 Caption2:caption2];
        NSNumber* number =[NSNumber numberWithBool:result];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeRange",@"split expection",nil);
    }
}
/**
 * 合并一个从指定序号起始的给定个数的分段专题图子项，并赋给合并后分段专题图子项显示风格和名称
 * @param themeRangeId
 * @param index
 * @param count
 * @param styleId
 * @param caption
 */
RCT_REMAP_METHOD(merge,mergeById:(NSString*)themeRangeId index:(int)index count:(int)count styleId:(NSString*)styleId caption:(NSString*)caption resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRange* theme = [JSObjManager getObjWithKey: themeRangeId];
        GeoStyle* style = [JSObjManager getObjWithKey: styleId];
        BOOL result = [theme merge:index Count:count GeoStyle:style Caption:caption];
        NSNumber* number =[NSNumber numberWithBool:result];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeRange",@"merge expection",nil);
    }
}
/**
 * 返回是否固定偏移量
 * @param themeRangeId
 */
RCT_REMAP_METHOD(isOffsetFixed,isOffsetFixedById:(NSString*)themeRangeId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRange* theme = [JSObjManager getObjWithKey: themeRangeId];
       
        BOOL result = [theme isOffsetFixed];
        NSNumber* number =[NSNumber numberWithBool:result];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeRange",@"isOffsetFixed expection",nil);
    }
}
/**
 * 获取自定义段长
 * @param themeRangeId
 */
RCT_REMAP_METHOD(getCustomInterval,getCustomIntervalById:(NSString*)themeRangeId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRange* theme = [JSObjManager getObjWithKey: themeRangeId];
        double value = [theme getCustomInterVal];
        resolve(@(value));
    } @catch (NSException *exception) {
        reject(@"JSThemeRange",@"getCustomInterval expection",nil);
    }
}

RCT_REMAP_METHOD(getPrecision,getPrecisionId:(NSString*)themeRangeId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRange* theme = [JSObjManager getObjWithKey: themeRangeId];
        double value = [theme getPrecision];
        resolve(@(value));
    } @catch (NSException *exception) {
        reject(@"JSThemeRange",@"getCustomInterval expection",nil);
    }
}

RCT_REMAP_METHOD(getRangeMode,getRangeModeId:(NSString*)themeRangeId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeRange* theme = [JSObjManager getObjWithKey: themeRangeId];
        int value = theme.mRangeMode;
        resolve(@(value));
    } @catch (NSException *exception) {
        reject(@"JSThemeRange",@"getCustomInterval expection",nil);
    }
}
@end

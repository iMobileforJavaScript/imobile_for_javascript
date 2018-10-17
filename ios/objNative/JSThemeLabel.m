//
//  JSThemeLabel.m
//  Supermap
//
//  Created by imobile-xzy on 2018/8/14.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSThemeLabel.h"
#import "JSObjManager.h"
#import "SuperMap/ThemeLabel.h"

@interface JSThemeLabel()
{
    NSString* m_LabelExpression,* m_RangeExpression;
}
@end
@implementation JSThemeLabel
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(createObj,createObjWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabel* theme = [[ThemeLabel alloc]init];
        NSString* key = [JSObjManager addObj:theme];
        resolve(key);
    } @catch (NSException *exception) {
        reject(@"colorScheme",@"ThemeLabel create Obj expection",nil);
    }
}

RCT_REMAP_METHOD(createObjClone,createObjCloneById:(NSString*)themeId withResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabel* oldTheme = [JSObjManager getObjWithKey:themeId];
        ThemeLabel* theme = [[ThemeLabel alloc] initThemeLabel:oldTheme];
        NSString* key = [JSObjManager addObj:theme];
        resolve(key);
    } @catch (NSException *exception) {
        reject(@"colorScheme",@"ThemeLabel createObjClone expection",nil);
    }
}

RCT_REMAP_METHOD(dispose,disposeById:(NSString*)themeId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabel* theme = [JSObjManager getObjWithKey:themeId];
        [theme dispose];
        [JSObjManager removeObj:theme];
        NSNumber* number = [NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeUnique",@"JSThemeLabel dispose expection",nil);
    }
}

/**
 * 设置标注字段表达式
 * @param themeLabelId
 * @param expression
 * @param promise
 */
RCT_REMAP_METHOD(setLabelExpression,setLabelExpressionId:(NSString*)themeId expression:(NSString*)expression resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabel* theme = [JSObjManager getObjWithKey: themeId];
        [theme setLabelExpression:expression];
        m_LabelExpression = expression;
        NSNumber* number =[NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeLabel",@"JSThemeLabel setLabelExpression expection",nil);
    }
}

/**
 * 返回标注字段表达式
 * @param themeLabelId
 * @param promise
 */
RCT_REMAP_METHOD(getLabelExpression,getLabelExpressionId:(NSString*)themeId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        resolve(m_LabelExpression);
    } @catch (NSException *exception) {
        reject(@"JSThemeLabel",@"JSThemeLabel getLabelExpression expection",nil);
    }
}

/**
 * 返回分段字段表达式
 * @param themeLabelId
 * @param promise
 */

RCT_REMAP_METHOD(getRangeExpression,getRangeExpressionId:(NSString*)themeId expression:(NSString*)expression resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        resolve(m_RangeExpression);
    } @catch (NSException *exception) {
        reject(@"JSThemeLabel",@"JSThemeLabel getRangeExpression expection",nil);
    }
}



/**
 * 设置分段字段表达式
 * @param themeLabelId
 * @param expression
 * @param promise
 */

RCT_REMAP_METHOD(setRangeExpression,setRangeExpressionId:(NSString*)themeId expression:(NSString*)expression resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabel* theme = [JSObjManager getObjWithKey: themeId];
        [theme setRangeExpression:expression];
        m_RangeExpression = expression;
        NSNumber* number =[NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeLabel",@"JSThemeLabel setRangeExpression expection",nil);
    }
}



/**
 * 把一个标签专题图子项添加到分段列表的开头
 * @param themeLabelId
 * @param themeLabelItemId
 * @param promise
 */

RCT_REMAP_METHOD(addToHead,addToHeadId:(NSString*)themeId  LabelItemId:(NSString*) themeLabelItemId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabel* theme = [JSObjManager getObjWithKey: themeId];
        ThemeLabelItem* item = [JSObjManager getObjWithKey: themeLabelItemId];
        [theme addToHead:item];
        NSNumber* number =[NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeLabel",@"JSThemeLabel addToHead expection",nil);
    }
}



/**
 * 把一个标签专题图子项添加到分段列表的尾部
 * @param themeLabelId
 * @param themeLabelItemId
 * @param promise
 */
RCT_REMAP_METHOD(addToTail,addToTailId:(NSString*)themeId  LabelItemId:(NSString*) themeLabelItemId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabel* theme = [JSObjManager getObjWithKey: themeId];
        ThemeLabelItem* item = [JSObjManager getObjWithKey: themeLabelItemId];
        [theme addToTail:item];
        NSNumber* number =[NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeLabel",@"JSThemeLabel addToHead expection",nil);
    }
}


/**
 * 删除标签专题图的子项
 * @param themeLabelId
 * @param promise
 */

RCT_REMAP_METHOD(clear,clearId:(NSString*)themeId    resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabel* theme = [JSObjManager getObjWithKey: themeId];
       
        [theme clear];
        NSNumber* number =[NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSThemeLabel",@"JSThemeLabel clear expection",nil);
    }
}


/**
 * 返回标签专题图中分段的个数
 * @param themeLabelId
 * @param promise
 */

RCT_REMAP_METHOD(getCount,getCountId:(NSString*)themeId    resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabel* theme = [JSObjManager getObjWithKey: themeId];
        
        int n = [theme getCount];
       // NSNumber* number =[NSNumber numberWithBool:YES];
        resolve(@(n));
    } @catch (NSException *exception) {
        reject(@"JSThemeLabel",@"JSThemeLabel getCount expection",nil);
    }
}



/**
 * 返回指定序号的标签专题图中标签专题图子项
 * @param themeLabelId
 * @param value
 * @param promise
 */

RCT_REMAP_METHOD(getItem,getItemId:(NSString*)themeId  index:(int)idx  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabel* theme = [JSObjManager getObjWithKey: themeId];
        ThemeLabelItem* item = [theme getItem:idx];
        
        resolve([JSObjManager addObj:item]);
    } @catch (NSException *exception) {
        reject(@"JSThemeLabel",@"JSThemeLabel getItem expection",nil);
    }
}




/**
 * 返回标签专题图中指定分段字段值在当前分段序列中的序号
 * @param themeLabelId
 * @param value
 * @param promise
 */

RCT_REMAP_METHOD(indexOf,indexOfId:(NSString*)themeId  index:(double)value  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabel* theme = [JSObjManager getObjWithKey: themeId];
        int idx = [theme indexOf:value];
        
        resolve(@(idx));
    } @catch (NSException *exception) {
        reject(@"JSThemeLabel",@"JSThemeLabel indexOf expection",nil);
    }
}


/**
 * 设置统一文本风格
 * @param themeLabelId
 * @param styleId
 * @param promise
 */

RCT_REMAP_METHOD(setUniformStyle,setUniformStyleId:(NSString*)themeId  style:(NSString*)styleId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabel* theme = [JSObjManager getObjWithKey: themeId];
        GeoStyle* style = [JSObjManager getObjWithKey: styleId];
        [theme setMUniformStyle:style];
        
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"JSThemeLabel",@"JSThemeLabel setUniformStyle expection",nil);
    }
}



/**
 * 返回统一文本风格
 * @param themeLabelId
 * @param promise
 */
RCT_REMAP_METHOD(getUniformStyle,getUniformStyleId:(NSString*)themeId    resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabel* theme = [JSObjManager getObjWithKey: themeId];
        resolve([JSObjManager addObj: theme.mUniformStyle]);
    } @catch (NSException *exception) {
        reject(@"JSThemeLabel",@"JSThemeLabel getUniformStyle expection",nil);
    }
}


/**
 * 合并一个从指定序号起始的给定个数的标签专题图子项，并赋给合并后标签专题图子项显示风格和名称
 * @param themeLabelId
 * @param index
 * @param count
 * @param styleId
 * @param caption
 * @param promise
 */
RCT_REMAP_METHOD(merge,mergeId:(NSString*)themeId   index:(int)index size:(int)count styleId:(NSString*)styleId caption:(NSString*)caption  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabel* theme = [JSObjManager getObjWithKey: themeId];
        GeoStyle* style = [JSObjManager getObjWithKey: styleId];
        BOOL b =  [theme merge:index Count:count TextStyle:style Caption:caption];
        resolve(@(b));
    } @catch (NSException *exception) {
        reject(@"JSThemeLabel",@"JSThemeLabel mergeId expection",nil);
    }
}



/**
 * 根据给定的拆分分段值将一个指定序号的标签专题图子项拆分成两个具有各自风格和名称的标签专题图子项
 * @param themeLabelId
 * @param index
 * @param splitValue
 * @param styleId1
 * @param caption1
 * @param styleId2
 * @param caption2
 * @param promise
 */

RCT_REMAP_METHOD(split,splitId:(NSString*)themeId   index:(int)index split:(double)splitValue styleId:(NSString*)styleId caption:(NSString*)caption styleId2:(NSString*)styleId2 caption2:(NSString*)caption2 resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabel* theme = [JSObjManager getObjWithKey: themeId];
        GeoStyle* style = [JSObjManager getObjWithKey: styleId];
        GeoStyle* style2 = [JSObjManager getObjWithKey: styleId2];
        BOOL b = [theme split:index SplitValue:splitValue Style1:style Caption1:caption Style2:style2 Caption2:caption2];
       
        resolve(@(b));
    } @catch (NSException *exception) {
        reject(@"JSThemeLabel",@"JSThemeLabel split expection",nil);
    }
}

/**
 * 根据给定的矢量数据集、分段字段表达式、分段模式和相应的分段参数生成默认的标签专题图
 * @param datasetVectorId
 * @param expression
 * @param rangeMode
 * @param rangeParameter
 * @param promise
 */

RCT_REMAP_METHOD(makeDefault,datasetVectorIdId:(NSString*)themeId expression:(NSString*)expression rangeMode:(int) rangeMode rangeParameter:(double) rangeParameter resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        DatasetVector* dv = [JSObjManager getObjWithKey: themeId];
        ThemeLabel* theme = [ThemeLabel makeDefault:dv rangeExpression:expression rangeMode:rangeMode rangeParameter:rangeParameter];
       
        resolve([JSObjManager addObj:theme]);
    } @catch (NSException *exception) {
        reject(@"JSThemeLabel",@"JSThemeLabel datasetVectorIdId expection",nil);
    }
}


/**
 * 根据给定的矢量数据集、分段字段表达式、分段模式、相应的分段参数和颜色渐变模式生成默认的标签专题图
 * @param datasetVectorId
 * @param expression
 * @param rangeMode
 * @param rangeParameter
 * @param colorGradientType
 * @param promise
 */
RCT_REMAP_METHOD(makeDefault,datasetVectorIdId:(NSString*)themeId expression:(NSString*)expression rangeMode:(int) rangeMode rangeParameter:(double) rangeParameter colorGradientType:(int)colorGradientType resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        DatasetVector* dv = [JSObjManager getObjWithKey: themeId];
        ThemeLabel* theme = [ThemeLabel makeDefault:dv rangeExpression:expression rangeMode:rangeMode rangeParameter:rangeParameter colorGradientType:colorGradientType];
        
        resolve([JSObjManager addObj:theme]);
    } @catch (NSException *exception) {
        reject(@"JSThemeLabel",@"JSThemeLabel datasetVectorIdId expection",nil);
    }
}


/**
 * 对标签专题图中分段的风格进行反序显示
 * @param themeRangeId
 * @param promise
 */

RCT_REMAP_METHOD(reverseStyle,reverseStyleId:(NSString*)themeId    resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabel* theme = [JSObjManager getObjWithKey: themeId];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"JSThemeLabel",@"JSThemeLabel reverseStyle expection",nil);
    }
}



/**
 * 设置是否以全方向文本避让
 * @param themeRangeId
 * @param value
 * @param promise
 */

RCT_REMAP_METHOD(setAllDirectionsOverlappedAvoided,setAllDirectionsOverlappedAvoidedId:(NSString*)themeId  b:(BOOL)b  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabel* theme = [JSObjManager getObjWithKey: themeId];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"JSThemeLabel",@"JSThemeLabel setAllDirectionsOverlappedAvoided expection",nil);
    }
}



/**
 * 设置是否沿线显示文本
 * @param themeRangeId
 * @param value
 * @param promise
 */
RCT_REMAP_METHOD(setAlongLine,setAlongLineId:(NSString*)themeId  b:(BOOL)b  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabel* theme = [JSObjManager getObjWithKey: themeId];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"JSThemeLabel",@"JSThemeLabel setAlongLine expection",nil);
    }
}




/**
 * 设置标签沿线标注方向
 * @param themeRangeId
 * @param value
 * @param promise
 */

RCT_REMAP_METHOD(setAlongLineDirection,setAlongLineDirectionId:(NSString*)themeId  b:(int)b  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabel* theme = [JSObjManager getObjWithKey: themeId];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"JSThemeLabel",@"JSThemeLabel setAlongLineDirection expection",nil);
    }
}


/**
 * 设置沿线文本间隔比率，该方法只对沿线标注起作用
 * @param themeRangeId
 * @param value
 * @param promise
 */

RCT_REMAP_METHOD(setAlongLineSpaceRatio,setAlongLineSpaceRatioId:(NSString*)themeId  b:(double)b  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabel* theme = [JSObjManager getObjWithKey: themeId];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"JSThemeLabel",@"JSThemeLabel setAlongLineSpaceRatio expection",nil);
    }
}

/**
 * 当沿线显示文本时，是否将文本角度固定
 * @param themeRangeId
 * @param value
 * @param promise
 */

RCT_REMAP_METHOD(setAngleFixed,setAngleFixedId:(NSString*)themeId  b:(BOOL)b  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabel* theme = [JSObjManager getObjWithKey: themeId];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"JSThemeLabel",@"JSThemeLabel getUsetAngleFixedniformStyle expection",nil);
    }
}



/**
 * 设置标签专题图中的标签背景的形状类型
 * @param themeRangeId
 * @param value
 * @param promise
 */

RCT_REMAP_METHOD(setBackShape,setBackShapeId:(NSString*)themeId  value:(int)value  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabel* theme = [JSObjManager getObjWithKey: themeId];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"JSThemeLabel",@"JSThemeLabel setBackShape expection",nil);
    }
}



/**
 * 设置标签专题图中的标签背景风格,OpenGL不支持标签背景透明度
 * @param themeRangeId
 * @param styleId
 * @param promise
 */

RCT_REMAP_METHOD(setBackStyle,setBackStyleId:(NSString*)themeId  value:(NSString*)value  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ThemeLabel* theme = [JSObjManager getObjWithKey: themeId];
        resolve(@(1));
    } @catch (NSException *exception) {
        reject(@"JSThemeLabel",@"JSThemeLabel setBackStyle expection",nil);
    }
}



@end

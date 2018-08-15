//
//  JSTheme.m
//  Supermap
//
//  Created by 王子豪 on 2017/4/26.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSTheme.h"

#import "SuperMap/Theme.h"
#import "SuperMap/ThemeLabel.h"
#import "SuperMap/ThemeUnique.h"
#import "SuperMap/ThemeRange.h"

#import "JSObjManager.h"

@implementation JSTheme
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(makeThemeLabel, makeThemeLabelBydsVectorId:(NSString*)dsVectorId rangeExpression:(NSString*)rangeExpression rangeMode:(int)rangeMode rangeParameter:(double)rangeParameter colorGradientType:(int)colorGradientType resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    DatasetVector* dsVector = [JSObjManager getObjWithKey:dsVectorId];
    if (dsVector) {
    ThemeLabel* themeLabel = [ThemeLabel makeDefault:dsVector rangeExpression:rangeExpression rangeMode:rangeMode rangeParameter:rangeParameter colorGradientType:colorGradientType];
    NSInteger labelKey = (NSInteger)themeLabel;
    [JSObjManager addObj:themeLabel];
        resolve(@{@"themeId":@(labelKey).stringValue});
    }else{
        reject(@"theme",@"make Theme Label failed",nil);
    }
}

RCT_REMAP_METHOD(makeThemeUnique, makeThemeUniqueBydsVectorId:(NSString*)dsVectorId uniqueExpression:(NSString*)uniqueExpression colorGradientType:(int)colorGradientType resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    DatasetVector* dsVector = [JSObjManager getObjWithKey:dsVectorId];
    if (dsVector) {
        ThemeUnique* themeUnique = [ThemeUnique makeDefault:dsVector uniqueExpression:uniqueExpression colorType:colorGradientType];
        NSInteger uniqueKey = (NSInteger)themeUnique;
        [JSObjManager addObj:themeUnique];
        resolve(@{@"themeId":@(uniqueKey).stringValue});
    }else{
        reject(@"theme",@"make Theme Unique failed",nil);
    }
}

RCT_REMAP_METHOD(makeThemeRange, makeThemeRangeBydsVectorId:(NSString*)dsVectorId rangeExpression:(NSString*)rangeExpression rangeMode:(int)rangeMode rangeParameter:(double)rangeParameter colorGradientType:(int)colorGradientType resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    DatasetVector* dsVector = [JSObjManager getObjWithKey:dsVectorId];
    if (dsVector) {
        ThemeRange* themeRange = [ThemeRange makeDefaultDataSet:dsVector RangeExpression:rangeExpression RangeMode:rangeMode RangeParameter:rangeParameter ColorGradientType:colorGradientType];
        NSInteger rangeKey = (NSInteger)themeRange;
        [JSObjManager addObj:themeRange];
        resolve(@{@"themeId":@(rangeKey).stringValue});
    }else{
        reject(@"theme",@"make Theme Range failed",nil);
    }
}

RCT_REMAP_METHOD(getType, getTypeId:(NSString*)dsVectorId  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Theme* dsVector = [JSObjManager getObjWithKey:dsVectorId];
    if (dsVector) {
        int type = dsVector.themeType;
        resolve(@(type));
    }else{
        reject(@"theme",@"theme getType  failed",nil);
    }
}

@end

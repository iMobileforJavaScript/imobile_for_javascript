//
//  JSRelationalPointChart.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/8.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSRelationalPointChart.h"

#import "SuperMap/RelationalPointChart.h"
#import "SuperMap/Color.h"
#import "JSObjManager.h"
@implementation JSRelationalPointChart
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj,createObjWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        RelationalPointChart* chart = [[RelationalPointChart alloc]init];
        NSInteger nsKey = (NSInteger)chart;
        [JSObjManager addObj:chart];
        resolve(@{@"relationalPointChartId":@(nsKey).stringValue});
    } @catch (NSException *exception) {
        reject(@"RelationalPointChart",@"create Obj expection",nil);
    }
}

RCT_REMAP_METHOD(setAnimation,setAnimationById:(NSString*)chartId isAnimation:(BOOL)isAnimation resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        RelationalPointChart* relationalPointChart = [JSObjManager getObjWithKey:chartId];
        relationalPointChart.isAnimation = isAnimation;
        resolve(@"Animation  setted");
    } @catch (NSException *exception) {
        reject(@"RelationalPointChart",@"set Animation expection",nil);
    }
}

RCT_REMAP_METHOD(isAnimation,isAnimationById:(NSString*)chartId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        RelationalPointChart* relationalPointChart = [JSObjManager getObjWithKey:chartId];
        BOOL isAnimation = relationalPointChart.isAnimation;
        NSNumber* nsAnimation = [NSNumber numberWithBool:isAnimation];
        resolve(@{@"isAnimation":nsAnimation});
    } @catch (NSException *exception) {
        reject(@"RelationalPointChart",@"get Animation expection",nil);
    }
}

RCT_REMAP_METHOD(setAnimationImage,setAnimationImageById:(NSString*)chartId URL:(NSString*)url resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        RelationalPointChart* relationalPointChart = [JSObjManager getObjWithKey:chartId];
        UIImage* image = [UIImage imageNamed:url];
        relationalPointChart.animationImage = image;
        resolve(@"image  setted");
    } @catch (NSException *exception) {
        reject(@"RelationalPointChart",@"set imaage expection",nil);
    }
}
/*
RCT_REMAP_METHOD(getAnimationImage,getAnimationImageById:(NSString*)chartId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        RelationalPointChart* relationalPointChart = [JSObjManager getObjWithKey:chartId];
        UIImage* image = relationalPointChart.animationImage;
        NSNumber* nsAnimation = [NSNumber numberWithBool:isAnimation];
        resolve(@{@"isAnimation":nsAnimation});
    } @catch (NSException *exception) {
        reject(@"RelationalPointChart",@"get Animation expection",nil);
    }
}
 */
RCT_REMAP_METHOD(setColorScheme,setColorSchemeById:(NSString*)chartId colorScheme:(NSString*)colorSchemeId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        RelationalPointChart* relationalPointChart = [JSObjManager getObjWithKey:chartId];
        ColorScheme* colorScheme = [JSObjManager getObjWithKey:colorSchemeId];
        [relationalPointChart setColorScheme:colorScheme];
        resolve(@"ColorScheme setted");
    } @catch (NSException *exception) {
        reject(@"RelationalPointChart",@"set ColorScheme expection",nil);
    }
}
@end

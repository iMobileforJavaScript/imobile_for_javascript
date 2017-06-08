//
//  JSColorScheme.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/6.
//  Copyright © 2017年 Facebook. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "JSColorScheme.h"

#import "SuperMap/ChartView.h"
#import "SuperMap/Color.h"
#import "JSObjManager.h"
@implementation JSColorScheme
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj,createObjWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ColorScheme* colorScheme = [[ColorScheme alloc]init];
        NSInteger nsColorKey = (NSInteger)colorScheme;
        [JSObjManager addObj:colorScheme];
        resolve(@{@"colorSchemeId":@(nsColorKey).stringValue});
    } @catch (NSException *exception) {
        reject(@"colorScheme",@"create Obj expection",nil);
    }
}

RCT_REMAP_METHOD(setColors,setColorsById:(NSString*)schemeId colors:(NSArray*)colors resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSMutableArray* colorsArr = [NSMutableArray arrayWithCapacity:5];
        for (NSArray* arr in colors) {
            float alpha = 1.0f;
            if (arr.count<3 || arr.count>=5) {
                reject(@"colorScheme",@"each RGB arr should have 3 or 4 arguments!",nil);
            }else if (arr.count ==4){
                alpha = ((NSNumber*)arr[3]).floatValue;
            }
            float red = ((NSNumber*)arr[0]).floatValue;
            float green = ((NSNumber*)arr[1]).floatValue;
            float blue = ((NSNumber*)arr[2]).floatValue;
            UIColor* color = [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:alpha];
            [colorsArr addObject:color];
        }
        ColorScheme* colorScheme = [JSObjManager getObjWithKey:schemeId];
        colorScheme.colors = colorsArr;
        resolve(@"colorScheme setted");
    } @catch (NSException *exception) {
        reject(@"colorScheme",@"create Obj expection",nil);
    }
}

RCT_REMAP_METHOD(getColors,getColorsById:(NSString*)schemeId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ColorScheme* colorScheme = [JSObjManager getObjWithKey:schemeId];
        NSArray* colorArr = colorScheme.colors;
        NSMutableArray* numArr = [[NSMutableArray alloc]initWithCapacity:10];
        for (int i =0; i<colorArr.count; i++) {
            Color* color = colorArr[i];
            NSNumber* nsColorNum = [NSNumber numberWithInt:color.rgb];
            [numArr addObject:nsColorNum];
        }
        resolve(@{@"colors":numArr});
    } @catch (NSException *exception) {
        reject(@"colorScheme",@"get Colors expection",nil);
    }
}

RCT_REMAP_METHOD(setSegmentValue,setSegmentValueById:(NSString*)schemeId value:(NSArray*)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ColorScheme* colorScheme = [JSObjManager getObjWithKey:schemeId];
        colorScheme.segmentValue = value;
        resolve(@"segmentValue setted");
    } @catch (NSException *exception) {
        reject(@"colorScheme",@"set segmentValue expection",nil);
    }
}

RCT_REMAP_METHOD(getSegmentValue,getSegmentValueById:(NSString*)schemeId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        ColorScheme* colorScheme = [JSObjManager getObjWithKey:schemeId];
        NSArray* getSegmentValue = colorScheme.segmentValue;
        resolve(@{@"segmentValue":getSegmentValue});
    } @catch (NSException *exception) {
        reject(@"colorScheme",@"get SegmentValue expection",nil);
    }
}
@end

//
//  JSPolymerChart.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/8.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSPolymerChart.h"
#import "SuperMap/PolymerChart.h"
#import "SuperMap/Color.h"
#import "JSObjManager.h"
@implementation JSPolymerChart
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj,createObjByMapControl:(NSString*)mapControlId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if([NSThread isMainThread]){
            MapControl* mapControl = [JSObjManager getObjWithKey:mapControlId];
            PolymerChart* polymerChart = [[PolymerChart alloc]initWithMapControl:mapControl];
            NSInteger nsKey = (NSInteger)polymerChart;
            [JSObjManager addObj:polymerChart];
            resolve(@{@"polymerChartId":@(nsKey).stringValue});
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                MapControl* mapControl = [JSObjManager getObjWithKey:mapControlId];
                PolymerChart* polymerChart = [[PolymerChart alloc]initWithMapControl:mapControl];
                NSInteger nsKey = (NSInteger)polymerChart;
                [JSObjManager addObj:polymerChart];
                resolve(@{@"polymerChartId":@(nsKey).stringValue});
            });
        }
    } @catch (NSException *exception) {
        reject(@"PolymerChart",@"create Obj expection",nil);
    }
}

RCT_REMAP_METHOD(setPolymerizationType,setPolymerizationTypeById:(NSString*)chartId type:(int)type resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PolymerChart* polymerChart = [JSObjManager getObjWithKey:chartId];
        polymerChart.polymeriztionType = type;
        resolve(@"type setted");
    } @catch (NSException *exception) {
        reject(@"PolymerChart",@"set Polymerization Type expection",nil);
    }
}

RCT_REMAP_METHOD(getPolymerizationType,getPolymerizationTypeById:(NSString*)chartId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PolymerChart* polymerChart = [JSObjManager getObjWithKey:chartId];
        int type = polymerChart.polymeriztionType;
        NSNumber* typeNum = [NSNumber numberWithInt:type];
        resolve(@{@"type":typeNum});
    } @catch (NSException *exception) {
        reject(@"PolymerChart",@"get Polymerization Type expection",nil);
    }
}

RCT_REMAP_METHOD(setUnfoldColor,setUnfoldColorById:(NSString*)chartId colorDic:(NSDictionary*)colorDic resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PolymerChart* polymerChart = [JSObjManager getObjWithKey:chartId];
        float red = ((NSNumber*)[colorDic objectForKey:@"red"]).floatValue;
        float green = ((NSNumber*)[colorDic objectForKey:@"green"]).floatValue;
        float blue = ((NSNumber*)[colorDic objectForKey:@"blue"]).floatValue;
        float alpha = ((NSNumber*)[colorDic objectForKey:@"alpha"]).floatValue;
        Color* SMcolor = [[Color alloc]initWithR:red G:green B:blue A:alpha];
        polymerChart.unfoldColor = SMcolor;
        resolve(@"UnfoldColor setted");
    } @catch (NSException *exception) {
        reject(@"PolymerChart",@"set UnfoldColor expection",nil);
    }
}

RCT_REMAP_METHOD(getUnfoldColor,getUnfoldColorById:(NSString*)chartId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PolymerChart* polymerChart = [JSObjManager getObjWithKey:chartId];
        Color* color = polymerChart.unfoldColor;
        NSNumber* red = [NSNumber numberWithInt:color.red];
        NSNumber* green = [NSNumber numberWithInt:color.green];
        NSNumber* blue = [NSNumber numberWithInt:color.blue];
        NSNumber* alpha = [NSNumber numberWithInt:color.alpha];
        NSDictionary* colorDic = @{@"red":red,@"green":green,@"blue":blue,@"alpha":alpha};
        resolve(@{@"colorObj":colorDic});
    } @catch (NSException *exception) {
        reject(@"PolymerChart",@"get UnfoldColor expection",nil);
    }
}

RCT_REMAP_METHOD(setFoldColor,setFoldColorById:(NSString*)chartId colorDic:(NSDictionary*)colorDic resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PolymerChart* polymerChart = [JSObjManager getObjWithKey:chartId];
        float red = ((NSNumber*)[colorDic objectForKey:@"red"]).floatValue;
        float green = ((NSNumber*)[colorDic objectForKey:@"green"]).floatValue;
        float blue = ((NSNumber*)[colorDic objectForKey:@"blue"]).floatValue;
        float alpha = ((NSNumber*)[colorDic objectForKey:@"alpha"]).floatValue;
        Color* SMcolor = [[Color alloc]initWithR:red G:green B:blue A:alpha];
        polymerChart.foldColor = SMcolor;
        resolve(@"foldColor setted");
    } @catch (NSException *exception) {
        reject(@"PolymerChart",@"set foldColor expection",nil);
    }
}

RCT_REMAP_METHOD(getFoldColor,getFoldColorById:(NSString*)chartId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PolymerChart* polymerChart = [JSObjManager getObjWithKey:chartId];
        Color* color = polymerChart.foldColor;
        NSNumber* red = [NSNumber numberWithInt:color.red];
        NSNumber* green = [NSNumber numberWithInt:color.green];
        NSNumber* blue = [NSNumber numberWithInt:color.blue];
        NSNumber* alpha = [NSNumber numberWithInt:color.alpha];
        NSDictionary* colorDic = @{@"red":red,@"green":green,@"blue":blue,@"alpha":alpha};
        resolve(@{@"colorObj":colorDic});
    } @catch (NSException *exception) {
        reject(@"PolymerChart",@"get foldColor expection",nil);
    }
}

RCT_REMAP_METHOD(setColorScheme,setColorSchemeById:(NSString*)chartId colorScheme:(NSString*)colorSchemeId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        PolymerChart* polymerChart = [JSObjManager getObjWithKey:chartId];
        ColorScheme* colorScheme = [JSObjManager getObjWithKey:colorSchemeId];
        [polymerChart setColorScheme:colorScheme];
        resolve(@"ColorScheme setted");
    } @catch (NSException *exception) {
        reject(@"PolymerChart",@"set ColorScheme expection",nil);
    }
}
@end

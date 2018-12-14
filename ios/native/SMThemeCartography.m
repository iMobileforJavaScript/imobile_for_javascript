//
//  SMThemeCartography.m
//  Supermap
//
//  Created by xianglong li on 2018/12/6.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "SMThemeCartography.h"
#import "SMap.h"
#include "STranslate.h"

@implementation SMThemeCartography

+(Dataset* )getDataset:(NSString* ) datasetName datasourceIndex:(int) datasourceIndex{
    @try{
        Datasources* datasources = [SMap singletonInstance].smMapWC.workspace.datasources;
        Datasource* datasource = [datasources get:datasourceIndex];
        Dataset* dataset = nil;
        if (datasource != nil) {
            dataset = [datasource.datasets getWithName:datasetName];
        }
        return dataset;
    }
    @catch (NSException *exception){
        @throw exception;
    }
}

+(Dataset* )getDataset:(NSString* ) datasetName datasourceAlias:(NSString* )datasourceAlias{
    @try{
        Datasources* datasources = [SMap singletonInstance].smMapWC.workspace.datasources;
        Datasource* datasource = [datasources getAlias:datasourceAlias];
        Dataset* dataset = nil;
        if (datasource != nil) {
            dataset = [datasource.datasets getWithName:datasetName];
        }
        return dataset;
    }
    @catch (NSException *exception){
        @throw exception;
    }
}

+(Dataset* )getDataset:(NSString* ) datasetName data:(NSDictionary *)data{
    @try{
        if (![data objectForKey:@"server"] || ![data objectForKey:@"alias"] || ![data objectForKey:@"engineType"] ) {
            return nil;
        }
        Dataset* dataset = nil;
        Datasource* datasource = [[SMap singletonInstance].smMapWC openDatasource:data];
        if (datasource != nil) {
            dataset = [datasource.datasets getWithName:datasetName];
        }
        return dataset;
    }
    @catch (NSException *exception){
        @throw exception;
    }
}

+(Layer* )getLayerByIndex:(int) layerIndex{
    @try{
        MapControl *mapControl = [SMap singletonInstance].smMapWC.mapControl;
        Layers *layers = mapControl.map.layers;
        return [layers getLayerAtIndex:layerIndex];
    }
    @catch(NSException *exception){
        @throw exception;
    }
}
+(Layer* )getLayerByName:(NSString* )layerName{
    @try{
        MapControl *mapControl = [SMap singletonInstance].smMapWC.mapControl;
        Layers *layers = mapControl.map.layers;
        return [layers getLayerWithName:layerName];
    }
    @catch(NSException *exception){
        @throw exception;
    }
}
+(GeoStyle* )getThemeUniqueGeoStyle:(GeoStyle*)style data:(NSDictionary* )params{
    GeoStyle* cloneStyle = [style clone];
    @try {
        if (!params) {
            return nil;
        }
        NSArray* keyArr = [params allKeys];
        if ([keyArr containsObject:@"MarkerSymbolID"]){
            NSNumber* num = [params objectForKey:@"MarkerSymbolID"];
            int value = num.intValue;
            [style setMarkerSymbolID:value];
        }
        if ([keyArr containsObject:@"MarkerSize"]){
            NSNumber* num = [params objectForKey:@"MarkerSize"];
            int value = num.intValue;
            Size2D* size = [[Size2D alloc]initWithWidth:value Height:value];
            [style setMarkerSize:size];
        }
        if ([keyArr containsObject:@"MakerColor"]){
            NSString* str = [params objectForKey:@"MakerColor"];
            Color *color = [STranslate colorFromHexString:str];
            if(color != nil) [style setLineColor:color];
        }
        if ([keyArr containsObject:@"MarkerAngle"]){
            NSNumber* num = [params objectForKey:@"MarkerAngle"];
            int value = num.intValue;
            [style setMarkerAngle:value];
        }
        if ([keyArr containsObject:@"MarkerAngle"]){
            NSNumber* num = [params objectForKey:@"MarkerAngle"];
            int value = num.intValue;
            [style setMarkerAngle:value];
        }
        if ([keyArr containsObject:@"MarkerAlpha"]){
            NSNumber* num = [params objectForKey:@"MarkerAlpha"];
            int value = num.intValue;
            [style setFillOpaqueRate:100-value];
        }
        if ([keyArr containsObject:@"LineSymbolID"]){
            NSNumber* num = [params objectForKey:@"LineSymbolID"];
            int value = num.intValue;
            [style setLineSymbolID:value];
        }
        if ([keyArr containsObject:@"LineWidth"]){
            NSNumber* num = [params objectForKey:@"LineWidth"];
            int value = num.intValue;
            double width = value / 10.0;
            [style setLineWidth:width];
        }
        if ([keyArr containsObject:@"LineColor"]){
            NSString* str = [params objectForKey:@"LineColor"];
            Color *color = [STranslate colorFromHexString:str];
            if(color != nil) [style setLineColor:color];
        }
        
        if ([keyArr containsObject:@"FillSymbolID"]){
            NSNumber* num = [params objectForKey:@"FillSymbolID"];
            int value = num.intValue;
            [style setFillSymbolID:value];
        }
        if ([keyArr containsObject:@"FillForeColor"]){
            NSString* str = [params objectForKey:@"FillForeColor"];
            Color *color = [STranslate colorFromHexString:str];
            if(color != nil) [style setFillForeColor:color];
        }
        if ([keyArr containsObject:@"FillBackColor"]){
            NSString* str = [params objectForKey:@"FillBackColor"];
            Color *color = [STranslate colorFromHexString:str];
            if(color != nil) [style setFillBackColor:color];
        }
        if ([keyArr containsObject:@"FillOpaqueRate"]){
            NSNumber* num = [params objectForKey:@"FillOpaqueRate"];
            int value = num.intValue;
            [style setFillOpaqueRate:100-value];
        }
        if ([keyArr containsObject:@"FillGradientMode"]){
            NSString* str = [params objectForKey:@"FillGradientMode"];
            if ([str isEqualToString:@"LINER"]) {
                [style setFillGradientMode:FGM_LINEAR];
            }
            if ([str isEqualToString:@"RADIAL"]) {
                [style setFillGradientMode:FGM_RADIAL];
            }
            if ([str isEqualToString:@"SQUARE"]) {
                [style setFillGradientMode:FGM_SQUARE];
            }
            if ([str isEqualToString:@"NONE"]) {
                [style setFillGradientMode:FGM_NONE];
            }
        }
        return style;
    }
    @catch(NSException *exception){
        @throw exception;
        return cloneStyle;
    }
}
+(NSMutableDictionary* )getThemeUniqueDefaultStyle:(GeoStyle* )style{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    @try{
        int markerSymbolID = [style getMarkerSymbolID];
        [dic setValue:[NSNumber numberWithInteger:markerSymbolID] forKey:@"MarkerSymbolID"];
        
        Size2D* markerSize = [style getMarkerSize];
        [dic setValue:[NSNumber numberWithDouble:markerSize.height] forKey:@"MarkerSize"];
        
        Color* markerColor = [style getLineColor];
        [dic setValue:[markerColor toColorString] forKey:@"MarkerColor"];
        
        double markerAngle = [style getMarkerAngle];
        [dic setValue:[NSNumber numberWithDouble:markerAngle] forKey:@"MarkerAngle"];
        
        int markerFillOpaqueRate = [style getFillOpaqueRate];
        [dic setValue:[NSNumber numberWithInteger:markerFillOpaqueRate] forKey:@"MarkerFillOpaqueRate"];
        
        int lineSymbolID = [style getLineSymbolID];
        [dic setValue:[NSNumber numberWithInteger:lineSymbolID] forKey:@"MarkerSymbolID"];
        
        double lineWidth = [style getMarkerSymbolID];
        [dic setValue:[NSNumber numberWithDouble:lineWidth] forKey:@"LineWidth"];
        
        Color* lineColor = [style getLineColor];
        [dic setValue:[lineColor toColorString] forKey:@"LineColor"];
        
        int fillSymbolID = [style getFillSymbolID];
        [dic setValue:[NSNumber numberWithInteger:fillSymbolID] forKey:@"FillSymbolID"];
        
        Color* fillBackColor = [style getFillBackColor];
        [dic setValue:[fillBackColor toColorString] forKey:@"FillBackColor"];
        
        Color* fillForeColor = [style getFillForeColor];
        [dic setValue:[fillForeColor toColorString] forKey:@"FillForeColor"];
        
        int fillOpaqueRate = [style getFillOpaqueRate];
        [dic setValue:[NSNumber numberWithInteger:fillOpaqueRate] forKey:@"FillOpaqueRate"];
        
        SM_FillGradientMode fillGradientMode =  [style getFillGradientMode];
        NSString* stringMode = @"NONE";
        if (fillGradientMode == FGM_LINEAR) {
            stringMode = @"LINEAR";
        } else if(fillGradientMode == FGM_RADIAL){
            stringMode = @"RADIAL";
        } else if (fillGradientMode == FGM_SQUARE){
            stringMode = @"SQUARE";
        } else if (fillGradientMode == FGM_NONE){
            stringMode = @"NONE";
        }
        [dic setValue:stringMode forKey:@"FillGradientMode"];
        return dic;
    }
    
    @catch(NSException *exception){
        @throw exception;
        return nil;
    }
}

+(ColorGradientType) getColorGradientType:(NSString*) type{
    if ([type isEqualToString:@"BLACKWHITE"]) {
        return CGT_BLACKWHITE;
    }
    if ([type isEqualToString:@"BLUEBLACK"]) {
        return CGT_BLUEBLACK;
    }
    if ([type isEqualToString:@"BLUERED"]) {
        return CGT_BLUERED;
    }
    if ([type isEqualToString:@"BLUEWHITE"]) {
        return CGT_BLUEWHITE;
    }
    if ([type isEqualToString:@"CYANBLACK"]) {
        return CGT_CYANBLACK;
    }
    if ([type isEqualToString:@"CYANBLUE"]) {
        return CGT_CYANBLUE;
    }
    if ([type isEqualToString:@"CYANGREEN"]) {
        return CGT_CYANGREEN;
    }
    if ([type isEqualToString:@"CYANWHITE"]) {
        return CGT_CYANWHITE;
    }
    if ([type isEqualToString:@"GREENBLACK"]) {
        return CGT_GREENBLACK;
    }
    if ([type isEqualToString:@"GREENBLUE"]) {
        return CGT_GREENBLUE;
    }
    if ([type isEqualToString:@"GREENORANGEVIOLET"]) {
        return CGT_GREENORANGEVIOLET;
    }
    if ([type isEqualToString:@"GREENRED"]) {
        return CGT_GREENRED;
    }
    if ([type isEqualToString:@"GREENWHITE"]) {
        return CGT_GREENWHITE;
    }
    if ([type isEqualToString:@"PINKBLACK"]) {
        return CGT_PINKBLACK;
    }
    if ([type isEqualToString:@"PINKBLUE"]) {
        return CGT_PINKBLUE;
    }
    if ([type isEqualToString:@"PINKRED"]) {
        return CGT_PINKRED;
    }
    if ([type isEqualToString:@"PINKWHITE"]) {
        return CGT_PINKWHITE;
    }
    if ([type isEqualToString:@"RAINBOW"]) {
        return CGT_RAINBOW;
    }
    if ([type isEqualToString:@"REDBLACK"]) {
        return CGT_REDBLACK;
    }
    if ([type isEqualToString:@"REDWHITE"]) {
        return CGT_REDWHITE;
    }
    if ([type isEqualToString:@"SPECTRUM"]) {
        return CGT_SPECTRUM;
    }
    if ([type isEqualToString:@"TERRAIN"]) {
        return CGT_TERRAIN;
    }
    if ([type isEqualToString:@"YELLOWBLACK"]) {
        return CGT_YELLOWBLACK;
    }
    if ([type isEqualToString:@"YELLOWBLUE"]) {
        return CGT_YELLOWBLUE;
    }
    if ([type isEqualToString:@"YELLOWGREEN"]) {
        return CGT_YELLOWGREEN;
    }
    if ([type isEqualToString:@"YELLOWRED"]) {
        return CGT_YELLOWRED;
    }
    if ([type isEqualToString:@"YELLOWWHITE"]) {
        return CGT_YELLOWWHITE;
    }
    return CGT_TERRAIN;
}

@end

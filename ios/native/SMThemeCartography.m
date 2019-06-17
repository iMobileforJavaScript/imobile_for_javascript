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
static NSArray* lastGridRangeColors = nil;

+(void)setGeoStyleColor:(DatasetType)type geoStyle:(GeoStyle*)geoStyle color:(Color*)color{
    @try{
        NSString* strType = [self datasetTypeToString:type];
        if([strType isEqualToString:@"POINT"])
        {
            [geoStyle setLineColor:color];
        }
        if([strType isEqualToString:@"LINE"])
        {
            [geoStyle setLineColor:color];
        }
        if([strType isEqualToString:@"REGION"])
        {
            [geoStyle setFillForeColor:color];
        }
    }
    @catch (NSException *exception){
        @throw exception;
    }
}

+(NSMutableArray*)getLastThemeColors:(Layer* )layer{
    @try{
        if (layer == nil) {
            return nil;
        }
        Theme* theme = nil;
        theme = layer.theme;
        if (theme == nil) {
            return nil;
        }
        Color* color_start = nil;
        Color* color_end = nil;
        if (theme.themeType == TT_Unique) {
            ThemeUnique* themeUnique = (ThemeUnique*)theme;
            int count = [themeUnique getCount];
            NSString* strType = [self datasetTypeToString:layer.dataset.datasetType];
            if ([strType isEqualToString:@"POINT"]) {
                color_start = [[themeUnique getItem:0].mStyle getLineColor];
                color_end = [[themeUnique getItem:(count-1)].mStyle getLineColor];
            }
            if ([strType isEqualToString:@"LINE"]) {
                color_start = [[themeUnique getItem:0].mStyle getLineColor];
                color_end = [[themeUnique getItem:(count-1)].mStyle getLineColor];
            }
            if ([strType isEqualToString:@"REGION"]) {
                color_start = [[themeUnique getItem:0].mStyle getFillForeColor];
                color_end = [[themeUnique getItem:(count-1)].mStyle getFillForeColor];
            }
            if(color_start == nil || color_end == nil)
            {
                return nil;
            }
            int rgb_start = color_start.rgb;
            int rgb_end = color_end.rgb;
            NSEnumerator* enumValue = [[self getUniqueColors:@""] objectEnumerator];
            for (NSObject* object in enumValue) {
                NSMutableArray* arrayColor = (NSMutableArray*)object;
                NSUInteger count = arrayColor.count;
                Color* color01 =[arrayColor objectAtIndex:0];
                int rgb01 = color01.rgb;
                Color* color02 = [arrayColor objectAtIndex:count-1];
                int rgb02 = color02.rgb;
                if (rgb_start == rgb01 && rgb_end == rgb02) {
                    return arrayColor;
                }
            }
        }
        else if (theme.themeType == TT_Range){
            ThemeRange* themeRange = (ThemeRange*)theme;
            int count = [themeRange getCount];
            NSString* strType = [self datasetTypeToString:layer.dataset.datasetType];
            if ([strType isEqualToString:@"POINT"]) {
                color_start = [[themeRange getItem:0].mStyle getLineColor];
                color_end = [[themeRange getItem:(count-1)].mStyle getLineColor];
            }
            if ([strType isEqualToString:@"LINE"]) {
                color_start = [[themeRange getItem:0].mStyle getLineColor];
                color_end = [[themeRange getItem:(count-1)].mStyle getLineColor];
            }
            if ([strType isEqualToString:@"REGION"]) {
                color_start = [[themeRange getItem:0].mStyle getFillForeColor];
                color_end = [[themeRange getItem:(count-1)].mStyle getFillForeColor];
            }
            if(color_start == nil || color_end == nil)
            {
                return nil;
            }
            int rgb_start = color_start.rgb;
            int rgb_end = color_end.rgb;
            NSEnumerator* enumValue = [[self getRangeColors:@""] objectEnumerator];
            for (NSObject* object in enumValue) {
                NSMutableArray* arrayColor = (NSMutableArray*)object;
                NSUInteger count = arrayColor.count;
                Color* color01 =[arrayColor objectAtIndex:0];
                int rgb01 = color01.rgb;
                Color* color02 = [arrayColor objectAtIndex:count-1];
                int rgb02 = color02.rgb;
                if (rgb_start == rgb01 && rgb_end == rgb02) {
                    return arrayColor;
                }
            }
        }else if (theme.themeType == TT_Graph){
            ThemeGraph* themeGraph=(ThemeGraph*)theme;
            int count=[themeGraph getCount];
            
            if(count==0){
                return nil;
            }else{
                color_start=[[[themeGraph getItem:0] uniformStyle] getFillForeColor];
                
                if(color_start==nil){
                    return nil;
                }
                
                int rgb_start=color_start.rgb;
                NSEnumerator* enumValue = [[self getGraphColors:@""] objectEnumerator];
                for (NSObject* object in enumValue) {
                    NSMutableArray* arrayColor = (NSMutableArray*)object;
                    Color* color01 =[arrayColor objectAtIndex:0];
                    int rgb01 = color01.rgb;
                    if (rgb_start == rgb01) {
                        return arrayColor;
                    }
                }
            }
            
        }else if(theme.themeType == TT_GridUnique){
            ThemeGridUnique* themeGridUnique=(ThemeGridUnique*) theme;
            int count=[themeGridUnique getCount];
            
            NSString* strType = [self datasetTypeToString:layer.dataset.datasetType];
            if ([strType isEqualToString:@"GRID"]) {
                [themeGridUnique getItem:0];
                color_start = [[themeGridUnique getItem:0] color];
                color_end = [[themeGridUnique getItem:(count-1)] color];
            }
            if(color_start == nil || color_end == nil)
            {
                return nil;
            }
            int rgb_start = color_start.rgb;
            int rgb_end = color_end.rgb;
            NSEnumerator* enumValue = [[self getRangeColors:@""] objectEnumerator];
            for (NSObject* object in enumValue) {
                NSMutableArray* arrayColor = (NSMutableArray*)object;
                NSUInteger count = arrayColor.count;
                Color* color01 =[arrayColor objectAtIndex:0];
                int rgb01 = color01.rgb;
                Color* color02 = [arrayColor objectAtIndex:count-1];
                int rgb02 = color02.rgb;
                if (rgb_start == rgb01 && rgb_end == rgb02) {
                    return arrayColor;
                }
            }
        }else if(theme.themeType == TT_GridRange){
            ThemeGridRange* themeGridRange=(ThemeGridRange*) theme;     //组件缺这个类
            int count = [themeGridRange getCount];
            if (layer.dataset.datasetType==Grid) {
                color_start = [[themeGridRange getItem:0] color];
                color_end = [[themeGridRange getItem:count-1] color];
            }
            if (color_start==nil || color_end==nil) {
                return nil;
            }
            int rgb_start = color_start.rgb;
            int rgb_end = color_end.rgb;
            NSEnumerator* enumValue = [[self getRangeColors:@""] objectEnumerator];
            for (NSObject* object in enumValue) {
                NSMutableArray* arrayColor = (NSMutableArray*)object;
                NSUInteger count = arrayColor.count;
                Color* color01 =[arrayColor objectAtIndex:0];
                int rgb01 = color01.rgb;
                Color* color02 = [arrayColor objectAtIndex:count-1];
                int rgb02 = color02.rgb;
                if (rgb_start == rgb01 && rgb_end == rgb02) {
                    return arrayColor;
                }
            }
        }
        return nil;
    }
    @catch (NSException *exception){
        @throw exception;
    }
}

+(NSString*)getThemeColorSchemeName:(Layer* )layer{
    @try{
        if (layer == nil) {
            return nil;
        }
        Theme* theme = nil;
        theme = layer.theme;
        if (theme == nil) {
            return nil;
        }
        Color* color_start = nil;
        Color* color_end = nil;
        if (theme.themeType == TT_Unique) {
            ThemeUnique* themeUnique = (ThemeUnique*)theme;
            int count = [themeUnique getCount];
            NSString* strType = [self datasetTypeToString:layer.dataset.datasetType];
            if ([strType isEqualToString:@"POINT"]) {
                color_start = [[themeUnique getItem:0].mStyle getLineColor];
                color_end = [[themeUnique getItem:(count-1)].mStyle getLineColor];
            }
            if ([strType isEqualToString:@"LINE"]) {
                color_start = [[themeUnique getItem:0].mStyle getLineColor];
                color_end = [[themeUnique getItem:(count-1)].mStyle getLineColor];
            }
            if ([strType isEqualToString:@"REGION"]) {
                color_start = [[themeUnique getItem:0].mStyle getFillForeColor];
                color_end = [[themeUnique getItem:(count-1)].mStyle getFillForeColor];
            }
            if(color_start == nil || color_end == nil)
            {
                return nil;
            }
            int rgb_start = color_start.rgb;
            int rgb_end = color_end.rgb;
            NSMutableDictionary* colorDic = [self getUniqueColors:@""];
            for (NSString* key in colorDic) {
                NSMutableArray* arrayColor = [colorDic objectForKey:key];
                NSUInteger count = arrayColor.count;
                Color* color01 =[arrayColor objectAtIndex:0];
                int rgb01 = color01.rgb;
                Color* color02 = [arrayColor objectAtIndex:count-1];
                int rgb02 = color02.rgb;
                if (rgb_start == rgb01 && rgb_end == rgb02) {
                    return key;
                }
            }
        }
        else if (theme.themeType == TT_Range){
            ThemeRange* themeRange = (ThemeRange*)theme;
            int count = [themeRange getCount];
            NSString* strType = [self datasetTypeToString:layer.dataset.datasetType];
            if ([strType isEqualToString:@"POINT"]) {
                color_start = [[themeRange getItem:0].mStyle getLineColor];
                color_end = [[themeRange getItem:(count-1)].mStyle getLineColor];
            }
            if ([strType isEqualToString:@"LINE"]) {
                color_start = [[themeRange getItem:0].mStyle getLineColor];
                color_end = [[themeRange getItem:(count-1)].mStyle getLineColor];
            }
            if ([strType isEqualToString:@"REGION"]) {
                color_start = [[themeRange getItem:0].mStyle getFillForeColor];
                color_end = [[themeRange getItem:(count-1)].mStyle getFillForeColor];
            }
            if(color_start == nil || color_end == nil)
            {
                return nil;
            }
            int rgb_start = color_start.rgb;
            int rgb_end = color_end.rgb;
            NSMutableDictionary* colorDic = [self getRangeColors:@""];
            for (NSString* key in colorDic) {
                NSMutableArray* arrayColor = [colorDic objectForKey:key];
                NSUInteger count = arrayColor.count;
                Color* color01 =[arrayColor objectAtIndex:0];
                int rgb01 = color01.rgb;
                Color* color02 = [arrayColor objectAtIndex:count-1];
                int rgb02 = color02.rgb;
                if (rgb_start == rgb01 && rgb_end == rgb02) {
                    return key;
                }
            }
        }
        return nil;
    }
    @catch (NSException *exception){
        @throw exception;
    }
}

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

+(RangeMode)getRangeMode:(NSString*) strMode{
    if ([strMode isEqualToString:@"CUSTOMINTERVAL"]) {
        return RM_CUSTOMINTERVAL;
    }
    if ([strMode isEqualToString:@"EQUALINTERVAL"]) {
        return RM_EQUALINTERVAL;
    }
    if ([strMode isEqualToString:@"LOGARITHM"]) {
        return RM_LOGARITHM;
    }
    if ([strMode isEqualToString:@"NONE"]) {
        return RM_None;
    }
    if ([strMode isEqualToString:@"QUANTILE"]) {
        return RM_QUANTILE;
    }
    if ([strMode isEqualToString:@"SQUAREROOT"]) {
        return RM_SQUAREROOT;
    }
    if ([strMode isEqualToString:@"STDDEVIATION"]) {
        return RM_STDDEVIATION;
    }
    return RM_CUSTOMINTERVAL;
}

+(NSString*)rangeModeToStr:(RangeMode) mode{
    NSString* strMode = @"";
    switch (mode) {
        case RM_CUSTOMINTERVAL:
            strMode = @"CUSTOMINTERVAL";
            break;
        case RM_EQUALINTERVAL:
            strMode = @"EQUALINTERVAL";
            break;
        case RM_LOGARITHM:
            strMode = @"LOGARITHM";
            break;
        case RM_None:
            strMode = @"NONE";
            break;
        case RM_QUANTILE:
            strMode = @"QUANTILE";
            break;
        case RM_SQUAREROOT:
            strMode = @"SQUAREROOT";
            break;
        case RM_STDDEVIATION:
            strMode = @"STDDEVIATION";
            break;
        default:
            break;
    }
    return strMode;
}

+(NSString*)getFieldType:(NSString*)language info:(FieldInfo*) info{
    NSString* type =@"未知";
   
    if ([language isEqualToString:@"CN"]){
        switch (info.fieldType) {
            case FT_BOOLEAN:
                type = @"布尔型字段";
                break;
            case FT_BYTE:
                type = @"字节型字段";
                break;
            case FT_INT16:
                type = @"16位整型字段";
                break;
            case FT_INT32:
                type = @"32位整型字段";
                break;
            case FT_INT64:
                type = @"64位整型字段";
                break;
            case FT_SINGLE:
                type = @"32位精度浮点型字段";
                break;
            case FT_DOUBLE:
                type = @"64位精度浮点型字段";
                break;
            case FT_DATE:
                type = @"时间型字段";
                break;
            case FT_DATETIME:
                type = @"日期型字段";
                break;
            case FT_LONGBINARY:
                type = @"二进制型字段";
                break;
            case FT_TEXT:
                type = @"变长的文本型字段";
                break;
            case FT_CHAR:
                type = @"定长的文本类型字段";
                break;
            case FT_WTEXT:
                type = @"宽字符类型字段";
                break;
            default:
                break;
        }
    }else if([language isEqualToString:@"EN"]){
        type = @"Unknown Type";
        switch (info.fieldType) {
            case FT_BOOLEAN:
                type = @"Boolean";
                break;
            case FT_BYTE:
                type = @"Byte";
                break;
            case FT_INT16:
                type = @"Short";
                break;
            case FT_INT32:
                type = @"Int";
                break;
            case FT_INT64:
                type = @"Long";
                break;
            case FT_SINGLE:
                type = @"Single";
                break;
            case FT_DOUBLE:
                type = @"Double";
                break;
            case FT_DATE:
                type = @"Time";
                break;
            case FT_DATETIME:
                type = @"Date";
                break;
            case FT_LONGBINARY:
                type = @"Long Binary";
                break;
            case FT_TEXT:
                type = @"Text";
                break;
            case FT_CHAR:
                type = @"Char";
                break;
            case FT_WTEXT:
                type = @"Wide Char";
                break;
            default:
                break;
                
        }
    }
    return type;
}
+(BOOL)addGraphItem:(ThemeGraph*)themeGraph graphExpression:(NSString*)graphExpression colors:(Colors*)colors{
    BOOL isSuccess=NO;
    @try{
        NSMutableArray* existItems=[[NSMutableArray alloc] init];
        for(int i=0;i<themeGraph.getCount;i++){
            [existItems addObject:[[themeGraph getItem:i]graphExpression]];
        }
        ThemeGraphItem* item=[[ThemeGraphItem alloc] init];
        NSString* caption=[self getCaption:graphExpression];
        [item setGraphExpression:graphExpression];
        [item setCaption:caption];
        
        if(![self itemExist:item existItems:existItems]){
            [themeGraph insert:themeGraph.getCount item:item];
        }
        int num=themeGraph.getCount-1;
        if(num>=colors.getCount){
            num = num % colors.getCount;
        }
        [[[themeGraph getItem:themeGraph.getCount-1] uniformStyle] setFillForeColor:[colors get:num]];
        
        isSuccess=YES;
        return isSuccess;
    }
    @catch(NSException *exception){
        @throw exception;
    }
}

+(NSString*)getGeoCoordSysType:(GeoCoordSysType) type{
    //TODO  这个类型枚举较长，解析代码后面再补
    return @"";
}
+(NSString*)getPrjCoordSysType:(PrjCoordSysType) type{
    //TODO  这个类型枚举较长，解析代码后面再补
    return @"";
}

+(LabelBackShape)getLabelBackShape:(NSString*) shape{
    if ([shape isEqualToString:@"DIAMOND"]) {
        return LAB_DIAMOND;
    }
    if ([shape isEqualToString:@"ELLIPSE"]) {
        return LAB_ELLIPSE;
    }
    if ([shape isEqualToString:@"MARKER"]) {
        return LAB_MARKER;
    }
    if ([shape isEqualToString:@"NONE"]) {
        return LAB_NONE;
    }
    if ([shape isEqualToString:@"RECT"]) {
        return LAB_RECT;
    }
    if ([shape isEqualToString:@"ROUNDRECT"]) {
        return LAB_ROUNDRECT;
    }
    if ([shape isEqualToString:@"TRIANGLE"]) {
        return LAB_TRIANGLE;
    }
    return LAB_NONE;
}

+(NSString*)getLabelBackShapeString:(LabelBackShape) shape{
    if (shape == LAB_DIAMOND) {
        return @"DIAMOND";
    }
    if (shape == LAB_ELLIPSE) {
        return @"ELLIPSE";
    }
    if (shape == LAB_MARKER) {
        return @"MARKER";
    }
    if (shape == LAB_NONE) {
        return @"NONE";
    }
    if (shape == LAB_RECT) {
        return @"RECT";
    }
    if (shape == LAB_ROUNDRECT) {
        return @"ROUNDRECT";
    }
    if (shape == LAB_TRIANGLE) {
        return @"TRIANGLE";
    }
    return nil;
}

+(NSArray*)getColorList{
    NSArray *array = [[NSArray alloc] initWithObjects:@"#000000",@"#424242",@"#757575",@"#BDBDBD",@"#EEEEEE",@"#FFFFFF",@"#3E2723",@"#5D4037",@"#A1887F",@"#D7CCC8",@"#263238",@"#546E7A",@"#90A4AE",@"#CFD8DC",@"#FFECB3",@"#FFF9C4",@"#F1F8E9",@"#E3F2FD",@"#EDE7F6",@"#FCE4EC",@"#FBE9E7",@"#004D40",@"#006064",@"#009688",@"#8BC34A",@"#A5D6A7",@"#80CBC4",@"#80DEEA",@"#A1C2FA",@"#9FA8DA",@"#01579B",@"#1A237E",@"#3F51B5",@"#03A9F4",@"#4A148C",@"#673AB7",@"#9C27B0",@"#880E4F",@"#E91E63",@"#F44336",@"#F48FB1",@"#EF9A9A",@"#F57F17",@"#F4B400",@"#FADA80",@"#FFF59D",@"#FFEB3B"];
    return array;
}

NSMutableDictionary* colorRangeDic = nil;
 NSMutableDictionary* colorUniqueDic = nil;
NSMutableDictionary* colorGraphDic = nil;

+(NSArray*)getRangeColors:(NSString* )colorType{
    if (colorRangeDic == nil) {
        colorRangeDic = [[NSMutableDictionary alloc] init];

        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:255 G:242 B:230];
            Color* color2 = [[Color alloc]initWithR:255 G:203 B:153];
            Color* color3 = [[Color alloc]initWithR:255 G:140 B:25];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [colorRangeDic setValue:array forKey:@"CA_Oranges"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:255 G:230 B:217];
            Color* color2 = [[Color alloc]initWithR:255 G:144 B:112];
            Color* color3 = [[Color alloc]initWithR:223 G:39 B:36];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [colorRangeDic setValue:array forKey:@"CB_Reds"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:255 G:255 B:230];
            Color* color2 = [[Color alloc]initWithR:255 G:255 B:153];
            Color* color3 = [[Color alloc]initWithR:230 G:255 B:51];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [colorRangeDic setValue:array forKey:@"CC_Lemons"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:229 G:255 B:237];
            Color* color2 = [[Color alloc]initWithR:153 G:255 B:187];
            Color* color3 = [[Color alloc]initWithR:0 G:217 B:152];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [colorRangeDic setValue:array forKey:@"CD_Cyans"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:229 G:245 B:225];
            Color* color2 = [[Color alloc]initWithR:161 G:217 B:156];
            Color* color3 = [[Color alloc]initWithR:48 G:163 B:85];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [colorRangeDic setValue:array forKey:@"CE_Greens"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:223 G:236 B:247];
            Color* color2 = [[Color alloc]initWithR:159 G:202 B:225];
            Color* color3 = [[Color alloc]initWithR:48 G:130 B:189];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [colorRangeDic setValue:array forKey:@"CF_Blues"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:240 G:238 B:245];
            Color* color2 = [[Color alloc]initWithR:188 G:189 B:221];
            Color* color3 = [[Color alloc]initWithR:117 G:106 B:177];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [colorRangeDic setValue:array forKey:@"CG_Purples"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:255 G:242 B:230];
            Color* color2 = [[Color alloc]initWithR:255 G:216 B:178];
            Color* color3 = [[Color alloc]initWithR:223 G:178 B:102];
            Color* color4 = [[Color alloc]initWithR:227 G:108 B:9];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [colorRangeDic setValue:array forKey:@"DA_Oranges"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:254 G:229 B:217];
            Color* color2 = [[Color alloc]initWithR:253 G:174 B:144];
            Color* color3 = [[Color alloc]initWithR:252 G:105 B:75];
            Color* color4 = [[Color alloc]initWithR:216 G:43 B:48];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [colorRangeDic setValue:array forKey:@"DB_Reds"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:255 G:255 B:230];
            Color* color2 = [[Color alloc]initWithR:255 G:255 B:178];
            Color* color3 = [[Color alloc]initWithR:255 G:255 B:127];
            Color* color4 = [[Color alloc]initWithR:229 G:43 B:50];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [colorRangeDic setValue:array forKey:@"DC_Lemons"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:222 G:247 B:232];
            Color* color2 = [[Color alloc]initWithR:149 G:252 B:189];
            Color* color3 = [[Color alloc]initWithR:79 G:247 B:177];
            Color* color4 = [[Color alloc]initWithR:0 G:217 B:152];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [colorRangeDic setValue:array forKey:@"DD_Cyans"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:223 G:236 B:247];
            Color* color2 = [[Color alloc]initWithR:159 G:202 B:225];
            Color* color3 = [[Color alloc]initWithR:95 G:161 B:204];
            Color* color4 = [[Color alloc]initWithR:48 G:130 B:189];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [colorRangeDic setValue:array forKey:@"DF_Blues"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:242 G:241 B:247];
            Color* color2 = [[Color alloc]initWithR:203 G:202 B:226];
            Color* color3 = [[Color alloc]initWithR:159 G:154 B:201];
            Color* color4 = [[Color alloc]initWithR:105 G:81 B:163];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [colorRangeDic setValue:array forKey:@"DG_Purples"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:254 G:238 B:223];
            Color* color2 = [[Color alloc]initWithR:253 G:190 B:134];
            Color* color3 = [[Color alloc]initWithR:253 G:154 B:86];
            Color* color4 = [[Color alloc]initWithR:239 G:107 B:28];
            Color* color5 = [[Color alloc]initWithR:230 G:85 B:7];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [colorRangeDic setValue:array forKey:@"EA_Oranges"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:254 G:229 B:217];
            Color* color2 = [[Color alloc]initWithR:253 G:174 B:144];
            Color* color3 = [[Color alloc]initWithR:252 G:126 B:100];
            Color* color4 = [[Color alloc]initWithR:233 G:71 B:55];
            Color* color5 = [[Color alloc]initWithR:216 G:43 B:48];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [colorRangeDic setValue:array forKey:@"EB_Reds"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:255 G:255 B:230];
            Color* color2 = [[Color alloc]initWithR:255 G:255 B:196];
            Color* color3 = [[Color alloc]initWithR:255 G:255 B:153];
            Color* color4 = [[Color alloc]initWithR:249 G:255 B:111];
            Color* color5 = [[Color alloc]initWithR:229 G:255 B:50];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [colorRangeDic setValue:array forKey:@"EC_Lemons"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:222 G:247 B:232];
            Color* color2 = [[Color alloc]initWithR:163 G:252 B:198];
            Color* color3 = [[Color alloc]initWithR:103 G:247 B:187];
            Color* color4 = [[Color alloc]initWithR:31 G:229 B:162];
            Color* color5 = [[Color alloc]initWithR:10 G:216 B:164];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [colorRangeDic setValue:array forKey:@"ED_Cyans"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:238 G:248 B:233];
            Color* color2 = [[Color alloc]initWithR:186 G:228 B:180];
            Color* color3 = [[Color alloc]initWithR:116 G:196 B:118];
            Color* color4 = [[Color alloc]initWithR:53 G:165 B:89];
            Color* color5 = [[Color alloc]initWithR:41 G:140 B:77];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [colorRangeDic setValue:array forKey:@"EE_Greens"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:240 G:243 B:255];
            Color* color2 = [[Color alloc]initWithR:189 G:215 B:231];
            Color* color3 = [[Color alloc]initWithR:106 G:174 B:214];
            Color* color4 = [[Color alloc]initWithR:48 G:130 B:189];
            Color* color5 = [[Color alloc]initWithR:15 G:88 B:163];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [colorRangeDic setValue:array forKey:@"EF_Blues"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:242 G:241 B:247];
            Color* color2 = [[Color alloc]initWithR:203 G:202 B:226];
            Color* color3 = [[Color alloc]initWithR:157 G:152 B:198];
            Color* color4 = [[Color alloc]initWithR:131 G:116 B:181];
            Color* color5 = [[Color alloc]initWithR:105 G:81 B:163];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [colorRangeDic setValue:array forKey:@"EG_Purples"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:254 G:238 B:223];
            Color* color2 = [[Color alloc]initWithR:253 G:190 B:134];
            Color* color3 = [[Color alloc]initWithR:253 G:154 B:86];
            Color* color4 = [[Color alloc]initWithR:239 G:107 B:28];
            Color* color5 = [[Color alloc]initWithR:230 G:85 B:7];
            Color* color6 = [[Color alloc]initWithR:219 G:72 B:0];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [array addObject:color6];
            [colorRangeDic setValue:array forKey:@"FA_Oranges"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:254 G:229 B:217];
            Color* color2 = [[Color alloc]initWithR:253 G:174 B:144];
            Color* color3 = [[Color alloc]initWithR:252 G:126 B:100];
            Color* color4 = [[Color alloc]initWithR:233 G:71 B:55];
            Color* color5 = [[Color alloc]initWithR:216 G:43 B:48];
            Color* color6 = [[Color alloc]initWithR:204 G:36 B:40];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [array addObject:color6];
            [colorRangeDic setValue:array forKey:@"FB_Reds"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:255 G:255 B:230];
            Color* color2 = [[Color alloc]initWithR:255 G:255 B:196];
            Color* color3 = [[Color alloc]initWithR:255 G:255 B:153];
            Color* color4 = [[Color alloc]initWithR:249 G:255 B:111];
            Color* color5 = [[Color alloc]initWithR:229 G:255 B:50];
            Color* color6 = [[Color alloc]initWithR:216 G:255 B:0];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [array addObject:color6];
            [colorRangeDic setValue:array forKey:@"FC_Lemons"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:222 G:247 B:232];
            Color* color2 = [[Color alloc]initWithR:163 G:252 B:198];
            Color* color3 = [[Color alloc]initWithR:103 G:247 B:187];
            Color* color4 = [[Color alloc]initWithR:31 G:229 B:162];
            Color* color5 = [[Color alloc]initWithR:10 G:216 B:164];
            Color* color6 = [[Color alloc]initWithR:2 G:198 B:156];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [array addObject:color6];
            [colorRangeDic setValue:array forKey:@"FD_Cyans"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:238 G:248 B:233];
            Color* color2 = [[Color alloc]initWithR:186 G:228 B:180];
            Color* color3 = [[Color alloc]initWithR:116 G:196 B:118];
            Color* color4 = [[Color alloc]initWithR:48 G:163 B:85];
            Color* color5 = [[Color alloc]initWithR:6 G:127 B:50];
            Color* color6 = [[Color alloc]initWithR:3 G:114 B:58];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [array addObject:color6];
            [colorRangeDic setValue:array forKey:@"FE_Greens"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:240 G:243 B:255];
            Color* color2 = [[Color alloc]initWithR:189 G:215 B:231];
            Color* color3 = [[Color alloc]initWithR:106 G:174 B:214];
            Color* color4 = [[Color alloc]initWithR:48 G:130 B:189];
            Color* color5 = [[Color alloc]initWithR:7 G:89 B:173];
            Color* color6 = [[Color alloc]initWithR:5 G:67 B:158];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [array addObject:color6];
            [colorRangeDic setValue:array forKey:@"FF_Blues"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:242 G:241 B:247];
            Color* color2 = [[Color alloc]initWithR:203 G:202 B:226];
            Color* color3 = [[Color alloc]initWithR:157 G:152 B:198];
            Color* color4 = [[Color alloc]initWithR:131 G:116 B:181];
            Color* color5 = [[Color alloc]initWithR:105 G:81 B:163];
            Color* color6 = [[Color alloc]initWithR:89 G:58 B:153];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [array addObject:color6];
            [colorRangeDic setValue:array forKey:@"FG_Purples"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:255 G:254 B:102];
            Color* color2 = [[Color alloc]initWithR:255 G:119 B:51];
            [array addObject:color1];
            [array addObject:color2];
            [colorRangeDic setValue:array forKey:@"GA_Yellow to Orange"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:250 G:204 B:137];
            Color* color2 = [[Color alloc]initWithR:204 G:40 B:40];
            [array addObject:color1];
            [array addObject:color2];
            [colorRangeDic setValue:array forKey:@"GB_Orange to Red"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:75 G:172 B:198];
            Color* color2 = [[Color alloc]initWithR:255 G:255 B:255];
            Color* color3 = [[Color alloc]initWithR:178 G:162 B:199];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [colorRangeDic setValue:array forKey:@"GC_Olive to Purple"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:127 G:194 B:105];
            Color* color2 = [[Color alloc]initWithR:255 G:255 B:255];
            Color* color3 = [[Color alloc]initWithR:247 G:150 B:70];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [colorRangeDic setValue:array forKey:@"GD_Green to Orange"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:146 G:255 B:220];
            Color* color2 = [[Color alloc]initWithR:255 G:255 B:255];
            Color* color3 = [[Color alloc]initWithR:255 G:255 B:0];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [colorRangeDic setValue:array forKey:@"GE_Blue to Lemon"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:255 G:255 B:255];
            Color* color2 = [[Color alloc]initWithR:253 G:225 B:255];
            Color* color3 = [[Color alloc]initWithR:242 G:195 B:255];
            Color* color4 = [[Color alloc]initWithR:236 G:175 B:255];
            Color* color5 = [[Color alloc]initWithR:229 G:156 B:255];
            Color* color6 = [[Color alloc]initWithR:222 G:136 B:255];
            
            Color* color7 = [[Color alloc]initWithR:216 G:117 B:255];
            Color* color8 = [[Color alloc]initWithR:209 G:97 B:255];
            Color* color9 = [[Color alloc]initWithR:188 G:88 B:255];
            Color* color10 = [[Color alloc]initWithR:139 G:100 B:255];
            Color* color11 = [[Color alloc]initWithR:114 G:107 B:255];
            Color* color12 = [[Color alloc]initWithR:66 G:157 B:244];
            
            Color* color13 = [[Color alloc]initWithR:51 G:217 B:226];
            Color* color14 = [[Color alloc]initWithR:53 G:236 B:176];
            Color* color15 = [[Color alloc]initWithR:134 G:221 B:25];
            Color* color16 = [[Color alloc]initWithR:185 G:234 B:21];
            Color* color17 = [[Color alloc]initWithR:244 G:249 B:22];
            Color* color18 = [[Color alloc]initWithR:244 G:203 B:24];
            
            Color* color19 = [[Color alloc]initWithR:243 G:156 B:25];
            Color* color20 = [[Color alloc]initWithR:241 G:108 B:26];
            Color* color21 = [[Color alloc]initWithR:240 G:62 B:27];
            Color* color22 = [[Color alloc]initWithR:224 G:33 B:32];
            Color* color23 = [[Color alloc]initWithR:193 G:24 B:41];
            Color* color24 = [[Color alloc]initWithR:178 G:20 B:46];
            
            Color* color25 = [[Color alloc]initWithR:131 G:7 B:60];
            Color* color26 = [[Color alloc]initWithR:110 G:0 B:78];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [array addObject:color6];
            
            [array addObject:color7];
            [array addObject:color8];
            [array addObject:color9];
            [array addObject:color10];
            [array addObject:color11];
            [array addObject:color12];
            
            [array addObject:color13];
            [array addObject:color14];
            [array addObject:color15];
            [array addObject:color16];
            [array addObject:color17];
            [array addObject:color18];
            
            [array addObject:color19];
            [array addObject:color20];
            [array addObject:color21];
            [array addObject:color22];
            [array addObject:color23];
            [array addObject:color24];
            
            [array addObject:color25];
            [array addObject:color26];
            [colorRangeDic setValue:array forKey:@"ZA_Temperature 1"];
        }
        
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:28 G:12 B:204];
            Color* color2 = [[Color alloc]initWithR:40 G:25 B:204];
            Color* color3 = [[Color alloc]initWithR:34 G:77 B:244];
            Color* color4 = [[Color alloc]initWithR:51 G:119 B:230];
            Color* color5 = [[Color alloc]initWithR:107 G:174 B:217];
            Color* color6 = [[Color alloc]initWithR:122 G:222 B:238];
            
            Color* color7 = [[Color alloc]initWithR:204 G:255 B:240];
            Color* color8 = [[Color alloc]initWithR:255 G:246 B:172];
            Color* color9 = [[Color alloc]initWithR:252 G:230 B:121];
            Color* color10 = [[Color alloc]initWithR:250 G:222 B:53];
            Color* color11 = [[Color alloc]initWithR:251 G:183 B:46];
            Color* color12 = [[Color alloc]initWithR:255 G:161 B:47];
            
            Color* color13 = [[Color alloc]initWithR:230 G:112 B:2];
            Color* color14 = [[Color alloc]initWithR:255 G:85 B:1];

            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [array addObject:color6];
            
            [array addObject:color7];
            [array addObject:color8];
            [array addObject:color9];
            [array addObject:color10];
            [array addObject:color11];
            [array addObject:color12];
            
            [array addObject:color13];
            [array addObject:color14];
            [colorRangeDic setValue:array forKey:@"ZB_Temperature 2"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:255 G:255 B:216];
            Color* color2 = [[Color alloc]initWithR:255 G:204 B:153];
            Color* color3 = [[Color alloc]initWithR:255 G:153 B:51];
            Color* color4 = [[Color alloc]initWithR:204 G:51 B:0];
            Color* color5 = [[Color alloc]initWithR:153 G:0 B:0];
     
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [colorRangeDic setValue:array forKey:@"ZC_Temperature 3"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:112 G:229 B:236];
            Color* color2 = [[Color alloc]initWithR:217 G:255 B:255];
            Color* color3 = [[Color alloc]initWithR:252 G:255 B:174];
            Color* color4 = [[Color alloc]initWithR:255 G:255 B:1];
            Color* color5 = [[Color alloc]initWithR:250 G:113 B:0];
            Color* color6 = [[Color alloc]initWithR:184 G:103 B:48];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [array addObject:color6];
            [colorRangeDic setValue:array forKey:@"ZD_Temperature 4"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:255 G:62 B:0];
            Color* color2 = [[Color alloc]initWithR:255 G:93 B:0];
            Color* color3 = [[Color alloc]initWithR:255 G:124 B:0];
            Color* color4 = [[Color alloc]initWithR:255 G:155 B:0];
            Color* color5 = [[Color alloc]initWithR:255 G:185 B:0];
            Color* color6 = [[Color alloc]initWithR:255 G:216 B:0];
            
            Color* color7 = [[Color alloc]initWithR:255 G:247 B:0];
            Color* color8 = [[Color alloc]initWithR:232 G:255 B:23];
            Color* color9 = [[Color alloc]initWithR:201 G:255 B:54];
            Color* color10 = [[Color alloc]initWithR:170 G:255 B:85];
            Color* color11 = [[Color alloc]initWithR:139 G:255 B:116];
            Color* color12 = [[Color alloc]initWithR:108 G:255 B:147];
            
            Color* color13 = [[Color alloc]initWithR:77 G:255 B:178];
            Color* color14 = [[Color alloc]initWithR:46 G:255 B:209];
            Color* color15 = [[Color alloc]initWithR:15 G:255 B:240];
            Color* color16 = [[Color alloc]initWithR:0 G:248 B:255];
            Color* color17 = [[Color alloc]initWithR:0 G:233 B:255];
            Color* color18 = [[Color alloc]initWithR:0 G:219 B:255];
            
            Color* color19 = [[Color alloc]initWithR:0 G:204 B:255];
            Color* color20 = [[Color alloc]initWithR:0 G:190 B:255];
            Color* color21 = [[Color alloc]initWithR:0 G:175 B:255];
            Color* color22 = [[Color alloc]initWithR:0 G:160 B:255];
            Color* color23 = [[Color alloc]initWithR:0 G:146 B:255];
            Color* color24 = [[Color alloc]initWithR:0 G:131 B:255];
            
            Color* color25 = [[Color alloc]initWithR:0 G:115 B:255];
            Color* color26 = [[Color alloc]initWithR:0 G:98 B:255];
            Color* color27 = [[Color alloc]initWithR:0 G:82 B:255];
            Color* color28 = [[Color alloc]initWithR:0 G:65 B:255];
            Color* color29 = [[Color alloc]initWithR:0 G:49 B:255];
            Color* color30 = [[Color alloc]initWithR:0 G:33 B:255];
            Color* color31 = [[Color alloc]initWithR:0 G:16 B:255];
            Color* color32 = [[Color alloc]initWithR:0 G:0 B:255];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [array addObject:color6];
            
            [array addObject:color7];
            [array addObject:color8];
            [array addObject:color9];
            [array addObject:color10];
            [array addObject:color11];
            [array addObject:color12];
            
            [array addObject:color13];
            [array addObject:color14];
            [array addObject:color15];
            [array addObject:color16];
            [array addObject:color17];
            [array addObject:color18];
            
            [array addObject:color19];
            [array addObject:color20];
            [array addObject:color21];
            [array addObject:color22];
            [array addObject:color23];
            [array addObject:color24];
            
            [array addObject:color25];
            [array addObject:color26];
            [array addObject:color27];
            [array addObject:color28];
            [array addObject:color29];
            [array addObject:color30];
            [array addObject:color31];
            [array addObject:color32];
            [colorRangeDic setValue:array forKey:@"ZE_Precipitation 1"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:246 G:151 B:107];
            Color* color2 = [[Color alloc]initWithR:247 G:192 B:143];
            Color* color3 = [[Color alloc]initWithR:252 G:228 B:179];
            Color* color4 = [[Color alloc]initWithR:167 G:219 B:212];
            Color* color5 = [[Color alloc]initWithR:92 G:182 B:229];
            Color* color6 = [[Color alloc]initWithR:4 G:155 B:224];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [array addObject:color6];
            [colorRangeDic setValue:array forKey:@"ZF_Precipitation 2"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:253 G:253 B:227];
            Color* color2 = [[Color alloc]initWithR:204 G:251 B:219];
            Color* color3 = [[Color alloc]initWithR:171 G:247 B:235];
            Color* color4 = [[Color alloc]initWithR:116 G:225 B:232];
            Color* color5 = [[Color alloc]initWithR:108 G:198 B:235];
            Color* color6 = [[Color alloc]initWithR:78 G:178 B:29];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [array addObject:color6];
            [colorRangeDic setValue:array forKey:@"ZG_Precipitation 3"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:252 G:75 B:45];
            Color* color2 = [[Color alloc]initWithR:253 G:118 B:52];
            Color* color3 = [[Color alloc]initWithR:252 G:154 B:38];
            Color* color4 = [[Color alloc]initWithR:248 G:205 B:89];
            Color* color5 = [[Color alloc]initWithR:250 G:235 B:110];
            Color* color6 = [[Color alloc]initWithR:238 G:251 B:132];
            
            Color* color7 = [[Color alloc]initWithR:197 G:248 B:136];
            Color* color8 = [[Color alloc]initWithR:168 G:247 B:155];
            Color* color9 = [[Color alloc]initWithR:139 G:250 B:189];
            Color* color10 = [[Color alloc]initWithR:107 G:249 B:172];
            Color* color11 = [[Color alloc]initWithR:75 G:229 B:146];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [array addObject:color6];
            
            [array addObject:color7];
            [array addObject:color8];
            [array addObject:color9];
            [array addObject:color10];
            [array addObject:color11];
            [colorRangeDic setValue:array forKey:@"ZH_Precipitation 4"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:106 G:247 B:0];
            Color* color2 = [[Color alloc]initWithR:99 G:254 B:0];
            Color* color3 = [[Color alloc]initWithR:132 G:255 B:0];
            Color* color4 = [[Color alloc]initWithR:144 G:255 B:0];
            Color* color5 = [[Color alloc]initWithR:172 G:252 B:3];
            Color* color6 = [[Color alloc]initWithR:191 G:255 B:0];
            
            Color* color7 = [[Color alloc]initWithR:210 G:255 B:0];
            Color* color8 = [[Color alloc]initWithR:224 G:254 B:0];
            Color* color9 = [[Color alloc]initWithR:247 G:245 B:2];
            Color* color10 = [[Color alloc]initWithR:255 G:246 B:0];
            Color* color11 = [[Color alloc]initWithR:255 G:236 B:31];
            Color* color12 = [[Color alloc]initWithR:255 G:222 B:1];
            
            Color* color13 = [[Color alloc]initWithR:248 G:209 B:0];
            Color* color14 = [[Color alloc]initWithR:255 G:202 B:2];
            Color* color15 = [[Color alloc]initWithR:255 G:193 B:0];
            Color* color16 = [[Color alloc]initWithR:249 G:176 B:0];
            Color* color17 = [[Color alloc]initWithR:255 G:169 B:0];
            Color* color18 = [[Color alloc]initWithR:252 G:159 B:0];
            
            Color* color19 = [[Color alloc]initWithR:249 G:153 B:0];
            Color* color20 = [[Color alloc]initWithR:255 G:140 B:0];
            Color* color21 = [[Color alloc]initWithR:248 G:136 B:26];
            Color* color22 = [[Color alloc]initWithR:255 G:112 B:1];
            Color* color23 = [[Color alloc]initWithR:255 G:112 B:9];
            Color* color24 = [[Color alloc]initWithR:255 G:92 B:13];
            
            Color* color25 = [[Color alloc]initWithR:250 G:89 B:0];
            Color* color26 = [[Color alloc]initWithR:255 G:75 B:4];
            Color* color27 = [[Color alloc]initWithR:250 G:57 B:0];
            Color* color28 = [[Color alloc]initWithR:255 G:48 B:0];
            Color* color29 = [[Color alloc]initWithR:255 G:44 B:0];
            Color* color30 = [[Color alloc]initWithR:246 G:33 B:0];
            Color* color31 = [[Color alloc]initWithR:247 G:27 B:3];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [array addObject:color6];
            
            [array addObject:color7];
            [array addObject:color8];
            [array addObject:color9];
            [array addObject:color10];
            [array addObject:color11];
            [array addObject:color12];
            
            [array addObject:color13];
            [array addObject:color14];
            [array addObject:color15];
            [array addObject:color16];
            [array addObject:color17];
            [array addObject:color18];
            
            [array addObject:color19];
            [array addObject:color20];
            [array addObject:color21];
            [array addObject:color22];
            [array addObject:color23];
            [array addObject:color24];
            
            [array addObject:color25];
            [array addObject:color26];
            [array addObject:color27];
            [array addObject:color28];
            [array addObject:color29];
            [array addObject:color30];
            [array addObject:color31];
            [colorRangeDic setValue:array forKey:@"ZI_Altitude 1"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:250 G:248 B:251];
            Color* color2 = [[Color alloc]initWithR:203 G:203 B:203];
            Color* color3 = [[Color alloc]initWithR:161 G:147 B:134];
            Color* color4 = [[Color alloc]initWithR:123 G:74 B:42];
            Color* color5 = [[Color alloc]initWithR:111 G:37 B:12];
            Color* color6 = [[Color alloc]initWithR:123 G:13 B:0];
            
            Color* color7 = [[Color alloc]initWithR:188 G:70 B:9];
            Color* color8 = [[Color alloc]initWithR:227 G:183 B:22];
            Color* color9 = [[Color alloc]initWithR:99 G:147 B:63];
            Color* color10 = [[Color alloc]initWithR:23 G:158 B:55];
            Color* color11 = [[Color alloc]initWithR:214 G:235 B:132];
            Color* color12 = [[Color alloc]initWithR:192 G:245 B:177];
            
            Color* color13 = [[Color alloc]initWithR:175 G:243 B:232];
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [array addObject:color6];
            
            [array addObject:color7];
            [array addObject:color8];
            [array addObject:color9];
            [array addObject:color10];
            [array addObject:color11];
            [array addObject:color12];
            
            [array addObject:color13];
            [colorRangeDic setValue:array forKey:@"ZJ_Altitude 2"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:155 G:228 B:248];
            Color* color2 = [[Color alloc]initWithR:252 G:252 B:248];
            Color* color3 = [[Color alloc]initWithR:251 G:194 B:98];
            Color* color4 = [[Color alloc]initWithR:174 G:163 B:128];
            Color* color5 = [[Color alloc]initWithR:130 G:107 B:109];

            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [colorRangeDic setValue:array forKey:@"ZK_Altitude 3"];
        }
    }
    return [colorRangeDic objectForKey:colorType];
        
}

+(NSArray*)getUniqueColors:(NSString* )colorType{
    if (colorUniqueDic == nil) {
        colorUniqueDic = [[NSMutableDictionary alloc]init];

        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:191 G:217 B:242];
            Color* color2 = [[Color alloc]initWithR:128 G:179 B:230];
            [array addObject:color1];
            [array addObject:color2];
            [colorUniqueDic setValue:array forKey:@"BA_Blue"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:204 G:255 B:204];
            Color* color2 = [[Color alloc]initWithR:127 G:229 B:127];
            [array addObject:color1];
            [array addObject:color2];
            [colorUniqueDic setValue:array forKey:@"BB_Green"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:255 G:239 B:204];
            Color* color2 = [[Color alloc]initWithR:255 G:222 B:153];
            [array addObject:color1];
            [array addObject:color2];
            [colorUniqueDic setValue:array forKey:@"BC_Orange"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:255 G:224 B:203];
            Color* color2 = [[Color alloc]initWithR:242 G:185 B:145];
            [array addObject:color1];
            [array addObject:color2];
            [colorUniqueDic setValue:array forKey:@"BD_Pink"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:255 G:244 B:91];
            Color* color2 = [[Color alloc]initWithR:252 G:216 B:219];
            Color* color3 = [[Color alloc]initWithR:129 G:195 B:231];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [colorUniqueDic setValue:array forKey:@"CA_Red Rose"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:245 G:255 B:166];
            Color* color2 = [[Color alloc]initWithR:121 G:232 B:208];
            Color* color3 = [[Color alloc]initWithR:255 G:251 B:0];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [colorUniqueDic setValue:array forKey:@"CB_Blue and Yellow"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:255 G:204 B:178];
            Color* color2 = [[Color alloc]initWithR:255 G:255 B:204];
            Color* color3 = [[Color alloc]initWithR:153 G:204 B:153];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [colorUniqueDic setValue:array forKey:@"CC_Pink and Green"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:204 G:255 B:204];
            Color* color2 = [[Color alloc]initWithR:255 G:255 B:204];
            Color* color3 = [[Color alloc]initWithR:204 G:255 B:255];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [colorUniqueDic setValue:array forKey:@"CD_Fresh"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:254 G:224 B:236];
            Color* color2 = [[Color alloc]initWithR:255 G:253 B:228];
            Color* color3 = [[Color alloc]initWithR:194 G:229 B:252];
            Color* color4 = [[Color alloc]initWithR:166 G:255 B:166];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [colorUniqueDic setValue:array forKey:@"DA_Ragular"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:221 G:168 B:202];
            Color* color2 = [[Color alloc]initWithR:253 G:253 B:176];
            Color* color3 = [[Color alloc]initWithR:197 G:228 B:189];
            Color* color4 = [[Color alloc]initWithR:245 G:198 B:144];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [colorUniqueDic setValue:array forKey:@"DB_Common"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:122 G:203 B:203];
            Color* color2 = [[Color alloc]initWithR:245 G:245 B:110];
            Color* color3 = [[Color alloc]initWithR:183 G:229 B:193];
            Color* color4 = [[Color alloc]initWithR:254 G:250 B:177];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [colorUniqueDic setValue:array forKey:@"DC_Bright"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:237 G:156 B:156];
            Color* color2 = [[Color alloc]initWithR:255 G:251 B:154];
            Color* color3 = [[Color alloc]initWithR:244 G:191 B:122];
            Color* color4 = [[Color alloc]initWithR:226 G:201 B:220];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [colorUniqueDic setValue:array forKey:@"DD_Warm"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:140 G:211 B:200];
            Color* color2 = [[Color alloc]initWithR:255 G:255 B:180];
            Color* color3 = [[Color alloc]initWithR:190 G:186 B:218];
            Color* color4 = [[Color alloc]initWithR:252 G:128 B:114];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [colorUniqueDic setValue:array forKey:@"DE_Set"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:180 G:226 B:206];
            Color* color2 = [[Color alloc]initWithR:253 G:206 B:172];
            Color* color3 = [[Color alloc]initWithR:203 G:213 B:232];
            Color* color4 = [[Color alloc]initWithR:245 G:202 B:228];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [colorUniqueDic setValue:array forKey:@"DF_Pastel"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:162 G:205 B:247];
            Color* color2 = [[Color alloc]initWithR:160 G:239 B:158];
            Color* color3 = [[Color alloc]initWithR:255 G:252 B:240];
            Color* color4 = [[Color alloc]initWithR:255 G:255 B:195];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [colorUniqueDic setValue:array forKey:@"DG_Grass"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:179 G:255 B:255];
            Color* color2 = [[Color alloc]initWithR:255 G:204 B:255];
            Color* color3 = [[Color alloc]initWithR:255 G:255 B:204];
            Color* color4 = [[Color alloc]initWithR:204 G:204 B:255];
            Color* color5 = [[Color alloc]initWithR:204 G:255 B:179];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [colorUniqueDic setValue:array forKey:@"EA_Sin_ColorScheme8"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:241 G:176 B:160];
            Color* color2 = [[Color alloc]initWithR:245 G:245 B:191];
            Color* color3 = [[Color alloc]initWithR:185 G:219 B:65];
            Color* color4 = [[Color alloc]initWithR:192 G:232 B:207];
            Color* color5 = [[Color alloc]initWithR:251 G:213 B:181];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [colorUniqueDic setValue:array forKey:@"EB_Sweet"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:254 G:203 B:163];
            Color* color2 = [[Color alloc]initWithR:229 G:155 B:18];
            Color* color3 = [[Color alloc]initWithR:234 G:226 B:27];
            Color* color4 = [[Color alloc]initWithR:177 G:210 B:34];
            Color* color5 = [[Color alloc]initWithR:205 G:238 B:204];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [colorUniqueDic setValue:array forKey:@"EC_Dusk"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:180 G:226 B:206];
            Color* color2 = [[Color alloc]initWithR:253 G:206 B:172];
            Color* color3 = [[Color alloc]initWithR:203 G:213 B:232];
            Color* color4 = [[Color alloc]initWithR:245 G:202 B:228];
            Color* color5 = [[Color alloc]initWithR:230 G:245 B:202];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [colorUniqueDic setValue:array forKey:@"ED_Pastel"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:103 G:205 B:227];
            Color* color2 = [[Color alloc]initWithR:165 G:226 B:228];
            Color* color3 = [[Color alloc]initWithR:99 G:192 B:190];
            Color* color4 = [[Color alloc]initWithR:183 G:229 B:193];
            Color* color5 = [[Color alloc]initWithR:102 G:201 B:147];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [colorUniqueDic setValue:array forKey:@"EE_Lake"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:254 G:242 B:0];
            Color* color2 = [[Color alloc]initWithR:104 G:189 B:178];
            Color* color3 = [[Color alloc]initWithR:185 G:219 B:65];
            Color* color4 = [[Color alloc]initWithR:206 G:232 B:142];
            Color* color5 = [[Color alloc]initWithR:29 G:151 B:121];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [colorUniqueDic setValue:array forKey:@"EF_Grass"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:255 G:251 B:178];
            Color* color2 = [[Color alloc]initWithR:230 G:243 B:180];
            Color* color3 = [[Color alloc]initWithR:179 G:208 B:239];
            Color* color4 = [[Color alloc]initWithR:142 G:212 B:226];
            Color* color5 = [[Color alloc]initWithR:68 G:200 B:227];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [colorUniqueDic setValue:array forKey:@"EG_Sin_ColorScheme1"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:255 G:204 B:204];
            Color* color2 = [[Color alloc]initWithR:255 G:204 B:153];
            Color* color3 = [[Color alloc]initWithR:153 G:204 B:204];
            Color* color4 = [[Color alloc]initWithR:204 G:255 B:255];
            Color* color5 = [[Color alloc]initWithR:255 G:255 B:102];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [colorUniqueDic setValue:array forKey:@"EH_Sin_ColorScheme4"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:95 G:217 B:205];
            Color* color2 = [[Color alloc]initWithR:234 G:247 B:134];
            Color* color3 = [[Color alloc]initWithR:255 G:181 B:161];
            Color* color4 = [[Color alloc]initWithR:184 G:255 B:184];
            Color* color5 = [[Color alloc]initWithR:184 G:244 B:255];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [colorUniqueDic setValue:array forKey:@"EI_Sin_ColorScheme6"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:204 G:255 B:204];
            Color* color2 = [[Color alloc]initWithR:204 G:255 B:153];
            Color* color3 = [[Color alloc]initWithR:153 G:204 B:255];
            Color* color4 = [[Color alloc]initWithR:198 G:217 B:240];
            Color* color5 = [[Color alloc]initWithR:230 G:226 B:0];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [colorUniqueDic setValue:array forKey:@"EJ_Sin_ColorScheme7"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:165 G:0 B:36];
            Color* color2 = [[Color alloc]initWithR:215 G:48 B:36];
            Color* color3 = [[Color alloc]initWithR:245 G:107 B:69];
            Color* color4 = [[Color alloc]initWithR:253 G:174 B:96];
            Color* color5 = [[Color alloc]initWithR:254 G:225 B:143];
            Color* color6 = [[Color alloc]initWithR:255 G:255 B:191];
            
            Color* color7 = [[Color alloc]initWithR:225 G:243 B:248];
            Color* color8 = [[Color alloc]initWithR:171 G:217 B:233];
            Color* color9 = [[Color alloc]initWithR:116 G:172 B:209];
            Color* color10 = [[Color alloc]initWithR:71 G:117 B:181];
            Color* color11 = [[Color alloc]initWithR:48 G:55 B:149];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [array addObject:color6];
            
            [array addObject:color7];
            [array addObject:color8];
            [array addObject:color9];
            [array addObject:color10];
            [array addObject:color11];
            [colorUniqueDic setValue:array forKey:@"FA_Red-Yellow-Blue"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:48  G:55 B:149];
            Color* color2 = [[Color alloc]initWithR:71 G:117 B:181];
            Color* color3 = [[Color alloc]initWithR:116 G:172 B:209];
            Color* color4 = [[Color alloc]initWithR:171 G:217 B:233];
            Color* color5 = [[Color alloc]initWithR:255 G:243 B:248];
            Color* color6 = [[Color alloc]initWithR:255 G:255 B:191];
            
            Color* color7 = [[Color alloc]initWithR:254 G:225 B:143];
            Color* color8 = [[Color alloc]initWithR:253 G:174 B:96];
            Color* color9 = [[Color alloc]initWithR:245 G:107 B:69];
            Color* color10 = [[Color alloc]initWithR:215 G:48 B:36];
            Color* color11 = [[Color alloc]initWithR:165 G:0 B:36];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [array addObject:color6];
            
            [array addObject:color7];
            [array addObject:color8];
            [array addObject:color9];
            [array addObject:color10];
            [array addObject:color11];
            [colorUniqueDic setValue:array forKey:@"FA_Blue-Yellow-Red"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            Color* color1 = [[Color alloc]initWithR:165 G:0 B:36];
            Color* color2 = [[Color alloc]initWithR:213 G:64 B:79];
            Color* color3 = [[Color alloc]initWithR:245 G:107 B:69];
            Color* color4 = [[Color alloc]initWithR:253 G:174 B:96];
            Color* color5 = [[Color alloc]initWithR:254 G:225 B:138];
            Color* color6 = [[Color alloc]initWithR:255 G:255 B:191];
            
            Color* color7 = [[Color alloc]initWithR:217 G:240 B:138];
            Color* color8 = [[Color alloc]initWithR:166 G:217 B:105];
            Color* color9 = [[Color alloc]initWithR:102 G:189 B:99];
            Color* color10 = [[Color alloc]initWithR:25 G:153 B:81];
            Color* color11 = [[Color alloc]initWithR:0 G:103 B:55];
            
            [array addObject:color1];
            [array addObject:color2];
            [array addObject:color3];
            [array addObject:color4];
            [array addObject:color5];
            [array addObject:color6];
            
            [array addObject:color7];
            [array addObject:color8];
            [array addObject:color9];
            [array addObject:color10];
            [array addObject:color11];
            [colorUniqueDic setValue:array forKey:@"FB_Red-Yellow-Green"];
        }
    }
    return [colorUniqueDic objectForKey:colorType];
}

+(NSArray*)getGraphColors:(NSString* )colorType{
    if (colorGraphDic == nil) {
        colorGraphDic = [[NSMutableDictionary alloc]init];
        
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:255 G:244 B:91]];
            [array addObject:[[Color alloc]initWithR:252 G:216 B:219]];
            [array addObject:[[Color alloc]initWithR:129 G:195 B:231]];
            [colorGraphDic setValue:array forKey:@"CA_Red Rose"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:244 G:198 B:162]];
            [array addObject:[[Color alloc]initWithR:252 G:237 B:136]];
            [array addObject:[[Color alloc]initWithR:93 G:187 B:197]];
            [colorGraphDic setValue:array forKey:@"CB_Childish"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:235 G:241 B:221]];
            [array addObject:[[Color alloc]initWithR:121 G:232 B:208]];
            [array addObject:[[Color alloc]initWithR:255 G:251 B:0]];
            [colorGraphDic setValue:array forKey:@"CC_Blue-Yellow"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:183 G:221 B:200]];
            [array addObject:[[Color alloc]initWithR:87 G:150 B:204]];
            [array addObject:[[Color alloc]initWithR:149 G:208 B:222]];
            [colorGraphDic setValue:array forKey:@"CD_Concise"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:233 G:163 B:202]];
            [array addObject:[[Color alloc]initWithR:247 G:247 B:247]];
            [array addObject:[[Color alloc]initWithR:161 G:215 B:105]];
            [colorGraphDic setValue:array forKey:@"CE_Reposeful"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:253 G:140 B:90]];
            [array addObject:[[Color alloc]initWithR:255 G:255 B:191]];
            [array addObject:[[Color alloc]initWithR:144 G:207 B:96]];
            [colorGraphDic setValue:array forKey:@"CF_Home"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:182 G:162 B:222]];
            [array addObject:[[Color alloc]initWithR:46 G:199 B:201]];
            [array addObject:[[Color alloc]initWithR:90 G:177 B:239]];
            [colorGraphDic setValue:array forKey:@"CG_Cold"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:202 G:134 B:34]];
            [array addObject:[[Color alloc]initWithR:145 G:199 B:174]];
            [array addObject:[[Color alloc]initWithR:47 G:69 B:84]];
            [colorGraphDic setValue:array forKey:@"CH_Naive"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:176 G:220 B:233]];
            [array addObject:[[Color alloc]initWithR:228 G:226 B:103]];
            [array addObject:[[Color alloc]initWithR:236 G:80 B:94]];
            [array addObject:[[Color alloc]initWithR:172 G:229 B:194]];
            [colorGraphDic setValue:array forKey:@"DA_Limber"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:255 G:86 B:0]];
            [array addObject:[[Color alloc]initWithR:0 G:153 B:102]];
            [array addObject:[[Color alloc]initWithR:204 G:204 B:0]];
            [array addObject:[[Color alloc]initWithR:23 G:146 B:192]];
            [colorGraphDic setValue:array forKey:@"DB_Field"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:47 G:69 B:84]];
            [array addObject:[[Color alloc]initWithR:194 G:53 B:49]];
            [array addObject:[[Color alloc]initWithR:212 G:130 B:101]];
            [array addObject:[[Color alloc]initWithR:145 G:199 B:174]];
            [colorGraphDic setValue:array forKey:@"DC_Dressy"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:140 G:211 B:200]];
            [array addObject:[[Color alloc]initWithR:255 G:255 B:180]];
            [array addObject:[[Color alloc]initWithR:190 G:186 B:218]];
            [array addObject:[[Color alloc]initWithR:252 G:128 B:114]];
            [colorGraphDic setValue:array forKey:@"DD_Set"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:103 G:76 B:133]];
            [array addObject:[[Color alloc]initWithR:183 G:87 B:115]];
            [array addObject:[[Color alloc]initWithR:212 G:129 B:121]];
            [array addObject:[[Color alloc]initWithR:244 G:217 B:135]];
            [colorGraphDic setValue:array forKey:@"DE_Shock"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:119 G:200 B:204]];
            [array addObject:[[Color alloc]initWithR:240 G:244 B:183]];
            [array addObject:[[Color alloc]initWithR:204 G:154 B:189]];
            [array addObject:[[Color alloc]initWithR:245 G:146 B:27]];
            [colorGraphDic setValue:array forKey:@"DF_Summer"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:240 G:154 B:189]];
            [array addObject:[[Color alloc]initWithR:243 G:202 B:148]];
            [array addObject:[[Color alloc]initWithR:255 G:251 B:118]];
            [array addObject:[[Color alloc]initWithR:185 G:221 B:125]];
            [colorGraphDic setValue:array forKey:@"DG_Common"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:202 G:0 B:31]];
            [array addObject:[[Color alloc]initWithR:245 G:165 B:130]];
            [array addObject:[[Color alloc]initWithR:145 G:197 B:223]];
            [array addObject:[[Color alloc]initWithR:0 G:113 B:176]];
            [colorGraphDic setValue:array forKey:@"DH_Red-Blue"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:205 G:228 B:200]];
            [array addObject:[[Color alloc]initWithR:229 G:146 B:106]];
            [array addObject:[[Color alloc]initWithR:243 G:209 B:119]];
            [array addObject:[[Color alloc]initWithR:236 G:216 B:179]];
            [array addObject:[[Color alloc]initWithR:221 G:90 B:62]];
            [colorGraphDic setValue:array forKey:@"EA_Orange"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:129 G:194 B:214]];
            [array addObject:[[Color alloc]initWithR:129 G:146 B:214]];
            [array addObject:[[Color alloc]initWithR:217 G:179 B:230]];
            [array addObject:[[Color alloc]initWithR:220 G:247 B:161]];
            [array addObject:[[Color alloc]initWithR:131 G:252 B:216]];
            [colorGraphDic setValue:array forKey:@"EB_Cold"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:246 G:134 B:32]];
            [array addObject:[[Color alloc]initWithR:236 G:28 B:35]];
            [array addObject:[[Color alloc]initWithR:254 G:236 B:125]];
            [array addObject:[[Color alloc]initWithR:80 G:76 B:170]];
            [array addObject:[[Color alloc]initWithR:179 G:227 B:170]];
            [colorGraphDic setValue:array forKey:@"EC_Distinct"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:103 G:205 B:227]];
            [array addObject:[[Color alloc]initWithR:165 G:226 B:228]];
            [array addObject:[[Color alloc]initWithR:99 G:192 B:190]];
            [array addObject:[[Color alloc]initWithR:183 G:229 B:193]];
            [array addObject:[[Color alloc]initWithR:102 G:201 B:147]];
            [colorGraphDic setValue:array forKey:@"ED_Pastal"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:254 G:242 B:0]];
            [array addObject:[[Color alloc]initWithR:104 G:189 B:178]];
            [array addObject:[[Color alloc]initWithR:185 G:219 B:65]];
            [array addObject:[[Color alloc]initWithR:206 G:232 B:142]];
            [array addObject:[[Color alloc]initWithR:29 G:151 B:121]];
            [colorGraphDic setValue:array forKey:@"EE_Grass"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:97 G:255 B:105]];
            [array addObject:[[Color alloc]initWithR:184 G:247 B:136]];
            [array addObject:[[Color alloc]initWithR:88 G:210 B:232]];
            [array addObject:[[Color alloc]initWithR:242 G:182 B:182]];
            [array addObject:[[Color alloc]initWithR:232 G:237 B:81]];
            [colorGraphDic setValue:array forKey:@"EF_Blind"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:235 G:74 B:19]];
            [array addObject:[[Color alloc]initWithR:234 G:217 B:0]];
            [array addObject:[[Color alloc]initWithR:0 G:234 B:180]];
            [array addObject:[[Color alloc]initWithR:114 G:0 B:234]];
            [array addObject:[[Color alloc]initWithR:234 G:124 B:0]];
            [colorGraphDic setValue:array forKey:@"EG_Passion"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:31 G:60 B:255]];
            [array addObject:[[Color alloc]initWithR:255 G:68 B:255]];
            [array addObject:[[Color alloc]initWithR:145 G:59 B:255]];
            [array addObject:[[Color alloc]initWithR:122 G:255 B:201]];
            [array addObject:[[Color alloc]initWithR:218 G:97 B:74]];
            [colorGraphDic setValue:array forKey:@"EH_Amazing"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:217 G:77 B:77]];
            [array addObject:[[Color alloc]initWithR:135 G:171 B:102]];
            [array addObject:[[Color alloc]initWithR:251 G:180 B:72]];
            [array addObject:[[Color alloc]initWithR:103 G:205 B:204]];
            [array addObject:[[Color alloc]initWithR:171 G:58 B:107]];
            
            [array addObject:[[Color alloc]initWithR:81 G:48 B:135]];
            [array addObject:[[Color alloc]initWithR:4 G:101 B:137]];
            [array addObject:[[Color alloc]initWithR:146 G:2 B:64]];
            [colorGraphDic setValue:array forKey:@"HA_Calm"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:66 G:80 B:99]];
            [array addObject:[[Color alloc]initWithR:94 G:213 B:209]];
            [array addObject:[[Color alloc]initWithR:58 G:154 B:217]];
            [array addObject:[[Color alloc]initWithR:48 G:173 B:167]];
            [array addObject:[[Color alloc]initWithR:253 G:224 B:214]];
            
            [array addObject:[[Color alloc]initWithR:235 G:114 B:96]];
            [array addObject:[[Color alloc]initWithR:243 G:152 B:0]];
            [array addObject:[[Color alloc]initWithR:211 G:50 B:73]];
            [colorGraphDic setValue:array forKey:@"HB_Distance"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:15 G:99 B:161]];
            [array addObject:[[Color alloc]initWithR:37 G:143 B:185]];
            [array addObject:[[Color alloc]initWithR:104 G:161 B:49]];
            [array addObject:[[Color alloc]initWithR:167 G:202 B:34]];
            [array addObject:[[Color alloc]initWithR:238 G:119 B:26]];
            
            [array addObject:[[Color alloc]initWithR:245 G:193 B:28]];
            [array addObject:[[Color alloc]initWithR:124 G:61 B:146]];
            [array addObject:[[Color alloc]initWithR:229 G:74 B:120]];
            [colorGraphDic setValue:array forKey:@"HC_Exotic"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:228 G:26 B:28]];
            [array addObject:[[Color alloc]initWithR:55 G:126 B:184]];
            [array addObject:[[Color alloc]initWithR:77 G:175 B:74]];
            [array addObject:[[Color alloc]initWithR:152 G:78 B:163]];
            [array addObject:[[Color alloc]initWithR:255 G:127 B:0]];
            
            [array addObject:[[Color alloc]initWithR:255 G:255 B:51]];
            [array addObject:[[Color alloc]initWithR:166 G:86 B:40]];
            [array addObject:[[Color alloc]initWithR:247 G:129 B:191]];
            [colorGraphDic setValue:array forKey:@"HD_Luck"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:91 G:155 B:213]];
            [array addObject:[[Color alloc]initWithR:237 G:125 B:49]];
            [array addObject:[[Color alloc]initWithR:165 G:165 B:165]];
            [array addObject:[[Color alloc]initWithR:255 G:192 B:0]];
            [array addObject:[[Color alloc]initWithR:68 G:114 B:196]];
            
            [array addObject:[[Color alloc]initWithR:112 G:173 B:71]];
            [array addObject:[[Color alloc]initWithR:158 G:72 B:14]];
            [array addObject:[[Color alloc]initWithR:67 G:104 B:43]];
            [colorGraphDic setValue:array forKey:@"HE_Moist"];
        }
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            [array addObject:[[Color alloc]initWithR:237 G:125 B:49]];
            [array addObject:[[Color alloc]initWithR:255 G:192 B:0]];
            [array addObject:[[Color alloc]initWithR:112 G:173 B:71]];
            [array addObject:[[Color alloc]initWithR:158 G:72 B:14]];
            [array addObject:[[Color alloc]initWithR:153 G:115 B:0]];
            
            [array addObject:[[Color alloc]initWithR:67 G:104 B:43]];
            [array addObject:[[Color alloc]initWithR:227 G:108 B:9]];
            [array addObject:[[Color alloc]initWithR:182 G:170 B:0]];
            [colorGraphDic setValue:array forKey:@"HF_Warm"];
        }
    }
    return [colorGraphDic objectForKey:colorType];
}

+(NSString*)datasetTypeToString:(DatasetType)datasetType{
    if (datasetType == TABULAR) {
        return @"TABULAR";
    }
    if (datasetType == POINT) {
        return @"POINT";
    }
    if (datasetType == LINE) {
        return @"LINE";
    }
    if (datasetType == Network) {
        return @"Network";
    }
    if (datasetType == REGION) {
        return @"REGION";
    }
    if (datasetType == TEXT) {
        return @"TEXT";
    }
    if (datasetType == IMAGE) {
        return @"IMAGE";
    }
    if (datasetType == Grid) {
        return @"Grid";
    }
    if (datasetType == DEM) {
        return @"DEM";
    }
    if (datasetType == WMS) {
        return @"WMS";
    }
    if (datasetType == WCS) {
        return @"WCS";
    }
    if (datasetType == MBImage) {
        return @"MBImage";
    }
    if (datasetType == PointZ) {
        return @"PointZ";
    }
    if (datasetType == LineZ) {
        return @"LineZ";
    }
    if (datasetType == RegionZ) {
        return @"RegionZ";
    }
    if (datasetType == VECTORMODEL) {
        return @"VECTORMODEL";
    }
    if (datasetType == TIN) {
        return @"TIN";
    }
    if (datasetType == CAD) {
        return @"CAD";
    }
    if (datasetType == WFS) {
        return @"WFS";
    }
    if (datasetType == NETWORK3D) {
        return @"NETWORK3D";
    }
    if (datasetType == VECTORCACHE) {
        return @"VECTORCACHE";
    }
    return nil;
}
+(BOOL)itemExist:(ThemeGraphItem*) item existItems:(NSArray*) existItems{
    for (int i=0; i<existItems.count; i++) {
        if([[existItems objectAtIndex:i]isEqualToString:[item graphExpression]]){
            return YES;
        }
    }
    return NO;
}
+(NSString*)getCaption:(NSString*)graphExpression{
    NSString* caption=graphExpression;
    if([graphExpression containsString:@"."]){
        NSArray *array = [caption componentsSeparatedByString:@"."];
        if(array.count==2){
            caption=[caption pathExtension];
        }
    }
    return caption;
}
+(ThemeGraphType)getThemeGraphType:(NSString*)type{
    ThemeGraphType themeGraphType=-1;
    if([type isEqualToString:@"面积图"]){
        themeGraphType=TGT_Area;
    }else if([type isEqualToString:@"阶梯图"]){
        themeGraphType=TGT_Step;
    }else if([type isEqualToString:@"折线图"]){
        themeGraphType=TGT_Line;
    }else if([type isEqualToString:@"点状图"]){
        themeGraphType=TGT_Point;
    }else if([type isEqualToString:@"柱状图"]){
        themeGraphType=TGT_Bar;
    }else if([type isEqualToString:@"三维柱状图"]){
        themeGraphType=TGT_Bar3D;
    }else if([type isEqualToString:@"饼图"]){
        themeGraphType=TGT_Pie;
    }else if([type isEqualToString:@"三维饼图"]){
        themeGraphType=TGT_Custom;
    }else if([type isEqualToString:@"玫瑰图"]){
        themeGraphType=TGT_Rose;
    }else if([type isEqualToString:@"三维玫瑰图"]){
        themeGraphType=TGT_Rose3D;
    }else if([type isEqualToString:@"堆叠柱状图"]){
        themeGraphType=TGT_Stack_Bar;
    }else if([type isEqualToString:@"三维堆叠柱状图"]){
        themeGraphType=TGT_Stack_Bar3D;
    }else if([type isEqualToString:@"环状图"]){
        themeGraphType=TGT_Ring;
    }
    return themeGraphType;
}
//+(GraduatedMode)getGraduatedMode:(NSString*)type{
//    GraduatedMode graduatedMode=nil;
//
//}
/**
 * 根据RGB值判断 深色与浅色
 * @param r
 * @param g
 * @param b
 * @return
 */
+(BOOL)isDarkR:(int)r G:(int)g B:(int)b{
    if(r * 0.299 + g * 0.578 + b * 0.114 >= 192){
        //浅色
        return false;
    }else{
        //深色
        return true;
    }
}

/**
 * 获取统计专题图,等级符号专题图分级模式
 * @param type
 * @return
 */
+(GraduatedMode)getGraduatedMode:(NSString*)strType{
    if ([strType isEqualToString:@"CONSTANT"]) {
        return GM_Constant;//常量分级
    }else if([strType isEqualToString:@"LOGARITHM"]){
        return GM_Logarithm;//对数分级
    }else if([strType isEqualToString:@"SQUAREROOT"]){
        return GM_Squareroot;//平方根分级
    }else{
        return GM_Constant;
    }
}

/**
 * 计算矢量数据集中某个字段的最大值,不支持多字段计算最大值
 * @param datasetVector
 * @param dotExpression
 * @return
 */
+(double)getMaxValue:(DatasetVector*)datasetVector dotExpression:(NSString*)dotExpression{
    double maxValue = 1000;
    QueryParameter *parameter =[[QueryParameter alloc]init];
    [parameter setAttriButeFilter:dotExpression];
    [parameter setCursorType:STATIC];
    [parameter setHasGeometry:true];
    [parameter setResultFields:[NSArray arrayWithObjects:dotExpression, nil]];
    Recordset* recordset = [datasetVector query:parameter];
    if (nil != recordset && [recordset recordCount]!=0){
        FieldInfos *fieldInfos = [recordset fieldInfos];
        if([[fieldInfos getName:dotExpression] fieldType]==FT_INT64){
            // 屏蔽掉64位整形数据,组件不支持
            return maxValue;
        }
        if ([[fieldInfos getName:dotExpression] fieldType]==FT_TEXT) {
            maxValue = [recordset statisticByName:dotExpression statisticMode:MAX];
        }
    }
    if (nil != recordset) {
        [recordset close];
        [recordset dispose];
    }
    [parameter dispose];
    
    return maxValue;
}

+(ThemeGraduatedSymbol*)getThemeGraduatedSymbol:(NSDictionary*)data{
    NSString* layerName = nil;
    int layerIndex = -1;
    layerName = [data objectForKey:@"LayerName"];
    layerIndex = [[data objectForKey:@"LayerIndex"] intValue];
    

    Layer *layer =nil;
    if (layerName != nil) {
        layer = [SMThemeCartography getLayerByName:layerName];
    } else {
        layer = [SMThemeCartography getLayerByIndex:layerIndex];
    }
    
    if (layer != nil && layer.theme != nil) {
        if (layer.theme.themeType == TT_GraduatedSymbol) {
            return (ThemeGraduatedSymbol*) layer.theme;
        }
    }
    
    return nil;
}

+(ThemeDotDensity*) getThemeDotDensity:(NSDictionary*)data{
    NSString* layerName = nil;
    int layerIndex = -1;
    layerName = [data objectForKey:@"LayerName"];
    layerIndex = [[data objectForKey:@"LayerIndex"] intValue];
    
    
    Layer *layer =nil;
    if (layerName != nil) {
        layer = [SMThemeCartography getLayerByName:layerName];
    } else {
        layer = [SMThemeCartography getLayerByIndex:layerIndex];
    }
    
    if (layer != nil && layer.theme != nil) {
        if (layer.theme.themeType == TT_DotDensity) {
            return (ThemeDotDensity*) layer.theme;
        }
    }
    
    return nil;
}

/**
 * 获取统计专题图中统计符号显示的最大值,最小值
 * @return
 */
+(void)getGraphSizeMax:(double*)dMax min:(double*)dMin{
    MapControl *mapControl = [SMap singletonInstance].smMapWC.mapControl;
    Map *map = mapControl.map;
    
    CGPoint pointStart = CGPointMake(0, 0);
    CGPoint pointEnd = CGPointMake(0, (int)([mapControl mapWidth] / 3));
    Point2D* point2DStart = [map pixelTomap:pointStart];
    Point2D* point2DEnd = [map pixelTomap:pointEnd];
    CGPoint pointMinEnd = CGPointMake(0, (int)([mapControl mapWidth] / 18));
    Point2D* point2DMinEnd = [map pixelTomap:pointMinEnd];
    
    double maxSize = sqrt(pow(point2DEnd.x - point2DStart.x, 2) + pow(point2DEnd.y - point2DStart.y, 2));
    double minSize = sqrt(pow(point2DMinEnd.x - point2DStart.x, 2) + pow(point2DMinEnd.y - point2DStart.y, 2));
    
    *dMax = maxSize;
    *dMin = minSize;
}

/**
 * 创建统计专题图
 * @param dataset
 * @param graphExpressions
 * @param themeGraphType
 * @param colors
 * @return
 */
+(BOOL)createThemeGraphMap:(Dataset*)dataset graphExpressions:(NSArray*)graphExpressions type:(ThemeGraphType)themeGraphType colors:(NSArray*)colors{
    @try{
        if (dataset!=nil && graphExpressions!=nil && graphExpressions.count>0 &&
           colors!=nil) {
            ThemeGraph *themeGraph = [[ThemeGraph alloc] init];
            [themeGraph setGraphType:themeGraphType];
            
            ThemeGraphItem *themeGraphItem = [[ThemeGraphItem alloc]init];
            [themeGraphItem setGraphExpression:[graphExpressions objectAtIndex:0]];
            [themeGraphItem setCaption:[graphExpressions objectAtIndex:0]];
            [themeGraph insert:0 item:themeGraphItem];
            
            [[themeGraph axesTextStyle] setFontHeight:6];
            
            double dMax = 0;
            double dMin = 0;
            [SMThemeCartography getGraphSizeMax:&dMax min:&dMin];
            [themeGraph setMaxGraphSize:dMax];
            [themeGraph setMinGraphSize:dMin];
            
            int count = [themeGraph getCount];
            Colors *selectedColors = [Colors makeGradient:colors.count gradientColorArray:colors];
            //Colors.makeGradient(colors.length, colors);
            if (count > 0) {
                for (int i = 0; i < count; i++) {
                    [[[themeGraph getItem:i] uniformStyle] setFillForeColor:[selectedColors get:i]];
                }
            }
            
            //若有多个表达式，则从第二个开始添加
            for (int i = 1; i < graphExpressions.count; i++) {
                [SMThemeCartography addGraphItem:themeGraph graphExpression:[graphExpressions objectAtIndex:i] colors:selectedColors];
            }
            
            Map* map = [SMap singletonInstance].smMapWC.mapControl.map;
            [map.layers addDataset:dataset Theme:themeGraph ToHead:YES];
            [map refresh];
            
            return true;
        }
    }@catch(NSException *exception){
        return false;
    }
}

/**
 * 创建栅格单值专题图
 * @param dataset
 * @param colors
 * @return
 */
+(NSDictionary*)createThemeGridUniqueMap:(Dataset*)dataset colors:(NSArray*)colors{
    Map* map = [SMap singletonInstance].smMapWC.mapControl.map;
    DatasetGrid *datasetGrid = nil;
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    
    if (dataset!=nil && dataset.datasetType == Grid) {
        datasetGrid = (DatasetGrid*) dataset;
    }else if(dataset!=nil && dataset.datasetType != Grid){
        [resultDic setObject:@"数据集类型不匹配：栅格专题图只能由栅格数据集制作" forKey:@"Error"];
        [resultDic setObject:[NSNumber numberWithBool:false] forKey:@"Result"];
        return resultDic;
    }
    
    if (datasetGrid!=nil && colors!=nil) {
        
        ThemeGridUnique *theme = [ThemeGridUnique makeDefault:dataset colorGradientType:CGT_GREENORANGEVIOLET];
        if ([theme getCount]>3000) {
            [resultDic setObject:@"所选栅格数据集的单值项超过了系统的最大限制数目3000条，专题图制作失败" forKey:@"Error"];
            [resultDic setObject:[NSNumber numberWithBool:false] forKey:@"Result"];
            return resultDic;
        }
        
        if (nil!=theme) {
            int rangeCount = [theme getCount];
            Colors *selectedColors = [Colors makeGradient:rangeCount gradientColorArray:colors];
            if (rangeCount>0) {
                for (int i=0; i<rangeCount; i++) {
                    [[theme getItem:i] setColor:[selectedColors get:i]];
                }
            }
            [map.layers addDataset:datasetGrid Theme:theme ToHead:YES];
            [map refresh];
        }
        [resultDic setObject:[NSNumber numberWithBool:true] forKey:@"Result"];
        return resultDic;
        
    }
    
    [resultDic setObject:@"专题图创建失败" forKey:@"Error"];
    [resultDic setObject:[NSNumber numberWithBool:false] forKey:@"Result"];
    return resultDic;
    
}

/**
 * 创建栅格分段专题图
 * @param dataset
 * @param colors
 * @return
 */
+(NSDictionary*)createThemeGridRangeMap:(Dataset*)dataset colors:(NSArray*)colors{
    Map* map = [SMap singletonInstance].smMapWC.mapControl.map;
    DatasetGrid *datasetGrid = nil;
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    
    if (dataset!=nil && dataset.datasetType == Grid) {
        datasetGrid = (DatasetGrid*) dataset;
    }else if(dataset!=nil && dataset.datasetType != Grid){
        [resultDic setObject:@"数据集类型不匹配：栅格专题图只能由栅格数据集制作" forKey:@"Error"];
        [resultDic setObject:[NSNumber numberWithBool:false] forKey:@"Result"];
        return resultDic;
    }
    
    if (datasetGrid!=nil && colors!=nil) {
        ThemeGridRange *theme = [ThemeGridRange makeDefault:datasetGrid rangeMode:RM_EQUALINTERVAL parameter:5 gradientType:CGT_GREENORANGEVIOLET];
        
        if (nil!=theme) {
            int rangeCount = [theme getCount];
            Colors *selectedColors = [Colors makeGradient:rangeCount gradientColorArray:colors];
            if (rangeCount>0) {
                for (int i=0; i<rangeCount; i++) {
                    [[theme getItem:i] setColor:[selectedColors get:i]];
                }
            }
            [map.layers addDataset:datasetGrid Theme:theme ToHead:YES];
            [map refresh];
        }
        [resultDic setObject:[NSNumber numberWithBool:true] forKey:@"Result"];
        return resultDic;
        
    }
    
    [resultDic setObject:@"专题图创建失败" forKey:@"Error"];
    [resultDic setObject:[NSNumber numberWithBool:false] forKey:@"Result"];
    return resultDic;
    
}

/**
 * 修改栅格单值专题图
 * @param layer
 * @param newColors
 * @param specialValue
 * @param defaultColor
 * @param specialValueColor
 * @param isParams
 * @param isTransparent
 * @return
 */
+(BOOL)modifyThemeGridUniqueMap:(Layer*)layer colors:(NSArray*)newColors specialValue:(int)specialValue defaultColor:(Color*)defaultColor specialValueColor:(Color*)specialValueColor isParams:(BOOL)isParams  isTransparent:(BOOL)isTransparent{
    
    if (layer != nil && layer.theme != nil && [layer.theme themeType] == TT_GridUnique){
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [[mapControl getEditHistory]addMapHistory];
        
        ThemeGridUnique * themeGridUnique = (ThemeGridUnique*)layer.theme;
        if(specialValue!=-1){
            [themeGridUnique setSpecialValue:specialValue];
        }
        if(defaultColor!=nil){
            [themeGridUnique setDefaultColor:defaultColor];
        }
        if(isParams){
            [themeGridUnique setIsSpecialValueTransparent:isTransparent];
        }
        if(specialValueColor!=nil){
            //themeGridUnique.setSpecialValueColor(specialValueColor); //接口还未实现
        }
        if(newColors!=nil){
            int rangeCount = [themeGridUnique getCount];
            Colors *selectedColors = [Colors makeGradient:rangeCount gradientColorArray:newColors];
            if (rangeCount>0) {
                for (int i=0; i<rangeCount; i++) {
                    [[themeGridUnique getItem:i] setColor:[selectedColors get:i]];
                }
            }
        }
        [mapControl.map refresh];
        return true;
    }
    return false;
}

/**
 * 修改栅格分段专题图
 * @param layer
 * @param rangeMode
 * @param rangeParameter
 * @param newColors
 * @return
 */
+(BOOL)modifyThemeGridRangeMap:(Layer*)layer rangeMode:(RangeMode)rangeMode  rangeParameter:(double)rangeParameter newColors:(NSArray*)newColors{
    
    if (layer != nil && layer.theme != nil && [layer.theme themeType] == TT_GridUnique){
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [[mapControl getEditHistory]addMapHistory];
        
        ThemeGridRange* themeGridRange = (ThemeGridRange*)layer.theme;
        if (rangeMode==RM_None) {
            rangeMode = [themeGridRange getRangeMode];
        }
        if (rangeParameter==-1) {
            rangeParameter = [themeGridRange getCount];
        }
        
        ThemeGridRange *themeTemp = [ThemeGridRange makeDefault:((DatasetGrid*)layer.dataset) rangeMode:rangeMode parameter:rangeParameter gradientType:CGT_GREENORANGEVIOLET];
        
        if (themeTemp!=nil) {
            if (newColors!=nil) {
                int rangeCount = [themeTemp getCount];
                Colors *selectedColors = [Colors makeGradient:rangeCount gradientColorArray:newColors];
                if (rangeCount>0) {
                    for (int i=0; i<rangeCount; i++) {
                        [[themeTemp getItem:i] setColor:[selectedColors get:i]];
                    }
                }
            }else{
                //获取上次的颜色方案(先从专题图中获取，再从内存中获取)
                NSArray* colorsArr = [SMThemeCartography getLastThemeColors:layer];
                if (colorsArr!=nil && colorsArr.count!=0) {
                    lastGridRangeColors = colorsArr;
                    int rangeCount = [themeTemp getCount];
                    Colors *selectedColors = [Colors makeGradient:rangeCount gradientColorArray:lastGridRangeColors];
                    if (rangeCount>0) {
                        for (int i=0; i<rangeCount; i++) {
                            [[themeTemp getItem:i] setColor:[selectedColors get:i]];
                        }
                    }
                }else{
                    if (lastGridRangeColors!=nil) {
                        int rangeCount = [themeTemp getCount];
                        Colors *selectedColors = [Colors makeGradient:rangeCount gradientColorArray:lastGridRangeColors];
                        if (rangeCount>0) {
                            for (int i=0; i<rangeCount; i++) {
                                [[themeTemp getItem:i] setColor:[selectedColors get:i]];
                            }
                        }
                    }
                }
            }
            [themeGridRange fromXML:[themeTemp toXML]];
            [mapControl.map refresh];
            return true;
        }
    }
    return false;
}



@end

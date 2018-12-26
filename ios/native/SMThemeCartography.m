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

+(void)setGeoStyleColor:(DatasetType)type geoStyle:(GeoStyle*)geoStyle color:(Color*)color{
    @try{
        NSString* strType = [self datasetTypeToString:type];
        if([strType isEqualToString:@"POINT"])
        {
//TODO            [geoStyle setPointColor:color];
        }
        if([strType isEqualToString:@"LINE"])
        {
 //TODO            [geoStyle setLineColor:color];
        }
        if([strType isEqualToString:@"REGION"])
        {
//TODO             [geoStyle setFillForeColor:color];
        }
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

+(NSMutableArray*)getRangeColors:(NSString* )colorType{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    if ([colorType isEqualToString:@"CA_Oranges"]) {
        Color* color1 = [[Color alloc]initWithR:255 G:242 B:230];
        Color* color2 = [[Color alloc]initWithR:255 G:203 B:153];
        Color* color3 = [[Color alloc]initWithR:255 G:140 B:25];
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
    }
    else if ([colorType isEqualToString:@"CB_Reds"]) {
        Color* color1 = [[Color alloc]initWithR:255 G:230 B:217];
        Color* color2 = [[Color alloc]initWithR:255 G:144 B:112];
        Color* color3 = [[Color alloc]initWithR:223 G:39 B:36];
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
    }
    else if ([colorType isEqualToString:@"CC_Lemons"]) {
        Color* color1 = [[Color alloc]initWithR:255 G:255 B:230];
        Color* color2 = [[Color alloc]initWithR:255 G:255 B:153];
        Color* color3 = [[Color alloc]initWithR:230 G:255 B:51];
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
    }
    else if ([colorType isEqualToString:@"CD_Cyans"]) {
        Color* color1 = [[Color alloc]initWithR:229 G:255 B:237];
        Color* color2 = [[Color alloc]initWithR:153 G:255 B:187];
        Color* color3 = [[Color alloc]initWithR:0 G:217 B:152];
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
    }
    else if ([colorType isEqualToString:@"CE_Greens"]) {
        Color* color1 = [[Color alloc]initWithR:229 G:245 B:225];
        Color* color2 = [[Color alloc]initWithR:161 G:217 B:156];
        Color* color3 = [[Color alloc]initWithR:48 G:163 B:85];
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
    }
    else if ([colorType isEqualToString:@"CF_Blues"]) {
        Color* color1 = [[Color alloc]initWithR:223 G:236 B:247];
        Color* color2 = [[Color alloc]initWithR:159 G:202 B:225];
        Color* color3 = [[Color alloc]initWithR:48 G:130 B:189];
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
    }
    else if ([colorType isEqualToString:@"CG_Purples"]) {
        Color* color1 = [[Color alloc]initWithR:240 G:238 B:245];
        Color* color2 = [[Color alloc]initWithR:188 G:189 B:221];
        Color* color3 = [[Color alloc]initWithR:117 G:106 B:177];
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
    }
    else if ([colorType isEqualToString:@"DA_Oranges"]) {
        Color* color1 = [[Color alloc]initWithR:255 G:242 B:230];
        Color* color2 = [[Color alloc]initWithR:255 G:216 B:178];
        Color* color3 = [[Color alloc]initWithR:223 G:178 B:102];
        Color* color4 = [[Color alloc]initWithR:227 G:108 B:9];
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
        [array addObject:color4];
    }
    else if ([colorType isEqualToString:@"DB_Reds"]) {
        Color* color1 = [[Color alloc]initWithR:254 G:229 B:217];
        Color* color2 = [[Color alloc]initWithR:253 G:174 B:144];
        Color* color3 = [[Color alloc]initWithR:252 G:105 B:75];
        Color* color4 = [[Color alloc]initWithR:216 G:43 B:48];
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
        [array addObject:color4];
    }
    else if ([colorType isEqualToString:@"DC_Lemons"]) {
        Color* color1 = [[Color alloc]initWithR:255 G:255 B:230];
        Color* color2 = [[Color alloc]initWithR:255 G:255 B:178];
        Color* color3 = [[Color alloc]initWithR:255 G:255 B:127];
        Color* color4 = [[Color alloc]initWithR:229 G:43 B:50];
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
        [array addObject:color4];
    }
    if ([colorType isEqualToString:@"DD_Cyans"]) {
        Color* color1 = [[Color alloc]initWithR:222 G:247 B:232];
        Color* color2 = [[Color alloc]initWithR:149 G:252 B:189];
        Color* color3 = [[Color alloc]initWithR:79 G:247 B:177];
        Color* color4 = [[Color alloc]initWithR:0 G:217 B:152];
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
        [array addObject:color4];
    }
    if ([colorType isEqualToString:@"DF_Blues"]) {
        Color* color1 = [[Color alloc]initWithR:223 G:236 B:247];
        Color* color2 = [[Color alloc]initWithR:159 G:202 B:225];
        Color* color3 = [[Color alloc]initWithR:95 G:161 B:204];
        Color* color4 = [[Color alloc]initWithR:48 G:130 B:189];
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
        [array addObject:color4];
    }
    else if ([colorType isEqualToString:@"DG_Purples"]) {
        Color* color1 = [[Color alloc]initWithR:242 G:241 B:247];
        Color* color2 = [[Color alloc]initWithR:203 G:202 B:226];
        Color* color3 = [[Color alloc]initWithR:159 G:154 B:201];
        Color* color4 = [[Color alloc]initWithR:105 G:81 B:163];
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
        [array addObject:color4];
    }
    else if ([colorType isEqualToString:@"EA_Oranges"]) {
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
    }
    else if ([colorType isEqualToString:@"EB_Reds"]) {
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
    }
    else if ([colorType isEqualToString:@"EC_Lemons"]) {
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
    }
    else if ([colorType isEqualToString:@"ED_Cyans"]) {
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
    }
    else if ([colorType isEqualToString:@"EE_Greens"]) {
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
    }
    else if ([colorType isEqualToString:@"EF_Blues"]) {
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
    }
    else if ([colorType isEqualToString:@"EG_Purples"]) {
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
    }
    
    else if ([colorType isEqualToString:@"FA_Oranges"]) {
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
    }
    else if ([colorType isEqualToString:@"FB_Reds"]) {
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
    }
    else if ([colorType isEqualToString:@"FC_Lemons"]) {
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
    }
    else if ([colorType isEqualToString:@"FD_Cyans"]) {
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
    }
    else if ([colorType isEqualToString:@"FE_Greens"]) {
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
    }
    else if ([colorType isEqualToString:@"FF_Blues"]) {
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
    }
    else if ([colorType isEqualToString:@"FG_Purples"]) {
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
    }
    else if ([colorType isEqualToString:@"GA_Yellow to Orange"]) {
        Color* color1 = [[Color alloc]initWithR:255 G:254 B:102];
        Color* color2 = [[Color alloc]initWithR:255 G:119 B:51];
        [array addObject:color1];
        [array addObject:color2];
    }
    else if ([colorType isEqualToString:@"GB_Orange to Red"]) {
        Color* color1 = [[Color alloc]initWithR:250 G:204 B:137];
        Color* color2 = [[Color alloc]initWithR:204 G:40 B:40];
        [array addObject:color1];
        [array addObject:color2];
    }
    else if ([colorType isEqualToString:@"GC_Olive to Purple"]) {
        Color* color1 = [[Color alloc]initWithR:75 G:172 B:198];
        Color* color2 = [[Color alloc]initWithR:255 G:255 B:255];
        Color* color3 = [[Color alloc]initWithR:178 G:162 B:199];
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
    }
    else if ([colorType isEqualToString:@"GD_Green to Orange"]) {
        Color* color1 = [[Color alloc]initWithR:127 G:194 B:105];
        Color* color2 = [[Color alloc]initWithR:255 G:255 B:255];
        Color* color3 = [[Color alloc]initWithR:247 G:150 B:70];
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
    }
    else if ([colorType isEqualToString:@"GE_Blue to Lemon"]) {
        Color* color1 = [[Color alloc]initWithR:146 G:255 B:220];
        Color* color2 = [[Color alloc]initWithR:255 G:255 B:255];
        Color* color3 = [[Color alloc]initWithR:255 G:255 B:0];
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
    }
    else if ([colorType isEqualToString:@"ZA_Temperature 1"]) {
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
    }
    
    else if ([colorType isEqualToString:@"ZB_Temperature 2"]) {
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
    }
    else if ([colorType isEqualToString:@"ZC_Temperature 3"]) {
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
    }
    else if ([colorType isEqualToString:@"ZD_Temperature 4"]) {
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
    }
    else if ([colorType isEqualToString:@"ZE_Precipitation 1"]) {
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
    }
    else if ([colorType isEqualToString:@"ZF_Precipitation 2"]) {
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
    }
    else if ([colorType isEqualToString:@"ZG_Precipitation 3"]) {
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
    }
    else if ([colorType isEqualToString:@"ZH_Precipitation 4"]) {
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
    }
    else if ([colorType isEqualToString:@"ZI_Altitude 1"]) {
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
    }
    else if ([colorType isEqualToString:@"ZJ_Altitude 2"]) {
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
    }
    else if ([colorType isEqualToString:@"ZK_Altitude 3"]) {
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
    }
//    if ([colorType isEqualToString:@"ZC_Temperature 3"]) {
//        Color* color1 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//        Color* color2 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//        Color* color3 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//        Color* color4 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//        Color* color5 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//        Color* color6 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//
//        Color* color7 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//        Color* color8 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//        Color* color9 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//        Color* color10 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//        Color* color11 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//        Color* color12 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//
//        Color* color13 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//        Color* color14 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//        Color* color15 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//        Color* color16 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//        Color* color17 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//        Color* color18 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//
//        Color* color19 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//        Color* color20 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//        Color* color21 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//        Color* color22 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//        Color* color23 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//        Color* color24 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//
//        Color* color25 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//        Color* color26 = [[Color alloc]initWithR:<#(int)#> G:<#(int)#> B:<#(int)#>];
//        [array addObject:color1];
//        [array addObject:color2];
//        [array addObject:color3];
//        [array addObject:color4];
//        [array addObject:color5];
//        [array addObject:color6];
//
//        [array addObject:color7];
//        [array addObject:color8];
//        [array addObject:color9];
//        [array addObject:color10];
//        [array addObject:color11];
//        [array addObject:color12];
//
//        [array addObject:color13];
//        [array addObject:color14];
//        [array addObject:color15];
//        [array addObject:color16];
//        [array addObject:color17];
//        [array addObject:color18];
//
//        [array addObject:color19];
//        [array addObject:color20];
//        [array addObject:color21];
//        [array addObject:color22];
//        [array addObject:color23];
//        [array addObject:color24];
//
//        [array addObject:color25];
//        [array addObject:color26];
//    }
    return array;
        
}

+(NSMutableArray*)getUniqueColors:(NSString* )colorType{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    if ([colorType isEqualToString:@"BA_Blue"]) {
        Color* color1 = [[Color alloc]initWithR:191 G:217 B:242];
        Color* color2 = [[Color alloc]initWithR:128 G:179 B:230];
        [array addObject:color1];
        [array addObject:color2];
    }
    else if ([colorType isEqualToString:@"BB_Green"]) {
        Color* color1 = [[Color alloc]initWithR:204 G:255 B:204];
        Color* color2 = [[Color alloc]initWithR:127 G:229 B:127];
        [array addObject:color1];
        [array addObject:color2];
    }
    else if ([colorType isEqualToString:@"BC_Orange"]) {
        Color* color1 = [[Color alloc]initWithR:255 G:239 B:204];
        Color* color2 = [[Color alloc]initWithR:255 G:222 B:153];
        [array addObject:color1];
        [array addObject:color2];
    }
    else if ([colorType isEqualToString:@"BD_Pink"]) {
        Color* color1 = [[Color alloc]initWithR:255 G:224 B:203];
        Color* color2 = [[Color alloc]initWithR:242 G:185 B:145];
        [array addObject:color1];
        [array addObject:color2];
    }
    else if ([colorType isEqualToString:@"CA_Red Rose"]) {
        Color* color1 = [[Color alloc]initWithR:255 G:244 B:91];
        Color* color2 = [[Color alloc]initWithR:252 G:216 B:219];
        Color* color3 = [[Color alloc]initWithR:129 G:195 B:231];
        
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
    }
    else if ([colorType isEqualToString:@"CB_Blue and Yellow"]) {
        Color* color1 = [[Color alloc]initWithR:245 G:255 B:166];
        Color* color2 = [[Color alloc]initWithR:121 G:232 B:208];
        Color* color3 = [[Color alloc]initWithR:255 G:251 B:0];
        
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
    }
    else if ([colorType isEqualToString:@"CC_Pink and Green"]) {
        Color* color1 = [[Color alloc]initWithR:255 G:204 B:178];
        Color* color2 = [[Color alloc]initWithR:255 G:255 B:204];
        Color* color3 = [[Color alloc]initWithR:153 G:204 B:153];
        
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
    }
    else if ([colorType isEqualToString:@"CD_Fresh"]) {
        Color* color1 = [[Color alloc]initWithR:204 G:255 B:204];
        Color* color2 = [[Color alloc]initWithR:255 G:255 B:204];
        Color* color3 = [[Color alloc]initWithR:204 G:255 B:255];
        
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
    }
    else if ([colorType isEqualToString:@"DA_Ragular"]) {
        Color* color1 = [[Color alloc]initWithR:254 G:224 B:236];
        Color* color2 = [[Color alloc]initWithR:255 G:253 B:228];
        Color* color3 = [[Color alloc]initWithR:194 G:229 B:252];
        Color* color4 = [[Color alloc]initWithR:166 G:255 B:166];
        
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
        [array addObject:color4];
    }
    else if ([colorType isEqualToString:@"DB_Common"]) {
        Color* color1 = [[Color alloc]initWithR:221 G:168 B:202];
        Color* color2 = [[Color alloc]initWithR:253 G:253 B:176];
        Color* color3 = [[Color alloc]initWithR:197 G:228 B:189];
        Color* color4 = [[Color alloc]initWithR:245 G:198 B:144];
        
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
        [array addObject:color4];
    }
    else if ([colorType isEqualToString:@"DC_Bright"]) {
        Color* color1 = [[Color alloc]initWithR:122 G:203 B:203];
        Color* color2 = [[Color alloc]initWithR:245 G:245 B:110];
        Color* color3 = [[Color alloc]initWithR:183 G:229 B:193];
        Color* color4 = [[Color alloc]initWithR:254 G:250 B:177];
        
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
        [array addObject:color4];
    }
    else if ([colorType isEqualToString:@"DD_Warm"]) {
        Color* color1 = [[Color alloc]initWithR:237 G:156 B:156];
        Color* color2 = [[Color alloc]initWithR:255 G:251 B:154];
        Color* color3 = [[Color alloc]initWithR:244 G:191 B:122];
        Color* color4 = [[Color alloc]initWithR:226 G:201 B:220];
        
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
        [array addObject:color4];
    }
    else if ([colorType isEqualToString:@"DE_Set"]) {
        Color* color1 = [[Color alloc]initWithR:140 G:211 B:200];
        Color* color2 = [[Color alloc]initWithR:255 G:255 B:180];
        Color* color3 = [[Color alloc]initWithR:190 G:186 B:218];
        Color* color4 = [[Color alloc]initWithR:252 G:128 B:114];
        
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
        [array addObject:color4];
    }
    else if ([colorType isEqualToString:@"DF_Pastel"]) {
        Color* color1 = [[Color alloc]initWithR:180 G:226 B:206];
        Color* color2 = [[Color alloc]initWithR:253 G:206 B:172];
        Color* color3 = [[Color alloc]initWithR:203 G:213 B:232];
        Color* color4 = [[Color alloc]initWithR:245 G:202 B:228];
        
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
        [array addObject:color4];
    }
    else if ([colorType isEqualToString:@"DG_Grass"]) {
        Color* color1 = [[Color alloc]initWithR:162 G:205 B:247];
        Color* color2 = [[Color alloc]initWithR:160 G:239 B:158];
        Color* color3 = [[Color alloc]initWithR:255 G:252 B:240];
        Color* color4 = [[Color alloc]initWithR:255 G:255 B:195];
        
        [array addObject:color1];
        [array addObject:color2];
        [array addObject:color3];
        [array addObject:color4];
    }
    else if ([colorType isEqualToString:@"EA_Sin_ColorScheme8"]) {
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
    }
    else if ([colorType isEqualToString:@"EB_Sweet"]) {
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
    }
    else if ([colorType isEqualToString:@"EC_Dusk"]) {
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
    }
    else if ([colorType isEqualToString:@"ED_Pastel"]) {
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
    }
    else if ([colorType isEqualToString:@"EE_Lake"]) {
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
    }
    else if ([colorType isEqualToString:@"EF_Grass"]) {
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
    }
    else if ([colorType isEqualToString:@"EG_Sin_ColorScheme1"]) {
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
    }
    else if ([colorType isEqualToString:@"EH_Sin_ColorScheme4"]) {
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
    }
    else if ([colorType isEqualToString:@"EI_Sin_ColorScheme6"]) {
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
    }
    else if ([colorType isEqualToString:@"EJ_Sin_ColorScheme7"]) {
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
    }
    else if ([colorType isEqualToString:@"FA_Red-Yellow-Blue"]) {
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
    }
    else if ([colorType isEqualToString:@"FB_Red-Yellow-Green"]) {
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
    }
    return array;
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
@end

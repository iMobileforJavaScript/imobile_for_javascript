//
//  SThemeCartography.m
//  Supermap
//
//  Created by xianglong li on 2018/12/7.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "SThemeCartography.h"
#import "SMThemeCartography.h"
#import "STranslate.h"
#import "SMap.h"

@implementation SThemeCartography
RCT_EXPORT_MODULE();

/*单值专题图
 *********************************************************************************************/
/**
 * 新建单值专题图层
 *
 * @param dataDic (数据源的索引/数据源的别名/打开本地数据源、数据集名称、单值专题图字段表达式、默认样式)
 */

RCT_REMAP_METHOD(createThemeUniqueMap, createThemeUniqueMapWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        int datasourceIndex = 0;
        NSString* datasourceAlias = @"";
        NSString* datasetName = @"";
        NSString* uniqueExpression = @"";
        ColorGradientType colorGradientType = CGT_TERRAIN;//默认
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"DatasetName"]) {
            datasetName = [dataDic objectForKey:@"DatasetName"];
        }
        if ([array containsObject:@"UniqueExpression"]) {
            uniqueExpression = [dataDic objectForKey:@"UniqueExpression"];
        }
        if ([array containsObject:@"ColorGradientType"]) {
            NSString* type = [dataDic objectForKey:@"ColorGradientType"];
            colorGradientType = [SMThemeCartography getColorGradientType:type];
        }
        Dataset *dataset = nil;
        dataset = [SMThemeCartography getDataset:datasetName data:dataDic];
        if (dataset == nil) {
            if ([array containsObject:@"DatasourceIndex"]) {
                NSNumber* index = [dataDic objectForKey:@"DatasourceIndex"];
                datasourceIndex = index.intValue;
            }
            if ([array containsObject:@"DatasourceAlias"]) {
                datasourceAlias = [dataDic objectForKey:@"DatasourceAlias"];
            }
            if ([datasourceAlias isEqualToString:@""]) {
                dataset = [SMThemeCartography getDataset:datasetName datasourceAlias:datasourceAlias];
            }
            else{
                dataset = [SMThemeCartography getDataset:datasetName datasourceIndex:datasourceIndex];
            }
        }
        if (dataset != nil && ![uniqueExpression isEqualToString:@""]) {
            ThemeUnique* themeUnique = [ThemeUnique makeDefault:(DatasetVector*)dataset uniqueExpression:uniqueExpression colorType:colorGradientType];
            GeoStyle* geoStyle = [SMThemeCartography getThemeUniqueGeoStyle:themeUnique.mDefaultStyle data:dataDic];
            themeUnique.mDefaultStyle = geoStyle;
            MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
            [mapControl.map.layers addDataset:dataset Theme:themeUnique ToHead:true];
            [mapControl.map refresh];    
            resolve([NSNumber numberWithBool:YES]);
        }
        else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 修改单值专题图层
 *
 * @param readableMap (数据源的索引/数据源的别名/打开本地数据源、数据集名称、单值专题图字段表达式、默认样式)
 *                    LayerName: 要移除的专题图层
 */

RCT_REMAP_METHOD(createAndRemoveThemeUniqueMap, createAndRemoveThemeUniqueMapWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        int datasourceIndex = -1;
        NSString* datasourceAlias = @"";
        NSString* datasetName = @"";
        NSString* uniqueExpression = @"";
        ColorGradientType colorGradientType = CGT_TERRAIN;//默认
        NSString* layerName = @"";
        int layerIndex = 0;
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"DatasetName"]) {
            datasetName = [dataDic objectForKey:@"DatasetName"];
        }
        if ([array containsObject:@"UniqueExpression"]) {
            uniqueExpression = [dataDic objectForKey:@"UniqueExpression"];
        }
        if ([array containsObject:@"ColorGradientType"]) {
            NSString* type = [dataDic objectForKey:@"ColorGradientType"];
            colorGradientType = [SMThemeCartography getColorGradientType:type];
        }
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
        }
        if ([array containsObject:@"LayerIndex"]) {
            NSNumber* index = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = index.intValue;
        }
        Dataset *dataset = nil;
        dataset = [SMThemeCartography getDataset:datasetName data:dataDic];
        if (dataset == nil) {
            if ([array containsObject:@"DatasourceIndex"]) {
                NSNumber* index = [dataDic objectForKey:@"DatasourceIndex"];
                datasourceIndex = index.intValue;
            }
            if ([array containsObject:@"DatasourceAlias"]) {
                datasourceAlias = [dataDic objectForKey:@"DatasourceAlias"];
            }
            if ([datasourceAlias isEqualToString:@""]) {
                dataset = [SMThemeCartography getDataset:datasetName datasourceAlias:datasourceAlias];
            }
            else{
                dataset = [SMThemeCartography getDataset:datasetName datasourceIndex:datasourceIndex];
            }
        }
        if (dataset != nil && ![uniqueExpression isEqualToString:@""]) {
            ThemeUnique* themeUnique = [ThemeUnique makeDefault:(DatasetVector*)dataset uniqueExpression:uniqueExpression colorType:colorGradientType];
            GeoStyle* geoStyle = [SMThemeCartography getThemeUniqueGeoStyle:themeUnique.mDefaultStyle data:dataDic];
            themeUnique.mDefaultStyle = geoStyle;
            MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
            if ([layerName isEqualToString:@""]) {
                [[mapControl.map.layers getLayerAtIndex:layerIndex] setVisible:false];
            } else {
                [[mapControl.map.layers getLayerWithName:layerName] setVisible:false];
            }
            [mapControl.map.layers addDataset:dataset Theme:themeUnique ToHead:true];
            [mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        }
        else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 修改单值专题图层
 *
 * @param readableMap (数据源的索引/数据源的别名/打开本地数据源、数据集名称、单值专题图字段表达式、默认样式)
 *                    LayerName: 要移除的专题图层
 */

RCT_REMAP_METHOD(modifyThemeUniqueMap, modifyThemeUniqueMapWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSString* uniqueExpression = @"";
        ColorGradientType colorGradientType = CGT_TERRAIN;//默认
        NSString* layerName = @"";
        int layerIndex = 0;
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
        }
        Layer* themeUniqueLayer = nil;
        themeUniqueLayer = [SMThemeCartography getLayerByName:layerName];
        Dataset* dataset = nil;
        if (themeUniqueLayer != nil) {
            dataset = themeUniqueLayer.dataset;
        }
        ThemeUnique* themeUnique = nil;
        if (themeUniqueLayer != nil && themeUniqueLayer.theme != nil && themeUniqueLayer.theme.themeType == TT_Unique) {
            themeUnique = (ThemeUnique*) themeUniqueLayer.theme;
        }
        if ([array containsObject:@"UniqueExpression"]) {
            uniqueExpression = [dataDic objectForKey:@"UniqueExpression"];
        }
        else{
            if (themeUnique != nil) {
                uniqueExpression = [themeUnique getUniqueExpression];
            }
        }
        
        if ([array containsObject:@"ColorGradientType"]) {
            NSString* strType = [dataDic objectForKey:@"ColorGradientType"];
            colorGradientType = [SMThemeCartography getColorGradientType:strType];
        }
        else
        {
            colorGradientType = CGT_GREENWHITE;
        }
        
        bool result = false;
        if (dataset != nil && themeUniqueLayer.theme != nil && ![uniqueExpression isEqualToString:@""]) {
            ThemeUnique* tu = nil;
            tu = [ThemeUnique makeDefault:(DatasetVector*)dataset uniqueExpression:uniqueExpression colorType:colorGradientType];
            if (tu != nil) {
                if(![array containsObject:@"ColorGradientType"]){
                    NSMutableArray* mulArray = nil;
                    mulArray =  [SMThemeCartography getLastThemeColors:themeUniqueLayer];
                    if (mulArray != nil) {
                        int rangeCount = [tu getCount];
                        Colors* selectedColors = [Colors makeGradient:rangeCount gradientColorArray:mulArray];
                        for (int i = 0; i < rangeCount; i++) {
                            [SMThemeCartography setGeoStyleColor:dataset.datasetType geoStyle:[tu getItem:i].mStyle color:[selectedColors get:i]];
                        }
                    }
                }
                [themeUniqueLayer.theme fromXML:[tu toXML]];
                MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
                [mapControl.map refresh];
            }
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 设置单值专题图的默认风格
 *
 * @param readableMap 显示风格
 * @param layerName 图层名称
 */
RCT_REMAP_METHOD(setThemeUniqueDefaultStyle, setThemeUniqueDefaultStyleWithResolver:(NSDictionary*)dataDic layerName:(NSString*)layerName resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        Layer* layer = [SMThemeCartography getLayerByName:layerName];
        if (layer != nil && layer.theme != nil) {
            if (layer.theme.themeType == TT_Unique) {
                ThemeUnique* themeUnique = (ThemeUnique*)layer.theme;
                GeoStyle* geoStyle = [SMThemeCartography getThemeUniqueGeoStyle:themeUnique.mDefaultStyle data:dataDic];
                themeUnique.mDefaultStyle = geoStyle;
                [[SMap singletonInstance].smMapWC.mapControl.map refresh];
                resolve([NSNumber numberWithBool:YES]);
            }
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 设置单值专题图子项的显示风格
 *
 * @param readableMap 显示风格
 * @param layerName 图层名称
 * @param itemIndex 单值专题图子项索引
 * @param promise
 */
RCT_REMAP_METHOD(setThemeUniqueItemStyle, setThemeUniqueItemStyleWithResolver:(NSDictionary*)dataDic layerName:(NSString*)layerName itemIndex:(int)itemIndex resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        Layer* layer = [SMThemeCartography getLayerByName:layerName];
        if (layer != nil && layer.theme != nil) {
            if (layer.theme.themeType == TT_Unique) {
                ThemeUnique* themeUnique = (ThemeUnique*)layer.theme;
                ThemeUniqueItem * uniqueItem = [themeUnique getItem:itemIndex];
                GeoStyle* geoStyle = [SMThemeCartography getThemeUniqueGeoStyle:uniqueItem.mStyle data:dataDic];
                uniqueItem.mStyle = geoStyle;
                [[SMap singletonInstance].smMapWC.mapControl.map refresh];
                resolve([NSNumber numberWithBool:YES]);
            }
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 设置单值专题图字段表达式
 *
 * @param readableMap 单值专题图字段表达式 图层名称 图层索引
 * @param promise
 */
RCT_REMAP_METHOD(setUniqueExpression, setUniqueExpressionWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSString* layerName = @"";
        int layerIndex = -1;
        NSString* uniqueExpression = @"";
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
        }
        if ([array containsObject:@"UniqueExpression"]) {
            uniqueExpression = [dataDic objectForKey:@"UniqueExpression"];
        }
        if ([array containsObject:@"LayerIndex"]) {
            NSNumber* indexValue = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = indexValue.intValue;
        }
        
        Layer* layer = nil;
        
        if ([layerName isEqualToString:@""]) {
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        } else {
            layer = [SMThemeCartography getLayerByName:layerName];
        }
        
        if (layer != nil && ![uniqueExpression isEqualToString:@""] && layer.theme != nil) {
            if (layer.theme.themeType == TT_Unique) {
                ThemeUnique* themeUnique = (ThemeUnique*)layer.theme;
                [themeUnique setUniqueExpression:uniqueExpression];
                [[SMap singletonInstance].smMapWC.mapControl.map refresh];
                resolve([NSNumber numberWithBool:YES]);
            }
        }
        else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 获取单值专题图的默认风格
 *
 * @param layerName 图层名称
 * @param promise
 */
RCT_REMAP_METHOD(getThemeUniqueDefaultStyle, getThemeUniqueDefaultStyleWithResolver:(NSString*)layerName resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        Layer *layer = nil;
        layer = [SMThemeCartography getLayerByName:layerName];
        if (layer != nil && layer.theme != nil) {
            ThemeUnique* themeUnique =(ThemeUnique*)layer.theme;
            GeoStyle* geoStyle = themeUnique.mDefaultStyle;
            NSMutableDictionary* dic = [SMThemeCartography getThemeUniqueDefaultStyle:geoStyle];
            resolve(dic);
        }
        else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 获取单值专题图的字段表达式
 *
 * @param layerName 图层名称
 */

RCT_REMAP_METHOD(getUniqueExpression, getUniqueExpressionWithResolver:(NSDictionary*)dataDic layerName:(NSString*)layerName resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        Layer *layer = nil;
        layer = [SMThemeCartography getLayerByName:layerName];
        if (layer != nil && layer.theme != nil) {
            ThemeUnique* themeUnique =(ThemeUnique*)layer.theme;
            NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
            NSString* strExpression = [themeUnique getUniqueExpression];
            [dic setValue:strExpression forKey:@"UniqueExpression"];
            resolve(dic);
        }
        else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/*标签专题图
 * ********************************************************************************************/
/**
 * 新建统一标签专题图
 *
 * @param layerName 图层名称
 */
RCT_REMAP_METHOD(createUniformThemeLabelMap, createUniformThemeLabelMapWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        int datasourceIndex = -1;
        NSString* datasourceAlias = @"";
        NSString* datasetName = @"";
        NSString* labelExpression = @"";
        LabelBackShape labelBackShape;
        NSString* fontName = @"";
        double fontSize = -1;
        double rotation = -1;
        NSString* forecolor = @"";
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"DatasetName"]) {
            datasetName = [dataDic objectForKey:@"DatasetName"];
        }
        if ([array containsObject:@"LabelExpression"]) {
            labelExpression = [dataDic objectForKey:@"LabelExpression"];
        }
        if ([array containsObject:@"LabelBackShape"]) {
            NSString* type = [dataDic objectForKey:@"LabelBackShape"];
            labelBackShape = [SMThemeCartography getLabelBackShape:type];
        }
        else
        {
            labelBackShape = LAB_NONE;
        }
        if ([array containsObject:@"FontName"]) {
            fontName = [dataDic objectForKey:@"FontName"];
        }
        if ([array containsObject:@"FontSize"]) {
            NSNumber* num = [dataDic objectForKey:@"FontSize"];
            fontSize = num.doubleValue;
        }
        if ([array containsObject:@"Rotation"]) {
            NSNumber* num = [dataDic objectForKey:@"Rotation"];
            rotation = num.doubleValue;
        }
        if ([array containsObject:@"ForeColor"]) {
            forecolor = [dataDic objectForKey:@"ForeColor"];
        }
        Dataset *dataset = nil;
        dataset = [SMThemeCartography getDataset:datasetName data:dataDic];
        if (dataset == nil) {
            if ([array containsObject:@"DatasourceIndex"]) {
                NSNumber* index = [dataDic objectForKey:@"DatasourceIndex"];
                datasourceIndex = index.intValue;
            }
            if ([array containsObject:@"DatasourceAlias"]) {
                datasourceAlias = [dataDic objectForKey:@"DatasourceAlias"];
            }
            if ([datasourceAlias isEqualToString:@""]) {
                dataset = [SMThemeCartography getDataset:datasetName datasourceIndex:datasourceIndex];
            }
            else{
                dataset = [SMThemeCartography getDataset:datasetName datasourceAlias:datasourceAlias];
            }
        }
        if (dataset != nil && ![labelExpression isEqualToString:@""]) {
            ThemeLabel* themeLabel = [[ThemeLabel alloc] init];
            [themeLabel setLabelExpression:labelExpression];
            [themeLabel setBackShape:labelBackShape];
            TextStyle* textStyle = [[TextStyle alloc] init];
            if (![fontName isEqualToString:@""]) {
                [textStyle setFontName:fontName];
            }
            if (fontSize != -1) {
                [textStyle setFontHeight:fontSize];
                [textStyle setFontWidth:fontSize];
            }
            if (rotation != -1) {
                [textStyle setRotation:rotation];
            }
            if (![forecolor isEqualToString:@""]) {
                [textStyle setForeColor:[STranslate colorFromHexString:forecolor]];
            }
            [themeLabel setMUniformStyle:textStyle];
            MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
            [mapControl.map.layers addDataset:dataset Theme:themeLabel ToHead:true];
            [mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        }
        else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 设置统一标签专题图字段表达式
 *
 * @param dataDic 单值专题图字段表达式 图层名称 图层索引
 * @param promise
 */
RCT_REMAP_METHOD(setUniformLabelExpression, setUniformLabelExpressionWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSString* layerName = @"";
        int layerIndex = -1;
        NSString* labelExpression = @"";
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
        }
        if ([array containsObject:@"LabelExpression"]) {
            labelExpression = [dataDic objectForKey:@"LabelExpression"];
        }
        if ([array containsObject:@"LayerIndex"]) {
            NSNumber* indexValue = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = indexValue.intValue;
        }
        
        Layer* layer = nil;
        
        if ([layerName isEqualToString:@""]) {
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        } else {
            layer = [SMThemeCartography getLayerByName:layerName];
        }
        
        if (layer != nil && ![labelExpression isEqualToString:@""] && layer.theme != nil) {
            if (layer.theme.themeType == TT_label) {
                ThemeLabel* themeLabel = (ThemeLabel*)layer.theme;
                [themeLabel setLabelExpression:labelExpression];
                [[SMap singletonInstance].smMapWC.mapControl.map refresh];
                resolve([NSNumber numberWithBool:YES]);
            }
        }
        else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 获取统一标签专题图的字段表达式
 *
 * @param layerName 图层名称
 */

RCT_REMAP_METHOD(getUniformLabelExpression, getUniformLabelExpressionWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        Layer *layer = nil;
        NSString* layerName = @"";
        int layerIndex = -1;
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
        }
        if ([array containsObject:@"LayerIndex"]) {
            NSNumber* indexValue = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = indexValue.intValue;
        }
        if ([layerName isEqualToString:@""]) {
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        } else {
            layer = [SMThemeCartography getLayerByName:layerName];
        }
        if (layer != nil && layer.theme != nil) {
            if (layer.theme.themeType == TT_label) {
//                ThemeLabel* themeLabel =(ThemeLabel*)layer.theme;
                NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
                NSString* strExpression;
//TODO          strExpression = [themeLabel getLabelExpression];
                [dic setValue:strExpression forKey:@"LabelExpression"];
                resolve(dic);
            }
        }
        else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 设置统一标签专题图背景形状
 *
 * @param dataDic 单值专题图字段表达式 图层名称 图层索引
 * @param promise
 */
RCT_REMAP_METHOD(setUniformLabelBackShape, setUniformLabelBackShapeWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSString* layerName = @"";
        int layerIndex = -1;
        LabelBackShape labelBackShape;
        bool isContainBackShape = false;
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
        }
        if ([array containsObject:@"LabelBackShape"]) {
            NSString* shape = [dataDic objectForKey:@"LabelBackShape"];
            labelBackShape = [SMThemeCartography getLabelBackShape:shape];
            isContainBackShape = true;
        }
        if ([array containsObject:@"LayerIndex"]) {
            NSNumber* indexValue = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = indexValue.intValue;
        }
        
        Layer* layer = nil;
        
        if ([layerName isEqualToString:@""]) {
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        } else {
            layer = [SMThemeCartography getLayerByName:layerName];
        }
        
        if (layer != nil && isContainBackShape && layer.theme != nil) {
            if (layer.theme.themeType == TT_label) {
                ThemeLabel* themeLabel = (ThemeLabel*)layer.theme;
                [themeLabel setBackShape:labelBackShape];
                [[SMap singletonInstance].smMapWC.mapControl.map refresh];
                resolve([NSNumber numberWithBool:YES]);
            }
        }
        else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 设置统一标签专题图背景形状
 *
 * @param dataDic 单值专题图字段表达式 图层名称 图层索引
 * @param promise
 */
RCT_REMAP_METHOD(setUniformLabelBackColor, setUniformLabelBackColorWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSString* layerName = @"";
        int layerIndex = -1;
        NSString* strColor = @"";
        bool isContainColor = false;
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
        }
        if ([array containsObject:@"Color"]) {
            strColor = [dataDic objectForKey:@"Color"];
            isContainColor = true;
        }
        if ([array containsObject:@"LayerIndex"]) {
            NSNumber* indexValue = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = indexValue.intValue;
        }
        
        Layer* layer = nil;
        
        if ([layerName isEqualToString:@""]) {
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        } else {
            layer = [SMThemeCartography getLayerByName:layerName];
        }
        
        if (layer != nil && isContainColor && layer.theme != nil) {
            if (layer.theme.themeType == TT_label) {
                ThemeLabel* themeLabel = (ThemeLabel*)layer.theme;
                GeoStyle* backStyle = [themeLabel getBackStyle];
                Color* color = [STranslate colorFromHexString:strColor];
                [backStyle setFillForeColor:color];
                [[SMap singletonInstance].smMapWC.mapControl.map refresh];
                resolve([NSNumber numberWithBool:YES]);
            }
        }
        else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 获取统一标签专题图的背景形状
 *
 * @param layerName 图层名称
 */

RCT_REMAP_METHOD(getUniformLabelBackShape, getUniformLabelBackShapeWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        Layer *layer = nil;
        NSString* layerName = @"";
        int layerIndex = -1;
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
        }
        if ([array containsObject:@"LayerIndex"]) {
            NSNumber* indexValue = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = indexValue.intValue;
        }
        if ([layerName isEqualToString:@""]) {
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        } else {
            layer = [SMThemeCartography getLayerByName:layerName];
        }
        if (layer != nil && layer.theme != nil) {
            if (layer.theme.themeType == TT_label) {
//                ThemeLabel* themeLabel =(ThemeLabel*)layer.theme;
//                LabelBackShape labelBackShape;
//TODO          labelBackShape  = [themeLabel getBackShape];
//                NSString* strBackShape = [SMThemeCartography getLabelBackShapeString:labelBackShape];
//                if (strBackShape != nil) {
//                    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
//                    [dic setValue:strBackShape forKey:@"LabelBackShape"];
//                    resolve(dic);
//                }
//                else{
//                    resolve([NSNumber numberWithBool:NO]);
//                }
            }
        }
        else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 设置统一标签专题图的字体
 *
 * @param dataDic 单值专题图字段表达式 图层名称 图层索引
 * @param promise
 */
RCT_REMAP_METHOD(setUniformLabelFontName, setUniformLabelFontNameWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSString* layerName = @"";
        int layerIndex = -1;
        NSString* fontName = @"";
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
        }
        if ([array containsObject:@"LayerIndex"]) {
            NSNumber* indexValue = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = indexValue.intValue;
        }
        if ([array containsObject:@"FontName"]) {
            fontName = [dataDic objectForKey:@"FontName"];
        }
        
        Layer* layer = nil;
        
        if ([layerName isEqualToString:@""]) {
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        } else {
            layer = [SMThemeCartography getLayerByName:layerName];
        }
        
        if (layer != nil && ![fontName isEqualToString:@""] && layer.theme != nil) {
            if (layer.theme.themeType == TT_label) {
                ThemeLabel* themeLabel = (ThemeLabel*)layer.theme;
                TextStyle* style = themeLabel.mUniformStyle;
                [style setFontName:fontName];
                [[SMap singletonInstance].smMapWC.mapControl.map refresh];
                resolve([NSNumber numberWithBool:YES]);
            }
        }
        else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 获取统一标签专题图的字体
 *
 * @param layerName 图层名称
 */

RCT_REMAP_METHOD(getUniformLabelFontName, getUniformLabelFontNameWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        Layer *layer = nil;
        NSString* layerName = @"";
        int layerIndex = -1;
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
        }
        if ([array containsObject:@"LayerIndex"]) {
            NSNumber* indexValue = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = indexValue.intValue;
        }
        if ([layerName isEqualToString:@""]) {
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        } else {
            layer = [SMThemeCartography getLayerByName:layerName];
        }
        if (layer != nil && layer.theme != nil) {
            if (layer.theme.themeType == TT_label) {
                ThemeLabel* themeLabel =(ThemeLabel*)layer.theme;
                TextStyle* style = themeLabel.mUniformStyle;
                NSString* fontName = [style getFontName];
                NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
                [dic setValue:fontName forKey:@"FontName"];
                resolve(dic);
            }
        }
        else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 设置统一标签专题图的字号
 *
 * @param dataDic 单值专题图字段表达式 图层名称 图层索引
 * @param promise
 */
RCT_REMAP_METHOD(setUniformLabelFontSize, setUniformLabelFontSizeWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSString* layerName = @"";
        int layerIndex = -1;
        double fontSize = -1;
        
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
        }
        if ([array containsObject:@"LayerIndex"]) {
            NSNumber* indexValue = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = indexValue.intValue;
        }
        if ([array containsObject:@"FontSize"]) {
            NSNumber* indexValue = [dataDic objectForKey:@"FontSize"];
            fontSize = indexValue.intValue;
        }
        
        Layer* layer = nil;
        
        if ([layerName isEqualToString:@""]) {
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        } else {
            layer = [SMThemeCartography getLayerByName:layerName];
        }
        
        if (layer != nil && fontSize != -1 && layer.theme != nil) {
            if (layer.theme.themeType == TT_label) {
                ThemeLabel* themeLabel = (ThemeLabel*)layer.theme;
                TextStyle* style = themeLabel.mUniformStyle;
                [style setFontWidth:fontSize];
                [style setFontHeight:fontSize];
                [[SMap singletonInstance].smMapWC.mapControl.map refresh];
                resolve([NSNumber numberWithBool:YES]);
            }
        }
        else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 获取统一标签专题图的字号
 *
 * @param layerName 图层名称
 */

RCT_REMAP_METHOD(getUniformLabelFontSize, getUniformLabelFontSizeWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        Layer *layer = nil;
        NSString* layerName = @"";
        int layerIndex = -1;
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
        }
        if ([array containsObject:@"LayerIndex"]) {
            NSNumber* indexValue = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = indexValue.intValue;
        }
        if ([layerName isEqualToString:@""]) {
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        } else {
            layer = [SMThemeCartography getLayerByName:layerName];
        }
        if (layer != nil && layer.theme != nil) {
            if (layer.theme.themeType == TT_label) {
                ThemeLabel* themeLabel =(ThemeLabel*)layer.theme;
                TextStyle* style = themeLabel.mUniformStyle;
                double fontSize = [style getFontHeight];
                NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
                NSNumber* num = [NSNumber numberWithDouble:fontSize];;
                [dic setValue:num forKey:@"FontSize"];
                resolve(dic);
            }
        }
        else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 设置统一标签专题图的旋转角度
 *
 * @param dataDic 单值专题图字段表达式 图层名称 图层索引
 * @param promise
 */
RCT_REMAP_METHOD(setUniformLabelRotaion, setUniformLabelRotaionWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSString* layerName = @"";
        int layerIndex = -1;
        double rotation = -1;
        
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
        }
        if ([array containsObject:@"LayerIndex"]) {
            NSNumber* indexValue = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = indexValue.intValue;
        }
        if ([array containsObject:@"Rotaion"]) {
            NSNumber* indexValue = [dataDic objectForKey:@"Rotaion"];
            rotation = indexValue.intValue;
        }
        
        Layer* layer = nil;
        
        if ([layerName isEqualToString:@""]) {
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        } else {
            layer = [SMThemeCartography getLayerByName:layerName];
        }
        
        if (layer != nil && rotation != -1 && layer.theme != nil) {
            if (layer.theme.themeType == TT_label) {
                ThemeLabel* themeLabel = (ThemeLabel*)layer.theme;
                TextStyle* style = themeLabel.mUniformStyle;
                double lastRotation = [style getRotation];
                if (lastRotation == 360.0) {
                    lastRotation = 0.0;
                } else if(lastRotation == 0.0){
                    lastRotation = 360.0;
                }
                [style setRotation:(lastRotation + rotation)];
                [[SMap singletonInstance].smMapWC.mapControl.map refresh];
                resolve([NSNumber numberWithBool:YES]);
            }
        }
        else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 获取统一标签专题图的旋转角度
 *
 * @param layerName 图层名称
 */

RCT_REMAP_METHOD(getUniformLabelRotaion, getUniformLabelRotaionWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        Layer *layer = nil;
        NSString* layerName = @"";
        int layerIndex = -1;
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
        }
        if ([array containsObject:@"LayerIndex"]) {
            NSNumber* indexValue = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = indexValue.intValue;
        }
        if ([layerName isEqualToString:@""]) {
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        } else {
            layer = [SMThemeCartography getLayerByName:layerName];
        }
        if (layer != nil && layer.theme != nil) {
            if (layer.theme.themeType == TT_label) {
                ThemeLabel* themeLabel =(ThemeLabel*)layer.theme;
                TextStyle* style = themeLabel.mUniformStyle;
                double rotation = [style getRotation];
                NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
                NSNumber* num = [NSNumber numberWithDouble:rotation];;
                [dic setValue:num forKey:@"FontSize"];
                resolve(dic);
            }
        }
        else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 设置统一标签专题图的颜色
 *
 * @param dataDic 单值专题图字段表达式 图层名称 图层索引
 * @param promise
 */
RCT_REMAP_METHOD(setUniformLabelColor, setUniformLabelColorWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSString* layerName = @"";
        int layerIndex = -1;
        NSString* strColor = @"";
        
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
        }
        if ([array containsObject:@"LayerIndex"]) {
            NSNumber* indexValue = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = indexValue.intValue;
        }
        if ([array containsObject:@"Color"]) {
            strColor = [dataDic objectForKey:@"Color"];
        }
        
        Layer* layer = nil;
        
        if ([layerName isEqualToString:@""]) {
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        } else {
            layer = [SMThemeCartography getLayerByName:layerName];
        }
        
        if (layer != nil && ![strColor isEqualToString:@""] && layer.theme != nil) {
            if (layer.theme.themeType == TT_label) {
                ThemeLabel* themeLabel = (ThemeLabel*)layer.theme;
                TextStyle* style = themeLabel.mUniformStyle;
                Color* color = [STranslate colorFromHexString:strColor];
                [style setForeColor:color];
                [[SMap singletonInstance].smMapWC.mapControl.map refresh];
                resolve([NSNumber numberWithBool:YES]);
            }
        }
        else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 获取统一标签专题图的颜色
 *
 * @param layerName 图层名称
 */

RCT_REMAP_METHOD(getUniformLabelColor, getUniformLabelColorWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        Layer *layer = nil;
        NSString* layerName = @"";
        int layerIndex = -1;
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
        }
        if ([array containsObject:@"LayerIndex"]) {
            NSNumber* indexValue = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = indexValue.intValue;
        }
        if ([layerName isEqualToString:@""]) {
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        } else {
            layer = [SMThemeCartography getLayerByName:layerName];
        }
        if (layer != nil && layer.theme != nil) {
            if (layer.theme.themeType == TT_label) {
                ThemeLabel* themeLabel =(ThemeLabel*)layer.theme;
                TextStyle* style = themeLabel.mUniformStyle;
                Color* color = [style getForeColor];
                NSString* strColor = [color toColorString];
                NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
                [dic setValue:strColor  forKey:@"Color"];
                resolve(dic);
            }
        }
        else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}
/*分段专题图
 * ********************************************************************************************/
/**
 * 新建分段专题图层
 *
 * @param dataDic (数据源的索引/数据源的别名/打开本地数据源、数据集名称、 分段字段表达式、分段模式、分段参数、颜色渐变模式)
 */
RCT_REMAP_METHOD(createThemeRangeMap, createThemeRangeMapMapWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        int datasourceIndex = -1;
        NSString* datasourceAlias = @"";
        NSString* datasetName = @"";
        NSString* rangeExpression = @"";
        RangeMode rangeMode;
        bool isContainRangeMode = false;
        double rangeParameter = -1;
        ColorGradientType colorGradientType = CGT_TERRAIN;
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"DatasetName"]) {
            datasetName = [dataDic objectForKey:@"DatasetName"];
        }
        if ([array containsObject:@"RangeExpression"]) {
            rangeExpression = [dataDic objectForKey:@"RangeExpression"];
        }
        if ([array containsObject:@"RangeMode"]) {
            NSString* mode = [dataDic objectForKey:@"RangeMode"];
            rangeMode = [SMThemeCartography getRangeMode:mode];
            isContainRangeMode = true;
        }
        if ([array containsObject:@"RangeParameter"]) {
            NSNumber* num = [dataDic objectForKey:@"RangeParameter"];
            rangeParameter = num.doubleValue;
        }
        if ([array containsObject:@"ColorGradientType"]) {
            NSString* strType = [dataDic objectForKey:@"ColorGradientType"];
            colorGradientType = [SMThemeCartography getColorGradientType:strType];
        }
        Dataset *dataset = nil;
        dataset = [SMThemeCartography getDataset:datasetName data:dataDic];
        if (dataset == nil) {
            if ([array containsObject:@"DatasourceIndex"]) {
                NSNumber* index = [dataDic objectForKey:@"DatasourceIndex"];
                datasourceIndex = index.intValue;
            }
            if ([array containsObject:@"DatasourceAlias"]) {
                datasourceAlias = [dataDic objectForKey:@"DatasourceAlias"];
            }
            if ([datasourceAlias isEqualToString:@""]) {
                dataset = [SMThemeCartography getDataset:datasetName datasourceIndex:datasourceIndex];
            }
            else{
                dataset = [SMThemeCartography getDataset:datasetName datasourceAlias:datasourceAlias];
            }
        }
        bool result = false;
        if (dataset != nil && ![rangeExpression isEqualToString:@""] && isContainRangeMode && rangeParameter != -1) {
            ThemeRange* themeRange = nil;
            themeRange = [ThemeRange makeDefaultDataSet:(DatasetVector*)dataset RangeExpression:rangeExpression RangeMode:rangeMode RangeParameter:rangeParameter ColorGradientType:colorGradientType];
            if(themeRange != nil)
            {
                if ([array containsObject:@"ColorScheme"]) {
                    NSString* colorScheme = [dataDic objectForKey:@"ColorScheme"];
                    NSMutableDictionary* arrayColor = nil;
                    NSMutableArray* colorArray;
                    arrayColor = [SMThemeCartography getRangeColors:colorScheme];
                    NSArray* arrKey = [arrayColor allKeys];
                    if ([arrKey containsObject:colorScheme]) {
                    colorArray = [arrayColor objectForKey:colorScheme];
                    }
                    if (colorArray != nil) {
                        int rangeCount = [themeRange getCount];
                        Colors* selectedColors = [Colors makeGradient:rangeCount gradientColorArray:colorArray];
                        for (int i = 0; i < rangeCount; i++) {
                            [SMThemeCartography setGeoStyleColor:dataset.datasetType geoStyle:[themeRange getItem:i].mStyle color:[selectedColors get:i]];
                        }
                    }
                }
                [[SMap singletonInstance].smMapWC.mapControl.map.layers addDataset:dataset Theme:themeRange ToHead:true];
                [[SMap singletonInstance].smMapWC.mapControl.map refresh];
                result = true;
            }
        }
        resolve([NSNumber numberWithBool:result]);
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 修改分段专题图层
 *
 * @param dataDic (数据源的索引/数据源的别名/打开本地数据源、数据集名称、 分段字段表达式、分段模式、分段参数、颜色渐变模式)
 */
RCT_REMAP_METHOD(modifyThemeRangeMap, modifyThemeRangeMapWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSString* rangeExpression = @"";
        RangeMode rangeMode;
        bool isContainRangeMode = false;
        double rangeParameter = -1;
        ColorGradientType colorGradientType;
        bool isContainColorGradientType = false;
        NSString* layerName = @"";
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
        }
        Layer* themeRangeLayer = nil;
        themeRangeLayer = [SMThemeCartography getLayerByName:layerName];
        Dataset *dataset = nil;
        if (themeRangeLayer != nil) {
            dataset = themeRangeLayer.dataset;
        }
        
        ThemeRange* themeRange = nil;
        if (themeRangeLayer != nil && themeRangeLayer.theme != nil && themeRangeLayer.theme.themeType == TT_Range) {
            themeRange = (ThemeRange*)themeRangeLayer.theme;
        }
        if ([array containsObject:@"RangeExpression"]) {
            rangeExpression = [dataDic objectForKey:@"RangeExpression"];
        }
        else{
            if (themeRange != nil) {
                rangeExpression = [themeRange getRangeExpression];
            }
        }
        if ([array containsObject:@"RangeMode"]) {
            NSString* mode = [dataDic objectForKey:@"RangeMode"];
            rangeMode = [SMThemeCartography getRangeMode:mode];
            isContainRangeMode = true;
        }
        else
        {
            if (themeRange != nil) {
                rangeMode = themeRange.mRangeMode;
                isContainRangeMode = true;
            }
        }
        if ([array containsObject:@"RangeParameter"]) {
            NSNumber* num = [dataDic objectForKey:@"RangeParameter"];
            rangeParameter = num.doubleValue;
        }
        else{
            if (themeRange != nil) {
                rangeParameter = [themeRange getCount];
            }
        }
        if ([array containsObject:@"ColorGradientType"]) {
            NSString* strType = [dataDic objectForKey:@"ColorGradientType"];
            colorGradientType = [SMThemeCartography getColorGradientType:strType];
            isContainColorGradientType = true;
        }
        else
        {
            colorGradientType = CGT_GREENWHITE;
            isContainColorGradientType = true;
        }
        bool result = false;

        if (dataset != nil && themeRangeLayer.theme != nil && ![rangeExpression isEqualToString:@""] && isContainRangeMode && rangeParameter != -1 && isContainColorGradientType) {
            ThemeRange* themeRange = nil;
            themeRange = [ThemeRange makeDefaultDataSet:(DatasetVector*)dataset RangeExpression:rangeExpression RangeMode:rangeMode RangeParameter:rangeParameter ColorGradientType:colorGradientType];
            if(themeRange != nil)
            {
                if(![array containsObject:@"ColorGradientType"]){
                    NSMutableArray* mulArray = nil;
                    mulArray =  [SMThemeCartography getLastThemeColors:themeRangeLayer];
                    if (mulArray != nil) {
                        int rangeCount = [themeRange getCount];
                        Colors* selectedColors = [Colors makeGradient:rangeCount gradientColorArray:mulArray];
                        for (int i = 0; i < rangeCount; i++) {
                            [SMThemeCartography setGeoStyleColor:dataset.datasetType geoStyle:[themeRange getItem:i].mStyle color:[selectedColors get:i]];
                        }
                    }
                }
                
                [themeRangeLayer.theme fromXML:[themeRange toXML]];
                [[SMap singletonInstance].smMapWC.mapControl.map refresh];
                result = true;
            }
        }
        resolve([NSNumber numberWithBool:result]);
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 设置单值专题图颜色方案
 *
 * @param dataDic 单值专题图字段表达式 图层名称 图层索引
 * @param promise
 */
RCT_REMAP_METHOD(setUniqueColorScheme, setUniqueColorSchemeWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSString* layerName = @"";
        int layerIndex = -1;
        NSString* strColor = @"";
        
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
        }
        if ([array containsObject:@"LayerIndex"]) {
            NSNumber* indexValue = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = indexValue.intValue;
        }
        NSMutableDictionary* arrayColor = nil;
        NSMutableArray* colorArray;
        if ([array containsObject:@"ColorScheme"]) {
            strColor = [dataDic objectForKey:@"ColorScheme"];
            arrayColor = [SMThemeCartography getUniqueColors:strColor];
            NSArray* arrKey = [arrayColor allKeys];
            if ([arrKey containsObject:strColor]) {
                colorArray = [arrayColor objectForKey:strColor];
            }
        }
        
        Layer* layer = nil;
        
        if ([layerName isEqualToString:@""]) {
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        } else {
            layer = [SMThemeCartography getLayerByName:layerName];
        }
        
        if (layer != nil && arrayColor != nil && layer.theme != nil) {
            if (layer.theme.themeType == TT_Unique) {
                ThemeUnique* themeUnique = (ThemeUnique*)layer.theme;
                int rangeCount = [themeUnique getCount];
                Colors* selectedColors = [Colors makeGradient:rangeCount gradientColorArray:colorArray];
                for (int i = 0; i < rangeCount; i++) {
                    [SMThemeCartography setGeoStyleColor:layer.dataset.datasetType geoStyle:[themeUnique getItem:i].mStyle color:[selectedColors get:i]];
                }
                [[SMap singletonInstance].smMapWC.mapControl.map refresh];
                resolve([NSNumber numberWithBool:YES]);
            }
        }
        else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 设置分段专题图颜色方案
 *
 * @param dataDic 单值专题图字段表达式 图层名称 图层索引
 * @param promise
 */
RCT_REMAP_METHOD(setRangeColorScheme, setRangeColorSchemeWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSString* layerName = @"";
        int layerIndex = -1;
        NSString* strColor = @"";
        
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
        }
        if ([array containsObject:@"LayerIndex"]) {
            NSNumber* indexValue = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = indexValue.intValue;
        }
        NSMutableDictionary* arrayColor = nil;
        NSMutableArray* colorArray;
        if ([array containsObject:@"ColorScheme"]) {
            strColor = [dataDic objectForKey:@"ColorScheme"];
            arrayColor = [SMThemeCartography getRangeColors:strColor];
            NSArray* arrKey = [arrayColor allKeys];
            if ([arrKey containsObject:strColor]) {
                colorArray = [arrayColor objectForKey:strColor];
            }
        }
        
        Layer* layer = nil;
        
        if ([layerName isEqualToString:@""]) {
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        } else {
            layer = [SMThemeCartography getLayerByName:layerName];
        }
        
        if (layer != nil && arrayColor != nil && layer.theme != nil) {
            if (layer.theme.themeType == TT_Range) {
                ThemeRange* themeUnique = (ThemeRange*)(layer.theme);
                int rangeCount = [themeUnique getCount];
                Colors* selectedColors = [Colors makeGradient:rangeCount gradientColorArray:colorArray];
                for (int i = 0; i < rangeCount; i++) {
                    [SMThemeCartography setGeoStyleColor:layer.dataset.datasetType geoStyle:[themeUnique getItem:i].mStyle color:[selectedColors get:i]];
                }
                [[SMap singletonInstance].smMapWC.mapControl.map refresh];
                resolve([NSNumber numberWithBool:YES]);
            }
        }
        else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 设置分段专题图的分段字段表达式
 *
 * @param dataDic 单值专题图字段表达式 图层名称 图层索引
 * @param promise
 */
RCT_REMAP_METHOD(setRangeExpression, setRangeExpressionWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSString* layerName = @"";
        int layerIndex = -1;
        NSString* rangeExpression = @"";
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
        }
        if ([array containsObject:@"RangeExpression"]) {
            rangeExpression = [dataDic objectForKey:@"RangeExpression"];
        }
        if ([array containsObject:@"LayerIndex"]) {
            NSNumber* indexValue = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = indexValue.intValue;
        }
        
        Layer* layer = nil;
        
        if ([layerName isEqualToString:@""]) {
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        } else {
            layer = [SMThemeCartography getLayerByName:layerName];
        }
        
        if (layer != nil && ![rangeExpression isEqualToString:@""] && layer.theme != nil) {
            if (layer.theme.themeType == TT_Range) {
                ThemeRange* themeLabel = (ThemeRange*)layer.theme;
                [themeLabel setRangeExpression:rangeExpression];
                [[SMap singletonInstance].smMapWC.mapControl.map refresh];
                resolve([NSNumber numberWithBool:YES]);
            }
        }
        else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 获取分段专题图的分段字段表达式
 *
 * @param dataDic 单值专题图字段表达式 图层名称 图层索引
 * @param promise
 */
RCT_REMAP_METHOD(getRangeExpression, getRangeExpressionWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSString* layerName = @"";
        int layerIndex = -1;
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
        }
        if ([array containsObject:@"LayerIndex"]) {
            NSNumber* indexValue = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = indexValue.intValue;
        }
        
        Layer* layer = nil;
        
        if ([layerName isEqualToString:@""]) {
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        } else {
            layer = [SMThemeCartography getLayerByName:layerName];
        }
        
        if (layer != nil && layer.theme != nil) {
            if (layer.theme.themeType == TT_Range) {
                ThemeRange* themeLabel = (ThemeRange*)layer.theme;
                resolve([themeLabel getRangeExpression]);
            }
        }
        else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}
/*栅格分段专题图
 * ********************************************************************************************/

/**
 * 获取数据集中的字段
 * @param udbPath UDB在内存中路径
 * @param datasetName 数据集名称
 */
RCT_REMAP_METHOD(getThemeExpressByUdb, getThemeExpressByUdbWithResolver:(NSString*)udbPath datasetName:(NSString*)datasetName resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        SMMapWC *smMapWC = [SMap singletonInstance].smMapWC;
        [smMapWC.mapControl.map setWorkspace:smMapWC.workspace];
        DatasourceConnectionInfo* datasourceConnection = [[DatasourceConnectionInfo alloc] init];
        if ([smMapWC.mapControl.map.workspace.datasources indexOf:@"switchudb"] != -1) {
            [smMapWC.mapControl.map.workspace.datasources closeAlias:@"switchudb"];
        }
        [datasourceConnection setEngineType:ET_UDB];
        [datasourceConnection setServer:udbPath];
        [datasourceConnection setAlias:@"switchudb"];
        Datasource* datasource = [smMapWC.mapControl.map.workspace.datasources open:datasourceConnection];
        Datasets* datasets = datasource.datasets;
        DatasetVector* datasetVector = (DatasetVector*)[datasets getWithName:datasetName];
        FieldInfos* fieldInfos = datasetVector.fieldInfos;
        NSMutableArray* array = [[NSMutableArray alloc]init];
        NSInteger count = fieldInfos.count;
        for(int i = 0; i < count; i++)
        {
            FieldInfo* fieldinfo = [fieldInfos get:i];
            NSString* strName = fieldinfo.name;
            NSMutableDictionary* info = [[NSMutableDictionary alloc] init];
            [info setObject:(strName) forKey:(@"title")];
            [array addObject:info];
        }
        [datasourceConnection dispose];
        resolve(array);
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}
/**
 * 获取数据集中的字段
 * @param layerName 图层名称
 */
RCT_REMAP_METHOD(getThemeExpressionByLayerName, getThemeExpressionByLayerNameWithResolver:(NSString*)layerName resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        Layers *layers = [SMap singletonInstance].smMapWC.mapControl.map.layers;
        Dataset* dataset = [layers getLayerWithName:layerName].dataset;
        DatasetVector* datasetVector = (DatasetVector*)dataset;
        FieldInfos* fieldInfos = datasetVector.fieldInfos;
        NSMutableArray* array = [[NSMutableArray alloc]init];
        NSInteger count = fieldInfos.count;
        for(int i = 0; i < count; i++)
        {
            FieldInfo* fieldinfo = [fieldInfos get:i];
            NSString* strName = fieldinfo.name;
            NSMutableDictionary* info = [[NSMutableDictionary alloc] init];
            [info setObject:(strName) forKey:(@"title")];
            [array addObject:info];
        }
        
        NSMutableDictionary* mulDic2 = [[NSMutableDictionary alloc] init];
        NSString* datasetName = dataset.name;
        [mulDic2 setValue:datasetName forKey:@"datasetName"];
        NSString* datasetType = [SMThemeCartography datasetTypeToString:dataset.datasetType];
        [mulDic2 setValue:datasetType forKey:@"datasetType"];
        
        NSMutableDictionary* mulDic3 =[[NSMutableDictionary alloc] init];
        [mulDic3 setValue:array forKey:@"list"];
        [mulDic3 setValue:mulDic2 forKey:@"dataset"];
        
        resolve(mulDic3);
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 获取数据集中的字段
 * @param layerIndex 图层索引
 * @param promise
 */

RCT_REMAP_METHOD(getThemeExpressionByLayerIndex, getThemeExpressionByLayerIndexWithResolver:(int)layerIndex resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        Layers *layers = [SMap singletonInstance].smMapWC.mapControl.map.layers;
        Dataset* dataset = [layers getLayerAtIndex:layerIndex].dataset;
        DatasetVector* datasetVector = (DatasetVector*)dataset;
        FieldInfos* fieldInfos = datasetVector.fieldInfos;
        NSMutableArray* array = [[NSMutableArray alloc]init];
        NSInteger count = fieldInfos.count;
        for(int i = 0; i < count; i++)
        {
            FieldInfo* fieldinfo = [fieldInfos get:i];
            NSString* strName = fieldinfo.name;
            NSMutableDictionary* info = [[NSMutableDictionary alloc] init];
            [info setObject:(strName) forKey:(@"title")];
            [array addObject:info];
        }
        NSMutableDictionary* mulDic2 = [[NSMutableDictionary alloc] init];
        NSString* datasetName = dataset.name;
        [mulDic2 setValue:datasetName forKey:@"datasetName"];
        NSString* datasetType = [SMThemeCartography datasetTypeToString:dataset.datasetType];
        [mulDic2 setValue:datasetType forKey:@"datasetType"];
        
        NSMutableDictionary* mulDic3 =[[NSMutableDictionary alloc] init];
        [mulDic3 setValue:array forKey:@"list"];
        [mulDic3 setValue:mulDic2 forKey:@"dataset"];
        
        resolve(mulDic3);
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 获取数据集中的字段
 * @param layerIndex 图层索引
 * @param promise
 */

RCT_REMAP_METHOD(getThemeExpressionByDatasetName, getThemeExpressionByDatasetNameWithResolver:(NSString*)datasourceAlias datasetName:(NSString*)datasetName resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        Datasources* datasources = [SMap singletonInstance].smMapWC.workspace.datasources;
        Datasource* datasource = [datasources getAlias:datasourceAlias];
        Datasets* datasets = datasource.datasets;
        Dataset* dataset = [datasets getWithName:datasetName];
        DatasetVector* datasetVector = (DatasetVector*)dataset;
        FieldInfos* fieldInfos = datasetVector.fieldInfos;
        NSMutableArray* array = [[NSMutableArray alloc]init];
        NSInteger count = fieldInfos.count;
        for(int i = 0; i < count; i++)
        {
            FieldInfo* fieldinfo = [fieldInfos get:i];
            NSString* strName = fieldinfo.name;
            NSMutableDictionary* info = [[NSMutableDictionary alloc] init];
            [info setObject:(strName) forKey:(@"title")];
            [array addObject:info];
        }
        NSMutableDictionary* mulDic2 = [[NSMutableDictionary alloc] init];
        NSString* datasetName = dataset.name;
        [mulDic2 setValue:datasetName forKey:@"datasetName"];
        NSString* datasetType = [SMThemeCartography datasetTypeToString:dataset.datasetType];
        [mulDic2 setValue:datasetType forKey:@"datasetType"];
        
        NSMutableDictionary* mulDic3 =[[NSMutableDictionary alloc] init];
        [mulDic3 setValue:array forKey:@"list"];
        [mulDic3 setValue:mulDic2 forKey:@"dataset"];
        
        resolve(mulDic3);
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 获取数据集中的表达式
 * @param layerIndex 图层索引
 * @param promise
 */

RCT_REMAP_METHOD(getThemeExpressByDatasetName, getThemeExpressByDatasetNameWithResolver:(NSString*)datasourceAlias datasetName:(NSString*)datasetName resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        Datasources* datasources = [SMap singletonInstance].smMapWC.workspace.datasources;
        Datasource* datasource = [datasources getAlias:datasourceAlias];
        Datasets* datasets = datasource.datasets;
        Dataset* dataset = [datasets getWithName:datasetName];
        DatasetVector* datasetVector = (DatasetVector*)dataset;
        FieldInfos* fieldInfos = datasetVector.fieldInfos;
        NSMutableArray* array = [[NSMutableArray alloc]init];
        NSInteger count = fieldInfos.count;
        for(int i = 0; i < count; i++)
        {
            FieldInfo* fieldinfo = [fieldInfos get:i];
            NSString* strName = fieldinfo.name;
            NSMutableDictionary* info = [[NSMutableDictionary alloc] init];
            [info setObject:(strName) forKey:(@"title")];
            [array addObject:info];
        }
        NSMutableDictionary* mulDic2 = [[NSMutableDictionary alloc] init];
        NSString* datasetName = dataset.name;
        [mulDic2 setValue:datasetName forKey:@"datasetName"];
        NSString* datasetType = [SMThemeCartography datasetTypeToString:dataset.datasetType];
        [mulDic2 setValue:datasetType forKey:@"datasetType"];
        
        NSMutableDictionary* mulDic3 =[[NSMutableDictionary alloc] init];
        [mulDic3 setValue:array forKey:@"list"];
        [mulDic3 setValue:mulDic2 forKey:@"dataset"];
        
        resolve(mulDic3);
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 获取所有数据源中的数据集
 * @param layerIndex 图层索引
 * @param promise
 */

RCT_REMAP_METHOD(getAllDatasetNames, ggetAllDatasetNamesWithResolver:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        Datasources* datasources = [SMap singletonInstance].smMapWC.workspace.datasources;
        NSInteger datasourcesCount = datasources.count;
        NSMutableArray* array = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < datasourcesCount; i++) {
            Datasource* datasource = [datasources get:i];
            Datasets* datasets = datasource.datasets;
            NSInteger datasetCount = datasets.count;
            NSMutableArray* array2 = [[NSMutableArray alloc] init];
            for (NSInteger j = 0; j < datasetCount; j++) {
                NSMutableDictionary* mulDic2 = [[NSMutableDictionary alloc] init];
                [mulDic2 setValue:[datasets get:j].name forKey:@"datasetName"];
                NSString *strType = [SMThemeCartography datasetTypeToString:[datasets get:j].datasetType];
                [mulDic2 setValue:strType forKey:@"datasetType"];
                [mulDic2 setValue:datasource.alias forKey:@"datasourceName"];
                [array2 addObject:mulDic2];
            }
            NSMutableDictionary* mulDic3 = [[NSMutableDictionary alloc] init];
            [mulDic3 setValue:datasource.alias forKey:@"alias"];
            NSMutableDictionary* mulDic4 = [[NSMutableDictionary alloc] init];
            [mulDic4 setValue:array2 forKey:@"list"];
            [mulDic4 setValue:mulDic3 forKey:@"datasource"];
            
            [array addObject:mulDic4];
        }
        resolve(array);
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}
@end

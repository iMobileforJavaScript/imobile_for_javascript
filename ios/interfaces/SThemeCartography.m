//
//  SThemeCartography.m
//  Supermap
//  专题制图
//  Created by xianglong li on 2018/12/7.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "SThemeCartography.h"
#import "SMThemeCartography.h"
#import "STranslate.h"
#import "SMap.h"

//static NSMutableArray* _lastColorUniqueArray = nil;
//static NSMutableArray* _lastColorRangeArray = nil;
static NSMutableArray* _lastColorGraphArray = nil;

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
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [[mapControl getEditHistory] addMapHistory];
        
        int datasourceIndex = 0;
        NSString* datasourceAlias = @"";
        NSString* datasetName = @"";
        NSString* uniqueExpression = @"";
        ColorGradientType colorGradientType;//默认
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
        else{
            colorGradientType = CGT_GREENWHITE;
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
            if (![datasourceAlias isEqualToString:@""]) {
                dataset = [SMThemeCartography getDataset:datasetName datasourceAlias:datasourceAlias];
            }
            else{
                dataset = [SMThemeCartography getDataset:datasetName datasourceIndex:datasourceIndex];
            }
        }
        if (dataset != nil && ![uniqueExpression isEqualToString:@""]) {
            ThemeUnique* themeUnique = [ThemeUnique makeDefault:(DatasetVector*)dataset uniqueExpression:uniqueExpression colorType:colorGradientType];
            if ([array containsObject:@"ColorScheme"]) {
                NSString* colorScheme = [dataDic objectForKey:@"ColorScheme"];
                NSMutableDictionary* arrayColor = nil;
                NSArray* colorArray;
                colorArray = [SMThemeCartography getUniqueColors:colorScheme];
                if (colorArray != nil) {
                    int rangeCount = [themeUnique getCount];
                    Colors* selectedColors = [Colors makeGradient:rangeCount gradientColorArray:colorArray];
                    for (int i = 0; i < rangeCount; i++) {
                        [SMThemeCartography setGeoStyleColor:dataset.datasetType geoStyle:[themeUnique getItem:i].mStyle color:[selectedColors get:i]];
                    }
//                    _lastColorUniqueArray = colorArray;
                }
            }
            else{
//                _lastColorUniqueArray = nil;
            }
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
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [[mapControl getEditHistory] addMapHistory];
        
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
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [[mapControl getEditHistory] addMapHistory];
        
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
        if (dataset != nil && themeUniqueLayer.theme != nil && ![uniqueExpression isEqualToString:@""] && ![uniqueExpression isEqualToString:[themeUnique getUniqueExpression] ]) {
            ThemeUnique* tu = nil;
            tu = [ThemeUnique makeDefault:(DatasetVector*)dataset uniqueExpression:uniqueExpression colorType:colorGradientType];
            NSMutableArray* _lastColorUniqueArray;
            if (tu != nil) {
                if(![array containsObject:@"ColorGradientType"]){

                    if(_lastColorUniqueArray==nil){
                        _lastColorUniqueArray = [NSMutableArray array];
                        for (int i = 0; i < [themeUnique getCount]; i++) {
                            Color* color = [SMThemeCartography getGeoStyleColor:dataset.datasetType geoStyle:[themeUnique getItem:i].mStyle];//
                            [_lastColorUniqueArray addObject:color];
                        }
                    }
                }
                [themeUnique fromXML:[tu toXML]];
                
                
                for (int i = 0; i < [themeUnique getCount]; i++) {
                    int k = arc4random() % _lastColorUniqueArray.count ;
                    Color* color = _lastColorUniqueArray[k];//[SMThemeCartography getGeoStyleColor:dataset.datasetType geoStyle:[themeRange getItem:i].mStyle];//
                    [SMThemeCartography setGeoStyleColor:dataset.datasetType geoStyle:[themeUnique getItem:i].mStyle color:color];
                }
                
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
            MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
            [[mapControl getEditHistory] addMapHistory];
            
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
                MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
                [[mapControl getEditHistory] addMapHistory];
                
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
                MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
                [[mapControl getEditHistory] addMapHistory];
                
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
            MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
            [[mapControl getEditHistory] addMapHistory];
            
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

RCT_REMAP_METHOD(getUniqueExpression, getUniqueExpressionWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
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
            MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
            [[mapControl getEditHistory] addMapHistory];
            
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
 * 新建单值标签图层
 *
 * @param readableMap (数据源的索引/数据源的别名/打开本地数据源、数据集名称、 分段字段表达式、分段模式、分段参数、颜色渐变模式)
 * @param promise
 */
RCT_REMAP_METHOD(createUniqueThemeLabelMap, createUniqueThemeLabelMapWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [[mapControl getEditHistory] addMapHistory];
        
        int datasourceIndex = -1;
        NSString* datasourceAlias = @"";
        NSString* datasetName = @"";
        NSString* uniqueExpression = @"";//单值字段表达式
        //RangeMode rangeMode = RM_None;//分段模式
        //double rangeParameter = -1;//分段参数
        ColorGradientType colorGradientType = CGT_NULL;
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"DatasetName"]) {
            datasetName = [dataDic objectForKey:@"DatasetName"];
        }
        if ([array containsObject:@"UniqueExpression"]) {
            uniqueExpression = [dataDic objectForKey:@"UniqueExpression"];
        }
        
        if ([array containsObject:@"ColorGradientType"]){
            NSString* type = [dataDic objectForKey: @"ColorGradientType" ];
            colorGradientType = [SMThemeCartography getColorGradientType:type];
        } else {
            colorGradientType = CGT_YELLOWBLUE;
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
        BOOL result = false;
        if (dataset != nil && ![uniqueExpression isEqualToString:@""]) {
            JoinItems *joinItems = nil;
            ThemeLabel *themeLabel = [ThemeLabel makeDefault:(DatasetVector*)dataset uniqueExpression:uniqueExpression colorGradientType:colorGradientType joinItems:joinItems];
            
            if (themeLabel!=nil) {
                [themeLabel setLabelExpression:uniqueExpression];
                [themeLabel setIsFlowEnabled:YES];
                if([array containsObject:@"ColorScheme"]){
                    NSString *strColorScheme = [dataDic objectForKey:@"ColorScheme"];
                    NSArray* uniqueColors = [SMThemeCartography getUniqueColors:strColorScheme];
                    if (uniqueColors!=nil) {
                        int count = [themeLabel getUniqueCount];
                        Colors* selectedColors;
                        if (count>0) {
                            selectedColors = [Colors makeGradient:count gradientColorArray:uniqueColors];
                        }else{
                             selectedColors = [Colors makeGradient:1 gradientColorArray:uniqueColors];
                        }
                        
                        for (int i=0; i<count; i++) {
                            [[[themeLabel getUniqueItem:i] textStyle] setForeColor:[selectedColors get:i]];
                        }
                    }
                
                }
                [mapControl.map.layers addDataset:dataset Theme:themeLabel ToHead:YES];
                [mapControl.map refresh];
                result = true;
            }
            
            resolve([NSNumber numberWithBool:result]);
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
 * 获取单值标签专题图的字段表达式
 *
 * @param layerName 图层名称
 */

RCT_REMAP_METHOD(getUniqueLabelExpression, getUniqueLabelExpressionWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
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
                NSString* strExpression = @"";
                strExpression = [themeLabel uniqueExpression];
                if(strExpression!=nil && strExpression.length>0){
                    resolve(strExpression);
                    return;
                }
            }
        }

        resolve([NSNumber numberWithBool:NO]);
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 设置单值标签专题图字段单值字段
 *
 * @param dataDic 单值专题图字段表达式 图层名称 图层索引
 * @param promise
 */
RCT_REMAP_METHOD(setUniqueLabelExpression, setUniqueLabelExpressionWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSString* layerName = @"";
        int layerIndex = -1;
        NSString* labelExpression = @"";
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
        }
        if ([array containsObject:@"UniqueExpression"]) {
            labelExpression = [dataDic objectForKey:@"UniqueExpression"];
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
                MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
                [[mapControl getEditHistory] addMapHistory];
                
                ThemeLabel* themeLabel = (ThemeLabel*)layer.theme;
                [themeLabel setUniqueExpression:labelExpression];
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
 * 设置单值标签专题图颜色方案
 *
 * @param dataDic 单值专题图字段表达式 图层名称 图层索引
 * @param promise
 */
RCT_REMAP_METHOD(setUniqueLabelColorScheme, setUniqueLabelColorSchemeWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
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
        
        NSArray* colorArray = nil;
        if ([array containsObject:@"ColorScheme"]) {
            strColor = [dataDic objectForKey:@"ColorScheme"];
            colorArray = [SMThemeCartography getUniqueColors:strColor];
        }
        
        Layer* layer = nil;
        
        if ([layerName isEqualToString:@""]) {
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        } else {
            layer = [SMThemeCartography getLayerByName:layerName];
        }
        
        if (layer != nil && colorArray != nil && layer.theme != nil) {
            if (layer.theme.themeType == TT_label) {
                MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
                [[mapControl getEditHistory] addMapHistory];
                
                ThemeLabel* themeLabel = (ThemeLabel*)layer.theme;
                int rangeCount = [themeLabel getUniqueCount];
                Colors* selectedColors = [Colors makeGradient:rangeCount gradientColorArray:colorArray];
                for (int i = 0; i < rangeCount; i++) {
                    [[[themeLabel getUniqueItem:i] textStyle] setForeColor:[selectedColors get:i]];
                }
                //_lastColorUniqueArray = colorArray;
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
 * 新建分段标签图层
 *
 * @param readableMap (数据源的索引/数据源的别名/打开本地数据源、数据集名称、 分段字段表达式、分段模式、分段参数、颜色渐变模式)
 * @param promise
 */
RCT_REMAP_METHOD(createRangeThemeLabelMap, createRangeThemeLabelMapWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [[mapControl getEditHistory] addMapHistory];
        
        int datasourceIndex = -1;
        NSString* datasourceAlias = @"";
        NSString* datasetName = @"";
        NSString* rangeExpression = @"";//分段字段表达式
        RangeMode rangeMode = RM_None;//分段模式
        double rangeParameter = -1;//分段参数
        ColorGradientType colorGradientType = CGT_NULL;
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"DatasetName"]) {
            datasetName = [dataDic objectForKey:@"DatasetName"];
        }
        if ([array containsObject:@"RangeExpression"]) {
            rangeExpression = [dataDic objectForKey:@"RangeExpression"];
        }
        if ([array containsObject:@"RangeMode"]) {
            NSString* type = [dataDic objectForKey:@"RangeMode"];
            rangeMode = [SMThemeCartography getRangeMode:type];
        }
        if ([array containsObject:@"RangeParameter"]) {
            NSString* param = [dataDic objectForKey:@"RangeParameter"];
            rangeParameter = [param doubleValue];
        }
        if ([array containsObject:@"ColorGradientType"]){
            NSString* type = [dataDic objectForKey: @"ColorGradientType" ];
            colorGradientType = [SMThemeCartography getColorGradientType:type];
        } else {
            colorGradientType = CGT_YELLOWGREEN;
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
        BOOL result = false;
        if (dataset != nil && ![rangeExpression isEqualToString:@""] && rangeMode!=RM_None && rangeParameter!=-1) {
            JoinItems *joinItems = nil;
            ThemeLabel *themeLabel = [ThemeLabel makeDefault:(DatasetVector*)dataset rangeExpression:rangeExpression rangeMode:rangeMode rangeParameter:5 colorGradientType:colorGradientType];
            
            if (themeLabel!=nil) {
                [themeLabel setMaxLabelLength:8];
                [themeLabel setLabelExpression:rangeExpression];
                //themeLabel.setNumericPrecision(1);
                //themeLabel.setFlowEnabled(true); 组件无接口
                if([array containsObject:@"ColorScheme"]){
                    NSString *strColorScheme = [dataDic objectForKey:@"ColorScheme"];
                    NSArray* rangeColors = [SMThemeCartography getRangeColors:strColorScheme];
                    if (rangeColors!=nil) {
                        int rangecount = [themeLabel getRangeCount];
                        Colors* selectedColors;
                        if (rangecount>0) {
                            selectedColors = [Colors makeGradient:rangecount gradientColorArray:rangeColors];
                        }else{
                            selectedColors = [Colors makeGradient:1 gradientColorArray:rangeColors];
                        }
                        
                        for (int i=0; i<rangecount; i++) {
                            [[[themeLabel getRangeItem:i] mTextStyle] setForeColor:[selectedColors get:i]];
                        }
                        
                    }
                }
                [mapControl.map.layers addDataset:dataset Theme:themeLabel ToHead:YES];
                [mapControl.map refresh];
                result = true;
            }
            
            resolve([NSNumber numberWithBool:result]);
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
 * 获取分段标签专题图的字段分段表达式
 *
 * @param layerName 图层名称
 */

RCT_REMAP_METHOD(getRangeLabelExpression, getRangeLabelExpressionWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
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
                NSString* strExpression = @"";
                strExpression = [themeLabel rangeExpression];
                if(strExpression!=nil && strExpression.length>0){
                    resolve(strExpression);
                    return;
                }
            }
        }
        
        resolve([NSNumber numberWithBool:NO]);
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 设置分段标签专题图颜色方案
 *
 * @param dataDic 单值专题图字段表达式 图层名称 图层索引
 * @param promise
 */
RCT_REMAP_METHOD(setRangeLabelColorScheme, setRangeLabelColorSchemeWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
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
        
        NSArray* colorArray = nil;
        if ([array containsObject:@"ColorScheme"]) {
            strColor = [dataDic objectForKey:@"ColorScheme"];
            colorArray = [SMThemeCartography getRangeColors:strColor];
        }
        
        Layer* layer = nil;
        
        if ([layerName isEqualToString:@""]) {
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        } else {
            layer = [SMThemeCartography getLayerByName:layerName];
        }
        
        if (layer != nil && colorArray != nil && layer.theme != nil) {
            if (layer.theme.themeType == TT_label) {
                MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
                [[mapControl getEditHistory] addMapHistory];
                
                ThemeLabel* themeLabel = (ThemeLabel*)layer.theme;
                int rangeCount = [themeLabel getRangeCount];
                Colors* selectedColors = [Colors makeGradient:rangeCount gradientColorArray:colorArray];
                for (int i = 0; i < rangeCount; i++) {
                    [[[themeLabel getRangeItem:i] mTextStyle] setForeColor:[selectedColors get:i]];
                }
                //_lastColorUniqueArray = colorArray;
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
 * 设置分段标签专题图字段分段表达式
 *
 * @param dataDic 单值专题图字段表达式 图层名称 图层索引
 * @param promise
 */
RCT_REMAP_METHOD(setRangeLabelExpression, setRangeLabelExpressionWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSString* layerName = @"";
        int layerIndex = -1;
        NSString* labelExpression = @"";
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
        }
        if ([array containsObject:@"RangeExpression"]) {
            labelExpression = [dataDic objectForKey:@"RangeExpression"];
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
                MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
                [[mapControl getEditHistory] addMapHistory];
                
                ThemeLabel* themeLabel = (ThemeLabel*)layer.theme;
                [themeLabel setRangeExpression:labelExpression];
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
 * 新建统一标签专题图
 *
 * @param layerName 图层名称
 */
RCT_REMAP_METHOD(createUniformThemeLabelMap, createUniformThemeLabelMapWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [[mapControl getEditHistory] addMapHistory];
        
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
                MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
                [[mapControl getEditHistory] addMapHistory];
                
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
                ThemeLabel* themeLabel =(ThemeLabel*)layer.theme;
                NSString* strExpression = @"";
                strExpression = [themeLabel labelExpression];
                resolve(strExpression);
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
                MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
                [[mapControl getEditHistory] addMapHistory];
                
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
                MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
                [[mapControl getEditHistory] addMapHistory];
                
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
//                MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
//                [[mapControl getEditHistory] addMapHistory];
                
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
                MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
                [[mapControl getEditHistory] addMapHistory];
                
                ThemeLabel* themeLabel = (ThemeLabel*)layer.theme;
                int count = [themeLabel getUniqueCount];// getUniqueItems().getCount();
                if(count == 0){
                    TextStyle* uniformStyle = themeLabel.mUniformStyle;
                    if([fontName isEqualToString:@"BOLD"]){
                        if([uniformStyle isBold]){
                            [uniformStyle setBold:false];
                        }
                        else{
                            [uniformStyle setBold:true];
                        }
                    }else if([fontName isEqualToString:@"ITALIC"]){
                        if([uniformStyle getItalic]){
                            [uniformStyle setItalic:false];
                        }else{
                            [uniformStyle setItalic:true];
                        }
                        
                    }else if([fontName isEqualToString:@"UNDERLINE"]){
                        if([uniformStyle getUnderline]){
                            [uniformStyle setUnderline:false];
                        }else{
                            [uniformStyle setUnderline:true];
                        }
                    }else if([fontName isEqualToString:@"STRIKEOUT"]){
                        if([uniformStyle getStrikeout]){
                            [uniformStyle setStrikeout:false];
                        }else{
                            [uniformStyle setStrikeout:true];
                        }
                    }else if([fontName isEqualToString:@"SHADOW"]){
                        if([uniformStyle getShadow]){
                            [uniformStyle setShadow:false];
                        }else{
                            [uniformStyle setShadow:true];
                        }
                    }else if([fontName isEqualToString:@"OUTLINE"] ){
                        if([uniformStyle getOutline]){
                            [uniformStyle setOutline:false];
                        }else{
                            [uniformStyle setOutline:YES];
                            [uniformStyle setBackColor:[[Color alloc]initWithR:255 G:255 B:255]];
                            //                            uniformStyle.set
                        }
                    }
                }else{
                    for (int i = 0; i < count; i++) {
                        TextStyle* uniformStyle = [themeLabel getUniqueItem:i].textStyle;//.getUniqueItems().getItem(i).getStyle();
                      
                        if([fontName isEqualToString:@"BOLD"]){
                            if([uniformStyle isBold]){
                                [uniformStyle setBold:false];
                            }
                            else{
                                [uniformStyle setBold:true];
                            }
                        }else if([fontName isEqualToString:@"ITALIC"]){
                            if([uniformStyle getItalic]){
                                [uniformStyle setItalic:false];
                            }else{
                                [uniformStyle setItalic:true];
                            }
                            
                        }else if([fontName isEqualToString:@"UNDERLINE"]){
                            if([uniformStyle getUnderline]){
                                [uniformStyle setUnderline:false];
                            }else{
                                [uniformStyle setUnderline:true];
                            }
                        }else if([fontName isEqualToString:@"STRIKEOUT"]){
                            if([uniformStyle getStrikeout]){
                                [uniformStyle setStrikeout:false];
                            }else{
                                [uniformStyle setStrikeout:true];
                            }
                        }else if([fontName isEqualToString:@"SHADOW"]){
                            if([uniformStyle getShadow]){
                                [uniformStyle setShadow:false];
                            }else{
                                [uniformStyle setShadow:true];
                            }
                        }else if([fontName isEqualToString:@"OUTLINE"] ){
                            if([uniformStyle getOutline]){
                                [uniformStyle setOutline:false];
                            }else{
                                [uniformStyle setOutline:YES];
                                [uniformStyle setBackColor:[[Color alloc]initWithR:255 G:255 B:255]];
                                //                            uniformStyle.set
                            }
                        }
                        
                    }
                }
                
//                [style setFontName:fontName];
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
                MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
                [[mapControl getEditHistory] addMapHistory];
                
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
                MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
                [[mapControl getEditHistory] addMapHistory];
                
                ThemeLabel* themeLabel = (ThemeLabel*)layer.theme;
                int count = [themeLabel getUniqueCount];// getUniqueItems().getCount();
                if(count == 0){
                    TextStyle* style = themeLabel.mUniformStyle;
                    [style setFontWidth:fontSize];
                    [style setFontHeight:fontSize];
                }else{
                    for (int i = 0; i < count; i++) {
                        TextStyle* uniformStyle = [themeLabel getUniqueItem:i].textStyle;//.getUniqueItems().getItem(i).getStyle
                        [uniformStyle setFontWidth:fontSize];
                        [uniformStyle setFontHeight:fontSize];
                    }
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
                int count = [themeLabel getUniqueCount];// getUniqueItems().getCount();
                if(count == 0){
                    TextStyle* style = themeLabel.mUniformStyle;
                    double fontSize = [style getFontHeight];
                    resolve([NSNumber numberWithDouble:fontSize]);
                }else{
                    for (int i = 0; i < count; i++) {
                        TextStyle* uniformStyle = [themeLabel getUniqueItem:i].textStyle;//.getUniqueItems().getItem(i).getStyle
                       double fontSize = [uniformStyle getFontHeight];
                        resolve([NSNumber numberWithDouble:fontSize]);
                        return;
                    }
                }
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
                MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
                [[mapControl getEditHistory] addMapHistory];
                
                ThemeLabel* themeLabel = (ThemeLabel*)layer.theme;
                int count = [themeLabel getUniqueCount];// getUniqueItems().getCount();
                if(count == 0){
                    TextStyle* style = themeLabel.mUniformStyle;
                    double lastRotation = [style getRotation];
                    if (lastRotation == 360.0) {
                        lastRotation = 0.0;
                    } else if(lastRotation == 0.0){
                        lastRotation = 360.0;
                    }
                    [style setRotation:(lastRotation + rotation)];
                }else{
                    for (int i = 0; i < count; i++) {
                        TextStyle* style = [themeLabel getUniqueItem:i].textStyle;//.getUniqueItems().getItem(i).getStyle
                        double lastRotation = [style getRotation];
                        if (lastRotation == 360.0) {
                            lastRotation = 0.0;
                        } else if(lastRotation == 0.0){
                            lastRotation = 360.0;
                        }
                        [style setRotation:(lastRotation + rotation)];
                    }
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
                int count = [themeLabel getUniqueCount];// getUniqueItems().getCount();
                if(count == 0){
                    TextStyle* style = themeLabel.mUniformStyle;
                    double rotation = [style getRotation];
                    resolve([NSNumber numberWithDouble:rotation]);
                }else{
                    for (int i = 0; i < count; i++) {
                        TextStyle* style = [themeLabel getUniqueItem:i].textStyle;//.getUniqueItems().getItem(i).getStyle
                        double rotation = [style getRotation];
                        resolve([NSNumber numberWithDouble:rotation]);
                        return;
                    }
                }
                

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
                MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
                [[mapControl getEditHistory] addMapHistory];
                
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
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [[mapControl getEditHistory] addMapHistory];
        
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
                    colorArray = [SMThemeCartography getRangeColors:colorScheme];
                    
                    if (colorArray != nil) {
                        int rangeCount = [themeRange getCount];
                        if(rangeCount <= 0)
                        {
                            resolve([NSNumber numberWithBool:false]);
                            return;
                        }
                        Colors* selectedColors = [Colors makeGradient:rangeCount gradientColorArray:colorArray];
                        for (int i = 0; i < rangeCount; i++) {
                            [SMThemeCartography setGeoStyleColor:dataset.datasetType geoStyle:[themeRange getItem:i].mStyle color:[selectedColors get:i]];
                        }
//                        _lastColorRangeArray = colorArray;
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
            MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
            [[mapControl getEditHistory] addMapHistory];
            
            ThemeRange* tr = nil;
            tr = [ThemeRange makeDefaultDataSet:(DatasetVector*)dataset RangeExpression:rangeExpression RangeMode:rangeMode RangeParameter:rangeParameter ColorGradientType:colorGradientType];
            if(tr != nil)
            {
                if(![array containsObject:@"ColorGradientType"]){
                    NSMutableArray* mulArray = nil;
                    mulArray =  [SMThemeCartography getLastThemeColors:themeRangeLayer];
                    if(!mulArray){
                        mulArray = [NSMutableArray array];
                        for (int i = 0; i < [themeRange getCount]; i++) {
                            Color* color = [SMThemeCartography getGeoStyleColor:dataset.datasetType geoStyle:[themeRange getItem:i].mStyle];//
                            [mulArray addObject:color];
                        }
                    }
                    if (mulArray != nil) {
                        int rangeCount = [tr getCount];
                        Colors* selectedColors = [Colors makeGradient:rangeCount gradientColorArray:mulArray];
                        for (int i = 0; i < rangeCount; i++) {
                            [SMThemeCartography setGeoStyleColor:dataset.datasetType geoStyle:[tr getItem:i].mStyle color:[selectedColors get:i]];
                        }
//                        _lastColorRangeArray = mulArray;
                    }
                }
                
                [themeRangeLayer.theme fromXML:[tr toXML]];
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

        NSArray* colorArray = nil;
        if ([array containsObject:@"ColorScheme"]) {
            strColor = [dataDic objectForKey:@"ColorScheme"];
            colorArray = [SMThemeCartography getUniqueColors:strColor];
        }
        
        Layer* layer = nil;
        
        if ([layerName isEqualToString:@""]) {
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        } else {
            layer = [SMThemeCartography getLayerByName:layerName];
        }
        
        if (layer != nil && colorArray != nil && layer.theme != nil) {
            if (layer.theme.themeType == TT_Unique) {
                MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
                [[mapControl getEditHistory] addMapHistory];
                
                ThemeUnique* themeUnique = (ThemeUnique*)layer.theme;
                int rangeCount = [themeUnique getCount];
                Colors* selectedColors = [Colors makeGradient:rangeCount gradientColorArray:colorArray];
                for (int i = 0; i < rangeCount; i++) {
                    [SMThemeCartography setGeoStyleColor:layer.dataset.datasetType geoStyle:[themeUnique getItem:i].mStyle color:[selectedColors get:i]];
                }
//                _lastColorUniqueArray = colorArray;
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
    
        NSArray* colorArray;
        if ([array containsObject:@"ColorScheme"]) {
            strColor = [dataDic objectForKey:@"ColorScheme"];
            colorArray = [SMThemeCartography getRangeColors:strColor];
        }
        
        Layer* layer = nil;
        
        if ([layerName isEqualToString:@""]) {
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        } else {
            layer = [SMThemeCartography getLayerByName:layerName];
        }
        
        if (layer != nil && colorArray != nil && layer.theme != nil) {
            if (layer.theme.themeType == TT_Range) {
                MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
                [[mapControl getEditHistory] addMapHistory];
                
                ThemeRange* themeUnique = (ThemeRange*)(layer.theme);
                int rangeCount = [themeUnique getCount];
                Colors* selectedColors = [Colors makeGradient:rangeCount gradientColorArray:colorArray];
                for (int i = 0; i < rangeCount; i++) {
                    [SMThemeCartography setGeoStyleColor:layer.dataset.datasetType geoStyle:[themeUnique getItem:i].mStyle color:[selectedColors get:i]];
                }
//                _lastColorRangeArray = colorArray;
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
                MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
                [[mapControl getEditHistory] addMapHistory];
                
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
 * 获取分段专题图的分段方法
 *
 * @param dataDic 单值专题图字段表达式 图层名称 图层索引
 * @param promise
 */
RCT_REMAP_METHOD(getRangeMode, getRangeModeWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
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
                NSString* strMode = [SMThemeCartography rangeModeToStr:themeLabel.mRangeMode];
                resolve(strMode);
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
 * 获取分段专题图的分段数
 *
 * @param dataDic 单值专题图字段表达式 图层名称 图层索引
 * @param promise
 */
RCT_REMAP_METHOD(getRangeCount, getRangeCountWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
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
                resolve([NSNumber numberWithInt:[themeLabel getCount]]);
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
 * 数据集->创建栅格分段专题图
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(createThemeGridRangeMap, createThemeGridRangeMapWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [[mapControl getEditHistory] addMapHistory];
        
        int datasourceIndex = -1;
        NSString* datasourceAlias = @"";
        NSString* datasetName = @"";
        NSArray* colors = nil;//颜色方案
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"DatasetName"]) {
            datasetName = [dataDic objectForKey:@"DatasetName"];
        }
        if ([array containsObject:@"GridRangeColorScheme"]){
            NSString* type = [dataDic objectForKey: @"GridRangeColorScheme" ];
            colors = [SMThemeCartography getRangeColors:type];
        } else {
            colors = [SMThemeCartography getRangeColors:@"FF_Blues"];//默认
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
        
        NSDictionary *resDic = [SMThemeCartography createThemeGridRangeMap:dataset colors:colors];
     
        resolve(resDic);
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
    
}

/**
 * 图层->创建栅格分段专题图
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(createThemeGridRangeMapByLayer, createThemeGridRangeMapByLayerWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [[mapControl getEditHistory] addMapHistory];
        
//        int datasourceIndex = -1;
//        NSString* datasourceAlias = @"";
//        NSString* datasetName = @"";
       
        NSArray* colors = nil;//颜色方案
        
        NSArray* array = [dataDic allKeys];

        if ([array containsObject:@"GridRangeColorScheme"]){
            NSString* type = [dataDic objectForKey: @"GridRangeColorScheme" ];
            colors = [SMThemeCartography getRangeColors:type];
        } else {
            colors = [SMThemeCartography getRangeColors:@"FF_Blues"];//默认
        }
        
        Layer* layer = nil;
        Dataset *dataset = nil;
        NSString* layerName = nil;//图层名称
        int layerIndex = -1;
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
            layer = [SMThemeCartography getLayerByName:layerName];
        }else if([array containsObject:@"LayerIndex"]){
            NSString* index = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = [index intValue];
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        }
        
        if (layer!=nil) {
            dataset = layer.dataset;
        }
        
        NSDictionary *resDic = [SMThemeCartography createThemeGridRangeMap:dataset colors:colors];
        
        resolve(resDic);
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
    
}

/**
 * 修改栅格分段专题图(分段方法，分段参数，颜色方案)
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(modifyThemeGridRangeMap,  modifyThemeGridRangeMapWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [[mapControl getEditHistory] addMapHistory];
        
        //        int datasourceIndex = -1;
        //        NSString* datasourceAlias = @"";
        //        NSString* datasetName = @"";
        RangeMode rangeMode = RM_None;//分段方法：等距，平方根，对数
        double rangeParameter = -1;
        NSArray* colors = nil;//颜色方案
        
        NSArray* array = [dataDic allKeys];

        if ([array containsObject:@"RangeMode"]) {
            NSString* type = [dataDic objectForKey:@"RangeMode"];
            rangeMode = [SMThemeCartography getRangeMode:type];
        }
        if ([array containsObject:@"RangeParameter"]) {
            NSString* param = [dataDic objectForKey:@"RangeParameter"];
            rangeParameter = [param doubleValue];
        }
        if ([array containsObject:@"GridRangeColorScheme"]){
            NSString* type = [dataDic objectForKey: @"GridRangeColorScheme" ];
            colors = [SMThemeCartography getRangeColors:type];
        }
        
        
        Layer* layer = nil;
        NSString* layerName = nil;//图层名称
        int layerIndex = -1;
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
            layer = [SMThemeCartography getLayerByName:layerName];
        }else if([array containsObject:@"LayerIndex"]){
            NSString* index = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = [index intValue];
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        }
        
        BOOL result = [SMThemeCartography modifyThemeGridRangeMap:layer rangeMode:rangeMode rangeParameter:rangeParameter newColors:colors];
        
        resolve([NSNumber numberWithBool:result]);
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
    
}

/**
 * 获取栅格分段专题图的分段数
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(getGridRangeCount,  getGridRangeCountWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [[mapControl getEditHistory] addMapHistory];
        
        NSArray* array = [dataDic allKeys];
        
        Layer* layer = nil;
        Dataset *dataset = nil;
        NSString* layerName = nil;//图层名称
        int layerIndex = -1;
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
            layer = [SMThemeCartography getLayerByName:layerName];
        }else if([array containsObject:@"LayerIndex"]){
            NSString* index = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = [index intValue];
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        }
        
        if (layer!=nil && layer.theme!=nil && layer.theme.themeType == TT_GridRange) {
            ThemeGridRange *themeGridRange = (ThemeGridRange*) layer.theme;
            resolve([NSNumber numberWithInt:[themeGridRange getCount]]);
        }else{
            resolve([NSNumber numberWithBool:false]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
    
}

/*栅格单值专题图
 * ********************************************************************************************/
/**
 * 数据集->创建栅格单值专题图
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(createThemeGridUniqueMap, createThemeGridUniqueMapWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [[mapControl getEditHistory] addMapHistory];
        
        int datasourceIndex = -1;
        NSString* datasourceAlias = @"";
        NSString* datasetName = @"";
        NSArray* colors = nil;//颜色方案
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"DatasetName"]) {
            datasetName = [dataDic objectForKey:@"DatasetName"];
        }
        if ([array containsObject:@"GridUniqueColorScheme"]){
            NSString* type = [dataDic objectForKey: @"GridUniqueColorScheme" ];
            colors = [SMThemeCartography getUniqueColors:type];
        } else {
            colors = [SMThemeCartography getUniqueColors:@"EE_Lake"];//默认
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
        
        NSDictionary *resDic = [SMThemeCartography createThemeGridUniqueMap:dataset colors:colors];
        
        resolve(resDic);
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
    
}
/**
 * 图层->创建栅格单值专题图
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(createThemeGridUniqueMapByLayer, createThemeGridUniqueMapByLayerWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [[mapControl getEditHistory] addMapHistory];
        
        //        int datasourceIndex = -1;
        //        NSString* datasourceAlias = @"";
        //        NSString* datasetName = @"";
        
        NSArray* colors = nil;//颜色方案
        
        NSArray* array = [dataDic allKeys];
        
        if ([array containsObject:@"GridUniqueColorScheme"]){
            NSString* type = [dataDic objectForKey: @"GridUniqueColorScheme" ];
            colors = [SMThemeCartography getUniqueColors:type];
        } else {
            colors = [SMThemeCartography getUniqueColors:@"EE_Lake"];//默认
        }
        
        Layer* layer = nil;
        Dataset *dataset = nil;
        NSString* layerName = nil;//图层名称
        int layerIndex = -1;
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
            layer = [SMThemeCartography getLayerByName:layerName];
        }else if([array containsObject:@"LayerIndex"]){
            NSString* index = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = [index intValue];
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        }
        
        if (layer!=nil) {
            dataset = layer.dataset;
        }
        
        NSDictionary *resDic = [SMThemeCartography createThemeGridUniqueMap:dataset colors:colors];
        
        resolve(resDic);
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
    
}

/**
 * 设置栅格单值专题图层的特殊值。
 * 设置栅格单值专题图的默认颜色，对于那些未在栅格单值专题图子项之列的对象使用该颜色显示。
 * 设置栅格单值专题图层特殊值的颜色。
 * 设置栅格单值专题图层的特殊值所处区域是否透明。
 * 设置颜色方案。
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(modifyThemeGridUniqueMap, modifyThemeGridUniqueMapWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [[mapControl getEditHistory] addMapHistory];
        
        int specialValue = -1;
        Color *defaultColor = nil;
        Color *specialValueColor = nil;
        
        BOOL isParams = false;
        BOOL isTransparent = false;//特殊值透明显示：默认false
        NSArray* colors = nil;//颜色方案
        
        NSArray* array = [dataDic allKeys];
        
        if ([array containsObject:@"SpecialValue"]) {
            NSString* value = [dataDic objectForKey:@"SpecialValue"];
            specialValue = [value intValue];
        }
        if ([array containsObject:@"DefaultColor"]) {
            NSString* strColor = [dataDic objectForKey:@"DefaultColor"];
            defaultColor = [STranslate colorFromHexString:strColor];
        }
        if ([array containsObject:@"SpecialValueColor"]) {
            NSString* strColor = [dataDic objectForKey:@"SpecialValueColor"];
            specialValueColor = [STranslate colorFromHexString:strColor];
        }
        if ([array containsObject:@"SpecialValueTransparent"]){
            isParams = true;
            NSString* value = [dataDic objectForKey: @"SpecialValueTransparent" ];
            isTransparent = [value boolValue];
        }
        if ([array containsObject:@"GridUniqueColorScheme"]){
            NSString* type = [dataDic objectForKey: @"GridUniqueColorScheme" ];
            colors = [SMThemeCartography getUniqueColors:type];
        }
        
        
        Layer* layer = nil;
        Dataset *dataset = nil;
        NSString* layerName = nil;//图层名称
        int layerIndex = -1;
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
            layer = [SMThemeCartography getLayerByName:layerName];
        }else if([array containsObject:@"LayerIndex"]){
            NSString* index = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = [index intValue];
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        }
        
        BOOL result = [SMThemeCartography modifyThemeGridUniqueMap:layer colors:colors specialValue:specialValue defaultColor:defaultColor specialValueColor:specialValueColor isParams:isParams isTransparent:isTransparent];
        
        resolve([NSNumber numberWithBool:result]);
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
    
}

/*统计专题图
 * ********************************************************************************************/
/**
 * 数据集->新建统计专题图层
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(createThemeGraphMap, createThemeGraphMapWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        dispatch_async(dispatch_get_main_queue(), ^{
            MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
            [[mapControl getEditHistory] addMapHistory];
            
            int datasourceIndex = -1;
            NSString* datasourceAlias = @"";
            NSString* datasetName = @"";
            NSArray* graphExpressions = nil;//字段表达式
            ThemeGraphType themeGraphType = TGT_Area;//统计图类型
            NSArray* colors = nil;//颜色方案
            
            NSArray* array = [dataDic allKeys];
            if ([array containsObject:@"DatasetName"]) {
                datasetName = [dataDic objectForKey:@"DatasetName"];
            }
            if ([array containsObject:@"GraphExpressions"]){
                graphExpressions = [dataDic objectForKey: @"GraphExpressions" ];
            }
            if ([array containsObject:@"ThemeGraphType"]){
                NSString *type = [dataDic objectForKey: @"ThemeGraphType" ];
                themeGraphType = [SMThemeCartography getThemeGraphType:type];
            }
            if ([array containsObject:@"GraphColorType"]){
                NSString* type = [dataDic objectForKey: @"GraphColorType" ];
                colors = [SMThemeCartography getGraphColors:type];
            } else {
                colors = [SMThemeCartography getGraphColors:@"HA_Calm"];//默认
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
            
            BOOL result = [SMThemeCartography createThemeGraphMap:dataset graphExpressions:graphExpressions type:themeGraphType colors:colors];
            
            resolve([NSNumber numberWithBool:result]);
            
        });
        
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
    
}

/**
 * 图层->新建统计专题图层
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(createThemeGraphMapByLayer, createThemeGraphMapByLayerWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [[mapControl getEditHistory] addMapHistory];
        
    
        NSArray* graphExpressions = nil;//字段表达式
        ThemeGraphType themeGraphType = TGT_Area;//统计图类型
        NSArray* colors = nil;//颜色方案

        Layer* layer = nil;
        Dataset *dataset = nil;
        NSString* layerName = nil;//图层名称
        int layerIndex = -1;
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
            layer = [SMThemeCartography getLayerByName:layerName];
        }else if([array containsObject:@"LayerIndex"]){
            NSString* index = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = [index intValue];
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        }
        
        if ([array containsObject:@"GraphExpressions"]){
            graphExpressions = [dataDic objectForKey: @"GraphExpressions" ];
        }
        if ([array containsObject:@"ThemeGraphType"]){
            NSString *type = [dataDic objectForKey: @"ThemeGraphType" ];
            themeGraphType = [SMThemeCartography getThemeGraphType:type];
        }
        if ([array containsObject:@"GraphColorType"]){
            NSString* type = [dataDic objectForKey: @"GraphColorType" ];
            colors = [SMThemeCartography getGraphColors:type];
        } else {
            colors = [SMThemeCartography getGraphColors:@"HA_Calm"];//默认
        }
       
        if (layer!=nil) {
            dataset = layer.dataset;
        }
        
        BOOL result = [SMThemeCartography createThemeGraphMap:dataset graphExpressions:graphExpressions type:themeGraphType colors:colors];
        
        resolve([NSNumber numberWithBool:result]);
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
    
}
/**
 * 设置统计专题图的最大显示值
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(setGraphMaxValue, setGraphMaxValueWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        
        Layer* layer = nil;
        NSString* layerName = nil;//图层名称
        int layerIndex = -1;
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
            layer = [SMThemeCartography getLayerByName:layerName];
        }else if([array containsObject:@"LayerIndex"]){
            NSString* index = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = [index intValue];
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        }
        
        double maxValue = -1;//倍数
        if ([array containsObject:@"MaxValue"]) {
            NSString*value = [dataDic objectForKey:@"MaxValue"];
            maxValue = [value doubleValue];
        }
        
        if (layer!=nil && maxValue>=1 && layer.theme!=nil && layer.theme.themeType==TT_Graph) {
            MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
            [[mapControl getEditHistory] addMapHistory];
            ThemeGraph* themeGraph = (ThemeGraph*) layer.theme;
            double dMax = 0;
            double dMin = 0;
            [SMThemeCartography getGraphSizeMax:&dMax min:&dMin];
            [themeGraph setMaxGraphSize:dMax*maxValue];
            [themeGraph setMinGraphSize:dMin];
            [mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        }else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
    
}

/**
 * 获取统计专题图的最大显示值
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(getGraphMaxValue, getGraphMaxValueWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        
        Layer* layer = nil;
        Dataset *dataset = nil;
        NSString* layerName = nil;//图层名称
        int layerIndex = -1;
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
            layer = [SMThemeCartography getLayerByName:layerName];
        }else if([array containsObject:@"LayerIndex"]){
            NSString* index = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = [index intValue];
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        }
        
        
        if (layer!=nil && layer.theme!=nil && layer.theme.themeType==TT_Graph) {
            
            ThemeGraph* themeGraph = (ThemeGraph*) layer.theme;
            double dMax = 0;
            double dMin = 0;
            [SMThemeCartography getGraphSizeMax:&dMax min:&dMin];
            double maxGraphSize = [themeGraph maxGraphSize];
            
            double maxSize = 1;
            if (maxGraphSize / dMax < 1) {
                maxSize = 1;
            } else if ((maxGraphSize / dMax) > 20 ) {
                maxSize = 20;
            } else {
                maxSize = (maxGraphSize / dMax);
            }
            

            resolve([NSNumber numberWithBool:YES]);
        }else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
    
}

/**
 * 设置统计专题图的表达式
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(setThemeGraphExpressions, setThemeGraphExpressionsWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        
        Layer* layer = nil;
        NSString* layerName = nil;//图层名称
        int layerIndex = -1;
        NSArray *graphExpressions = nil;
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
            layer = [SMThemeCartography getLayerByName:layerName];
        }else if([array containsObject:@"LayerIndex"]){
            NSString* index = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = [index intValue];
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        }
        
        if ([array containsObject:@"GraphExpressions"]){
            graphExpressions = [dataDic objectForKey: @"GraphExpressions" ];
        }
        
        if (layer!=nil && graphExpressions!=nil && layer.theme!=nil && layer.theme.themeType==TT_Graph) {
            MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
            [[mapControl getEditHistory] addMapHistory];
            ThemeGraph* themeGraph = (ThemeGraph*) layer.theme;
            
            int count = [themeGraph getCount];
            NSMutableArray *listExpression = [[NSMutableArray alloc] init];
            for (int i=0; i<count; i++) {
                [listExpression addObject:[[themeGraph getItem:i] graphExpression]];
            }
            //移除的表达式
            NSMutableArray *listremovedExpressions = [[NSMutableArray alloc] init];
            for (int i=0; i<count; i++) {
                NSString*expression = [[themeGraph getItem:i] graphExpression];
                if (![graphExpressions containsObject:expression]) {
                    [listremovedExpressions addObject:expression];
                }
            }
            //新增的表达式
            NSMutableArray *listAddedExpressions = [[NSMutableArray alloc] init];
            for (int i=0; i<graphExpressions.count; i++) {
                NSString*expression = [graphExpressions objectAtIndex:i];
                if (![listExpression containsObject:expression]) {
                    [listAddedExpressions addObject:expression];
                }
            }
            if (listAddedExpressions.count>0||listremovedExpressions.count>0) {
                
                NSArray *colors = [SMThemeCartography getLastThemeColors:layer];
                if (colors!=nil) {
                    _lastColorGraphArray = colors;
                }else{
                    if (_lastColorGraphArray!=nil) {
                        colors = _lastColorGraphArray;
                    }else{
                        colors = [SMThemeCartography getGraphColors:@"HA_Calm"];
                    }
                }
                Colors *selectedColors = [Colors makeGradient:[colors count] gradientColorArray:colors];
                
                //移除
                for (int i = 0; i < listremovedExpressions.count; i++) {
                    [themeGraph remove: [themeGraph indexOf: [listremovedExpressions objectAtIndex:i] ] ];
                }
                //防止因为修改字段表达式造成的颜色值重复，遍历设置每个子项的颜色值
                for (int i = 0; i < [themeGraph getCount]; i++) {
                    int index = i;
                    if (index >= [selectedColors getCount]) {
                        index = index % [selectedColors getCount];
                    }
                    [[[themeGraph getItem:i] uniformStyle] setFillForeColor:[selectedColors get:index]];
                }
                //添加
                for (int i = 0; i < [listAddedExpressions count]; i++) {
                    [SMThemeCartography addGraphItem:themeGraph graphExpression:[listAddedExpressions objectAtIndex:i] colors:selectedColors];
                }
                [mapControl.map refresh];
                [mapControl.map refresh];
                resolve([NSNumber numberWithBool:YES]);
            }else{
                resolve([NSNumber numberWithBool:NO]);
            }
        }else{
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
    
}

/**
 * 设置统计专题图的颜色方案
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(setThemeGraphColorScheme, setThemeGraphColorSchemeWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        
        Layer* layer = nil;
        NSString* layerName = nil;//图层名称
        int layerIndex = -1;
        NSArray*colors = nil;
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
            layer = [SMThemeCartography getLayerByName:layerName];
        }else if([array containsObject:@"LayerIndex"]){
            NSString* index = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = [index intValue];
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        }
        
        if ([array containsObject:@"GraphColorType"]){
            NSString* type = [dataDic objectForKey: @"GraphColorType" ];
            colors = [SMThemeCartography getGraphColors:type];
        }
        
        if (layer!=nil && colors!=nil && layer.theme!=nil && layer.theme.themeType==TT_Graph) {
            MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
            [[mapControl getEditHistory] addMapHistory];
            ThemeGraph* themeGraph = (ThemeGraph*) layer.theme;
            
            int count = [themeGraph getCount];
            Colors *selectedColors = [Colors makeGradient:[colors count] gradientColorArray:colors];
            for (int i = 0; i < count; i++) {
                int index = i;
                if (index >= [selectedColors getCount]) {
                    index = index % selectedColors.getCount;
                }
                [[[themeGraph getItem:i] uniformStyle] setFillForeColor:[selectedColors get:index]];
            }
            [mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        }else{
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
    
}

/**
 * 设置统计专题图的类型
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(setThemeGraphType, setThemeGraphTypeWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        
        Layer* layer = nil;
        NSString* layerName = nil;//图层名称
        int layerIndex = -1;
        ThemeGraphType themeGraphType = TGT_Area;
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
            layer = [SMThemeCartography getLayerByName:layerName];
        }else if([array containsObject:@"LayerIndex"]){
            NSString* index = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = [index intValue];
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        }
        
        if ([array containsObject:@"ThemeGraphType"]){
            NSString* type = [dataDic objectForKey: @"ThemeGraphType" ];
            themeGraphType = [SMThemeCartography getThemeGraphType:type];
        }
        
        if (layer!=nil  && layer.theme!=nil && layer.theme.themeType==TT_Graph) {
            MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
            [[mapControl getEditHistory] addMapHistory];
            ThemeGraph* themeGraph = (ThemeGraph*) layer.theme;
            [themeGraph setGraphType:themeGraphType];
            [mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        }else{
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 设置统计专题图的统计值的计算方法
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(setThemeGraphGraduatedMode, setThemeGraphGraduatedModeWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        
        Layer* layer = nil;
        NSString* layerName = nil;//图层名称
        int layerIndex = -1;
        GraduatedMode graduatedMode = GM_Constant;
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
            layer = [SMThemeCartography getLayerByName:layerName];
        }else if([array containsObject:@"LayerIndex"]){
            NSString* index = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = [index intValue];
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        }
        
        if ([array containsObject:@"GraduatedMode"]){
            NSString* type = [dataDic objectForKey: @"GraduatedMode" ];
            graduatedMode = [SMThemeCartography getGraduatedMode:type];
        }
        
        if (layer!=nil  && layer.theme!=nil && layer.theme.themeType==TT_Graph) {
            MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
            [[mapControl getEditHistory] addMapHistory];
            ThemeGraph* themeGraph = (ThemeGraph*) layer.theme;
            [themeGraph setGraduatedMode:graduatedMode];
            [mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        }else{
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 获取统计专题图的表达式
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(getGraphExpressions, getGraphExpressionsWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        
        Layer* layer = nil;
        NSString* layerName = nil;//图层名称
        int layerIndex = -1;
        GraduatedMode graduatedMode = GM_Constant;
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
            layer = [SMThemeCartography getLayerByName:layerName];
        }else if([array containsObject:@"LayerIndex"]){
            NSString* index = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = [index intValue];
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        }
        
        if (layer!=nil  && layer.theme!=nil && layer.theme.themeType==TT_Graph) {
            MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
            [[mapControl getEditHistory] addMapHistory];
            ThemeGraph* themeGraph = (ThemeGraph*) layer.theme;
            
            NSMutableArray *arrResult = [[NSMutableArray alloc] init];
            for (int i=0; i<[themeGraph getCount]; i++) {
                [arrResult addObject:[[themeGraph getItem:i]graphExpression]];
            }
        
            resolve(@{@"list":arrResult});
        }else{
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**点密度专题图*************************************************************************************/
/**
 * 新建点密度专题图
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(createDotDensityThemeMap, createDotDensityThemeMapWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [[mapControl getEditHistory] addMapHistory];
        
        int datasourceIndex = -1;
        NSString* datasourceAlias = @"";
        NSString* datasetName = @"";
        NSString* dotExpression = nil;//字段表达式
        Color* lineColor = nil;
        double value = -1;
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"DatasetName"]) {
            datasetName = [dataDic objectForKey:@"DatasetName"];
        }
        if ([array containsObject:@"DotExpression"]){
            dotExpression = [dataDic objectForKey: @"DotExpression" ];
        }
        if ([array containsObject:@"LineColor"]) {
            NSString* strColor = [dataDic objectForKey:@"LineColor"];
            lineColor = [STranslate colorFromHexString:strColor];
        }else{
            lineColor = [[Color alloc] initWithR:255 G:165 B:0 A:0];
        }
        if ([array containsObject:@"Value"]){
            NSString *strValue = [dataDic objectForKey: @"Value" ];
            value = [strValue doubleValue];
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
        
        BOOL result = false;
        if (dataset != nil && dotExpression != nil) {
            ThemeDotDensity *themeDotDensity = [[ThemeDotDensity alloc] init];
            if (themeDotDensity != nil) {
                [themeDotDensity setDotExpression:dotExpression];
                GeoStyle *geoStyle = [[GeoStyle alloc]init];
                [geoStyle setMarkerSize:[[Size2D alloc]initWithWidth:2 Height:2] ];
                [geoStyle setLineColor:lineColor];
                [themeDotDensity setStyle:geoStyle];
                if (value != -1) {
                    [themeDotDensity setValue:value];
                } else {
                    double maxValue = [ SMThemeCartography getMaxValue:(DatasetVector*)dataset dotExpression:dotExpression];
                    [themeDotDensity setValue:maxValue / 1000];
                }
                [mapControl.map.layers addDataset:dataset Theme:themeDotDensity ToHead:YES];
                [mapControl.map refresh];
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
 * 修改点密度专题图：设置点密度图的表达式，单点代表的值，点风格（符号，大小和颜色）。
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(modifyDotDensityThemeMap, modifyDotDensityThemeMapWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        
        Layer* layer = nil;
        NSString* layerName = nil;//图层名称
        int layerIndex = -1;
        GraduatedMode graduatedMode = GM_Constant;
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
            layer = [SMThemeCartography getLayerByName:layerName];
        }else if([array containsObject:@"LayerIndex"]){
            NSString* index = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = [index intValue];
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        }
        
        NSString* dotExpression = nil;
        double value = -1;
        double dotSize = -1;
        Color* lineColor = nil;
        int symbolID = -1;
        
        if ([array containsObject:@"DotExpression"]){
            dotExpression = [dataDic objectForKey: @"DotExpression" ];
        }
        if ([array containsObject:@"LineColor"]) {
            NSString* strColor = [dataDic objectForKey:@"LineColor"];
            lineColor = [STranslate colorFromHexString:strColor];
        }
        if ([array containsObject:@"Value"]){
            NSString *strValue = [dataDic objectForKey: @"Value" ];
            value = [strValue doubleValue];
        }
        if ([array containsObject:@"SymbolSize"]){
            NSString *strValue = [dataDic objectForKey: @"SymbolSize" ];
            dotSize = [strValue doubleValue];
        }
        if ([array containsObject:@"SymbolID"]){
            NSString *strValue = [dataDic objectForKey: @"SymbolID" ];
            symbolID = [strValue intValue];
        }
        
        if (layer != nil && layer.theme != nil && layer.theme.themeType==TT_DotDensity) {
            MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
            [[mapControl getEditHistory] addMapHistory];
            
            ThemeDotDensity* themeDotDensity = (ThemeDotDensity*) layer.theme;
            if (dotExpression != nil) {
                [themeDotDensity setDotExpression:dotExpression];
            }
            if (value != -1) {
                [themeDotDensity setValue:value];
            }
            if (dotSize != -1) {
                [[themeDotDensity getStyle] setMarkerSize:[[Size2D alloc]initWithWidth:dotSize Height:dotSize]];
            }
            if (lineColor != nil) {
                [[themeDotDensity getStyle]setLineColor:lineColor];
            }
            if (symbolID != -1) {
                [[themeDotDensity getStyle]setMarkerSymbolID:symbolID];
            }
            [mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }

    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 获取点密度专题图的表达式
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(getDotDensityExpression, getDotDensityExpressionWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
       
        ThemeDotDensity *themeDot = [SMThemeCartography getThemeDotDensity:dataDic];
        if(themeDot!=nil){
            resolve([themeDot getDotExpression]);
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 获取点密度专题图的单点代表值
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(getDotDensityValue, getDotDensityValueWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        
        ThemeDotDensity *themeDot = [SMThemeCartography getThemeDotDensity:dataDic];
        if(themeDot!=nil){
            resolve([NSNumber numberWithDouble:[themeDot getValue]]);
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 获取点密度专题图的点符号大小
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(getDotDensityDotSize, getDotDensityDotSizeWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        
        ThemeDotDensity *themeDot = [SMThemeCartography getThemeDotDensity:dataDic];
        if(themeDot!=nil){
            Size2D* markerSize = [[themeDot getStyle]getMarkerSize];
            resolve([NSNumber numberWithDouble:markerSize.height]);
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**等级符号专题图*************************************************************************************/
/**
 * 新建等级符号专题图
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(createGraduatedSymbolThemeMap, createGraduatedSymbolThemeMapWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [[mapControl getEditHistory] addMapHistory];
        
        int datasourceIndex = -1;
        NSString* datasourceAlias = @"";
        NSString* datasetName = @"";
        NSString* graSymbolExpression = nil;//字段表达式
        Color* lineColor = nil;
        double symbolSize = -1;
        GraduatedMode graduatedMode = GM_Constant;
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"DatasetName"]) {
            datasetName = [dataDic objectForKey:@"DatasetName"];
        }
        if ([array containsObject:@"GraduatedMode"]){
            NSString* mode = [dataDic objectForKey: @"GraduatedMode" ];
            graduatedMode = [SMThemeCartography getGraduatedMode:mode];
        }
        if ([array containsObject:@"GraSymbolExpression"]){
            graSymbolExpression = [dataDic objectForKey: @"GraSymbolExpression" ];
        }
        if ([array containsObject:@"LineColor"]) {
            NSString* strColor = [dataDic objectForKey:@"LineColor"];
            lineColor = [STranslate colorFromHexString:strColor];
        }else{
            lineColor = [[Color alloc] initWithR:255 G:165 B:0 A:0];
        }
        if ([array containsObject:@"SymbolSize"]){
            NSString *strValue = [dataDic objectForKey: @"SymbolSize" ];
            symbolSize = [strValue doubleValue];
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
        
        BOOL result = false;
        if (dataset != nil && graSymbolExpression != nil) {
            ThemeGraduatedSymbol *themeGraduatedSymbol = [ThemeGraduatedSymbol makeDefault:(DatasetVector *)dataset expression:graSymbolExpression graduatedMode:graduatedMode];
            if (themeGraduatedSymbol==nil) {
                themeGraduatedSymbol = [[ThemeGraduatedSymbol alloc] init];
            }
            [themeGraduatedSymbol setFlowEnabled:true];
            [themeGraduatedSymbol setExpression:graSymbolExpression];
            [[themeGraduatedSymbol getPositiveStyle]setLineColor:lineColor];
            if (symbolSize!=-1) {
                [[themeGraduatedSymbol getPositiveStyle]setMarkerSize:[[Size2D alloc]initWithWidth:symbolSize Height:symbolSize]];
            }
            
            [mapControl.map.layers addDataset:dataset Theme:themeGraduatedSymbol ToHead:YES];
            [mapControl.map refresh];
            result = true;
        }
        
        resolve([NSNumber numberWithBool:result]);
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
    
}

/**
 * 修改等级符号专题图：设置表达式，分级方式，基准值，正值基准值风格（大小和颜色）。
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(modifyGraduatedSymbolThemeMap, modifyGraduatedSymbolThemeMapWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        
        Layer* layer = nil;
        NSString* layerName = nil;//图层名称
        int layerIndex = -1;
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"LayerName"]) {
            layerName = [dataDic objectForKey:@"LayerName"];
            layer = [SMThemeCartography getLayerByName:layerName];
        }else if([array containsObject:@"LayerIndex"]){
            NSString* index = [dataDic objectForKey:@"LayerIndex"];
            layerIndex = [index intValue];
            layer = [SMThemeCartography getLayerByIndex:layerIndex];
        }
        
        NSString* graSymbolExpression = nil;//字段表达式
        Color* lineColor = nil;
        double baseValue = -1;//基准值
        int symbolID = -1;
        double symbolSize = -1;
        GraduatedMode graduatedMode = GM_Constant;

        if ([array containsObject:@"GraduatedMode"]){
            NSString* mode = [dataDic objectForKey: @"GraduatedMode" ];
            graduatedMode = [SMThemeCartography getGraduatedMode:mode];
        }
        if ([array containsObject:@"GraSymbolExpression"]){
            graSymbolExpression = [dataDic objectForKey: @"GraSymbolExpression" ];
        }
        if ([array containsObject:@"LineColor"]) {
            NSString* strColor = [dataDic objectForKey:@"LineColor"];
            lineColor = [STranslate colorFromHexString:strColor];
        }
        if ([array containsObject:@"BaseValue"]){
            NSString *strValue = [dataDic objectForKey: @"BaseValue" ];
            baseValue = [strValue doubleValue];
        }
        if ([array containsObject:@"SymbolSize"]){
            NSString *strValue = [dataDic objectForKey: @"SymbolSize" ];
            symbolSize = [strValue doubleValue];
        }
        if ([array containsObject:@"SymbolID"]){
            NSString *strValue = [dataDic objectForKey: @"SymbolID" ];
            symbolID = [strValue intValue];
        }
        
        if (layer!=nil && layer.theme!=nil && layer.theme.themeType==TT_GraduatedSymbol) {
            MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
            [[mapControl getEditHistory] addMapHistory];
            ThemeGraduatedSymbol* themeGraduatedSymbol = (ThemeGraduatedSymbol*) layer.theme;
            if (graSymbolExpression != nil) {
                [themeGraduatedSymbol setExpression:graSymbolExpression];
            }
           
            [themeGraduatedSymbol setGraduatedMode:graduatedMode];
            
            if (baseValue != -1) {
                [themeGraduatedSymbol setBaseValue:baseValue];
            }
            if (symbolSize != -1) {
                [[themeGraduatedSymbol getPositiveStyle] setMarkerSize:[[Size2D alloc]initWithWidth:symbolSize Height:symbolSize]];
            }
            if (lineColor != nil) {
                [[themeGraduatedSymbol getPositiveStyle] setLineColor:lineColor];
            }
            if (symbolID != -1) {
                [[themeGraduatedSymbol getPositiveStyle] setMarkerSymbolID:symbolID];
            }

            [mapControl.map refresh];
            resolve([NSNumber numberWithBool:true]);
        }else{
            resolve([NSNumber numberWithBool:false]);
        }

    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
    
}

/**
 * 获取等级符号专题图的表达式
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(getGraduatedSymbolExpress, getGraduatedSymbolExpressWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        
        ThemeGraduatedSymbol* theme = [SMThemeCartography getThemeGraduatedSymbol:dataDic];
        if(theme!=nil){

            resolve([theme getExpression]);
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 获取等级符号专题图的基准值
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(getGraduatedSymbolValue, getGraduatedSymbolValueWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        
        ThemeGraduatedSymbol* theme = [SMThemeCartography getThemeGraduatedSymbol:dataDic];
        if(theme!=nil){
            
            resolve([NSNumber numberWithDouble:[theme getBaseValue]]);
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 获取等级符号专题图的符号大小
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(getGraduatedSymbolSize, getGraduatedSymbolSizeWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        
        ThemeGraduatedSymbol* theme = [SMThemeCartography getThemeGraduatedSymbol:dataDic];
        if(theme!=nil){
            Size2D *markerSize = [[theme getPositiveStyle] getMarkerSize];
            resolve([NSNumber numberWithDouble:[markerSize height]]);
        } else {
            resolve([NSNumber numberWithBool:NO]);
        }
        
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

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
RCT_REMAP_METHOD(getThemeExpressionByLayerName, getThemeExpressionByLayerNameWithResolver:(NSString*)language layerName:(NSString*)layerName resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
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
            NSString* fieldType = [SMThemeCartography getFieldType:language info:fieldinfo];
            NSString* strName = fieldinfo.name;
            NSMutableDictionary* info = [[NSMutableDictionary alloc] init];
            [info setValue:(strName) forKey:(@"expression")];
            [info setValue:false forKey:(@"isSelected")];
            [info setValue:dataset.datasource.alias forKey:@"datasourceName"];
            [info setValue:dataset.name forKey:@"datasetName"];
            [info setValue:fieldType forKey:@"fieldType"];
            [info setObject:[SMThemeCartography getFieldTypeStr:fieldinfo] forKey:(@"fieldTypeStr")];
            if ([strName isEqualToString:@"SmGeoPosition"]){
                [info setObject:[NSNumber numberWithBool:true] forKey:(@"isSystemField")];
            }
            else{
                NSNumber* num_IsSys = [NSNumber numberWithBool:fieldinfo.isSystemField];
                [info setObject:num_IsSys forKey:(@"isSystemField")];
            }
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
            [info setValue:(strName) forKey:(@"expression")];
            [info setValue:false forKey:(@"isSelected")];
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

RCT_REMAP_METHOD(getThemeExpressionByDatasetName, getThemeExpressionByDatasetNameWithResolver:(NSString*)language alisa:(NSString*)datasourceAlias datasetName:(NSString*)datasetName resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
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
            NSString* fieldType = [SMThemeCartography getFieldType:language info:fieldinfo];
            NSString* strName = fieldinfo.name;
            NSMutableDictionary* info = [[NSMutableDictionary alloc] init];
            [info setObject:(strName) forKey:(@"expression")];
            [info setObject:(fieldType) forKey:(@"fieldType")];
            [info setObject:[SMThemeCartography getFieldTypeStr:fieldinfo] forKey:(@"fieldTypeStr")];
            if ([strName isEqualToString:@"SmGeoPosition"]){
                [info setObject:[NSNumber numberWithBool:true] forKey:(@"isSystemField")];
            }
            else{
                NSNumber* num_IsSys = [NSNumber numberWithBool:fieldinfo.isSystemField];
                [info setObject:num_IsSys forKey:(@"isSystemField")];
            }
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
            NSString* fieldType=[SMThemeCartography getFieldType:@"CN" info:fieldinfo];
            NSMutableDictionary* info = [[NSMutableDictionary alloc] init];
            [info setObject:(strName) forKey:(@"expression")];
            [info setObject:(fieldType) forKey:(@"fieldType")];
            [info setObject:[SMThemeCartography getFieldTypeStr:fieldinfo] forKey:(@"fieldTypeStr")];
            if ([strName isEqualToString:@"SmGeoPosition"]){
                [info setObject:[NSNumber numberWithBool:true] forKey:(@"isSystemField")];
            }
            else{
                NSNumber* num_IsSys = [NSNumber numberWithBool:fieldinfo.isSystemField];
                [info setObject:num_IsSys forKey:(@"isSystemField")];
            }
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
            if (datasource.datasourceConnectionInfo.engineType!=ET_UDB) {
                continue;
            }
            Datasets* datasets = datasource.datasets;
            NSInteger datasetCount = datasets.count;
            NSMutableArray* array2 = [[NSMutableArray alloc] init];
            for (NSInteger j = 0; j < datasetCount; j++) {
                NSMutableDictionary* mulDic2 = [[NSMutableDictionary alloc] init];
                [mulDic2 setValue:[datasets get:j].name forKey:@"datasetName"];
                NSString *strType = [SMThemeCartography datasetTypeToString:[datasets get:j].datasetType];
                [mulDic2 setValue:strType forKey:@"datasetType"];
                [mulDic2 setValue:datasource.alias forKey:@"datasourceName"];
                PrjCoordSys* prjCoordSys = nil;
                prjCoordSys = [datasets get:j].prjCoordSys;
                if (prjCoordSys != nil) {
                    GeoCoordSys* geoCoordSys = nil;
                    geoCoordSys = prjCoordSys.geoCoordSys;
                    if (geoCoordSys != nil) {
                        GeoCoordSysType geoCoordSysType = geoCoordSys.geoCoordSysType;
                        NSString* strGeoCoordSysType = [SMThemeCartography getGeoCoordSysType:geoCoordSysType];
                        [mulDic2 setValue:strGeoCoordSysType forKey:@"geoCoordSysType"];
                        
                    }
                    if (prjCoordSys.type) {
                        PrjCoordSysType prjCoordSysType = prjCoordSys.type;
                        NSString* strPrjCoordSysType = [SMThemeCartography getPrjCoordSysType:prjCoordSysType];
                        [mulDic2 setValue:strPrjCoordSysType forKey:@"prjCoordSysType"];
                    }
                }
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

/**
 * 获取指定数据源中的数据集
 *
 * @param dataDic 单值专题图字段表达式 图层名称 图层索引
 * @param promise
 */
RCT_REMAP_METHOD(getDatasetsByDatasource, getDatasetsByDatasourceWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSString* alias = @"";
        
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"Alias"]) {
            alias = [dataDic objectForKey:@"Alias"];
        }
        Datasources* datasources = [SMap singletonInstance].smMapWC.workspace.datasources;
        NSMutableArray* WA = [[NSMutableArray alloc] init];
        Datasource* datasource = nil;
        datasource = [datasources getAlias:alias];
        if (datasource == nil || datasource.datasourceConnectionInfo.engineType!=ET_UDB) {
            resolve([NSNumber numberWithBool:false]);
            return;
        }
        Datasets* datasets = datasource.datasets;
        NSInteger datasetsCount = datasets.count;
        NSMutableArray* arr = [[NSMutableArray alloc] init];
        for (int i = 0; i < datasetsCount; i++) {
            NSMutableDictionary* mulDic = [[NSMutableDictionary alloc] init];
            [mulDic setValue:[datasets get:i].name forKey:@"datasetName"];
            NSString* datasetType = [SMThemeCartography  datasetTypeToString:[datasets get:i].datasetType];
            [mulDic setValue:datasetType forKey:@"datasetType"];
            [mulDic setValue:datasource.alias forKey:@"datasourceName"];
            [arr addObject:mulDic];
        }
        
        NSMutableDictionary* mulDic2 = [[NSMutableDictionary alloc] init];
        NSString* datasourceAlias = datasource.alias;
        [mulDic2 setValue:datasourceAlias forKey:@"alias"];
        
        NSMutableDictionary* mulDic3 = [[NSMutableDictionary alloc] init];
        [mulDic3 setValue:arr forKey:@"list"];
        [mulDic3 setValue:mulDic2 forKey:@"datasource"];
        
        [WA addObject:mulDic3];
        resolve(WA);
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 获取专题图的颜色方案
 *
 * @param dataDic 单值专题图字段表达式 图层名称 图层索引
 * @param promise
 */
RCT_REMAP_METHOD(getThemeColorSchemeName, getThemeColorSchemeNameWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
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
            NSString* themeColorSchemeName = nil;
            themeColorSchemeName = [SMThemeCartography getThemeColorSchemeName:layer];
            if (themeColorSchemeName != nil) {
                resolve(themeColorSchemeName);
            }
            else{
                resolve([NSNumber numberWithBool:false]);
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
 * 保存当前地图
 *
 * @param dataDic 单值专题图字段表达式 图层名称 图层索引
 * @param promise
 */
RCT_REMAP_METHOD(saveMap, saveMapWithResolver:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        MapControl* mapcontrol = [SMap singletonInstance].smMapWC.mapControl;
        bool saveMap = [mapcontrol.map save];
        bool saveWorkspace = [[SMap singletonInstance].smMapWC.workspace save];
        if (saveMap && saveWorkspace) {
            resolve([NSNumber numberWithBool:true]);
        }
        else{
            resolve([NSNumber numberWithBool:false]);
        }
    }
    @catch(NSException *exception){
        reject(@"saveMap", exception.reason, nil);
    }
}
#pragma mark 热力图
RCT_REMAP_METHOD(createHeatMap, createHeatMap:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    
    @try{
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [[mapControl getEditHistory] addMapHistory];
        
        int datasourceIndex = -1;
        NSString* datasourceAlias = nil;
        
        NSString* datasetName = nil;//数据集名称
        int KernelRadius = 20;//核半径
        double FuzzyDegree = 0.1;//颜色渐变模糊度
        double Intensity = 0.1;//最大颜色权重
        NSArray* colors = nil;//颜色方案
        
        
        if (dataDic[@"DatasetName"]){
            datasetName = dataDic[@"DatasetName"];
        }
        if (dataDic[@"KernelRadius"]){
            KernelRadius  = ((NSNumber*)dataDic[@"KernelRadius"]).intValue;
        }
        if (dataDic[@"FuzzyDegree"]){
            FuzzyDegree  =((NSNumber*)dataDic[@"FuzzyDegree"]).doubleValue;
        }
        if (dataDic[@"Intensity"]){
            Intensity  = ((NSNumber*)dataDic[@"Intensity"]).doubleValue;
        }
        NSString* type = @"BA_Rainbow";
        if (dataDic[@"ColorType"]){
            type = dataDic[@"ColorType"];
        }
        colors = [SMThemeCartography getAggregationColors:type];
        
        Dataset* dataset = [SMThemeCartography getDataset:datasetName data:dataDic];//getDataset(data, datasetName);
        if (dataset == nil) {
            if (dataDic[@"DatasourceIndex"]){
                NSString* index = dataDic[@"DatasourceIndex"];
                datasourceIndex = index.intValue;
            }
            if (dataDic[@"DatasourceAlias"]){
                datasourceAlias = dataDic[@"DatasourceAlias"];
            }
            
            if (datasourceAlias != nil) {
                dataset = [SMThemeCartography getDataset:datasetName datasourceAlias:datasourceAlias];//. getDataset(datasourceAlias, datasetName);
            }  else {
                dataset = [SMThemeCartography getDataset:datasetName datasourceIndex:datasourceIndex];//.getDataset(datasourceIndex, datasetName);
            }
        }
        if(dataset.datasetType != (DatasetType)POINT){
            reject(@"createHeatMap", @"TypeError", nil);
            return;
        }
        NSDictionary* dict = [SMThemeCartography createLayerHeatMap:dataset radius:KernelRadius fuzzyDegree:FuzzyDegree intensity:Intensity colors:colors];
        resolve(dict);
//        promise.resolve(writableMap);
    }
    @catch(NSException *exception){
        reject(@"createHeatMap", exception.reason, nil);
    }
}

/**
 * 获取热力图的核半径
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(getHeatMapRadius, getHeatMapRadius:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try {
        NSString* layerName = nil;
        int layerIndex = -1;
        
        if (dataDic[@"LayerName"]){
            layerName = dataDic[@"LayerName"];
        }
        if (dataDic[@"LayerIndex"]){
            NSString* index = dataDic[@"LayerIndex"];
            layerIndex = index.intValue;
        }
        
        Layer* layer = nil;
        if (layerName != nil) {
            layer = [SMThemeCartography getLayerByName:layerName];// getLayerByName(layerName);
        } else {
            layer = [SMThemeCartography getLayerByIndex:layerIndex]; // etLayerByIndex(layerIndex);
        }
        
        if (layer != nil && layer.theme == nil) {
            LayerHeatmap* heatMap = (LayerHeatmap*) layer;
            int kernelRadius = heatMap.kernelRadius;
            
            resolve(@(kernelRadius));
        } else {
            resolve([NSNumber numberWithBool:false]);
        }
    } @catch(NSException *exception){
        reject(@"getHeatMapRadius", exception.reason, nil);
    }
}

/**
 * 设置热力图的核半径
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(setHeatMapRadius, setHeatMapRadius:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try {
        NSString* layerName = nil;
        int layerIndex = -1;
        int radius = -1;
        
        if (dataDic[@"LayerName"]){
            layerName = dataDic[@"LayerName"];
        }
        if (dataDic[@"LayerIndex"]){
            NSString* index = dataDic[@"LayerIndex"];
            layerIndex = index.intValue;
        }
        
        if (dataDic[@"Radius"]){
            NSString* index = dataDic[@"Radius"];
            radius = index.intValue;
        }
        
        Layer* layer = nil;
        if (layerName != nil) {
            layer = [SMThemeCartography getLayerByName:layerName];// getLayerByName(layerName);
        } else {
            layer = [SMThemeCartography getLayerByIndex:layerIndex]; // etLayerByIndex(layerIndex);
        }
        
        if (layer != nil && layer.theme == nil && radius != -1) {
            MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
            [[mapControl getEditHistory] addMapHistory];
            
            LayerHeatmap* heatMap = (LayerHeatmap*) layer;
            heatMap.kernelRadius = radius;
            [mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        } else {
            resolve([NSNumber numberWithBool:false]);
        }
    } @catch(NSException *exception){
        reject(@"getHeatMapRadius", exception.reason, nil);
    }
}


/**
 * 获取热力图的颜色渐变模糊度
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(getHeatMapFuzzyDegree, getHeatMapFuzzyDegree:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try {
        NSString* layerName = nil;
        int layerIndex = -1;
        
        if (dataDic[@"LayerName"]){
            layerName = dataDic[@"LayerName"];
        }
        if (dataDic[@"LayerIndex"]){
            NSString* index = dataDic[@"LayerIndex"];
            layerIndex = index.intValue;
        }
        
        Layer* layer = nil;
        if (layerName != nil) {
            layer = [SMThemeCartography getLayerByName:layerName];// getLayerByName(layerName);
        } else {
            layer = [SMThemeCartography getLayerByIndex:layerIndex]; // etLayerByIndex(layerIndex);
        }
        
        if (layer != nil && layer.theme == nil) {
            LayerHeatmap* heatMap = (LayerHeatmap*) layer;
            double fuzzyDegree = heatMap.fuzzyDegree;
            
            resolve(@(fuzzyDegree));
        } else {
            resolve([NSNumber numberWithBool:false]);
        }
    } @catch(NSException *exception){
        reject(@"getHeatMapFuzzyDegree", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(setHeatMapColorScheme, setHeatMapColorScheme:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try {
        NSString* layerName = nil;
        int layerIndex = -1;
        NSString* ColorScheme = nil;
        
        if (dataDic[@"LayerName"]){
            layerName = dataDic[@"LayerName"];
        }
        if (dataDic[@"LayerIndex"]){
            NSString* index = dataDic[@"LayerIndex"];
            layerIndex = index.intValue;
        }
        
        if (dataDic[@"HeatmapColorScheme"]){
            ColorScheme = dataDic[@"HeatmapColorScheme"];
        }
        
        Layer* layer = nil;
        if (layerName != nil) {
            layer = [SMThemeCartography getLayerByName:layerName];// getLayerByName(layerName);
        } else {
            layer = [SMThemeCartography getLayerByIndex:layerIndex]; // etLayerByIndex(layerIndex);
        }
        
        if (layer != nil && layer.theme == nil && ColorScheme != nil) {
            
            MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
            [[mapControl getEditHistory] addMapHistory];
            
            LayerHeatmap* heatMap = (LayerHeatmap*) layer;
            NSArray* colors = [SMThemeCartography getAggregationColors:ColorScheme];
            heatMap.colorset = [Colors makeGradient3:colors.count gradientColorArray:colors];
            [mapControl.map refresh];
        }
        
        
    }@catch(NSException *exception){
        reject(@"setHeatMapColorScheme", exception.reason, nil);
    }
}
/**
 * 设置热力图的颜色渐变模糊度(0-1)
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(setHeatMapFuzzyDegree, setHeatMapFuzzyDegree:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try {
        NSString* layerName = nil;
        int layerIndex = -1;
        double fuzzyDegree = -1;
        
        if (dataDic[@"LayerName"]){
            layerName = dataDic[@"LayerName"];
        }
        if (dataDic[@"LayerIndex"]){
            NSString* index = dataDic[@"LayerIndex"];
            layerIndex = index.intValue;
        }
        
        if (dataDic[@"FuzzyDegree"]){
            NSString* index = dataDic[@"FuzzyDegree"];
            fuzzyDegree = index.doubleValue;
        }
        
        Layer* layer = nil;
        if (layerName != nil) {
            layer = [SMThemeCartography getLayerByName:layerName];// getLayerByName(layerName);
        } else {
            layer = [SMThemeCartography getLayerByIndex:layerIndex]; // etLayerByIndex(layerIndex);
        }
        
        if (layer != nil && layer.theme == nil && fuzzyDegree != -1) {
            MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
            [[mapControl getEditHistory] addMapHistory];
            
            LayerHeatmap* heatMap = (LayerHeatmap*) layer;
            heatMap.fuzzyDegree = fuzzyDegree/10;
            [mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        } else {
            resolve([NSNumber numberWithBool:false]);
        }
    } @catch(NSException *exception){
        reject(@"getHeatMapRadius", exception.reason, nil);
    }
}


/**
 * 获取热力图的最大颜色权重
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(getHeatMapMaxColorWeight, getHeatMapMaxColorWeight:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try {
        NSString* layerName = nil;
        int layerIndex = -1;
        
        if (dataDic[@"LayerName"]){
            layerName = dataDic[@"LayerName"];
        }
        if (dataDic[@"LayerIndex"]){
            NSString* index = dataDic[@"LayerIndex"];
            layerIndex = index.intValue;
        }
        
        Layer* layer = nil;
        if (layerName != nil) {
            layer = [SMThemeCartography getLayerByName:layerName];// getLayerByName(layerName);
        } else {
            layer = [SMThemeCartography getLayerByIndex:layerIndex]; // etLayerByIndex(layerIndex);
        }
        
        if (layer != nil && layer.theme == nil) {
            LayerHeatmap* heatMap = (LayerHeatmap*) layer;
            double intensity = heatMap.intensity;
            
            resolve(@(intensity));
        } else {
            resolve([NSNumber numberWithBool:false]);
        }
    } @catch(NSException *exception){
        reject(@"getHeatMapMaxColorWeight", exception.reason, nil);
    }
}

/**
 * 设置热力图的最大颜色权重(0-100)
 *
 * @param readableMap
 * @param promise
 */
RCT_REMAP_METHOD(setHeatMapMaxColorWeight, setHeatMapMaxColorWeight:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try {
        NSString* layerName = nil;
        int layerIndex = -1;
        double intensity = -1;
        
        if (dataDic[@"LayerName"]){
            layerName = dataDic[@"LayerName"];
        }
        if (dataDic[@"MaxColorWeight"]){
            NSString* index = dataDic[@"MaxColorWeight"];
            intensity = index.intValue;
        }
        
        if (dataDic[@"Radius"]){
            NSString* index = dataDic[@"Radius"];
            intensity = index.doubleValue;
        }
        
        Layer* layer = nil;
        if (layerName != nil) {
            layer = [SMThemeCartography getLayerByName:layerName];// getLayerByName(layerName);
        } else {
            layer = [SMThemeCartography getLayerByIndex:layerIndex]; // etLayerByIndex(layerIndex);
        }
        
        if (layer != nil && layer.theme == nil && intensity != -1) {
            MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
            [[mapControl getEditHistory] addMapHistory];
            
            LayerHeatmap* heatMap = (LayerHeatmap*) layer;
            heatMap.intensity = intensity/100.0;
            [mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        } else {
            resolve([NSNumber numberWithBool:false]);
        }
    } @catch(NSException *exception){
        reject(@"setHeatMapMaxColorWeight", exception.reason, nil);
    }
}

#pragma mark 获取UDB数据源的数据集列表
RCT_REMAP_METHOD(getUDBName, getUDBNameWithPath:(NSString*)path resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        path = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString* udbName = [[path lastPathComponent] stringByDeletingPathExtension ];
        Datasource* datasource = nil;
        SMap* sMap = [SMap singletonInstance];
        if ([sMap.smMapWC.workspace.datasources indexOf:udbName] != -1) {
            datasource = [sMap.smMapWC.workspace.datasources getAlias:udbName];
        }
        else{
            NSDictionary *params=[[NSDictionary alloc] initWithObjects:@[path,@219,udbName] forKeys:@[@"server",@"engineType",@"alias"]];
            datasource = [sMap.smMapWC openDatasource:params];
        }
        NSInteger count = [datasource.datasets count];
        NSString* name;
        NSMutableArray* array = [[NSMutableArray alloc]init];
        for(int i = 0; i < count; i++)
        {
            Dataset* dataset = [datasource.datasets get:i];
            NSMutableDictionary* info = [[NSMutableDictionary alloc] init];
            [info setValue:dataset.name forKey:@"datasetName"];
            NSString* datasetType = [SMThemeCartography datasetTypeToString:dataset.datasetType];
            [info setValue:datasetType forKey:@"datasetType"];
            [info setValue:datasource.alias forKey:@"datasourceName"];
            
            NSString* description = dataset.description;
            if ([description isEqualToString:@"NULL"]) {
                description = @"";
            }
            [info setValue:description forKey:@"description"];
            PrjCoordSys* prjCoordSys = nil;
            prjCoordSys = dataset.prjCoordSys;
            if (prjCoordSys != nil) {
                GeoCoordSys* geoCoordSys = nil;
                geoCoordSys = prjCoordSys.geoCoordSys;
                if (geoCoordSys != nil) {
                    GeoCoordSysType geoCoordSysType = geoCoordSys.geoCoordSysType;
                    NSString* strGeoCoordSysType = [SMThemeCartography getGeoCoordSysType:geoCoordSysType];
                    [info setValue:strGeoCoordSysType forKey:@"geoCoordSysType"];
                    
                }
                if (prjCoordSys.type) {
                    PrjCoordSysType prjCoordSysType = prjCoordSys.type;
                    NSString* strPrjCoordSysType = [SMThemeCartography getPrjCoordSysType:prjCoordSysType];
                    [info setValue:strPrjCoordSysType forKey:@"prjCoordSysType"];
                }
            }
            [array addObject:info];
        }
        resolve(array);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 检查是否有打开的数据源
RCT_REMAP_METHOD(isAnyOpenedDS, isAnyOpenedDS:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSInteger count = [SMap singletonInstance].smMapWC.workspace.datasources.count;
        bool isAny = true;
        if (count <= 0) {
            isAny = false;
        }
        resolve([NSNumber numberWithBool:isAny]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}
@end

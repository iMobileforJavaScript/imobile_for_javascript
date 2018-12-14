//
//  SThemeCartography.m
//  Supermap
//
//  Created by xianglong li on 2018/12/7.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "SThemeCartography.h"
#import "SMThemeCartography.h"
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
 * 新建单值专题图层
 *
 * @param readableMap (数据源的索引/数据源的别名/打开本地数据源、数据集名称、单值专题图字段表达式、默认样式)
 *                    LayerName: 要移除的专题图层
 */

RCT_REMAP_METHOD(createAndRemoveThemeUniqueMap, createAndRemoveThemeUniqueMapWithResolver:(NSDictionary*) dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        int datasourceIndex = 0;
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


/*分段专题图
 * ********************************************************************************************/


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
RCT_REMAP_METHOD(getThemeExpressByLayerName, getThemeExpressByLayerNameWithResolver:(NSString*)layerName resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        Layers *layers = [SMap singletonInstance].smMapWC.mapControl.map.layers;
        Dataset* dataset = [layers getLayerWithName:layerName].dataset;
        DatasetVector* datasetVector = (DatasetVector*)dataset;
        FieldInfos* fieldInfos = datasetVector.fieldInfos;
        NSMutableDictionary* mulDic = [[NSMutableDictionary alloc] init];
        NSInteger count = fieldInfos.count;
        for (NSInteger i = 0; i < count; i++) {
            FieldInfo* fieldinfo = [fieldInfos get:i];
            NSString* strName = fieldinfo.name;
            [mulDic setValue:strName forKey:@"title"];
        }
        resolve(mulDic);
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

RCT_REMAP_METHOD(getThemeExpressByLayerIndex, getThemeExpressByLayerIndexWithResolver:(int)layerIndex resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        Layers *layers = [SMap singletonInstance].smMapWC.mapControl.map.layers;
        Dataset* dataset = [layers getLayerAtIndex:layerIndex].dataset;
        DatasetVector* datasetVector = (DatasetVector*)dataset;
        FieldInfos* fieldInfos = datasetVector.fieldInfos;
        NSMutableDictionary* mulDic = [[NSMutableDictionary alloc] init];
        NSInteger count = fieldInfos.count;
        for (NSInteger i = 0; i < count; i++) {
            FieldInfo* fieldinfo = [fieldInfos get:i];
            NSString* strName = fieldinfo.name;
            [mulDic setValue:strName forKey:@"title"];
        }
        resolve(mulDic);
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}
@end

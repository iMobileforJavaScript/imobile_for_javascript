//
//  SMLayer.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/11/16.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "SMLayer.h"
#import "SuperMap/ThemeLabel.h"
#import "SuperMap/LayerHeatmap.h"

@implementation SMLayer

+ (NSArray *)getLayersByType:(int)type path:(NSString *)path {
    Map* map = [SMap singletonInstance].smMapWC.mapControl.map;
    Layers* layers = map.layers;
    int count = [layers getCount];
    
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    if (path == nil || [path isEqualToString:@""]) {
        for (int i = 0; i < count; i++) {
            Layer* layer = [layers getLayerAtIndex:i];
            Dataset* dataset = layer.dataset;
            
            if (dataset == nil || dataset.datasetType == type || type == -1) {
                NSMutableDictionary* info = [self getLayerInfo:layer path:path];
                [arr addObject:info];
            }
        }
    } else {
        Layer* layer = [self findLayerByPath:path];
        if (layer.dataset == nil) {
            LayerGroup* layerGroup = (LayerGroup *)layer;
            for (int i = 0; i < [layerGroup getCount]; i++) {
                Layer* mLayer = [layerGroup getLayer:i];
                NSMutableDictionary* info = [self getLayerInfo:mLayer path:path];
                [arr addObject:info];
            }
        }
    }
    
    return arr;
}

+ (NSArray *)getLayersByGroupPath:(NSString *)path{
    Map* map = [SMap singletonInstance].smMapWC.mapControl.map;
    Layers* layers = map.layers;
    LayerGroup* layerGroup = nil;
    Layer* layer;
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    NSArray* pathParams = [path componentsSeparatedByString:@"/"];
    if (path == nil || [path isEqualToString:@""] || pathParams.count == 1) {
        layer = [layers getLayerWithName:pathParams[0]];
    } else {
        layer = [self findLayerByPath:path];
    }
    if ([layer isKindOfClass:[LayerGroup class]]) {
        layerGroup = (LayerGroup *)layer;
    } else {
        return arr;
    }
    for (int i = 0; i < [layerGroup getCount]; i++) {
        Layer* layer = [layerGroup getLayer:i];
        NSMutableDictionary* info = [self getLayerInfo:layer path:path];
        [arr addObject:info];
    }
    
    return arr;
}

+ (NSMutableDictionary *)getLayerInfo:(Layer *)layer path:(NSString *)path {
    int themeType = (int)layer.theme.themeType;
    if( themeType == TT_label ){
        ThemeLabel* themelabel = ( ThemeLabel* )layer.theme;
        if ([themelabel rangeExpression]!=nil && [[themelabel rangeExpression] length]!=0 && [themelabel getRangeCount]!=0 ) {
            themeType = TT_label+200;
        }else if([themelabel uniqueExpression]!=nil && [[themelabel uniqueExpression] length]!=0 && [themelabel getUniqueCount]!=0){
            themeType = TT_label+100;
        }
    }
    
    NSString* datasetName = @"";
    if (layer.dataset != nil && ![layer isKindOfClass:[LayerGroup class]]) {
        datasetName = layer.dataset.name;
    }
    
    NSString* mLayerGroupName = layer.parentGroup.name;
    
    BOOL isHeatmap = [layer isKindOfClass:[LayerHeatmap class]];
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:layer.name forKey:@"name"];
    [dictionary setValue:layer.caption forKey:@"caption"];
    [dictionary setValue:layer.description forKey:@"description"];
    [dictionary setValue:[NSNumber numberWithBool:layer.editable] forKey:@"isEditable"];
    [dictionary setValue:[NSNumber numberWithBool:layer.visible] forKey:@"isVisible"];
    [dictionary setValue:[NSNumber numberWithBool:layer.selectable] forKey:@"isSelectable"];
    [dictionary setValue:[NSNumber numberWithBool:layer.isSnapable] forKey:@"isSnapable"];
    [dictionary setValue:mLayerGroupName forKey:@"groupName"];
    [dictionary setValue:[NSNumber numberWithBool:isHeatmap] forKey:@"isHeatmap"];
    path = [path isEqualToString:@""] ? layer.name : [NSString stringWithFormat:@"%@/%@", path, layer.name];
    [dictionary setValue:path forKey:@"path"];
    [dictionary setValue:@(themeType) forKey:@"themeType"];
    
    if (![layer isKindOfClass:[LayerGroup class]]) {
        NSNumber* dsType = @(-1);
        NSString* datasourceAlias = @"";
        if (layer.dataset != nil) {
            dsType = [NSNumber numberWithInteger:layer.dataset.datasetType];
            datasourceAlias = layer.dataset.datasource.datasourceConnectionInfo.alias;
        }
        [dictionary setValue:dsType forKey:@"type"];
        [dictionary setValue:datasetName forKey:@"datasetName"];
        [dictionary setValue:datasourceAlias forKey:@"datasourceAlias"];
    } else {
        NSArray * child = [self getLayersByGroupPath:path];
        [dictionary setValue:@"layerGroup" forKey:@"type"];
        [dictionary setValue:child forKey:@"child"];
    }
    return dictionary;
}

+ (void)setLayerVisible:(NSString *)path value:(BOOL)value {
    Layer* layer = [self findLayerByPath:path];
    layer.visible = value;
}

+ (void)setLayerEditable:(NSString *)path value:(BOOL)value {
    Layer* layer = [self findLayerByPath:path];
    layer.editable = value;
}

+ (Layer *)findLayerByPath:(NSString *)path {
    if (path == nil || [path isEqualToString:@""]) return nil;
    Map* map = [SMap singletonInstance].smMapWC.mapControl.map;
    Layers* layers = map.layers;
    
    NSArray* pathParams = [path componentsSeparatedByString:@"/"];
    Layer* layer;
    LayerGroup* layerGroup;
    layer = [layers getLayerWithName:pathParams[0]];
    for (int i = 1; i < pathParams.count; i++) {
        if ([layer isKindOfClass: [LayerGroup class]]) {
            layerGroup = (LayerGroup *)layer;
            layer = [layerGroup getLayerWithName:pathParams[i]];
        } else {
            break;
        }
    }
    return layer;
}

+ (void)findLayerAndGroupByPath:(NSString *)path layer:(Layer**)pLayer group:(LayerGroup**)pGroup{
    if (path == nil || [path isEqualToString:@""]) return ;
    Map* map = [SMap singletonInstance].smMapWC.mapControl.map;
    Layers* layers = map.layers;
    
    NSArray* pathParams = [path componentsSeparatedByString:@"/"];
//    Layer* layer;
//    LayerGroup* layerGroup;
    *pLayer = [layers getLayerWithName:pathParams[0]];
    for (int i = 1; i < pathParams.count; i++) {
        if ([*pLayer isKindOfClass: [LayerGroup class]]) {
            *pGroup = (LayerGroup *)*pLayer;
            *pLayer = [*pGroup getLayerWithName:pathParams[i]];
        } else {
            break;
        }
    }
}

+ (Layer *)findLayerWithName:(NSString *)name {
    if (name == nil || [name isEqualToString:@""]) return nil;
    Map* map = [SMap singletonInstance].smMapWC.mapControl.map;
    Layers* layers = map.layers;

    return [layers findLayerWithName:name];
}

+ (NSDictionary *)getLayerAttribute:(NSString *)path page:(int)page size:(int)size params:(NSDictionary *)params {
    Layer* layer = [self findLayerByPath:path];
    DatasetVector* dv = (DatasetVector *)layer.dataset;
    
    Recordset* recordSet;
    if (params != nil) {
        QueryParameter* parameter = [[QueryParameter alloc] init];
        [parameter setCursorType:STATIC];
        if ([params objectForKey:@"filter"]) {
            NSArray* filterArr = [[params objectForKey:@"filter"] componentsSeparatedByString:@","];
            [parameter setOrderBy:filterArr];
        }
        
        if ([params objectForKey:@"groupBy"]) {
            NSArray* group = [[params objectForKey:@"groupBy"] componentsSeparatedByString:@","];
            [parameter setGroupBy:group];
        }
        
        recordSet = [dv query:parameter];
    } else {
        recordSet = [dv recordset:false cursorType:STATIC];
    }
    
    long nCount = recordSet.recordCount > size ? size : recordSet.recordCount;
    NSMutableDictionary* dic = [NativeUtil recordsetToDictionary:recordSet page:page size:nCount];
    [recordSet dispose];
    return dic;
}

+ (NSDictionary *)getSelectionAttributeByLayer:(NSString *)path page:(int)page size:(int)size {
    Layer* layer = [self findLayerByPath:path];
    Selection* selection = [layer getSelection];
    Recordset* recordSet = selection.toRecordset;
    
    [recordSet moveFirst];
    long nCount = recordSet.recordCount > size ? size : recordSet.recordCount;
    NSMutableDictionary* dic = [NativeUtil recordsetToDictionary:recordSet page:page size:nCount]; // recordSet已经dispose了
    
    [recordSet dispose];
    [selection dispose];
    recordSet = nil;
    return dic;
}

+ (NSDictionary *)getAttributeByLayer:(NSString *)path ids:(NSArray *)ids {
    Layer* layer = [self findLayerByPath:path];
    NSString* filter = @"";
    for (int i = 0; i < ids.count; i++) {
        NSNumber* ID = ids[i];
        if (i == 0) {
            filter = [NSString stringWithFormat:@"SmID=%d", ID.intValue];
        } else {
            filter = [NSString stringWithFormat:@"%@ OR SmID=%d", filter, ID.intValue];
        }
    }
    QueryParameter* qp = [[QueryParameter alloc] init];
    [qp setAttriButeFilter:filter];
    [qp setCursorType:STATIC];
    
    DatasetVector* dv = (DatasetVector *)layer.dataset;;
    Recordset* recordSet = [dv query:qp];
    
    [recordSet moveFirst];
    NSMutableDictionary* dic = [NativeUtil recordsetToDictionary:recordSet page:0 size:recordSet.recordCount]; // recordSet已经dispose了
    
    [recordSet dispose];
    recordSet = nil;
    return dic;
}

+ (NSString *)getLayerPath:(Layer *)layer {
    NSString* path = layer.name;
    while (layer.parentGroup != nil) {
        path = [NSString stringWithFormat:@"%@/%@", layer.parentGroup.name, path];
        layer = layer.parentGroup;
    }
    return path;
}

+ (Layer *)findLayerByDatasetName:(NSString *)datasetName {
    if (datasetName == nil || [datasetName isEqualToString:@""]) return nil;
    Map* map = [SMap singletonInstance].smMapWC.mapControl.map;
    Layers* layers = map.layers;
    Layer* targetLayer = nil;
    int count = layers.getCount;
    for (int i = 0; i < count; i++) {
        Layer* layer = [layers getLayerAtIndex:i];
        Dataset* dataset = layer.dataset;
        
        if ([dataset.name isEqualToString:datasetName]) {
            targetLayer = layer;
            break;
        }
    }
    
    return targetLayer;
}

+ (NSMutableDictionary *)searchLayerAttribute:(NSString *)path params:(NSDictionary *)params page:(int *)page size:(int *)size {
    NSString* filter = [params objectForKey:@"filter"];
    NSString* key = [params objectForKey:@"key"];
    
    Layer* layer = [self findLayerByPath:path];
    DatasetVector* dv = (DatasetVector*) layer.dataset;
    
    QueryParameter* qp = [[QueryParameter alloc] init];
    Recordset* recordset;
    
    if (filter != nil && ![filter isEqualToString:@""]) {
        qp.attriButeFilter = filter;
        qp.cursorType = STATIC;
        recordset = [dv query:qp];
    } else if (key != nil && ![key isEqualToString:@""]) {
        FieldInfos* infos = dv.fieldInfos;
        NSString* sql = @"";
        for (int i = 0; i < infos.count; i++) {
            NSString* fieldName = [infos get:i].name;
            if (i == 0) {
                sql = [NSString stringWithFormat:@"%@ LIKE '%%%@%%'", fieldName, key];
            } else {
                sql = [NSString stringWithFormat:@"%@ OR %@ LIKE '%%%@%%'", sql, fieldName, key];
            }
        }
        qp.attriButeFilter = sql;
        qp.cursorType = STATIC;
        recordset = [dv query:qp];
    } else {
        recordset = [dv recordset:NO cursorType:STATIC];
    }
    
    [recordset moveFirst];
    NSMutableDictionary* dic = [NativeUtil recordsetToDictionary:recordset page:page size:size]; // recordSet已经dispose了
    
    [recordset dispose];
    recordset = nil;
    return dic;
}

+ (NSMutableDictionary *)searchSelectionAttribute:(NSString *)path searchKey:(NSString *)searchKey page:(int)page size:(int)size {
    Layer* layer = [self findLayerByPath:path];
    Selection* selection = [layer getSelection];
    Recordset* recordSet = selection.toRecordset;
    
    [recordSet moveFirst];
    long nCount = recordSet.recordCount > size ? size : recordSet.recordCount;
    NSMutableDictionary* dic = [NativeUtil recordsetToDictionary:recordSet page:page size:nCount filterKey:searchKey]; // recordSet已经dispose了
    
    [recordSet dispose];
    [selection dispose];
    recordSet = nil;
    return dic;
}

+ (Layer *)addLayerByName:(NSString *)datasourceName datasetName:(NSString *)datasetName {
    SMap* sMap = [SMap singletonInstance];
    Workspace* workspace = sMap.smMapWC.workspace;
    if(![datasourceName isEqualToString:@""] && ![datasetName isEqualToString:@""]){
        Datasource* datasource = [workspace.datasources getAlias:datasourceName];
        Dataset* dataset = [datasource.datasets getWithName:datasetName];
        Layer* layer = [sMap.smMapWC.mapControl.map.layers addDataset:dataset ToHead:true];
        
        [sMap.smMapWC.mapControl.map setIsVisibleScalesEnabled:false];
        [sMap.smMapWC.mapControl.map refresh];
        return layer;
    }
    return nil;
}

+ (Layer *)addLayerByName:(NSString *)datasourceName datasetIndex:(int)datasetIndex {
    SMap* sMap = [SMap singletonInstance];
    Datasources* dataSources = sMap.smMapWC.workspace.datasources;
    if (dataSources && [dataSources getAlias:datasourceName]) {
        Datasets* dss = [dataSources getAlias:datasourceName].datasets;
        if (dss.count > datasetIndex) {
            Dataset* ds = [dss get:datasetIndex];
            Layer* layer = [sMap.smMapWC.mapControl.map.layers addDataset:ds ToHead:YES];
            sMap.smMapWC.mapControl.map.isVisibleScalesEnabled = NO;
            return layer;
        }
    }
    return nil;
}

+ (Layer *)addLayerByIndex:(int)datasourceIndex datasetName:(NSString *)datasetName {
    SMap* sMap = [SMap singletonInstance];
    Workspace* workspace = sMap.smMapWC.workspace;
    if(datasourceIndex >= 0 && ![datasetName isEqualToString:@""]){
        Datasource* datasource = [workspace.datasources get:datasourceIndex];
        Dataset* dataset = [datasource.datasets getWithName:datasetName];
        Layer* layer = [sMap.smMapWC.mapControl.map.layers addDataset:dataset ToHead:true];
        
        [sMap.smMapWC.mapControl.map setIsVisibleScalesEnabled:false];
        [sMap.smMapWC.mapControl.map refresh];
        return layer;
    }
    return nil;
}

+ (Layer *)addLayerByIndex:(int)datasourceIndex datasetIndex:(int)datasetIndex {
    SMap* sMap = [SMap singletonInstance];
    Workspace* workspace = sMap.smMapWC.workspace;
    if(datasourceIndex >= 0 && datasetIndex >= 0){
        Datasource* datasource = [workspace.datasources get:datasourceIndex];
        Dataset* dataset = [datasource.datasets get:datasetIndex];
        Layer* layer = [sMap.smMapWC.mapControl.map.layers addDataset:dataset ToHead:true];
        
        [sMap.smMapWC.mapControl.map setIsVisibleScalesEnabled:false];
        [sMap.smMapWC.mapControl.map refresh];
        return layer;
    }
    return nil;
}

+ (BOOL)setLayerFieldInfo:(Layer *)layer fieldInfos:(NSArray *)fieldInfos params:(NSDictionary *)params {
    if (!layer) return NO;
    Layers* layers = [SMap singletonInstance].smMapWC.mapControl.map.layers;
    Layer* editableLayer = nil;
    // 找到原来可编辑图层并记录
    // 三种情况：1.目标图层即为可编辑图层；2.目标图层不为可编辑图层，且layers中不存在编辑图层；3.layers中存在可编辑图层，但不是目标图层
    int status = 1;
    if (!layer.editable) {
        for (int i = 0; i < layers.getCount; i++) {
            if ([layers getLayerAtIndex:i].editable) {
                editableLayer = [layers getLayerAtIndex:i];
                status = 3;
                break;
            }
        }
        
        layer.editable = YES;
        if (!editableLayer) {
            status = 2;
        }
    }
    
    DatasetVector* dsVector = (DatasetVector *)layer.dataset;
    Recordset* recordset;
    
    if ([params objectForKey:@"filter"]) {
        NSString* filter = [params objectForKey:@"filter"];
        CursorType cursorType = DYNAMIC;
        if ([params objectForKey:@"cursorType"]) {
            NSNumber* cType = [params objectForKey:@"cursorType"];
            cursorType = cType.intValue;
        }
        
        QueryParameter* queryParams = [[QueryParameter alloc] init];
        [queryParams setAttriButeFilter:filter];
        [queryParams setCursorType:cursorType];
        recordset = [dsVector query:queryParams];
    } else {
        recordset = [dsVector recordset:false cursorType:DYNAMIC];
        if ([params objectForKey:@"index"] >= 0){
            NSNumber* indexNum = [params objectForKey:@"index"];
            long index = indexNum.longValue;
            index = index >= 0 ? index : (recordset.recordCount - 1);
            [recordset moveTo:index];
        }
    }
    [recordset edit];
    BOOL result = NO;
    for (int i = 0; i < fieldInfos.count; i++) {
        @try{
            NSDictionary* info = fieldInfos[i];
            
            NSString* name = [info objectForKey:@"name"];
            NSObject* value = [info objectForKey:@"value"];
            FieldInfo* fieldInfo = [recordset.fieldInfos getName:name];
            
            if (!fieldInfo) continue;
            
            switch (fieldInfo.fieldType) {
                case FT_BOOLEAN: {
                    if ([value isEqual:@""]) {
                        result = [recordset setFieldValueNULLWithString:name];
                    } else if ([value isEqual:@"YES"] || [value isEqual:@"true"] || [(NSNumber *)value intValue] > 0) {
                        result = [recordset setBOOLWithName:name BOOLValue:YES];
                    } else {
                        result = [recordset setBOOLWithName:name BOOLValue:NO];
                    }
                    break;
                }
                case FT_BYTE:
                    result = [recordset setByteWithName:name ByteValue: (Byte)[[(NSString *)value dataUsingEncoding: NSUTF8StringEncoding] bytes]];
                    break;
                case FT_INT16: {
                    short shortValue = (short)((NSString *)value).intValue;
                    result = [recordset setInt16WithName:name shortValue:shortValue];
                    break;
                }
                case FT_INT32:
                    result = [recordset setInt32WithName:name value:((NSString *)value).intValue];
                    break;
                case FT_INT64:
                    result = [recordset setInt64WithName:name value:((NSString *)value).intValue];
                    break;
                case FT_SINGLE:
                    result = [recordset setSingleWithName:name value:((NSString *)value).floatValue];
                    break;
                case FT_DOUBLE:
                    result = [recordset setDoubleWithName:name DoubleValue:((NSString *)value).doubleValue];
                    break;
                case FT_DATE:
                    break;
                case FT_TEXT:
                    result = [recordset setStringWithName:name StringValue:(NSString *)value];
                    break;
                case FT_LONGBINARY:
                default:
                    result = [recordset setFieldValueWithString:name Obj:value];
                    break;
            }
        }@catch (NSException *exception) {
            continue;
        }
       
//        if (!result) break;
    }
    
    [recordset update];
    [recordset dispose];
    recordset = nil;
    
    // 还原编辑之前的图层可编辑状态
    switch (status) {
        case 2:
            layer.editable = NO;
            break;
        case 3:
            editableLayer.editable = YES;
            break;
        case 1:
        default:
            break;
    }
    return result;
}

+ (InfoCallout *)addCallOutWithLongitude:(double)longitude latitude:(double)latitude image:(NSString *)imagePath {
    SMap* sMap = [SMap singletonInstance];
    
    Point2D* pt = [[Point2D alloc] initWithX:longitude Y:latitude];
    InfoCallout* callout = [[InfoCallout alloc] initWithMapControl:sMap.smMapWC.mapControl BackgroundColor:nil Alignment:CALLOUT_BOTTOM];
    callout.width = 50;
    callout.height = 50;
    callout.userInteractionEnabled = YES;

    NSString* extension = [[imagePath pathExtension] lowercaseString];
    UIImage* img;
    
    if ([extension isEqualToString:@"mp4"] || [extension isEqualToString:@"mov"]) {
        img = [MediaUtil getScreenShotImageFromVideoPath:imagePath];
    } else {
        img = [UIImage imageWithContentsOfFile:imagePath];
        // TODO 压缩图片
    }
    
    UIImageView* image = [[UIImageView alloc]initWithImage:img];
    image.frame = CGRectMake(0, 0, 50, 50);
    [callout addSubview:image];
    [callout showAt:pt Tag:callout.layerName];
    sMap.smMapWC.mapControl.map.center = pt;
    if (sMap.smMapWC.mapControl.map.scale < 0.000011947150294723098) {
        sMap.smMapWC.mapControl.map.scale = 0.000011947150294723098;
    }
    [sMap.smMapWC.mapControl.map refresh];
    
    return callout;
}

+ (BOOL)addRecordsetFieldInfo:(NSString *)path isSelectOrLayer:(BOOL)isSelect fieldInfo:(NSDictionary*)fieldInfo{
    @try{
        Layer* layer = [self findLayerByPath:path];
        DatasetVector* datasetVector;
        if(isSelect){
            Selection* selection = [layer getSelection];
            datasetVector = [selection getDataset];
        }else{
            datasetVector = (DatasetVector *)layer.dataset;
        }
        
        FieldInfo* filedInfo=[[FieldInfo alloc] init];
        //别名
        if([fieldInfo objectForKey:@"caption"]){
            filedInfo.caption=[fieldInfo objectForKey:@"caption"];
        }
        //名称
        if([fieldInfo objectForKey:@"name"]){
            filedInfo.name=[fieldInfo objectForKey:@"name"];
        }
        //是否必填
        if([fieldInfo objectForKey:@"required"]){
            filedInfo.required=[[fieldInfo objectForKey:@"required"] boolValue];
        }
        //最大长度
        if([fieldInfo objectForKey:@"maxLength"]){
            filedInfo.maxLength=[[fieldInfo objectForKey:@"maxLength"] intValue];
        }
        //字段的类型
        if([fieldInfo objectForKey:@"type"]){
            filedInfo.fieldType=[[fieldInfo objectForKey:@"type"] intValue];
            //默认值
            if([fieldInfo objectForKey:@"defaultValue"]){
                if(filedInfo.fieldType==FT_BOOLEAN){
                    filedInfo.defaultValue=[[fieldInfo objectForKey:@"defaultValue"] boolValue]?@"1":@"0";
                }else{
                    filedInfo.defaultValue=[fieldInfo objectForKey:@"defaultValue"];
                }
            }
        }
        int result=[datasetVector.fieldInfos add:filedInfo];
        [filedInfo dispose];
        if(result>=0){
            return YES;
        }else{
            return NO;
        }
    }@catch (NSException *exception) {
        return NO;
    }
}
+ (BOOL)removeRecordsetFieldInfo:(NSString *)path isSelectOrLayer:(BOOL)isSelect attributeName:(NSString*)attributeName{
    @try{
        Layer* layer = [self findLayerByPath:path];
        DatasetVector* datasetVector;
        if(isSelect){
            Selection* selection = [layer getSelection];
            datasetVector = [selection getDataset];
        }else{
            datasetVector = (DatasetVector *)layer.dataset;
        }
        
        BOOL result=[datasetVector.fieldInfos removeFieldName:(attributeName)];
        
        return result;
    }@catch (NSException *exception) {
        return NO;
    }
}

+ (double)statistic:(NSString *)path isSelect:(BOOL)isSelect fieldName:(NSString*)fieldName statisticMode:(int)statisticMode {
    @try{
        Layer* layer = [self findLayerByPath:path];
        DatasetVector* datasetVector;
        Recordset* recordset;
        double result = 0.0;
        if(isSelect){
            Selection* selection = [layer getSelection];
            recordset = [selection toRecordset];
        }else{
            datasetVector = (DatasetVector *)layer.dataset;
            recordset = [datasetVector recordset:NO cursorType:STATIC];
        }
        result = [recordset statisticByName:fieldName statisticMode:statisticMode];
        [recordset dispose];
        
        return result;
    }@catch (NSException *exception) {
        return NO;
    }
}
@end

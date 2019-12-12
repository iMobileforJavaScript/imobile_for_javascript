//
//  SDatasource.m
//  Supermap
//
//  Created by Shanglong Yang on 2018/12/7.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "SDatasource.h"

@implementation SDatasource
RCT_EXPORT_MODULE();

#pragma mark 创建数据源
RCT_REMAP_METHOD(createDatasource, createDatasource:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Workspace* workspace = [SMap singletonInstance].smMapWC.workspace;
        Datasource* datasource = nil;
        DatasourceConnectionInfo* info = [SMDatasource convertDicToInfo:params];
        
        // 判断文件目录是否存在，不存在则创建
        NSString* server = [params objectForKey:@"server"];
        NSString* serverParentPath = [server stringByDeletingLastPathComponent];
        [SMFileUtil createFileDirectories:serverParentPath];
        
        datasource = [workspace.datasources create:info];
        if([params.allKeys containsObject:@"description"]){
            NSString *description = [params objectForKey:@"description"];
            datasource.description = description;
        }
        resolve([NSNumber numberWithBool:datasource != nil]);
    } @catch (NSException *exception) {
        reject(@"Datasource", exception.reason, nil);
    }
}

#pragma mark 创建数据源
RCT_REMAP_METHOD(createDatasourceOfLabel, createDatasourceOfLabel:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Workspace *workspace = [[Workspace alloc]init];
        Datasource *datasource = nil;
        DatasourceConnectionInfo *info = [SMDatasource convertDicToInfo:params];
        NSString *server = [params objectForKey:@"server"];
        NSString *serverPath = [server stringByDeletingLastPathComponent];
        [SMFileUtil createFileDirectories:serverPath];
        datasource = [workspace.datasources create:info];
        if([params objectForKey:@"description"]){
            NSString *description = [params objectForKey:@"description"];
            [datasource setDescription:description];
        }
        if(workspace != nil){
            [workspace close];
            [workspace dispose];
        }
        resolve(@(datasource != nil));
    }@catch(NSException *exception){
        reject(@"createDatasourceOfLabel",exception.reason,nil);
    }
}

#pragma mark 打开数据源
RCT_REMAP_METHOD(openDatasource, openDatasource:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Workspace* workspace = [SMap singletonInstance].smMapWC.workspace;
        Datasource* datasource = nil;
        DatasourceConnectionInfo* info = [SMDatasource convertDicToInfo:params];
        
        datasource = [workspace.datasources open:info];
        resolve([NSNumber numberWithBool:datasource != nil]);
    } @catch (NSException *exception) {
        reject(@"Datasource", exception.reason, nil);
    }
}

#pragma mark 重命名数据源
RCT_REMAP_METHOD(renameDatasource, renameDatasource:(NSString *)oldName newName:(NSString*)newName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Workspace* workspace = [SMap singletonInstance].smMapWC.workspace;
        Datasources* datasources = workspace.datasources;
        [datasources RenameDatasource:oldName with:newName];
        
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"Datasource", exception.reason, nil);
    }
}

#pragma mark 通过alias关闭数据源
RCT_REMAP_METHOD(closeDatasourceByAlias, closeDatasourceByAlias:(NSString *)alias resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Workspace* workspace = [SMap singletonInstance].smMapWC.workspace;
        Datasources* datasources = workspace.datasources;
        BOOL isClosed = YES;
        if (alias == nil || [alias isEqualToString:@""]) {
            // 导航地图崩溃
                [datasources closeAll];
        } else {
            if ([datasources getAlias:alias]) {
                isClosed = [datasources closeAlias:alias];
            }
        }
        
        resolve([NSNumber numberWithBool:isClosed]);
    } @catch (NSException *exception) {
        reject(@"Datasource", exception.reason, nil);
    }
}

#pragma mark 通过index关闭数据源
RCT_REMAP_METHOD(closeDatasourceByIndex, closeDatasourceByIndex:(int)index resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Workspace* workspace = [SMap singletonInstance].smMapWC.workspace;
        Datasources* datasources = workspace.datasources;
        BOOL isClosed = YES;
        if (index == -1) {
            [datasources closeAll];
        } else {
            if ([datasources get:index]) {
                isClosed = [datasources close:index];
            }
        }
        
        resolve([NSNumber numberWithBool:isClosed]);
    } @catch (NSException *exception) {
        reject(@"Datasource", exception.reason, nil);
    }
}

#pragma mark 删除数据源
RCT_REMAP_METHOD(deleteDatasource, deleteDatasource:(NSString *)path resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BOOL exsit = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:nil];
        BOOL delete = exsit && [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
        
        resolve([NSNumber numberWithBool:delete]);
    } @catch (NSException *exception) {
        reject(@"Datasource", exception.reason, nil);
    }
}

#pragma mark 从不同数据源中复制数据集
RCT_REMAP_METHOD(copyDataset, copyDatasetWithPath:(NSString *)dataSourcePath destinationPath:(NSString *)destinationPath datasets:(NSArray *)datasets resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Datasource *datasource;
        Datasource *toDatasource;
        Workspace *workspace = [[Workspace alloc]init];
        
        DatasourceConnectionInfo *datasourceconnection = [[DatasourceConnectionInfo alloc] init];
        datasourceconnection.engineType = ET_UDB;
        datasourceconnection.server = dataSourcePath;
        datasourceconnection.alias = @"dataSource";
        
        DatasourceConnectionInfo *datasourceconnection2 = [[DatasourceConnectionInfo alloc] init];
        datasourceconnection2.engineType = ET_UDB;
        datasourceconnection2.server = destinationPath;
        datasourceconnection2.alias = @"toDataSource";
        
        datasource = [workspace.datasources open:datasourceconnection];
        toDatasource = [workspace.datasources open:datasourceconnection2];
        for(int i = 0, count = datasets.count; i < count; i++){
            DatasetVector *datasetVector = (DatasetVector *)[datasource.datasets getWithName: [datasets objectAtIndex:i]];
            NSString *datasetName = [toDatasource.datasets availableDatasetName:datasetVector.name];
            [toDatasource copyDataset:datasetVector desDatasetName:datasetName encodeType:INT32];
        }
        [workspace.datasources closeAll];
        [workspace dispose];
        [datasourceconnection dispose];
        [datasourceconnection2 dispose];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"codyDataset",exception.reason,nil);
    }
}

#pragma mark 获取数据源列表
RCT_REMAP_METHOD(getDatasources, getDatasourcesWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Workspace* workspace = [SMap singletonInstance].smMapWC.workspace;
        Datasources* datasources = workspace.datasources;
        
        NSMutableArray* dsList = [[NSMutableArray alloc] init];
        for (int i = 0; i < datasources.count; i++) {
            NSMutableDictionary* dicInfo = [[NSMutableDictionary alloc] init];
            Datasource* ds = [datasources get:i];
            DatasourceConnectionInfo* info = ds.datasourceConnectionInfo;
            [dicInfo setObject:info.alias forKey:@"alias"];
            [dicInfo setObject:[NSNumber numberWithInt:info.engineType] forKey:@"engineType"];
            [dicInfo setObject:info.server forKey:@"server"];
            [dicInfo setObject:info.driver forKey:@"driver"];
            [dicInfo setObject:info.user forKey:@"user"];
            [dicInfo setObject:[NSNumber numberWithBool:info.readOnly] forKey:@"readOnly"];
            [dicInfo setObject:info.password forKey:@"password"];
            
            [dsList addObject:dicInfo];
        }
        
        resolve(dsList);
    } @catch (NSException *exception) {
        reject(@"Datasource", exception.reason, nil);
    }
}

/**
 * 获取指定数据源中的数据集
 *
 * @param dataDic DatasourceConnectionInfo
 * @param promise
 */
RCT_REMAP_METHOD(getDatasetsByDatasource, getDatasetsByDatasource:(NSDictionary*)dataDic autoOpen:(BOOL)autoOpen resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSString* alias = @"";
        Workspace* workspace = [SMap singletonInstance].smMapWC.workspace;
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"Alias"]) {
            alias = [dataDic objectForKey:@"Alias"];
        } else if ([array containsObject:@"alias"]) {
            alias = [dataDic objectForKey:@"alias"];
        }
        Datasources* datasources = [SMap singletonInstance].smMapWC.workspace.datasources;
        Datasource* datasource = nil;
        datasource = [datasources getAlias:alias];
        if (datasource == nil && autoOpen) {
            DatasourceConnectionInfo* info = [SMDatasource convertDicToInfo:dataDic];
            datasource = [workspace.datasources open:info];
        } else if ((datasource == nil && !autoOpen) || datasource.datasourceConnectionInfo.engineType!=ET_UDB) {
            resolve([[NSDictionary alloc]init]);
            return;
        }
        Datasets* datasets = datasource.datasets;
        NSInteger datasetsCount = datasets.count;
        NSMutableArray* arr = [[NSMutableArray alloc] init];
        for (int i = 0; i < datasetsCount; i++) {
            NSMutableDictionary* mulDic = [[NSMutableDictionary alloc] init];
            [mulDic setValue:[datasets get:i].name forKey:@"datasetName"];
            [mulDic setValue:[NSNumber numberWithInt:[datasets get:i].datasetType] forKey:@"datasetType"];
            [mulDic setValue:datasource.alias forKey:@"datasourceName"];
            [arr addObject:mulDic];
        }
        
        NSMutableDictionary* mulDic2 = [[NSMutableDictionary alloc] init];
        NSString* datasourceAlias = datasource.alias;
        [mulDic2 setValue:datasourceAlias forKey:@"alias"];
        
        NSMutableDictionary* mulDic3 = [[NSMutableDictionary alloc] init];
        [mulDic3 setValue:arr forKey:@"list"];
        [mulDic3 setValue:mulDic2 forKey:@"datasource"];
        
        resolve(mulDic3);
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 新建数据集
RCT_REMAP_METHOD(createDataset, createDatasetIn:(NSString*)datasourceAlias dataset:(NSString *)datasetName type:(int) type resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try {
        Datasources* datasources = [SMap singletonInstance].smMapWC.workspace.datasources;
        Datasets* datasets = [datasources getAlias:datasourceAlias].datasets;
        BOOL hasDataset = [datasets contain:datasetName];
        DatasetVector* datasetVector;
        if(hasDataset){
            resolve([NSNumber numberWithBool:NO]);
        } else {
            DatasetVectorInfo* datasetvectorInfo = [[DatasetVectorInfo alloc] init];
            datasetvectorInfo.datasetType = type;
            datasetvectorInfo.name = datasetName;
            datasetVector = [datasets create:datasetvectorInfo];
            [datasetvectorInfo dispose];
            resolve([NSNumber numberWithBool:YES]);
        }
    } @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 删除数据集
RCT_REMAP_METHOD(deleteDataset, deleteDatasetIn:(NSString*)datasourceAlias dataset:(NSString *)datasetName resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try {
        Datasources* datasources = [SMap singletonInstance].smMapWC.workspace.datasources;
        Datasets* datasets = [datasources getAlias:datasourceAlias].datasets;
        
        int index = [datasets indexOf:datasetName];
        BOOL result = [datasets delete:index];
        resolve([NSNumber numberWithBool:result]);
    } @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(importDataset,
                 type:(NSString *) type
                 filePath:(NSString*) filePath
                 datasourceParams:(NSDictionary *)datasourceParams
                 importParams:(NSDictionary *)importParams
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {
    @try {
        Workspace* workspace = [SMap singletonInstance].smMapWC.workspace;
        Datasource* datasource = nil;
        DatasourceConnectionInfo* info = [SMDatasource convertDicToInfo:datasourceParams];
        
        datasource = [workspace.datasources open:info];
        BOOL result = NO;
        if(datasource != nil) {
            if([type isEqualToString:@"tif"]) {
                result = [DataConversion importTIFFile:filePath toDatasource:datasource];
            } else if([type isEqualToString:@"shp"]) {
                result = [DataConversion importSHPFile:filePath toDatasource:datasource];
            } else if([type isEqualToString:@"mif"]) {
                result = [DataConversion importMIFFile:filePath toDatasource:datasource];
            } else if([type isEqualToString:@"kml"]) {
                NSString *datasetName = importParams[@"datasetName"];
                BOOL isCad = [importParams[@"importAsCAD"] boolValue];
                result = [DataConversion importKML:filePath toDatasource:datasource targetDatasetName:datasetName isCad:isCad];
            } else if([type isEqualToString:@"kmz"]) {
                NSString *datasetName = importParams[@"datasetName"];
                BOOL isCad = [importParams[@"importAsCAD"] boolValue];
                result = [DataConversion importKMZ:filePath toDatasource:datasource targetDatasetName:datasetName isCad:isCad];
            } else if([type isEqualToString:@"dwg"]) {
                BOOL isBlack = [importParams[@"inverseBlackWhite"] boolValue];
                BOOL isCad = [importParams[@"importAsCAD"] boolValue];
                result = [DataConversion importDWG:filePath toDatasource:datasource bIsBlack:isBlack isCad:isCad];
            } else if([type isEqualToString:@"dxf"]) {
                BOOL isBlack = [importParams[@"inverseBlackWhite"] boolValue];
                BOOL isCad = [importParams[@"importAsCAD"] boolValue];
                result = [DataConversion importDXF:filePath toDatasource:datasource bIsBlack:isBlack isCad:isCad];
            } else if([type isEqualToString:@"gpx"]) {
                NSString *datasetName = importParams[@"datasetName"];
                result = [DataConversion importGPX:filePath toDatasource:datasource targetDatasetName:datasetName];
            } else if([type isEqualToString:@"img"]) {
                result = [DataConversion importIMG:filePath toDatasource:datasource];
            }
        }
        resolve([NSNumber numberWithBool:result]);
    } @catch(NSException *exception){
        reject(@"importTif", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(exportDataset,
                 type:(NSString *) type
                 filePath:(NSString*) filePath
                 params:(NSDictionary *)params
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {
    @try {
        NSString * datasourceAlias = params[@"datasourceName"];
        NSString * datasetName = params[@"datasetName"];
        Datasources* datasources = [SMap singletonInstance].smMapWC.workspace.datasources;
        Datasets* datasets = [datasources getAlias:datasourceAlias].datasets;
        Dataset* dataset = [datasets getWithName:datasetName];
        NSRange range = [filePath rangeOfString:@"Documents/"];
        
        NSString *relativePath = [filePath substringFromIndex: range.location + range.length];
        BOOL result = NO;
        if(dataset != nil) {
            if([type isEqualToString:@"tif"]) {
                result = [DataConversion exportTIFNamed:relativePath fromDataset:dataset];
            } else if([type isEqualToString:@"shp"]) {
                result = [DataConversion exportSHPNamed:relativePath fromDataset:dataset];
            } else if([type isEqualToString:@"mif"]) {
                result = [DataConversion exportMIFNamed:relativePath fromDataset:dataset];
            } else if([type isEqualToString:@"kml"]) {
                result = [DataConversion exportKML:relativePath fromDataset:dataset];
            } else if([type isEqualToString:@"kmz"]) {
                result = [DataConversion exportKMZ:relativePath fromDataset:dataset];
            } else if([type isEqualToString:@"dwg"]) {
                result = [DataConversion exportDWG:relativePath fromDataset:dataset];
            } else if([type isEqualToString:@"dxf"]) {
                result = [DataConversion exportDXF:relativePath fromDataset:dataset];
            } else if([type isEqualToString:@"gpx"]) {
                result = [DataConversion exportGPX:relativePath fromDataset:dataset];
            } else if([type isEqualToString:@"img"]) {
                result = [DataConversion exportIMG:relativePath fromDataset:dataset];
            }
        }
        resolve([NSNumber numberWithBool:result]);
    } @catch(NSException *exception){
        reject(@"exportTif", exception.reason, nil);
    }
}


RCT_REMAP_METHOD(isAvailableDatasetName, checkAvailaleIn:(NSString*)datasourceAlias WithName:(NSString *)datasetName resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try {
        Datasources* datasources = [SMap singletonInstance].smMapWC.workspace.datasources;
        Datasets* datasets = [datasources getAlias:datasourceAlias].datasets;
        
        BOOL result = [datasets isAvailableDatasetName:datasetName];
        resolve([NSNumber numberWithBool:result]);
    } @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}
        
/**
 * 获取指定数据源中的数据集
 *
 * @param dataDic DatasourceConnectionInfo
 * @param promise
 */
RCT_REMAP_METHOD(getFieldInfos, getFieldInfos:(NSDictionary*)dataDic filter:(NSDictionary *)filter autoOpen:(BOOL)autoOpen resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSString* alias = @"";
        Workspace* workspace = [SMap singletonInstance].smMapWC.workspace;
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"Alias"]) {
            alias = [dataDic objectForKey:@"Alias"];
        } else if ([array containsObject:@"alias"]) {
            alias = [dataDic objectForKey:@"alias"];
        }
        NSString* datasetName = [dataDic objectForKey:@"datasetName"];
        Datasources* datasources = [SMap singletonInstance].smMapWC.workspace.datasources;
        Datasource* datasource = nil;
        datasource = [datasources getAlias:alias];
        if (datasource == nil && autoOpen) {
            DatasourceConnectionInfo* info = [SMDatasource convertDicToInfo:dataDic];
            datasource = [workspace.datasources open:info];
        } else if ((datasource == nil && !autoOpen) || datasource.datasourceConnectionInfo.engineType != ET_UDB) {
            resolve([[NSDictionary alloc]init]);
            return;
        }
        Dataset* dataset = [datasource.datasets getWithName:datasetName];
        NSArray* infos;
        if (dataset) {
            Recordset* recordset = [(DatasetVector *)dataset recordset:NO cursorType:STATIC];
            infos = [NativeUtil getFieldInfos:recordset filter:filter];
            [recordset dispose];
        } else {
            infos = [[NSArray alloc] init];
        }
        
        
        resolve(infos);
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}


//指定数据集保存为文件
RCT_REMAP_METHOD(getDatasetToGeoJson, getDatasetBydatasourceAlias:(NSString*)datasourceAlias dataset:(NSString *)datasetName to:(NSString *)path resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL fexist = [fileManager fileExistsAtPath:path];
        if (!fexist) {
            [fileManager createFileAtPath:path contents:nil attributes:nil];
        }
        const char * filePath = [path cStringUsingEncoding:NSUTF8StringEncoding];
        FILE* file = fopen(filePath, "w");
        Datasources* datasources = [SMap singletonInstance].smMapWC.workspace.datasources;
        DatasetVector* datasetVector = (DatasetVector*) [[datasources getAlias:datasourceAlias].datasets getWithName:datasetName];
        
        int re = [datasetVector toGeoJSONFile:file];
        fclose(file);
        resolve(@(re));
    } @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

//指定文件导入数据集到当前工作空间
RCT_REMAP_METHOD(importDatasetFromGeoJson, importTo:(NSString*)datasourceAlias dataset:(NSString *)datasetName from:(NSString *)path type:(int) type properties:(NSDictionary *) properties resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try {
        const char * filePath = [path cStringUsingEncoding:NSUTF8StringEncoding];
        FILE* file = fopen(filePath, "r");
        Datasources* datasources = [SMap singletonInstance].smMapWC.workspace.datasources;
        Datasets* datasets = [datasources getAlias:datasourceAlias].datasets;
        BOOL hasDataset = [datasets contain:datasetName];
        DatasetVector* datasetVector;
        if(hasDataset){
            datasetVector = (DatasetVector*) [datasets getWithName:datasetName];
        } else {
            DatasetVectorInfo* datasetvectorInfo = [[DatasetVectorInfo alloc] init];
            datasetvectorInfo.datasetType = type;
            datasetvectorInfo.name = datasetName;
            datasetVector = [datasets create:datasetvectorInfo];
            [datasetvectorInfo dispose];
            
            FieldInfo* fieldInfo = [[FieldInfo alloc]init];
            FieldInfos* fieldInfos = [datasetVector fieldInfos];
            
            for(NSString *key in properties) {
                if([fieldInfos indexOfWithFieldName:key] == -1) {
                    [fieldInfo setName:key];
                    [fieldInfo setCaption:key];
                    id obj = [properties objectForKey:key];
                    if([obj isKindOfClass:[NSString class]]){
                        [fieldInfo setFieldType:FT_WTEXT];
                    } else if([obj isKindOfClass:[NSNumber class]]) {
                        if (strcmp([obj objCType], @encode(BOOL)) == 0) {
                            [fieldInfo setFieldType:FT_BOOLEAN];
                        } else if(strcmp([obj objCType], @encode(int)) == 0) {
                            [fieldInfo setFieldType:FT_INT64];
                        } else {
                            [fieldInfo setFieldType:FT_DOUBLE];
                        }
                    } else if([obj isKindOfClass:[NSNull class]]) {
                        [fieldInfo setFieldType:FT_DOUBLE];
                    }
                    [fieldInfos add:fieldInfo];
                }
            }
        }
        
        int re = [datasetVector fromGeoJSONFile:file];
        fclose(file);
        resolve(@(re));
    } @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}
#pragma mark 根据名称移除UDB中数据集
RCT_REMAP_METHOD(removeDatasetByName, removeDatasetByNameWithPath:(NSString *)path Name:(NSString *)name resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try {
//        path = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *udbName = [[path lastPathComponent] stringByDeletingPathExtension];
        Datasource *datasource = nil;
        Workspace *workspace = nil;
        DatasourceConnectionInfo *datasourceconnection = [[DatasourceConnectionInfo alloc]init];
        workspace = [[Workspace alloc]init];
        datasourceconnection.engineType =ET_UDB;
        datasourceconnection.server = path;
        datasourceconnection.alias = udbName;
        datasource = [workspace.datasources open:datasourceconnection];
        int index = [datasource.datasets indexOf:name];
        [datasource.datasets delete:index];
        if(workspace != nil){
            [workspace.datasources closeAll];
            [workspace close];
            [workspace dispose];
        }
        [datasourceconnection dispose];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"removeDatasetByName",exception.reason,nil);
    }
}

/**
 * 根据数据源目录，获取指定数据源中的数据集（非工作空间已存在的数据源）
 *
 * @param dataDic DatasourceConnectionInfo
 * @param promise
 */
RCT_REMAP_METHOD(getDatasetsByExternalDatasource, getDatasetsByExternalDatasourceWithInfo:(NSDictionary*)dataDic resolver:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
    @try{
        Workspace *workspaceTemp = [[Workspace alloc]init];
//        NSString* alias = @"";
//        NSArray* array = [dataDic allKeys];
//        if ([array containsObject:@"Alias"]) {
//            alias = [dataDic objectForKey:@"Alias"];
//        } else if ([array containsObject:@"alias"]) {
//            alias = [dataDic objectForKey:@"alias"];
//        }
        
        DatasourceConnectionInfo* info = [SMDatasource convertDicToInfo:dataDic];
        Datasource* datasource = [workspaceTemp.datasources open:info];
        
        Datasets* datasets = datasource.datasets;
        NSInteger datasetsCount = datasets.count;
        NSMutableArray* arr = [[NSMutableArray alloc] init];
        for (int i = 0; i < datasetsCount; i++) {
            NSMutableDictionary* datasetInfo = [[NSMutableDictionary alloc] init];
            [datasetInfo setValue:[datasets get:i].name forKey:@"datasetName"];
            [datasetInfo setValue:[NSNumber numberWithInt:[datasets get:i].datasetType] forKey:@"datasetType"];
            [datasetInfo setValue:datasource.alias forKey:@"datasourceName"];
            [arr addObject:datasetInfo];
        }
        
        resolve(arr);
        
        [info dispose];
        [workspaceTemp close];
        [workspaceTemp dispose];
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

/**
 * 获取数据集范围
 *
 * @param sourceData 数据源和数据集信息
 * @param promise
 */
RCT_REMAP_METHOD(getDatasetBounds, getDatasetBounds:(NSDictionary*)sourceData resolver:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject){
    @try{
        DatasetVector* sourceDataset = (DatasetVector *)[SMAnalyst getDatasetByDictionary:sourceData];
        
        Rectangle2D* bounds = [sourceDataset computeBounds];
        NSMutableDictionary* boundPoints = [[NSMutableDictionary alloc] initWithCapacity:4];
        [boundPoints setObject:@(bounds.left) forKey:@"left"];
        [boundPoints setObject:@(bounds.bottom) forKey:@"bottom"];
        [boundPoints setObject:@(bounds.right) forKey:@"right"];
        [boundPoints setObject:@(bounds.top) forKey:@"top"];
        [boundPoints setObject:@(bounds.width) forKey:@"width"];
        [boundPoints setObject:@(bounds.height) forKey:@"height"];
        resolve(boundPoints);
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}
@end

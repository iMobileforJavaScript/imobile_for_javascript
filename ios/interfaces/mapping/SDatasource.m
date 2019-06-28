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
RCT_REMAP_METHOD(getDatasetsByDatasource, getDatasetsByDatasourceWithResolver:(NSDictionary*)dataDic autoOpen:(BOOL)autoOpen resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
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
        } else if (datasource == nil && !autoOpen || datasource.datasourceConnectionInfo.engineType!=ET_UDB) {
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

#pragma mark 根据名称移除UDB中数据集
RCT_REMAP_METHOD(removeDatasetByName, removeDatasetByNameWithPath:(NSString *)path Name:(NSString *)name resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try {
//        path = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *udbName = [[path lastPathComponent] stringByDeletingPathExtension];
        Datasource *datasource = nil;
        Workspace *workspace = nil;
        SMap *sMap = [SMap singletonInstance];
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
@end

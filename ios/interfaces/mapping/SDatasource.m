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
            resolve([NSNumber numberWithBool:false]);
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
        path = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *udbName = [[path lastPathComponent] stringByDeletingPathExtension];
        Datasource *datasource = nil;
        Workspace *workspace = nil;
        SMap *sMap = [SMap singletonInstance];
        DatasourceConnectionInfo *datasourceconnection = [[DatasourceConnectionInfo alloc]init];
        if(sMap.smMapWC.mapControl == nil){
            workspace = [[Workspace alloc]init];
            datasourceconnection.engineType =ET_UDB;
            datasourceconnection.server = path;
            datasourceconnection.alias = udbName;
            datasource = [workspace.datasources open:datasourceconnection];
            [datasource.datasets deleteName:name];
        }else{
            sMap.smMapWC.mapControl.map.workspace = sMap.smMapWC.workspace;
            if([sMap.smMapWC.mapControl.map.workspace.datasources indexOf:udbName] != -1){
                datasource = [sMap.smMapWC.mapControl.map.workspace.datasources getAlias:udbName];
                [datasource.datasets deleteName:name];
            }else{
                datasourceconnection.engineType = ET_UDB;
                datasourceconnection.server = path;
                datasourceconnection.alias = udbName;
                datasource = [sMap.smMapWC.mapControl.map.workspace.datasources open:datasourceconnection];
                [datasource.datasets deleteName:name];
            }
        }
        if(workspace != nil){
            [workspace dispose];
        }
        [datasourceconnection dispose];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"removeDatasetByName",exception.reason,nil);
    }
}

@end

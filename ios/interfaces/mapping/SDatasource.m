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
@end

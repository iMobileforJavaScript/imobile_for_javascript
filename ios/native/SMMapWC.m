//
//  SMMapWC.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/11/2.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "SMMapWC.h"

@implementation SMMapWC

- (BOOL)openWorkspace:(NSDictionary*)infoDic {
    @try {
        WorkspaceConnectionInfo* info = [[WorkspaceConnectionInfo alloc] init];
        info = [self setWorkspaceConnectionInfo:infoDic workspace:nil];
        
        bool openWsResult = [_workspace open:info];
        [info dispose];
        
        return openWsResult;
    } @catch (NSException *exception) {
        @throw exception;
    }
}

- (Datasource *)openDatasource:(NSDictionary*)params{
    @try {
        DatasourceConnectionInfo* info = [[DatasourceConnectionInfo alloc]init];
        if(params&&info){
            NSArray* keyArr = [params allKeys];
            BOOL bDefault = YES;
            if ([keyArr containsObject:@"alias"]){
                info.alias = [params objectForKey:@"alias"];
                bDefault = NO;
            }
            if ([keyArr containsObject:@"engineType"]){
                NSNumber* num = [params objectForKey:@"engineType"];
                long type = num.floatValue;
                info.engineType = (EngineType)type;
            }
            if ([keyArr containsObject:@"server"]){
                NSString* path = [params objectForKey:@"server"];
                info.server = path;
                if(bDefault){
                    info.alias = [[path lastPathComponent] stringByDeletingPathExtension];
                }
            }
            
            if([_workspace.datasources indexOf:info.alias]!=-1){
                [_workspace.datasources closeAlias:info.alias];
            }
            if ([keyArr containsObject:@"driver"]) info.driver = [params objectForKey:@"driver"];
            if ([keyArr containsObject:@"user"]) info.user = [params objectForKey:@"user"];
            if ([keyArr containsObject:@"readOnly"]) info.readOnly = ((NSNumber*)[params objectForKey:@"readOnly"]).boolValue;
            if ([keyArr containsObject:@"password"]) info.password = [params objectForKey:@"password"];
            if ([keyArr containsObject:@"webCoordinate"]) info.webCoordinate = [params objectForKey:@"webCoordinate"];
            if ([keyArr containsObject:@"webVersion"]) info.webVersion = [params objectForKey:@"webVersion"];
            if ([keyArr containsObject:@"webFormat"]) info.webFormat = [params objectForKey:@"webFormat"];
            if ([keyArr containsObject:@"webVisibleLayers"]) info.webVisibleLayers = [params objectForKey:@"webVisibleLayers"];
            if ([keyArr containsObject:@"webExtendParam"]) info.webExtendParam = [params objectForKey:@"webExtendParam"];
            //            if ([keyArr containsObject:@"webBBox"]){
            //                Rectangle2D* rect2d = [JSObjManager getObjWithKey:[params objectForKey:@"webBBox"]];
            //                info.webBBox = rect2d;
            //            }
            Datasource* dataSource = [_workspace.datasources open:info];
            [info dispose];
            return dataSource;
        }
    } @catch (NSException *exception) {
        @throw exception;
    }
}

- (Dataset *)addDatasetByName:(NSString*)name type:(DatasetType)type datasourceName:(NSString *)datasourceName datasourcePath:(NSString *)datasourcePath {
    @try {
        NSString* dsName = name;
        if (name == nil || [name isEqualToString:@""]) {
            switch (type) {
                case POINT:
                    dsName = @"COL_POINT";
                    break;
                case LINE:
                    dsName = @"COL_LINE";
                    break;
                case REGION:
                    dsName = @"COL_REGION";
                    break;
                default:
                    dsName = @"COL_POINT";
                    break;
            }
        }
        
        Datasource* datasource = [_workspace.datasources getAlias:datasourceName];
        if (datasource == nil || datasource.isReadOnly) {
            DatasourceConnectionInfo* info = [[DatasourceConnectionInfo alloc] init];
            NSString* dsType = @"udb";
            
            info.alias = datasourceName;
            info.engineType = ET_UDB;
            info.server = [NSString stringWithFormat:@"%@/%@.%@", datasourcePath, datasourceName, dsType];
            datasource = [_workspace.datasources create:info];
            if (datasource == nil) {
                datasource = [_workspace.datasources open:info];
            }
        }
        
        Datasets* datasets = datasource.datasets;
        Dataset* ds = [datasets getWithName:dsName];
        if (ds == nil) {
            NSString* dsAvailableName = [datasets availableDatasetName:dsName];
            DatasetVectorInfo* info = [[DatasetVectorInfo alloc]initWithName:dsAvailableName datasetType:type];
            ds = (Dataset*)[datasets create:info];
        }
        return ds;
    } @catch (NSException *exception) {
        @throw exception;
    }
}

- (BOOL)saveWorkspace {
    Workspace* workspace = _workspace;
    if(workspace == nil) return NO;
    
    bool saved = [workspace save];
    return saved;
}

- (BOOL)saveWorkspaceWithInfo:(NSDictionary*)infoDic{
    Workspace* workspace = _workspace;
    if(workspace == nil) return NO;
    [self setWorkspaceConnectionInfo:infoDic workspace:workspace];
    bool saved = [workspace save];
    
    return saved;
}

- (WorkspaceConnectionInfo *)setWorkspaceConnectionInfo:(NSDictionary *)infoDic workspace:(Workspace *)workspace {
    WorkspaceConnectionInfo* info;
    if (workspace == nil) {
        info = [[WorkspaceConnectionInfo alloc] init];
    } else {
        info = workspace.connectionInfo;
    }
    NSString* caption = [infoDic objectForKey:@"caption"];
    NSNumber* type = (NSNumber *)[infoDic objectForKey:@"type"];
    type = type > 0 ? type : 0;
    NSInteger version = (NSInteger)[infoDic objectForKey:@"version"];
    NSString* server = [infoDic objectForKey:@"server"];
    NSString* user = [infoDic objectForKey:@"user"];
    NSString* password = [infoDic objectForKey:@"password"];
    
    //        [info setServer:path];
    if (caption) {
        [workspace setCaption:caption];
    }
    if (version) {
        info.version = (WorkspaceVersion)version;
    }
    if (user) {
        info.user = user;
    }
    if (password) {
        info.password = password;
    }
    
    if (server) {
        switch (type.integerValue) {
            case 4:
                [info setType:SM_SXW];
                if (![server hasSuffix:@".sxw"]) {
                    server = [NSString stringWithFormat:@"%@/%@%@", server, caption, @".sxw"];
                }
                break;
                
                // SMW 工作空间信息设置
            case 5:
                [info setType:SM_SMW];
                if (![server hasSuffix:@".smw"]) {
                    server = [NSString stringWithFormat:@"%@/%@%@", server, caption, @".smw"];
                }
                [info setServer:[NSString stringWithFormat:@"%@/%@%@", server, caption, @".smw"]];
                break;
                
                // SXWU 文件工作空间信息设置
            case 8:
                [info setType:SM_SXWU];
                if (![server hasSuffix:@".sxwu"]) {
                    server = [NSString stringWithFormat:@"%@/%@%@", server, caption, @".sxwu"];
                }
                [info setServer:[NSString stringWithFormat:@"%@/%@%@", server, caption, @".sxwu"]];
                break;
                
                // SMWU 工作空间信息设置
            case 9:
                [info setType:SM_SMWU];
                if (![server hasSuffix:@".smwu"]) {
                    server = [NSString stringWithFormat:@"%@/%@%@", server, caption, @".smwu"];
                }
                [info setServer:[NSString stringWithFormat:@"%@/%@%@", server, caption, @".smwu"]];
                break;
                
                // 其他情况
            default:
                [info setType:SM_SMWU];
                if (![server hasSuffix:@".smwu"]) {
                    server = [NSString stringWithFormat:@"%@/%@%@", server, caption, @".smwu"];
                }
                break;
        }
        [info setServer:server];
    }
    return info;
}


@end

//
//  SMMapWC.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/11/2.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "SMSceneWC.h"
//#import "SuperMap/Workspace.h"

@implementation SMSceneWC

- (BOOL)openWorkspace:(NSDictionary*)infoDic {
    @try {
        WorkspaceConnectionInfo* info = [[WorkspaceConnectionInfo alloc] init];
        if ([infoDic objectForKey:@"name"]) {
            info.name = [infoDic objectForKey:@"name"];
        }
        if ([infoDic objectForKey:@"password"]) {
            info.password = [infoDic objectForKey:@"password"];
        }
        if ([infoDic objectForKey:@"server"]) {
            info.server = [infoDic objectForKey:@"server"];
        }
        if ([infoDic objectForKey:@"type"]) {
            NSNumber* type = [infoDic objectForKey:@"type"];
            info.type = (int)type.integerValue;
        }
        if ([infoDic objectForKey:@"user"]) {
            info.user = [infoDic objectForKey:@"user"];
        }
        if ([infoDic objectForKey:@"version"]) {
            NSNumber* version = [infoDic objectForKey:@"version"];
            info.version = (int)version.integerValue;
        }
        
        _workspace.resources;
        bool openWsResult = [_workspace open:info];
        [info dispose];
        [_sceneControl.scene setWorkspace:_workspace];
        
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

//- (Dataset *)addDatasetByName:(NSString*)name type:(DatasetType)type datasourceName:(NSString *)datasourceName datasourcePath:(NSString *)datasourcePath {
//    @try {
//        NSString* dsName = name;
//        if (name == nil || [name isEqualToString:@""]) {
//            switch (type) {
//                case POINT:
//                    dsName = @"COL_POINT";
//                    break;
//                case LINE:
//                    dsName = @"COL_LINE";
//                    break;
//                case REGION:
//                    dsName = @"COL_REGION";
//                    break;
//                default:
//                    dsName = @"COL_POINT";
//                    break;
//            }
//        }
//        
//        Datasource* datasource = [_workspace.datasources getAlias:datasourceName];
//        if (datasource == nil || datasource.isReadOnly) {
//            DatasourceConnectionInfo* info = [[DatasourceConnectionInfo alloc] init];
//            NSString* dsType = @"udb";
//            
//            info.alias = datasourceName;
//            info.engineType = ET_UDB;
//            info.server = [NSString stringWithFormat:@"%@/%@.%@", datasourcePath, datasourceName, dsType];
//            datasource = [_workspace.datasources create:info];
//            if (datasource == nil) {
//                datasource = [_workspace.datasources open:info];
//            }
//        }
//        
//        Datasets* datasets = datasource.datasets;
//        Dataset* ds = [datasets getWithName:dsName];
//        if (ds == nil) {
//            NSString* dsAvailableName = [datasets availableDatasetName:dsName];
//            DatasetVectorInfo* info = [[DatasetVectorInfo alloc]initWithName:dsAvailableName datasetType:type];
//            ds = (Dataset*)[datasets create:info];
//        }
//        return ds;
//    } @catch (NSException *exception) {
//        @throw exception;
//    }
//}
@end

//
//  SMMapWC.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/11/2.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "SMSceneWC.h"
//#import "SuperMap/Workspace.h"
#import "SuperMap/Scenes.h"

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

-(BOOL)copyFileFromPath:(NSString*)srcPath toPath:(NSString*)desPath{
    BOOL copySucc = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:desPath]) {
        [fileManager createDirectoryAtPath:desPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSArray *array = [fileManager contentsOfDirectoryAtPath:srcPath error:nil];
    for (int i=0; i<array.count; i++) {
        NSString *fullPath = [srcPath stringByAppendingPathComponent:[array objectAtIndex:i]];
        NSString *fullToPath = [desPath stringByAppendingPathComponent:[array objectAtIndex:i]];
        BOOL isDir = NO;
        BOOL isExist = [fileManager fileExistsAtPath:fullPath isDirectory:&isDir];
        if (isExist) {
            NSError *err = nil;
            [fileManager copyItemAtPath:fullPath toPath:fullToPath error:&err];
            if (err) {
                copySucc = false;
            }
            if (isDir) {
                [self copyFileFromPath:fullPath toPath:fullToPath];
            }
        }
        
    }
    return copySucc;
    
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
    NSInteger typevalue = type.integerValue > 0 ? type.integerValue : 0;
    type = @(typevalue);
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
                break;
                
                // SXWU 文件工作空间信息设置
            case 8:
                [info setType:SM_SXWU];
                if (![server hasSuffix:@".sxwu"]) {
                    server = [NSString stringWithFormat:@"%@/%@%@", server, caption, @".sxwu"];
                }
                break;
                
                // SMWU 工作空间信息设置
            case 9:
                [info setType:SM_SMWU];
                if (![server hasSuffix:@".smwu"]) {
                    server = [NSString stringWithFormat:@"%@/%@%@", server, caption, @".smwu"];
                }
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

static NSString *g_strCustomerDirectory = nil;
-(NSString *)getCustomerDirectory{
    if (g_strCustomerDirectory==nil) {
        g_strCustomerDirectory = [NSHomeDirectory() stringByAppendingString:@"/Documents/iTablet/User/Customer"];
    }
    return g_strCustomerDirectory;
    //return @"/Customer";
}
-(void)setCustomerDirectory:(NSString *)strValue{
    g_strCustomerDirectory = strValue;
}

-(NSString*)formateNoneExistFileName:(NSString*)strPath isDir:(BOOL)bDirFile{
    
    NSString*strName = strPath;
    NSString*strSuffix = @"";
    if (!bDirFile) {
        NSArray *arrPath = [strPath componentsSeparatedByString:@"/"];
        NSString *strFileName = [arrPath lastObject];
        NSArray *arrFileName = [strFileName componentsSeparatedByString:@"."];
        strSuffix = [arrFileName lastObject];
        strName = [strPath substringToIndex:strPath.length-strSuffix.length-1];
    }
    NSString *strResult = strPath;
    int nAddNumber = 1;
    while (1) {
        BOOL isDir  = false;
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:strResult isDirectory:&isDir];
        if (!isExist) {
            return strResult;
        }else if(isDir!=bDirFile){
            return strResult;
        }else{
            if (!bDirFile) {
                strResult = [NSString stringWithFormat:@"%@_%d.%@",strName,nAddNumber,strSuffix];
            }else{
                strResult = [NSString stringWithFormat:@"%@_%d",strName,nAddNumber];
            }
            
            nAddNumber++;
        }
    }
}

-(BOOL)export3DScenceName:(NSString*)strScenceName toFolder:(NSString*)strDesFolder{
    
    NSString * strDir = [NSString stringWithFormat:@"%@/Data/Scene",[self getCustomerDirectory]];
    NSString* srcPathPXP = [NSString stringWithFormat:@"%@/%@.pxp",strDir,strScenceName];
    BOOL isDir = true;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:srcPathPXP isDirectory:&isDir];
    if (!isExist || isDir) {
        return false;
    }
    BOOL result = false;
    NSString* strScencePXP = [NSString stringWithContentsOfFile:srcPathPXP encoding:NSUTF8StringEncoding error:nil];
    // {
    //  "Datasources":
    //                  [ {"Alians":strMapName,"Type":nEngineType,"Server":strDatasourceName} , {...} , {...} ... ] ,
    //  "Resources":
    //                  strMapName
    // }
    NSDictionary *dicExp = [NSJSONSerialization JSONObjectWithData:[strScencePXP dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    NSString *strName = [dicExp objectForKey:@"Name"];
    NSDictionary *dicTemp = [dicExp objectForKey:@"Workspace"];
    NSString *strServer = [dicTemp objectForKey:@"server"];
    isDir = true;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",strDir,strServer] isDirectory:&isDir];
    if (!isExist || isDir) {
        return false;
    }
    NSArray* arrServer = [strServer componentsSeparatedByString:@"/"];
    
    NSString *strSrcFolder = [NSString stringWithFormat:@"%@/%@",strDir,[arrServer firstObject]];
    
    [self copyFileFromPath:strSrcFolder toPath:strDesFolder];
    result = true;
//    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] initWithDictionary:dicTemp];
//    NSString *strDesServer = [NSString stringWithFormat:@"%@/%@",strDesFolder,[arrServer lastObject]];
//    [dicInfo setObject:strDesServer forKey:@"server"];
//    WorkspaceConnectionInfo *info = [self setWorkspaceConnectionInfo:dicInfo workspace:nil];
//    Workspace *desWorkspace = [[Workspace alloc]init];
//    if([desWorkspace open:info]){
//        NSMutableArray *arrNames = [[NSMutableArray alloc]init];
//        for (int i=0; i<desWorkspace.scenes.count; i++) {
//            NSString *strNameTemp = [desWorkspace.scenes get:i];
//            if (![strNameTemp isEqualToString:strName]) {
//                [arrNames addObject:strNameTemp];
//            }
//        }
//        for (int i=0; i<arrNames.count; i++) {
//            [desWorkspace.scenes ]
//        }
//
//        result = true;
//    }
//
//    [info dispose];
    
    return result;
    
}

-(BOOL)import3DWorkspaceInfo:(NSDictionary *)infoDic{
    
    BOOL result = false;
    if ( infoDic && [infoDic objectForKey:@"server"] && [infoDic objectForKey:@"type"] && ![_workspace.connectionInfo.server isEqualToString:[infoDic objectForKey:@"server"]]) {
        Workspace *importWorkspace = [[Workspace alloc]init];
        WorkspaceConnectionInfo* info = [self setWorkspaceConnectionInfo:infoDic workspace:nil];
        
        if([importWorkspace open:info]){
            NSString * strSrcServer = [infoDic objectForKey:@"server"];
            NSString * strServerName = [[strSrcServer componentsSeparatedByString:@"/"] lastObject];
            
            NSString * strSrcFolder = [strSrcServer substringToIndex:strSrcServer.length-strServerName.length-1];
            NSString * strFolderName = [[strSrcFolder  componentsSeparatedByString:@"/"] lastObject];
            
            NSString * strDesDir = [NSString stringWithFormat:@"%@/Data/Scene",[self getCustomerDirectory]];
            NSString * strDesFolder = [NSString stringWithFormat:@"%@/%@",strDesDir,strFolderName];
            //1.拷贝所有数据
            strDesFolder = [self formateNoneExistFileName:strDesFolder isDir:YES];
            //处理重名
            strFolderName = [[strDesFolder  componentsSeparatedByString:@"/"] lastObject];
            
            [self copyFileFromPath:strSrcFolder toPath:strDesFolder];
            
            NSString *strWorkspace = [NSString stringWithFormat:@"%@/%@",strFolderName,strServerName];
            NSMutableDictionary *dicParame = [[NSMutableDictionary alloc]initWithDictionary:infoDic];
            [dicParame setObject:strWorkspace forKey:@"server"];
            
            //2.导出所有scence
            for (int i=0; i<importWorkspace.scenes.count; i++) {
                NSString* strScenceName = [importWorkspace.scenes get:i];
                NSString *desScencePxp = [NSString stringWithFormat:@"%@/%@.pxp",strDesDir,strScenceName];
                desScencePxp = [self formateNoneExistFileName:desScencePxp isDir:NO];
                
                NSDictionary *dicTemp = @{ @"Name":strScenceName , @"Workspace":dicParame };
                
                NSData *dataJson = [NSJSONSerialization dataWithJSONObject:dicTemp options:NSJSONWritingPrettyPrinted error:nil];
                NSString *strExplorerJson = [[NSString alloc]initWithData:dataJson encoding:NSUTF8StringEncoding];
                [strExplorerJson writeToFile:desScencePxp atomically:YES encoding:NSUTF8StringEncoding error:nil];
            }
            
            [importWorkspace close];
            result = true;
        }
        
        [info dispose];
        [importWorkspace close];
        [importWorkspace dispose];
    }
    
    return result;
    
}

-(BOOL)openScenceName:(NSString *)strScenceName toScenceControl:(SceneControl*)scenceControl{
    if(scenceControl.scene.workspace==nil){
        return false;
    }
    NSString * strDir = [NSString stringWithFormat:@"%@/Data/Scene",[self getCustomerDirectory]];
    NSString* srcPathPXP = [NSString stringWithFormat:@"%@/%@.pxp",strDir,strScenceName];
    BOOL isDir = true;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:srcPathPXP isDirectory:&isDir];
    if (!isExist || isDir) {
        return false;
    }
    BOOL result = false;
    NSString* strScencePXP = [NSString stringWithContentsOfFile:srcPathPXP encoding:NSUTF8StringEncoding error:nil];
    // {
    //  "Datasources":
    //                  [ {"Alians":strMapName,"Type":nEngineType,"Server":strDatasourceName} , {...} , {...} ... ] ,
    //  "Resources":
    //                  strMapName
    // }
    NSDictionary *dicExp = [NSJSONSerialization JSONObjectWithData:[strScencePXP dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    NSString *strName = [dicExp objectForKey:@"Name"];
    NSDictionary *dicTemp = [dicExp objectForKey:@"Workspace"];
    NSString *strServer = [dicTemp objectForKey:@"server"];
    NSString *strFullPath = [NSString stringWithFormat:@"%@/%@",strDir,strServer];
    isDir = true;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:strFullPath isDirectory:&isDir];
    if (!isExist || isDir) {
        return false;
    }
    
    NSMutableDictionary *dicInfo = [[NSMutableDictionary alloc] initWithDictionary:dicTemp];
    
    [dicInfo setObject:strFullPath forKey:@"server"];
    
    WorkspaceConnectionInfo* info = [self setWorkspaceConnectionInfo:dicInfo workspace:nil];
    
    if([[scenceControl.scene.workspace caption]isEqualToString:@"UntitledWorkspace"]){
        //工作空间未打开
        if([scenceControl.scene.workspace open:info]){
            //[_sceneControl.scene setWorkspace:_workspace];
            [_sceneControl.scene open:strName];
            result = true;
        }
    }else{
        
        if ([scenceControl.scene.workspace.connectionInfo.server isEqualToString:strFullPath]) {
            // 同一个工作空间
            if ([_sceneControl.scene.name isEqualToString:strName]) {
                result = true;
            }else{
                [_sceneControl.scene close];
                result = [_sceneControl.scene open:strName];
            }
        }else{
            // 不同工作空间
            [_sceneControl.scene close];
            [_sceneControl.scene.workspace close];
            if ([_sceneControl.scene.workspace open:info]) {
                result = [_sceneControl.scene open:strName];
            }
        }
        
    }

     [info dispose];
    return result;
}

-(BOOL)is3DWorkspaceInfo:(NSDictionary *)infoDic{
    BOOL result = false;
    if ( infoDic && [infoDic objectForKey:@"server"] && [infoDic objectForKey:@"type"] && ![_workspace.connectionInfo.server isEqualToString:[infoDic objectForKey:@"server"]]) {
        Workspace *importWorkspace = [[Workspace alloc]init];
        WorkspaceConnectionInfo* info = [self setWorkspaceConnectionInfo:infoDic workspace:nil];
        
        if([importWorkspace open:info]){
            if (importWorkspace.scenes.count>0) {
                result = YES;
            }
            [importWorkspace close];
        }
        [info dispose];
        [importWorkspace close];
        [importWorkspace dispose];
    }
    return result;
}

@end

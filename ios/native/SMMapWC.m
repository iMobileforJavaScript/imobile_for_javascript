//
//  SMMapWC.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/11/2.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "SMMapWC.h"
#import "SuperMap/Maps.h"
#import "SuperMap/Map.h"
#import "SuperMap/Resources.h"
#import "SuperMap/SymbolMarkerLibrary.h"
#import "SuperMap/SymbolLineLibrary.h"
#import "SuperMap/SymbolFillLibrary.h"

@implementation SMMapWC

- (BOOL)openWorkspace:(NSDictionary*)infoDic {
    @try {
        bool openWsResult = YES;
        if (infoDic && [infoDic objectForKey:@"server"] && ![_workspace.connectionInfo.server isEqualToString:[infoDic objectForKey:@"server"]]) {
            WorkspaceConnectionInfo* info = [[WorkspaceConnectionInfo alloc] init];
            info = [self setWorkspaceConnectionInfo:infoDic workspace:nil];
            
            openWsResult = [_workspace open:info];
            // _workspace =
            [info dispose];
        }
        
        return openWsResult;
    } @catch (NSException *exception) {
        @throw exception;
    }
}

- (Datasource *)openDatasource:(NSDictionary*)params{
    @try {
        if (!params) {
            return nil;
        }
        DatasourceConnectionInfo* info = [[DatasourceConnectionInfo alloc]init];
        Datasource* tempDs = [params objectForKey:@"alias"] ? [_workspace.datasources getAlias:[params objectForKey:@"alias"]] : nil;
        BOOL isOpen = tempDs && [params objectForKey:@"server"] && [tempDs.datasourceConnectionInfo.server isEqualToString:[params objectForKey:@"server"]] && [tempDs isOpended];
        Datasource* dataSource = nil;
        if (!isOpen) {
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
            
//            if([_workspace.datasources indexOf:info.alias] != -1){
//                [_workspace.datasources closeAlias:info.alias];
//            }
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
            dataSource = [_workspace.datasources open:info];
            [info dispose];
        }
        return dataSource;
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
            [SMFileUtil createFileDirectories:datasourcePath];
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
                strResult = [NSString stringWithFormat:@"%@#%d.%@",strName,nAddNumber,strSuffix];
            }else{
                strResult = [NSString stringWithFormat:@"%@#%d",strName,nAddNumber];
            }
            
            nAddNumber++;
        }
    }
}

-(NSString*)formateNoneExistDatasourceAlian:(NSString*)alian{
    NSString *resultAlian = alian;
    int nAddNumber = 1;
    while ([_workspace.datasources indexOf:resultAlian]!=-1) {
        resultAlian = [NSString stringWithFormat:@"%@#%d",alian,nAddNumber];
        nAddNumber++;
    }
    return resultAlian;
}

-(NSString*)formateNoneExistMapName:(NSString*)name{
    NSString *resultName = name;
    int nAddNumber = 1;
    while ([_workspace.maps indexOf:resultName]!=-1) {
        resultName = [NSString stringWithFormat:@"%@#%d",name,nAddNumber];
        nAddNumber++;
    }
    return resultName;
}

-(BOOL)isUDBFileExist:(NSString*)udbPath{
    if(![udbPath hasSuffix:@".udb"]){
        return false;
    }
    
    BOOL bDir = false;
    BOOL bExist = [[NSFileManager defaultManager] fileExistsAtPath:udbPath isDirectory:&bDir];
    if ( !bExist || bDir) {
        return false;
    }
    
    NSString* strPathName = [udbPath substringToIndex:udbPath.length-4];
    NSString* uddPath = [strPathName stringByAppendingString:@".udd"];
    bExist = [[NSFileManager defaultManager] fileExistsAtPath:uddPath isDirectory:&bDir];
    
    if ( !bExist || bDir) {
        return false;
    }else{
        return true;
    }
}

-(NSString*)modifyXML:(NSString*)strXML replace:(NSArray*)arrAlian with:(NSArray*)arrNewAlian{
    // 倒着替换 不然会把先前替换过的名字再次替换出错
    NSString* strResult = strXML;
    for (NSInteger i=arrAlian.count-1; i>=0; i--) {
        NSString * strAlian = [arrAlian objectAtIndex:i];
        NSString * strNewAlian = [arrNewAlian objectAtIndex:i];
        NSString * strSrc = [NSString stringWithFormat:@"<sml:DataSourceAlias>%@</sml:DataSourceAlias>",strAlian];
        NSString * strReplace = [NSString stringWithFormat:@"<sml:DataSourceAlias>%@</sml:DataSourceAlias>",strNewAlian];
        strResult = [strResult stringByReplacingOccurrencesOfString:strSrc withString:strReplace];
    }
    return strResult;
}


//导入工作空间
//  失败情况：
//      a)info为空或sever为空
//      b)打开工作空间失败
//      c)_workspace没初始化
//  流程：
//      1.新的工作空间打开
//      2.导入数据源
//          -文件型数据源需拷贝数据源到目录下,重名要改名
//          -打开数据源，alias相同需改名
//      3.导入点线面符号库（若是SMWX可直接读取文件，其他类型需要先导出符号库文件再读入）
//      4.导入maps，先导出成XML在倒入，3中alian变化的数据源需修改导出XML对应字段

-(BOOL)importWorkspaceInfo:(NSDictionary *)infoDic isResourcesReplace:(BOOL)bReplace{
    
    BOOL bSucc = NO;
    NSString *targetPath = [_workspace.connectionInfo server];
    if (_workspace && targetPath!=nil && infoDic && [infoDic objectForKey:@"server"] && ![_workspace.connectionInfo.server isEqualToString:[infoDic objectForKey:@"server"]]) {
        Workspace *importWorkspace = [[Workspace alloc]init];
        WorkspaceConnectionInfo* info = [self setWorkspaceConnectionInfo:infoDic workspace:nil];
        
        NSString *importPath = info.server;
        if([importWorkspace open:info]){
            NSFileManager *manager = [NSFileManager defaultManager];
            
            int nSuffixCount = 0;
            if (info.type==SM_SXWU || info.type==SM_SMWU) {
                nSuffixCount = 5;
            }else{
                nSuffixCount = 4;
            }
            
            
            NSArray *arrTargetPathStr = [targetPath componentsSeparatedByString:@"/"];
            NSString* strTargetWorkspaceName = [arrTargetPathStr lastObject];
            NSString* strTargetDirFather = [targetPath substringToIndex:targetPath.length-strTargetWorkspaceName.length];
            
            
            NSArray* arrSrcPathStr = [importPath componentsSeparatedByString:@"/"];
            NSArray* arrSrcWorkspaceName = [[arrSrcPathStr lastObject] componentsSeparatedByString:@"."];
            // 目标文件+importWorkspaceName
            NSString* strTargetDir = [NSString stringWithFormat:@"%@%@", strTargetDirFather,[arrSrcWorkspaceName firstObject]];
            // 目标文件存在性判断 文件名后加 #num
            // 这里判断了文件夹存在性 后面可以省略文件的判断
            strTargetDir = [self formateNoneExistFileName:strTargetDir isDir:YES];
            BOOL bFirstFile = YES;
            //数据源
            Datasources *datasourcesTemp = [importWorkspace datasources];
            //NSMutableDictionary *reAlianDic = [[NSMutableDictionary alloc]init];
            NSMutableArray *arrAlian = [[NSMutableArray alloc]init];
            NSMutableArray *arrReAlian = [[NSMutableArray alloc]init];
            for (int i=0; i<datasourcesTemp.count; i++) {
                Datasource* dTemp = [datasourcesTemp get:i];
                DatasourceConnectionInfo *infoTemp = dTemp.datasourceConnectionInfo;
                NSString *importServer = infoTemp.server;
                
                if(infoTemp.engineType==ET_UDB){
                    
                    if( ![self isUDBFileExist:importServer] ){
                        continue;
                    }
                    if (bFirstFile) {
                        if( [manager createDirectoryAtPath:strTargetDir withIntermediateDirectories:YES attributes:nil error:nil]){
                            bFirstFile = NO;
                        }else{
                            continue;
                        }
                    }
                    NSString *strSrcDatasourcePath = [importServer substringToIndex:importServer.length-4];
                    // 文件数据源拷贝
                    NSArray *arrSrcStr = [importServer componentsSeparatedByString:@"/"];
                    NSString *strUDBName = [arrSrcStr lastObject];
                    // 导入工作空间名／数据源名字
                    NSString *strTargetDatasourcePath = [NSString stringWithFormat:@"%@/%@",strTargetDir,[strUDBName substringToIndex:strUDBName.length-4]];
                    // 拷贝udb
                    if(![manager copyItemAtPath:[strSrcDatasourcePath stringByAppendingString:@".udb"] toPath:[strTargetDatasourcePath stringByAppendingString:@".udb"] error:nil]){
                        continue;
                    }
                    // 拷贝udd
                    if(![manager copyItemAtPath:[strSrcDatasourcePath stringByAppendingString:@".udd"] toPath:[strTargetDatasourcePath stringByAppendingString:@".udd"] error:nil]){
                        continue;
                    }
                    
                    // 更名
                    NSString *strAlian = [self formateNoneExistDatasourceAlian:infoTemp.alias];
                    
                    // 打开
                    DatasourceConnectionInfo *temp = [[DatasourceConnectionInfo alloc]init];
                    temp.server = [strTargetDatasourcePath stringByAppendingString:@".udb"];
                    temp.alias = strAlian;
                    temp.user = infoTemp.user;
                    if(infoTemp.password && ![infoTemp.password isEqualToString:@""]){
                        temp.password = infoTemp.password;
                    }
                    
                    temp.engineType = ET_UDB;
                    
                    if ( [_workspace.datasources open:temp] ) {
                        //[reAlianDic setObject:strAlian forKey:infoTemp.alias];
                        if (![strAlian isEqualToString:infoTemp.alias]) {
                            [arrAlian addObject:infoTemp.alias];
                            [arrReAlian addObject:strAlian];
                        }
                    }
                    
                }
                else if(infoTemp.engineType==ET_IMAGEPLUGINS){
                    BOOL bDir = false;
                    BOOL bExist = [[NSFileManager defaultManager] fileExistsAtPath:importServer isDirectory:&bDir];
                    if ( !bExist || bDir) {
                        continue;
                    }
                    if (bFirstFile) {
                        if( [manager createDirectoryAtPath:strTargetDir withIntermediateDirectories:YES attributes:nil error:nil]){
                            bFirstFile = NO;
                        }else{
                            continue;
                        }
                    }
                    // 文件数据源拷贝
                    NSArray *arrSrcStr = [importServer componentsSeparatedByString:@"/"];
                    NSString *strFileName = [arrSrcStr lastObject];
                    // 拷贝影像文件
                    if(![manager copyItemAtPath:importServer toPath:[strTargetDir stringByAppendingString:strFileName] error:nil]){
                        continue;
                    }
                    // 更名
                    NSString *strAlian = [self formateNoneExistDatasourceAlian:infoTemp.alias];
                    // 打开
                    DatasourceConnectionInfo *temp = [[DatasourceConnectionInfo alloc]init];
                    temp.server = [strTargetDir stringByAppendingString:strFileName];
                    temp.alias = strAlian;
                    temp.user = infoTemp.user;
                    if(infoTemp.password && ![infoTemp.password isEqualToString:@""]){
                        temp.password = infoTemp.password;
                    }
                    temp.engineType = ET_IMAGEPLUGINS;
                    
                    if ( [_workspace.datasources open:temp] ) {
                        //[reAlianDic setObject:strAlian forKey:infoTemp.alias];
                        if (![strAlian isEqualToString:infoTemp.alias]) {
                            [arrAlian addObject:infoTemp.alias];
                            [arrReAlian addObject:strAlian];
                        }
                    }
                }
                else{
                    NSString *strAlian = [self formateNoneExistDatasourceAlian:infoTemp.alias];
                    // web数据源
                    DatasourceConnectionInfo *temp = [[DatasourceConnectionInfo alloc]init];
                    temp.server = infoTemp.server;
                    temp.alias = strAlian;
                    temp.user = infoTemp.user;
                    if(infoTemp.password && ![infoTemp.password isEqualToString:@""]){
                        temp.password = infoTemp.password;
                    }
                    temp.driver = infoTemp.driver;
                    temp.engineType = infoTemp.engineType;
                    [_workspace.datasources open:temp];
                    
                    if ( [_workspace.datasources open:temp] ) {
                        if (![strAlian isEqualToString:infoTemp.alias]) {
                            [arrAlian addObject:infoTemp.alias];
                            [arrReAlian addObject:strAlian];
                        }
                    }
                    
                }// if udb
                
            }// for datasources
            
            
            //符号库
            
            NSString*serverResourceBase = [importPath substringToIndex:importPath.length-nSuffixCount];
            NSString*strMarkerPath = [serverResourceBase stringByAppendingString:@".sym"];
            NSString*strLinePath = [serverResourceBase stringByAppendingString:@".lsl"];
            NSString*strFillPath = [serverResourceBase stringByAppendingString:@".bru"];
            if (info.type!=SM_SXWU) {
                //导出
                [importWorkspace.resources.markerLibrary saveAs:strMarkerPath];
                [importWorkspace.resources.lineLibrary saveAs:strLinePath];
                [importWorkspace.resources.fillLibrary saveAs:strFillPath];
                
            }
            [_workspace.resources.markerLibrary appendFromFile:strMarkerPath isReplace:YES];
            [_workspace.resources.lineLibrary appendFromFile:strLinePath isReplace:YES];
            [_workspace.resources.fillLibrary appendFromFile:strFillPath isReplace:YES];
            if (info.type!=SM_SXWU) {
                [manager removeItemAtPath:strMarkerPath error:nil];
                [manager removeItemAtPath:strLinePath error:nil];
                [manager removeItemAtPath:strFillPath error:nil];
            }
            
            
            
            // map
            for (int i=0; i<importWorkspace.maps.count; i++) {
                Map *mapTemp = [[Map alloc]initWithWorkspace:importWorkspace];
                [mapTemp open:[importWorkspace.maps get:i]];
                mapTemp.description = [NSString stringWithFormat:@"%@-%@", @"Template", mapTemp.name];
                NSString* strSrcMapXML = [mapTemp toXML];
                NSString* strMapName = [self formateNoneExistMapName:mapTemp.name];
                [mapTemp close];
                
                // 替换XML字段
                NSString* strTargetMapXML = [self modifyXML:strSrcMapXML replace:arrAlian with:arrReAlian];
                [_workspace.maps add:strMapName withXML:strTargetMapXML];
            }
            
            
            [importWorkspace close];
        }
        
        [info dispose];
        [importWorkspace dispose];
        bSucc = YES;
    }
    return bSucc;
}

@end

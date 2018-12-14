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
#import "SuperMap/Layers.h"
#import "SuperMap/Layer.h"
#import "SuperMap/Dataset.h"
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

-(BOOL)isDatasourceFileExist:(NSString*)strPath isUDB:(BOOL)bUDB{
    if(bUDB){
        return [self isUDBFileExist:strPath];
    }else{
        BOOL bDir = false;
        BOOL bExist = [[NSFileManager defaultManager] fileExistsAtPath:strPath isDirectory:&bDir];
        if ( !bExist || bDir) {
            return false;
        }else{
            return true;
        }
    }
}

-(BOOL)isUDBFileExist:(NSString*)udbPath{
    if (![udbPath hasSuffix:@".udb"]) {
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
//      a)info为空或sever为空或type为空 或导入工作空间为_workspace
//      b)打开工作空间失败
//      c)_workspace没初始化
//  流程：
//      1.新的工作空间打开
//      2.导入数据源
//          -文件型数据源需拷贝数据源到目录下,重名要改名
//          -打开数据源，alias相同需改名
//      3.导入点线面符号库（若是SMWX可直接读取文件，其他类型需要先导出符号库文件再读入）
//      4.导入maps，先导出成XML在倒入，3中alian变化的数据源需修改导出XML对应字段
//  非替换模式：重复文件名+num
//  替换模式：重复文件替换，同路径先关闭工作空间再替换

-(BOOL)importWorkspaceInfo:(NSDictionary *)infoDic withFileDirectory:(NSString*)strDirPath isDatasourceReplace:(BOOL)bDatasourceRep isSymbolsReplace:(BOOL)bSymbolsRep{
    
    BOOL bSucc = NO;
    
    if (_workspace && infoDic && [infoDic objectForKey:@"server"] && [infoDic objectForKey:@"type"] && ![_workspace.connectionInfo.server isEqualToString:[infoDic objectForKey:@"server"]]) {
        Workspace *importWorkspace = [[Workspace alloc]init];
        WorkspaceConnectionInfo* info = [self setWorkspaceConnectionInfo:infoDic workspace:nil];
        
        if([importWorkspace open:info]){
            NSString *importPath = info.server;
            NSFileManager *manager = [NSFileManager defaultManager];
            
            int nSuffixCount = 0;
            if (info.type==SM_SXWU || info.type==SM_SMWU) {
                nSuffixCount = 5;
            }else{
                nSuffixCount = 4;
            }
            
            NSString * strTargetDir = strDirPath;
            
            if (strTargetDir==nil||strTargetDir.length==0) {
                //若未指定存放目录需构造默认目录
                NSString *currentPath = [_workspace.connectionInfo server];
                NSArray *arrCurrentPathStr = [currentPath componentsSeparatedByString:@"/"];
                NSString* strCurrentNameStr = [arrCurrentPathStr lastObject];
                // NSString* strTargetDirFather = [targetPath substringToIndex:targetPath.length-strTargetWorkspaceName.length];
                strTargetDir = [currentPath substringToIndex:currentPath.length-strCurrentNameStr.length-1];
                NSArray* arrSrcPathStr = [importPath componentsSeparatedByString:@"/"];
                NSArray* arrSrcWorkspaceName = [[arrSrcPathStr lastObject] componentsSeparatedByString:@"."];
                // 目标文件+importWorkspaceName
                strTargetDir = [NSString stringWithFormat:@"%@/%@", strTargetDir,[arrSrcWorkspaceName firstObject]];
            }
            
            BOOL bDirReady = YES;
            BOOL bNewDir = NO;
            BOOL bDir = NO;
            BOOL bExist = [manager fileExistsAtPath:strTargetDir isDirectory:&bDir];
            if (!bExist || !bDir) {
                bDirReady = [manager createDirectoryAtPath:strTargetDir withIntermediateDirectories:YES attributes:nil error:nil];
                bNewDir = YES;
            }
            if (!bDirReady) {
                return false;
            }
            
            // 重复的server处理
            //      1.文件型数据源：若bDatasourceRep，关闭原来数据源，拷贝新数据源并重新打开（alian保持原来的）
            //      2.网络型数据源：不再重复打开（alian保持原来的）
            NSMutableArray * arrTargetServers = [[NSMutableArray alloc]init];
            NSMutableArray * arrTargetAlians = [[NSMutableArray alloc]init];
            for (int i=0; i<_workspace.datasources.count; i++) {
                Datasource* datasource = [_workspace.datasources get:i];
                DatasourceConnectionInfo *datasourceInfo = [datasource datasourceConnectionInfo];
                if (datasourceInfo.engineType == ET_UDB || datasourceInfo.engineType == ET_IMAGEPLUGINS) {
                    //只要名字
                    if (bDatasourceRep) {
                        NSString* fullName = datasourceInfo.server;
                        NSArray * arrServer = [fullName componentsSeparatedByString:@"/"];
                        NSString* lastName = [arrServer lastObject];
                        NSString* fatherName = [fullName substringToIndex:fullName.length-lastName.length-1];
                        if ([fatherName isEqualToString:strTargetDir]) {
                            //同级目录下的才会被替换
                            [arrTargetServers addObject:lastName];
                            [arrTargetAlians addObject:datasourceInfo.alias];
                        }
                    }
                }else{
                    //网络数据集用完整url
                    [arrTargetServers addObject:datasourceInfo.server];
                    [arrTargetAlians addObject:datasourceInfo.alias];
                }
            }
            
            //数据源
            Datasources *datasourcesTemp = [importWorkspace datasources];
            //NSMutableDictionary *reAlianDic = [[NSMutableDictionary alloc]init];
            //更名数组
            NSMutableArray *arrAlian = [[NSMutableArray alloc]init];
            NSMutableArray *arrReAlian = [[NSMutableArray alloc]init];
            for (int i=0; i<datasourcesTemp.count; i++) {
                Datasource* dTemp = [datasourcesTemp get:i];
                if (![dTemp isOpended]) {
                    //没打开就跳过
                    continue;
                }
                DatasourceConnectionInfo *infoTemp = dTemp.datasourceConnectionInfo;
                NSString *strSrcServer = infoTemp.server;
                EngineType engineType = infoTemp.engineType;
                NSString *strSrcAlian = infoTemp.alias;
                NSString *strSrcUser = infoTemp.user;
                NSString *strSrcPassword = infoTemp.password;
                NSString* strTargetAlian = strSrcAlian;
                
                if(engineType==ET_UDB || engineType==ET_IMAGEPLUGINS){
                    
                    // 源文件存在？
                    if( ![self isDatasourceFileExist:strSrcServer isUDB:(engineType==ET_UDB)] ){
                        continue;
                    }
                    
                    NSArray *arrSrcServer = [strSrcServer componentsSeparatedByString:@"/"];
                    NSString *strFileName = [arrSrcServer lastObject];
                    // 导入工作空间名／数据源名字
                    NSString *strTargetServer = [NSString stringWithFormat:@"%@/%@",strTargetDir,strFileName];
                    
                    if (engineType==ET_UDB) {
                        
                        NSString * strSrcDatasourcePath = [strSrcServer substringToIndex:strSrcServer.length-4];
                        NSString * strTargetDatasourcePath = [strTargetServer substringToIndex:strTargetServer.length-4];
                        if (!bNewDir) {
                            // 检查重复性
                            bDir = YES;
                            bExist = [manager fileExistsAtPath:strTargetServer isDirectory:&bDir];
                            if (bExist && !bDir) {
                                //存在同名文件
                                if (bDatasourceRep) {
                                    //覆盖模式
                                    NSInteger nIndex = [arrTargetServers indexOfObject:strFileName];
                                    if (nIndex>=0 && nIndex<arrTargetServers.count) {
                                        // 替换alian 保证原来map有数据源
                                        strTargetAlian = [arrTargetAlians objectAtIndex:nIndex];
                                        [_workspace.datasources closeAlias:strTargetAlian];
                                        //删文件
                                        if(![manager removeItemAtPath:[strTargetDatasourcePath stringByAppendingString:@".udb"] error:nil]){
                                            continue;
                                        }
                                        if(![manager removeItemAtPath:[strTargetDatasourcePath stringByAppendingString:@".udd"] error:nil]){
                                            continue;
                                        }
                                    }else{
                                        //_worspace外的 直接删
                                        [manager removeItemAtPath:[strTargetDatasourcePath stringByAppendingString:@".udb"] error:nil];
                                        [manager removeItemAtPath:[strTargetDatasourcePath stringByAppendingString:@".udd"] error:nil];
                                    }
                                }else{
                                    //重名文件
                                    strTargetServer = [self formateNoneExistFileName:strTargetServer isDir:NO];
                                    strTargetDatasourcePath = [strTargetServer substringToIndex:strTargetServer.length-4];
                                }//rep
                            }//exist
                        }//!New
                        
                        // 拷贝udb
                        if(![manager copyItemAtPath:[strSrcDatasourcePath stringByAppendingString:@".udb"] toPath:[strTargetDatasourcePath stringByAppendingString:@".udb"] error:nil]){
                            continue;
                        }
                        // 拷贝udd
                        if(![manager copyItemAtPath:[strSrcDatasourcePath stringByAppendingString:@".udd"] toPath:[strTargetDatasourcePath stringByAppendingString:@".udd"] error:nil]){
                            continue;
                        }
                        
                    }else{
                        if (!bNewDir) {
                            // 检查重复性
                            bDir = YES;
                            bExist = [manager fileExistsAtPath:strTargetServer isDirectory:&bDir];
                            if (bExist && !bDir) {
                                //存在同名文件
                                if (bDatasourceRep) {
                                    //覆盖模式
                                    NSInteger nIndex = [arrTargetServers indexOfObject:strFileName];
                                    if (nIndex>=0 && nIndex<arrTargetServers.count) {
                                        // 替换alian 保证原来map有数据源
                                        strTargetAlian = [arrTargetAlians objectAtIndex:nIndex];
                                        [_workspace.datasources closeAlias:strTargetAlian];
                                        //删文件
                                        if(![manager removeItemAtPath:strTargetServer error:nil]){
                                            continue;
                                        }
                                    }else{
                                        //_worspace外的 直接删
                                        [manager removeItemAtPath:strTargetServer error:nil];
                                    }
                                }else{
                                    //重名文件
                                    strTargetServer = [self formateNoneExistFileName:strTargetServer isDir:NO];
                                }//rep
                            }//exist
                        }//!New
                        
                        // 拷贝
                        if(![manager copyItemAtPath:strSrcServer toPath:strTargetServer error:nil]){
                            continue;
                        }
                        
                    }//bUDB
                    // 打开
                    DatasourceConnectionInfo *temp = [[DatasourceConnectionInfo alloc]init];
                    temp.server = strTargetServer;
                    // 更名
                    strTargetAlian= [self formateNoneExistDatasourceAlian:strTargetAlian];
                    temp.alias = strTargetAlian;
                    temp.user = strSrcUser;
                    if(strSrcPassword && ![strSrcPassword isEqualToString:@""]){
                        temp.password = strSrcPassword;
                    }
                    temp.engineType =engineType;
                    
                    if ( [_workspace.datasources open:temp] ) {
                        //[reAlianDic setObject:strAlian forKey:infoTemp.alias];
                        if (![strTargetAlian isEqualToString:strSrcAlian]) {
                            [arrAlian addObject:strSrcAlian];
                            [arrReAlian addObject:strTargetAlian];
                        }
                    }
                    
                }
                else{
                    //url需要区分大小写吗？
                    NSInteger nIndex = [arrTargetServers indexOfObject:strSrcServer];
                    if (nIndex>=0 && nIndex<arrTargetServers.count) {
                        // 替换alian 保证原来map有数据源
                        strTargetAlian = [arrTargetAlians objectAtIndex:nIndex];
                        if (![strTargetAlian isEqualToString:strSrcAlian]) {
                            [arrAlian addObject:strSrcAlian];
                            [arrReAlian addObject:strTargetAlian];
                        }
                    }else{
                        strTargetAlian = [self formateNoneExistDatasourceAlian:strTargetAlian];
                        // web数据源
                        DatasourceConnectionInfo *temp = [[DatasourceConnectionInfo alloc]init];
                        temp.server = strSrcServer;
                        temp.alias = strTargetAlian;
                        temp.user = strSrcUser;
                        if(strSrcPassword && ![strSrcPassword isEqualToString:@""]){
                            temp.password = strSrcPassword;
                        }
                        temp.driver = infoTemp.driver;
                        temp.engineType = infoTemp.engineType;
                        
                        if ( [_workspace.datasources open:temp] ) {
                            if (![strTargetAlian isEqualToString:strSrcAlian]) {
                                [arrAlian addObject:strSrcAlian];
                                [arrReAlian addObject:strTargetAlian];
                            }
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
            [_workspace.resources.markerLibrary appendFromFile:strMarkerPath isReplace:bSymbolsRep];
            [_workspace.resources.lineLibrary appendFromFile:strLinePath isReplace:bSymbolsRep];
            [_workspace.resources.fillLibrary appendFromFile:strFillPath isReplace:bSymbolsRep];
            if (info.type!=SM_SXWU) {
                [manager removeItemAtPath:strMarkerPath error:nil];
                [manager removeItemAtPath:strLinePath error:nil];
                [manager removeItemAtPath:strFillPath error:nil];
            }
            
            
            Map *mapTemp = [[Map alloc]initWithWorkspace:importWorkspace];
            // map
            for (int i=0; i<importWorkspace.maps.count; i++) {
                
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
            bSucc = YES;
        }
        
        [info dispose];
        [importWorkspace dispose];
        bSucc = YES;
    }
    return bSucc;
}

//导出工作空间
//  失败情况：
//      a)工作空间未打开
//      b)导出文件名错误
//      c)非强制覆盖模式有同名sxm文件
//  流程：
//      1.新的工作空间目录，导出文件名可用？
//      2.新建workspace
//      3.导出列表中map，加到workspace.maps中
//      4.遍历datasource，拷贝其中文件数据源（注意覆盖模式），workspace打开数据源
//      5.导出符号库，workspace打开符号库
//      5.设置workspaceConnectionInfo，保存workspace

-(BOOL)exportMapNamed:(NSArray*)arrMapNames toFile:(NSString*)fileName isReplaceFile:(BOOL)bFileRep{
    if (_workspace==nil || fileName==nil||fileName.length==0||arrMapNames==nil||[arrMapNames count]==0||[_workspace.connectionInfo.server isEqualToString:fileName]) {
        return false;
    }
    
    NSFileManager *manager =  [NSFileManager defaultManager];
    //    SM_SXW = 4,
    //    SM_SMW = 5,
    //    SM_SXWU = 8,
    //    SM_SMWU = 9
    
    WorkspaceType workspaceType = SM_DEFAULT;
    NSString* strWorkspaceSuffix = [[fileName componentsSeparatedByString:@"."] lastObject];
    if ( [strWorkspaceSuffix isEqualToString:@"sxw"] ) {
        workspaceType = SM_SXW;
    }else if( [strWorkspaceSuffix isEqualToString:@"smw"] ){
        workspaceType = SM_SMW;
    }else if( [strWorkspaceSuffix isEqualToString:@"sxwu"] ){
        workspaceType = SM_SXWU;
    }else if( [strWorkspaceSuffix isEqualToString:@"smwu"] ){
        workspaceType = SM_SMWU;
    }else{
        return false;
    }
    
    //建目录
    NSString *desWorkspaceName = [[fileName componentsSeparatedByString:@"/"]lastObject];
    NSString *desDir = [fileName substringToIndex:fileName.length-desWorkspaceName.length-1];
    BOOL bDir = NO;
    BOOL bExist = [manager fileExistsAtPath:desDir isDirectory:&bDir];
    BOOL bNewDir = false;
    // 目录下受保护文件
    NSMutableArray *arrProtectedFile = [[NSMutableArray alloc]init];
    if (bExist && bDir) {
        for (int i=0; i<_workspace.datasources.count; i++) {
            Datasource* datasource = [_workspace.datasources get:i];
            DatasourceConnectionInfo *datasourceInfo = [datasource datasourceConnectionInfo];
            if (datasourceInfo.engineType == ET_UDB || datasourceInfo.engineType == ET_IMAGEPLUGINS) {
                //只要名字
                if (bFileRep) {
                    NSString* fullName = datasourceInfo.server;
                    NSArray * arrServer = [fullName componentsSeparatedByString:@"/"];
                    NSString* lastName = [arrServer lastObject];
                    NSString* fatherName = [fullName substringToIndex:fullName.length-lastName.length-1];
                    if ([fatherName isEqualToString:desDir]) {
                        //同级目录下的才会被替换
                        [arrProtectedFile addObject:fullName];
                    }
                }
            }
        }
        bNewDir = false;
    }else{
        if(![manager createDirectoryAtPath:desDir withIntermediateDirectories:YES attributes:nil error:nil]){
            return false;
        }
        bNewDir = true;
    }
    //文件名
    bDir = NO;
    bExist = [manager fileExistsAtPath:fileName isDirectory:&bDir];
    if (bExist && !bDir) {
        if(bFileRep){
            [manager removeItemAtPath:fileName error:nil];
        }else{
            return false;
        }
    }
    
    Workspace *workspaceDes = [[Workspace alloc]init];
    // map用到的datasource
    NSMutableArray *arrDatasources = [[NSMutableArray alloc]init];
    
    Map *mapExport = [[Map alloc]initWithWorkspace:_workspace];
    
    for (int k=0; k<arrMapNames.count; k++) {
        NSString *mapName = [arrMapNames objectAtIndex:k];
        if ([_workspace.maps indexOf:mapName]!=-1) {
            // 打开map
            [mapExport open:mapName];
            // 不重复的datasource保存
            for (int i=0; i<mapExport.layers.getCount; i++) {
                Datasource *datasource = [[[mapExport.layers getLayerAtIndex:i] dataset]datasource];
                if (![arrDatasources containsObject:datasource]) {
                    [arrDatasources addObject:datasource];
                }
            }
            NSString* strMapXML = [mapExport toXML];
            [workspaceDes.maps add:mapName withXML:strMapXML];
            [mapExport close];
        }
    }
    
    // 导出datasource
    for (int i=0; i<arrDatasources.count; i++) {
        Datasource *datasource = [arrDatasources objectAtIndex:i];
        // 文件拷贝
        DatasourceConnectionInfo *srcInfo = [datasource datasourceConnectionInfo];
        NSString *strSrcServer = srcInfo.server;
        EngineType engineType = srcInfo.engineType;
        NSString *strTargetServer = strSrcServer;
        if (engineType == ET_UDB || engineType == ET_IMAGEPLUGINS) {
            
            // 源文件存在？
            if( ![self isDatasourceFileExist:strSrcServer isUDB:(engineType==ET_UDB)] ){
                continue;
            }
            
            NSArray *arrSrcServer = [strSrcServer componentsSeparatedByString:@"/"];
            NSString *strFileName = [arrSrcServer lastObject];
            // 导入工作空间名
            strTargetServer = [NSString stringWithFormat:@"%@/%@",desDir,strFileName];
            
            if (engineType==ET_UDB) {
                
                NSString * strSrcDatasourcePath = [strSrcServer substringToIndex:strSrcServer.length-4];
                NSString * strTargetDatasourcePath = [strTargetServer substringToIndex:strTargetServer.length-4];
                if (!bNewDir) {
                    // 检查重复性
                    if ([arrProtectedFile containsObject:strTargetServer]) {
                        continue;
                    }
                    bDir = YES;
                    bExist = [manager fileExistsAtPath:strTargetServer isDirectory:&bDir];
                    if (bExist && !bDir) {
                        //存在同名文件
                        if (bFileRep) {
                            //覆盖模式
                            [manager removeItemAtPath:[strTargetDatasourcePath stringByAppendingString:@".udb"] error:nil];
                            [manager removeItemAtPath:[strTargetDatasourcePath stringByAppendingString:@".udd"] error:nil];
                        }else{
                            //重名文件
                            strTargetServer = [self formateNoneExistFileName:strTargetServer isDir:NO];
                            strTargetDatasourcePath = [strTargetServer substringToIndex:strTargetServer.length-4];
                        }//rep
                    }//exist
                }//!New
                
                // 拷贝udb
                if(![manager copyItemAtPath:[strSrcDatasourcePath stringByAppendingString:@".udb"] toPath:[strTargetDatasourcePath stringByAppendingString:@".udb"] error:nil]){
                    continue;
                }
                // 拷贝udd
                if(![manager copyItemAtPath:[strSrcDatasourcePath stringByAppendingString:@".udd"] toPath:[strTargetDatasourcePath stringByAppendingString:@".udd"] error:nil]){
                    continue;
                }
                
            }else{
                if (!bNewDir) {
                    // 检查重复性
                    if ([arrProtectedFile containsObject:strTargetServer]) {
                        continue;
                    }
                    bDir = YES;
                    bExist = [manager fileExistsAtPath:strTargetServer isDirectory:&bDir];
                    if (bExist && !bDir) {
                        //存在同名文件
                        if (bFileRep) {
                            //覆盖模式
                            [manager removeItemAtPath:strTargetServer error:nil];
                        }else{
                            //重名文件
                            strTargetServer = [self formateNoneExistFileName:strTargetServer isDir:NO];
                        }//rep
                    }//exist
                }//!New
                
                // 拷贝
                if(![manager copyItemAtPath:strSrcServer toPath:strTargetServer error:nil]){
                    continue;
                }
            }//bUDB
        }
        DatasourceConnectionInfo *desInfo = [[DatasourceConnectionInfo alloc]init];
        desInfo.server = strTargetServer;
        desInfo.alias = srcInfo.alias;
        desInfo.engineType = srcInfo.engineType;
        desInfo.user = srcInfo.user;
        if (srcInfo.password && ![srcInfo.password isEqualToString:@""]) {
            desInfo.password = srcInfo.password;
        }
        [workspaceDes.datasources open:desInfo];
    }
    
    // symbol lib
    NSString*serverResourceBase = [fileName substringToIndex:fileName.length-strWorkspaceSuffix.length];
    NSString*strMarkerPath = [serverResourceBase stringByAppendingString:@".sym"];
    NSString*strLinePath = [serverResourceBase stringByAppendingString:@".lsl"];
    NSString*strFillPath = [serverResourceBase stringByAppendingString:@".bru"];
    if (workspaceType!=SM_SXWU) {
        //重命名
        strMarkerPath = [self formateNoneExistFileName:strMarkerPath isDir:NO];
        strLinePath = [self formateNoneExistFileName:strLinePath isDir:NO];
        strFillPath = [self formateNoneExistFileName:strFillPath isDir:NO];
    }
    
    [_workspace.resources.markerLibrary saveAs:strMarkerPath];
    [_workspace.resources.lineLibrary saveAs:strLinePath];
    [_workspace.resources.fillLibrary saveAs:strFillPath];
    // 导入
    [workspaceDes.resources.markerLibrary appendFromFile:strMarkerPath isReplace:YES];
    [workspaceDes.resources.lineLibrary appendFromFile:strLinePath isReplace:YES];
    [workspaceDes.resources.fillLibrary appendFromFile:strFillPath isReplace:YES];
    if (workspaceType!=SM_SXWU) {
        [manager removeItemAtPath:strMarkerPath error:nil];
        [manager removeItemAtPath:strLinePath error:nil];
        [manager removeItemAtPath:strFillPath error:nil];
    }
    
    // fileName查重
    //WorkspaceConnectionInfo *workspaceInfo = [[WorkspaceConnectionInfo alloc]initWithFile:fileName];
    [workspaceDes.connectionInfo setType:workspaceType];
    [workspaceDes.connectionInfo setServer:fileName];
    //[workspaceDes.connectionInfo setVersion:UGC60];
    [workspaceDes save];
    [workspaceDes close];
    
    return true;
}

@end

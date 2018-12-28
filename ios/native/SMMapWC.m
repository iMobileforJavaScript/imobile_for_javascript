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
#import "SuperMap/SymbolLine.h"
#import "SuperMap/SymbolFill.h"
#import "SuperMap/Geometry.h"
#import "SuperMap/GeoStyle.h"
#import "SMap.h"


@implementation SMMapWC

- (BOOL)openWorkspace:(NSDictionary*)infoDic {
    @try {
        bool openWsResult = YES;
        if (infoDic && [infoDic objectForKey:@"server"] && ![SMap.singletonInstance.smMapWC.workspace.connectionInfo.server isEqualToString:[infoDic objectForKey:@"server"]]) {
            if (SMap.singletonInstance.smMapWC.workspace && [SMap.singletonInstance.smMapWC.workspace.caption isEqualToString:@"UntitledWorkspace"]) {
//                if (![SMap.singletonInstance.smMapWC.workspace.caption isEqualToString:@"UntitledWorkspace"]) {
//                    [SMap.singletonInstance.smMapWC.workspace close];
//                }
                [SMap.singletonInstance.smMapWC.workspace dispose];
                SMap.singletonInstance.smMapWC.workspace = [[Workspace alloc] init];
            }
            
            WorkspaceConnectionInfo* info = [[WorkspaceConnectionInfo alloc] init];
            info = [self setWorkspaceConnectionInfo:infoDic workspace:nil];
            
            openWsResult = [SMap.singletonInstance.smMapWC.workspace open:info];
            // SMap.singletonInstance.smMapWC.workspace =
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
        Datasource* tempDs = [params objectForKey:@"alias"] ? [SMap.singletonInstance.smMapWC.workspace.datasources getAlias:[params objectForKey:@"alias"]] : nil;
        BOOL isOpen = tempDs && [params objectForKey:@"server"] && [tempDs.datasourceConnectionInfo.server isEqualToString:[params objectForKey:@"server"]] && [tempDs isOpended];
        Datasource* dataSource = isOpen ? tempDs : nil;
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
            
//            if([SMap.singletonInstance.smMapWC.workspace.datasources indexOf:info.alias] != -1){
//                [SMap.singletonInstance.smMapWC.workspace.datasources closeAlias:info.alias];
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
            dataSource = [SMap.singletonInstance.smMapWC.workspace.datasources open:info];
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
        
        Datasource* datasource = [SMap.singletonInstance.smMapWC.workspace.datasources getAlias:datasourceName];
        if (datasource == nil || datasource.isReadOnly) {
            DatasourceConnectionInfo* info = [[DatasourceConnectionInfo alloc] init];
            NSString* dsType = @"udb";
            
            info.alias = datasourceName;
            info.engineType = ET_UDB;
            [SMFileUtil createFileDirectories:datasourcePath];
            info.server = [NSString stringWithFormat:@"%@/%@.%@", datasourcePath, datasourceName, dsType];
            datasource = [SMap.singletonInstance.smMapWC.workspace.datasources create:info];
            if (datasource == nil) {
                datasource = [SMap.singletonInstance.smMapWC.workspace.datasources open:info];
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
    Workspace* workspace = SMap.singletonInstance.smMapWC.workspace;
    if(workspace == nil) return NO;
    
    bool saved = [workspace save];
    return saved;
}

- (BOOL)saveWorkspaceWithInfo:(NSDictionary*)infoDic{
    Workspace* workspace = SMap.singletonInstance.smMapWC.workspace;
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

-(NSString*)formateNoneExistDatasourceAlian:(NSString*)alian ofWorkspace:(Workspace*)workspaceTemp{
    if (workspaceTemp==nil) {
        return alian;
    }
    NSString *resultAlian = alian;
    int nAddNumber = 1;
    while ([workspaceTemp.datasources indexOf:resultAlian]!=-1) {
        resultAlian = [NSString stringWithFormat:@"%@#%d",alian,nAddNumber];
        nAddNumber++;
    }
    return resultAlian;
}

-(NSString*)formateNoneExistMapName:(NSString*)name ofWorkspace:(Workspace*)workspaceTemp{
    if (workspaceTemp==nil) {
        return name;
    }
    NSString *resultName = name;
    int nAddNumber = 1;
    while ([workspaceTemp.maps indexOf:resultName]!=-1) {
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

// arrAlian中值不重复
// arrNewAlian中值不重复
// arrAlian与arrNewAlian对应位不等

-(NSString*)modifyXML:(NSString*)strXML replace:(NSArray*)arrAlian with:(NSArray*)arrNewAlian{
    
    NSSet *setAlian= [NSSet setWithArray:arrAlian];
    if (setAlian.count!=arrAlian.count) {
        NSLog(@"error:XML modify with redefined srcString!!");
    }
    NSSet *setNewAlian= [NSSet setWithArray:arrNewAlian];
    if (setNewAlian.count!=arrNewAlian.count) {
        NSLog(@"error:XML modify with redefined desString!!");
    }
    
    int nCount = arrAlian.count;
    int pRespace[nCount];
    
    for (int i=0; i<nCount; i++) {
        pRespace[i] = [arrAlian indexOfObject:arrNewAlian[i]];
        if (pRespace[i]<0 || pRespace[i]>=nCount) {
            pRespace[i] = -1;  //源外的
        }
    }
    
    // -2处理过 -1不在源内 i为所指list
    
    NSMutableArray *arrLists = [[NSMutableArray alloc]init];
    for (int i=0; i<nCount; i++) {
        int nIndex = pRespace[i];
        if (nIndex == -2) {
            //已经处理过 在list中
            continue;
        }else{
            
            NSMutableArray *arrTemp = [[NSMutableArray alloc]init];
            [arrTemp addObject:arrAlian[i]];//list头
            int nPreIndex = i;
            while (nIndex > i) {
                
                [arrTemp addObject:arrAlian[nIndex]];//加到list中
                nPreIndex = nIndex;
                nIndex = pRespace[nPreIndex];
                pRespace[nPreIndex] = -2;//标记处理过了
                
            }
            if (nIndex==i || nIndex==-1) {
                //循环 || 源外的
                
                int nListIndex = arrLists.count;
                [arrTemp addObject:arrNewAlian[nPreIndex]];
                [arrLists addObject:arrTemp];
                pRespace[i] = nListIndex;
                
                
            }else if(nIndex >= 0){
                
                //添加到其他表头
                int nListIndex = pRespace[nIndex];
                NSArray *arrListTemp = arrLists[ nListIndex ];
                [arrTemp addObjectsFromArray:arrListTemp];
                [arrLists replaceObjectAtIndex:nListIndex withObject:arrTemp];
                pRespace[nIndex] = -2;
                pRespace[i] = nListIndex;
                
                
            }else{
                //error
                NSLog(@"error_____wnmng");
            }
            
        }
        
    }
    
    
    NSString* strResult = strXML;
    for (int i=0; i<arrLists.count; i++) {
        NSMutableArray *arrListTemp = arrLists[i];
        if ([[arrListTemp firstObject] isEqualToString:[arrListTemp lastObject]]) {
            int ntemp = 1;
            NSString *strTail = [arrListTemp lastObject];
            NSString *strTmp =[ NSString stringWithFormat:@"%@#%d" ,strTail,ntemp ];
            while ([strResult containsString: [NSString stringWithFormat:@"<sml:DataSourceAlias>%@</sml:DataSourceAlias>",strTmp] ]
                   || [arrNewAlian containsObject:strTmp] ) {
                ntemp++;
                strTmp = [ NSString stringWithFormat:@"%@#%d" ,strTail,ntemp ];
            }
            [arrListTemp replaceObjectAtIndex:arrListTemp.count-1 withObject:strTmp];
            strResult = [self modifyXML:strResult with:arrListTemp];
            NSArray *arrStrTemp_Tail = [NSArray arrayWithObjects:strTmp,strTail, nil];
            strResult = [self modifyXML:strResult with:arrStrTemp_Tail];
        }else{
            strResult = [self modifyXML:strResult with:arrListTemp];
        }
        
    }
    
    return strResult;
}

-(NSString*)modifyXML:(NSString*)strXML with:(NSArray*)arrString{
    NSString*strResult = strXML;
    int nIndex = arrString.count-1;
    while (nIndex>0) {
        NSString *strSrc = [NSString stringWithFormat:@"<sml:DataSourceAlias>%@</sml:DataSourceAlias>",arrString[nIndex-1]];
        NSString *strReplace = [NSString stringWithFormat:@"<sml:DataSourceAlias>%@</sml:DataSourceAlias>",arrString[nIndex]];
        strResult = [strResult stringByReplacingOccurrencesOfString:strSrc withString:strReplace];
        nIndex--;
    }
    return strResult;
}

//导入工作空间
//  失败情况：
//      a)info为空或sever为空或type为空 或导入工作空间为SMap.singletonInstance.smMapWC.workspace
//      b)打开工作空间失败
//      c)SMap.singletonInstance.smMapWC.workspace没初始化
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
    
    if (SMap.singletonInstance.smMapWC.workspace && infoDic && [infoDic objectForKey:@"server"] && [infoDic objectForKey:@"type"] && ![SMap.singletonInstance.smMapWC.workspace.connectionInfo.server isEqualToString:[infoDic objectForKey:@"server"]]) {
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
                NSString *currentPath = [SMap.singletonInstance.smMapWC.workspace.connectionInfo server];
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
            for (int i=0; i<SMap.singletonInstance.smMapWC.workspace.datasources.count; i++) {
                Datasource* datasource = [SMap.singletonInstance.smMapWC.workspace.datasources get:i];
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
                                        [SMap.singletonInstance.smMapWC.workspace.datasources closeAlias:strTargetAlian];
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
                                        [SMap.singletonInstance.smMapWC.workspace.datasources closeAlias:strTargetAlian];
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
                    strTargetAlian= [self formateNoneExistDatasourceAlian:strTargetAlian ofWorkspace:_workspace];
                    temp.alias = strTargetAlian;
                    temp.user = strSrcUser;
                    if(strSrcPassword && ![strSrcPassword isEqualToString:@""]){
                        temp.password = strSrcPassword;
                    }
                    temp.engineType =engineType;
                    
                    if ( [SMap.singletonInstance.smMapWC.workspace.datasources open:temp] ) {
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
                        strTargetAlian = [self formateNoneExistDatasourceAlian:strTargetAlian ofWorkspace:_workspace];
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
                        
                        if ( [SMap.singletonInstance.smMapWC.workspace.datasources open:temp] ) {
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
            [SMap.singletonInstance.smMapWC.workspace.resources.markerLibrary appendFromFile:strMarkerPath isReplace:bSymbolsRep];
            [SMap.singletonInstance.smMapWC.workspace.resources.lineLibrary appendFromFile:strLinePath isReplace:bSymbolsRep];
            [SMap.singletonInstance.smMapWC.workspace.resources.fillLibrary appendFromFile:strFillPath isReplace:bSymbolsRep];
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
                NSString* strMapName = [self formateNoneExistMapName:mapTemp.name ofWorkspace:_workspace];
                [mapTemp close];
                
                // 替换XML字段
                NSString* strTargetMapXML = [self modifyXML:strSrcMapXML replace:arrAlian with:arrReAlian];
                [SMap.singletonInstance.smMapWC.workspace.maps add:strMapName withXML:strTargetMapXML];
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
    if (SMap.singletonInstance.smMapWC.workspace==nil || fileName==nil||fileName.length==0||arrMapNames==nil||[arrMapNames count]==0||[SMap.singletonInstance.smMapWC.workspace.connectionInfo.server isEqualToString:fileName]) {
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
        for (int i=0; i<SMap.singletonInstance.smMapWC.workspace.datasources.count; i++) {
            Datasource* datasource = [SMap.singletonInstance.smMapWC.workspace.datasources get:i];
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
    
    Map *mapExport = [[Map alloc]initWithWorkspace:SMap.singletonInstance.smMapWC.workspace];
    
    for (int k=0; k<arrMapNames.count; k++) {
        NSString *mapName = [arrMapNames objectAtIndex:k];
        if ([SMap.singletonInstance.smMapWC.workspace.maps indexOf:mapName]!=-1) {
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
    
    [SMap.singletonInstance.smMapWC.workspace.resources.markerLibrary saveAs:strMarkerPath];
    [SMap.singletonInstance.smMapWC.workspace.resources.lineLibrary saveAs:strLinePath];
    [SMap.singletonInstance.smMapWC.workspace.resources.fillLibrary saveAs:strFillPath];
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

-(NSArray*)findIntValuesFromXML:(NSString*)strXML withTag:(NSString*)strTag{
    NSMutableArray *arrValues = [[NSMutableArray alloc]init];
    NSString * strTagHead = [NSString stringWithFormat:@"<%@>",strTag];
    NSString * strTagTail = [NSString stringWithFormat:@"</%@>",strTag];
    NSArray *arrStrXML = [strXML componentsSeparatedByString:strTagHead];
    for (int i=1; i<arrStrXML.count; i++) {
        NSString *strTemp = [arrStrXML objectAtIndex:i];
        NSString *strValue = [[strTemp componentsSeparatedByString:strTagTail] firstObject];
        int nValue = [strValue intValue];
        [arrValues addObject:[NSNumber numberWithInt:nValue]];
    }
    return arrValues;
}

//从srcGroup导入Symbol到desGroup
//bDirRetain 保留srcGroup的目录结构，否则所有的Symbol都放在desGroup而不是其子group中
//bSymReplace 相同id的处理：true替换 false新id

-(void)importSymbolsFrom:(SymbolGroup*)srcGroup toGroup:(SymbolGroup*)desGroup isDirRetain:(BOOL)bDirRetain isSymbolReplace:(BOOL)bSymReplace{
    if (desGroup.symbolLibrary==nil) {
        //deGroup必须是必须在Lib中
        return;
    }
    // group的名称 symbol的id 都需要desLib查重名
    SymbolLibrary *desLib = desGroup.symbolLibrary;
    
    for (int i=0; i<srcGroup.count; i++) {
        Symbol * sym = [srcGroup getSymbolWithIndex:i];
        if(bSymReplace && [desLib containID:sym.getID]){
            [desLib removeWithID:sym.getID];
        }
        [desLib add:sym toGroup:desGroup];
    }
    
    SymbolGroup* desSubGroup = desGroup;
    SymbolGroups *srcChildGroups = srcGroup.childSymbolGroups;
    for (int j=0; j<srcChildGroups.count; j++) {
        SymbolGroup *subGroup = [srcChildGroups getGroupWithIndex:j];
        
        if (bDirRetain) {
            NSString* subName = subGroup.name;
            int nAddNum = 1;
            while ([desLib.rootGroup.childSymbolGroups indexofGroup:subName]!=-1) {
                subName = [NSString stringWithFormat:@"%@#%d",subGroup.name,nAddNum];
                nAddNum++;
            }
            desSubGroup = [desGroup.childSymbolGroups createGroupWith:subName];
        }
        
        [self importSymbolsFrom:subGroup toGroup:desSubGroup isDirRetain:bDirRetain isSymbolReplace:bSymReplace];
    }
    
    return;
}

//static NSString *g_strCustomerDirectory = nil;
-(NSString *)getCustomerDirectory{
    NSString *strServer = SMap.singletonInstance.smMapWC.workspace.connectionInfo.server;
    NSString *strRootFolder = [strServer substringToIndex: strServer.length - [[strServer componentsSeparatedByString:@"/"]lastObject].length-1];
    return strRootFolder;
    //    if (g_strCustomerDirectory==nil) {
    //        g_strCustomerDirectory = [NSHomeDirectory() stringByAppendingString:@"/Documents/iTablet/User/Customer"];
    //    }
    //    return g_strCustomerDirectory;
    //    //return @"/Customer";
    //}
    //-(void)setCustomerDirectory:(NSString *)strValue{
    //    g_strCustomerDirectory = strValue;
}

-(NSString*)getModuleDirectory:(int)nModule{
    switch (nModule) {
        case 0:  /*模块0*/
            return  @"模块0";
        case 1:  /*模块0*/
            return  @"模块1";
        default:
            return nil;
    }
}

// 导入文件工作空间到程序目录
//      拆分文件工作空间成为多个map.xml及其资源文件到程序相应目录
// 目录结构：
//      Customer:
//          \------->Map:           旗下包含模块子文件夹，存放map.xml和map.exp文件
//          \------->Datasource:    旗下包含模块子文件夹，存放文件数据源文件
//          \------->Resource:      旗下包含模块子文件夹，存放符号库文件（.sym/.lsl./bru）
// 返回结果：NSArray为导入成功的所有地图名

-(NSArray *)importWorkspaceInfo:(NSDictionary *)infoDic toModule:(NSString*)strModule/*(int)nModule*/{
    NSArray *arrResult = nil;
    if ( infoDic && [infoDic objectForKey:@"server"] && [infoDic objectForKey:@"type"] && ![_workspace.connectionInfo.server isEqualToString:[infoDic objectForKey:@"server"]]) {
        Workspace *importWorkspace = [[Workspace alloc]init];
        WorkspaceConnectionInfo* info = [self setWorkspaceConnectionInfo:infoDic workspace:nil];
        
        if([importWorkspace open:info]){
            
            NSMutableDictionary *dicAddition = [[NSMutableDictionary alloc]init];
            
            //模版
            //if ([strModule isEqualToString:@"Collection"]/*采集模块*/) {
                NSString *strServer = [infoDic objectForKey:@"server"];
                NSString *strRootDir =[strServer substringToIndex:strServer.length-[[strServer componentsSeparatedByString:@"/"]lastObject].length-1];
                NSArray *arrSubs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:strRootDir error:nil];
                for (int i=0; i<arrSubs.count; i++) {
                    NSString *strSub = [arrSubs objectAtIndex:i];
                    if ([strSub hasSuffix:@".xml"]) {
                        NSString *strSrcTemplate = [NSString stringWithFormat:@"%@/%@",strRootDir,strSub];
                        NSString *strDesTemplate = [NSString stringWithFormat:@"%@/Template/%@",[self getCustomerDirectory],strSub];
                        strDesTemplate = [self formateNoneExistFileName:strDesTemplate isDir:NO];
                        NSString *strNewSub = [[strDesTemplate componentsSeparatedByString:@"/"]lastObject];
                        
                        [[NSFileManager defaultManager]copyItemAtPath:strSrcTemplate toPath:strDesTemplate error:nil];
                        [dicAddition setObject:strNewSub forKey:@"Template"];
                        
                        break;
                    }
                }
            //}


            NSMutableArray *arrTemp = [[NSMutableArray alloc]init];
            for (int i=0; i<importWorkspace.maps.count; i++) {
                NSString *strMapName = [importWorkspace.maps get:i];
                NSString *strResName = [self saveMapName:strMapName fromWorkspace:importWorkspace ofModule:strModule withAddition:dicAddition isNewMap:YES isResourcesModyfied:false];
                if(strResName!=nil){
                    [arrTemp addObject:strResName];
                }
            }
            if(arrTemp.count>0){
                arrResult = arrTemp;
            }
        }
        
        [importWorkspace close];
        [importWorkspace dispose];
        
    }
    return arrResult;
    
}

//
// 返回保存成功地图名
//
// 导出(保存)工作空间中地图到模块
// 参数：
//      strMapAlians: 导出的地图别名（一般即为保存文件名）
//      srcWorkspace: 内存工作空间
//      nModule: 模块id，对应模块名
//      bNew: 是否是外部导入程序的地图；是，则需要检查.xml和.exp命名避免覆盖,另外需要文件数据源和符号库的拷贝；否，则直接替换.xml和.exp
//      bResourcesModified: 导出时是否考虑地图用到的符号库外的符号追加到符号库
// 条件：
//      1.srcWorkspace打开
//      2.srcWorkspace包含地图
//      3.模块存在
//
-(NSString*)saveMapName:(NSString*)strMapAlians fromWorkspace:(Workspace*)srcWorkspace ofModule:(NSString*)strModule withAddition:(NSDictionary*)dicAddition isNewMap:(BOOL)bNew isResourcesModyfied:(BOOL)bResourcesModified{
    
    if(srcWorkspace==nil || [srcWorkspace.maps indexOf:strMapAlians]==-1){
        return nil;
    }
    
    NSString *strCustomer = [self getCustomerDirectory];
    //NSString *strModule = [self getModuleDirectory:nModule];
//    if (strModule == nil) {
//        return nil;
//    }
    
    Map *mapExport = [[Map alloc]initWithWorkspace:srcWorkspace];
    
    if(![mapExport open:strMapAlians]){
        //打开失败
        return nil;
    }
    
    NSString* desDirMap =  [NSString stringWithFormat:@"%@/Map",strCustomer];
    if(strModule!=nil){
        desDirMap = [NSString stringWithFormat:@"%@/%@",desDirMap,strModule];
    }
    BOOL isDir = false;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:desDirMap isDirectory:&isDir];
    if (!isExist || !isDir) {
        [[NSFileManager defaultManager] createDirectoryAtPath:desDirMap withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *strMapName = strMapAlians;
    // map文件
    NSString* desPathMapXML = [NSString stringWithFormat:@"%@/%@.xml",desDirMap,strMapName];
    NSString* desPathMapExp ;
    if (!bNew) {
        // 删文件
        isDir = true;
        isExist = [[NSFileManager defaultManager]fileExistsAtPath:desPathMapXML isDirectory:&isDir];
        if (isExist && !isDir) {
            [[NSFileManager defaultManager]removeItemAtPath:desPathMapXML error:nil];
        }
        desPathMapExp = [NSString stringWithFormat:@"%@/%@.exp",desDirMap,strMapName];
        isExist = [[NSFileManager defaultManager]fileExistsAtPath:desPathMapExp isDirectory:&isDir];
        if (isExist && !isDir) {
            [[NSFileManager defaultManager]removeItemAtPath:desPathMapXML error:nil];
        }
        
    }else{
        // 改名
        desPathMapXML = [self formateNoneExistFileName:desPathMapXML isDir:NO];
        NSString * desLastMap = [[desPathMapXML componentsSeparatedByString:@"/"]lastObject];
        // map文件名确定后其他文件（符号库）不需要判断，直接覆盖
        strMapName = [desLastMap substringToIndex:desLastMap.length-4];
        desPathMapExp = [NSString stringWithFormat:@"%@/%@.exp",desDirMap,strMapName];
    }
    
    
    // map xml
    NSString* strMapXML = [mapExport toXML];
    [strMapXML writeToFile:desPathMapXML atomically:YES encoding:NSUTF8StringEncoding error:nil];
    //NSString*newstr = [NSString stringWithContentsOfFile:desPathMapXML encoding:NSUTF8StringEncoding error:nil];
    
    //bResourcesModified时存所有用到的符号id
    NSMutableSet *setMarkerIDs = [[NSMutableSet alloc]init];
    NSMutableSet *setLineIDs = [[NSMutableSet alloc]init];
    NSMutableSet *setFillIDs = [[NSMutableSet alloc]init];
    
    //    NSMutableArray *arrMarkerIDs = [[NSMutableArray alloc]init];
    //    NSMutableArray *arrLineIDs = [[NSMutableArray alloc]init];
    //    NSMutableArray *arrFillIDs = [[NSMutableArray alloc]init];
    // datasources
    NSMutableArray *arrDatasources = [[NSMutableArray alloc]init];
    for (int i=0; i<mapExport.layers.getCount; i++) {
        Layer *layer = [mapExport.layers getLayerAtIndex:i];
        
        Datasource *datasource = [[layer dataset]datasource];
        if (![arrDatasources containsObject:datasource]) {
            [arrDatasources addObject:datasource];
        }
        //处理newSymbol
        //cad
        if(bResourcesModified && layer.dataset.datasetType == CAD){
            Recordset *recordset = [(DatasetVector*)layer.dataset recordset:NO cursorType:STATIC];
            [recordset moveFirst];
            while ([recordset isEOF]) {
                Geometry *geoTemp = [recordset geometry];
                [recordset moveNext];
                GeoStyle *styleTemp = [geoTemp getStyle];
                int nMarkerID = [styleTemp getMarkerSymbolID];
                int nLineID = [styleTemp getLineSymbolID];
                int nFillID = [styleTemp getFillSymbolID];
                if (nMarkerID>0) {
                    [setMarkerIDs addObject:[NSNumber numberWithInt:nMarkerID]];
                }
                if (nLineID>0) {
                    [setLineIDs addObject:[NSNumber numberWithInt:nLineID]];
                }
                if (nFillID>0) {
                    [setFillIDs addObject:[NSNumber numberWithInt:nFillID]];
                }
            }
            [recordset close];
        }
        
    }
    
    NSString *desDatasourceDir = [NSString stringWithFormat:@"%@/Datasource",strCustomer];
    if(strModule!=nil){
        desDatasourceDir = [NSString stringWithFormat:@"%@/%@",desDatasourceDir,strModule];
    }
    isDir = false;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:desDatasourceDir isDirectory:&isDir];
    if (!isExist || !isDir) {
        [[NSFileManager defaultManager] createDirectoryAtPath:desDatasourceDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    NSMutableArray *arrExpDatasources = [[NSMutableArray alloc]init];
    //[[NSFileManager defaultManager]createDirectoryAtPath:desDataDir withIntermediateDirectories:YES attributes:nil error:nil];
    // 导出datasource  datasource名=文件名
    for (int i=0; i<arrDatasources.count; i++) {
        Datasource *datasource = [arrDatasources objectAtIndex:i];
        // 文件拷贝
        DatasourceConnectionInfo *srcInfo = [datasource datasourceConnectionInfo];
        NSString *strSrcAlian = srcInfo.alias;
        NSString *strSrcServer = srcInfo.server;
        EngineType engineType = srcInfo.engineType;
        NSString *strTargetServer = strSrcServer;
        //---------》》》》》只有一部分new怎么办？
        if (bNew) {
            if (engineType == ET_UDB || engineType == ET_IMAGEPLUGINS) {
                
                // 源文件存在？
                if( ![self isDatasourceFileExist:strSrcServer isUDB:(engineType==ET_UDB)] ){
                    continue;
                }
                
                NSArray *arrSrcServer = [strSrcServer componentsSeparatedByString:@"/"];
                NSString *strFileName = [arrSrcServer lastObject];
                // 导入工作空间名
                strTargetServer = [NSString stringWithFormat:@"%@/%@",desDatasourceDir,strFileName];
                
                if (engineType==ET_UDB) {
                    
                    NSString * strSrcDatasourcePath = [strSrcServer substringToIndex:strSrcServer.length-4];
                    NSString * strTargetDatasourcePath = [strTargetServer substringToIndex:strTargetServer.length-4];
                    
                    // 检查重复性
                    BOOL bDir = YES;
                    BOOL bExist = [[NSFileManager defaultManager] fileExistsAtPath:strTargetServer isDirectory:&bDir];
                    if (bExist && !bDir) {
                        //存在同名文件
                        //重名文件
                        strTargetServer = [self formateNoneExistFileName:strTargetServer isDir:NO];
                        strTargetDatasourcePath = [strTargetServer substringToIndex:strTargetServer.length-4];
                    }//exist
                    
                    // 拷贝udb
                    if(![[NSFileManager defaultManager] copyItemAtPath:[strSrcDatasourcePath stringByAppendingString:@".udb"] toPath:[strTargetDatasourcePath stringByAppendingString:@".udb"] error:nil]){
                        continue;
                    }
                    // 拷贝udd
                    if(![[NSFileManager defaultManager] copyItemAtPath:[strSrcDatasourcePath stringByAppendingString:@".udd"] toPath:[strTargetDatasourcePath stringByAppendingString:@".udd"] error:nil]){
                        continue;
                    }
                    
                }else{
                    
                    BOOL bDir = YES;
                    BOOL bExist = [[NSFileManager defaultManager] fileExistsAtPath:strTargetServer isDirectory:&bDir];
                    if (bExist && !bDir) {
                        //存在同名文件
                        //重名文件
                        strTargetServer = [self formateNoneExistFileName:strTargetServer isDir:NO];
                    }//exist
                    
                    
                    // 拷贝
                    if(![[NSFileManager defaultManager] copyItemAtPath:strSrcServer toPath:strTargetServer error:nil]){
                        continue;
                    }
                }//bUDB
            }
        }
        
        if (engineType == ET_UDB || engineType == ET_IMAGEPLUGINS){
            strTargetServer = [strTargetServer substringFromIndex:desDatasourceDir.length+1];
        }
        
        NSDictionary *dicDatasource = @{ @"Alians":strSrcAlian , @"Server":strTargetServer , @"Type":[NSNumber numberWithInt:engineType] };
        [arrExpDatasources addObject:dicDatasource];
        //user password
    }
    
    NSString *desResourceDir = [NSString stringWithFormat:@"%@/Symbol",strCustomer];
    if(strModule!=nil){
        desResourceDir = [NSString stringWithFormat:@"%@/%@",desResourceDir,strModule];
    }
    
    isDir = false;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:desResourceDir isDirectory:&isDir];
    if (!isExist || !isDir) {
        [[NSFileManager defaultManager] createDirectoryAtPath:desResourceDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    NSString* desResources = [NSString stringWithFormat:@"%@/%@",desResourceDir,strMapName];
    //    if (bNew) {
    //        NSString *strSymTemp = [desResources stringByAppendingString:@".sym"];
    //        strSymTemp = [self formateNoneExistFileName:strSymTemp isDir:NO];
    //        desResources = [strSymTemp substringToIndex:strSymTemp.length-4];
    //    }
    
    if (bNew||bResourcesModified) {
        // 从工作空间Lib中找到地图名的分组，导出成为根组符号库
        // Marker
        {
            SymbolMarkerLibrary *markerLibrary = [[SymbolMarkerLibrary alloc]init];
            //SymbolGroup *desMarkerGroup = [markerLibrary.rootGroup.childSymbolGroups createGroupWith:strMapName];
            SymbolGroup *desMarkerGroup = markerLibrary.rootGroup;
            SymbolGroup *srcMarkerGroup = [srcWorkspace.resources.markerLibrary.rootGroup.childSymbolGroups getGroupWithName:strMapAlians];
            if (bNew && !bResourcesModified) {
                // 整个库都倒出
                srcMarkerGroup = srcWorkspace.resources.markerLibrary.rootGroup;
            }
            if (srcMarkerGroup!=nil) {
                [self importSymbolsFrom:srcMarkerGroup toGroup:desMarkerGroup isDirRetain:YES isSymbolReplace:NO];
            }
            if (bResourcesModified) {
                NSArray *arrMarkerFromXML = [self findIntValuesFromXML:strMapXML withTag:@"sml:MarkerStyle"];
                [setMarkerIDs addObjectsFromArray:arrMarkerFromXML];
                NSArray *arrMarkerIDs = [setMarkerIDs allObjects];
                for (int i=0; i<arrMarkerIDs.count; i++) {
                    int nMarkerID = [[arrMarkerIDs objectAtIndex:i]intValue];
                    if (![markerLibrary containID:nMarkerID]) {
                        Symbol * symbolTemp = [srcWorkspace.resources.markerLibrary findSymbolWithID:nMarkerID];
                        if (symbolTemp!=nil) {
                            //[markerLibrary add:symbolTemp toGroup:desMarkerGroup];
                            [markerLibrary add:symbolTemp];
                        }
                    }
                }
            }
            [markerLibrary saveAs:[desResources stringByAppendingString:@".sym"]];
            [markerLibrary dispose];
        }
        // Line
        {
            SymbolLineLibrary *lineLibrary = [[SymbolLineLibrary alloc]init];
            SymbolMarkerLibrary *markerInlineLibrary = [lineLibrary getInlineMarkerLib];
            
            //SymbolGroup *desLineGroup = [lineLibrary.rootGroup.childSymbolGroups createGroupWith:strMapName];
            SymbolGroup *desLineGroup = lineLibrary.rootGroup;
            SymbolGroup *srcLineGroup = [srcWorkspace.resources.lineLibrary.rootGroup.childSymbolGroups getGroupWithName:strMapAlians];
            if (bNew && !bResourcesModified) {
                srcLineGroup = srcWorkspace.resources.lineLibrary.rootGroup;
            }
            if (srcLineGroup!=nil) {
                [self importSymbolsFrom:srcLineGroup toGroup:desLineGroup isDirRetain:YES isSymbolReplace:NO];
            }
            //SymbolGroup *desInlineGroup = [markerInlineLibrary.rootGroup.childSymbolGroups createGroupWith:strMapName];
            SymbolGroup *desInlineGroup = markerInlineLibrary.rootGroup;
            SymbolGroup *srcInlineGroup = [srcWorkspace.resources.lineLibrary.getInlineMarkerLib.rootGroup.childSymbolGroups getGroupWithName:strMapAlians];
            if (bNew && !bResourcesModified) {
                srcInlineGroup = srcWorkspace.resources.lineLibrary.getInlineMarkerLib.rootGroup;
            }
            if (srcInlineGroup!=nil) {
                [self importSymbolsFrom:srcInlineGroup toGroup:desInlineGroup isDirRetain:YES isSymbolReplace:NO];
            }
            if (bResourcesModified) {
                NSArray *arrLineFromXML = [self findIntValuesFromXML:strMapXML withTag:@"sml:LineStyle"];
                [setLineIDs addObjectsFromArray:arrLineFromXML];
                NSArray *arrLineIDs = [setLineIDs allObjects];
                for (int i=0; i<arrLineIDs.count; i++) {
                    int nLineID = [[arrLineIDs objectAtIndex:i]intValue];
                    if (![lineLibrary containID:nLineID]) {
                        SymbolLine * symbolTemp = (SymbolLine *)[srcWorkspace.resources.lineLibrary findSymbolWithID:nLineID];
                        if (symbolTemp!=nil) {
                            NSArray *arrInlineMarkerIds = [symbolTemp customizedPointSymbolIDs];
                            for (int j=0; j<arrInlineMarkerIds.count; j++) {
                                int nInlineMarker = [[arrInlineMarkerIds objectAtIndex:j]intValue];
                                if ( ![markerInlineLibrary containID:nInlineMarker] ) {
                                    Symbol *symbolMarker = [srcWorkspace.resources.lineLibrary.getInlineMarkerLib findSymbolWithID:nInlineMarker];
                                    //[markerInlineLibrary add:symbolMarker toGroup:desInlineGroup];
                                    [markerInlineLibrary add:symbolMarker];
                                }
                            }
                            //[lineLibrary add:symbolTemp toGroup:desLineGroup];
                            [lineLibrary add:symbolTemp];
                        }
                    }
                }
            }
            [lineLibrary saveAs:[desResources stringByAppendingString:@".lsl"]];
            [lineLibrary dispose];
        }
        // Fill
        {
            SymbolFillLibrary *fillLibrary = [[SymbolFillLibrary alloc]init];
            SymbolMarkerLibrary *markerInfillLibrary = [fillLibrary getInfillMarkerLib];
            
            //SymbolGroup *desFillGroup = [fillLibrary.rootGroup.childSymbolGroups createGroupWith:strMapName];
            SymbolGroup *desFillGroup = fillLibrary.rootGroup;
            SymbolGroup *srcFillGroup = [srcWorkspace.resources.fillLibrary.rootGroup.childSymbolGroups getGroupWithName:strMapAlians];
            if (bNew && !bResourcesModified) {
                srcFillGroup = srcWorkspace.resources.fillLibrary.rootGroup;
            }
            if (srcFillGroup!=nil) {
                [self importSymbolsFrom:srcFillGroup toGroup:desFillGroup isDirRetain:YES isSymbolReplace:NO];
            }
            //SymbolGroup *desInfillGroup = [markerInfillLibrary.rootGroup.childSymbolGroups createGroupWith:strMapName];
            SymbolGroup *desInfillGroup = markerInfillLibrary.rootGroup;
            SymbolGroup *srcInfillGroup = [srcWorkspace.resources.fillLibrary.getInfillMarkerLib.rootGroup.childSymbolGroups getGroupWithName:strMapAlians];
            if (bNew && !bResourcesModified) {
                srcInfillGroup = srcWorkspace.resources.fillLibrary.getInfillMarkerLib.rootGroup;
            }
            if (srcInfillGroup!=nil) {
                [self importSymbolsFrom:srcInfillGroup toGroup:desInfillGroup isDirRetain:YES isSymbolReplace:NO];
            }
            if (bResourcesModified) {
                NSArray *arrFillFromXML = [self findIntValuesFromXML:strMapXML withTag:@"sml:FillStyle"];
                [setFillIDs addObjectsFromArray:arrFillFromXML];
                NSArray *arrFillIDs = [setFillIDs allObjects];
                for (int i=0; i<arrFillIDs.count; i++) {
                    int nFillID = [[arrFillIDs objectAtIndex:i]intValue];
                    if (![fillLibrary containID:nFillID]) {
                        SymbolFill * symbolTemp = (SymbolFill *)[srcWorkspace.resources.fillLibrary findSymbolWithID:nFillID];
                        if (symbolTemp!=nil) {
                            NSArray *arrInfillMarkerIds = [symbolTemp customizedPointSymbolIDs];
                            for (int j=0; j<arrInfillMarkerIds.count; j++) {
                                int nInfillMarker = [[arrInfillMarkerIds objectAtIndex:j]intValue];
                                if ( ![markerInfillLibrary containID:nInfillMarker] ) {
                                    Symbol *symbolMarker = [srcWorkspace.resources.fillLibrary.getInfillMarkerLib findSymbolWithID:nInfillMarker];
                                    //[markerInfillLibrary add:symbolMarker toGroup:desInfillGroup];
                                    [markerInfillLibrary add:symbolMarker];
                                }
                            }
                            //[fillLibrary add:symbolTemp toGroup:desFillGroup];
                            [fillLibrary add:symbolTemp];
                        }
                    }
                }
            }
            [fillLibrary saveAs:[desResources stringByAppendingString:@".bru"]];
            [fillLibrary dispose];
        }
        
    }
    
    //NSDictionary *dicExp= @{ @"Datasources":arrExpDatasources , @"Resources": strMapName};
    NSMutableDictionary *dictionaryExp = [[NSMutableDictionary alloc]init];
    [dictionaryExp setObject:arrExpDatasources forKey:@"Datasources"];
    [dictionaryExp setObject:strMapName forKey:@"Resources"];
    //模板
    NSString *strTemplate = [dicAddition objectForKey:@"Template"];
    if (strTemplate!=nil) {
        [dictionaryExp setObject:strTemplate forKey:@"Template"];
    }
    
    NSData *dataJson = [NSJSONSerialization dataWithJSONObject:dictionaryExp options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strExplorerJson = [[NSString alloc]initWithData:dataJson encoding:NSUTF8StringEncoding];
    [strExplorerJson writeToFile:desPathMapExp atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    [mapExport close];
    
    return strMapName;
}


// 大工作空间打开本地地图
-(BOOL)openMapName:(NSString*)strMapName toWorkspace:(Workspace*)desWorkspace ofModule:(NSString *)strModule{
    
    if(desWorkspace==nil || [desWorkspace.maps indexOf:strMapName]!=-1){
        return false;
    }
    
    NSString *strCustomer = [self getCustomerDirectory];
    
//    if (strModule==nil) {
//        return false;
//    }
    NSString* srcPathMap;
    if (strModule!=nil) {
        srcPathMap = [NSString stringWithFormat:@"%@/Map/%@/%@",strCustomer,strModule,strMapName];
    }else{
        srcPathMap = [NSString stringWithFormat:@"%@/Map/%@",strCustomer,strMapName];
    }
    NSString* srcPathXML = [NSString stringWithFormat:@"%@.xml",srcPathMap];
    BOOL isDir = true;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:srcPathXML isDirectory:&isDir];
    if (!isExist || isDir) {
        return false;
    }
    
    NSString* srcPathEXP = [NSString stringWithFormat:@"%@.exp",srcPathMap];
    isDir = true;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:srcPathEXP isDirectory:&isDir];
    if (!isExist || isDir) {
        return false;
    }
    NSString* strMapEXP = [NSString stringWithContentsOfFile:srcPathEXP encoding:NSUTF8StringEncoding error:nil];
    // {
    //  "Datasources":
    //                  [ {"Alians":strMapName,"Type":nEngineType,"Server":strDatasourceName} , {...} , {...} ... ] ,
    //  "Resources":
    //                  strMapName
    // }
    NSDictionary *dicExp = [NSJSONSerialization JSONObjectWithData:[strMapEXP dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    NSString *srcDatasourceDir = [NSString stringWithFormat:@"%@/Datasource",strCustomer];
    if (strModule!=nil) {
        srcDatasourceDir = [NSString stringWithFormat:@"%@/%@",srcDatasourceDir,strModule];
    }
    
    // 重复的server处理
    //      1.文件型数据源：若bDatasourceRep，关闭原来数据源，拷贝新数据源并重新打开（alian保持原来的）
    //      2.网络型数据源：不再重复打开（alian保持原来的）
    NSMutableArray * arrTargetServers = [[NSMutableArray alloc]init];
    NSMutableArray * arrTargetAlians = [[NSMutableArray alloc]init];
    for (int i=0; i<desWorkspace.datasources.count; i++) {
        Datasource* datasource = [desWorkspace.datasources get:i];
        DatasourceConnectionInfo *datasourceInfo = [datasource datasourceConnectionInfo];
        if (datasourceInfo.engineType == ET_UDB || datasourceInfo.engineType == ET_IMAGEPLUGINS) {
            //只要名字
            NSString* fullName = datasourceInfo.server;
            NSArray * arrServer = [fullName componentsSeparatedByString:@"/"];
            NSString* lastName = [arrServer lastObject];
            NSString* fatherName = [fullName substringToIndex:fullName.length-lastName.length-1];
            if ([fatherName isEqualToString:srcDatasourceDir]) {
                //同级目录下的才会被替换
                [arrTargetServers addObject:lastName];
                [arrTargetAlians addObject:datasourceInfo.alias];
            }
        }else{
            //网络数据集用完整url
            [arrTargetServers addObject:datasourceInfo.server];
            [arrTargetAlians addObject:datasourceInfo.alias];
        }
    }
    
    //更名数组
    NSMutableArray *arrAlian = [[NSMutableArray alloc]init];
    NSMutableArray *arrReAlian = [[NSMutableArray alloc]init];
    
    NSArray *arrDatasources = [dicExp objectForKey:@"Datasources"];
    for (int i=0; i<arrDatasources.count; i++) {
        NSDictionary *dicDatasource = [arrDatasources objectAtIndex:i];
        NSString *strAlian = [dicDatasource objectForKey:@"Alians"];
        NSString *strServer = [dicDatasource objectForKey:@"Server"];
        EngineType engineType = (EngineType)[[dicDatasource objectForKey:@"Type"] intValue];
        // Alians重命名 同一个Server不要打开两次
        NSString *strDesAlian = strAlian;
        
        NSInteger nIndex = [arrTargetServers indexOfObject:strServer];
        if (nIndex>=0 && nIndex<arrTargetServers.count) {
            // 替换alian 保证原来map有数据源
            strDesAlian = [arrTargetAlians objectAtIndex:nIndex];
        }else{
            // 保证不重名
            strDesAlian = [self formateNoneExistDatasourceAlian:strAlian ofWorkspace:desWorkspace];
            DatasourceConnectionInfo *infoTemp = [[DatasourceConnectionInfo alloc]init];
            if (engineType == ET_UDB || engineType == ET_IMAGEPLUGINS){
                infoTemp.server = [NSString stringWithFormat:@"%@/%@",srcDatasourceDir,strServer];
            }else{
                infoTemp.server = strServer;
            }
            infoTemp.engineType = engineType;
            infoTemp.alias = strDesAlian;
            if(![desWorkspace.datasources open:infoTemp]){
                continue;
            }
        }
        // xml中需重命名的别名
        if (![strAlian isEqualToString:strDesAlian]) {
            [arrAlian addObject:strAlian];
            [arrReAlian addObject:strDesAlian];
        }
    }
    
    
    NSString* srcResources;// = [NSString stringWithFormat:@"%@/Resource/%@/%@",strCustomer,strModule,strMapName];
    if (strModule!=nil) {
        srcResources = [NSString stringWithFormat:@"%@/Symbol/%@/%@",strCustomer,strModule,strMapName];
    }else{
         srcResources = [NSString stringWithFormat:@"%@/Symbol/%@/%@",strCustomer,strMapName];
    }
    // Marker
    {
        if([desWorkspace.resources.markerLibrary.rootGroup.childSymbolGroups indexofGroup:strMapName]!=-1){
            //删除分组
            //-----??>>>[desWorkspace.resources.markerLibrary.rootGroup.childSymbolGroups removeGroupWith:strMapName];
            [desWorkspace.resources.markerLibrary.rootGroup.childSymbolGroups removeGroupWith:strMapName isUpMove:NO];
        }
        //新建分组
        SymbolGroup *desMarkerGroup = [desWorkspace.resources.markerLibrary.rootGroup.childSymbolGroups createGroupWith:strMapName];
        
        NSString *strMarkerPath = [srcResources stringByAppendingString:@".sym"];
        isDir = true;
        isExist = [[NSFileManager defaultManager] fileExistsAtPath:strMarkerPath isDirectory:&isDir];
        if ( isExist && !isDir) {
            SymbolMarkerLibrary *markerLibrary = [[SymbolMarkerLibrary alloc]init];
            [markerLibrary appendFromFile:strMarkerPath isReplace:YES];
            [self importSymbolsFrom:markerLibrary.rootGroup toGroup:desMarkerGroup isDirRetain:YES isSymbolReplace:YES];
        }
    }
    // Line
    {
        if([desWorkspace.resources.lineLibrary.rootGroup.childSymbolGroups indexofGroup:strMapName]!=-1){
            //删除分组
            [desWorkspace.resources.lineLibrary.rootGroup.childSymbolGroups removeGroupWith:strMapName isUpMove:NO];
        }
        if([desWorkspace.resources.lineLibrary.getInlineMarkerLib.rootGroup.childSymbolGroups indexofGroup:strMapName]!=-1){
            //删除inlineMarkerLib
            [desWorkspace.resources.lineLibrary.getInlineMarkerLib.rootGroup.childSymbolGroups removeGroupWith:strMapName isUpMove:NO];
        }
        
        SymbolGroup *desLineGroup = [desWorkspace.resources.lineLibrary.rootGroup.childSymbolGroups createGroupWith:strMapName];
        SymbolGroup *desInlineMarkerGroup = [desWorkspace.resources.lineLibrary.getInlineMarkerLib.rootGroup.childSymbolGroups createGroupWith:strMapName];
        
        NSString *strLinePath = [srcResources stringByAppendingString:@".lsl"];
        isDir = true;
        isExist = [[NSFileManager defaultManager] fileExistsAtPath:strLinePath isDirectory:&isDir];
        if ( isExist && !isDir) {
            SymbolLineLibrary *lineLibrary = [[SymbolLineLibrary alloc]init];
            [lineLibrary appendFromFile:strLinePath isReplace:YES];
            [self importSymbolsFrom:lineLibrary.getInlineMarkerLib.rootGroup toGroup:desInlineMarkerGroup isDirRetain:YES isSymbolReplace:YES];
            [self importSymbolsFrom:lineLibrary.rootGroup toGroup:desLineGroup isDirRetain:YES isSymbolReplace:YES];
        }
    }
    // Fill
    {
        if([desWorkspace.resources.fillLibrary.rootGroup.childSymbolGroups indexofGroup:strMapName]!=-1){
            //删除分组
            [desWorkspace.resources.fillLibrary.rootGroup.childSymbolGroups removeGroupWith:strMapName isUpMove:NO];
        }
        if([desWorkspace.resources.fillLibrary.getInfillMarkerLib.rootGroup.childSymbolGroups indexofGroup:strMapName]!=-1){
            //删除infillMarkerLib
            [desWorkspace.resources.fillLibrary.getInfillMarkerLib.rootGroup.childSymbolGroups removeGroupWith:strMapName isUpMove:NO];
        }
        
        SymbolGroup *desFillGroup = [desWorkspace.resources.fillLibrary.rootGroup.childSymbolGroups createGroupWith:strMapName];
        SymbolGroup *desInfillMarkerGroup = [desWorkspace.resources.fillLibrary.getInfillMarkerLib.rootGroup.childSymbolGroups createGroupWith:strMapName];
        
        NSString *strFillPath = [srcResources stringByAppendingString:@".bru"];
        isDir = true;
        isExist = [[NSFileManager defaultManager] fileExistsAtPath:strFillPath isDirectory:&isDir];
        if ( isExist && !isDir) {
            SymbolFillLibrary *fillLibrary = [[SymbolFillLibrary alloc]init];
            [fillLibrary appendFromFile:strFillPath isReplace:YES];
            [self importSymbolsFrom:fillLibrary.getInfillMarkerLib.rootGroup toGroup:desInfillMarkerGroup isDirRetain:YES isSymbolReplace:YES];
            [self importSymbolsFrom:fillLibrary.rootGroup toGroup:desFillGroup isDirRetain:YES isSymbolReplace:YES];
        }
    }
    
    
    NSString* strMapXML = [NSString stringWithContentsOfFile:srcPathXML encoding:NSUTF8StringEncoding error:nil];
    strMapXML = [self modifyXML:strMapXML replace:arrAlian with:arrReAlian];
    
    [desWorkspace.maps add:strMapName withXML:strMapXML];
    
    return true;
}

@end

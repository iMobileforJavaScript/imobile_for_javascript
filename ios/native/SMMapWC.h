//
//  SMMapWC.h
//  Supermap
//
//  Created by Yang Shang Long on 2018/11/2.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "SuperMap/MapControl.h"
#import "SuperMap/Workspace.h"
#import "SuperMap/Map.h"
#import "SuperMap/Workspace.h"
#import "SuperMap/WorkspaceConnectionInfo.h"
#import "SuperMap/Datasource.h"
#import "SuperMap/Datasources.h"
#import "SuperMap/DatasourceConnectionInfo.h"
#import "SuperMap/Dataset.h"
#import "SuperMap/Datasets.h"
#import "SuperMap/DatasetType.h"
#import "SuperMap/DatasetVectorInfo.h"
#import "SuperMap/EngineType.h"
#import "SMFileUtil.h"

@interface SMMapWC : NSObject

@property (strong, nonatomic) Workspace* workspace;
@property (strong, nonatomic) MapControl* mapControl;

- (BOOL)openWorkspace:(NSDictionary *)infoDic;
- (Datasource *)openDatasource:(NSDictionary *)params;
- (Dataset *)addDatasetByName:(NSString *)name type:(DatasetType)type datasourceName:(NSString *)datasourceName datasourcePath:(NSString *)datasourcePath;
- (BOOL)saveWorkspace;
- (BOOL)saveWorkspaceWithInfo:(NSDictionary*)infoDic;
-(BOOL)importWorkspaceInfo:(NSDictionary *)infoDic withFileDirectory:(NSString*)strDirPath isDatasourceReplace:(BOOL)bDatasourceRep isSymbolsReplace:(BOOL)bSymbolsRep;
-(BOOL)exportMapNamed:(NSArray*)arrMapNames toFile:(NSString*)fileName isReplaceFile:(BOOL)bFileRep;
//-(BOOL)saveMapName:(NSString*)strMapAlians fromWorkspace:(Workspace*)srcWorkspace ofModule:(NSString *)nModule isNewMap:(BOOL)bNew isResourcesModyfied:(BOOL)bResourcesModified;
-(BOOL)saveMapName:(NSString*)strMapAlians fromWorkspace:(Workspace*)srcWorkspace ofModule:(NSString*)strModule withAddition:(NSDictionary*)dicAddition isNewMap:(BOOL)bNew isResourcesModyfied:(BOOL)bResourcesModified;
-(BOOL)importWorkspaceInfo:(NSDictionary *)infoDic toModule:(NSString *)nModule;
-(BOOL)openMapName:(NSString*)strMapName toWorkspace:(Workspace*)desWorkspace ofModule:(NSString *)nModule;
@end

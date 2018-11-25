//
//  SMMapWC.h
//  Supermap
//
//  Created by Yang Shang Long on 2018/11/2.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "SuperMap/SceneControl.h"
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
#import "SuperMap/Scene.h"

@interface SMSceneWC : NSObject

@property (strong, nonatomic) Workspace* workspace;
@property (strong, nonatomic) SceneControl* sceneControl;

- (BOOL)openWorkspace:(NSDictionary *)infoDic;
- (Datasource *)openDatasource:(NSDictionary *)params;
//- (Dataset *)addDatasetByName:(NSString *)name type:(DatasetType)type datasourceName:(NSString *)datasourceName datasourcePath:(NSString *)datasourcePath;

@end
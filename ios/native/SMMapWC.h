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
#import "SuperMap/Maps.h"
#import "SuperMap/Layers.h"
#import "SuperMap/Layer.h"
#import "SuperMap/Resources.h"
#import "SuperMap/SymbolMarkerLibrary.h"
#import "SuperMap/SymbolLineLibrary.h"
#import "SuperMap/SymbolFillLibrary.h"
#import "SuperMap/SymbolLine.h"
#import "SuperMap/SymbolFill.h"
#import "SuperMap/Geometry.h"
#import "SuperMap/GeoStyle.h"
#import "SuperMap/OverlayAnalyst.h"
#import "SuperMap/OverlayAnalystParameter.h"
#import "SuperMap/RasterClip.h"
#import "Supermap/ScaleView.h"
@interface SMMapWC : NSObject

@property (strong, nonatomic) Workspace* workspace;
@property (strong, nonatomic) MapControl* mapControl;
@property (strong, nonatomic) ScaleView* scaleView;

- (BOOL)openWorkspace:(NSDictionary *)infoDic;
- (Datasource *)openDatasource:(NSDictionary *)params;
- (Dataset *)addDatasetByName:(NSString *)name type:(DatasetType)type datasourceName:(NSString *)datasourceName datasourcePath:(NSString *)datasourcePath;
- (BOOL)saveWorkspace;
- (BOOL)saveWorkspaceWithInfo:(NSDictionary*)infoDic;
-(NSArray *)importWorkspaceInfo:(NSDictionary *)infoDic toModule:(NSString*)strModule isPrivate:(BOOL)isPrivate;
- (BOOL)exportMapNamed:(NSArray*)arrMapNames toFile:(NSString*)fileName isReplaceFile:(BOOL)bFileRep extra:(NSDictionary*)extraDic;
//-(BOOL)saveMapName:(NSString*)strMapAlians fromWorkspace:(Workspace*)srcWorkspace ofModule:(NSString *)nModule isNewMap:(BOOL)bNew isResourcesModyfied:(BOOL)bResourcesModified;
- (NSString *)saveMapName:(NSString*)strMapAlians fromWorkspace:(Workspace*)srcWorkspace ofModule:(NSString*)strModule withAddition:(NSDictionary*)dicAddition isNewMap:(BOOL)bNew isResourcesModyfied:(BOOL)bResourcesModified isPrivate:(BOOL)bPrivate;
-(BOOL)importWorkspaceInfo:(NSDictionary *)infoDic withFileDirectory:(NSString*)strDirPath isDatasourceReplace:(BOOL)bDatasourceRep isSymbolsReplace:(BOOL)bSymbolsRep;
//- (BOOL)openMapName:(NSString*)strMapName toWorkspace:(Workspace*)desWorkspace ofModule:(NSString *)nModule isPrivate:(BOOL)bPrivate;
- (BOOL)openMapName:(NSString*)strMapName toWorkspace:(Workspace*)desWorkspace withParam:(NSDictionary*)dicParam;
- (BOOL)appendFromFile:(Resources *)resources path:(NSString *)path isReplace:(BOOL)isReplace;

-(NSString*)importDatasourceFile:(NSString*)strFile ofModule:(NSString*)strModule;


- (BOOL)copyDatasetsFrom:(NSString*)strSrcUDB to:(NSString*)strDesUDB;
-(BOOL)clipMap:(Map*)_srcMap withRegion:(GeoRegion*)clipRegion parameters:(NSArray*)arrLayers/*NSString*)jsonParam*/ saveAs:(NSString**)strResultName;
//-(BOOL)addLayersFromMap:(NSString*)srcMapName ofModule:(NSString*)srcModule isPrivate:(BOOL)bSrcPrivate toMap:(Map*)desMap;
-(BOOL)addLayersFromMap:(NSString*)srcMapName toMap:(Map*)desMap withParam:(NSDictionary*)dicParam;
-(BOOL)addLayersFromMapJson:(NSString*)jsonSrcMap toMap:(NSString*)jsonDesMap;
-(NSString *)getUserName;
@end

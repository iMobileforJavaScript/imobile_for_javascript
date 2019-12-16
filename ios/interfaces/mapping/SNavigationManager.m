//
//  SNavigationManager.m
//  Supermap
//
//  Created by jiushuaizhao on 2019/12/16.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "SNavigationManager.h"

static SMap *sMap = nil;
//导航相关数据源
static Datasource *incrementDatasource;
static NSString *incrementLineDatasetName;
static NSString *incrementNetworkDatasetName;
static BOOL incrementLayerAdded = NO;
//Gps点
Point2Ds *GpsPoint2Ds;

@implementation SNavigationManager
RCT_EXPORT_MODULE();
- (NSArray<NSString *> *)supportedEvents
{
    return @[
             INDUSTRYNAVIAGTION,
             ];
}
#pragma mark 清除导航路线
RCT_REMAP_METHOD(clearTrackingLayer, clearTrackingLayerWithResolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        [sMap.smMapWC.mapControl.map.trackingLayer clear];
        [sMap.smMapWC.mapControl.map refresh];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"clearTarckingLayer",exception.reason,nil);
    }
}

#pragma mark 获取导航路径长度
RCT_REMAP_METHOD(getNavPathLength, getNavPathLengthWithBool:(BOOL)isIndoor resolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        NSArray *naviPath;
        if(isIndoor){
            naviPath = [[sMap.smMapWC.mapControl getNavigation3] getNaviPath];
        }else{
            naviPath = [sMap.sNavigation2.m_navigation getNaviPath];
        }
        int length =  0;
        for(int i = 0; i < naviPath.count; i++){
            NaviStep *step = naviPath[i];
            length += (int)step.length;
        }
        NSDictionary *dic = @{@"length":[NSNumber numberWithInt:length]};
        resolve(dic);
    } @catch (NSException *exception) {
        reject(@"getNavPathLength",exception.reason,nil);
    }
}

#pragma mark 获取导航路径详情
RCT_REMAP_METHOD(getPathInfos, getPathInfosWithBool:(BOOL)isIndoor resolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        sMap  = [SMap singletonInstance];
        NSArray *navipath;
        if(isIndoor){
            navipath = [[sMap.smMapWC.mapControl getNavigation3] getNaviPath];
        }else{
            navipath = [sMap.sNavigation2.m_navigation getNaviPath];
        }
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for(int i = 0; i < navipath.count; i++){
            NaviStep *step = navipath[i];
            //NSString *roadName = step.name;
            int roadLength = step.length;
            int type = step.toSwerve;
            roadLength = (int)roadLength;
            NSDictionary *dic = @{
                                  @"roadLength":[NSNumber numberWithInt:roadLength],
                                  @"turnType":[NSNumber numberWithInt:type],
                                  };
            [array addObject:dic];
        }
        resolve(array);
    } @catch (NSException *exception) {
        reject(@"getPathInfos",exception.reason,nil);
    }
}

#pragma mark 绘制在线路径分析的路径
RCT_REMAP_METHOD(drawOnlinePath,drawOnlinePathWithPathPoints:(NSArray *)pathPoints resolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try{
        sMap = [SMap singletonInstance];
        TrackingLayer *trackingLayer = sMap.smMapWC.mapControl.map.trackingLayer;
        [trackingLayer clear];
        Point2Ds *points = [[Point2Ds alloc] init];
        
        for(int i = 0; i < pathPoints.count; i++){
            double x = [[pathPoints[i] valueForKey:@"x"] doubleValue];
            double y = [[pathPoints[i] valueForKey:@"y"] doubleValue];
            Point2D *pt = [[Point2D alloc]initWithX:x Y:y];
            [points add:pt];
        }
        
        GeoLine *geoline = [[GeoLine alloc] initWithPoint2Ds:points];
        GeoStyle *geostyle = [[GeoStyle alloc] init];
        Color *color = [[Color alloc] initWithR:0 G:191 B:255];
        [geostyle setLineSymbolID:15];
        [geostyle setLineColor:color];
        [geoline setStyle:geostyle];
        
        [trackingLayer addGeometry:geoline WithTag:@"线路"];
        [sMap.smMapWC.mapControl.map refresh];
        resolve(@(YES));
    }@catch(NSException *exception){
        reject(@"drawOnlinePath", exception.reason, nil);
    }
}

#pragma mark 设置行业导航参数
RCT_REMAP_METHOD(startNavigation, startNavigationWithNetworkDatasetName:(NSDictionary *)selectedItem resolver: (RCTPromiseResolveBlock)resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        
        NSString *networkDatasetName = [selectedItem valueForKey:@"name"];
        NSString *datasourceName = [selectedItem valueForKey:@"datasourceName"];
        NSString *netModelFileName = [selectedItem valueForKey:@"modelFileName"];
        
        NSString *strUserName = [sMap.smMapWC getUserName];
        NSString *strRootPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/iTablet/User"];
        NSString *netModelPath = [NSString stringWithFormat:@"%@/%@/Data/Datasource/%@.snm",strRootPath,strUserName,netModelFileName];
        
        sMap = [SMap singletonInstance];
        Datasource *datasource = [sMap.smMapWC.workspace.datasources getAlias:datasourceName];
        Dataset *dataset = [datasource.datasets getWithName:networkDatasetName];
        
        if(dataset != nil){
            DatasetVector *networkDataset = (DatasetVector *)dataset;
            if(sMap.sNavigation2 == nil){
                sMap.sNavigation2 = [[SNavigation2 alloc] initWithMapControl:sMap.smMapWC.mapControl];
            }
            SNavigation2 *navigation2 = sMap.sNavigation2;
            GeoStyle *style = [[GeoStyle alloc] init];
            [style setLineSymbolID:964882];
            //defaultMap 加数据集 导航线符号拿不到 需要设置线的颜色
            [style setLineColor:[[Color alloc]initWithR:82 G:198 B:233]];
            [navigation2 setRouteStyle:style];
            [navigation2 setNetworkDataset:networkDataset];
            [navigation2 loadModel:netModelPath];
            navigation2.m_navigation.navi2Delegate = self;
            resolve(@(YES));
        }else{
            resolve(@(NO));
        }
        
    } @catch (NSException *exception) {
        reject(@"startNavigation",exception.reason,nil);
    }
}

#pragma mark 行业导航停止回调
-(void)navi2GuideStop{
    [SNavigationManager clearOutdoorPoint];
    [self sendEventWithName:INDUSTRYNAVIAGTION
                       body:@(YES)];
}
#pragma mark 行业导航 导航完成回调
-(void)navi2GuideArrive{
    [SNavigationManager clearOutdoorPoint];
    [self sendEventWithName:INDUSTRYNAVIAGTION
                       body:@(YES)];
}

#pragma mark 清除行业导航起始点
+(void) clearOutdoorPoint{
    MapControl *mapControl = [SMap singletonInstance].smMapWC.mapControl;
    [mapControl removeCalloutWithTag:@"startpoint"];
    [mapControl removeCalloutWithTag:@"endpoint"];
}

#pragma mark 是否在导航过程中（处理是否退出fullMap）
RCT_REMAP_METHOD(isGuiding, isGuidingWithResolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        MapControl *mapControl = [SMap singletonInstance].smMapWC.mapControl;
        BOOL isIndoorGuiding = [[mapControl getNavigation3] isGuiding];
        BOOL isOutdoorGuiding = [sMap.sNavigation2.m_navigation isGuiding];
        resolve(@(isIndoorGuiding || isOutdoorGuiding));
    } @catch (NSException *exception) {
        reject(@"isGuiding",exception.reason,nil);
    }
}

#pragma mark 行业导航路径分析
RCT_REMAP_METHOD(beginNavigation, beginNavigationWithX:(double)x Y:(double)y X2:(double)x2 Y2:(double)y2 resolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Map *map = sMap.smMapWC.mapControl.map;
        SNavigation2 *navigation2 = sMap.sNavigation2;
        [navigation2 setStartPoint:x sPointY:y];
        [navigation2 setDestinationPoint:x2 dPointY:y2];
        [navigation2.m_navigation setPathVisible:YES];
        BOOL isFind = [navigation2.m_navigation routeAnalyst];
        if(!isFind){
            isFind = [navigation2 reAnalyst];
            if(isFind){
                [navigation2 addGuideLineOnTrackinglayerWithMapPrj:map.prjCoordSys];
            }
        }else{
            [map refresh];
        }
        resolve(@(isFind));
    } @catch (NSException *exception) {
        sMap = [SMap singletonInstance];
        Map *map = sMap.smMapWC.mapControl.map;
        SNavigation2 *navigation2 = sMap.sNavigation2;
        BOOL isFind = [navigation2 reAnalyst];
        if(isFind){
            [navigation2 addGuideLineOnTrackinglayerWithMapPrj:map.prjCoordSys];
        }
        resolve(@(isFind));
    }
}

#pragma mark 进行行业导航
RCT_REMAP_METHOD(outdoorNavigation, outdoorNavigationWithInt:(int)naviType resolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [sMap.sNavigation2.m_navigation enablePanOnGuide:YES];
            [sMap.sNavigation2.m_navigation startGuide:naviType];
            [sMap.sNavigation2.m_navigation setIsCarUpFront:NO];
            resolve(@(YES));
        });
    } @catch (NSException *exception) {
        reject(@"outdoorNavigation",exception.reason,nil);
    }
}

#pragma mark 设置室内导航
RCT_REMAP_METHOD(startIndoorNavigation, startIndoorNavigationWithResolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Datasource *naviDatasource;
        Datasources *datasources = sMap.smMapWC.workspace.datasources;
        for(int i = 0; i < datasources.count; i++){
            Datasource *datasource = [datasources get:i];
            Datasets *datasets = datasource.datasets;
            if([datasets contain:@"FloorRelationTable"]){
                naviDatasource = datasource;
                break;
            }
        }
        if(naviDatasource != nil){
            Navigation3 *navigation3 = [sMap.smMapWC.mapControl getNavigation3];
            GeoStyle *style = [[GeoStyle alloc] init];
            [style setLineSymbolID:964882];
            [navigation3 setRouteStyle:style];
            GeoStyle *styleHint = [[GeoStyle alloc] init];
            [styleHint setLineWidth:2];
            [styleHint setLineColor:[[Color alloc]initWithR:82 G:198 B:233]];
            [styleHint setLineSymbolID:2];
            [navigation3 setHintRouteStyle:styleHint];
            [navigation3 setDatasource:naviDatasource];
            navigation3.navDelegate = self;
            resolve(@(YES));
        }else{
            reject(@"startIndoorNavigation",@"naviDatasource can't be null",nil);
        }
        
    } @catch (NSException *exception) {
        reject(@"startIndoorNavigation",exception.reason,nil);
    }
}

#pragma mark 到达目的地回调
-(void)onAarrivedDestination{
    [self sendEventWithName:INDUSTRYNAVIAGTION
                       body:@(YES)];
}

#pragma mark 停止导航后回调
-(void)onStopNavi{
    [self sendEventWithName:INDUSTRYNAVIAGTION
                       body:@(YES)];
}

#pragma mark 室内导航路径分析
RCT_REMAP_METHOD(beginIndoorNavigation, beginIndoorNavigationWithX:(double)x Y:(double)y X2:(double)x2 Y2:(double)y2 resolver:(RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try{
        sMap = [SMap singletonInstance];
        BOOL result = [[sMap.smMapWC.mapControl getNavigation3] routeAnalyst];
        resolve(@(result));
    }@catch(NSException *exception){
        reject(@"beginIndoorNavigation",exception.reason,nil);
    }
}

#pragma mark 进行室内导航
RCT_REMAP_METHOD(indoorNavigation, indoorNavigationWithInt:(int)naviType resolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        MapControl *mapControl = [SMap singletonInstance].smMapWC.mapControl;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[mapControl getNavigation3] startGuide:naviType];
            [mapControl.map setIsFullScreenDrawModel:YES];
            [[mapControl getNavigation3] setIsCarUpFront:YES];
            resolve(@(YES));
        });
    } @catch (NSException *exception) {
        reject(@"indoorNavigation",exception.reason,nil);
    }
}

#pragma mark 判断当前工作空间是否存在线数据集（增量路网前置条件）
RCT_REMAP_METHOD(hasLineDataset, hasLineDatasetWithResolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Datasources *datasouces = sMap.smMapWC.workspace.datasources;
        BOOL hasLineDataset = NO;
        for(int i = 0; i < datasouces.count; i++){
            Datasets *datasets = [datasouces get:i].datasets;
            for(int j = 0; j < datasets.count; j++){
                Dataset *dataset = [datasets get:j];
                if(dataset.datasetType == LINE){
                    hasLineDataset = YES;
                    break;
                }
            }
        }
        resolve(@(hasLineDataset));
    } @catch (NSException *exception) {
        reject(@"hasLineDataset", exception.reason, nil);
    }
}

#pragma mark 设置当前楼层ID
RCT_REMAP_METHOD(setCurrentFloorID, setCurrentFloorIDWithId:(NSString *)floorID Resolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try{
        sMap = [SMap singletonInstance];
        sMap.smMapWC.floorListView.currentFloorId = floorID;
        [[sMap.smMapWC.mapControl getNavigation3] setCurrentFloorId:floorID];
        resolve(@(YES));
    }@catch(NSException *exception){
        reject(@"setCurrentFloorID", exception.reason, nil);
    }
}


#pragma mark 获取当前楼层ID
RCT_REMAP_METHOD(getCurrentFloorID, getCurrentFloorIDWithResolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try{
        sMap = [SMap singletonInstance];
        NSString *floorID = @"";
        FloorListView *floorListView = sMap.smMapWC.floorListView;
        if(floorListView != nil && !floorListView.isHidden){
            floorID = sMap.smMapWC.floorListView.currentFloorId;
        }
        resolve(floorID);
    }@catch(NSException *exception){
        reject(@"getCurrentFloorID", exception.reason, nil);
    }
}

#pragma mark 打开含有ModelFileLinkTable的数据源，用于室外导航
RCT_REMAP_METHOD(openNavDatasource, openNavDatasourceWithParams:(NSDictionary *) params resolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try{
        sMap = [SMap singletonInstance];
        NSString *alias = [params valueForKey:@"alias"];
        Datasources *datasources = sMap.smMapWC.workspace.datasources;
        Datasource *datasource = [datasources getAlias:alias];
        if(datasource == nil){
            datasource = [sMap.smMapWC openDatasource:params];
            if(datasource != nil){
                Dataset *linkTable = [datasource.datasets getWithName:@"ModelFileLinkTable"];
                if(linkTable == nil){
                    [datasources closeAlias:datasource.alias];
                }
            }
        }
        resolve(@(YES));
    }@catch(NSException *exception){
        reject(@"openNavDatasource",exception.reason,nil);
    }
}

#pragma mark 获取当前工作空间含有网络数据集
RCT_REMAP_METHOD(getNetworkDataset, getNetworkDatasourceWithResolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try{
        sMap = [SMap singletonInstance];
        Datasources *datasouces = sMap.smMapWC.workspace.datasources;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for(int i = 0; i < datasouces.count; i++){
            Datasource *datasource = [datasouces get:i];
            Datasets *datasets = datasource.datasets;
            Dataset *linkTable = [datasets getWithName:@"ModelFileLinkTable"];
            if(linkTable != nil){
                DatasetVector *datasetVector = (DatasetVector *)linkTable;
                Recordset *recordset = [datasetVector recordset:NO cursorType:STATIC];
                do{
                    NSString *networkDataset = (NSString *)[recordset getFieldValueWithString:@"NetworkDataset"];
                    NSString *netModel = (NSString *)[recordset getFieldValueWithString:@"NetworkModelFile"];
                    if(networkDataset != nil && netModel != nil){
                        NSDictionary *dic = @{
                                              @"name":networkDataset,
                                              @"modelFileName":netModel,
                                              @"datasourceName":datasource.alias,
                                              };
                        [array addObject:dic];
                    }
                }while([recordset moveNext]);
                [recordset close];
                [recordset dispose];
            }
        }
        resolve(array);
    }@catch(NSException *exception){
        reject(@"getNetworkDatasource",exception.reason, nil);
    }
}

#pragma mark 将路网数据集所在线数据集添加到地图上
RCT_REMAP_METHOD(addNetWorkDataset, addNetWorkDatasetWithResolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        dispatch_sync(dispatch_get_main_queue(), ^{
            sMap = [SMap singletonInstance];
            Datasources *datasources = sMap.smMapWC.workspace.datasources;
            Dataset *floorRelationTable = nil;
            
            NSString *floorID = sMap.smMapWC.floorListView.currentFloorId;
            if(floorID != nil){
                //室内
                for (int i = 0; i < datasources.count; i++) {
                    Datasource *datasource = [datasources get:i];
                    Datasets *datasets = datasource.datasets;
                    if([datasets contain:@"FloorRelationTable"]){
                        incrementDatasource = datasource;
                        floorRelationTable = [datasets getWithName:@"FloorRelationTable"];
                        break;
                    }
                }
                
                DatasetVector *datasetVector = (DatasetVector *)floorRelationTable;
                Recordset *recordset = [datasetVector recordset:NO cursorType:STATIC];
                do{
                    NSString *FL_ID = (NSString *)[recordset getFieldValueWithString:@"FL_ID"];
                    if([FL_ID isEqualToString:floorID]){
                        incrementLineDatasetName = (NSString *)[recordset getFieldValueWithString:@"LineDatasetName"];
                        incrementNetworkDatasetName = (NSString *)[recordset getFieldValueWithString:@"NetworkName"];
                    }
                } while([recordset moveNext]);
                [recordset close];
                [recordset dispose];
            }
            if(incrementLineDatasetName != nil && incrementDatasource != nil){
                Dataset *dataset = [incrementDatasource.datasets getWithName:incrementLineDatasetName];
                Layer *layer = [sMap.smMapWC.mapControl.map.layers addDataset:dataset ToHead:YES];
                layer.editable = YES;
                resolve(@(YES));
            }else{
                resolve(@(NO));
            }
        });
    } @catch (NSException *exception) {
        reject(@"addNetWorkDataset",exception.reason,nil);
    }
}

#pragma mark 将路网数据集和线数据集从地图移除
RCT_REMAP_METHOD(removeNetworkDataset, removeNetworkDatasetWithResolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSString *datasourceName = incrementDatasource.alias;
            sMap = [SMap singletonInstance];
            Layers *layers = sMap.smMapWC.mapControl.map.layers;
            NSString *layerName = [NSString stringWithFormat:@"%@%@%@",incrementLineDatasetName,@"@",datasourceName];
            Layer *layer = [layers getLayerWithName:layerName];
            [layers remove:layer];
            
            if(incrementNetworkDatasetName != nil){
                DatasetVector *datasetVector = (DatasetVector *)[incrementDatasource.datasets getWithName:incrementNetworkDatasetName];
                NSString *layerName = [NSString stringWithFormat:@"%@%@%@",datasetVector.childDataset.name,@"@",datasourceName];
                Layer *networklayer = [layers getLayerWithName:layerName];
                if(networklayer != nil){
                    [layers remove:networklayer];
                }
            }
            if(GpsPoint2Ds != nil && [GpsPoint2Ds getCount] > 0){
                [GpsPoint2Ds clear];
            }
            incrementLayerAdded = NO;
            resolve(@(YES));
        });
    } @catch (NSException *exception) {
        reject(@"removeNetworkDataset" ,exception.reason, nil);
    }
}


#pragma mark 判断当前工作空间是否存在网络数据集（导航前置条件）
RCT_REMAP_METHOD(hasNetworkDataset, hasNetworkDatasetWithResolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Datasources *datasouces = sMap.smMapWC.workspace.datasources;
        BOOL hasNetworkDataset = NO;
        for(int i = 0; i < datasouces.count; i++){
            Datasets *datasets = [datasouces get:i].datasets;
            for(int j = 0; j < datasets.count; j++){
                Dataset *dataset = [datasets get:j];
                if(dataset.datasetType == Network){
                    hasNetworkDataset = YES;
                    break;
                }
            }
        }
        resolve(@(hasNetworkDataset));
    } @catch (NSException *exception) {
        reject(@"hasNetworkDataset", exception.reason, nil);
    }
}


#pragma mark 生成路网
RCT_REMAP_METHOD(buildNetwork, buildNetworkWithResolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try{
        dispatch_sync(dispatch_get_main_queue(), ^{
            sMap = [SMap singletonInstance];
            
            if(incrementLayerAdded){
                [sMap.smMapWC.mapControl.map.layers removeAt:0];
            }
            DatasetVector *lineDataset = (DatasetVector *) [incrementDatasource.datasets getWithName:incrementLineDatasetName];
            NSString *datasetName = [NSString stringWithFormat:@"%@%@",incrementLineDatasetName,@"_tmpDataset" ];
            [incrementDatasource.datasets deleteName:datasetName];
            
            DatasetVector *datasetVector = (DatasetVector *)[incrementDatasource copyDataset:lineDataset desDatasetName:datasetName encodeType:NONE];
            
            TopologyProcessingOptions *topologyProcessingOptions = [[TopologyProcessingOptions alloc] init];
            topologyProcessingOptions.linesIntersected = YES;
            [TopologyProcessing clean:datasetVector withOptions:topologyProcessingOptions];
            
            [incrementDatasource.datasets deleteName:incrementNetworkDatasetName];
            
            NSMutableArray *lineFieldNames = [[NSMutableArray alloc] init];
            for(int i = 0, count = datasetVector.fieldInfos.count; i < count; i++){
                lineFieldNames[i] = [datasetVector.fieldInfos get:i].caption;
            }
            
            NSMutableArray *datasets = [[NSMutableArray alloc] init];
            [datasets addObject:datasetVector];
            
            [NetworkBuilder buildNetwork:datasets pointDatasets:nil lineFieldNames:lineFieldNames pointFieldNames:nil outputDatasource:incrementDatasource networkDatasetName:incrementNetworkDatasetName networkSplitMode:NSM_LINE_SPLIT_BY_POINT tolerance:0.0000001];
            
            Layers *layers = sMap.smMapWC.mapControl.map.layers;
            DatasetVector *datasetVector2 = (DatasetVector *)[incrementDatasource.datasets getWithName:incrementNetworkDatasetName];
            [layers addDataset:datasetVector2.childDataset ToHead:YES];
            incrementLayerAdded = YES;
            resolve(@(YES));
        });
    }@catch(NSException *exception){
        reject(@"buildNetwork", exception.reason, nil);
    }
}

#pragma mark GPS开始
RCT_REMAP_METHOD(gpsBegin, gpsBeginWithResolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        GPSData *gpsData = [NativeUtil getGPSData];
        Point2D *gpsPoint = [[Point2D alloc]initWithX:gpsData.dLongitude Y:gpsData.dLatitude];
        NSLog(@"%@",gpsPoint);
        if(GpsPoint2Ds == nil){
            GpsPoint2Ds = [[Point2Ds alloc] init];
        }
        [GpsPoint2Ds add:gpsPoint];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"gpsBegin",exception.reason,nil);
    }
}

#pragma mark 添加GPS轨迹
RCT_REMAP_METHOD(addGPSRecordset,addGPSRecordsetWithResolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        DatasetVector *datasetVector = (DatasetVector *)[incrementDatasource.datasets getWithName:incrementLineDatasetName];
        if(datasetVector != nil){
            [datasetVector setReadOnly:NO];
        }
        Recordset *recordset = [datasetVector recordset:NO cursorType:DYNAMIC];
        GeoLine *geoline = [[GeoLine alloc] init];
        [geoline addPart:GpsPoint2Ds];
        [recordset addNew:geoline];
        [recordset update];
        NSArray *idNo = @[[NSNumber numberWithInteger:recordset.ID]];
        [recordset close];
        [geoline dispose];
        [recordset dispose];
        Recordset *recordset1 = [datasetVector queryWithID:idNo Type:DYNAMIC];
        EditHistory *history = [sMap.smMapWC.mapControl getEditHistory];
        [history BatchBegin];
        [history addHistoryType:EHT_AddNew recordset:recordset1 isCurrentOnly:YES];
        [history BatchEnd];
        [recordset1 close];
        [recordset1 dispose];
        [datasetVector close];
        [sMap.smMapWC.mapControl.map refresh];
        //提交完清空点数组
        if(GpsPoint2Ds != nil && [GpsPoint2Ds getCount] > 0){
            [GpsPoint2Ds clear];
        }
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"addGPSRecordset",exception.reason,nil);
    }
}


#pragma mark 判断是否是室内点
RCT_REMAP_METHOD(isIndoorPoint, isIndoorPointWithX:(double)x Y:(double) y resolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try{
        sMap = [SMap singletonInstance];
        BOOL isIndoor = NO;
        Datasource *naviDatasource;
        Datasources *datasources = sMap.smMapWC.workspace.datasources;
        for(int i = 0; i < datasources.count; i++){
            Datasource *datasource = [datasources get:i];
            Datasets *datasets = datasource.datasets;
            if([datasets contain:@"FloorRelationTable"]){
                naviDatasource = datasource;
                break;
            }
        }
        if(naviDatasource != nil){
            Datasets *datasets = naviDatasource.datasets;
            Point2D *mapCenter = sMap.smMapWC.mapControl.map.center;
            mapCenter = [SNavigationManager getPointWithX:mapCenter.x Y:mapCenter.y];
            for(int i = 0; i < datasets.count; i++){
                Dataset *dataset = [datasets get:i];
                if([dataset.bounds containsPoint2D:mapCenter] && [dataset.bounds containsX:x Y:y]){
                    isIndoor = YES;
                    break;
                }
            }
        }
        NSDictionary *dic = @{@"isindoor":@(isIndoor)};
        resolve(dic);
    }@catch(NSException *exception){
        reject(@"isIndoorPoint",exception.reason,nil);
    }
}

#pragma mark 添加起始点
RCT_REMAP_METHOD(getStartPoint, getStartPointWithX:(double)x Y:(double) y isIndoor: (BOOL)isindoor FloorID:(NSString*) floorID resolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        if(floorID == nil){
            floorID = sMap.smMapWC.floorListView.currentFloorId;
        }
        if(isindoor){
            [[sMap.smMapWC.mapControl getNavigation3] setStartPoint:x Y:y ID:floorID];
            [[sMap.smMapWC.mapControl getNavigation3] setCurrentFloorId:floorID];
        }else{
            Point2D *point2d =[SNavigationManager getMapPointWithX:x Y:y];
            [SNavigationManager showPointByCalloutAtX:point2d.x Y:point2d.y PointName:@"startpoint"];
        }
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"getStartPoint", exception.reason, nil);
    }
}

#pragma mark 添加终点
RCT_REMAP_METHOD(getEndPoint, getEndPointWithX:(double)x Y:(double) y isIndoor: (BOOL)isindoor  FloorID:(NSString*) floorID resolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        if(floorID == nil){
            floorID = sMap.smMapWC.floorListView.currentFloorId;
        }
        if(isindoor){
            [[sMap.smMapWC.mapControl getNavigation3] setDestinationPoint:x Y:y ID:floorID];
        }else{
            Point2D *point2d =[SNavigationManager getMapPointWithX:x Y:y];
            [SNavigationManager showPointByCalloutAtX:point2d.x Y:point2d.y PointName:@"endpoint"];
        }
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"getEndPoint", exception.reason, nil);
    }
}

#pragma mark 清除起终点
RCT_REMAP_METHOD(clearPoint, clearPointWithResolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try{
        sMap = [SMap singletonInstance];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [sMap.sNavigation2.m_navigation cleanPath];
            [sMap.smMapWC.mapControl.map.trackingLayer clear];
            [[sMap.smMapWC.mapControl getNavigation3] cleanPath];
            [SNavigationManager clearOutdoorPoint];
        });
        resolve(@(YES));
    }@catch(NSException *exception){
        reject(@"clearPoint", exception.reason, nil);
    }
}

#pragma mark 停止导航
RCT_REMAP_METHOD(stopGuide, stopGuideWithResolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [sMap.sNavigation2.m_navigation stopGuide];
            [[sMap.smMapWC.mapControl getNavigation3] stopGuide];
        });
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"stopGuide",exception.reason,nil);
    }
}

//#pragma mark 判断起终点地理位置名称
//RCT_REMAP_METHOD(getPointName, getPointNameWithX:(double)x Y:(double) y IsStart: (BOOL)isstart resolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
//    @try {
//        isStart = isstart;
//        Point2D *point2D = [[Point2D alloc] initWithX:x Y:y];
//        Geocoding *reverseGeocoding = [[Geocoding alloc] init];
//        [reverseGeocoding setKey:@"fvV2osxwuZWlY0wJb8FEb2i5"];
//        reverseGeocoding.delegate = self;
//        [reverseGeocoding reverseGeocoding:point2D];
//        resolve(@(YES));
//    } @catch (NSException *exception) {
//        reject(@"getPointName",exception.reason,nil);
//    }
//}
//
//#pragma mark 逆地理编码成功回调
//-(void)reversegeocodingSuccess:(GeocodingData*)geocodingData{
//    if(isStart){
//        [self sendEventWithName: MAPSELECTPOINTNAMESTART body:geocodingData.formatedAddress];
//    }else{
//        [self sendEventWithName: MAPSELECTPOINTNAMEEND body:geocodingData.formatedAddress];
//    }
//}
#pragma mark 获取当前地理坐标
RCT_REMAP_METHOD(getCurrentMapPosition, getCurrentMapPositionWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
        sMap = [SMap singletonInstance];
        GPSData *gpsData= [NativeUtil getGPSData];
        PrjCoordSys *mapCoordSys = sMap.smMapWC.mapControl.map.prjCoordSys;
        Point2Ds *points = [[Point2Ds alloc]init];
        Point2D *point = [[Point2D alloc] initWithX:gpsData.dLongitude Y:gpsData.dLatitude];
        [points add:point];
        
        PrjCoordSys *desPrjCoordSys = [[PrjCoordSys alloc]init];
        desPrjCoordSys.type = PCST_EARTH_LONGITUDE_LATITUDE;
        
        [CoordSysTranslator convert:points PrjCoordSys:desPrjCoordSys PrjCoordSys:mapCoordSys CoordSysTransParameter:[[CoordSysTransParameter alloc]init] CoordSysTransMethod:MTH_GEOCENTRIC_TRANSLATION];
        
        Point2D *point2D = [points getItem:0];
        resolve(@{
                  @"x":[NSNumber numberWithDouble:point2D.x],
                  @"y":[NSNumber numberWithDouble:point2D.y],
                  });
    }@catch(NSException *exception){
        reject(@"getCurrentMapPosition",exception.reason,nil);
    }
}

#pragma mark 显示起点/终点
+(void)showPointByCalloutAtX:(double)x Y:(double)y PointName:(NSString *)pointName{
    MapControl *mapControl = [SMap singletonInstance].smMapWC.mapControl;
    
    [mapControl removeCalloutWithTag:pointName];
    
    InfoCallout *infoCallout = [[InfoCallout alloc]initWithMapControl:mapControl BackgroundColor:[UIColor colorWithRed:255 green:0 blue:0 alpha:0] Alignment:CALLOUT_BOTTOM];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIImage *image;
        if([pointName isEqualToString:@"startpoint"]){
            image = [UIImage imageNamed:@"resources.bundle/icon_scene_tool_start.png"];
        }else{
            image = [UIImage imageNamed:@"resources.bundle/icon_scene_tool_end.png"];
        }
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setFrame:CGRectMake(0, 0, 60, 60)];
        infoCallout.width = 60;
        infoCallout.height = 60;
        
        [infoCallout addSubview:imageView];
        [infoCallout showAt:[[Point2D alloc] initWithX:x Y:y] Tag:pointName];
    });
}

#pragma mark 将地图上的点转换为经纬坐标点
+(Point2D *)getPointWithX:(double)x Y:(double)y{
    Point2D *point2D = nil;
    PrjCoordSys *mapCoordSys = [SMap singletonInstance].smMapWC.mapControl.map.prjCoordSys;
    if(mapCoordSys.type != PCST_EARTH_LONGITUDE_LATITUDE){
        Point2Ds *points = [[Point2Ds alloc]init];
        Point2D *point = [[Point2D alloc] initWithX:x Y:y];
        [points add:point];
        PrjCoordSys *desPrjCoordSys = [[PrjCoordSys alloc]init];
        desPrjCoordSys.type = PCST_EARTH_LONGITUDE_LATITUDE;
        // 转换投影坐标
        [CoordSysTranslator convert:points PrjCoordSys:mapCoordSys PrjCoordSys:desPrjCoordSys CoordSysTransParameter:[[CoordSysTransParameter alloc]init] CoordSysTransMethod:MTH_GEOCENTRIC_TRANSLATION];
        point2D = [points getItem:0];
    }else{
        point2D = [[Point2D alloc] initWithX:x Y:y];
    }
    return point2D;
}

#pragma mark 经纬坐标点转地理坐标点
+(Point2D *)getMapPointWithX:(double)x Y:(double)y{
    Point2D *point2D = nil;
    if(x >= -180 && x <= 180 && y >= -90 && y <= 90){
        PrjCoordSys *mapCoordSys = [SMap singletonInstance].smMapWC.mapControl.map.prjCoordSys;
        Point2Ds *points = [[Point2Ds alloc]init];
        Point2D *point = [[Point2D alloc] initWithX:x Y:y];
        [points add:point];
        PrjCoordSys *desPrjCoordSys = [[PrjCoordSys alloc]init];
        desPrjCoordSys.type = PCST_EARTH_LONGITUDE_LATITUDE;
        [CoordSysTranslator convert:points PrjCoordSys:desPrjCoordSys PrjCoordSys:mapCoordSys CoordSysTransParameter:[[CoordSysTransParameter alloc]init] CoordSysTransMethod:MTH_GEOCENTRIC_TRANSLATION];
        point2D = [points getItem:0];
    }else{
        point2D = [[Point2D alloc]initWithX:x Y:y];
    }
    return point2D;
}

#pragma mark 打开实时路况信息
RCT_REMAP_METHOD(openTrafficMap, openTrafficMapWithData:(NSDictionary *)data resolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Map *map =sMap.smMapWC.mapControl.map;
        Datasource *datasource = [sMap.smMapWC openDatasource:data];
        Layers *layers = map.layers;
        Point2D *center = map.center;
        double scale = map.scale;
        BOOL isAdded = NO;
        for(int i = 0; i < [layers getCount]; i++){
            if([[layers getLayerAtIndex:i].name isEqualToString:@"tencent@TrafficMap"]){
                isAdded = YES;
            }
        }
        if(!isAdded){
            [map.layers addDataset:[datasource.datasets get:0] ToHead:YES];
            map.scale = scale;
            map.center = center;
            [map refresh];
        }
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"openTrafficMap",exception.reason,nil);
    }
}

#pragma mark 判断是否打开实时路况
RCT_REMAP_METHOD(isOpenTrafficMap, isOpenTrafficMapWithResolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Layers *layers = sMap.smMapWC.mapControl.map.layers;
        BOOL isOpen = NO;
        for(int i = 0; i < [layers getCount]; i++){
            if([[layers getLayerAtIndex:i].name isEqualToString:@"tencent@TrafficMap"]){
                isOpen = YES;
            }
        }
        resolve(@(isOpen));
    } @catch (NSException *exception) {
        reject(@"isOpenTrafficMap",exception.reason,nil);
    }
}

#pragma mark 移除实时路况
RCT_REMAP_METHOD(removeTrafficMap, removeTrafficMapWith:(NSString *)layerName resolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try{
        sMap = [SMap singletonInstance];
        Map *map = sMap.smMapWC.mapControl.map;
        Point2D *center = map.center;
        double scale = map.scale;
        BOOL result = NO;
        Layer *layer = nil;
        LayerGroup *layerGroup = nil;
        [SMLayer findLayerAndGroupByPath:layerName layer:&layer group:&layerGroup];
        if(layerGroup != nil){
            if(layer != nil){
                [layerGroup removeLayer:layer];
            }
        }else{
            if(layer != nil){
                result = [map.layers removeWithName:layerName];
            }
        }
        map.scale = scale;
        map.center = center;
        [map refresh];
        resolve(@(result));
    }@catch(NSException *exception){
        reject(@"removeTrafficMap",exception.reason,nil);
    }
}


#pragma mark 拷贝室外地图网络模型snm文件
RCT_REMAP_METHOD(copyNaviSnmFile,copyNaviSnmFileWithArray:(NSArray *)files resolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        for(int i = 0; i < files.count; i++){
            NSDictionary *file = [files objectAtIndex:i];
            [sMap.smMapWC copyNaviSnmFileFrom:file];
        }
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"copyNaviSnmFile",exception.reason,nil);
    }
}

#pragma mark 判断当前地图是否是室内地图
RCT_REMAP_METHOD(isIndoorMap,isIndoorMapWithResolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        BOOL isIndoor = NO;
        if(sMap.smMapWC.floorListView.currentFloorId != nil){
            isIndoor = YES;
        }
        resolve(@(isIndoor));
    } @catch (NSException *exception) {
        reject(@"isIndoorMap",exception.reason,nil);
    }
}

#pragma mark 判断点是否在数据集bounds内
RCT_REMAP_METHOD(isInBounds, isInBoundsWithPoint:(NSDictionary *)point DatasetName:(NSString *)datasetName Resolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        BOOL inBounds = NO;
        double x = [[point valueForKey:@"x"] doubleValue];
        double y = [[point valueForKey:@"y"] doubleValue];
        Datasources *datasources = sMap.smMapWC.workspace.datasources;
        for(int i = 0; i < datasources.count; i++){
            Datasource *datasource = [datasources get:i];
            Datasets *datasets = datasource.datasets;
            Dataset *dataset = [datasets getWithName:datasetName];
            if(dataset != nil && [dataset.bounds containsX:x Y:y]){
                inBounds = YES;
            }
        }
        resolve(@(inBounds));
    } @catch (NSException *exception) {
        reject(@"isInBounds", exception.reason, nil);
    }
}
#pragma mark 获取楼层相关数据，并初始化楼层控件 额外返回一个数据源名称，用于判断是否需要重新获取楼层信息
RCT_REMAP_METHOD(getFloorData, getFloorDataWithResolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try{
        sMap = [SMap singletonInstance];
        Datasources *datasources = sMap.smMapWC.workspace.datasources;
        Datasource *curDatasource = nil;
        Dataset *floorRelationTable = nil;
        for(int i = 0; i < datasources.count; i++){
            Datasource *datasource = [datasources get:i];
            Datasets *datasets = datasource.datasets;
            if([datasets contain:@"FloorRelationTable"]){
                curDatasource = datasource;
                floorRelationTable = [datasets getWithName:@"FloorRelationTable"];
                break;
            }
        }
        if(floorRelationTable != nil){
            
            //初始化floorListView
            FloorListView *floorListView = [[FloorListView alloc] initWithFrame:CGRectMake(0,0,0,0)];
            [floorListView linkMapControl:sMap.smMapWC.mapControl];
            sMap.smMapWC.floorListView = floorListView;
            
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            DatasetVector *datasetVector = (DatasetVector *)floorRelationTable;
            Recordset *recordset = [datasetVector recordset:NO cursorType:STATIC];
            do{
                NSString *FL_ID = (NSString *)[recordset getFieldValueWithString:@"FL_ID"];
                NSString *floorName = (NSString *)[recordset getFieldValueWithString:@"FLoorName"];
                if(FL_ID != nil && floorName != nil){
                    [array addObject:@{@"name":floorName,@"id":FL_ID}];
                }
            } while([recordset moveNext]);
            [recordset close];
            [recordset dispose];
            
            NSString *currentFloorID = floorListView.currentFloorId == nil ? @"" : floorListView.currentFloorId;
            [dic setValue:array forKey:@"data"];
            [dic setValue:curDatasource.alias forKey:@"datasource"];
            [dic setValue:currentFloorID forKey:@"currentFloorID"];
            
            resolve(dic);
        }else{
            resolve(@{@"datasource": @""});
        }
    }@catch(NSException *exception){
        reject(@"getFloorData", exception.reason, nil);
    }
}

#pragma mark 判断搜索结果的两个点是否在某个路网数据集的bounds内，返回结果用于行业导航。无结果则进行在线路径分析
RCT_REMAP_METHOD(isPointsInMapBounds, isPointsInMapBoundsWithStartPoint:(NSDictionary *)startPoint EndPoin:(NSDictionary *)endPoint resolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try{
        
        NSDictionary *dic = @{};
        double x1 = [[startPoint valueForKey:@"x"] doubleValue];
        double y1 = [[startPoint valueForKey:@"y"] doubleValue];
        double x2 = [[endPoint valueForKey:@"x"] doubleValue];
        double y2 = [[endPoint valueForKey:@"y"] doubleValue];
        Datasource *networkDatasource = nil;
        Dataset *networkDataset = nil;
        
        sMap = [SMap singletonInstance];
        
        Datasources *datasouces = sMap.smMapWC.workspace.datasources;
        for(int i = 0; i < datasouces.count; i++){
            Datasource *datasource = [datasouces get:i];
            Datasets *datasets = datasource.datasets;
            for(int j = 0; j < datasets.count; j++){
                Dataset *dataset = [datasets get:j];
                if(dataset.datasetType == Network && [dataset.bounds containsX:x1 Y:y1] && [dataset.bounds containsX:x2 Y:y2]){
                    networkDataset = dataset;
                    networkDatasource = datasource;
                    break;
                }
            }
        }
        if(networkDataset != nil){
            Datasets *datasets = networkDatasource.datasets;
            Dataset *linkTable = [datasets getWithName:@"ModelFileLinkTable"];
            if(linkTable != nil){
                DatasetVector *datasetVector = (DatasetVector *)linkTable;
                Recordset *recordset = [datasetVector recordset:NO cursorType:STATIC];
                do{
                    NSString *networkDatasetName = (NSString *)[recordset getFieldValueWithString:@"NetworkDataset"];
                    NSString *netModelFileName = (NSString *)[recordset getFieldValueWithString:@"NetworkModelFile"];
                    if(networkDatasetName != nil && netModelFileName != nil){
                        dic = @{
                                @"name":networkDatasetName,
                                @"modelFileName":netModelFileName,
                                @"datasourceName":networkDatasource.alias,
                                };
                        break;
                        
                    }
                }while([recordset moveNext]);
                [recordset close];
                [recordset dispose];
            }
        }
        resolve(dic);
    }@catch(NSException *exception){
        reject(@"isPointsInMapBounds",exception.reason,nil);
    }
}

@end


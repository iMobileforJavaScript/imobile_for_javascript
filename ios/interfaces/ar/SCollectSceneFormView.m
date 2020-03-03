//
//  SCollectSceneFormView.m
//  Supermap
//
//  Created by wnmng on 2020/2/14.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "SCollectSceneFormView.h"
#import "SMap.h"
#import "SuperMap/Recordset.h"
#import "SuperMap/CoordSysTranslator.h"
#import "SMCollector.h"
#import "SuperMap/GeoLine3D.h"
#import "SuperMap/Point3Ds.h"
#import "SceneFormInfo.h"


@implementation SCollectSceneFormView

static ARCollectorView* _arCollection = nil;
static BOOL _isShowTrace = NO;
static NSString* mDatasourceAlias = nil;

//校准时，面朝正南方，屏幕垂直面朝自己
//校准信息先存储 saveDataset时应用
//校准点（x,y)  校准GPS（Longitude,Latitude）=>Mercator(x,y)
//static CGPoint mFixedAR;
static Point2D* mFixedMercator;
static double mFixedAltitude = 0;
//校准南向偏移角度a
static float mFixedAngle = 0;

RCT_EXPORT_MODULE();

NSString * const SCOLLECT_TOTALLENGTHCHANGE =  @"onTotalLengthChanged";
- (NSArray<NSString *> *)supportedEvents
{
    return @[
        SCOLLECT_TOTALLENGTHCHANGE
             ];
}

//static AIPlateCollectionView* aiPlateCollection = nil;
//
//+(AIPlateCollectionView*)shareInstance{
//    return aiPlateCollection;
//}
//
//+(void)setInstance:(AIPlateCollectionView*)aICollectView{
//    aiPlateCollection = aICollectView;
//}

+(ARCollectorView*)shareInstance{
    return _arCollection;
}
+(void)setInstance:(ARCollectorView*)arCollectView{
    _arCollection = arCollectView;
}

-(NSString*)getCurrentTime{
    NSDate *date = [NSDate date];
    //如果没有规定formatter的时区，那么formatter默认的就是当前时区，比如现在在北京就是东八区，在东京就是东九区
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //最结尾的Z表示的是时区，零时区表示+0000，东八区表示+0800
    //[formatter setDateFormat:@"yyyy-MM-dd&HH:mm:ss"];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    // 使用formatter转换后的date字符串变成了当前时区的时间
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}


-(void)saveLineData:(NSArray*)arrPnts toDataset:(NSString*)datasetName{
    [self createLineDataset:datasetName toDatasource:mDatasourceAlias];
    DatasetVector *datasetVector = nil;
    MapControl* mapControl = SMap.singletonInstance.smMapWC.mapControl;
    Workspace* workspace = mapControl.map.workspace;
    Datasource* datasource = [workspace.datasources getAlias:mDatasourceAlias];
    datasetVector = (DatasetVector*) [datasource.datasets getWithName:datasetName];
    Recordset *recordset = [datasetVector recordset:true cursorType:DYNAMIC];//动态指针
    NSArray*arrLinePnts = [self transformARToMercator:arrPnts];
    if (recordset != nil) {
        //移动指针到最后
       // [recordset moveLast];
        [recordset edit];//可编辑
        
        int count = arrLinePnts.count/3;
        Point2Ds *pnt2ds = [[Point2Ds alloc]init];
        for (int i = 0; i < count; i++) {
            Point2D *pnt2d = [[Point2D alloc] init];
            pnt2d.x = [[arrLinePnts objectAtIndex:i*3] doubleValue];
            pnt2d.y = [[arrLinePnts objectAtIndex:i*3+1] doubleValue];
            [pnt2ds add:pnt2d];
        }
        
        if (![datasetVector.prjCoordSys isSame:[[PrjCoordSys alloc] initWithType:PCST_WORLD_MERCATOR]]) {
            //mercator -> gps
            [CoordSysTranslator convert:pnt2ds
                       PrjCoordSys:[[PrjCoordSys alloc] initWithType:PCST_WORLD_MERCATOR]
                       PrjCoordSys:datasetVector.prjCoordSys
            CoordSysTransParameter:[[CoordSysTransParameter alloc]init]
               CoordSysTransMethod:MTH_GEOCENTRIC_TRANSLATION];
        }
        
        
        Point3Ds *point3DS = [[Point3Ds alloc]init];
        for (int i = 0; i < count;i++) {
            Point3D value;
            Point2D *pnt2d = [pnt2ds getItem:i];
            value.x = pnt2d.x;
            value.y = pnt2d.y;
            value.z = [[arrLinePnts objectAtIndex:i*3+2] doubleValue];
            [point3DS addPoint3D:value];
        }

        GeoLine3D *geoLine3D = [[GeoLine3D alloc]initWithPoint3Ds:point3DS];
        //移动指针到下一位
        //[recordset moveNext];
        //新增面对象
        [recordset addNew:geoLine3D];

        FieldInfos *fieldInfos = [recordset fieldInfos];
        if ([fieldInfos indexOfWithFieldName: @"ModifiedDate"] != -1) {
            NSString* str = (NSString*)[recordset getFieldValueWithString:@"ModifiedDate"];
            NSString* currentTime = [self getCurrentTime];
            if (! [currentTime isEqualToString:str]) {
                [recordset setFieldValueWithString:@"ModifiedDate" Obj:currentTime];
            }
        }
        if ([fieldInfos indexOfWithFieldName: @"NAME"] != -1) {
            NSString* str = (NSString*)[recordset getFieldValueWithString:@"NAME"];
            
            if (! [datasetName isEqualToString:str]) {
                [recordset setFieldValueWithString:@"NAME" Obj:datasetName];
            }
        }

        //保存更新,并释放资源
        [recordset update];
        [recordset close];
        [recordset dispose];
    }
    [datasource saveDatasource];
}

-(void)savePointDataX:(double)x y:(double)y z:(double)z toDataset:(NSString*)datasetName withStr:(NSString*)strValue{
    [self createPointDataset:datasetName toDatasource:mDatasourceAlias];
    DatasetVector *datasetVector = nil;
    MapControl* mapControl = SMap.singletonInstance.smMapWC.mapControl;
    Workspace* workspace = mapControl.map.workspace;
    Datasource* datasource = [workspace.datasources getAlias:mDatasourceAlias];
    datasetVector = (DatasetVector*) [datasource.datasets getWithName:datasetName];
    Recordset *recordset = [datasetVector recordset:true cursorType:DYNAMIC];//动态指针
    
    NSArray *arrAR = [NSArray arrayWithObjects:@(x),@(y),@(z), nil];
    NSArray *arrMercator = [self transformARToMercator:arrAR];
    Point2Ds *pnt2ds = [[Point2Ds alloc]init];
    Point2D *pnt2d = [[Point2D alloc] init];
    pnt2d.x = [[arrMercator objectAtIndex:0] doubleValue];
    pnt2d.y = [[arrMercator objectAtIndex:1] doubleValue];
    [pnt2ds add:pnt2d];
    
    if (![datasetVector.prjCoordSys isSame:[[PrjCoordSys alloc] initWithType:PCST_WORLD_MERCATOR]]) {
        //mercator -> gps
        [CoordSysTranslator convert:pnt2ds
                   PrjCoordSys:[[PrjCoordSys alloc] initWithType:PCST_WORLD_MERCATOR]
                   PrjCoordSys:datasetVector.prjCoordSys
        CoordSysTransParameter:[[CoordSysTransParameter alloc]init]
           CoordSysTransMethod:MTH_GEOCENTRIC_TRANSLATION];
    }
    Point2D *pntGPS = [pnt2ds getItem:0];
    double gpsz = [[arrMercator objectAtIndex:2] doubleValue];
    
   GeoPoint3D *geoPoint = [[GeoPoint3D alloc]initWithX:pntGPS.x Y:pntGPS.y Z:gpsz];
    
    
    if (recordset != nil) {
        //移动指针到最后
        //[recordset moveLast];
        [recordset edit];//可编辑
        
        
        
        //移动指针到下一位
        //[recordset moveNext];
        //新增面对象
        [recordset addNew:geoPoint];

        FieldInfos *fieldInfos = [recordset fieldInfos];
        if ([fieldInfos indexOfWithFieldName: @"ModifiedDate"] != -1) {
            NSString* str = (NSString*)[recordset getFieldValueWithString:@"ModifiedDate"];
            NSString* currentTime = [self getCurrentTime];
            if (! [currentTime isEqualToString:str]) {
                [recordset setFieldValueWithString:@"ModifiedDate" Obj:currentTime];
            }
        }
        if ([fieldInfos indexOfWithFieldName: @"NAME"] != -1) {
            NSString* str = (NSString*)[recordset getFieldValueWithString:@"NAME"];
            
            if (! [datasetName isEqualToString:str]) {
                [recordset setFieldValueWithString:@"NAME" Obj:datasetName];
            }
        }
        if ([fieldInfos indexOfWithFieldName: @"Description"] != -1) {
            NSString* str = (NSString*)[recordset getFieldValueWithString:@"Description"];
            
            if (! [datasetName isEqualToString:str]) {
                [recordset setFieldValueWithString:@"Description" Obj:strValue];
            }
        }

        //保存更新,并释放资源
        [recordset update];
        [recordset close];
        [recordset dispose];
    }
    [datasource saveDatasource];
}

-(void)createDatasource:(NSString*)datasourceAlias path:(NSString*)datasourcePath{
    Datasource *datasource = [SMap.singletonInstance.smMapWC.workspace.datasources getAlias:datasourceAlias];
    if (datasource==nil || datasource.isReadOnly) {
        DatasourceConnectionInfo* info =  [[DatasourceConnectionInfo alloc]init];
        [info setAlias:datasourceAlias];
        [info setEngineType:ET_UDB];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        BOOL isDir = false;
        BOOL isExist = [manager fileExistsAtPath:datasourcePath isDirectory:&isDir];
        if (!isExist || !isDir) {
            [manager createDirectoryAtPath:datasourcePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString* strServer = [NSString stringWithFormat:@"%@%@.udb",datasourcePath,datasourceAlias];
        [info setServer:strServer];

        datasource = [SMap.singletonInstance.smMapWC.workspace.datasources create:info];
        //datasource = SMap.getInstance().getSmMapWC().getWorkspace().getDatasources().create(info);
        if (datasource == nil) {
            [SMap.singletonInstance.smMapWC.workspace.datasources open:info];
            //SMap.getInstance().getSmMapWC().getWorkspace().getDatasources().open(info);
        }
        [info dispose];
    }
}

-(void)createLineDataset:(NSString*)datasetName toDatasource:(NSString*)UDBName{
    //MapControl *mapcontrol = SMap.singletonInstance.smMapWC.mapControl;
    Workspace  *workspace  = SMap.singletonInstance.smMapWC.workspace;
    Datasource *datasource = [workspace.datasources getAlias:UDBName];
    Datasets *datasets = datasource.datasets;
    if ([datasets contain:datasetName]) {
        [self checkFieldInfos:(DatasetVector*)[datasets getWithName:datasetName]];
        return;
    }
    
    DatasetVectorInfo *datasetVectorInfo = [[DatasetVectorInfo alloc]init];
    [datasetVectorInfo setDatasetType:LineZ];
    [datasetVectorInfo setEncodeType:NONE];
    [datasetVectorInfo setName:datasetName];
    DatasetVector *datasetVector = [datasets create:datasetVectorInfo];
    
    //创建数据集时创建好字段
    [self addFieldInfo:datasetVector name:@"Description" fileType:FT_TEXT required:false default:@"" maxLength:255];
    //      addFieldInfo(datasetVector, "Description", FieldType.TEXT, false, "", 255);
    [self addFieldInfo:datasetVector name:@"ModifiedDate" fileType:FT_TEXT required:false default:@"" maxLength:255];
    //      addFieldInfo(datasetVector, "ModifiedDate", FieldType.TEXT, false, "", 255);
    [self addFieldInfo:datasetVector name:@"Name" fileType:FT_TEXT required:false default:@"" maxLength:255];
    //      addFieldInfo(datasetVector, "Name", FieldType.TEXT, false, "", 255);

    [datasetVector setPrjCoordSys:[[PrjCoordSys alloc] initWithType:PCST_EARTH_LONGITUDE_LATITUDE]];
   // [datasetVector setPrjCoordSys:[[PrjCoordSys alloc] initWithType:PCST_WORLD_MERCATOR]];
    //      datasetVector.setPrjCoordSys(new PrjCoordSys(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE));

    [datasetVectorInfo dispose];
    [datasetVector close];
    
}


-(void)createPointDataset:(NSString*)pointdatasetName toDatasource:(NSString*)UDBName{
   // MapControl *mapcontrol = SMap.singletonInstance.smMapWC.mapControl;
    Workspace  *workspace  = SMap.singletonInstance.smMapWC.workspace;
    Datasource *datasource = [workspace.datasources getAlias:UDBName];
    Datasets *datasets = datasource.datasets;
    if ([datasets contain:pointdatasetName]) {
        [self checkFieldInfos:(DatasetVector*)[datasets getWithName:pointdatasetName]];
        return;
    }
    
    DatasetVectorInfo *datasetVectorInfo = [[DatasetVectorInfo alloc]init];
    [datasetVectorInfo setDatasetType:PointZ];
    [datasetVectorInfo setEncodeType:NONE];
    [datasetVectorInfo setName:pointdatasetName];
    DatasetVector *datasetVector = [datasets create:datasetVectorInfo];
    
    //创建数据集时创建好字段
    [self addFieldInfo:datasetVector name:@"Description" fileType:FT_TEXT required:false default:@"" maxLength:255];
    //      addFieldInfo(datasetVector, "Description", FieldType.TEXT, false, "", 255);
    [self addFieldInfo:datasetVector name:@"ModifiedDate" fileType:FT_TEXT required:false default:@"" maxLength:255];
    //      addFieldInfo(datasetVector, "ModifiedDate", FieldType.TEXT, false, "", 255);
    [self addFieldInfo:datasetVector name:@"Name" fileType:FT_TEXT required:false default:@"" maxLength:255];
    //      addFieldInfo(datasetVector, "Name", FieldType.TEXT, false, "", 255);

    [datasetVector setPrjCoordSys:[[PrjCoordSys alloc] initWithType:PCST_EARTH_LONGITUDE_LATITUDE]];
    //[datasetVector setPrjCoordSys:[[PrjCoordSys alloc] initWithType:PCST_WORLD_MERCATOR]];
    //      datasetVector.setPrjCoordSys(new PrjCoordSys(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE));

    [datasetVectorInfo dispose];
    [datasetVector close];
    
}

-(void)addFieldInfo:(DatasetVector*)dataset name:(NSString*)name fileType:(FieldType)type required:(BOOL)isReq default:(NSString*)value maxLength:(int)maxLength{
    FieldInfos *infos = [dataset fieldInfos];
    if([infos indexOfWithFieldName:name]!=-1){
        [infos removeFieldName:name];
    }
    FieldInfo *newInfo = [[FieldInfo alloc]init];
    [newInfo setName:name];
    [newInfo setFieldType:type];
    [newInfo setMaxLength:maxLength];
    [newInfo setDefaultValue:value];
    [newInfo setRequired:isReq];
    [infos add:newInfo];
}

-(void)checkFieldInfos:(DatasetVector*)datasetVector{
    FieldInfos *fieldInfos  = [datasetVector fieldInfos];
    if ([fieldInfos indexOfWithFieldName:@"Description"] == -1) {
        [self addFieldInfo:datasetVector name:@"Description" fileType:FT_TEXT required:false default:@"" maxLength:255];
        //addFieldInfo(datasetVector, "Description", FieldType.TEXT, false, "", 255);
    }

    if ([fieldInfos indexOfWithFieldName:@"ModifiedDate"] == -1) {
        [self addFieldInfo:datasetVector name:@"ModifiedDate" fileType:FT_TEXT required:false default:@"" maxLength:255];
        //addFieldInfo(datasetVector, "ModifiedDate", FieldType.TEXT, false, "", 255);
    }
    
    if ([fieldInfos indexOfWithFieldName:@"Namee"] == -1) {
        [self addFieldInfo:datasetVector name:@"Name" fileType:FT_TEXT required:false default:@"" maxLength:255];
        //addFieldInfo(datasetVector, "Name", FieldType.TEXT, false, "", 255);
    }
}

-(NSArray*)allGeometryFromDatasource:(NSString*)UDBName dataset:(int)index{
    DatasetVector *datasetVector = nil;
    if (UDBName != nil) {
        MapControl* mapControl = SMap.singletonInstance.smMapWC.mapControl;
        Workspace *workspace = mapControl.map.workspace;
        Datasource* datasource = [workspace.datasources getAlias:UDBName];
        if (datasource != nil) {
            datasetVector = (DatasetVector*) [datasource.datasets get:index];
            [datasetVector open];
        }
    }
    
    if (datasetVector==nil || datasetVector.datasetType!=LineZ || ![datasetVector isOpen]) {
        return nil;
    }
    
    Recordset *recordset = [datasetVector recordset:false cursorType:STATIC];
    [recordset moveFirst];
   
    FieldInfos* fieldInfos = [recordset fieldInfos];
    
    NSMutableArray*list = [[NSMutableArray alloc]init];
    
    while (![recordset isEOF]) {
        int geometryId = [[recordset geometry] getID];

        GeoLine3D* geoLine3D =(GeoLine3D*) [recordset geometry];

        NSString* NAME = @"";
        if ([fieldInfos indexOfWithFieldName:@"NAME"]!=-1) {
            NAME = (NSString*)[recordset getFieldValueWithString:@"NAME"];
        }
        NSString* TIME = @"";
        if ([fieldInfos indexOfWithFieldName:@"ModifiedDate"]!=-1) {
            TIME = (NSString*)[recordset getFieldValueWithString:@"ModifiedDate"];
        }
        NSString* Description = @"";
        if ([fieldInfos indexOfWithFieldName:@"Description"]!=-1) {
            Description = (NSString*)[recordset getFieldValueWithString:@"Description"];
        }
        
        //trans
        Point3Ds* line3dPnts = [geoLine3D getPart:0];
        Point2Ds* pnt2ds = [[Point2Ds alloc]init];
        NSMutableArray*arrMercator = [[NSMutableArray alloc]init];
        for (int i=0; i<line3dPnts.count;i++) {
            Point3D value = [line3dPnts itemofIndex:i];
            [pnt2ds add: [[Point2D alloc] initWithX:value.x Y:value.y]];
            [arrMercator addObject:@(value.x)];
            [arrMercator addObject:@(value.y)];
            [arrMercator addObject:@(value.z)];
        }
        
        if (![datasetVector.prjCoordSys isSame:[[PrjCoordSys alloc] initWithType:PCST_WORLD_MERCATOR]]) {
           //mercator -> gps
           [CoordSysTranslator convert:pnt2ds
                      PrjCoordSys:datasetVector.prjCoordSys
                      PrjCoordSys:[[PrjCoordSys alloc] initWithType:PCST_WORLD_MERCATOR]
           CoordSysTransParameter:[[CoordSysTransParameter alloc]init]
              CoordSysTransMethod:MTH_GEOCENTRIC_TRANSLATION];
        }
        
        
        for (int i=0; i<pnt2ds.getCount;i++) {
            Point2D *pnt2d = [pnt2ds getItem:i];
            [arrMercator replaceObjectAtIndex:i*3 withObject:@(pnt2d.x)];
            [arrMercator replaceObjectAtIndex:i*3+1 withObject:@(pnt2d.y)];
        }
        
        NSArray *arrARPnts = [self transformMercatorToAR:arrMercator];
        
       // GeoLine3D *line3DAR = [[GeoLine3D alloc]initWithPoint3Ds:<#(Point3Ds *)#>];
        

        SceneFormInfo*info = [[SceneFormInfo alloc]init];
        [info setID:geometryId];
        [info setArrPointsData:arrARPnts];
        //[info setGeoLine3D:geoLine3D];
        [info setName:NAME];
        [info setTime:TIME];
        [info setNotes:Description];
        
        [list addObject:info];

        [recordset moveNext];
            
    }

    [recordset close];
    [recordset dispose];
    return list;
}

-(NSArray*)allPointsFromDatasource:(NSString*)UDBName dataset:(int)index{
    DatasetVector *datasetVector = nil;
    if (UDBName != nil) {
        MapControl* mapControl = SMap.singletonInstance.smMapWC.mapControl;
        Workspace *workspace = mapControl.map.workspace;
        Datasource* datasource = [workspace.datasources getAlias:UDBName];
        if (datasource != nil) {
            datasetVector = (DatasetVector*) [datasource.datasets get:index];
            [datasetVector open];
        }
    }
    
    if (datasetVector==nil || datasetVector.datasetType!=PointZ || ![datasetVector isOpen]) {
        return nil;
    }
    
    Recordset *recordset = [datasetVector recordset:false cursorType:STATIC];
    [recordset moveFirst];
   
    FieldInfos* fieldInfos = [recordset fieldInfos];
    
    NSMutableArray*list = [[NSMutableArray alloc]init];
    
    while (![recordset isEOF]) {
        int geometryId = [[recordset geometry] getID];

        GeoPoint3D* geopoint3D =(GeoPoint3D*) [recordset geometry];

        NSString* NAME = @"";
        if ([fieldInfos indexOfWithFieldName:@"NAME"]!=-1) {
            NAME = (NSString*)[recordset getFieldValueWithString:@"NAME"];
        }
        NSString* TIME = @"";
        if ([fieldInfos indexOfWithFieldName:@"ModifiedDate"]!=-1) {
            TIME = (NSString*)[recordset getFieldValueWithString:@"ModifiedDate"];
        }
        NSString* Description = @"";
        if ([fieldInfos indexOfWithFieldName:@"Description"]!=-1) {
            Description = (NSString*)[recordset getFieldValueWithString:@"Description"];
        }
        
        //trans
        Point3D value = [geopoint3D innerPoint3D];
        Point2Ds* pnt2ds = [[Point2Ds alloc]init];
        [pnt2ds add: [[Point2D alloc] initWithX:value.x Y:value.y]];
        if (![datasetVector.prjCoordSys isSame:[[PrjCoordSys alloc] initWithType:PCST_WORLD_MERCATOR]]) {
            //mercator -> gps
            [CoordSysTranslator convert:pnt2ds
                     PrjCoordSys:datasetVector.prjCoordSys
                     PrjCoordSys:[[PrjCoordSys alloc] initWithType:PCST_WORLD_MERCATOR]
            CoordSysTransParameter:[[CoordSysTransParameter alloc]init]
             CoordSysTransMethod:MTH_GEOCENTRIC_TRANSLATION];
        }
        Point2D *pnt2d = [pnt2ds getItem:0];
        NSMutableArray*arrMercator = [[NSMutableArray alloc]init];
        [arrMercator addObject:@(pnt2d.x)];
        [arrMercator addObject:@(pnt2d.y)];
        [arrMercator addObject:@(value.z)];
    
        NSArray *arrARPnts = [self transformMercatorToAR:arrMercator];
        

        SceneFormInfo*info = [[SceneFormInfo alloc]init];
        [info setID:geometryId];
        //[info setGeoPoint3D:geopoint3D];
        [info setArrPointsData:arrARPnts];
        [info setName:NAME];
        [info setTime:TIME];
        [info setNotes:Description];
        
        [list addObject:info];

        [recordset moveNext];
            
    }
 
    [recordset close];
    [recordset dispose];
    return list;
}

-(void)onLengthChange:(float)length{
    NSString* str = [NSString stringWithFormat:@"%.2f",length];
    [self sendEventWithName:SCOLLECT_TOTALLENGTHCHANGE body:@{ @"totalLength": str }];
}

-(NSArray*)transformARToMercator:(NSArray*)arrARPos{
    int nCount = arrARPos.count/3;
    NSMutableArray *arrMercator = [[NSMutableArray alloc] init];
    for (int i=0; i<nCount; i++) {
        double x = [(NSNumber*)arrARPos[i*3] doubleValue] ;
        double y = [(NSNumber*)arrARPos[i*3+1] doubleValue];
        double z = [(NSNumber*)arrARPos[i*3+2] doubleValue];
        
        double cosa = cosf(mFixedAngle);
        double sina = sinf(mFixedAngle);
        
        double resX = (x*cosa + y*sina) + mFixedMercator.x;
        double resY = (y*cosa - x*sina) + mFixedMercator.y;
        double resZ = z + mFixedAltitude;
        
        [arrMercator addObject:@(resX)];
        [arrMercator addObject:@(resY)];
        [arrMercator addObject:@(resZ)];
    }
    return arrMercator;
}


-(NSArray*)transformMercatorToAR:(NSArray*)arrMercator{
    int nCount = arrMercator.count/3;
    NSMutableArray *arrAR = [[NSMutableArray alloc] init];
    for (int i=0; i<nCount; i++) {
        double x = [(NSNumber*)arrMercator[i*3] doubleValue] - mFixedMercator.x;
        double y = [(NSNumber*)arrMercator[i*3+1] doubleValue] - mFixedMercator.y;
        double z = [(NSNumber*)arrMercator[i*3+2] doubleValue] - mFixedAltitude;
        
        double cosa = cosf(-mFixedAngle);
        double sina = sinf(-mFixedAngle);
        
        double resX = (x*cosa + y*sina);
        double resY = (y*cosa - x*sina);
        double resZ = z;
        
        [arrAR addObject:@(resX)];
        [arrAR addObject:@(resY)];
        [arrAR addObject:@(resZ)];
    }
    return arrAR;
}

#pragma mark ----------------getSystemTime--------RN--------
RCT_REMAP_METHOD(getSystemTime, getSystemTime:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSString *strTime = [self getCurrentTime];
        resolve(strTime);
    } @catch (NSException *exception) {
        reject(@"getSystemTime", exception.reason, nil);
    }
}

/**
* 开始记录
*
* @param promise
*/
#pragma mark ----------------startRecording--------RN--------
RCT_REMAP_METHOD(startRecording, startRecording:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [_arCollection addNewRoute];
        _isShowTrace = true;
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"startRecording", exception.reason, nil);
    }
}

/**
* 停止记录
*
* @param promise
*/
#pragma mark ----------------stopRecording--------RN--------
RCT_REMAP_METHOD(stopRecording, stopRecording:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        _isShowTrace = false;
        [_arCollection saveCurrentRoute];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"stopRecording", exception.reason, nil);
    }
}

/**
* 获取轨迹状态
*
* @param promise
*/
#pragma mark ----------------isShowTrace--------RN--------
RCT_REMAP_METHOD(isShowTrace, isShowTrace:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        resolve(@(_isShowTrace));
    } @catch (NSException *exception) {
        reject(@"isShowTrace", exception.reason, nil);
    }
}

/**
* 获取三维场景里的数据并保存
*
* @param promise
*/
#pragma mark ----------------saveData--------RN--------
RCT_REMAP_METHOD(saveData, saveData:(NSString*)name resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSArray *arrPostData = [_arCollection currentRoutePoints];
        if(arrPostData.count<3){
            resolve(@(NO));
        }else{
            NSString *strDatasetName = [NSString stringWithFormat:@"Line%@",[self getCurrentTime]];
            [self saveLineData:arrPostData toDataset:strDatasetName];
            resolve(@(YES));
        }
        
    } @catch (NSException *exception) {
        reject(@"saveData", exception.reason, nil);
    }
}

/**
    * 场景数增加
    *
    * @param promise
*/
#pragma mark ----------------routeAdd--------RN--------
RCT_REMAP_METHOD(routeAdd, routeAdd:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [_arCollection routeAdd];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"routeAdd", exception.reason, nil);
    }
}

/**
* 删除指定数据
*
* @param promise
*/
#pragma mark ----------------deleteData--------RN--------
RCT_REMAP_METHOD(deleteData, deleteData:(int)index resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Workspace *workspace = [SMap.singletonInstance.smMapWC workspace];
        Datasource *datasource = [workspace.datasources getAlias:mDatasourceAlias];
        [datasource.datasets delete:index];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"deleteData", exception.reason, nil);
    }
}

/**
    * 重命名数据源
    *
    * @param promise
*/
#pragma mark ----------------reNameDataSource--------RN--------
RCT_REMAP_METHOD(reNameDataSource, reNameDataSource:(NSString*)name reName:(NSString*)reName resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Workspace *workspace = [SMap.singletonInstance.smMapWC workspace];
        [workspace.datasources RenameDatasource:name with:reName];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"reNameDataSource", exception.reason, nil);
    }
}

/**
    * 保存当前定位点
    *
    * @param promise
*/
#pragma mark ----------------saveGPSData--------RN--------
RCT_REMAP_METHOD(saveGPSData, saveGPSData:(NSString*)name resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        GPSData* gpsData = [SMCollector getGPSPoint];
        NSString* strDataset = [NSString stringWithFormat:@"Point%@",[self getCurrentTime]];
        NSString*strDescrip = [NSString stringWithFormat:@"Longitude:%.4fLatitude:%.4fAltitude:%.4f",gpsData.dLongitude,gpsData.dLatitude,gpsData.dAltitude];
        
        NSArray *arr = [_arCollection collectCurrentPoint];
        //[self savePointDataX:gpsData.dLongitude y:gpsData.dLatitude z:gpsData.dAltitude toDataset:strDataset];
        
        
        [self savePointDataX:[(NSNumber*)arr[0] floatValue] y:[(NSNumber*)arr[1] floatValue] z:[(NSNumber*)arr[2] floatValue] toDataset:strDataset withStr:strDescrip];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"saveGPSData", exception.reason, nil);
    }
}

/**
* 判断数据集类型
*
* @param promise
*/
#pragma mark ----------------isLineDataset--------RN--------
RCT_REMAP_METHOD(isLineDataset, isLineDataset:(int)index resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Workspace *workspace = [SMap.singletonInstance.smMapWC workspace];
        Datasource *datasource = [workspace.datasources getAlias:mDatasourceAlias];
        Dataset* dataset =  [datasource.datasets get:index];
        
        if (dataset.datasetType == LineZ) {
             resolve(@(YES));
        }else{
             resolve(@(NO));
        }
       
    } @catch (NSException *exception) {
        reject(@"isLineDataset", exception.reason, nil);
    }
}

/**
    * 加载数据到三维场景里
    *
    * @param promise
*/
#pragma mark ----------------loadData--------RN--------
RCT_REMAP_METHOD(loadData, loadData:(int)index isLine:(BOOL)isLine resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BOOL bResult = false;
        if(isLine){
            NSArray* infoList = [self allGeometryFromDatasource:mDatasourceAlias dataset:index];
            if (infoList!=nil && infoList.count>0) {
                SceneFormInfo* info = [infoList objectAtIndex:0];
                NSArray* arr = [info arrPointsData];
                [_arCollection loadPoseData:arr];
                bResult = true;
            }

        }else{
            NSArray* infoList = [self allPointsFromDatasource:mDatasourceAlias dataset:index];
            if (infoList!=nil && infoList.count>0) {
                SceneFormInfo* info = [infoList objectAtIndex:0];
                NSArray* arr = [info arrPointsData];
                [_arCollection loadPoseData:arr];
                bResult = true;
            }
        }
        
         resolve(@(bResult));
        
    } @catch (NSException *exception) {
        reject(@"loadData", exception.reason, nil);
    }
}

/**
* 清空当前数据
*
* @param promise
*/
#pragma mark ----------------clearData--------RN--------
RCT_REMAP_METHOD(clearData, clearData:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [_arCollection clearCurrentRoute];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"clearData", exception.reason, nil);
    }
}

/**
* 清空所有数据
*
* @param promise
*/
#pragma mark ----------------clearAllData--------RN--------
RCT_REMAP_METHOD(clearAllData, clearAllData:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [_arCollection clearPoseData];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"clearAllData", exception.reason, nil);
    }
}

#pragma mark ----------------setArSceneViewVisible--------RN--------
RCT_REMAP_METHOD(setArSceneViewVisible, setArSceneViewVisible:(BOOL)isVisable resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setArSceneViewVisible", exception.reason, nil);
    }
}

#pragma mark ----------------onDestroy--------RN--------
RCT_REMAP_METHOD(onDestroy, onDestroy:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        _isShowTrace = false;
        [_arCollection dispose];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"onDestroy", exception.reason, nil);
    }
}

#pragma mark ----------------initSceneFormView--------RN--------
RCT_REMAP_METHOD(initSceneFormView, initSceneFormView:(NSString*)datasourceAlias dataset:(NSString*) datasetName datasetPoint:(NSString*)datasetPointName language:(NSString*)language path:(NSString*)UDBpath resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        mDatasourceAlias = datasourceAlias;
        GPSData* gpsData = [SMCollector getGPSPoint];
        Point2D *pnt = [[Point2D alloc] initWithX:gpsData.dLongitude Y:gpsData.dLatitude];
        Point2Ds *pnt2ds = [[Point2Ds alloc] init];
        [pnt2ds add:pnt];
        [CoordSysTranslator convert:pnt2ds
                               PrjCoordSys:[[PrjCoordSys alloc] initWithType:PCST_EARTH_LONGITUDE_LATITUDE]
                               PrjCoordSys:[[PrjCoordSys alloc] initWithType:PCST_WORLD_MERCATOR]
                    CoordSysTransParameter:[[CoordSysTransParameter alloc]init]
                       CoordSysTransMethod:MTH_GEOCENTRIC_TRANSLATION];
        Point2D* pntMercator = [pnt2ds getItem:0];
        mFixedMercator = [[Point2D alloc]initWithX:pntMercator.x Y:pntMercator.y];
        mFixedAngle = 0;
        
        [self createDatasource:datasourceAlias path:UDBpath];
        [_arCollection setDelegate:self];
        [_arCollection startCollect];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"initSceneFormView", exception.reason, nil);
    }
}

#pragma mark ----------------getHistoryData--------RN--------
RCT_REMAP_METHOD(getHistoryData, getHistoryData:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Datasource *datasource = [SMap.singletonInstance.smMapWC.workspace.datasources getAlias:mDatasourceAlias];
        Datasets *datasets = datasource.datasets;
        if (datasets.count>0) {
            NSMutableArray *arrResult = [[NSMutableArray alloc]init];
            for (int i = 0; i < datasets.count; i++){
                Dataset *dataset = [datasets get:i];
                
                [arrResult addObject:@{
                    @"name":dataset.name,
                    @"index":@(i),
                    @"select":@(NO),
                    @"type":[NSString stringWithFormat:@"%d",dataset.datasetType]
                } ];
            }
            
            resolve(@{@"history":arrResult});
        }else{
            resolve(@(NO));
        }
        
    } @catch (NSException *exception) {
        reject(@"getHistoryData", exception.reason, nil);
    }
}

#pragma mark ----------------setDataSource--------RN--------
RCT_REMAP_METHOD(setDataSource, setDataSource:(NSString*)datasourceAlias path:(NSString*)UDBpath resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        mDatasourceAlias = datasourceAlias;
        BOOL bExist = NO;
        int count = SMap.singletonInstance.smMapWC.workspace.datasources.count;
        for (int i=0; i<count; i++) {
            if( [[[SMap.singletonInstance.smMapWC.workspace.datasources get:i] alias] isEqualToString:mDatasourceAlias]){
                bExist = true;
            }
        }
        
        if (!bExist) {
            DatasourceConnectionInfo*datasourceconnection = [[DatasourceConnectionInfo alloc]init];
            // 设置文件数据源连接需要的参数
            [datasourceconnection setEngineType:ET_UDB];;
            [datasourceconnection setServer: UDBpath];
            //datasourceconnection.setServer(android.os.Environment.getExternalStorageDirectory().getAbsolutePath() + path);
            [datasourceconnection setAlias:mDatasourceAlias];
            Datasource* datasource = [SMap.singletonInstance.smMapWC.workspace.datasources open:datasourceconnection];
        }
        
        [self createDatasource:datasourceAlias path:UDBpath];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"initSceneFormView", exception.reason, nil);
    }
}

/**
    * 切换观看模式
    *
    * @param promise
*/
#pragma mark ----------------switchViewMode--------RN--------
RCT_REMAP_METHOD(switchViewMode, switchViewMode:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {



//       ViewMode viewMode = mRenderer.getViewMode();
//        if (viewMode == ViewMode.FIRST_PERSON) {
//            mRenderer.setViewMode(ViewMode.THIRD_PERSON);
//        } else {
//            mRenderer.setViewMode(ViewMode.FIRST_PERSON);
//        }
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"switchViewMode", exception.reason, nil);
    }
//     @try {
//
//            float x = 0;
//            float y = 0;
//            float z = 0;
//            float w = 0;
//
//            [_arCollection currentPosX:&x y:&y z:&z angle:&w];
//            mFixedAngle = -w; // 坐标系偏移w
//
//            Point2Ds *pnt2ds = [[Point2Ds alloc]init];
//
//            GPSData* gpsData = [SMCollector getGPSPoint];
//            //Point2D *pnt = [[Point2D alloc] initWithX:gpsData.dLongitude Y:gpsData.dLatitude];
//         Point2D *pnt = [[Point2D alloc] initWithX:0 Y:0];
//            [pnt2ds add:pnt];
////            mFixedGPS = CGPointMake(gpsData.dLongitude, gpsData.dLatitude);
//            mFixedAltitude = gpsData.dAltitude - z;
//
//            [CoordSysTranslator convert:pnt2ds
//                            PrjCoordSys:[[PrjCoordSys alloc] initWithType:PCST_EARTH_LONGITUDE_LATITUDE]
//                            PrjCoordSys:[[PrjCoordSys alloc] initWithType:PCST_WORLD_MERCATOR]
//                 CoordSysTransParameter:[[CoordSysTransParameter alloc]init]
//                    CoordSysTransMethod:MTH_GEOCENTRIC_TRANSLATION];
//            //经纬度转墨卡托
//    //        [CoordSysTranslator convert:pnd2ds
//    //                        PrjCoordSys: [[PrjCoordSys alloc] initWithType:PCST_EARTH_LONGITUDE_LATITUDE]
//    //                        PrjCoordSys: [[PrjCoordSys alloc] initWithType:PCST_WORLD_MERCATOR]
//    //                        CoordSysTransParameter:[[CoordSysTransParameter alloc]init]
//    //                        CoordSysTransMethod: MTH_GEOCENTRIC_TRANSLATION];
//
//            //[CoordSysTranslator forward:pnt2ds PrjCoordSys:[[PrjCoordSys alloc] initWithType:PCST_WORLD_MERCATOR]];
//            Point2D* pntMercator = [pnt2ds getItem:0];
//
//
//            float cosa = cosf(mFixedAngle);
//            float sina = sinf(mFixedAngle);
//            //ARtoMercator
//            float offX = (x*cosa + y*sina) ;
//            float offY = (y*cosa - x*sina) ;
//            mFixedMercator.x = pntMercator.x-offX;
//            mFixedMercator.y = pntMercator.y-offY;
//
//
//            resolve(@(YES));
//        } @catch (NSException *exception) {
//            reject(@"fixedPosition", exception.reason, nil);
//        }
}

/**
    * 高清采集位置校准
    *
    * @param promise
*/
#pragma mark ----------------fixedPosition--------RN--------
RCT_REMAP_METHOD(fixedPosition, fixedPosition:(BOOL)bGPSAuto longitude:(float)dLongitude latitude:(float)dLatitude   altitude:(float)dAltitude resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        float x = 0;
        float y = 0;
        float z = 0;
        float w = 0;
        
        [_arCollection currentPosX:&x y:&y z:&z angle:&w];
        mFixedAngle = -w; // 坐标系偏移w
        
        Point2Ds *pnt2ds = [[Point2Ds alloc]init];
        if (bGPSAuto) {
            GPSData* gpsData = [SMCollector getGPSPoint];
            Point2D *pnt = [[Point2D alloc] initWithX:gpsData.dLongitude Y:gpsData.dLatitude];
            [pnt2ds add:pnt];
//            mFixedGPS = CGPointMake(gpsData.dLongitude, gpsData.dLatitude);
            mFixedAltitude = gpsData.dAltitude - z;
        }else{
            Point2D *pnt = [[Point2D alloc] initWithX:dLongitude Y:dLatitude];
            [pnt2ds add:pnt];
//            mFixedGPS = CGPointMake(dLongitude, dLatitude);
            mFixedAltitude = dAltitude - z;
        }

        [CoordSysTranslator convert:pnt2ds
                        PrjCoordSys:[[PrjCoordSys alloc] initWithType:PCST_EARTH_LONGITUDE_LATITUDE]
                        PrjCoordSys:[[PrjCoordSys alloc] initWithType:PCST_WORLD_MERCATOR]
             CoordSysTransParameter:[[CoordSysTransParameter alloc]init]
                CoordSysTransMethod:MTH_GEOCENTRIC_TRANSLATION];
        //经纬度转墨卡托
//        [CoordSysTranslator convert:pnd2ds
//                        PrjCoordSys: [[PrjCoordSys alloc] initWithType:PCST_EARTH_LONGITUDE_LATITUDE]
//                        PrjCoordSys: [[PrjCoordSys alloc] initWithType:PCST_WORLD_MERCATOR]
//                        CoordSysTransParameter:[[CoordSysTransParameter alloc]init]
//                        CoordSysTransMethod: MTH_GEOCENTRIC_TRANSLATION];
        
        //[CoordSysTranslator forward:pnt2ds PrjCoordSys:[[PrjCoordSys alloc] initWithType:PCST_WORLD_MERCATOR]];
        Point2D* pntMercator = [pnt2ds getItem:0];
    
    
        float cosa = cosf(mFixedAngle);
        float sina = sinf(mFixedAngle);
        //ARtoMercator
        float offX = (x*cosa + y*sina) ;
        float offY = (y*cosa - x*sina) ;
        mFixedMercator.x = pntMercator.x-offX;
        mFixedMercator.y = pntMercator.y-offY;

        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"fixedPosition", exception.reason, nil);
    }
}


@end

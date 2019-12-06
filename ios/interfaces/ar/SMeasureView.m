//
//  SMeasureView.m
//  Supermap
//
//  Created by zhouyuming on 2019/12/3.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import "SMeasureView.h"
#import <ARKit/ARKit.h>
#import "SuperMap/LocationManagePlugin.h"
#import "SMCollector.h"
#import "LocationTransfer.h"
static SMeasureView *sMeasureView = nil;
static ARMeasureView* mARMeasureView = nil;

NSString *const onCurrentLengthChanged  = @"onCurrentLengthChanged";
NSString *const onTotalLengthChanged  = @"onTotalLengthChanged";
NSString *const onCurrentToLastPntDstChanged  = @"onCurrentToLastPntDstChanged";
NSString *const onSearchingSurfaces  = @"onSearchingSurfaces";
NSString *const onSearchingSurfacesSucceed  = @"onSearchingSurfacesSucceed";

@implementation SMeasureView
{
    NSString* mDatasourceAlias;
    NSString* mDatasetName;
    Point2D* fixedPt;
}

RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents {
    return @[
             onCurrentLengthChanged,
             onTotalLengthChanged,
             onCurrentToLastPntDstChanged,
             onSearchingSurfaces,
             onSearchingSurfacesSucceed,
             ];
}

+(void)setInstance:(ARMeasureView*)aRMeasureView{
    mARMeasureView=aRMeasureView;
    
}
-(void)setDelegate{
//    mARMeasureView.arRangingDelegate=self;
}

#pragma mark 检查是否支持ARCore
RCT_REMAP_METHOD(isSupportedARCore, isSupportedARCore:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        resolve(@(ARWorldTrackingConfiguration.isSupported));
    } @catch (NSException *exception) {
        resolve(@(NO));
//        reject(@"isSupportedARCore", exception.reason, nil);
    }
}

#pragma mark 新增记录
RCT_REMAP_METHOD(addNewRecord, addNewRecord:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if(mARMeasureView){
            [mARMeasureView captureRangingNode];
        }
        
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"addNewRecord", exception.reason, nil);
    }
}

#pragma mark 撤销上一记录
RCT_REMAP_METHOD(undoDraw, undoDraw:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if(mARMeasureView){
            [mARMeasureView undo];
        }
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"undoDraw", exception.reason, nil);
    }
}

#pragma mark 清除所有
RCT_REMAP_METHOD(clearAll, clearAll:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if(mARMeasureView){
            [mARMeasureView clearARSession];
        }
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"clearAll", exception.reason, nil);
    }
}

#pragma mark 设置模型类型
RCT_REMAP_METHOD(setFlagType, setFlagType:(NSString*)type resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if(mARMeasureView){
            if([type isEqualToString:@"PIN_BOWLING"]){
                [mARMeasureView setFlagType:AR_PIN_BOWLING];
            }else if([type isEqualToString:@"RED_FLAG"]){
                [mARMeasureView setFlagType:AR_RED_FLAG];
            }
        }
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setFlagType", exception.reason, nil);
    }
}

#pragma mark 初始化
RCT_REMAP_METHOD(initMeasureCollector, initMeasureCollector:(NSString*)datasourceAlias datasetName:(NSString*)datasetName resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        mDatasourceAlias = datasourceAlias;
        mDatasetName = datasetName;
        
        [self createDataset:datasourceAlias datasetName:datasetName];
        
        if(![SMLayer findLayerByDatasetName:datasetName]){
            Layer* layer=[SMLayer addLayerByName:datasourceAlias datasetName:datasetName];
            if(layer){
                [layer setSelectable:YES];
            }
        }
        if(mARMeasureView){
            //使用ios原生的label显示测量结果
//            mARMeasureView.arRangingDelegate=self;
        }
        
        //初始化的时候获取当前定位坐标
        MapControl* mapControl=[SMap singletonInstance].smMapWC.mapControl;
        GPSData* gpsData = [NativeUtil getGPSData];
        fixedPt = [[Point2D alloc]initWithX:gpsData.dLongitude Y:gpsData.dLatitude];
        if ([mapControl.map.prjCoordSys type] != PCST_EARTH_LONGITUDE_LATITUDE) {//若投影坐标不是经纬度坐标则进行转换
            Point2Ds *points = [[Point2Ds alloc]init];
            [points add:fixedPt];
            PrjCoordSys *srcPrjCoorSys = [[PrjCoordSys alloc]init];
            [srcPrjCoorSys setType:PCST_EARTH_LONGITUDE_LATITUDE];
            CoordSysTransParameter *param = [[CoordSysTransParameter alloc]init];
            
            //根据源投影坐标系与目标投影坐标系对坐标点串进行投影转换，结果将直接改变源坐标点串
            [CoordSysTranslator convert:points PrjCoordSys:srcPrjCoorSys PrjCoordSys:[mapControl.map prjCoordSys] CoordSysTransParameter:param CoordSysTransMethod:(CoordSysTransMethod)9603];
            fixedPt = [points getItem:0];
        }
        
        
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"initMeasureCollector", exception.reason, nil);
    }
}

#pragma mark 保存数据
RCT_REMAP_METHOD(saveDataset, saveDataset:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if(!mARMeasureView){
            resolve(@(YES));
            return;
        }
        DatasetVector* datasetVector=nil;
        MapControl* mapControl=[SMap singletonInstance].smMapWC.mapControl;
        Workspace* workspace=mapControl.map.workspace;
        Datasource* datasource=[workspace.datasources getAlias:mDatasourceAlias];
        datasetVector=(DatasetVector*)[datasource.datasets getWithName:mDatasetName];
        
        //风格
        GeoStyle* geoStyle = [[GeoStyle alloc] init];
        
        NSArray* arr=[mARMeasureView endRanging];
        dispatch_async(dispatch_get_main_queue(), ^{
//        GPSData* gpsData = [NativeUtil getGPSData];
//        Point2D* pt = [[Point2D alloc]initWithX:gpsData.dLongitude Y:gpsData.dLatitude];
//        if ([mapControl.map.prjCoordSys type] != PCST_EARTH_LONGITUDE_LATITUDE) {//若投影坐标不是经纬度坐标则进行转换
//            Point2Ds *points = [[Point2Ds alloc]init];
//            [points add:pt];
//            PrjCoordSys *srcPrjCoorSys = [[PrjCoordSys alloc]init];
//            [srcPrjCoorSys setType:PCST_EARTH_LONGITUDE_LATITUDE];
//            CoordSysTransParameter *param = [[CoordSysTransParameter alloc]init];
//
//            //根据源投影坐标系与目标投影坐标系对坐标点串进行投影转换，结果将直接改变源坐标点串
//            [CoordSysTranslator convert:points PrjCoordSys:srcPrjCoorSys PrjCoordSys:[mapControl.map prjCoordSys] CoordSysTransParameter:param CoordSysTransMethod:(CoordSysTransMethod)9603];
//            pt = [points getItem:0];
//        }
        
        Point2Ds* fixedTotalPoints=[[Point2Ds alloc] init];
        for(int i=0;i<arr.count;i++){
            
            NSArray* arrPoint=[arr objectAtIndex:i];
            double x=[arrPoint[0] doubleValue]+fixedPt.x;
            double y=[arrPoint[1] doubleValue]+fixedPt.y;
            [fixedTotalPoints add:[[Point2D alloc] initWithX:x Y:y]];
        }
        
        Recordset *recordset = [datasetVector recordset:NO cursorType:DYNAMIC];
        if(!recordset){
            resolve(@(YES));
            return;
        }
        
        //移动指针到最后
        [recordset moveLast];
        [recordset edit];
        
        GeoRegion* geoRegion=[[GeoRegion alloc] init];
        [geoRegion addPart:fixedTotalPoints];
        [geoStyle setLineColor:[[Color alloc] initWithR:255 G:0 B:0]];
        [geoStyle setLineWidth:1];
        [geoStyle setFillForeColor:[[Color alloc] initWithR:255 G:160 B:122]];
        [geoStyle setFillBackColor:[[Color alloc] initWithR:255 G:160 B:122]];
        [geoStyle setFillOpaqueRate:30];    //加透明度更美观
        [geoRegion setStyle:geoStyle];
        //移动指针到下一位
        [recordset moveNext];
        //新增面对象
        [recordset addNew:geoRegion];
        
        FieldInfos* fieldInfos=recordset.fieldInfos;
        if([fieldInfos indexOfWithFieldName:@"ModifiedDate"]!=-1){
            NSObject* ob=[recordset getFieldValueWithString:@"ModifiedDate"];
            if(ob){
                NSString* str=[ob description];
                if(![[self getCurrentTime] isEqualToString:str]){
                    [recordset setFieldValueWithString:@"ModifiedDate" Obj:[self getCurrentTime]];
                }
            }
        }
        
            //android有以下代码
//        for(int i=0;i<[fixedTotalPoints getCount];i++){
//            //移动指针到下一位
//            [recordset moveNext];
//
//            NSArray* arrPoint=[arr objectAtIndex:i];
//            double x=[arrPoint[0] doubleValue]+pt.x;
//            double y=[arrPoint[1] doubleValue]+pt.y;
//
//            GeoPoint* geoPoint=[[GeoPoint alloc] initWithX:x Y:y];
//            [geoStyle setMarkerSize:[[Size2D alloc] initWithWidth:1 Height:1]];
//            [geoStyle setLineColor:[[Color alloc] initWithR:255 G:0 B:0]];
//            [geoPoint setStyle:geoStyle];
//            //新增点对象
//            [recordset addNew:geoPoint];
//
//            //修改属性
//            double dlocation=0;
//            NSString* str=nil;
//            NSObject* ob=nil;
//
//            if([fieldInfos indexOfWithFieldName:@"ModifiedDate"]!=-1){
//                ob=[recordset getFieldValueWithString:@"ModifiedDate"];
//                if(ob){
//                    NSString* str=[ob description];
//                    if(![[self getCurrentTime] isEqualToString:str]){
//                        [recordset setFieldValueWithString:@"ModifiedDate" Obj:[self getCurrentTime]];
//                    }
//                }
//            }
//        }
        
        //保存更新，并释放资源
        [recordset update];
        [recordset close];
        [recordset dispose];
        
        resolve(@(YES));
        });
    } @catch (NSException *exception) {
        reject(@"initMeasureCollector", exception.reason, nil);
    }
}

/////////////////////////////TODO//////////////////////////////////
#pragma mark 设置中心辅助
RCT_REMAP_METHOD(setEnableSupport, setEnableSupport:(BOOL)value rejecter:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if(mARMeasureView){
//            [mARMeasureView enableSupport:value];
        }
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setEnableSupport", exception.reason, nil);
    }
}

-(NSString*)getCurrentTime{
    // 获取当前时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 得到当前时间（世界标准时间 UTC/GMT）
    NSDate *nowDate = [NSDate date];
    // 设置系统时区为本地时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    // 计算本地时区与 GMT 时区的时间差
    NSInteger interval = [zone secondsFromGMT];
    // 在 GMT 时间基础上追加时间差值，得到本地时间
    nowDate = [nowDate dateByAddingTimeInterval:interval];
    
    NSString *nowDateString = [dateFormatter stringFromDate:nowDate];
    
    return nowDateString;
}
                       

//总长度
-(void)onTotalLengthOfSidesChange:(double)dLen{
        NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
        [params setObject:@(dLen) forKey:@"total"];
        [self sendEventWithName:onCurrentToLastPntDstChanged body:params];
}
//视点距离
-(void)onViewPointDistanceToSurfaceChange:(double)dLen{
        NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
        [params setObject:@(dLen) forKey:@"tolast"];
        [self sendEventWithName:onCurrentLengthChanged body:params];
}
//当前线段长度
-(void)onCurrentToLastPointDistanceChange:(double)dLen{
        NSMutableDictionary* params=[[NSMutableDictionary alloc] init];
        [params setObject:@(dLen) forKey:@"current"];
        [self sendEventWithName:onTotalLengthChanged body:params];
}
//状态变化
-(void)onARRuntimeStatusChange:(ARRuntimeStatus)status{
        switch (status) {
            case AR_SEARCHING_SURFACES:
                [self sendEventWithName:onSearchingSurfaces body:@(1)];
                break;
            case AR_SEARCHING_SURFACES_SUCCEED:
                [self sendEventWithName:onSearchingSurfacesSucceed body:@(1)];
                break;

            default:
                break;
        }
}

-(void)createDataset:(NSString*)UDBName datasetName:(NSString*)datasetName{
    MapControl* mapControl=[SMap singletonInstance].smMapWC.mapControl;
    Workspace* workspace=mapControl.map.workspace;
    Datasource* datasource=[workspace.datasources getAlias:UDBName];
    
    Datasets* datasets=datasource.datasets;
    if([datasets contain:datasetName]){
        [self checkPOIFieldInfos:(DatasetVector*)[datasets getWithName:datasetName]];
        return;
    }
    
    DatasetVectorInfo* datasetVectorInfo=[[DatasetVectorInfo alloc] init];
    datasetVectorInfo.datasetType=CAD;
    datasetVectorInfo.encodeType=NONE;
    datasetVectorInfo.name=datasetName;
    DatasetVector* datasetVector=[datasets create:datasetVectorInfo];
    
    //创建数据集时创建好字段
    [self addFieldInfo:datasetVector name:@"MediaFilePaths" type:FT_TEXT required:NO value:@"" maxLength:800];
    [self addFieldInfo:datasetVector name:@"HttpAddress" type:FT_TEXT required:NO value:@"" maxLength:255];
    [self addFieldInfo:datasetVector name:@"Description" type:FT_TEXT required:NO value:@"" maxLength:255];
    [self addFieldInfo:datasetVector name:@"ModifiedDate" type:FT_TEXT required:NO value:@"" maxLength:255];
    [self addFieldInfo:datasetVector name:@"MediaName" type:FT_TEXT required:NO value:@"" maxLength:255];
    
    [self addFieldInfo:datasetVector name:@"OriginalX" type:FT_DOUBLE required:NO value:@"" maxLength:25];
    [self addFieldInfo:datasetVector name:@"OriginalY" type:FT_DOUBLE required:NO value:@"" maxLength:25];
    
    [datasetVector setPrjCoordSys:[[PrjCoordSys alloc] initWithType:PCST_EARTH_LONGITUDE_LATITUDE]];
    
    [datasetVectorInfo dispose];
    [datasetVector close];
}

-(void)checkPOIFieldInfos:(DatasetVector*)datasetVector{
    FieldInfos* fieldInfors=datasetVector.fieldInfos;
    
    if([fieldInfors indexOfWithFieldName:@"MediaFilePaths"] == -1){
        [self addFieldInfo:datasetVector name:@"MediaFilePaths" type:FT_TEXT required:NO value:@"" maxLength:800];
    }
    if([fieldInfors indexOfWithFieldName:@"HttpAddress"] == -1){
        [self addFieldInfo:datasetVector name:@"HttpAddress" type:FT_TEXT required:NO value:@"" maxLength:255];
    }
    if([fieldInfors indexOfWithFieldName:@"Description"] == -1){
        [self addFieldInfo:datasetVector name:@"Description" type:FT_TEXT required:NO value:@"" maxLength:255];
    }
    if([fieldInfors indexOfWithFieldName:@"ModifiedDate"] == -1){
        [self addFieldInfo:datasetVector name:@"ModifiedDate" type:FT_TEXT required:NO value:@"" maxLength:255];
    }
    if([fieldInfors indexOfWithFieldName:@"MediaName"] == -1){
        [self addFieldInfo:datasetVector name:@"MediaName" type:FT_TEXT required:NO value:@"" maxLength:255];
    }
    if([fieldInfors indexOfWithFieldName:@"OriginalX"] == -1){
        [self addFieldInfo:datasetVector name:@"OriginalX" type:FT_DOUBLE required:NO value:@"" maxLength:25];
    }
    if([fieldInfors indexOfWithFieldName:@"OriginalY"] == -1){
        [self addFieldInfo:datasetVector name:@"OriginalY" type:FT_DOUBLE required:NO value:@"" maxLength:25];
    }
}


//添加指定字段到数据集
-(void)addFieldInfo:(DatasetVector*)dv name:(NSString*)name type:(FieldType)type required:(BOOL)required value:(NSString*)value maxLength:(int)maxlength{
    FieldInfos* infos=dv.fieldInfos;
    //判断字段是否存在
    if([infos indexOfWithFieldName:name]!=-1){
        [infos removeFieldName:name];
    }
    FieldInfo* newInfo=[[FieldInfo alloc] init];
    newInfo.name=name;
    newInfo.fieldType=type;
    newInfo.maxLength=maxlength;
    newInfo.defaultValue=value;
    newInfo.required=required;
    [infos add:newInfo];
    
}



@end

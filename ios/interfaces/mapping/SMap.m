//
//  SMap.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/26.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "SMap.h"

static SMap *sMap = nil;
//static NSInteger *fillNum;
static NSMutableArray *fillColors;
NSString * const LEGEND_CONTENT_CHANGE = @"com.supermap.RN.Map.Legend.legend_content_change";
/*
 * 用于对象添加监听回调，完成后销毁
 */
DatasetVector *dataset;
GeoStyle *geoStyle;
MapControl *mapControl;
@interface SMap()
{
   
}
@end

static  Point2D* defaultMapCenter;
static int curLocationTag = 118081;
@implementation SMap
-(ScaleViewHelper*)scaleViewHelper{
    if(_scaleViewHelper==nil){
         _scaleViewHelper = [[ScaleViewHelper alloc]initWithMapControl:sMap.smMapWC.mapControl];
    }
    return _scaleViewHelper;
}
RCT_EXPORT_MODULE();
- (NSArray<NSString *> *)supportedEvents
{
    return @[
             MEASURE_LENGTH,
             MEASURE_AREA,
             MEASURE_ANGLE,
             COLLECTION_SENSOR_CHANGE,
             MAP_LONG_PRESS,
             MAP_SINGLE_TAP,
             MAP_DOUBLE_TAP,
             MAP_TOUCH_BEGAN,
             MAP_TOUCH_END,
             MAP_SCROLL,
             MAP_GEOMETRY_MULTI_SELECTED,
             MAP_GEOMETRY_SELECTED,
             MAP_SCALE_CHANGED,
             MAP_BOUNDS_CHANGED,
             LEGEND_CONTENT_CHANGE,
             MAP_SCALEVIEW_CHANGED,
             ];
}

+ (instancetype)singletonInstance{
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sMap = [[self alloc] init];
    });
    
    if (sMap.smMapWC == nil) {
        sMap.smMapWC = [[SMMapWC alloc] init];
    }
    
    if (sMap.smMapWC.workspace == nil) {
        sMap.smMapWC.workspace = [[Workspace alloc] init];
    }
    
    return sMap;
}

+ (void)setInstance:(MapControl*) mapControl {
    sMap = [self singletonInstance];
    if (sMap.smMapWC == nil) {
        sMap.smMapWC = [[SMMapWC alloc] init];
    }
    sMap.smMapWC.mapControl = mapControl;
    if (sMap.smMapWC.workspace && sMap.smMapWC.mapControl.map.workspace == nil) {
        [sMap.smMapWC.mapControl.map setWorkspace:sMap.smMapWC.workspace];
    }
}

- (void)setDelegate {
    sMap.smMapWC.mapControl.mapMeasureDelegate = self;
    sMap.smMapWC.mapControl.delegate = self;
    sMap.smMapWC.mapControl.geometrySelectedDelegate = self;
}

#pragma mark getEnvironmentStatus 获取许可文件状态
RCT_REMAP_METHOD(getEnvironmentStatus, getEnvironmentStatusWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        LicenseStatus* status = [Environment getLicenseStatus];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        
        [dic setObject:[NSNumber numberWithBool:status.isActivated] forKey:@"isActivated"];
        [dic setObject:[NSNumber numberWithBool:status.isLicenseValid] forKey:@"isLicenseValid"];
        [dic setObject:[NSNumber numberWithBool:status.isLicenseExsit] forKey:@"isLicenseExist"];
        [dic setObject:[NSNumber numberWithBool:status.isTrailLicense] forKey:@"isTrailLicense"];
        [dic setObject:status.startDate forKey:@"startDate"];
        [dic setObject:status.expireDate forKey:@"expireDate"];
        [dic setObject:[NSString stringWithFormat:@"%ld", status.version] forKey:@"version"];
        
        resolve(dic);
    } @catch (NSException *exception) {
        reject(@"unZipFile", exception.reason, nil);
    }
}

#pragma mark 添加marker
+(void)showMarkerHelper:(Point2D*)pt tag:(int)tag{
   
    dispatch_async(dispatch_get_main_queue(), ^{
//        Callout* callout = [[Callout alloc]initWithMapControl:sMap.smMapWC.mapControl];
//        callout.tag = tag;
//        callout.width = 25;
//        callout.height = 25;
//        UIImageView* image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SuperMap.bundle/Contents/Resources/Resource/destination.png"]];
//        image.frame = CGRectMake(0, 0, 25, 25);
//        // UIImage* img = ;
//        [callout addSubview:image];
//        [callout showAt:pt];
        
        GeoPoint* point = [[GeoPoint alloc] initWithPoint2D:pt];//new GeoPoint(mapPt.getX(),mapPt.getY());
        GeoStyle* style = [[GeoStyle alloc]init];
        [style setMarkerSymbolID:118081];
        [style setMarkerSize: [[Size2D alloc]initWithWidth:8 Height:8]];// setMarkerSize(new Size2D(6,6));
//        style.setLineColor(new Color(255,0,0,255));
        [point setStyle:style];//setStyle(style);
        [sMap.smMapWC.mapControl.map.trackingLayer addGeometry:point WithTag:[NSString stringWithFormat:@"%d",tag]];
//        sMap.smMapWC.getMapControl().getMap().getTrackingLayer().add(point,tagStr);
        //[sMap.smMapWC.mapControl panTo:pt time:200];
        sMap.smMapWC.mapControl.map.center = pt;
        if(sMap.smMapWC.mapControl.map.scale < 0.000011947150294723098)
            sMap.smMapWC.mapControl.map.scale = 0.000011947150294723098;
        [sMap.smMapWC.mapControl.map refresh];
    });
}
RCT_REMAP_METHOD(showMarker,  longitude:(double)longitude latitude:(double)latitude tag:(int)tag showMarkerResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Point2D* pt = [[Point2D alloc] initWithX:longitude Y:latitude];
        Point2Ds *points = [[Point2Ds alloc]init];
        if ([sMap.smMapWC.mapControl.map.prjCoordSys type] != PCST_EARTH_LONGITUDE_LATITUDE) {//若投影坐标不是经纬度坐标则进行转换
            Point2Ds *points = [[Point2Ds alloc]init];
            [points add:pt];
            PrjCoordSys *srcPrjCoorSys = [[PrjCoordSys alloc]init];
            [srcPrjCoorSys setType:PCST_EARTH_LONGITUDE_LATITUDE];
            CoordSysTransParameter *param = [[CoordSysTransParameter alloc]init];
            
            //根据源投影坐标系与目标投影坐标系对坐标点串进行投影转换，结果将直接改变源坐标点串
            [CoordSysTranslator convert:points PrjCoordSys:srcPrjCoorSys PrjCoordSys:[sMap.smMapWC.mapControl.map prjCoordSys] CoordSysTransParameter:param CoordSysTransMethod:(CoordSysTransMethod)9603];
            pt = [points getItem:0];
        }
        [SMap showMarkerHelper:pt tag:tag];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"SMap", exception.reason, nil);
    }
}

+(void)deleteMarker:(int)tag{
    int n = [sMap.smMapWC.mapControl.map.trackingLayer indexof:[NSString stringWithFormat:@"%d",tag]];
    if(n!=-1){
        [sMap.smMapWC.mapControl.map.trackingLayer removeAt:n];
        [sMap.smMapWC.mapControl.map refresh];
    }
//    [sMap.smMapWC.mapControl removeCalloutWithTag:tag];
}
#pragma mark 移除marker
RCT_REMAP_METHOD(deleteMarker, tag:(int)tag deleteMarkerResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [SMap deleteMarker:tag];
//        [sMap.smMapWC.mapControl removeCalloutWithTag:tag];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"SMap", exception.reason, nil);
    }
}

#pragma mark 打开工作空间
RCT_REMAP_METHOD(openWorkspace, openWorkspaceByInfo:(NSDictionary*)infoDic resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        BOOL result = [sMap.smMapWC openWorkspace:infoDic];
        if (result && sMap.smMapWC.mapControl) {
            [sMap.smMapWC.mapControl.map setWorkspace:sMap.smMapWC.workspace];
            if(sMap.smMapWC.mapControl.map.delegate == nil){
                sMap.smMapWC.mapControl.map.delegate = self;
            }
//            if(sMap.scaleViewHelper == nil){
//
//
//            }
        }
        sMap.smMapWC.mapControl.map.isVisibleScalesEnabled = NO;
        sMap.smMapWC.mapControl.isMagnifierEnabled = YES;
        sMap.smMapWC.mapControl.map.isAntialias = YES;
        [sMap.smMapWC.mapControl.map refresh];
        [self openGPS];
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}
#pragma mark ---------------------地图设置菜单开始---------------------

#pragma mark 获取地图名称
RCT_REMAP_METHOD(getMapName, getMapNameWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        NSString *mapName = sMap.smMapWC.mapControl.map.name;
        resolve(mapName);
    } @catch (NSException *exception) {
        reject(@"getMapName",exception.reason,nil);
    }
}

#pragma mark 获取地图旋转角度
RCT_REMAP_METHOD(getMapAngle, getMapAngleWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        NSString *angleStr = [[NSString stringWithFormat:@"%.1f",sMap.smMapWC.mapControl.map.angle] stringByAppendingString:@"°"];
        resolve(angleStr);
    } @catch (NSException *exception) {
        reject(@"getMapAngle",exception.reason,nil);
    }
}

#pragma mark 设置地图旋转角度
RCT_REMAP_METHOD(setMapAngle, setMapAngleWithValue:(double)angle Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Map *map = sMap.smMapWC.mapControl.map;
        map.angle = angle;
        [map refresh];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setMapAngle",exception.reason,nil);
    }
}

#pragma mark 获取地图颜色模式
RCT_REMAP_METHOD(getMapColorMode, getMapColorModeWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        int modeIndex = sMap.smMapWC.mapControl.map.mapColorMode;
        NSArray *colorMode= @[@"默认色彩模式",@"黑白模式",@"灰度模式",@"黑白反色模式",@"黑白反色，其他颜色不变"];
        resolve(colorMode[modeIndex]);
    } @catch (NSException *exception) {
        reject(@"getMapColorMode",exception.reason,nil);
    }
}
#pragma mark 设置地图颜色模式
RCT_REMAP_METHOD(setMapColorMode, setMapColorModeWithValue:(int)value Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        dispatch_async(dispatch_get_main_queue(), ^{
            sMap = [SMap singletonInstance];
            sMap.smMapWC.mapControl.map.mapColorMode = value;
            [sMap.smMapWC.mapControl.map refresh];
        });
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setMapColorMode",exception.reason,nil);
    }
}

#pragma mark 获取地图背景颜色
RCT_REMAP_METHOD(getMapBackgroundColor, getMapBackgroundColorWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        GeoStyle *backgroundStyle = sMap.smMapWC.mapControl.map.backgroundStyle;
        Color * color = [backgroundStyle getFillForeColor];
        NSString *R = [[NSString alloc]initWithFormat:@"%02x",color.red];
        NSString *G = [[NSString alloc]initWithFormat:@"%02x",color.green];
        NSString *B = [[NSString alloc]initWithFormat:@"%02x",color.blue];
        NSString *returnColor = [NSString stringWithFormat:@"%@%@%@%@",@"#",R,G,B];
        resolve(returnColor);
    } @catch (NSException *exception) {
        reject(@"getMapColorMode",exception.reason,nil);
    }
}
#pragma mark 设置地图背景颜色
RCT_REMAP_METHOD(setMapBackgroundColor, setMapBackgroundColorWithR:(int)r G:(int)g B:(int)b Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        dispatch_async(dispatch_get_main_queue(), ^{
            sMap = [SMap singletonInstance];
            GeoStyle *backgroundStyle = sMap.smMapWC.mapControl.map.backgroundStyle;
            Color *color = [[Color alloc] initWithR:r G:g B:b];
            [backgroundStyle setFillForeColor:color];
            [sMap.smMapWC.mapControl.map refresh];
        });
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"getMapColorMode",exception.reason,nil);
    }
}

#pragma mark 设置是否固定文本角度
RCT_REMAP_METHOD(setTextFixedAngle, setTextFixedAngleWithValue: (BOOL)value Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        sMap.smMapWC.mapControl.map.isTextFixedAngle = value;
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setTextFixedAngle",exception.reason,nil);
    }
}

#pragma mark 获取是否固定文本角度
RCT_REMAP_METHOD(getTextFixedAngle, getTextFixedAngleWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        BOOL b = sMap.smMapWC.mapControl.map.isTextFixedAngle;
        resolve(@(b));
    } @catch (NSException *exception) {
        reject(@"getTextFixedAngle",exception.reason,nil);
    }
}

#pragma mark 设置是否固定符号角度
RCT_REMAP_METHOD(setMarkerFixedAngle, setMarkerFixedAngleWithValue: (BOOL)value Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        sMap.smMapWC.mapControl.map.isMarkerFixedAngle = value;
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setTextFixedAngle",exception.reason,nil);
    }
}

#pragma mark 获取是否固定符号角度
RCT_REMAP_METHOD(getMarkerFixedAngle, getMarkerFixedAngleWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        BOOL b = sMap.smMapWC.mapControl.map.isMarkerFixedAngle;
        resolve(@(b));
    } @catch (NSException *exception) {
        reject(@"getMarkerFixedAngle",exception.reason,nil);
    }
}

#pragma mark 设置是否固定文本方向
RCT_REMAP_METHOD(setFixedTextOrientation, setFixedTextOrientationWithValue: (BOOL)value Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        sMap.smMapWC.mapControl.map.isFixedTextOrientation = value;
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setFixedTextOrientation",exception.reason,nil);
    }
}
#pragma mark 获取是否固定文本方向
RCT_REMAP_METHOD(getFixedTextOrientation, getFixedTextOrientationWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        BOOL b = sMap.smMapWC.mapControl.map.isFixedTextOrientation;
        resolve(@(b));
    } @catch (NSException *exception) {
        reject(@"getMarkerFixedAngle",exception.reason,nil);
    }
}

#pragma mark 获取地图中心点
RCT_REMAP_METHOD(getMapCenter, getMapCenterWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Point2D *center = sMap.smMapWC.mapControl.map.center;
        NSString *centerX = [NSString stringWithFormat:@"%f",center.x];
        NSString *centerY = [NSString stringWithFormat:@"%f",center.y];
        resolve(@{@"x":centerX,@"y":centerY});
    } @catch (NSException *exception) {
        reject(@"getMapCenter",exception.reason,nil);
    }
}

#pragma mark 设置地图中心点
RCT_REMAP_METHOD(setMapCenter, setMapCenterWithX:(double)x Y:(double)y Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Point2D *point = [[Point2D alloc] initWithX:x Y:y];
        sMap.smMapWC.mapControl.map.center = point;
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setMapCenter",exception.reason,nil);
    }
}

#pragma mark 获取地图比例尺
RCT_REMAP_METHOD(getMapScale, getMapScaleWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        double mapScale = sMap.smMapWC.mapControl.map.scale;
        NSString *scaleStr =[NSString stringWithFormat:@"%.6f",1/mapScale];
        resolve(scaleStr);
    } @catch (NSException *exception) {
        reject(@"getMapScale",exception.reason,nil);
    }
}

#pragma mark 设置地图比例尺
RCT_REMAP_METHOD(setMapScale, setMapScaleWithValue:(double)value Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        sMap.smMapWC.mapControl.map.scale = value;
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setMapScale",exception.reason,nil);
    }
}
#pragma mark 获取四至范围 viewBounds
RCT_REMAP_METHOD(getMapViewBounds, getMapViewBoundsWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Rectangle2D *rect = sMap.smMapWC.mapControl.map.viewBounds;
        NSString *left = [NSString stringWithFormat:@"%.6f",rect.left];
        NSString *bottom = [NSString stringWithFormat:@"%.6f",rect.bottom];
        NSString *right = [NSString stringWithFormat:@"%.6f",rect.right];
        NSString *top = [NSString stringWithFormat:@"%.6f",rect.top];
        resolve(@{@"left":left,@"bottom":bottom,@"right":right,@"top":top});
    } @catch (NSException *exception) {
        reject(@"getMapViewBounds",exception.reason,nil);
    }
}

#pragma mark 设置当前窗口四至范围 viewBounds
RCT_REMAP_METHOD(setMapViewBounds, setMapViewBoundsWithLeft:(double)left Bottom:(double)bottom Right:(double)right Top:(double)top Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Rectangle2D *rect = [[Rectangle2D alloc] initWith:left bottom:bottom right:right top:top];
        sMap.smMapWC.mapControl.map.viewBounds = rect;
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setMapViewBounds",exception.reason,nil);
    }
}

#pragma mark 获取动态投影是否已开启
RCT_REMAP_METHOD(getMapDynamicProjection, getMapDynamicProjectionWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        BOOL isDynamicProjection = sMap.smMapWC.mapControl.map.dynamicProjection;
        resolve(@(isDynamicProjection));
    } @catch (NSException *exception) {
        reject(@"getMapDynamicProjection",exception.reason,nil);
    }
}
#pragma mark 设置动态投影开启/关闭
RCT_REMAP_METHOD(setMapDynamicProjection, setMapDynamicProjectionWithValue:(BOOL)value Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        sMap.smMapWC.mapControl.map.dynamicProjection = value;
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"getMapDynamicProjection",exception.reason,nil);
    }
}

#pragma mark 获取地图坐标系
RCT_REMAP_METHOD(getPrjCoordSys, getPrjCoordSysWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        NSString *prjCoordSysName = sMap.smMapWC.mapControl.map.prjCoordSys.name;
        resolve(prjCoordSysName);
    } @catch (NSException *exception) {
        reject(@"getPrjCoordSys",exception.reason,nil);
    }
}
#pragma mark 设置地图坐标系
RCT_REMAP_METHOD(setPrjCoordSys, setPrjCoordSysWithXml:(NSString *)xml Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        BOOL isCreate = [sMap.smMapWC.mapControl.map.prjCoordSys formXML:xml];
        if(isCreate){
            resolve(@(YES));
        }else{
            resolve(@(NO));
        }
    } @catch (NSException *exception) {
        reject(@"setMapScale",exception.reason,nil);
    }
}

#pragma mark 从数据源复制坐标系
RCT_REMAP_METHOD(copyPrjCoordSysFromDatasource, copyPrjCoordSysFromDatasourceWithPath:(NSString *)dataSourcePath EngineType:(int)enginetype resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try {
        sMap = [SMap singletonInstance];
        Workspace *workspace = [[Workspace alloc]init];
        
        DatasourceConnectionInfo *datasourceconnection = [[DatasourceConnectionInfo alloc] init];
        datasourceconnection.engineType = enginetype;
        datasourceconnection.server = dataSourcePath;
        datasourceconnection.alias = @"dataSource";
        Datasource *datasource = [workspace.datasources open:datasourceconnection];
        
        PrjCoordSys *coordSys = datasource.prjCoordSys;
        
        sMap.smMapWC.mapControl.map.prjCoordSys = coordSys;
        
        resolve(@{@"prjCoordSysName":sMap.smMapWC.mapControl.map.prjCoordSys.name});
    } @catch (NSException *exception) {
        reject(@"copyPrjCoordSysFromDatasourceServer",exception.reason,nil);
    }
    
}

#pragma mark 从数据集复制坐标系
RCT_REMAP_METHOD(copyPrjCoordSysFromDataset, copyPrjCoordSysFromDatasetWithDatasourceName:(NSString *)datasourceName datasetName:(NSString *)datasetName resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try {
        sMap = [SMap singletonInstance];
        Datasources *datasources = sMap.smMapWC.workspace.datasources;
        
        Datasource *datasource = [datasources getAlias:datasourceName];
        
        if(datasource != nil){
            Dataset *dataset = [datasource.datasets getWithName:datasetName];
            if(dataset != nil){
                if(dataset.prjCoordSys != nil){
                    sMap.smMapWC.mapControl.map.prjCoordSys = dataset.prjCoordSys;
                }else{
                    sMap.smMapWC.mapControl.map.prjCoordSys = datasource.prjCoordSys;
                }
                resolve(@{@"prjCoordSysName":sMap.smMapWC.mapControl.map.prjCoordSys.name});
            }else{
                resolve(@(NO));
            }
        }else{
            resolve(@(NO));
        }
    } @catch (NSException *exception) {
        reject(@"copyPrjCoordSysFromDataset",exception.reason,nil);
    }
    
}

#pragma mark 从文件复制坐标系
RCT_REMAP_METHOD(copyPrjCoordSysFromFile, copyPrjCoordSysFromFileWithPath:(NSString *)filePath  type:(NSString *)fileType resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        sMap = [SMap singletonInstance];
        PrjFileType type  = [fileType isEqualToString:@"xml"] ? SUPERMAP : ESRI;
        PrjCoordSys *prjCoordSys = [[PrjCoordSys alloc]init];
        BOOL isSuccess = [prjCoordSys fromFile:filePath Version:type];
        if(isSuccess){
            sMap.smMapWC.mapControl.map.prjCoordSys = prjCoordSys;
            resolve(@{@"prjCoordSysName":sMap.smMapWC.mapControl.map.prjCoordSys.name});
        }else{
            resolve(@{@"error":@"ILLEGAL_COORDSYS"});
        }
    } @catch (NSException *exception) {
        reject(@"copyPrjCoordSysFromFile",exception.reason,nil);
    }
    
}

#pragma mark 获取当前投影转换方法
RCT_REMAP_METHOD(getCoordSysTransMethod, getCoordSysTransMethodWithResolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        sMap = [SMap singletonInstance];
        CoordSysTransMethod method = sMap.smMapWC.mapControl.map.dynamicPrjTransMethond;
        NSString *name = @"";
        switch (method) {
            case MTH_GEOCENTRIC_TRANSLATION:
                name = @"Geocentric Transalation(3-para)";
                break;
            case MTH_MOLODENSKY:
                name = @"Molodensky(7-para)";
                break;
            case MTH_MOLODENSKY_ABRIDGED:
                name = @"Abridged Molodensky(7-para)";
                break;
            case MTH_POSITION_VECTOR:
                name = @"Position Vector(7-para)";
                break;
            case MTH_COORDINATE_FRAME:
                name = @"Coordinate Frame(7-para)";
                break;
            case MTH_BURSA_WOLF:
                name = @"Bursa-wolf(7-para)";
                break;
        }
        resolve(name);
    } @catch (NSException *exception) {
        reject(@"getCoordSysTransMethod",exception.reason,nil);
    }
    
}
#pragma mark 设置当前投影转换方法和参数
RCT_REMAP_METHOD(setCoordSysTransMethodAndParams, setCoordSysTransMethodAndParamsWithDic:(NSDictionary *) params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
        sMap = [SMap singletonInstance];
        Map *map = sMap.smMapWC.mapControl.map;
        CoordSysTransMethod method;
        NSArray *coorMethodArray = @[@"Geocentric Transalation(3-para)",@"Molodensky(7-para)",@"Abridged Molodensky(7-para)",@"Position Vector(7-para)",@"Coordinate Frame(7-para)",@"Bursa-wolf(7-para)"];
        NSString *name = [params valueForKey:@"coordSysTransMethod"];
        int index = [coorMethodArray indexOfObject:name];
        switch (index) {
            case 0:
                method = MTH_GEOCENTRIC_TRANSLATION;
                break;
            case 1:
                method = MTH_MOLODENSKY;
                break;
            case 2:
                method = MTH_MOLODENSKY_ABRIDGED;
                break;
            case 3:
                method = MTH_POSITION_VECTOR;
                break;
            case 4:
                method = MTH_COORDINATE_FRAME;
                break;
            case 5:
                method =MTH_BURSA_WOLF;
                break;
        }
        map.dynamicPrjTransMethond = method;
        map.dynamicPrjTransParameter.translateX = [[params valueForKey:@"translateX"] doubleValue];
        map.dynamicPrjTransParameter.translateY = [[params valueForKey:@"translateY"] doubleValue];
        map.dynamicPrjTransParameter.translateZ = [[params valueForKey:@"translateZ"] doubleValue];
        map.dynamicPrjTransParameter.rotateX = [[params valueForKey:@"rotateX"] doubleValue];
        map.dynamicPrjTransParameter.rotateY = [[params valueForKey:@"rotateY"] doubleValue];
        map.dynamicPrjTransParameter.rotateZ = [[params valueForKey:@"rotateZ"] doubleValue];
        
        resolve(@(YES));
    }@catch(NSException *exception){
        reject(@"setCoordSysTransMethodAndParams",exception.reason,nil);
    }
}
#pragma mark 获取图例的宽度和title
RCT_REMAP_METHOD(getScaleData, getScaleViewDataWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        sMap.scaleViewHelper.mScaleLevel =[sMap.scaleViewHelper getScaleLevel];
        sMap.scaleViewHelper.mScaleText = [sMap.scaleViewHelper getScaleText:sMap.scaleViewHelper.mScaleLevel];
        sMap.scaleViewHelper.mScaleWidth = [sMap.scaleViewHelper getScaleWidth:sMap.scaleViewHelper.mScaleLevel];
        double width = [[[NSNumber alloc]initWithFloat:sMap.scaleViewHelper.mScaleWidth] doubleValue];
        width = width * 100 / 70;
        resolve(@{@"width":[NSNumber numberWithDouble:width],@"title":sMap.scaleViewHelper.mScaleText});
    } @catch (NSException *exception) {
        reject(@"getScaleData",exception.reason,nil);
    }
}
#pragma mark 加此图例的事件监听
RCT_REMAP_METHOD(addLegendDelegate, addLegendDelegateWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        if(sMap.smMapWC.mapControl.map.legend.contentChangeDelegate == nil){
            sMap.smMapWC.mapControl.map.legend.contentChangeDelegate = self;
            [sMap.smMapWC.mapControl.map refresh];
        }
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"addLegendDelegate",exception.reason,nil);
    }
}


-(void)legentContentChange:(NSArray*)arrItems{
    NSMutableArray *legendSource = [[NSMutableArray alloc]init];
    for(int i = 0,count = arrItems.count; i < count; i++){
        UIImage *image = arrItems[i][0];
        NSData *data = UIImageJPEGRepresentation(arrItems[i][0], 1.0f);
        NSString *base64Str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSDictionary * temp = @{@"image":base64Str,@"title":arrItems[i][1],@"type":arrItems[i][2]};
        [legendSource addObject:temp];
    }
    
    [self sendEventWithName:LEGEND_CONTENT_CHANGE body:legendSource];
}

#pragma mark ---------------------地图设置菜单结束---------------------
//#pragma mark 导入工作空间
//RCT_REMAP_METHOD(openWorkspace, inputWKPath:(NSString*)inPutWorkspace resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        sMap = [SMap singletonInstance];
//        Workspace* wk = [[Workspace alloc]init];
//        WorkspaceConnectionInfo* wkInfo = [[WorkspaceConnectionInfo alloc]init];
//        NSString* exten = [inPutWorkspace pathExtension];
//        if([exten.uppercaseString isEqualToString:@"SMWU"]){
//            wkInfo.type = SM_SMWU;
//        }else if ([exten.uppercaseString isEqualToString:@"SXWU"]){
//            wkInfo.type = SM_SXWU;
//        }
//
//        wkInfo.server = inPutWorkspace;
//        BOOL bOPen = [wk open:wkInfo];
//        if(bOPen){
////            wk.maps;
////            NSMutableArray* mapArr = [NSMutableArray array];
////            for(int i=0;i<wk.maps.count;i++){
////                Map* map = [wk.maps get:i] ;
////                map
////            }
//        }
//
//
////        BOOL result = [sMap.smMapWC openWorkspace:infoDic];
////        if (result) {
////            [sMap.smMapWC.mapControl.map setWorkspace:sMap.smMapWC.workspace];
////        }
////        sMap.smMapWC.mapControl.map.isVisibleScalesEnabled = NO;
////        [sMap.smMapWC.mapControl.map refresh];
////        [self openGPS];
////        resolve([NSNumber numberWithBool:result]);
//    } @catch (NSException *exception) {
//        reject(@"workspace", exception.reason, nil);
//    }
//}


#pragma mark 关闭工作空间
RCT_REMAP_METHOD(closeWorkspace, closeWorkspaceWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        [sMap.smMapWC.mapControl.map close];
        [sMap.smMapWC.mapControl.map dispose];
        //        [sMap.smMapWC.mapControl dispose];
        [sMap.smMapWC.workspace close];
        defaultMapCenter = nil;
        //        [sMap.smMapWC.workspace dispose];
        
        //        sMap.smMapWC.mapControl = nil;
        //        sMap.smMapWC.workspace = nil;
        
        resolve([NSNumber numberWithBool:YES]);
    }@catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}


#pragma mark 以数据源形式打开工作空间, 默认根据Map 图层索引显示图层
RCT_REMAP_METHOD(openDatasourceWithIndex, openDatasourceByParams:(NSDictionary*)params defaultIndex:(int)defaultIndex toHead:(BOOL)toHead visible:(BOOL)visible resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        Datasource* dataSource = [sMap.smMapWC openDatasource:params];
        [sMap.smMapWC.mapControl.map setWorkspace:sMap.smMapWC.workspace];
        
        if (dataSource && defaultIndex >= 0 && dataSource.datasets.count > 0) {
            Dataset* ds = [dataSource.datasets get:defaultIndex];
            [sMap.smMapWC.mapControl.map setDynamicProjection:YES];
            Layer* layer = [sMap.smMapWC.mapControl.map.layers addDataset:ds ToHead:toHead];
            layer.visible = visible;
            sMap.smMapWC.mapControl.map.isVisibleScalesEnabled = NO;
        }
        [sMap.smMapWC.mapControl.map refresh];
        [self openGPS];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 以数据源形式打开工作空间, 默认根据Map 图层名称显示图层
RCT_REMAP_METHOD(openDatasourceWithName, openDatasourceByParams:(NSDictionary*)params defaultName:(NSString *)defaultName toHead:(BOOL)toHead visible:(BOOL)visible resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        if(params){
            Datasource* dataSource = [sMap.smMapWC openDatasource:params];
            [sMap.smMapWC.mapControl.map setWorkspace:sMap.smMapWC.workspace];
            
            if (defaultName != nil && defaultName.length > 0) {
                Dataset* ds = [dataSource.datasets getWithName:defaultName];
                [sMap.smMapWC.mapControl.map setDynamicProjection:YES];
                Layer* layer = [sMap.smMapWC.mapControl.map.layers addDataset:ds ToHead:toHead];
                layer.visible = visible;
                sMap.smMapWC.mapControl.map.isVisibleScalesEnabled = NO;
            }
            [self openGPS];
            [sMap.smMapWC.mapControl.map refresh];
            resolve([NSNumber numberWithBool:YES]);
        }
    } @catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 根据名称关闭数据源，datasourceName为空则全部关闭
RCT_REMAP_METHOD(closeDatasourceWithName, closeDatasourceWithName:(NSString *)datasourceName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap =[SMap singletonInstance];
        Datasources *datasources = sMap.smMapWC.workspace.datasources;
        BOOL isClose = YES;
        if([datasourceName isEqualToString:@""]){
            for(int i = 0; i < [datasources count]; i++){
                if([datasources get:i] != nil && [[datasources get:i] isOpended]){
                    isClose = [datasources close:i] && isClose;
                }
            }
        } else {
            if ([datasources getAlias:datasourceName] != nil) {
                isClose = [datasources closeAlias:datasourceName];
            }
        }
        resolve(@(isClose));
    } @catch (NSException *exception) {
        reject(@"closeDatasourceWithName",exception.reason,nil);
    }
}

#pragma mark 根据序号关闭数据源，index = -1 则全部关闭
RCT_REMAP_METHOD(closeDatasourceWithIndex, closeDatasourceWithIndex:(NSInteger *)index resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Datasources *datasources = sMap.smMapWC.workspace.datasources;
        BOOL isClose = YES;
        if(index == -1){
            for(int i = 0,l = [datasources count]; i < l; i++){
                if([datasources get:i] != nil && [[datasources get:i] isOpended]){
                    isClose = [datasources close:i] && isClose;
                }
            }
        } else {
            if ([datasources get:index] != nil) {
                isClose = [datasources close:index];
            }
        }
        resolve(@(isClose));
        
    } @catch (NSException *exception) {
        reject(@"closeDatasourceWithIndex",exception.reason,nil);
    }
}

#pragma mark 工作空间是否被修改
RCT_REMAP_METHOD(workspaceIsModified, workspaceIsModifiedWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BOOL result = sMap.smMapWC.workspace.isModified;
        resolve([NSNumber numberWithBool:result]);
    }@catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}


RCT_REMAP_METHOD(isModified, isModifiedWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        BOOL isWorkSpaceModified = sMap.smMapWC.workspace.isModified;
        BOOL isMapModified = sMap.smMapWC.mapControl.map.isModified;
        if(!isWorkSpaceModified && !isMapModified){
            resolve(@(YES));
        }else{
            resolve(@(NO));
        }
    } @catch (NSException *exception) {
        reject(@"isModified",exception.reason,nil);
    }
}
#pragma mark 仅用于判断在线数据是否可请求到数据
RCT_REMAP_METHOD(isDatasourceOpen, isDatasourceOpenWithData:(NSDictionary *)data resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    @try{
        sMap = [SMap singletonInstance];
        Datasource *datasource = [sMap.smMapWC openDatasource:data];
        if(datasource != nil){
            resolve(@(YES));
        }else{
            resolve(@(NO));
        }
    }@catch(NSException *exception){
        reject(@"isDatasourceOpen",exception.reason,nil);
    }
}


#pragma mark 保存地图为xml
RCT_REMAP_METHOD(saveMapToXML, saveMapToXMLWithFilePath:(NSString *)filepath resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap =  [SMap singletonInstance];
        NSArray *splitArr = [filepath componentsSeparatedByString:@"/"];
        NSString *mapName = [[[splitArr objectAtIndex:[splitArr count] - 1] componentsSeparatedByString:@"."] objectAtIndex:0];
        int count = sMap.smMapWC.workspace.maps.count;
        if(count == 0){
            [sMap.smMapWC.mapControl.map saveAs:mapName];
        }else{
            for(int i = 0; i < count; i++){
                NSString *name = [sMap.smMapWC.workspace.maps get:i];
                if([mapName isEqualToString:name]){
                    [sMap.smMapWC.mapControl.map save];
                    break;
                }
                if(i == count - 1){
                    [sMap.smMapWC.mapControl.map saveAs:mapName];
                }
            }
        }
        NSString *mapXML = [sMap.smMapWC.mapControl.map toXML];
        if(![mapXML isEqualToString:@""]){
            NSFileManager *filemanager = [NSFileManager defaultManager];
            [filemanager createFileAtPath:filepath contents:nil attributes:nil];
            [mapXML writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"saveMapToXML",exception.reason,nil);
    }
}

#pragma mark 加载地图XML，显示地图
RCT_REMAP_METHOD(openMapFromXML, openMapFromXMLWithFilePath:(NSString *)filePath resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        NSArray *splitArr = [filePath componentsSeparatedByString:@"/"];
        NSString *mapName = [[[splitArr objectAtIndex:[splitArr count] - 1] componentsSeparatedByString:@"."] objectAtIndex:0];
        NSFileManager *filemanager = [NSFileManager defaultManager];
        [filemanager createFileAtPath:filePath contents:nil attributes:nil];
        
        NSString *strXML = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        
        int count = [sMap.smMapWC.workspace.maps count];
        
        if(count == 0){
            [sMap.smMapWC.workspace.maps add:mapName withXML:strXML];
        }else{
            for(int i = 0; i < count; i++){
                NSString *name = [sMap.smMapWC.workspace.maps get:i];
                if([mapName isEqualToString:name]){
                    break;
                }
                if(i == count - 1){
                    [sMap.smMapWC.workspace.maps add:mapName withXML:strXML];
                }
            }
        }
        [sMap.smMapWC.mapControl.map open:mapName];
        [sMap.smMapWC.mapControl.map refresh];
        resolve(@(YES));
    }@catch (NSException *exception) {
        reject(@"openMapFromXML", exception.reason, nil);
    }
}

#pragma mark 获取地图对应的数据源
RCT_REMAP_METHOD(getMapDatasourcesAlias, getMapDatasourcesAliasWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap =[SMap singletonInstance];
        Layers *layers = sMap.smMapWC.mapControl.map.layers;
        int count =[layers getCount];
        NSMutableArray *datasourceNamelist = [[NSMutableArray alloc] init];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for(int i = 0; i < count; i++){
            Dataset *dataset = [[layers getLayerAtIndex:i] dataset];
            if(dataset != nil){
                NSString *dataSourceAlias = [[dataset datasource] alias];
                if(![datasourceNamelist containsObject:dataSourceAlias]){
                    [datasourceNamelist addObject:dataSourceAlias];
                    
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:[dataSourceAlias stringByAppendingString:@".udb"] forKey:@"title"];
                    [arr addObject:dic];
                }
            }
        }
        resolve(arr);
    }@catch (NSException *exception) {
        reject(@"getMapDatasourcesAlias", exception.reason, nil);
    }
}

#pragma mark 保存工作空间
RCT_REMAP_METHOD(saveWorkspace, saveWorkspaceWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        BOOL result = [sMap.smMapWC saveWorkspace];
        resolve([NSNumber numberWithBool:result]);
    }@catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 根据工作空间连接信息保存工作空间
RCT_REMAP_METHOD(saveWorkspaceWithInfo, saveWorkspaceWithInfoWithInfo:(NSDictionary *)info resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        BOOL result = [sMap.smMapWC saveWorkspaceWithInfo:info];
        resolve([NSNumber numberWithBool:result]);
    }@catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 关闭地图控件
RCT_REMAP_METHOD(closeMapControl, closeMapControlWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        if (sMap.smMapWC.mapControl.map) {
            [sMap.smMapWC.mapControl.map close];
            [sMap.smMapWC.mapControl.map dispose];
        }
        //        [sMap.smMapWC.mapControl dispose];
        if (sMap.smMapWC.mapControl) {
            //            [sMap.smMapWC.mapControl dispose];
        }
        if (sMap.smMapWC.workspace) {
            [sMap.smMapWC.workspace close];
            //            [sMap.smMapWC.workspace dispose];
        }
        
        defaultMapCenter = nil;
        //        sMap.smMapWC.mapControl = nil;
        //        sMap.smMapWC.workspace = nil;
        
        resolve([NSNumber numberWithBool:YES]);
    }@catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 根据工作空间名字获取地图
RCT_REMAP_METHOD(getMapsByFile, getMapsByFile:(NSString*)path resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSString* type = [path pathExtension];
        WorkspaceType workspaceType;
        
        if ( [type isEqualToString:@"sxw"] ) {
            workspaceType = SM_SXW;
        }else if( [type isEqualToString:@"smw"] ){
            workspaceType = SM_SMW;
        }else if( [type isEqualToString:@"sxwu"] ){
            workspaceType = SM_SXWU;
        }else if( [type isEqualToString:@"smwu"] ){
            workspaceType = SM_SMWU;
        }
        
        Workspace* ws = [[Workspace alloc] init];
        WorkspaceConnectionInfo* wsInfo = [[WorkspaceConnectionInfo alloc] init];
        wsInfo.server = path;
        wsInfo.type = workspaceType;
        
        BOOL result = [ws open:wsInfo];
        
        NSMutableArray* mapArr = [[NSMutableArray alloc] init];
        if (result && ws.maps.count > 0) {
            for (int i = 0; i < ws.maps.count; i++) {
                [mapArr addObject:[ws.maps get:i]];
            }
        }
        
        [ws close];
        [wsInfo dispose];
        [ws dispose];
        
        resolve(mapArr);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 根据名字显示图层
RCT_REMAP_METHOD(openMapByName, openMapByName:(NSString*)name viewEntire:(BOOL)viewEntire center:(NSDictionary *)center resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Map* map = sMap.smMapWC.mapControl.map;
        Maps* maps = sMap.smMapWC.workspace.maps;
        if(sMap.smMapWC.mapControl.map.delegate == nil){
            sMap.smMapWC.mapControl.map.delegate = self;
        }
//        if(sMap.scaleViewHelper == nil){
//            sMap.scaleViewHelper = [[ScaleViewHelper alloc]initWithMapControl:sMap.smMapWC.mapControl];
//
//        }
        BOOL isOpen = NO;
        
        if (![map.name isEqualToString:name] && maps.count > 0) {
            NSString* mapName = name;
            
            if ([name isEqualToString:@""]) {
                NSString* mapName = [maps get:0];
                [map open: mapName];
            }
            if (![name isKindOfClass:[NSNull class]] && name.length) {
                isOpen = [map open: mapName];
            } else if (viewEntire == YES) {
                [map viewEntire];
            }
            
            if (isOpen) {
                if (center != nil && ![center isKindOfClass:[NSNull class]] && center.count > 0) {
                    NSNumber* x = [center objectForKey:@"x"];
                    NSNumber* y = [center objectForKey:@"y"];
                    Point2D* point = [[Point2D alloc] init];
                    point.x = x.doubleValue;
                    point.y = y.doubleValue;
                    [map setCenter:point];
                }
                
                defaultMapCenter = map.center;
                [sMap.smMapWC.mapControl setAction:PAN];
                sMap.smMapWC.mapControl.map.isVisibleScalesEnabled = NO;
                [map refresh];
            }
        }
        
        resolve([NSNumber numberWithBool:isOpen]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 根据序号显示图层
RCT_REMAP_METHOD(openMapByIndex, openMapByIndex:(int)index viewEntire:(BOOL)viewEntire center:(NSDictionary *)center resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Map* map = sMap.smMapWC.mapControl.map;
        Maps* maps = sMap.smMapWC.workspace.maps;
        if(sMap.smMapWC.mapControl.map.delegate == nil){
            sMap.smMapWC.mapControl.map.delegate = self;
        }
//        if(sMap.scaleViewHelper == nil){
//            sMap.scaleViewHelper = [[ScaleViewHelper alloc]initWithMapControl:sMap.smMapWC.mapControl];
//
//        }
        BOOL isOpen = YES;
        
        if (maps.count > 0 && index >= 0) {
            if (index >= maps.count) index = maps.count - 1;
            NSString* mapName = [maps get:index];
            isOpen = [map open: mapName];
            
            if (isOpen) {
                if (viewEntire == YES) {
                    [map viewEntire];
                }
                
                if (center != nil && ![center isKindOfClass:[NSNull class]] && center.count > 0) {
                    NSNumber* x = [center objectForKey:@"x"];
                    NSNumber* y = [center objectForKey:@"y"];
                    Point2D* point = [[Point2D alloc] init];
                    point.x = x.doubleValue;
                    point.y = y.doubleValue;
                    [map setCenter:point];
                }
                defaultMapCenter = map.center;
                [sMap.smMapWC.mapControl setAction:PAN];
                sMap.smMapWC.mapControl.map.isVisibleScalesEnabled = NO;
                [map refresh];
            }
        }
        resolve([NSNumber numberWithBool:isOpen]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 获取工作空间地图列表
RCT_REMAP_METHOD(getMaps, getMapsWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Maps* maps = sMap.smMapWC.workspace.maps;
        NSMutableArray* mapList = [NSMutableArray array];
        for (int i = 0; i < maps.count; i++) {
            NSString* mapName = [maps get:i];
            NSMutableDictionary* mapInfo = [[NSMutableDictionary alloc] init];
            [mapInfo setObject:mapName forKey:@"title"];
            [mapList addObject:mapInfo];
        }
        resolve(mapList);
    }@catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 设置当前图层全副
/**
 * 设置当前图层全副
 *
 * @param promise
 */
RCT_REMAP_METHOD(setLayerFullView, name:(NSString*)name setLayerFullViewResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
     @try{
         Map* map = sMap.smMapWC.mapControl.map;
         Rectangle2D* bounds =  [map.layers getLayerWithName:name].dataset.bounds;
         map.viewBounds = bounds;
         [map refresh];
       resolve(@(1));
     } @catch (NSException *exception) {
         reject(@"workspace", exception.reason, nil);
     }
}

#pragma mark 获取地图信息
RCT_REMAP_METHOD(getMapInfo, getMapInfoWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Map* map = sMap.smMapWC.mapControl.map;
        NSMutableDictionary* mapInfo = [[NSMutableDictionary alloc] init];
        [mapInfo setObject:map.name forKey:@"name"];
        [mapInfo setObject:map.description forKey:@"description"];
        [mapInfo setObject:@(map.isModified) forKey:@"isModified"];
        resolve(mapInfo);
    }@catch (NSException *exception) {
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark MapControl的closeMap
RCT_REMAP_METHOD(closeMap, closeMapWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        if(sMap.scaleViewHelper){
            sMap.scaleViewHelper = nil;
        }
        MapControl* mapControl = sMap.smMapWC.mapControl;
        if (mapControl) {
            [[mapControl map] close];
        }
        
        defaultMapCenter = nil;
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}
RCT_REMAP_METHOD(getUDBNameOfLabel, getUDBNameOfLabelWithPath:(NSString *)path resolve:(RCTPromiseResolveBlock)resolve rejector:(RCTPromiseRejectBlock)reject){
    @try {
        
        NSString *udbName = [[path lastPathComponent] stringByDeletingPathExtension];
        Datasource *datasource;
        SMap *sMap = [SMap singletonInstance];
        DatasourceConnectionInfo *dsci = [[DatasourceConnectionInfo alloc] init];
        Workspace *workspace = [[Workspace alloc]init];
        dsci.engineType = ET_UDB;
        dsci.server = path;
        dsci.alias = udbName;
        datasource = [workspace.datasources open:dsci];
        Datasets *datasets = datasource.datasets;
        int count = datasets.count;
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for(int i = 0; i < count; i++){
            Dataset *dataset = [datasets get:i];
            NSString *name = dataset.name;
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:name forKey:@"title"];
            [arr addObject:dic];
        }
        if(workspace != nil){
            [workspace.datasources closeAll];
            [workspace close];
            [workspace dispose];
        }
        [dsci dispose];
        resolve(arr);
    } @catch (NSException *exception) {
        reject(@"getUDBNameOfLabel",exception.reason,nil);
    }
}
#pragma mark 获取UDB数据源的数据集列表
RCT_REMAP_METHOD(getUDBName, getUDBNameWithPath:(NSString *)path resolve:(RCTPromiseResolveBlock)resolve rejector:(RCTPromiseRejectBlock)reject){
    @try {
        NSString *udbName = [[path lastPathComponent] stringByDeletingPathExtension];
        Datasource *datasource;
        Workspace *workspace = nil;
        SMap *sMap = [SMap singletonInstance];
        DatasourceConnectionInfo *dsci = [[DatasourceConnectionInfo alloc] init];
        if(sMap.smMapWC.mapControl == nil){
            workspace = [[Workspace alloc]init];
            dsci.engineType = ET_UDB;
            dsci.server = path;
            dsci.alias = udbName;
            datasource = [workspace.datasources open:dsci];
        }else{
            sMap.smMapWC.mapControl.map.workspace = sMap.smMapWC.workspace;
            if([sMap.smMapWC.mapControl.map.workspace.datasources indexOf:udbName] != -1){
                datasource = [sMap.smMapWC.mapControl.map.workspace.datasources getAlias:udbName];
            }else{
                dsci.engineType = ET_UDB;
                dsci.server = path;
                dsci.alias = udbName;
                datasource = [sMap.smMapWC.mapControl.map.workspace.datasources open:dsci];
            }
        }
        Datasets *datasets = datasource.datasets;
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for(int i = 0, count = [datasets count]; i < count; i++){
            Dataset *dataset = [datasets get:i];
            NSString *name = dataset.name;
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:name forKey:@"title"];
            [arr addObject:dic];
        }
        if(workspace != nil){
            [workspace.datasources closeAll];
            [workspace close];
            [workspace dispose];
        }
        [dsci dispose];
        resolve(arr);
    } @catch (NSException *exception) {
        reject(@"getUDBName",exception.reason,nil);
    }
}

#pragma mark 设置MapControl的Action
RCT_REMAP_METHOD(setAction, setActionByActionType:(int)actionType resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        sMap.smMapWC.mapControl.action = actionType;
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark /************************************** 设置绘制对象时画笔样式 START****************************************/
#pragma mark 设置MapControl的Action
RCT_REMAP_METHOD(setStrokeColor, setStrokeColor:(int)strokeColor resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        //        sMap.smMapWC.mapControl.strokeColor = strokeColor;
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark MapControl的undo
RCT_REMAP_METHOD(undo, undoWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl* mapControl = sMap.smMapWC.mapControl;
        [mapControl undo];
        //        [[mapControl map] refresh];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark MapControl的redo
RCT_REMAP_METHOD(redo, redoWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl* mapControl = sMap.smMapWC.mapControl;
        [mapControl redo];
        //        [[mapControl map] refresh];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 添加量算监听
RCT_REMAP_METHOD(addMeasureListener, addMeasureListenerWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        if (mapControl.mapMeasureDelegate == nil) {
            mapControl.mapMeasureDelegate = self;
        }
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 移除量算监听
RCT_REMAP_METHOD(removeMeasureListener, removeMeasureListenerWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        mapControl.mapMeasureDelegate = nil;
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 量算监听
-(void)getMeasureResult:(double)result lastPoint:(Point2D *)lastPoint type:(int)type{
    NSNumber *nsResult = [NSNumber numberWithDouble:result];
    double x = lastPoint.x;
    double y = lastPoint.y;
    NSNumber* nsX = [NSNumber numberWithDouble:x];
    NSNumber* nsY = [NSNumber numberWithDouble:y];
    
    if(type == 0){
        [self sendEventWithName:MEASURE_LENGTH
                           body:@{@"curResult":nsResult,
                                  @"curPoint":@{@"x":nsX,@"y":nsY}
                                  }];
    }
    
    if(type == 1){
        [self sendEventWithName:MEASURE_AREA
                           body:@{@"curResult":nsResult,
                                  @"curPoint":@{@"x":nsX,@"y":nsY}
                                  }];
    }
    
    if(type == 2){
        [self sendEventWithName:MEASURE_ANGLE
                           body:@{@"curAngle":nsResult,
                                  @"curPoint":@{@"x":nsX,@"y":nsY}
                                  }];
    }
}

#pragma mark /******************************************** 地图工具 *****************************************************/
#pragma mark 将地图放大缩小到指定比例
RCT_REMAP_METHOD(zoom, zoomByScale:(double)scale resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [mapControl.map zoom:scale];
        [mapControl.map refresh];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 设置比例尺
RCT_REMAP_METHOD(setScale, setScale:(double)scale resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [mapControl.map setScale:scale];
        [mapControl.map refresh];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 设置地图手势旋转是否可用
RCT_REMAP_METHOD(enableRotateTouch, enableRotateTouch:(BOOL)enable resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [mapControl enableRotateTouch:enable];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 设置地图手势俯仰是否可用
RCT_REMAP_METHOD(enableSlantTouch, enableSlantTouch:(BOOL)enable resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [mapControl enableSlantTouch:enable];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 移动到当前位置
+(void)moveHelper{
    MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
//    Collector* collector = [mapControl getCollector];
    dispatch_async(dispatch_get_main_queue(), ^{
        //            [collector moveToCurrentPos];
        BOOL isMove = NO;
        GPSData* gpsData = [NativeUtil getGPSData];
        Point2D* pt = [[Point2D alloc]initWithX:gpsData.dLongitude Y:gpsData.dLatitude];
        if ([mapControl.map.prjCoordSys type] != PCST_EARTH_LONGITUDE_LATITUDE) {//若投影坐标不是经纬度坐标则进行转换
            Point2Ds *points = [[Point2Ds alloc]init];
            [points add:pt];
            PrjCoordSys *srcPrjCoorSys = [[PrjCoordSys alloc]init];
            [srcPrjCoorSys setType:PCST_EARTH_LONGITUDE_LATITUDE];
            CoordSysTransParameter *param = [[CoordSysTransParameter alloc]init];
            
            //根据源投影坐标系与目标投影坐标系对坐标点串进行投影转换，结果将直接改变源坐标点串
            [CoordSysTranslator convert:points PrjCoordSys:srcPrjCoorSys PrjCoordSys:[mapControl.map prjCoordSys] CoordSysTransParameter:param CoordSysTransMethod:(CoordSysTransMethod)9603];
            pt = [points getItem:0];
        }
        
        [SMap deleteMarker:curLocationTag];
       // [sMap.smMapWC.mapControl removeCalloutWithTag:curLocationTag];
        Point2D* mapCenter = pt;
        if (![mapControl.map.bounds containsPoint2D:pt]) {
            if(defaultMapCenter){
                mapCenter= defaultMapCenter;
            }
        }else{
            [SMap showMarkerHelper:mapCenter tag:curLocationTag];
        }
        
        mapControl.map.center = mapCenter;
        isMove = YES;
        [mapControl.map refresh];
        
    });
}
RCT_REMAP_METHOD(moveToCurrent, moveToCurrentWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [SMap moveHelper];
        [[SMap singletonInstance].smMapWC.mapControl.map setAngle:0];
        [[SMap singletonInstance].smMapWC.mapControl.map setSlantAngle:0];
//        [mapControl.map setAngle:0];
//        [mapControl.map setSlantAngle:0];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 移动到指定位置
RCT_REMAP_METHOD(moveToPoint, moveToPointWithPoint:(NSDictionary *)point resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if (![[point allKeys] containsObject:@"x"] || ![[point allKeys] containsObject:@"y"]){
            resolve([NSNumber numberWithBool:NO]);
            return;
        }
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [collector moveToCurrentPos];
            BOOL isMove = NO;
            NSNumber* x = [point objectForKey:@"x"];
            NSNumber* y = [point objectForKey:@"y"];
            Point2D* pt = [[Point2D alloc] initWithX:x.doubleValue Y:y.doubleValue];
            if (x.doubleValue <= 180 && x.doubleValue >= -180 && y.doubleValue >= - 90 && y.doubleValue <= 90) {
                if ([mapControl.map.prjCoordSys type] != PCST_EARTH_LONGITUDE_LATITUDE) {//若投影坐标不是经纬度坐标则进行转换
                    Point2Ds *points = [[Point2Ds alloc]init];
                    [points add:pt];
                    PrjCoordSys *srcPrjCoorSys = [[PrjCoordSys alloc]init];
                    [srcPrjCoorSys setType:PCST_EARTH_LONGITUDE_LATITUDE];
                    CoordSysTransParameter *param = [[CoordSysTransParameter alloc]init];
                    
                    //根据源投影坐标系与目标投影坐标系对坐标点串进行投影转换，结果将直接改变源坐标点串
                    [CoordSysTranslator convert:points PrjCoordSys:srcPrjCoorSys PrjCoordSys:[mapControl.map prjCoordSys] CoordSysTransParameter:param CoordSysTransMethod:(CoordSysTransMethod)9603];
                    pt = [points getItem:0];
                }
            } else {
                if ([mapControl.map.prjCoordSys type] != PCST_SPHERE_MERCATOR) {//若坐标不是地图坐标则进行转换
                    Point2Ds *points = [[Point2Ds alloc]init];
                    [points add:pt];
                    PrjCoordSys *srcPrjCoorSys = [[PrjCoordSys alloc]init];
                    [srcPrjCoorSys setType:PCST_SPHERE_MERCATOR];
                    CoordSysTransParameter *param = [[CoordSysTransParameter alloc]init];
                    
                    [CoordSysTranslator convert:points PrjCoordSys:srcPrjCoorSys PrjCoordSys:[mapControl.map prjCoordSys] CoordSysTransParameter:param CoordSysTransMethod:(CoordSysTransMethod)9603];
                    pt = [points getItem:0];
                }
            }
            //            if ([mapControl.map.prjCoordSys type] != PCST_EARTH_LONGITUDE_LATITUDE) {//若投影坐标不是经纬度坐标则进行转换
            //                Point2Ds *points = [[Point2Ds alloc]init];
            //                [points add:pt];
            //                PrjCoordSys *srcPrjCoorSys = [[PrjCoordSys alloc]init];
            //                [srcPrjCoorSys setType:PCST_EARTH_LONGITUDE_LATITUDE];
            //                CoordSysTransParameter *param = [[CoordSysTransParameter alloc]init];
            //
            //                //根据源投影坐标系与目标投影坐标系对坐标点串进行投影转换，结果将直接改变源坐标点串
            //                [CoordSysTranslator convert:points PrjCoordSys:srcPrjCoorSys PrjCoordSys:[mapControl.map prjCoordSys] CoordSysTransParameter:param CoordSysTransMethod:(CoordSysTransMethod)9603];
            //                pt = [points getItem:0];
            //            }
            
            if ([mapControl.map.bounds containsPoint2D:pt]) {
                mapControl.map.center = pt;
                isMove = YES;
            } else {
                if(defaultMapCenter){
                    mapControl.map.center = defaultMapCenter;
                }
            }
            
            [mapControl.map refresh];
            resolve([NSNumber numberWithBool:isMove]);
        });
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

-(void)openGPS {
//    MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
//    Collector* collector = [mapControl getCollector];
    [NativeUtil openGPS];
}

#pragma mark 提交
RCT_REMAP_METHOD(submit, submitWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        bool result = [mapControl submit];
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 取消
RCT_REMAP_METHOD(cancel, cancelWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [mapControl cancel];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 保存地图 autoNaming为true的话若有相同名字的地图则自动命名
RCT_REMAP_METHOD(saveMap, saveMapWithName:(NSString *)name autoNaming:(BOOL)autoNaming resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BOOL mapSaved = NO;
        BOOL wsSaved = NO;
        NSString* _name = name;
        Map* map = [SMap singletonInstance].smMapWC.mapControl.map;
        if (_name == nil || [_name isEqualToString:@""]) {
            if (map.name && ![map.name isEqualToString:@""]) {
                mapSaved = [map save];
            } else if (map.layers.getCount > 0) {
                Layer* layer = [map.layers getLayerAtIndex:map.layers.getCount - 1];
                NSArray* nameArr = [layer.name componentsSeparatedByString:@"@"];
                _name = nameArr[0];
                if (autoNaming) {
                    int i = 0;
                    while (!mapSaved) {
                        _name = i == 0 ? name : [NSString stringWithFormat:@"%@#%d", name, i];
                        mapSaved = [map save:_name];
                        i++;
                    }
                } else {
                    mapSaved = [map save:_name];
                }
            }
        } else {
            mapSaved = [map save:_name];
        }
        wsSaved = [[SMap singletonInstance].smMapWC.workspace save];
        
        if (mapSaved && wsSaved) {
            resolve(_name);
        } else {
            resolve([NSNumber numberWithBool:mapSaved && wsSaved]);
        }
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 移除指定位置的地图
RCT_REMAP_METHOD(removeMapByIndex, removeMapWithIndex:(int)index resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BOOL result = NO;
        Maps* maps = SMap.singletonInstance.smMapWC.workspace.maps;
        if (maps.count > 0 && index < maps.count) {
            if (index < 0) {
                for (int i = maps.count - 1; i >= 0; i--) {
                    NSString* name = [maps get:i];
                    result = [maps removeMapAtIndex:i] && result;
                    [SMap.singletonInstance.smMapWC.workspace.resources.markerLibrary.rootGroup.childSymbolGroups removeGroupWith:name isUpMove:NO];
                    [SMap.singletonInstance.smMapWC.workspace.resources.lineLibrary.rootGroup.childSymbolGroups removeGroupWith:name isUpMove:NO];
                    [SMap.singletonInstance.smMapWC.workspace.resources.fillLibrary.rootGroup.childSymbolGroups removeGroupWith:name isUpMove:NO];
                }
            } else {
                NSString* name = [maps get:index];
                result = [maps removeMapAtIndex:index];
                [SMap.singletonInstance.smMapWC.workspace.resources.markerLibrary.rootGroup.childSymbolGroups removeGroupWith:name isUpMove:NO];
                [SMap.singletonInstance.smMapWC.workspace.resources.lineLibrary.rootGroup.childSymbolGroups removeGroupWith:name isUpMove:NO];
                [SMap.singletonInstance.smMapWC.workspace.resources.fillLibrary.rootGroup.childSymbolGroups removeGroupWith:name isUpMove:NO];
            }
        }
        
        resolve([NSNumber numberWithBool:result]);///test test
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 移除指定名称的地图
RCT_REMAP_METHOD(removeMapByName, removeMapWithName:(NSString *)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BOOL result = NO;
        Maps* maps = SMap.singletonInstance.smMapWC.workspace.maps;
        if (maps.count > 0 && (name == nil || [name isEqualToString:@""])) {
            for (int i = 0; i < maps.count; i++) {
                NSString* _name = [maps get:i];
                result = [maps removeMapAtIndex:i] && result;
                [SMap.singletonInstance.smMapWC.workspace.resources.markerLibrary.rootGroup.childSymbolGroups removeGroupWith:_name isUpMove:NO];
                [SMap.singletonInstance.smMapWC.workspace.resources.lineLibrary.rootGroup.childSymbolGroups removeGroupWith:_name isUpMove:NO];
                [SMap.singletonInstance.smMapWC.workspace.resources.fillLibrary.rootGroup.childSymbolGroups removeGroupWith:_name isUpMove:NO];
            }
        } else if (maps.count > 0 && [maps indexOf:name] >= 0) {
            result = [maps removeMapName:name];
            [SMap.singletonInstance.smMapWC.workspace.resources.markerLibrary.rootGroup.childSymbolGroups removeGroupWith:name isUpMove:NO];
            [SMap.singletonInstance.smMapWC.workspace.resources.lineLibrary.rootGroup.childSymbolGroups removeGroupWith:name isUpMove:NO];
            [SMap.singletonInstance.smMapWC.workspace.resources.fillLibrary.rootGroup.childSymbolGroups removeGroupWith:name isUpMove:NO];
        }
        
        resolve([NSNumber numberWithBool:result]);///test test
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 地图另存为
RCT_REMAP_METHOD(saveAsMap, saveAsMapWithName:(NSString *)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BOOL result = NO;
        if (name != nil && ![name isEqualToString:@""]) {
            result = [[SMap singletonInstance].smMapWC.mapControl.map saveAs:name];
            result = result && [[SMap singletonInstance].smMapWC.workspace save];
        }
        
        resolve([NSNumber numberWithBool:result]);///test test
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 检查地图是否有改动
RCT_REMAP_METHOD(mapIsModified, mapIsModifiedWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BOOL result = [SMap singletonInstance].smMapWC.mapControl.map.isModified;
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 根据地图名称获取地图的index, 若name为空，则返回当前地图的index
RCT_REMAP_METHOD(getMapIndex, getMapIndexWithName:(NSString *)name Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        long index = -1;
        if (name == nil || [name isEqualToString:@""]) {
            if ([SMap singletonInstance].smMapWC.mapControl.map) {
                index = [[SMap singletonInstance].smMapWC.workspace.maps indexOf:[SMap singletonInstance].smMapWC.mapControl.map.name];
            }
        } else {
            index = [[SMap singletonInstance].smMapWC.workspace.maps indexOf:name];
        }
        
        resolve([NSNumber numberWithLong:index]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 设置手势监听
RCT_REMAP_METHOD(setGestureDetector, setGestureDetectorByResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [SMap singletonInstance].smMapWC.mapControl.delegate = self;
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 去除手势监听
RCT_REMAP_METHOD(deleteGestureDetector,deleteGestureDetectorwithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        mapControl.delegate = nil;
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(addGeometrySelectedListener, addGeometrySelectedListenerByResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        mapControl.geometrySelectedDelegate = self;
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 去除手势监听
RCT_REMAP_METHOD(removeGeometrySelectedListener, resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        mapControl.geometrySelectedDelegate = nil;
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 指定可编辑图层
RCT_REMAP_METHOD(appointEditGeometry, appointEditGeometryByGeoId:(int)geoId layerName:(NSString*)layerName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        Layer* layer = [mapControl.map.layers getLayerWithName:layerName];
        bool result = [mapControl appointEditGeometryWithID:geoId Layer:layer];
        [layer setEditable:YES];
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 获取指定SymbolGroup中所有的group
RCT_REMAP_METHOD(getSymbolGroups, getSymbolGroupsByType:(NSString *)type path:(NSString *)path resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Resources* resoures = [SMap singletonInstance].smMapWC.workspace.resources;
        NSArray* groups = [SMSymbol getSymbolGroups:resoures type:type path:path];
        
        resolve(groups);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 获取指定SymbolGroup中所有的symbol
RCT_REMAP_METHOD(findSymbolsByGroups, findSymbolsByGroups:(NSString *)type path:(NSString *)path resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Resources* resoures = [SMap singletonInstance].smMapWC.workspace.resources;
        NSArray* symbols = [SMSymbol findSymbolsByGroups:resoures type:type path:path];
        
        resolve(symbols);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 导入工作空间
RCT_REMAP_METHOD(importWorkspace, importWorkspaceInfo:(NSDictionary*)wInfo toFile:(NSString*)strFilePath  datasourceReplace:(BOOL)breplaceDatasource resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        sMap = [SMap singletonInstance];
        BOOL result = [sMap.smMapWC importWorkspaceInfo:wInfo withFileDirectory:strFilePath isDatasourceReplace:breplaceDatasource isSymbolsReplace:YES];
        
        resolve(@(result));
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}
RCT_REMAP_METHOD(importDatasourceFile, strFile:(NSString*)strFile module:(NSString*)nModule  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        sMap = [SMap singletonInstance];
        BOOL result = [sMap.smMapWC importDatasourceFile:strFile ofModule:nModule];
        
        resolve(@(result));
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}
/**
 * 获取统一标签专题图的字段表达式
 *
 * @param layerName 图层名称
 */
#pragma mark 获取统一标签专题图的字段表达式
RCT_REMAP_METHOD(addDatasetToMap, addDatasetToMapWithResolver:(NSDictionary*)dataDic resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSString* datastourceName = @"";
        NSString* datasetName = @"";
        NSArray* array = [dataDic allKeys];
        if ([array containsObject:@"DatasourceName"]) {
            datastourceName = [dataDic objectForKey:@"DatasourceName"];
        }
        if ([array containsObject:@"DatasetName"]) {
            datasetName = [dataDic objectForKey:@"DatasetName"];
        }
        Workspace* workspace = sMap.smMapWC.workspace;
        if(![datastourceName isEqualToString:@""] && ![datasetName isEqualToString:@""]){
            Datasource* datasource = [workspace.datasources getAlias:datastourceName];
            Dataset* dataset = [datasource.datasets getWithName:datasetName];
            Layer* layer = [sMap.smMapWC.mapControl.map.layers addDataset:dataset ToHead:true];
            
            if ([dataset datasetType] == REGION) {
                LayerSettingVector *setting = (LayerSettingVector*) layer.layerSetting;
                [[setting geoStyle] setLineSymbolID:5];
            }
            if ([dataset datasetType] == REGION || [dataset datasetType] == RegionZ) {
                LayerSettingVector *setting = (LayerSettingVector*) layer.layerSetting;
                [[setting geoStyle] setFillForeColor:[[Color alloc] initWithR:255 G:192 B:103]];
                [[setting geoStyle] setLineColor:[[Color alloc] initWithR:255 G:192 B:103]];
            } else if ([dataset datasetType] == LINE || [dataset datasetType] == Network || [dataset datasetType] == NETWORK3D || [dataset datasetType] == LineZ) {
                LayerSettingVector *setting = (LayerSettingVector*) layer.layerSetting;
                [[setting geoStyle] setLineColor:[[Color alloc] initWithR:255 G:192 B:103]];
                if ([dataset datasetType] == Network || [dataset datasetType] == NETWORK3D) {
                    [sMap.smMapWC.mapControl.map.layers addDataset:[(DatasetVector*)dataset childDataset] ToHead:true];
                }
            } else if ([dataset datasetType] == POINT || [dataset datasetType] == PointZ) {
                LayerSettingVector *setting = (LayerSettingVector*) layer.layerSetting;
                [[setting geoStyle] setLineColor:[[Color alloc] initWithR:255 G:192 B:103]];
            }
            
            [sMap.smMapWC.mapControl.map setIsVisibleScalesEnabled:false];
            [sMap.smMapWC.mapControl.map refresh];
            resolve([NSNumber numberWithBool:layer != nil]);
        }
        else{
            resolve([NSNumber numberWithBool:NO]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

#pragma mark 导出地图为工作空间
// strMapName 地图名字（不含后缀）
// ofModule 模块名（默认传空）
// isPrivate 是否是用户数据
// exportWorkspacePath 导出的工作空间绝对路径（含后缀）
RCT_REMAP_METHOD(exportWorkspaceByMap, exportWorkspaceByMap:(NSString*)strMapName exportWorkspacePath:(NSString *)exportWorkspacePath withParams:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        sMap = [SMap singletonInstance];
        // 先把地图导入大工作空间
        BOOL openResult = [sMap.smMapWC openMapName:strMapName toWorkspace:sMap.smMapWC.workspace withParam:params];
        BOOL exportResult = NO;
        if (openResult) {
            // 先把地图导出
            NSArray* exportMaps = [NSArray arrayWithObject:strMapName];
            exportResult = [sMap.smMapWC exportMapNamed:exportMaps toFile:exportWorkspacePath isReplaceFile:YES extra:nil];
            
            // 关闭所有地图
            Maps* maps = sMap.smMapWC.workspace.maps;
            [maps clear];
            // 清除符号库
            [SMap.singletonInstance.smMapWC.workspace.resources.markerLibrary.rootGroup.childSymbolGroups removeGroupWith:strMapName isUpMove:NO];
            [SMap.singletonInstance.smMapWC.workspace.resources.lineLibrary.rootGroup.childSymbolGroups removeGroupWith:strMapName isUpMove:NO];
            [SMap.singletonInstance.smMapWC.workspace.resources.fillLibrary.rootGroup.childSymbolGroups removeGroupWith:strMapName isUpMove:NO];
            // 删除数据源
            [sMap.smMapWC.workspace.datasources closeAll];
        }
        
        resolve(@(exportResult));
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 导出工作空间
RCT_REMAP_METHOD(exportWorkspace, exportWorkspace:(NSArray*)arrMapnames toFile:(NSString*)strFileName fileReplace:(BOOL)bFileReplace extra:(NSDictionary*)extraDic resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        sMap = [SMap singletonInstance];
        BOOL result = [sMap.smMapWC exportMapNamed:arrMapnames toFile:strFileName isReplaceFile:bFileReplace extra:extraDic];
        
        resolve(@(result));
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 导出地图为xml
RCT_REMAP_METHOD(saveMapName, saveMapName:(NSString *)name ofModule:(NSString *)nModule withAddition:(NSDictionary *)withAddition isNew:(BOOL)isNew bResourcesModified:(BOOL)bResourcesModified isPrivate:(BOOL)isPrivate resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BOOL mapSaved = NO;
        sMap = [SMap singletonInstance];
        //        BOOL bNew = name == nil || [name isEqualToString:@""] || [sMap.smMapWC.workspace.maps indexOf:name] == -1;
        BOOL bNew = YES;
        Map* map = sMap.smMapWC.mapControl.map;
        if (map.name && ![map.name isEqualToString:@""]) {
            bNew = NO;
        }
        
        NSString* oldName = map.name;
        
        if (name == nil || [name isEqualToString:@""]) {
            if (map.name && ![map.name isEqualToString:@""]) {
                bNew = NO;
                mapSaved = [map save];
                name = map.name;
            } else if (map.layers.getCount > 0) {
                bNew = YES;
                Layer* layer = [map.layers getLayerAtIndex:map.layers.getCount - 1];
                name = layer.name;
                int i = 0;
                while (!mapSaved) {
                    name = i == 0 ? name : [NSString stringWithFormat:@"%@#%d", name, i];
                    mapSaved = [map save:name];
                    i++;
                }
            }
        } else {
            if ([name isEqualToString:map.name]) {
                bNew = NO;
                mapSaved = [map save];
                name = map.name;
            } else {
                bNew = YES;
                mapSaved = isNew ? [map saveAs:name] : [map save:name];
            }
        }
        //        BOOL bResourcesModified = sMap.smMapWC.workspace.maps.count > 1;
        NSString* mapName = @"";
        if (mapSaved) {
            mapName = [sMap.smMapWC saveMapName:name fromWorkspace:sMap.smMapWC.workspace ofModule:nModule withAddition:withAddition isNewMap:(isNew || bNew) isResourcesModyfied:bResourcesModified isPrivate:isPrivate];
        }
        
        // isNew为true，另存为后保证当前地图是原地图
        BOOL isOpen = NO;
        if (oldName && ![oldName isEqualToString:@""] && ![oldName isEqualToString:mapName] && isNew) {
            isOpen = [map open:oldName];
            if ([sMap.smMapWC.workspace.maps indexOf:mapName] >= 0) {
                isOpen = [map open:mapName];
            } else {
                [map saveAs:mapName];
            }
            if (isOpen && [sMap.smMapWC.workspace.maps indexOf:oldName] >= 0) {
                [sMap.smMapWC.workspace.maps removeMapName:oldName];
            }
            [map refresh];
        }
        
        resolve(mapName);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 导入文件工作空间到程序目录
RCT_REMAP_METHOD(importWorkspaceInfo, importWorkspaceInfo:(NSDictionary *)infoDic toModule:(NSString *)nModule isPrivate:(BOOL)isPrivate resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        sMap = [SMap singletonInstance];
        NSArray* mapsInfo = [sMap.smMapWC importWorkspaceInfo:infoDic toModule:nModule isPrivate:isPrivate];
        
        resolve(mapsInfo);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 大工作空间打开本地地图
RCT_REMAP_METHOD(openMapName, openMapName:(NSString*)strMapName withParams:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        sMap = [SMap singletonInstance];
        BOOL result = [sMap.smMapWC openMapName:strMapName toWorkspace:sMap.smMapWC.workspace withParam:params];
        
        resolve(@(result));
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 设置地图反走样式
RCT_REMAP_METHOD(setAntialias, setAntialias:(int)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        
        sMap = [SMap singletonInstance];
        [sMap.smMapWC.mapControl.map setIsAntialias:value];
        [sMap.smMapWC.mapControl.map refresh];
        resolve([NSNumber numberWithBool:true]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 获取是否反走样
RCT_REMAP_METHOD(isAntialias, isAntialias:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        bool result = [sMap.smMapWC.mapControl.map isAntialias];
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 设置固定比例尺
RCT_REMAP_METHOD(setVisibleScalesEnabled, setVisibleScalesEnabled:(int)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        [sMap.smMapWC.mapControl.map setIsVisibleScalesEnabled:value];
        [sMap.smMapWC.mapControl.map refresh];
        resolve([NSNumber numberWithBool:true]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 获取是否固定比例尺
RCT_REMAP_METHOD(isVisibleScalesEnabled, isVisibleScalesEnabled:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        bool result = [sMap.smMapWC.mapControl.map isVisibleScalesEnabled];
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 检查是否有打开的地图
RCT_REMAP_METHOD(isAnyMapOpened, isAnyMapOpened:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        int count = sMap.smMapWC.mapControl.map.layers.getCount;
        bool isAny = true;
        if (count <= 0) {
            isAny = false;
        }
        resolve([NSNumber numberWithBool:isAny]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 导入符号库
RCT_REMAP_METHOD(importSymbolLibrary, importSymbolLibraryWithPath:(NSString *)path isReplace:(BOOL)isReplace resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        BOOL result = [sMap.smMapWC appendFromFile:sMap.smMapWC.workspace.resources path:path isReplace:isReplace];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 把指定地图中的图层添加到当前打开地图中
RCT_REMAP_METHOD(addMap, addMap:(NSString *)srcMapName withParams:(NSDictionary *)params resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        BOOL result = [sMap.smMapWC addLayersFromMap:srcMapName toMap:sMap.smMapWC.mapControl.map withParam:params];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 批量添加图层
RCT_REMAP_METHOD(addLayers, addLayers:(NSArray*)datasetNames dataSourceName:(NSString*)dataSourceName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if (datasetNames == nil || datasetNames.count == 0 || [dataSourceName isEqualToString:@""] || dataSourceName == nil) {
            resolve([NSNumber numberWithBool:false]);
            return;
        }
        sMap = [SMap singletonInstance];
        Datasource* datasource = [sMap.smMapWC.workspace.datasources getAlias:dataSourceName];
        Layers* layers = sMap.smMapWC.mapControl.map.layers;
        
        NSMutableArray* dataset_Point = [[NSMutableArray alloc] init];
        NSMutableArray* dataset_Line = [[NSMutableArray alloc] init];
        NSMutableArray* dataset_Region = [[NSMutableArray alloc] init];
        NSMutableArray* dataset_Text = [[NSMutableArray alloc] init];
        NSMutableArray* dataset_Else = [[NSMutableArray alloc] init];
        NSInteger count = datasetNames.count;
        for (int i = 0; i < count; i++) {
            NSString* datasetName = [datasetNames objectAtIndex:i];
            Dataset* dataset = [datasource.datasets getWithName:datasetName];
            if (dataset.datasetType == REGION || dataset.datasetType == RegionZ) {
                [dataset_Region addObject:dataset];
            }
            else if (dataset.datasetType == LINE || dataset.datasetType == Network || dataset.datasetType == NETWORK3D|| dataset.datasetType == LineZ) {
                [dataset_Line addObject:dataset];
            }
            else if (dataset.datasetType == POINT || dataset.datasetType == PointZ) {
                [dataset_Point addObject:dataset];
            }
            else if (dataset.datasetType == TEXT) {
                [dataset_Text addObject:dataset];
            }
            else{
                [dataset_Else addObject:dataset];
            }
        }
        NSMutableArray* datasets = [[NSMutableArray alloc] init];
        [datasets addObjectsFromArray:dataset_Region];
        [datasets addObjectsFromArray:dataset_Line];
        [datasets addObjectsFromArray:dataset_Point];
        [datasets addObjectsFromArray:dataset_Text];
        [datasets addObjectsFromArray:dataset_Else];
        
        NSMutableArray* resultArr = [[NSMutableArray alloc] init];
        if (datasets.count > 0) {
            MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
            [[mapControl getEditHistory] addMapHistory];
            
            for (int i = 0; i < datasets.count; i++) {
                Layer* layer = [layers addDataset:[datasets objectAtIndex:i] ToHead:true];
                if (layer) {
                    NSMutableDictionary* layerInfo = [[NSMutableDictionary alloc] init];
                    [layerInfo setObject:layer.name forKey:@"layerName"];
                    [layerInfo setObject:layer.dataset.name forKey:@"datasetName"];
                    [layerInfo setObject:[NSNumber numberWithInt:layer.dataset.datasetType] forKey:@"datasetType"];
                    NSString* description = layer.dataset.description;
                    if ([description isEqualToString:@"NULL"]) {
                        description = @"";
                    }
                    [layerInfo setValue:description forKey:@"description"];
                    
                    [resultArr addObject:layerInfo];
                }
            }
            [mapControl.map refresh];
        }
        
        resolve(resultArr);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 设置是否压盖
RCT_REMAP_METHOD(setOverlapDisplayed, setOverlapDisplayed:(BOOL)value resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Map* map = sMap.smMapWC.mapControl.map;
        [map setIsOverlapDisplay:value];
        [map refresh];
        resolve([NSNumber numberWithBool:true]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 是否已经开启压盖
RCT_REMAP_METHOD(isOverlapDisplayed, isOverlapDisplayed:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Map* map = sMap.smMapWC.mapControl.map;
        bool result = [map IsOverlapDisplay];
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 显示全幅
RCT_REMAP_METHOD(viewEntire, viewEntireWithResolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Map* map = sMap.smMapWC.mapControl.map;
        [map viewEntire];
        [map refresh];
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 开启动态投影
RCT_REMAP_METHOD(setDynamicProjection, setDynamicProjectionWithResolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Map *map = sMap.smMapWC.mapControl.map;
        [map setDynamicProjection:YES];
        [map refresh];
        
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setDynamicProjection", exception.reason, nil);
    }
}
//addLayers, addLayers:(NSArray*)datasetNames dataSourceName:(NSString*)dataSourceName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject
#pragma mark 初始化标绘符号库
RCT_REMAP_METHOD(initPlotSymbolLibrary, initPlotSymbolLibrary:(NSArray*)plotSymbolPaths resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl* mapControl=sMap.smMapWC.mapControl;
        NSMutableArray* resultArr = [[NSMutableArray alloc] init];
        for (NSString* path in plotSymbolPaths) {
            int libId=[mapControl addPlotLibrary:path];
            [resultArr addObject:@(libId)];
        }
        resolve(resultArr);
    } @catch (NSException *exception) {
        reject(@"setDynamicProjection", exception.reason, nil);
    }
}

#pragma mark 设置标绘符号
RCT_REMAP_METHOD(setPlotSymbol, setPlotSymbol:(int)libId symbolCode:(int)symbolCode resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl* mapControl=sMap.smMapWC.mapControl;
        [mapControl setAction:CREATE_PLOT];
        [mapControl setPlotSymbol:libId symbolCode:symbolCode];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setDynamicProjection", exception.reason, nil);
    }
}

#pragma mark 添加cad图层
RCT_REMAP_METHOD(addCadLayer, addCadLayer:(NSString*)layerName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl* mapControl=sMap.smMapWC.mapControl;
        Layer* layer=[mapControl.map.layers getLayerWithName:layerName];
        if(!layer){
            DatasetVectorInfo* datasetVectorInfo=[[DatasetVectorInfo alloc] init];
            [datasetVectorInfo setDatasetType:CAD];
            [datasetVectorInfo setName:layerName];
            Dataset* datasetVector=[[sMap.smMapWC.workspace.datasources get:0].datasets getWithName:layerName];
            if(!datasetVector){
                datasetVector=[[sMap.smMapWC.workspace.datasources get:0].datasets create:datasetVectorInfo];
            }
            layer=[mapControl.map.layers addDataset:datasetVector ToHead:true];
            [mapControl.map.layers addLayer:layer];
        }
        [layer setEditable:YES];
        
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setDynamicProjection", exception.reason, nil);
    }
}


#pragma mark /************************************** 选择集操作 BEGIN****************************************/
#pragma mark 设置Selection样式
RCT_REMAP_METHOD(setSelectionStyle, setSelectionStyleWithLayerPath:(NSString *)path style:(NSString *)styleJson resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Layer* layer = [SMLayer findLayerByPath:path];
        Selection* selection = [layer getSelection];
        GeoStyle* style = [[GeoStyle alloc] init];
        [style fromJson:styleJson];
        [selection setStyle:style];
        
        [sMap.smMapWC.mapControl.map refresh];
        
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 清除Selection
RCT_REMAP_METHOD(clearSelection, clearSelectionWithResolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Layers* layers = sMap.smMapWC.mapControl.map.layers;
        for (int i = 0; i < layers.getCount; i++) {
            Selection* selection = [[layers getLayerAtIndex:i] getSelection];
            [selection clear];
            [selection dispose];
            
            [sMap.smMapWC.mapControl.map refresh];
        }
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark /************************************** 地图编辑历史操作 BEGIN****************************************/
#pragma mark 把对地图操作记录到历史
RCT_REMAP_METHOD(addMapHistory, addMapHistoryWithResolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl* mapControl = sMap.smMapWC.mapControl;
        [[mapControl getEditHistory] addMapHistory];
        
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 获取地图操作记录数量
RCT_REMAP_METHOD(getMapHistoryCount, getMapHistoryCountWithResolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl* mapControl = sMap.smMapWC.mapControl;
        int count = [[mapControl getEditHistory] getCount];
        
        resolve([NSNumber numberWithInt:count]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 获取当前地图操作记录index
RCT_REMAP_METHOD(getMapHistoryCurrentIndex, getMapHistoryCurrentIndexWithResolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl* mapControl = sMap.smMapWC.mapControl;
        int index = [[mapControl getEditHistory] getCurrentIndex];
        
        resolve([NSNumber numberWithInt:index]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 地图操作记录重做到index
RCT_REMAP_METHOD(redoWithIndex, redoWithIndex:(int)index resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl* mapControl = sMap.smMapWC.mapControl;
        BOOL result = [[mapControl getEditHistory] Redo:index];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 地图操作记录撤销到index
RCT_REMAP_METHOD(undoWithIndex, undoWithIndex:(int)index resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl* mapControl = sMap.smMapWC.mapControl;
        BOOL result = [[mapControl getEditHistory] Undo:index];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 地图操作记录移除两个index之间的记录
RCT_REMAP_METHOD(removeRange, removeRangeWithStartIndex:(int)start endIndex:(int)endIndex resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl* mapControl = sMap.smMapWC.mapControl;
        BOOL result = [[mapControl getEditHistory] RemoveRange:start count:endIndex];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 地图操作记录移除index位置的记录
RCT_REMAP_METHOD(remove, removeWithIndex:(int)index resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl* mapControl = sMap.smMapWC.mapControl;
        BOOL result = [[mapControl getEditHistory] Remove:index];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 清除地图操作记录
RCT_REMAP_METHOD(clear, clearWithResolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl* mapControl = sMap.smMapWC.mapControl;
        BOOL result = [[mapControl getEditHistory] Clear];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

#pragma mark 地图裁剪
RCT_REMAP_METHOD(clipMap, clipMapWithPoints:(NSArray *)points layersInfo:(NSArray *)layersInfo saveAs:(NSString *)mapName nModule:(NSString *)nModule addition:(NSDictionary*)addition isPrivate:(BOOL)isPrivate resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if (points.count == 0) {
            reject(@"clipMap", @"points can not be empty!", nil);
        } else {
            Point2Ds* point2Ds = [[Point2Ds alloc] init];
            for (NSDictionary* point in points) {
                NSNumber* x = [point objectForKey:@"x"];
                NSNumber* y = [point objectForKey:@"y"];
                
                CGPoint point = CGPointMake(x.floatValue, y.floatValue);
                
                Point2D* point2D = [[SMap singletonInstance].smMapWC.mapControl.map pixelTomap:point];
                [point2Ds add:point2D];
            }
            GeoRegion* region = [[GeoRegion alloc] initWithPoint2Ds: point2Ds];
            
            sMap = [SMap singletonInstance];
            if ([mapName isEqualToString:@""]) {
                mapName = nil;
            }
            
            BOOL result = [sMap.smMapWC clipMap:sMap.smMapWC.mapControl.map withRegion:region parameters:layersInfo saveAs:&mapName];
            
            if (result) {
                if (mapName) {
                    mapName = [sMap.smMapWC saveMapName:mapName fromWorkspace:sMap.smMapWC.workspace ofModule:nModule withAddition:addition isNewMap:YES isResourcesModyfied:YES isPrivate:isPrivate];
                } else if (mapName == nil) {
                    mapName = @"";
                }
                resolve(@{
                          @"mapName": mapName,
                          @"result": [NSNumber numberWithBool:result],
                          });
            } else {
                reject(@"clipMap", @"Clip map failed!", nil);
            }
        }
    } @catch (NSException *exception) {
        reject(@"clipMap", exception.reason, nil);
    }
}
#pragma mark /************************************** 地图编辑历史操作 END****************************************/


#pragma mark /*************************************** 标注相关BEGIN******************************************/

#pragma mark 添加数据到指定字段
+(void) addFieldInfo:(DatasetVector *)dv Name:(NSString *)name FieldType:(FieldType)type Required:(BOOL)required Value:(NSString *)value Maxlength:(NSInteger)maxLength{
    FieldInfos *infos = [dv fieldInfos];
    if([infos getName:name]){
        [infos removeFieldName:name];
    }
    
    FieldInfo *newInfo = [[FieldInfo alloc]init];
    [newInfo setName:name];
    [newInfo setFieldType:type];
    [newInfo setMaxLength:maxLength];
    [newInfo setDefaultValue:value];
    [newInfo setRequired:required];
    [infos add:newInfo];
}

#pragma mark 新建标注数据集
RCT_REMAP_METHOD(newTaggingDataset, newTaggingDatasetWithName:(NSString *)Name Path:(NSString *)userpath resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Workspace *workspace =sMap.smMapWC.mapControl.map.workspace;
         NSString *labelName = [NSString  stringWithFormat:@"%@%@%@",@"Label_",userpath,@"#"];
        Datasource *opendatasource = [workspace.datasources getAlias:labelName];
        if(opendatasource == nil){
            DatasourceConnectionInfo *info = [[DatasourceConnectionInfo alloc]init];
            info.alias = labelName;
            info.engineType = ET_UDB;
            NSString *path = [NSString stringWithFormat: @"%@%@%@%@%@",NSHomeDirectory(),@"/Documents/iTablet/User/",userpath,@"/Data/Datasource/",labelName];
            info.server = path;
            Datasource *datasource = [workspace.datasources open:info];
            
            if(datasource != nil && [datasource.description isEqualToString: @"Label"]){
                Datasets *datasets = datasource.datasets;
                NSString *datasetName = [datasets availableDatasetName: Name];
                DatasetVectorInfo *datasetVectorInfo = [[DatasetVectorInfo alloc]init];
                [datasetVectorInfo setDatasetType:CAD];
                [datasetVectorInfo setEncodeType:NONE];
                [datasetVectorInfo setName:datasetName];
                DatasetVector *datasetVector = [datasets create:datasetVectorInfo];
                
                //创建数据集时创建好字段
                [SMap addFieldInfo:datasetVector Name:@"name" FieldType:FT_TEXT Required:NO Value:@"" Maxlength:255];
                [SMap addFieldInfo:datasetVector Name:@"remark" FieldType:FT_TEXT Required:NO Value:@"" Maxlength:255];
                [SMap addFieldInfo:datasetVector Name:@"address" FieldType:FT_TEXT Required:NO Value:@"" Maxlength:255];
                
                
                Dataset *ds = [datasets getWithName:datasetName];
                Map *map = sMap.smMapWC.mapControl.map;
                Layer *layer = [map.layers addDataset:ds ToHead:YES];
                
                [layer setEditable:YES];
                [datasetVectorInfo dispose];
                [datasetVector close];
                [info dispose];
                resolve(datasetName);
            }
        }else{
            Datasets *datasets = opendatasource.datasets;
            NSString *datasetName = [datasets availableDatasetName:Name];
            DatasetVectorInfo *datasetVectorInfo = [[DatasetVectorInfo alloc] init];
            [datasetVectorInfo setDatasetType:CAD];
            [datasetVectorInfo setEncodeType:NONE];
            [datasetVectorInfo setName:datasetName];
            
            DatasetVector *datasetVector = [datasets create:datasetVectorInfo];
            
            //创建数据集时创建好字段
            [SMap addFieldInfo:datasetVector Name:@"name" FieldType:FT_TEXT Required:NO Value:@"" Maxlength:255];
            [SMap addFieldInfo:datasetVector Name:@"remark" FieldType:FT_TEXT Required:NO Value:@"" Maxlength:255];
            [SMap addFieldInfo:datasetVector Name:@"address" FieldType:FT_TEXT Required:NO Value:@"" Maxlength:255];
            
            Dataset *ds = [datasets getWithName:datasetName];
            Map *map =sMap.smMapWC.mapControl.map;
            Layer *layer = [map.layers addDataset:ds ToHead:YES];
            
            [layer setEditable:YES];
            [datasetVectorInfo dispose];
            [datasetVector close];
            
            resolve(datasetName);
        }
    } @catch (NSException *exception) {
        reject(@"newTaggingDataset", exception.reason, nil);
    }
}

#pragma mark 删除标注数据集

RCT_REMAP_METHOD(removeTaggingDataset, removeTaggingDatasetWithName:(NSString *)Name Path:(NSString *)userpath resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        sMap = [SMap singletonInstance];
        Workspace *workspace =sMap.smMapWC.mapControl.map.workspace;
         NSString *labelName = [NSString  stringWithFormat:@"%@%@%@",@"Label_",userpath,@"#"];
        Datasource *opendatasource =[workspace.datasources getAlias:labelName];
        if(opendatasource == nil){
            DatasourceConnectionInfo *info = [[DatasourceConnectionInfo alloc]init];
            
            info.alias = labelName;
            info.engineType = ET_UDB;
            NSString *path = [NSString stringWithFormat: @"%@%@%@%@%@",NSHomeDirectory(),@"/Documents/iTablet/User/",userpath,@"/Data/Datasource/",labelName];
            info.server = path;
            
            Datasource *datasource = [workspace.datasources open:info];
            if(datasource != nil && [datasource.description isEqualToString:@"Label"]){
                Datasets *datasets = datasource.datasets;
                [datasets deleteName:Name];
            }
            resolve(@(YES));
        }else{
            Datasets *datasets = opendatasource.datasets;
            [datasets deleteName:Name];
            resolve(@(YES));
        }
    } @catch (NSException *exception) {
        reject(@"removeTaggingDataset",exception.reason,nil);
    }
    
}

#pragma mark 导入标注数据集

RCT_REMAP_METHOD(openTaggingDataset, openTaggingDatasetWithPath:(NSString *)userpath resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        sMap = [SMap singletonInstance];
        Workspace *workspace = sMap.smMapWC.mapControl.map.workspace;
         NSString *labelName = [NSString  stringWithFormat:@"%@%@%@",@"Label_",userpath,@"#"];
        Datasource *opendatasource =[workspace.datasources getAlias:labelName];
        if(opendatasource == nil){
            DatasourceConnectionInfo *info = [[DatasourceConnectionInfo alloc]init];
            info.alias = labelName;
            info.engineType = ET_UDB;
            NSString *path = [NSString stringWithFormat: @"%@%@%@%@%@",NSHomeDirectory(),@"/Documents/iTablet/User/",userpath,@"/Data/Datasource/",labelName];
            info.server = path;
            Datasource *datasource = [workspace.datasources open:info];
            if(datasource != nil){
                Datasets *datasets = datasource.datasets;
                Map *map = sMap.smMapWC.mapControl.map;
                for(int i = 0, count = datasets.count; i < count; i++){
                    Dataset *ds = [datasets get:i];
                    NSString* addname = [ds.name stringByAppendingFormat:@"@Label_%@#",userpath]; //getName()+"@Label_"+userpath+"#";
                    BOOL add = true;
                    Layers* maplayers = map.layers;
                    for(int j=0 ; j<[maplayers getCount];j++){
                        if([[maplayers getLayerAtIndex:j].caption isEqualToString:addname]){
                            add = false;
                        }
                    }
                    if(add) {
                        Layer* layer = [map.layers addDataset:ds ToHead:YES];// .add(ds, true);
                        layer.editable = false;// setEditable(false);
                        layer.visible = false;//(false);
                    }
                }
            }
            resolve(@(YES));
        }else {
            Datasets *datasets = opendatasource.datasets;
            Map *map = sMap.smMapWC.mapControl.map;
            for(int i = 0, count = datasets.count; i < count; i++){
                Dataset *ds = [datasets get:i];
                NSString* addname = [ds.name stringByAppendingFormat:@"@Label_%@#",userpath]; //getName()+"@Label_"+userpath+"#";
                BOOL add = true;
                Layers* maplayers = map.layers;
                for(int j=0 ; j<[maplayers getCount];j++){
                    if([[maplayers getLayerAtIndex:j].caption isEqualToString:addname]){
                        add = false;
                    }
                }
                if(add) {
                    Layer* layer = [map.layers addDataset:ds ToHead:YES];// .add(ds, true);
                    layer.editable = false;// setEditable(false);
                    layer.visible = false;//(false);
                }
            }
            resolve(@(YES));
        }
    } @catch (NSException *exception) {
        reject(@"openTaggingDataset",exception.reason,nil);
    }
}

#pragma mark 刷新地图
RCT_REMAP_METHOD(refreshMap, refreshMapWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        [sMap.smMapWC.mapControl.map refresh];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"refreshMap",exception.reason,nil);
    }
}
#pragma mark 获取默认标注
RCT_REMAP_METHOD(getDefaultTaggingDataset, getDefaultTaggingDatasetWithUserpath:(NSString *)userpath resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
        sMap = [SMap singletonInstance];
        Workspace *workspace = sMap.smMapWC.mapControl.map.workspace;
         NSString *labelName = [NSString  stringWithFormat:@"%@%@%@",@"Label_",userpath,@"#"];
        Datasource *opendatasource = [workspace.datasources getAlias:labelName];
        if(opendatasource == nil){
            NSString *datasetName = @"";
            Datasets *datasets = opendatasource.datasets;
            Layers *layers =sMap.smMapWC.mapControl.map.layers;
            BOOL isEditable = false;
            for(int i = 0, count = [layers getCount]; i < count; i++){
                if(!isEditable){
                    Layer *layer = [layers getLayerAtIndex:i];
                    for(int j = 0,dCount = datasets.count; j < dCount; j++){
                        Dataset *dataset = [datasets get:j];
                        if(layer.dataset == dataset){
                            if(layer.editable){
                                isEditable = YES;
                                datasetName = dataset.name;
                                break;
                            }
                        }
                    }
                }
            }
            resolve(datasetName);
        }
    }@catch(NSException *exception){
        reject(@"getDefaultTaggingDataset",exception.reason,nil);
    }
}

#pragma mark 判断是否有标注图层
RCT_REMAP_METHOD(isTaggingLayer, isTaggingLayerWithPath:(NSString *)userpath resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Workspace *workspace = sMap.smMapWC.mapControl.map.workspace;
        NSString *udbName = [NSString stringWithFormat: @"%@%@%@",@"Label_",userpath,@"#"];
        Datasource *opendatasource = [workspace.datasources getAlias:udbName];
        if(opendatasource != nil){
            Datasets *datasets = opendatasource.datasets;
            Layers *layers = sMap.smMapWC.mapControl.map.layers;
            BOOL isEditable = NO;
            for(int i = 0, count = [layers getCount]; i < count; i++){
                if(!isEditable){
                    Layer *layer = [layers getLayerAtIndex:i];
                    for(int j = 0,dCount = datasets.count; j < dCount; j++){
                        Dataset *dataset = [datasets get:j];
                        if(layer.dataset == dataset){
                            if(layer.editable){
                                isEditable = YES;
                            }
                        }
                    }
                }
            }
            resolve(@(isEditable));
        }
    } @catch (NSException *exception) {
        reject(@"Tagging",@"isTaggingLayer() Failed.",nil);
    }
    
}

#pragma mark 获取当前标注
RCT_REMAP_METHOD(getCurrentTaggingDataset, getCurrentTaggingDatasetWithName:(NSString *)name resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Map *map = sMap.smMapWC.mapControl.map;
        NSString *datasetName = @"";
        Layer *layer = [map.layers getLayerWithName:name];
        layer.visible = YES;
        layer.editable = YES;
        [map refresh];
        datasetName = layer.dataset.name;
        resolve(datasetName);
    } @catch (NSException *exception) {
        reject(@"getCurrentTaggingDataset",exception.reason,nil);
    }
    
}

#pragma mark 获取标注图层
RCT_REMAP_METHOD(getTaggingLayers, getTaggingLayersWithUserpath:(NSString *)userpath resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Workspace *workspace = sMap.smMapWC.mapControl.map.workspace;
         NSString *labelName = [NSString  stringWithFormat:@"%@%@%@",@"Label_",userpath,@"#"];
        Datasource *opendatasource = [workspace.datasources getAlias:labelName];
        if(opendatasource == nil){
            DatasourceConnectionInfo *info = [[DatasourceConnectionInfo alloc]init];
            info.alias = labelName;
            info.engineType = ET_UDB;
            NSString *path = [NSString stringWithFormat: @"%@%@%@%@%@",NSHomeDirectory(),@"/Documents/iTablet/User/",userpath,@"/Data/Datasource/",labelName];
            info.server = path;
            Datasource *datasource = [workspace.datasources open:info];
            if(datasource != nil && [datasource.description isEqualToString:@"Label"]){
                Datasets *datasets = datasource.datasets;
                Map *map = sMap.smMapWC.mapControl.map;
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                Layers *layers = map.layers;
                
                for(int i = 0, count = datasets.count; i < count; i++){
                    Dataset *ds = [datasets get:i];
                    for(int j = 0, len = [layers getCount]; j < len; j++){
                        Layer *layer = [layers getLayerAtIndex:j];
                        if(layer.dataset == ds){
                            NSMutableDictionary *dic = [SMLayer getLayerInfo:layer path:@""];
                            [arr addObject:dic];
                        }
                    }
                }
                resolve(arr);
            }
        }else{
            Datasets *datasets = opendatasource.datasets;
            Map *map = sMap.smMapWC.mapControl.map;
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            Layers *layers = map.layers;
            
            for(int i = 0, count = datasets.count; i < count; i++){
                Dataset *ds = [datasets get:i];
                for(int j = 0, len = [layers getCount]; j < len; j++){
                    Layer *layer = [layers getLayerAtIndex:j];
                    if(layer.dataset == ds){
                        NSMutableDictionary *dic = [SMLayer getLayerInfo:layer path:@""];
                        [arr addObject:dic];
                    }
                }
            }
            resolve(arr);
        }
    } @catch (NSException *exception) {
        reject(@"getTaggingLayers",exception.reason,nil);
    }
}

/**
 * 修改最新的属性值
 *
 */
+(void)modifyLastAttributeWithDatasets:(Dataset *)dataset FieldInfoName:(NSString *)fieldInfoName Value:(NSString *)value{
    if(dataset == nil || fieldInfoName == nil || value == nil || [value isEqualToString:@""]){
        return;
    }
    DatasetVector *dtVector = (DatasetVector *)dataset;
    Recordset *recordset = [dtVector recordset:NO cursorType:DYNAMIC];
    
    if(recordset == nil){
        return;
    }
    
    [recordset moveLast];
    BOOL b = [recordset edit];
    FieldInfos *fieldInfos = recordset.fieldInfos;
    if([fieldInfos indexOfWithFieldName:fieldInfoName] == -1){
        return;
    }
    [recordset setFieldValueWithString:fieldInfoName Obj:value];
    
    b = [recordset update];
    
    // [recordset close];
    [recordset dispose];
}
#pragma mark 添加数据集属性字段
RCT_REMAP_METHOD(addRecordset, addRecordsetWithDatasetName:(NSString *)datasetName FieldInfoName:(NSString *)fieldInfoName Value:(NSString *)value Path:(NSString *)userpath Resolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    
    @try {
        sMap = [SMap singletonInstance];
        Workspace *workspace = sMap.smMapWC.mapControl.map.workspace;
         NSString *labelName = [NSString  stringWithFormat:@"%@%@%@",@"Label_",userpath,@"#"];
        Datasource *opendatasource = [workspace.datasources getAlias:labelName];
        
        if(opendatasource == nil){
            DatasourceConnectionInfo *info = [[DatasourceConnectionInfo alloc]init];
            info.alias = labelName;
            info.engineType = ET_UDB;
            NSString *path = [NSString stringWithFormat: @"%@%@%@%@%@",NSHomeDirectory(),@"/Documents/iTablet/User/",userpath,@"/Data/Datasource/",labelName];
            info.server = path;
            Datasource *datasource = [workspace.datasources open:info];
            
            if(datasource != nil && [datasource.description isEqualToString:@"Label"]){
                Datasets *datasets = datasource.datasets;
                DatasetVector *dataset = (DatasetVector *)[datasets getWithName:datasetName];
                [SMap modifyLastAttributeWithDatasets:dataset FieldInfoName:fieldInfoName Value:value];
            }
            [info dispose];
            resolve(@(YES));
        }else{
            Datasets *datasets = opendatasource.datasets;
            DatasetVector *dataset = (DatasetVector *)[datasets getWithName:datasetName];
            [SMap modifyLastAttributeWithDatasets:dataset FieldInfoName:fieldInfoName Value:value];
            resolve(@(YES));
        }
    } @catch (NSException *exception) {
        reject(@"addRecordset",exception.reason,nil);
    }
}
#pragma mark 获取图层标题列表及对应的数据集类型
RCT_REMAP_METHOD(getLayersNames, getLayersNamesWithResolver:(RCTPromiseResolveBlock)resolve rejector:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Layers *layers = sMap.smMapWC.mapControl.map.layers;
        int count = [layers getCount];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for(int i = 0; i < count; i++){
            NSString *caption = [[layers getLayerAtIndex:i] caption];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            //获取数据集类型
            DatasetType type = [layers getLayerAtIndex:i].dataset.datasetType;
            NSString *datasetType = @"";
            if(type == POINT){
                datasetType = @"POINT";
            }else if(type == LINE){
                datasetType = @"LINE";
            }else if(type == REGION){
                datasetType = @"REGION";
            }else if(type == Grid){
                datasetType = @"GRID";
            }else if(type == TEXT){
                datasetType = @"TEXT";
            }else if(type == IMAGE){
                datasetType = @"IMAGE";
            }else{
                datasetType = [NSString stringWithFormat:@"%d",type];
            }
            
            [dic setObject:caption forKey:@"title"];
            [dic setObject:datasetType forKey:@"datasetType"];
            [arr addObject:dic];
        }
        resolve(arr);
    } @catch (NSException *exception) {
        reject(@"getLayersNames",exception.reason,nil);
    }
}
RCT_REMAP_METHOD(getTaggingLayerCount, getTaggingLayerCountWithPath:(NSString *)userpath Resolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Workspace *workspace = sMap.smMapWC.mapControl.map.workspace;
        NSString *alias = [[NSString alloc] initWithFormat:@"%@%@%@",@"Label_",userpath,@"#"];
        Datasource *datasource = [workspace.datasources getAlias:alias];
        if(datasource != nil){
            Datasets *datasets = datasource.datasets;
            NSNumber *count = [NSNumber numberWithInteger:datasets.count];
            resolve(count);
        }
    } @catch (NSException *exception) {
        reject(@"getTaggingLayerCount",exception.reason,nil);
    }
}

#pragma mark 设置最小比例尺范围
RCT_REMAP_METHOD(setMinVisibleScale, setMinVisibleScaleWithName:(NSString *)name Number:(double)number Resolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    @try{
        sMap = [SMap singletonInstance];
        Layer *layer =[sMap.smMapWC.mapControl.map.layers getLayerWithName:name];
        double scale = 1 / number;
        [layer setMinVisibleScale:scale];
        resolve(@(YES));
    }@catch(NSException *exception){
        reject(@"setMinVisibleScale",exception.reason,nil);
    }
}
#pragma mark 添加文字标注
RCT_REMAP_METHOD(addTextRecordset, addTextRecordsetWithDataName:(NSString *)dataname Name:(NSString *)name Path:(NSString *)userpath X:(int)x Y:(int)y Resolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Point2D *p =[sMap.smMapWC.mapControl.map pixelTomap:CGPointMake(x, y)];
        Workspace *workspace = sMap.smMapWC.mapControl.map.workspace;
        NSString *labelName = [NSString  stringWithFormat:@"%@%@%@",@"Label_",userpath,@"#"];
        Datasource *opendatasource = [workspace.datasources getAlias:labelName];
        Datasets *datasets = opendatasource.datasets;
        DatasetVector *dataset =(DatasetVector *)[datasets getWithName:dataname];
        [dataset setReadOnly:NO];
        Recordset *recordset = [dataset recordset:NO cursorType:DYNAMIC];
        TextPart *textpart = [[TextPart alloc]init];
        TextStyle *textStyle = [[TextStyle alloc]init];
        [textStyle setFontWidth:5];
        [textStyle setFontHeight:6];
        [textStyle setForeColor:[[Color alloc]initWithR:0 G:0 B:0]];
        [textpart setAnchorPoint:p];
        [textpart setText:name];
        GeoText *geoText = [[GeoText alloc]init];
        [geoText addPart:textpart];
        [geoText setTextStyle:textStyle];
        [recordset addNew:geoText];
        [recordset update];
        NSMutableArray *ids = [[NSMutableArray alloc]init];
        [ids addObject:[NSNumber numberWithInteger:recordset.ID]];
        [recordset close];
        [geoText dispose];
        [recordset dispose];
        
        Recordset *recordset1 = [dataset queryWithID:ids Type:DYNAMIC];
        [[sMap.smMapWC.mapControl getEditHistory] BatchBegin];
        [[sMap.smMapWC.mapControl getEditHistory] addHistoryType:EHT_AddNew recordset:recordset1 isCurrentOnly:YES];
        [[sMap.smMapWC.mapControl getEditHistory] BatchEnd];
        [recordset1 close];
        [recordset1 dispose];
        
        [sMap.smMapWC.mapControl.map refresh];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"addTextRecordset",exception.reason,nil);
    }
}


+(NSMutableArray *) getFillColors{
    if(fillColors == nil){
        fillColors = [[NSMutableArray alloc]init];
        [fillColors addObject:[[Color alloc] initWithR:224 G:207 B:226]];
        [fillColors addObject:[[Color alloc] initWithR:151 G:191 B:242]];
        [fillColors addObject:[[Color alloc] initWithR:242 G:242 B:186]];
        [fillColors addObject:[[Color alloc] initWithR:190 G:255 B:232]];
        [fillColors addObject:[[Color alloc] initWithR:255 G:190 B:232]];
        [fillColors addObject:[[Color alloc] initWithR:255 G:190 B:190]];
        [fillColors addObject:[[Color alloc] initWithR:255 G:235 B:175]];
        [fillColors addObject:[[Color alloc] initWithR:233 G:255 B:190]];
        [fillColors addObject:[[Color alloc] initWithR:234 G:225 B:168]];
        [fillColors addObject:[[Color alloc] initWithR:174 G:241 B:176]];
    }
    
    return fillColors;
}

+(Color *)getFillColor{
    Color *result = [[Color alloc] initWithR:255 G:192 B:203];
    int n = arc4random()%([SMap getFillColors].count);
    if(n >= [[SMap getFillColors] count]){
        n = 0;
    }
    result = [[SMap getFillColors] objectAtIndex:n];
    return result;
}

#pragma mark 设置标注面随机色
RCT_REMAP_METHOD(setTaggingGrid, setTaggingGridWithName:(NSString *)name UserPath:(NSString *)userpath Resolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        mapControl = sMap.smMapWC.mapControl;
        Workspace *workspace = sMap.smMapWC.mapControl.map.workspace;
        NSString *labelName = [NSString  stringWithFormat:@"%@%@%@",@"Label_",userpath,@"#"];
        Datasource *opendatasource = [workspace.datasources getAlias:labelName];
        dataset = (DatasetVector *)[[opendatasource datasets] getWithName:name];
        geoStyle = [[GeoStyle alloc]init];
        [geoStyle setFillForeColor:[SMap getFillColor]];
        [geoStyle setFillBackColor:[SMap getFillColor]];
        [geoStyle setMarkerSize: [[Size2D alloc] initWithWidth:10 Height:10]];
        [geoStyle setLineColor: [[Color alloc] initWithR:80 G:80 B:80]];
        [geoStyle setFillOpaqueRate:50]; //透明度
        if(dataset != nil){
            mapControl.geometryAddedDelegate = self;
        }
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setTaggingGrid",exception.reason,nil);
    }
}

#pragma mark 设置标注默认的结点，线，面颜色
RCT_REMAP_METHOD(setLabelColor, setLabelColorWithResolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl *mapControl = sMap.smMapWC.mapControl;
        [mapControl setStrokeColor: [[Color alloc] initWithValue:0x3999FF]];
        [mapControl setStrokeWidth:1];
        
        GeoStyle *geoStyle_P = [[GeoStyle alloc] init];
        
        Workspace *workspace = mapControl.map.workspace;
        Resources *m_resources = workspace.resources;
        SymbolMarkerLibrary *symbol_m = [m_resources markerLibrary];
        
        if([symbol_m containID:332]){
            [geoStyle_P setMarkerSymbolID:332];
            [mapControl setNodeStyle:geoStyle_P];
        }else if([symbol_m containID:313]){
            [geoStyle_P setMarkerSymbolID:313];
            [mapControl setNodeStyle:geoStyle_P];
        }else if([symbol_m containID:321]){
            [geoStyle_P setMarkerSymbolID:321];
            [mapControl setNodeStyle:geoStyle_P];
        }else {
            [mapControl setNodeColor:[[Color alloc] initWithValue:0x3999FF]];
            [mapControl setNodeSize:2.0];
        }
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setLabelColor",exception.reason,nil);
    }
}

#pragma mark /************************************************ 监听事件 ************************************************/
#pragma mark 监听事件
/*
 * 对象添加事件代理
 */
-(void)aftergeometryAddedCallBack:(GeometryArgs*)geometryArgs{
    
    NSArray *ids =[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:geometryArgs.id], nil];
    Recordset *recordset = [dataset queryWithID:ids Type:DYNAMIC];
    if(recordset != nil){
        [recordset moveFirst];
        [recordset edit];
        Geometry *geometry = recordset.geometry;
        if(geometry != nil){
            [geometry setStyle:geoStyle];
            [recordset setGeometry:geometry];
            [recordset update];
            [recordset dispose];
        }
    }
    mapControl.geometryAddedDelegate = nil;
}

-(void) boundsChanged:(Point2D*) newMapCenter{
    double x = newMapCenter.x;
    NSNumber* nsX = [NSNumber numberWithDouble:x];
    double y = newMapCenter.y;
    NSNumber* nsY = [NSNumber numberWithDouble:y];
    [self sendEventWithName:MAP_BOUNDS_CHANGED
                       body:@{@"x":nsX,
                              @"y":nsY
                              }];
}

-(void) scaleChanged:(double)newscale{
    sMap = [SMap singletonInstance];
    sMap.scaleViewHelper.mScaleLevel =[sMap.scaleViewHelper getScaleLevel];
    sMap.scaleViewHelper.mScaleText = [sMap.scaleViewHelper getScaleText:sMap.scaleViewHelper.mScaleLevel];
    sMap.scaleViewHelper.mScaleWidth = [sMap.scaleViewHelper getScaleWidth:sMap.scaleViewHelper.mScaleLevel];
    double width = sMap.scaleViewHelper.mScaleWidth;///[[[NSNumber alloc]initWithFloat:] doubleValue];
   // width = width * 100 / 70;
//    if(sMap.scaleViewHelper.mScaleText){
//
//    }
    [self sendEventWithName:MAP_SCALEVIEW_CHANGED
                        body:@{@"width":[NSNumber numberWithDouble:width],
                                @"title":sMap.scaleViewHelper.mScaleText
                                }];
   
}

- (void)longpress:(CGPoint)pressedPos{
    CGFloat x = pressedPos.x;
    CGFloat y = pressedPos.y;
    NSNumber* nsX = [NSNumber numberWithFloat:x];
    NSNumber* nsY = [NSNumber numberWithFloat:y];
    [self sendEventWithName:MAP_LONG_PRESS
                       body:@{@"x":nsX,
                              @"y":nsY
                              }];
}

- (void)onDoubleTap:(CGPoint)onDoubleTapPos{
    CGFloat x = onDoubleTapPos.x;
    CGFloat y = onDoubleTapPos.y;
    NSNumber* nsX = [NSNumber numberWithFloat:x];
    NSNumber* nsY = [NSNumber numberWithFloat:y];
    [self sendEventWithName:MAP_DOUBLE_TAP
                       body:@{@"x":nsX,
                              @"y":nsY
                              }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    CGFloat x = point.x;
    CGFloat y = point.y;
    NSNumber* nsX = [NSNumber numberWithFloat:x];
    NSNumber* nsY = [NSNumber numberWithFloat:y];
    [self sendEventWithName:MAP_TOUCH_BEGAN
                       body:@{@"x":nsX,
                              @"y":nsY
                              }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    CGFloat x = point.x;
    CGFloat y = point.y;
    NSNumber* nsX = [NSNumber numberWithFloat:x];
    NSNumber* nsY = [NSNumber numberWithFloat:y];
    
    [self sendEventWithName:MAP_TOUCH_END
                       body:@{@"x":nsX,
                              @"y":nsY
                              }];
}

-(void)onSingleTap:(CGPoint)onSingleTapPos{
    CGFloat x = onSingleTapPos.x;
    CGFloat y = onSingleTapPos.y;
    NSNumber* nsX = [NSNumber numberWithFloat:x];
    NSNumber* nsY = [NSNumber numberWithFloat:y];
    [self sendEventWithName:MAP_SINGLE_TAP
                       body:@{@"x":nsX,
                              @"y":nsY
                              }];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch1 = [touches anyObject];
    CGPoint startPoint = [touch1 locationInView:[touch1 view]];
    CGFloat x = startPoint.x;
    CGFloat y = startPoint.y;
    NSNumber* nsX = [NSNumber numberWithFloat:x];
    NSNumber* nsY = [NSNumber numberWithFloat:y];
    
    [self sendEventWithName:MAP_SCROLL
                       body:@{@"local":@{@"x":nsX,@"y":nsY}
                              }];
}

-(void)geometrySelected:(int)geometryID Layer:(Layer*)layer{
    NSNumber* nsId = [NSNumber numberWithInt:geometryID];
    //    NSInteger nsLayer = (NSInteger)layer;
    NSMutableDictionary *layerInfo = [[NSMutableDictionary alloc] init];
    [layerInfo setObject:layer.name forKey:@"name"];
    [layerInfo setObject:layer.caption forKey:@"caption"];
    [layerInfo setObject:[NSNumber numberWithBool:layer.editable] forKey:@"editable"];
    [layerInfo setObject:[NSNumber numberWithBool:layer.visible] forKey:@"visible"];
    [layerInfo setObject:[NSNumber numberWithBool:layer.selectable] forKey:@"selectable"];
    [layerInfo setObject:[NSNumber numberWithInteger:layer.dataset.datasetType] forKey:@"type"];
    [layerInfo setObject:[SMLayer getLayerPath:layer] forKey:@"path"];
    
    //    Recordset* r = [layer.getSelection.getDataset recordset:NO cursorType:STATIC];
    //    NSMutableDictionary* dic = [NativeUtil recordsetToDictionary:r count:0 size:1];
    //    [SMap singletonInstance].selection = [layer getSelection];
    
    [self sendEventWithName:MAP_GEOMETRY_SELECTED body:@{@"layerInfo":layerInfo,
                                                         @"id":nsId,
                                                         }];
}

-(void)geometryMultiSelected:(NSArray*)layersAndIds{
    NSMutableArray* layersIdAndIds = [[NSMutableArray alloc] init];
    for (id layerAndId in layersAndIds) {
        if ([layerAndId isKindOfClass:[NSArray class]] && [layerAndId[0] isKindOfClass:[Layer class]]) {
            Layer* layer = layerAndId[0];
            Dataset* dataset = layer.dataset;
            int type = (int)dataset.datasetType;
            NSMutableDictionary *layerInfo = [[NSMutableDictionary alloc] init];
            [layerInfo setObject:layer.name forKey:@"name"];
            [layerInfo setObject:[NSNumber numberWithBool:layer.editable] forKey:@"editable"];
            [layerInfo setObject:[NSNumber numberWithBool:layer.visible] forKey:@"visible"];
            [layerInfo setObject:[NSNumber numberWithBool:layer.selectable] forKey:@"selectable"];
            [layerInfo setObject:[SMLayer getLayerPath:layer] forKey:@"path"];
            [layerInfo setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
            
            NSMutableDictionary* layerData = [[NSMutableDictionary alloc] init];
            [layerData setObject:layerInfo forKey:@"layerInfo"];
            [layerData setObject:layerAndId[1] forKey:@"ids"];
            
            [layersIdAndIds addObject:layerData];
        }
    }
    [self sendEventWithName:MAP_GEOMETRY_MULTI_SELECTED body:@{@"geometries":(NSArray*)layersIdAndIds}];
}

//-(void)measureState{
//
//}

@end

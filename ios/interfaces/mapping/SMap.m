//
//  SMap.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/26.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "SMap.h"
#import "FileUtils.h"
#import "SuperMap/AnimationManager.h"
#import "SuperMap/AnimationGroup.h"
#import "SuperMap/AnimationGO.h"
#import "SuperMap/GeoGraphicObject.h"
#import "SuperMap/AnimationBlink.h"
#import "SuperMap/AnimationAttribute.h"
#import "SuperMap/AnimationShow.h"
#import "SuperMap/AnimationRotate.h"
#import "SuperMap/AnimationScale.h"
#import "SuperMap/AnimationGrow.h"
#import "SuperMap/AnimationWay.h"
#import "SuperMap/Point3D.h"
#import "SuperMap/GeoLine.h"
#import "SuperMap/DynamicView.h"
#import "SuperMap/DynamicElement.h"
#import "SuperMap/DynamicPoint.h"
#import "SuperMap/RecycleLicenseManager.h"
#import "SuperMap/LogInfoService.h"
#import "KeychainUtil.h"
#import "SuperMap/Scenes.h"
static SMap *sMap = nil;
//static NSInteger *fillNum;
static NSMutableArray *fillColors;
//static NSMutableArray *calloutArr;
static Point2Ds *animationWayPoint2Ds;
static Point2Ds *animationWaySavePoint2Ds;
//导航相关数据源
//static Datasource *IndoorDatasource;

static Datasource *incrementDatasource;
static NSString *incrementLineDatasetName;
static NSString *incrementNetworkDatasetName;
static BOOL incrementLayerAdded = NO;
//是否是起点
static BOOL isStart;
//Gps点
Point2Ds *GpsPoint2Ds;
NSString* KEYCHAIN_STORAGE_SERIAL_NUMBER_KEY=@"KEYCHAIN_STORAGE_SERIAL_NUMBER_KEY";
NSString* KEYCHAIN_STORAGE_SERIAL_MODULES_KEY=@"KEYCHAIN_STORAGE_SERIAL_MODULES_KEY";

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
             IS_FLOOR_HIDDEN,
             LEGEND_CONTENT_CHANGE,
             MAP_SCALEVIEW_CHANGED,
//             POINTSEARCH2D_KEYWORDS,
             MATCH_IMAGE_RESULT,
             NAVIGATION_WAYS,
             NAVIGATION_LENGTH,
             INDUSTRYNAVIAGTION,
             MAPSELECTPOINTNAMESTART,
             MAPSELECTPOINTNAMEEND,
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
    if(sMap.smMapWC.mapControl == nil){
        sMap.smMapWC.mapControl = mapControl;
    }
   // if( sMap.smMapWC.dynamicView == nil){
        dispatch_async(dispatch_get_main_queue(), ^{
            [sMap.smMapWC.dynamicView removeFromSuperview];
            sMap.smMapWC.dynamicView = nil;
            sMap.smMapWC.dynamicView = [[DynamicView alloc]initWithMapControl:mapControl];
//            sMap.smMapWC.dynamicView.backgroundColor = [[UIColor alloc] initWithRed:255 green:0 blue:0 alpha:0.5];
        });
   // }
    
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

RCT_REMAP_METHOD(setPOIOptimized, bPOIOptimized:(BOOL)bPOIOptimized setPOIOptimizedResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        sMap.smMapWC.mapControl.map.isPOIOptimized = bPOIOptimized;
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"SMap", exception.reason, nil);
    }
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
            if (sMap.smMapWC.mapControl.map) {
                [sMap.smMapWC.mapControl.map setWorkspace:sMap.smMapWC.workspace];
                if(sMap.smMapWC.mapControl.map.delegate == nil){
                    sMap.smMapWC.mapControl.map.delegate = self;
                }
                sMap.smMapWC.mapControl.map.isVisibleScalesEnabled = NO;
                //sMap.smMapWC.mapControl.isMagnifierEnabled = YES;
                sMap.smMapWC.mapControl.map.isAntialias = YES;
                [sMap.smMapWC.mapControl.map refresh];
            }
//            if(sMap.scaleViewHelper == nil){
//
//
//            }
        }
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

#pragma mark 设置地图旋转角度
RCT_REMAP_METHOD(setMapSlantAngle, setMapSlantAngleValue:(double)angle Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Map *map = sMap.smMapWC.mapControl.map;
        map.slantAngle = angle;
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
#pragma mark 获取放大镜是否开启
RCT_REMAP_METHOD(isMagnifierEnabled, isMagnifierEnabledWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        BOOL b = sMap.smMapWC.mapControl.isMagnifierEnabled;
        resolve(@(b));
    } @catch (NSException *exception) {
        reject(@"isMagnifierEnabled",exception.reason,nil);
    }
}
#pragma mark 设置放大镜是否开启
RCT_REMAP_METHOD(setIsMagnifierEnabled, setIsMagnifierEnabledWithValue:(BOOL)value Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        sMap.smMapWC.mapControl.isMagnifierEnabled = value;
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setIsMagnifierEnabled",exception.reason,nil);
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
        resolve(@{@"width":[NSNumber numberWithDouble:width],@"title":sMap.scaleViewHelper.mScaleText});
    } @catch (NSException *exception) {
        reject(@"getScaleData",exception.reason,nil);
    }
}
#pragma mark 添加图例的事件监听
RCT_REMAP_METHOD(addLegendListener, addLegendListenerWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        if(sMap.smMapWC.mapControl.map.legend.contentChangeDelegate == nil){
            sMap.smMapWC.mapControl.map.legend.contentChangeDelegate = self;
        }
        [sMap.smMapWC.mapControl.map refresh];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"addLegendDelegate",exception.reason,nil);
    }
}


-(void)legentContentChange:(NSArray*)arrItems{
    sMap = [SMap singletonInstance];
    NSMutableArray *legendSource = [[NSMutableArray alloc]init];
    for(int i = 0,count = arrItems.count; i < count; i++){
        NSData *data = UIImageJPEGRepresentation(arrItems[i][0], 1.0f);
        NSString *base64Str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSDictionary * temp = @{@"image":base64Str,@"title":arrItems[i][1],@"type":arrItems[i][2]};
        [legendSource addObject:temp];
    }
    [legendSource addObjectsFromArray:[sMap getOtherLegendData]];
    [self sendEventWithName:LEGEND_CONTENT_CHANGE body:legendSource];
}

-(NSArray *)getOtherLegendData{
    NSMutableArray *otherLegendData = [[NSMutableArray alloc]init];
    sMap = [SMap singletonInstance];
    Layers *layers = sMap.smMapWC.mapControl.map.layers;
    for (int i = 0; i < [layers getCount]; i++) {
        Layer *layer = [layers getLayerAtIndex:i];
        if(layer.theme != nil){
            if(layer.theme.themeType == TT_Range){
                ThemeRange *themeRange = (ThemeRange *)layer.theme;
                for(int j = 0; j < [themeRange getCount]; j++){
                    GeoStyle *geoStyle = [themeRange getItem:j].mStyle;
                    Color *color = [geoStyle getFillForeColor];
                    NSString *caption = [themeRange getItem:j].mCaption;
                    NSString *R = [[NSString alloc]initWithFormat:@"%02x",color.red];
                    NSString *G = [[NSString alloc]initWithFormat:@"%02x",color.green];
                    NSString *B = [[NSString alloc]initWithFormat:@"%02x",color.blue];
                    NSString *returnColor = [NSString stringWithFormat:@"%@%@%@%@",@"#",R,G,B];
                    NSDictionary * temp = @{@"color":returnColor,@"title":caption,@"type":@3};
                    [otherLegendData addObject:temp];
                }
            }
        }
    }
    return otherLegendData;
}

#pragma mark 移除图例的事件监听
RCT_REMAP_METHOD(removeLegendListener, removeLegendListenerWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        sMap.smMapWC.mapControl.map.legend.contentChangeDelegate = nil;
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"removeLegendListener",exception.reason,nil);
    }
}
#pragma mark ---------------------地图设置菜单结束---------------------

#pragma mark -------------------------导航模块开始---------------------------

#pragma mark 清除导航路线
RCT_REMAP_METHOD(clearTarckingLayer, clearTarckingLayerWithResolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        [sMap.smMapWC.mapControl.map.trackingLayer clear];
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
            naviPath = [[sMap.smMapWC.mapControl getNavigation2] getNaviPath];
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
            navipath = [[sMap.smMapWC.mapControl getNavigation2] getNaviPath];
        }
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for(int i = 0; i < navipath.count; i++){
            NaviStep *step = navipath[i];
            double getTime = step.time;
            int roadLength = step.length;
            int type = step.toSwerve;
            roadLength = (int)roadLength;
            NSDictionary *dic = @{@"roadName":[NSNumber numberWithDouble:getTime],
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

#pragma mark 路径分析
RCT_REMAP_METHOD(routeAnalyst, routeAnalystWithX:(double)x Y:(double)y resolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try{
        sMap = [SMap singletonInstance];
        Point2D *endPoint = [[Point2D alloc] initWithX:x Y:y];
        GPSData* gpsData = [NativeUtil getGPSData];
        Point2D* startPoint = [[Point2D alloc]initWithX:gpsData.dLongitude Y:gpsData.dLatitude];
        NavigationOnline *navigationOnline = [[NavigationOnline alloc]init];
        [navigationOnline setKey:@"fvV2osxwuZWlY0wJb8FEb2i5"];
        navigationOnline.delegate = self;
        NavigationOnlineParamater *params = [[NavigationOnlineParamater alloc]init];
        params.startPoint = startPoint;
        params.endPoint = endPoint;
        params.coordationType = NAVINFO_AMAP_MERCATOR;
        params.routeType = RE_COMMEND;
        [navigationOnline routeAnalyst:params];
        resolve(@(YES));
    }@catch(NSException *exception){
        reject(@"routeAnalyst",exception.reason,nil);
    }
}
#pragma mark 路径分析成功回调
-(void)caculateSuccess:(NavigationOnlineData*)data{
    if(data == nil)
        return;
    sMap = [SMap singletonInstance];
    MapControl *mapControl = sMap.smMapWC.mapControl;
    [mapControl.map.trackingLayer clear];
    
    GeoLine *geoline = data.route;
    GeoStyle *geostyle = [[GeoStyle alloc] init];
    Color *color = [[Color alloc] initWithR:0 G:191 B:255];
    [geostyle setLineSymbolID:15];
    [geostyle setLineColor:color];
    [geoline setStyle:geostyle];
    
    [mapControl.map.trackingLayer addGeometry:geoline WithTag:@"线路"];
    GPSData *gpsdata = [NativeUtil getGPSData];
    Point2D *pt = [[Point2D alloc] initWithX:gpsdata.dLongitude Y:gpsdata.dLatitude];
    if(mapControl.map.prjCoordSys.type != PCST_EARTH_LONGITUDE_LATITUDE){
        Point2Ds *points = [[Point2Ds alloc] init];
        [points add:pt];
        PrjCoordSys *sourcePrjCoordSys = [[PrjCoordSys alloc] initWithType:PCST_EARTH_LONGITUDE_LATITUDE];
        
        CoordSysTransParameter *coordSysTransParameter = [[CoordSysTransParameter alloc] init];
        [CoordSysTranslator convert:points PrjCoordSys:sourcePrjCoordSys PrjCoordSys:mapControl.map.prjCoordSys CoordSysTransParameter:coordSysTransParameter CoordSysTransMethod:MTH_GEOCENTRIC_TRANSLATION];
        pt = [points getItem:0];
        [SMap showMarkerHelper:pt tag:curLocationTag];
        
        NSArray *pathInfos = data.pathInfos;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for(int i = 0; i < pathInfos.count; i++){
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            NSDictionary *pathInfo = pathInfos[i];
            NSString *roadName = [pathInfo valueForKey:@"roadName"];
            int nextDirection = [[pathInfo valueForKey:@"nextDirection"] intValue];
            double roadLength = [[pathInfo valueForKey:@"roadLength"] doubleValue];
            [dic setObject:roadName forKey:@"roadName"];
            [dic setObject:[NSNumber numberWithInt:nextDirection] forKey:@"nextDirection"];
            [dic setObject:[NSNumber numberWithDouble: roadLength] forKey:@"roadLength"];
            [array addObject:dic];
        }
        NSDictionary *map = @{@"Length":data.length};
        [self sendEventWithName:NAVIGATION_WAYS
                           body:array];
        [self sendEventWithName:NAVIGATION_LENGTH
                           body:map];
    }
}
#pragma mark 路径分析失败回调
-(void)caculateFailed:(NSString *)errorInfo{
    NSLog(@"%@",errorInfo);
}
#pragma mark 设置行业导航参数
RCT_REMAP_METHOD(startNavigation, startNavigationWithNetworkDatasetName:(NSString *)networkDatasetName NetModel:(NSString *)netModelPath resolver: (RCTPromiseResolveBlock)resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Workspace *workspace = sMap.smMapWC.workspace;
        Datasources *datasources = workspace.datasources;
        for(int i = 0; i < [datasources count]; i++){
            Datasource *datasource = [datasources get:i];
            Dataset *dataset = [datasource.datasets getWithName:networkDatasetName];
            if(dataset != nil){
                DatasetVector *networkDataset = (DatasetVector *)dataset;
                Navigation2 *navigation2 = [sMap.smMapWC.mapControl getNavigation2];
                [navigation2 setNetworkDataset:networkDataset];
                [navigation2 loadModel:netModelPath];
                navigation2.navi2Delegate = self;
                [networkDataset close];
                resolve(@(YES));
            }
        }
    } @catch (NSException *exception) {
        reject(@"startNavigation",exception.reason,nil);
    }
}
#pragma mark 行业导航停止回调
-(void)navi2GuideStop{
    [SMap clearOutdoorPoint];
    [self sendEventWithName:INDUSTRYNAVIAGTION
                       body:@(YES)];
}
#pragma mark 行业导航 导航完成回调
-(void)navi2GuideArrive{
    [SMap clearOutdoorPoint];
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
        BOOL isOutdoorGuiding = [[mapControl getNavigation2] isGuiding];
        resolve(@(isIndoorGuiding || isOutdoorGuiding));
    } @catch (NSException *exception) {
        reject(@"isGuiding",exception.reason,nil);
    }
}
#pragma mark 行业导航路径分析
RCT_REMAP_METHOD(beginNavigation, beginNavigationWithX:(double)x Y:(double)y X2:(double)x2 Y2:(double)y2 resolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        MapControl *mapControl = [SMap singletonInstance].smMapWC.mapControl;
        Navigation2 *navigation2 = [mapControl getNavigation2];
        [navigation2 setStartPoint:x sPointY:y];
        [navigation2 setDestinationPoint:x2 dPointY:y2];
        [navigation2 setPathVisible:YES];
        BOOL isFind = [navigation2 routeAnalyst];
        [mapControl.map refresh];
        resolve(@(isFind));
    } @catch (NSException *exception) {
        reject(@"beginNavigation",exception.reason, nil);
    }
}

#pragma mark 进行行业导航
RCT_REMAP_METHOD(outdoorNavigation, outdoorNavigationWithBool:(BOOL)first resolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        MapControl *mapControl = [SMap singletonInstance].smMapWC.mapControl;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[mapControl getNavigation2] startGuide:1];
            [mapControl.map setIsFullScreenDrawModel:first];
            [[mapControl getNavigation2] setIsCarUpFront:first];
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
RCT_REMAP_METHOD(indoorNavigation, indoorNavigationWithBool:(BOOL)first resolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        MapControl *mapControl = [SMap singletonInstance].smMapWC.mapControl;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[mapControl getNavigation3] startGuide:1];
            [mapControl.map setIsFullScreenDrawModel:first];
            [[mapControl getNavigation3] setIsCarUpFront:first];
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
RCT_REMAP_METHOD(setCurrentFloorID, methodgetCurrentFloorIdWithId:(NSString *)floorID Resolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try{
        sMap = [SMap singletonInstance];
        sMap.smMapWC.floorListView.currentFloorId = floorID;
        resolve(@(YES));
    }@catch(NSException *exception){
        reject(@"setCurrentFloorID", exception.reason, nil);
    }
}

#pragma mark 获取当前楼层ID
RCT_REMAP_METHOD(getCurrentFloorID, methodgetCurrentFloorIDWithResolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try{
        sMap = [SMap singletonInstance];
        NSString *floorID = sMap.smMapWC.floorListView.currentFloorId;
        resolve(floorID);
    }@catch(NSException *exception){
        reject(@"getCurrentFloorID", exception.reason, nil);
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
            for(int j = 0; j < datasets.count; j++){
                Dataset *dataset = [datasets get:j];
                if(dataset.datasetType == Network){
                    NSDictionary *dic = @{
                                            @"name":dataset.name,
                                            @"datasourceName":datasource.alias,
                                        };
                    [array addObject:dic];
                }
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
            mapCenter = [SMap getPointWithX:mapCenter.x Y:mapCenter.y];
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
        }else{
            Point2D *point2d =[SMap getMapPointWithX:x Y:y];
            [SMap showPointByCalloutAtX:point2d.x Y:point2d.y PointName:@"startpoint"];
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
            Point2D *point2d =[SMap getMapPointWithX:x Y:y];
            [SMap showPointByCalloutAtX:point2d.x Y:point2d.y PointName:@"endpoint"];
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
            [[sMap.smMapWC.mapControl getNavigation2] cleanPath];
            [[sMap.smMapWC.mapControl getNavigation3] cleanPath];
            [SMap clearOutdoorPoint];
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
            [[sMap.smMapWC.mapControl getNavigation2] stopGuide];
            [[sMap.smMapWC.mapControl getNavigation3] stopGuide];
        });
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"stopGuide",exception.reason,nil);
    }
}

#pragma mark 判断起终点地理位置名称
RCT_REMAP_METHOD(getPointName, getPointNameWithX:(double)x Y:(double) y IsStart: (BOOL)isstart resolver: (RCTPromiseResolveBlock) resolve rejector: (RCTPromiseRejectBlock)reject){
    @try {
        isStart = isstart;
        Point2D *point2D = [[Point2D alloc] initWithX:x Y:y];
        Geocoding *reverseGeocoding = [[Geocoding alloc] init];
        [reverseGeocoding setKey:@"fvV2osxwuZWlY0wJb8FEb2i5"];
        reverseGeocoding.delegate = self;
        [reverseGeocoding reverseGeocoding:point2D];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"getPointName",exception.reason,nil);
    }
}

#pragma mark 逆地理编码成功回调
-(void)reversegeocodingSuccess:(GeocodingData*)geocodingData{
    if(isStart){
        [self sendEventWithName: MAPSELECTPOINTNAMESTART body:geocodingData.formatedAddress];
    }else{
        [self sendEventWithName: MAPSELECTPOINTNAMEEND body:geocodingData.formatedAddress];
    }
}
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
        infoCallout.backgroundColor = [UIColor redColor];
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

#pragma mark -------------------------导航模块结束---------------------------

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

//#pragma mark 初始化二维搜索
//RCT_REMAP_METHOD(initPointSearch, initPointSearchWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        sMap = [SMap singletonInstance];
//        sMap.poiSearchHelper2D = [POISearchHelper2D singletonInstance];
//        [sMap.poiSearchHelper2D initMapControl:sMap.smMapWC.mapControl];
//        sMap.poiSearchHelper2D.delegate =self;
//        resolve(@(YES));
//    } @catch (NSException *exception) {
//        reject(@"initPointSearch",exception.reason,nil);
//    }
//}
//#pragma mark 二维搜索
//RCT_REMAP_METHOD(pointSearch, pointSearchWithString:(NSString *)str resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        [sMap.poiSearchHelper2D poiSearch:str];
//        resolve(@(YES));
//    } @catch (NSException *exception) {
//        reject(@"pointSearch",exception.reason,nil);
//    }
//}
#pragma mark 获取当前定位经纬度
RCT_REMAP_METHOD(getCurrentPosition, getCurrentPositionWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
        GPSData *gpsData= [NativeUtil getGPSData];
        resolve(@{
                  @"x":[NSNumber numberWithDouble:gpsData.dLongitude],
                  @"y":[NSNumber numberWithDouble:gpsData.dLatitude],
                  });
    }@catch(NSException *exception){
        reject(@"getCurrentPosition",exception.reason,nil);
    }
}
#pragma mark 获取地图中心点经纬度
RCT_REMAP_METHOD(getMapcenterPosition, getMapcenterPositionWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
        sMap = [SMap singletonInstance];
        MapControl *mapControl = sMap.smMapWC.mapControl;
        
        Point2D *mapCenter = mapControl.map.center;
        Point2Ds *points = [[Point2Ds alloc] init];
        [points add:mapCenter];
        
        PrjCoordSys *sourcePrjCoordSys = [[PrjCoordSys alloc] initWithType:PCST_EARTH_LONGITUDE_LATITUDE];
        CoordSysTransParameter *coordSysTransParameter = [[CoordSysTransParameter alloc] init];
        
        [CoordSysTranslator convert:points PrjCoordSys:mapControl.map.prjCoordSys PrjCoordSys:sourcePrjCoordSys CoordSysTransParameter:coordSysTransParameter CoordSysTransMethod:MTH_GEOCENTRIC_TRANSLATION];
        Point2D *point = [points getItem:0];
        resolve(@{
                  @"x":[NSNumber numberWithDouble:point.x],
                  @"y":[NSNumber numberWithDouble:point.y]
                  });
    }@catch(NSException *exception){
        reject(@"getCurrentPosition",exception.reason,nil);
    }
}
#pragma mark 移除POI搜索的callout
RCT_REMAP_METHOD(removePOICallout, removePOICalloutWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
        sMap = [SMap singletonInstance];
        NSString *tagName = @"POISEARCH_2D_POINT";
        [sMap clearCalloutWithTagName:tagName];
        resolve(@(YES));
    }@catch(NSException *exception){
        reject(@"removePOICallout",exception.reason,nil);
    }
}
#pragma mark 移除周边搜索的callout
RCT_REMAP_METHOD(removeAllCallout, removeAllCalloutWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
        sMap = [SMap singletonInstance];
        dispatch_async(dispatch_get_main_queue(), ^{
            Map *map = sMap.smMapWC.mapControl.map;
            [sMap.smMapWC.dynamicView clear];
//            [mapControl removeCalloutWithArr:calloutArr];
//            calloutArr = nil;
            [map refresh];
        });

        resolve(@(YES));
    }@catch(NSException *exception){
        reject(@"removePOICallout",exception.reason,nil);
    }
}
#pragma mark 定位到搜索结果某个点
RCT_REMAP_METHOD(toLocationPoint, toLocationPointWithItem:(NSDictionary *)item resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        double x = [[item valueForKey:@"x"] doubleValue];
        double y =[[item valueForKey:@"y"] doubleValue];
        
        MapControl *mapcontrol = [SMap singletonInstance].smMapWC.mapControl;
        Point2D *mapPoint = [[Point2D alloc]initWithX:x Y:y];
        if(mapcontrol.map.prjCoordSys.type != PCST_EARTH_LONGITUDE_LATITUDE){
            Point2Ds *points = [[Point2Ds alloc] init];
            [points add:mapPoint];
            PrjCoordSys *sourcePrjCoordSys = [[PrjCoordSys alloc] initWithType:PCST_EARTH_LONGITUDE_LATITUDE];
            
            CoordSysTransParameter *coordSysTransParameter = [[CoordSysTransParameter alloc] init];
            [CoordSysTranslator convert:points PrjCoordSys:sourcePrjCoordSys PrjCoordSys:mapcontrol.map.prjCoordSys CoordSysTransParameter:coordSysTransParameter CoordSysTransMethod:MTH_GEOCENTRIC_TRANSLATION];
            mapPoint = [points getItem:0];
        }
        
        NSString *name = [item valueForKey:@"pointName"];
        NSString *tagName = @"POISEARCH_2D_POINT";
        [sMap clearCalloutWithTagName:tagName];
        BOOL isSuccess = [sMap addCalloutWithX:mapPoint.x Y:mapPoint.y Name:name TagName:tagName changeCenter:YES BigCallout:NO];
        if(mapcontrol.map.scale < 0.000011947150294723098)
            mapcontrol.map.scale = 0.000011947150294723098;
//        [mapcontrol panTo:mapPoint time:200];
        mapcontrol.map.center = mapPoint;
        [mapcontrol.map refresh];
        resolve(@(isSuccess));
    } @catch (NSException *exception) {
        reject(@"toLocationPoint",exception.reason,nil);
    }
}

//#pragma mark 当前选中的callout移动到地图中心
//RCT_REMAP_METHOD(setCalloutToMapCenter, setCalloutToMapCenter:(NSDictionary *)item resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        sMap = [SMap singletonInstance];
//        double x = [[item valueForKey:@"x"] doubleValue];
//        double y =[[item valueForKey:@"y"] doubleValue];
//        MapControl *mapcontrol = sMap.smMapWC.mapControl;
//        Point2D *point = [[Point2D alloc] initWithX:x Y:y];
//        Point2Ds *points = [[Point2Ds alloc] init];
//        [points add:point];
//        PrjCoordSys *sourcePrjCoordSys = [[PrjCoordSys alloc] initWithType:PCST_EARTH_LONGITUDE_LATITUDE];
//
//        CoordSysTransParameter *coordSysTransParameter = [[CoordSysTransParameter alloc] init];
//        [CoordSysTranslator convert:points PrjCoordSys:sourcePrjCoordSys PrjCoordSys:mapcontrol.map.prjCoordSys CoordSysTransParameter:coordSysTransParameter CoordSysTransMethod:MTH_GEOCENTRIC_TRANSLATION];
//        Point2D *mapPoint = [points getItem:0];
//        //移动无效
//        //[mapcontrol panTo:mapPoint time:1000];
//        mapcontrol.map.center = mapPoint;
//        [mapcontrol.map refresh];
//        resolve(@(YES));
//    } @catch (NSException *exception) {
//        reject(@"toLocationPoint",exception.reason,nil);
//    }
//}
// #pragma mark 将当前点击的callout特别标注
//RCT_REMAP_METHOD(setCenterCallout, setCenterCalloutWithItem:(NSDictionary *)item resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try{
//        sMap = [SMap singletonInstance];
//
//        double x = [[item valueForKey:@"x"] doubleValue];
//        double y = [[item valueForKey:@"y"] doubleValue];
//        NSString *name = @"";
//        NSString *tagName = @"bigCallout";
//        BOOL b = [sMap addCalloutWithX:x Y:y Name:name TagName:tagName changeCenter:YES BigCallout:YES];
//        resolve(@(b));
//    }@catch(NSException *exception){
//        reject(@"setCenterCallout",exception.reason,nil);
//    }
//}

#pragma mark 添加搜索到的callouts
RCT_REMAP_METHOD(addCallouts, addCalloutsWithArray:(NSArray *)pointList resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        //清除当前点
        [sMap clearCalloutWithTagName:@"POISEARCH_2D_POINT"];
        //最多添加10条
        int l = pointList.count < 10 ? pointList.count : 10;
        BOOL isSuccess = YES;
        

        Point2Ds* pts = [[Point2Ds alloc]init];
        for(int i = 0; i < l; i++){
            NSDictionary *dic = pointList[i];
            double x = [[dic valueForKey:@"x"] doubleValue];
            double y = [[dic valueForKey:@"y"] doubleValue];
            Point2D *mapPoint = [[Point2D alloc] initWithX:x Y:y];
            MapControl *mapcontrol = [SMap singletonInstance].smMapWC.mapControl;
            if(mapcontrol.map.prjCoordSys.type != PCST_EARTH_LONGITUDE_LATITUDE){
                Point2Ds *points = [[Point2Ds alloc] init];
                [points add:mapPoint];
                PrjCoordSys *sourcePrjCoordSys = [[PrjCoordSys alloc] initWithType:PCST_EARTH_LONGITUDE_LATITUDE];
                
                CoordSysTransParameter *coordSysTransParameter = [[CoordSysTransParameter alloc] init];
                [CoordSysTranslator convert:points PrjCoordSys:sourcePrjCoordSys PrjCoordSys:mapcontrol.map.prjCoordSys CoordSysTransParameter:coordSysTransParameter CoordSysTransMethod:MTH_GEOCENTRIC_TRANSLATION];
                mapPoint = [points getItem:0];
            }
            
            NSString *name = @"";
            NSString *tagName = [[NSString alloc] initWithFormat:@"%@%d",@"POISEARCH_2D_POINTS",i];
            BOOL b = [sMap addCalloutWithX:mapPoint.x Y:mapPoint.y Name:name TagName:tagName changeCenter:NO BigCallout:NO];
            if(!b){
                isSuccess = b;
            }else{
                [pts add:mapPoint];
            }
        }
        
        GeoRegion* geo = [[GeoRegion alloc]initWithPoint2Ds:pts];
        Rectangle2D* bounds = geo.getBounds;
//        [bounds inflateX:-bounds.width*0.2 Y:-bounds.height*0.4];
        sMap.smMapWC.mapControl.map.viewBounds = bounds;
        sMap.smMapWC.mapControl.map.scale = sMap.smMapWC.mapControl.map.scale*0.2;
        [sMap.smMapWC.mapControl.map refresh];
//        [sMap.smMapWC.mapControl zoomTo:sMap.smMapWC.mapControl.map.scale*0.8 time:200];
        [geo dispose];
        resolve(@(isSuccess));
    } @catch (NSException *exception) {
        reject(@"addCallouts",exception.reason,nil);
    }
}

#pragma mark 添加callout
/**  params
 * x 经度
 * y 纬度
 * name 要显示的文字
 * tagName callout标识符 可用于删除callout
 * changeCenter 是否设置地图中心点到当前经纬度
 * bigCallout 是否特别标注（绿色、加大）
 **/
-(BOOL)addCalloutWithX:(double)x Y:(double)y Name:(NSString *)name TagName:(NSString *)tagName changeCenter:(BOOL) change BigCallout:(BOOL)bigCallout{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        Point2D *mapPoint = [[Point2D alloc] initWithX:x Y:y];
        
        if( sMap.smMapWC.dynamicView == nil){
            sMap.smMapWC.dynamicView = [[DynamicView alloc]initWithMapControl:sMap.smMapWC.mapControl];
        }
    
        UIImage *image = [UIImage imageNamed:@"resources.bundle/icon_red.png"];
        DynamicPoint* dvPoint =  [[DynamicPoint alloc]init];
        [dvPoint addPoint:mapPoint];
        dvPoint.alignment = DYN_BOTTOM;
        dvPoint.textLableAlignment = DYN_RIGHT_TOP;
        dvPoint.name = name;
        dvPoint.nameHidden = false;
        dvPoint.tag = tagName;
        
        DynamicStyle* dynStyle =  [[DynamicStyle alloc]init];
        dynStyle.bitmap = image;
        dynStyle.width = 40;
        dynStyle.height = 40;
        dynStyle.radius = 20;
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.alignment = NSTextAlignmentLeft;
        paragraph.lineBreakMode = NSLineBreakByTruncatingTail;
        
        NSDictionary* attribute = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:15], NSParagraphStyleAttributeName: paragraph,NSForegroundColorAttributeName:[UIColor whiteColor],NSStrokeWidthAttributeName:@(-4),NSStrokeColorAttributeName:[UIColor blackColor]};
        
        dynStyle.textLableAttribute = attribute;
        dvPoint.style = dynStyle;
        
        [[SMap singletonInstance].smMapWC.dynamicView addElement:dvPoint];

    });
    return YES;
}

-(void)clearCalloutWithTagName:(NSString *)tagName{
    dispatch_async(dispatch_get_main_queue(), ^{
        MapControl *mapcontrol = [SMap singletonInstance].smMapWC.mapControl;
        [sMap.smMapWC.dynamicView removeElementWithTag:tagName];
        //[mapcontrol removeCalloutWithTag:tagName];
        [mapcontrol.map refresh];
    });
}

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
#pragma mark 判断当前数据源别名是否可用，返回可用别名
RCT_REMAP_METHOD(isAvilableAlias, isAvilableAliasWithAlias:(NSString*)alias resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Datasources *datasources = sMap.smMapWC.workspace.datasources;
        int index = 1;
        while ([datasources indexOf:alias] != -1) {
            alias = [NSString stringWithFormat:@"%@__%d",alias,index];
            index++;
        }
        resolve(alias);
    } @catch (NSException *exception) {
        reject(@"isAvaliableAlias",exception.reason,nil);
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
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [map refresh];
                });
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
RCT_REMAP_METHOD(setLayerFullView, setLayerFullView:(NSString*)layerPath setLayerFullViewResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
     @try{
         Map* map = sMap.smMapWC.mapControl.map;
//         Layer* layer =  [SMLayer findLayerByPath:layerPath];
         
         NSArray* paths = [layerPath componentsSeparatedByString:@"/"];
         Layer* layer =  [SMLayer findLayerByPath:paths[0]];
         
         Layers* layers = map.layers;
         NSMutableArray* layerArr = [[NSMutableArray alloc] init];
         for (int i = 0; i < [layers getCount]; i++) {
             Layer* temp = [layers getLayerAtIndex:i];
             if (temp.visible && ![temp.name isEqualToString:layer.name]) {
                 temp.visible = NO;
                 [layerArr addObject:temp];
             }
         }
         
         if ([layer isKindOfClass:[LayerGroup class]] && paths.count > 1) {
             NSString* tempPath = paths[1];
             for (int i = 2; i < paths.count; i++) {
                 tempPath = [NSString stringWithFormat:@"%@/%@", tempPath, paths[i]];
             }
             NSArray* tempArr = [SMMap setLayersInvisibleByGroup:(LayerGroup *)layer except:tempPath];
             layerArr = [[NSMutableArray alloc] initWithArray:[layerArr arrayByAddingObjectsFromArray:tempArr]];
         }
         
         [map viewEntire];
         for (int i = 0; i < layerArr.count; i++) {
             Layer* temp = layerArr[i];
             temp.visible = YES;
         }
         //sMap.smMapWC.mapControl.map.viewBounds
//         Rectangle2D* bounds = layer.dataset.bounds;
//         if(layer.dataset.prjCoordSys.type != map.prjCoordSys.type){
//             Point2Ds *points = [[Point2Ds alloc]init];
//             [points add:[[Point2D alloc]initWithX:bounds.left Y:bounds.top]];
//             [points add:[[Point2D alloc]initWithX:bounds.right Y:bounds.bottom]];
//             PrjCoordSys *srcPrjCoorSys = [[PrjCoordSys alloc]init];
//             [srcPrjCoorSys setType: layer.dataset.prjCoordSys.type];
//             CoordSysTransParameter *param = [[CoordSysTransParameter alloc]init];
//
//             //根据源投影坐标系与目标投影坐标系对坐标点串进行投影转换，结果将直接改变源坐标点串
//             [CoordSysTranslator convert:points PrjCoordSys:srcPrjCoorSys PrjCoordSys:[sMap.smMapWC.mapControl.map prjCoordSys] CoordSysTransParameter:param CoordSysTransMethod:(CoordSysTransMethod)9603];
//             Point2D* pt1 = [points getItem:0];
//             Point2D* pt2 = [points getItem:1];
//             bounds = [[Rectangle2D alloc]initWith:pt1.x bottom:pt2.y right:pt2.x top:pt1.y];
//         }
//
//         if(bounds.width <= 0 || bounds.height <= 0){
//             map.center = bounds.center;
//         } else {
//             sMap.smMapWC.mapControl.map.viewBounds = bounds;
//             [sMap.smMapWC.mapControl zoomTo:sMap.smMapWC.mapControl.map.scale*0.8 time:200];
//         }
         
         
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
        if(sMap.smMapWC.floorListView){
            [sMap.smMapWC.floorListView dispose];
            sMap.smMapWC.floorListView = nil;
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
            [dic setObject:name forKey:@"name"];
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

RCT_REMAP_METHOD(getLocalWorkspaceInfo, localurl: (NSString *) serverUrl
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {
    @try {
        Workspace * ws = [[Workspace alloc]init];
        WorkspaceConnectionInfo * wscInfo = [[WorkspaceConnectionInfo alloc]init];
        wscInfo.server = serverUrl;
        NSString * tempStr = [serverUrl lowercaseString];
        if([tempStr hasSuffix:@".smwu"]) {
            wscInfo.type = SM_SMWU;
        } else if([tempStr hasSuffix:@".sxwu"]) {
            wscInfo.type = SM_SXWU;
        }  else if([tempStr hasSuffix:@".smw"]) {
            wscInfo.type = SM_SMW;
        }  else if([tempStr hasSuffix:@".sxw"]) {
            wscInfo.type = SM_SXW;
        }
        
        NSMutableDictionary* workspaceInfos = [[NSMutableDictionary alloc] init];
        NSMutableArray *Maps = [[NSMutableArray alloc] init];
        NSMutableArray *Scenes = [[NSMutableArray alloc] init];
        NSMutableArray *datasources = [[NSMutableArray alloc] init];
        
        if([ws open:wscInfo]) {
            for(int i = 0; i < ws.maps.count; i++) {
                [Maps addObject:[ws.maps get:i]];
            }
            
            for(int i = 0; i < ws.scenes.count ; i++) {
                [Scenes addObject:[ws.scenes get:i]];
            }
            
            DatasourceConnectionInfo * dInfo = nil;
            for(int i = 0; i < ws.datasources.count; i++) {
                dInfo = [[ws.datasources get:i] datasourceConnectionInfo];
                if(dInfo.engineType == ET_UDB) {
                    NSMutableDictionary* datasourceInfo = [[NSMutableDictionary alloc] init];
                    [datasourceInfo setObject:dInfo.alias forKey:@"alias"];
                    [datasourceInfo setObject:dInfo.server forKey:@"server"];
                    [datasources addObject:datasourceInfo];
                }
            }
        }
        
        [workspaceInfos setObject:Maps forKey:@"maps"];
        [workspaceInfos setObject:Scenes forKey:@"scenes"];
        [workspaceInfos setObject:datasources forKey:@"datasources"];
        
        [ws close];
        [ws dispose];
        resolve(workspaceInfos);
    } @catch (NSException *exception) {
        reject(@"getLocalWorkspaceInfo", exception.reason, nil);
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

#pragma mark 获取MapControl的Action
RCT_REMAP_METHOD(getAction, getActionByActionTypeWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Action type = sMap.smMapWC.mapControl.action;
        resolve(@(type));
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
RCT_REMAP_METHOD(saveMap, saveMapWithName:(NSString *)name autoNaming:(BOOL)autoNaming saveWorkspace:(BOOL)saveWorkspace resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
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
        if (mapSaved && saveWorkspace) {
            wsSaved = [[SMap singletonInstance].smMapWC.workspace save];
        }
        
        if (mapSaved && (!saveWorkspace || wsSaved)) {
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
        BOOL result = YES;
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
        BOOL result = YES;
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
        Layer* layer = [SMLayer findLayerByPath:layerName];
//        Layer* layer = [mapControl.map.layers getLayerWithName:layerName];
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
            //保存地图后拷贝推演动画xml文件
            if(mapName){
                NSString *strUserName = nil;
                if (!isPrivate) {
                    strUserName = @"Customer";
                }else{
                    strUserName = [sMap.smMapWC getUserName];
                }
                NSString *strRootPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/iTablet/User"];
                NSString *strAnimationPath = [NSString stringWithFormat:@"%@/%@/Data/Animation",strRootPath,strUserName];
                NSString *fromPath=[NSString stringWithFormat:@"%@/%@",strAnimationPath,oldName];
                NSString *toPath=[NSString stringWithFormat:@"%@/%@",strAnimationPath,mapName];
                if([[NSFileManager defaultManager] fileExistsAtPath:fromPath]){
                    [sMap.smMapWC copyAnimationFileFrom:fromPath to:toPath toMapName:mapName];
                }
            }
        }
        
//        BOOL isOpen = NO;
        //另存地图 不对已打开地图做操作
        if (oldName && ![oldName isEqualToString:@""] && ![oldName isEqualToString:mapName] && isNew) {
            if ([sMap.smMapWC.workspace.maps indexOf:mapName] >= 0) {
                [sMap.smMapWC.workspace.maps removeMapName:mapName];
            }
//            [map close];
//            isOpen = [map open:oldName];
//            if ([sMap.smMapWC.workspace.maps indexOf:mapName] >= 0) {
//                isOpen = [map open:mapName];
//            } else {
//                [map saveAs:mapName];
//            }
//            if (isOpen && [sMap.smMapWC.workspace.maps indexOf:oldName] >= 0) {
//                [sMap.smMapWC.workspace.maps removeMapName:oldName];
//            }
        }
        
         [map refresh];
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
        
        [[sMap.smMapWC.mapControl getEditHistory] addMapHistory];
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
        
        Layer *layerWeb = nil;
        if(map.layers.getCount>1){
            Layer *layerTemp = [map.layers getLayerAtIndex:map.layers.getCount-1];
            if (layerTemp.dataset!=nil && layerTemp.dataset.datasource!=nil ) {
                EngineType engineType = layerTemp.dataset.datasource.datasourceConnectionInfo.engineType;
                switch (engineType) {
                    case ET_OGC:
                    case ET_SuperMapCloud:
                    case ET_GOOGLEMAPS:
                    case ET_REST:
                    case ET_BAIDU:
                    case ET_OPENSTREEMAPS:
                    case ET_BingMaps:
                    {
                        layerWeb = layerTemp;
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }
        
        if (layerWeb!=nil) {
            [layerWeb setVisible:false];
            [map viewEntire];
            [layerWeb setVisible:true];
        }
        else{
            [map viewEntire];
        }
        
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
//#pragma mark 初始化标绘符号库
//RCT_REMAP_METHOD(initPlotSymbolLibrary, initPlotSymbolLibrary:(NSArray*)plotSymbolPaths isFirst:(BOOL) isFirst newName:(NSString*)newName isDefaultNew:(BOOL)isDefaultNew resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//
//    @try {
//        sMap = [SMap singletonInstance];
//        Workspace *workspace =sMap.smMapWC.mapControl.map.workspace;
//
//        Dataset* dataset=nil;
//        Layer* cadLayer=nil;
//        NSString* userpath=nil;
//        NSString* Name=[@"PlotEdit_" stringByAppendingString:(isDefaultNew?newName:sMap.smMapWC.mapControl.map.name)];
//        NSArray *array = [plotSymbolPaths[0] componentsSeparatedByString:@"/"];
//        for (int i=0; i<array.count; i++) {
//            if([array[i] isEqualToString:@"User"]&&(i+1)<array.count){
//                userpath=array[i+1];
//                break;
//            }
//        }
//
//        NSString *plotDatasourceName = [NSString  stringWithFormat:@"%@%@%@",@"Plotting_",Name,@"#"];
//        plotDatasourceName = [plotDatasourceName stringByReplacingOccurrencesOfString:@"." withString:@""];
//        Datasource *opendatasource = [workspace.datasources getAlias:plotDatasourceName];
//        Datasource *datasource = nil;
//        if(opendatasource == nil){
//            DatasourceConnectionInfo *info = [[DatasourceConnectionInfo alloc]init];
//            info.alias = plotDatasourceName;
//            info.engineType = ET_UDB;
//            NSString *path = [NSString stringWithFormat: @"%@%@%@%@%@",NSHomeDirectory(),@"/Documents/iTablet/User/",userpath,@"/Data/Datasource/",plotDatasourceName];
//            info.server = path;
//            if([[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingString:@".udb"] ]){
//                 datasource = [workspace.datasources open:info];
//                if(!datasource){
//                    [[NSFileManager defaultManager] removeItemAtPath:[path stringByAppendingString:@".udb"] error:nil];
//                    [[NSFileManager defaultManager] removeItemAtPath:[path stringByAppendingString:@".udd"] error:nil];
//                    datasource=[workspace.datasources create:info];
//
//
//                }
//            }else{
//                datasource=[workspace.datasources create:info];
//            }
//
//            if(!datasource){
//                datasource=[workspace.datasources open:info];
//            }
//            [info dispose];
//        }else{
//            datasource=opendatasource;
//        }
//        if(!datasource){
//            resolve(nil);
//            return;
//        }
//        Datasets *datasets = datasource.datasets;
//
//        for (int i=0; i<[sMap.smMapWC.mapControl.map.layers getCount]; i++) {
//            Layer* tempLayer=[sMap.smMapWC.mapControl.map.layers getLayerAtIndex:i];
//            if([tempLayer.name hasPrefix:@"PlotEdit_"]&&tempLayer.dataset.datasetType==CAD){
//                dataset=tempLayer.dataset;
//                cadLayer=tempLayer;
////                break;
//            }else{
//                [tempLayer setEditable:NO];
//            }
//        }
//
////        dataset = [datasets getWithName:Name];
//        NSString* datasetName;
//        if(!dataset){
//            datasetName = [datasets availableDatasetName: Name];
//            DatasetVectorInfo *datasetVectorInfo = [[DatasetVectorInfo alloc]init];
//            [datasetVectorInfo setDatasetType:CAD];
//            [datasetVectorInfo setEncodeType:NONE];
//            [datasetVectorInfo setName:datasetName];
//            DatasetVector *datasetVector = [datasets create:datasetVectorInfo];
//            //创建数据集时创建好字段
//            [SMap addFieldInfo:datasetVector Name:@"name" FieldType:FT_TEXT Required:NO Value:@"" Maxlength:255];
//            [SMap addFieldInfo:datasetVector Name:@"remark" FieldType:FT_TEXT Required:NO Value:@"" Maxlength:255];
//            [SMap addFieldInfo:datasetVector Name:@"address" FieldType:FT_TEXT Required:NO Value:@"" Maxlength:255];
//
//            dataset = [datasets getWithName:datasetName];
//            Map *map = sMap.smMapWC.mapControl.map;
//            Layer *layer = [map.layers addDataset:dataset ToHead:YES];
//            [layer setEditable:YES];
//            [datasetVectorInfo dispose];
//            [datasetVector close];
//        }else{
//            [cadLayer setEditable:YES];
////            Layers *layers =sMap.smMapWC.mapControl.map.layers;
////            Layer *editLayer = [layers getLayerWithName:[NSString stringWithFormat:@"%@@%@",Name,datasource.alias]];
////            if(editLayer){
////                [editLayer setEditable:YES];
////            }else{
////                Layer* layer=[layers addDataset:dataset ToHead:true];
////                [layer setEditable:YES];
////            }
//        }
//
//        NSMutableDictionary* libInfo = [[NSMutableDictionary alloc] init];
//        for (NSString* path in plotSymbolPaths) {
//            int libId=[sMap.smMapWC.mapControl addPlotLibrary:path];
//            if(-1 != libId){
//                NSString* libName=[sMap.smMapWC.mapControl getPlotSymbolLibName: libId];
//                [libInfo setObject:@(libId) forKey:libName];
//            }
//
////            if(isFirst&&[libName isEqualToString:@"警用标号"]){
////                Point2Ds* point2Ds=[[Point2Ds alloc] init];
////                Point2D* point2D=[[Point2D alloc] initWithX:sMap.smMapWC.mapControl.map.viewBounds.left Y:sMap.smMapWC.mapControl.map.viewBounds.top];
////                [point2Ds add:point2D];
////                [sMap.smMapWC.mapControl addPlotObject:libId symbolCode:20100 point:point2Ds];
////                [sMap.smMapWC.mapControl cancel];
//////                Recordset *recordset = [(DatasetVector*)dataset recordset:NO cursorType:DYNAMIC];
//////                [recordset moveLast];
////////                [recordset delete];
//////                [recordset update];
//////                [recordset dispose];
////                [sMap.smMapWC.mapControl.map refresh];
////                [sMap.smMapWC.mapControl setAction:PAN];
////            }
//        }
////        if(isFirst){
////            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////                [self delay:dataset];
////            });
////        }
//
//        [sMap.smMapWC.mapControl.map refresh];
//        resolve(libInfo);
//    } @catch (NSException *exception) {
//        reject(@"initPlotSymbolLibrary", exception.reason, nil);
//    }
//}
//
////-(void)delay:(DatasetVector*)dataset {
////    Recordset *recordset = [(DatasetVector*)dataset recordset:NO cursorType:DYNAMIC];
////    [recordset moveLast];
////    [recordset delete];
////    [recordset update];
////    [recordset dispose];
////}
//#pragma mark 移除标绘库
//RCT_REMAP_METHOD(removePlotSymbolLibraryArr, removePlotSymbolLibraryArr:(NSArray*)plotSymbolIds resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        sMap = [SMap singletonInstance];
//        MapControl* mapControl=sMap.smMapWC.mapControl;
//        for (int i=0; i<[plotSymbolIds count]; i++) {
//            [mapControl removePlotLibrary:(int)plotSymbolIds[i]];
//        }
//        resolve(@(YES));
//    } @catch (NSException *exception) {
//        reject(@"removePlotSymbolLibraryArr", exception.reason, nil);
//    }
//}
//
//#pragma mark 设置标绘符号
//RCT_REMAP_METHOD(setPlotSymbol, setPlotSymbol:(int)libId symbolCode:(int)symbolCode resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        sMap = [SMap singletonInstance];
//        MapControl* mapControl=sMap.smMapWC.mapControl;
//
//        for (int i=0; i<[sMap.smMapWC.mapControl.map.layers getCount]; i++) {
//            Layer* tempLayer=[sMap.smMapWC.mapControl.map.layers getLayerAtIndex:i];
//            if([tempLayer.name hasPrefix:@"PlotEdit_"]&&tempLayer.dataset.datasetType==CAD){
//                [tempLayer setEditable:YES];
//            }else{
//                [tempLayer setEditable:NO];
//            }
//        }
//
//        [mapControl setAction:CREATE_PLOT];
//        [mapControl setPlotSymbol:libId symbolCode:symbolCode];
//        resolve(@(YES));
//    } @catch (NSException *exception) {
//        reject(@"setPlotSymbol", exception.reason, nil);
//    }
//}
//
//#pragma mark 导入标绘模板库
//RCT_REMAP_METHOD(importPlotLibData, importPlotLibData:(NSString*)fromPath  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//
//        NSString* userpath=nil;
//        NSArray *array = [fromPath componentsSeparatedByString:@"/"];
//        for (int i=0; i<array.count; i++) {
//            if([array[i] isEqualToString:@"User"]&&(i+1)<array.count){
//                userpath=array[i+1];
//                break;
//            }
//        }
//        NSString *toPath = [NSString stringWithFormat: @"%@%@%@%@",NSHomeDirectory(),@"/Documents/iTablet/User/",userpath,@"/Data/Plotting/"];
//        BOOL result=[FileUtils copyFiles:fromPath targetDictionary:toPath filterFileSuffix:@"plot" filterFileDicName:@"Symbol" otherFileDicName:@"SymbolIcon" isOnly:NO];
//
//        resolve([NSNumber numberWithBool:result]);
//    } @catch (NSException *exception) {
//        reject(@"importPlotLibData", exception.reason, nil);
//    }
//}
//
//
//#pragma mark 添加cad图层
//RCT_REMAP_METHOD(addCadLayer, addCadLayer:(NSString*)layerName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        sMap = [SMap singletonInstance];
//        MapControl* mapControl=sMap.smMapWC.mapControl;
//        Layer* layer=[mapControl.map.layers getLayerWithName:layerName];
//        if(!layer){
//            DatasetVectorInfo* datasetVectorInfo=[[DatasetVectorInfo alloc] init];
//            [datasetVectorInfo setDatasetType:CAD];
//            [datasetVectorInfo setName:layerName];
//            Dataset* datasetVector=[[sMap.smMapWC.workspace.datasources get:0].datasets getWithName:layerName];
//            if(!datasetVector){
//                datasetVector=[[sMap.smMapWC.workspace.datasources get:0].datasets create:datasetVectorInfo];
//            }
//            layer=[mapControl.map.layers addDataset:datasetVector ToHead:true];
//            [mapControl.map.layers addLayer:layer];
//        }
//        [layer setEditable:YES];
//
//        resolve(@(YES));
//    } @catch (NSException *exception) {
//        reject(@"addCadLayer", exception.reason, nil);
//    }
//}
//
//#pragma mark 态势推演定时器
//RCT_REMAP_METHOD(initAnimation,initAnimation:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//            //获取全局队列
//            dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//
//            //创建一个定时器，并将定时器的任务交给全局队列执行(并行，不会造成主线程阻塞)
//            dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
//
//            self.timer = timer;
//
//            //设置触发的间隔时间
//            dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
//
//            //设置定时器的触发事件
//            dispatch_source_set_event_handler(timer, ^{
//                [[AnimationManager getInstance] excute];
//
//            });
//
//            dispatch_resume(timer);
//        resolve(@(YES));
//    } @catch (NSException *exception) {
//        reject(@"addCadLayer", exception.reason, nil);
//    }
//}
//
//#pragma mark 读取态势推演xml文件
//RCT_REMAP_METHOD(readAnimationXmlFile,readAnimationXmlFile:(NSString*) filePath resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//
//        //获取全局队列
//        dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//
//        //创建一个定时器，并将定时器的任务交给全局队列执行(并行，不会造成主线程阻塞)
//        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
//
//        self.timer = timer;
//
//        //设置触发的间隔时间
//        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
//
//        //设置定时器的触发事件
//        dispatch_source_set_event_handler(timer, ^{
//            [[AnimationManager getInstance] excute];
//
//        });
//
//        dispatch_resume(timer);
//
//        sMap = [SMap singletonInstance];
//        MapControl* mapControl=sMap.smMapWC.mapControl;
//        [mapControl setAnimation];
//        [[AnimationManager getInstance] deleteAll];
//        [[AnimationManager getInstance] getAnimationFromXML:filePath];
//        resolve(@(YES));
//    } @catch (NSException *exception) {
//        reject(@"setDynamicProjection", exception.reason, nil);
//    }
//}
//
//#pragma mark 播放态势推演动画
//RCT_REMAP_METHOD(animationPlay,animationPlay:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        sMap = [SMap singletonInstance];
//        MapControl* mapControl=sMap.smMapWC.mapControl;
//        if([AnimationManager.getInstance getGroupCount]>0)
//        {
//            Rectangle2D* rectangle2D=[[Rectangle2D alloc] init];
//            AnimationGroup* animationGroup=[AnimationManager.getInstance getGroupByIndex:0];
//            int animationCount=[animationGroup getAnimationCount];
//            if(animationCount>0){
//                for(int i=0;i<animationCount;i++){
//                    AnimationGO* animationGo=[animationGroup getAnimationByIndex:i];
//                    NSString* layerName=[animationGo getLayerName];
//                    DatasetVector* dataset=(DatasetVector*)[mapControl.map.layers getLayerWithName:layerName].dataset;
//                    QueryParameter* queryParameter=[[QueryParameter alloc] init];
//                    [queryParameter setQueryIDs:[[NSArray alloc]initWithObjects:@([animationGo getGeometry]), nil]];
//                    [queryParameter setQueryType:IDS];
//                    Recordset* recordset=[dataset query:queryParameter];
//                    Geometry* geometry=[recordset geometry];
//                    if(geometry){
//                        if(i==0){
//                            rectangle2D=[[geometry getBounds] clone];
//                        }else{
//                            Rectangle2D* bounds=[geometry getBounds];
//                            if(bounds.left<rectangle2D.left){
//                                [rectangle2D setLeft:bounds.left];
//                            }
//                            if(bounds.right>rectangle2D.right){
//                                [rectangle2D setRight:bounds.right];
//                            }
//                            if(bounds.bottom<rectangle2D.bottom){
//                                [rectangle2D setBottom:bounds.bottom];
//                            }
//                            if(bounds.top>rectangle2D.top){
//                                [rectangle2D setTop:bounds.top];
//                            }
//                        }
////                        [rectangle2D unions:[geometry getBounds]];    组件接口方式有问题left和bottom一直为-1.7976931348623157E+308值不变
//                    }
//                }
//                double offsetX=(rectangle2D.right-rectangle2D.left)/6;
//                double offsetY=(rectangle2D.top-rectangle2D.bottom)/6;
//                [rectangle2D setLeft:rectangle2D.left-offsetX];
//                [rectangle2D setRight:rectangle2D.right+offsetX];
//                [rectangle2D setBottom:rectangle2D.bottom-offsetY*1.5];
//                [rectangle2D setTop:rectangle2D.top+offsetY*0.5];
//
//                [mapControl.map setViewBounds:rectangle2D];
//            }
//        }
////        double scale = mapControl.map.scale ;
////        mapControl.map.scale += 0.1;
////        [mapControl.map refresh];
////        mapControl.map.scale = scale;
//        [mapControl.map refresh];
////        [mapControl zoomTo:mapControl.map.scale*0.95 time:100];
////        [mapControl.map refresh];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [mapControl.map refresh];
//            [[AnimationManager getInstance] play];
//        });
//
//        resolve(@(YES));
//    } @catch (NSException *exception) {
//        reject(@"setDynamicProjection", exception.reason, nil);
//    }
//}
//
//#pragma mark 暂停态势推演动画
//RCT_REMAP_METHOD(animationPause,animationPause:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        [[AnimationManager getInstance] pause];
//        resolve(@(YES));
//    } @catch (NSException *exception) {
//        reject(@"setDynamicProjection", exception.reason, nil);
//    }
//}
//
//#pragma mark 复位态势推演动画
//RCT_REMAP_METHOD(animationReset,animationReset:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        [[AnimationManager getInstance] reset];
//        resolve(@(YES));
//    } @catch (NSException *exception) {
//        reject(@"setDynamicProjection", exception.reason, nil);
//    }
//}
//
//#pragma mark 停止态势推演动画
//RCT_REMAP_METHOD(animationStop,animationStop:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        [[AnimationManager getInstance] stop];
//        resolve(@(YES));
//    } @catch (NSException *exception) {
//        reject(@"setDynamicProjection", exception.reason, nil);
//    }
//}
//
//#pragma mark 关闭态势推演动画
//RCT_REMAP_METHOD(animationClose,animationClose:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        [[AnimationManager getInstance] stop];
//        [[AnimationManager getInstance] reset];
//        [[AnimationManager getInstance] deleteAll];
////        [[AnimationManager getInstance] deleteAnimationManager];
//        if(_timer){
//            dispatch_source_cancel(_timer);
//            _timer = nil;
//        }
//        resolve(@(YES));
//    } @catch (NSException *exception) {
//        reject(@"setDynamicProjection", exception.reason, nil);
//    }
//}
//
//#pragma mark 创建推演动画对象
//RCT_REMAP_METHOD(createAnimationGo,createAnimationGo:(NSDictionary *)createInfo newPlotMapName:(NSString*)newPlotMapName  resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        if (![createInfo objectForKey:@"animationMode"]) {
//            resolve(@(NO));
//            return;
//        }
//        sMap = [SMap singletonInstance];
//        MapControl* mapControl=sMap.smMapWC.mapControl;
//
//        NSString* animationGroupName=@"Create_Animation_Instance_#";   //动画动画组名，名称特殊，保证唯一
//        int count=[AnimationManager.getInstance getGroupCount];
//        //组件缺陷，group的count等于0调用getGroupByName还是能返回一个对象
////        AnimationGroup* animationGroup=[AnimationManager.getInstance getGroupByName:animationGroupName];
//        AnimationGroup* animationGroup;
//        if(count==0){
//            animationGroup=[AnimationManager.getInstance addAnimationGroup:animationGroupName];
//        }else{
//            animationGroup=[AnimationManager.getInstance getGroupByIndex:0];
//        }
//
//        NSNumber* animationMode=[createInfo objectForKey:@"animationMode"];
//        AnimationType type;
//        switch (animationMode.integerValue) {
//            case 0:
//                type=WayAnimation;
//                break;
//            case 1:
//                type=BlinkAnimation;
//                break;
//            case 2:
//                type=AttribAnimation;
//                break;
//            case 3:
//                type=ShowAnimation;
//                break;
//            case 4:
//                type=RotateAnimation;
//                break;
//            case 5:
//                type=ScaleAnimation;
//                break;
//            case 6:
//                type=GrowAnimation;
//                break;
//        }
//        AnimationGO* animationGo=[AnimationManager.getInstance createAnimation:type];
//
//        if(type==WayAnimation){
//            AnimationWay* animationWay=(AnimationWay*)animationGo;
//            Point3Ds* point3Ds=[[Point3Ds alloc] init];
//            if ([createInfo objectForKey:@"wayPoints"]) {
//                NSMutableArray* array=[createInfo objectForKey:@"wayPoints"];
//                for(int i=0;i<array.count;i++){
//                    NSDictionary* map=[array objectAtIndex:i];
//                    double x=[[map objectForKey:@"x"] doubleValue];
//                    double y=[[map objectForKey:@"y"] doubleValue];
//                    if ([mapControl.map.prjCoordSys type] != PCST_EARTH_LONGITUDE_LATITUDE) {//若投影坐标不是经纬度坐标则进行转换
//                        Point2Ds *points = [[Point2Ds alloc]init];
//                        [points add:[[Point2D alloc]initWithX:x Y:y]];
//                        PrjCoordSys *srcPrjCoorSys = [[PrjCoordSys alloc]init];
//                        [srcPrjCoorSys setType:PCST_EARTH_LONGITUDE_LATITUDE];
//                        CoordSysTransParameter *param = [[CoordSysTransParameter alloc]init];
//
//                        //根据源投影坐标系与目标投影坐标系对坐标点串进行投影转换，结果将直接改变源坐标点串
//                        [CoordSysTranslator convert:points PrjCoordSys:[mapControl.map prjCoordSys]  PrjCoordSys:srcPrjCoorSys CoordSysTransParameter:param CoordSysTransMethod:(CoordSysTransMethod)9603];
//                       x = [points getItem:0].x;
//                       y = [points getItem:0].y;
//                    }
//                    Point3D point3D = {x,y,0};
//                    [point3Ds addPoint3D:point3D];
//                    [animationWay addPathPt:point3D];
////                    [animationWay insertPathPt:0 pt:point3D];
//                }
//            }
//            [animationWay setTrackLineWidth:0.5];
//            [animationWay setPathType:0];
//            [animationWay setTrackLineColor:[[Color alloc] initWithR:255 G:0 B:0]];
//            [animationWay setPathTrackDir:YES];
//            animationWay.showPathTrack=YES;
//            animationGo=animationWay;
//        }else if(type==BlinkAnimation){
//            AnimationBlink* animationBlink=(AnimationBlink*)animationGo;
//            [animationBlink setBlinkNumberofTimes:20];
//            [animationBlink setBlinkStyle:1];
//            [animationBlink setBlinkAnimationReplaceStyle:1];
//            [animationBlink setBlinkAnimationReplaceColor:[[Color alloc] initWithR:0 G:0 B:255]];
//            animationGo=(AnimationGO*)animationBlink;
//        }else if(type==AttribAnimation){
//            AnimationAttribute* animationAttribute=(AnimationAttribute*)animationGo;
//            [animationAttribute setStartLineColor:[[Color alloc] initWithR:255 G:0 B:0]];
//            [animationAttribute setEndLineColor:[[Color alloc] initWithR:0 G:0 B:255]];
//            [animationAttribute setLineColorAttr:YES];
//            [animationAttribute setStartLineWidth:0];
//            [animationAttribute setEndLineWidth:1];
//            [animationAttribute setLineWidthAttr:YES];
//            animationGo=(AnimationGO*)animationAttribute;
//        }else if(type==ShowAnimation){
//            AnimationShow* animationShow=(AnimationShow*)animationGo;
//            [animationShow setShowEffect:NO];
//            [animationShow setShowState:YES];
//            animationGo=(AnimationGO*)animationShow;
//        }else if(type==RotateAnimation){
//            Point3D startPnt = {0,0,0};
//            Point3D endPnt = {720,720,0};
//            AnimationRotate* animationRotate=(AnimationRotate*)animationGo;
//            [animationRotate setStartangle:startPnt];
//            [animationRotate setEndAngle:endPnt];
//            animationGo=(AnimationGO*)animationRotate;
//
//        }else if(type==ScaleAnimation){
//            AnimationScale* animationScale=(AnimationScale*)animationGo;
//            [animationScale setStartScaleFactor:0];
//            [animationScale setEndScaleFactor:1];
//            animationGo=(AnimationGO*)animationScale;
//        }else if(type==GrowAnimation){
//            //默认是从0生成到1
//        }
//        //清空创建路径动画时的数据
//        [mapControl.map.trackingLayer clear];
//        animationWayPoint2Ds=nil;
//        animationWaySavePoint2Ds=nil;
//
//        if([createInfo objectForKey:@"startTime"]&&[animationGroup getAnimationCount]>0){
//            NSNumber* startTimeNumber=[createInfo objectForKey:@"startTime"];
//            double startTime=[startTimeNumber doubleValue];
//            if([createInfo objectForKey:@"startMode"]){
//                NSNumber* startMode=[createInfo objectForKey:@"startMode"];
//                AnimationGO* lastAnimationGO=[animationGroup getAnimationByIndex:([animationGroup getAnimationCount]-1)];
//                switch ([startMode intValue]) {
//                    case 1:
//                        startTime+=lastAnimationGO.startTime+lastAnimationGO.duration;
//                        break;
//                    case 2:
//                        break;
//                    case 3:
//                        startTime+=lastAnimationGO.startTime;
//                        break;
//                    default:
//                        break;
//                }
//            }
//            [animationGo setStartTime:startTime];
//        }else if([createInfo objectForKey:@"startTime"]&&[animationGroup getAnimationCount]==0){
//            NSNumber* startTimeNumber=[createInfo objectForKey:@"startTime"];
//             double startTime=[startTimeNumber doubleValue];
//            [animationGo setStartTime:startTime];
//        }
//        if([createInfo objectForKey:@"durationTime"]){
//            NSNumber* durationTimeNumber=[createInfo objectForKey:@"durationTime"];
//            double durationTime=[durationTimeNumber doubleValue];
//            [animationGo setDuration:durationTime];
//        }
//
//        NSString* mapName=mapControl.map.name;
//        if(!mapName||[mapName isEqualToString:@""]){
//            if(newPlotMapName&&![newPlotMapName isEqualToString:@""]){
//                mapName=newPlotMapName;
//            }else{
//                int layerCount=[mapControl.map.layers getCount];
//                if(layerCount>0){
//                    mapName=[mapControl.map.layers getLayerAtIndex:layerCount-1].name;
//                }
//            }
//            [mapControl.map save:mapName];
//        }
//
//        NSString* animationGoName=[NSString stringWithFormat:@"动画_%d",[[AnimationManager.getInstance getGroupByName:animationGroupName] getAnimationCount]];
//        if([createInfo objectForKey:@"layerName"]&&[createInfo objectForKey:@"geoId"]){
//            NSString* layerName=[createInfo objectForKey:@"layerName"];
//            int geoId=[[createInfo objectForKey:@"geoId"] intValue];
//            Layer* layer=[mapControl.map.layers getLayerWithName:layerName];
//            if(layer){
//                DatasetVector* dataset=(DatasetVector*)[mapControl.map.layers getLayerWithName:layerName].dataset;
//                QueryParameter* queryParameter=[[QueryParameter alloc] init];
//                [queryParameter setQueryIDs:[[NSArray alloc]initWithObjects:@(geoId), nil]];
//                [queryParameter setQueryType:IDS];
//                Recordset* recordset=[dataset query:queryParameter];
//                Geometry* geometry=[recordset geometry];
//                if(geometry){
//                    [animationGo setName:animationGoName];
//                    [animationGo setGeomtry:geometry mapControl:mapControl layer:layer.name];
//                    [animationGroup addAnimation:animationGo];
//                }
//            }
//        }
//        resolve(@(YES));
//    } @catch (NSException *exception) {
//        reject(@"setDynamicProjection", exception.reason, nil);
//    }
//}
//
//#pragma mark 保存推演动画
//RCT_REMAP_METHOD(animationSave,animationSave:(NSString*) savePath fileName:(NSString*)fileName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//
//        sMap = [SMap singletonInstance];
////        MapControl* mapControl=sMap.smMapWC.mapControl;
//        if(![[NSFileManager defaultManager] fileExistsAtPath:savePath]){
//            [[NSFileManager defaultManager] createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
//        }
////        NSString* mapName=mapControl.map.name;
//        NSString* tempPath=[NSString stringWithFormat:@"%@/%@.xml",savePath,fileName];
//        NSString* path=[FileUtils formateNoneExistFileName:tempPath isDir:false];
//        BOOL result=[AnimationManager.getInstance saveAnimationToXML:path];
//        [AnimationManager.getInstance reset];
//        [AnimationManager.getInstance deleteAll];
//
//        resolve(@(result));
//    } @catch (NSException *exception) {
//        reject(@"animationSave", exception.reason, nil);
//    }
//}
//
//#pragma mark 获取标号对象type
//RCT_REMAP_METHOD(getGeometryTypeById,getGeometryTypeById:(NSString*) layerName geoId:(int)geoId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//
//        sMap = [SMap singletonInstance];
//        MapControl* mapControl=sMap.smMapWC.mapControl;
//
//        int type=-1;
//        Layer* layer=[mapControl.map.layers getLayerWithName:layerName];
//        if(layer){
//            DatasetVector* dataset=(DatasetVector*)[mapControl.map.layers getLayerWithName:layerName].dataset;
//            QueryParameter* queryParameter=[[QueryParameter alloc] init];
//            [queryParameter setQueryIDs:[[NSArray alloc]initWithObjects:@(geoId), nil]];
//            [queryParameter setQueryType:IDS];
//            Recordset* recordset=[dataset query:queryParameter];
//            Geometry* geometry=[recordset geometry];
//            if(geometry){
//                GeoGraphicObject* geoGraphicObject=(GeoGraphicObject*)geometry;
//                type=[geoGraphicObject getSymbolType];
//            }
//        }
//        resolve(@(type));
//    } @catch (NSException *exception) {
//        resolve(@(-1));
////        reject(@"getGeometryTypeById", exception.reason, nil);
//    }
//}
//
//#pragma mark 添加路径动画点获取回退路径动画点
//RCT_REMAP_METHOD(addAnimationWayPoint,addAnimationWayPoint:(NSDictionary*)point isAdd:(BOOL)isAdd resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//
//        sMap = [SMap singletonInstance];
//        MapControl* mapControl=sMap.smMapWC.mapControl;
//
//        if(!isAdd){
//            if(!animationWayPoint2Ds||[animationWayPoint2Ds getCount]==0){
//                resolve([NSNumber numberWithBool:NO]);
//                return;
//            }else{
//                [animationWayPoint2Ds remove:[animationWayPoint2Ds getCount]-1];
//            }
//        }else{
//            int x=[[point objectForKey:@"x"] intValue];
//            int y=[[point objectForKey:@"y"] intValue];
//            CGPoint point1=CGPointMake(x, y);
//            Point2D* point2D=[mapControl.map pixelTomap:point1];
//            if(!animationWayPoint2Ds){
//                animationWayPoint2Ds=[[Point2Ds alloc] init];
//            }
//            [animationWayPoint2Ds add:point2D];
//        }
//        GeoStyle* style=[[GeoStyle alloc] init];
//        [style setMarkerSize:[[Size2D alloc] initWithWidth:10 Height:10]];
//        [style setLineColor:[[Color alloc] initWithR:225 G:105 B:0]];
////        [style setMarkerID:@"3614"];
//        {
//            [mapControl.map.trackingLayer clear];
//            if([animationWayPoint2Ds getCount]==1){
//                GeoPoint* geoPoint=[[GeoPoint alloc] initWithPoint2D:[animationWayPoint2Ds getItem:0]];
//                [geoPoint setStyle:style];
//                [mapControl.map.trackingLayer addGeometry:geoPoint WithTag:@"point"];
//            }else if([animationWayPoint2Ds getCount]>1){
//                GeoLine* geoline=[[GeoLine alloc] initWithPoint2Ds:animationWayPoint2Ds];
//                [geoline setStyle:style];
//                [mapControl.map.trackingLayer addGeometry:geoline WithTag:@"line"];
//            }
//            [mapControl.map refresh];
//        }
//
//        resolve([NSNumber numberWithBool:YES]);
//    } @catch (NSException *exception) {
//        reject(@"addAnimationWayPoint", exception.reason, nil);
//    }
//}
//
//#pragma mark 刷新路径动画点
//RCT_REMAP_METHOD(refreshAnimationWayPoint,refreshAnimationWayPoint:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//
//        sMap = [SMap singletonInstance];
//        MapControl* mapControl=sMap.smMapWC.mapControl;
//
//        if(!animationWaySavePoint2Ds||([animationWaySavePoint2Ds getCount]==0)){
//            animationWayPoint2Ds=nil;
//            [mapControl.map.trackingLayer clear];
//            resolve([NSNumber numberWithBool:YES]);
//            return;
//        }
//        animationWayPoint2Ds=[[Point2Ds alloc] initWithPoint2Ds:animationWaySavePoint2Ds];
//
//        GeoStyle* style=[[GeoStyle alloc] init];
//        [style setMarkerSize:[[Size2D alloc] initWithWidth:10 Height:10]];
//        [style setLineColor:[[Color alloc] initWithR:225 G:105 B:0]];
//        //        [style setMarkerID:@"3614"];
//        {
//            if([animationWayPoint2Ds getCount]==0){
//                [mapControl.map.trackingLayer clear];
//            }
//            else if([animationWayPoint2Ds getCount]==1){
//                [mapControl.map.trackingLayer clear];
//                GeoPoint* geoPoint=[[GeoPoint alloc] initWithPoint2D:[animationWayPoint2Ds getItem:0]];
//                [geoPoint setStyle:style];
//                [mapControl.map.trackingLayer addGeometry:geoPoint WithTag:@"point"];
//            }else if([animationWayPoint2Ds getCount]>1){
//                [mapControl.map.trackingLayer clear];
//                GeoLine* geoline=[[GeoLine alloc] initWithPoint2Ds:animationWayPoint2Ds];
//                [geoline setStyle:style];
//                [mapControl.map.trackingLayer addGeometry:geoline WithTag:@"line"];
//            }
//            [mapControl.map refresh];
//        }
//
//        resolve([NSNumber numberWithBool:YES]);
//    } @catch (NSException *exception) {
//        reject(@"refreshAnimationWayPoint", exception.reason, nil);
//    }
//}
//
//#pragma mark 取消路径动画，清除点
//RCT_REMAP_METHOD(cancelAnimationWayPoint,cancelAnimationWayPoint:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//
//        sMap = [SMap singletonInstance];
//        MapControl* mapControl=sMap.smMapWC.mapControl;
//
//        [mapControl.map.trackingLayer clear];
//        animationWayPoint2Ds=nil;
//        animationWaySavePoint2Ds=nil;
//        resolve([NSNumber numberWithBool:YES]);
//    } @catch (NSException *exception) {
//        reject(@"cancelAnimationWayPoint", exception.reason, nil);
//    }
//}
//
//#pragma mark 结束添加路径动画
//RCT_REMAP_METHOD(endAnimationWayPoint,endAnimationWayPoint:(BOOL)isSave resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//
//        sMap = [SMap singletonInstance];
//        MapControl* mapControl=sMap.smMapWC.mapControl;
//
//        if(!isSave){
//            [AnimationManager.getInstance deleteAll];
//            [mapControl.map.trackingLayer clear];
//            animationWayPoint2Ds=nil;
//            animationWaySavePoint2Ds=nil;
//            resolve([NSNumber numberWithBool:YES]);
//            return;
//        }
//        NSMutableArray* arr=[[NSMutableArray alloc] init];
//        if([animationWayPoint2Ds getCount]>0){
//            for(int i=0;i<[animationWayPoint2Ds getCount];i++){
//                NSDictionary* map=@{
//                                    @"x":[NSNumber numberWithDouble:[animationWayPoint2Ds getItem:i].x],
//                                    @"y":[NSNumber numberWithDouble:[animationWayPoint2Ds getItem:i].y],
//                                    };
//                [arr addObject:map];
//            }
//            animationWaySavePoint2Ds=[[Point2Ds alloc] initWithPoint2Ds:animationWayPoint2Ds];
//        }
//        resolve(arr);
//    } @catch (NSException *exception) {
//        reject(@"endAnimationWayPoint", exception.reason, nil);
//    }
//}
//
//#pragma mark 根据geoId获取已经创建的动画类型和数量
//RCT_REMAP_METHOD(getGeoAnimationTypes,getGeoAnimationTypes:(int)geoId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//
//        sMap = [SMap singletonInstance];
////        MapControl* mapControl=sMap.smMapWC.mapControl;
//
//        NSMutableArray* arr=[[NSMutableArray alloc] init];
//        for (int x=0; x<7; x++) {
//            [arr addObject:@(0)];
//        }
//
////        NSString* animationGroupName=@"Create_Animation_Instance_#";   //动画动画组名，名称特殊，保证唯一
//        int count=[AnimationManager.getInstance getGroupCount];
//        //组件缺陷，group的count等于0调用getGroupByName还是能返回一个对象
//        //        AnimationGroup* animationGroup=[AnimationManager.getInstance getGroupByName:animationGroupName];
//        AnimationGroup* animationGroup;
//        if(count==0){
//            resolve(arr);
//            return;
//        }else{
//            animationGroup=[AnimationManager.getInstance getGroupByIndex:0];
//        }
//        int size=[animationGroup getAnimationCount];
//        for (int i=0; i<size; i++) {
//            AnimationGO* animationGo=[animationGroup getAnimationByIndex:i];
//            int id=[animationGo getGeometry];
//            if(id==geoId){
//                int type=[animationGo getAnimationType];
//                int typeCount=[arr[type] intValue]+1;
//                [arr replaceObjectAtIndex:type withObject:@(typeCount)];
//            }
//        }
//        resolve(arr);
//    } @catch (NSException *exception) {
//        reject(@"getGeoAnimationTypes", exception.reason, nil);
//    }
//}
//
//#pragma mark 获取所有动画节点数据
//RCT_REMAP_METHOD(getAnimationNodeList,getAnimationNodeList:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//
//        sMap = [SMap singletonInstance];
//        //        MapControl* mapControl=sMap.smMapWC.mapControl;
//
//        NSMutableArray* arr=[[NSMutableArray alloc] init];
//
//        //        NSString* animationGroupName=@"Create_Animation_Instance_#";   //动画动画组名，名称特殊，保证唯一
//        int count=[AnimationManager.getInstance getGroupCount];
//        //组件缺陷，group的count等于0调用getGroupByName还是能返回一个对象
//        //        AnimationGroup* animationGroup=[AnimationManager.getInstance getGroupByName:animationGroupName];
//        AnimationGroup* animationGroup;
//        if(count==0){
//            resolve(arr);
//            return;
//        }else{
//            animationGroup=[AnimationManager.getInstance getGroupByIndex:0];
//        }
//        int size=[animationGroup getAnimationCount];
//        for (int i=0; i<size; i++) {
//            AnimationGO* animationGo=[animationGroup getAnimationByIndex:i];
//            NSDictionary* map=@{
//                                @"index":[NSNumber numberWithInt:i],
//                                @"name":animationGo.name
//                                };
//            [arr addObject:map];
//        }
//        resolve(arr);
//    } @catch (NSException *exception) {
//        reject(@"getAnimationNodeList", exception.reason, nil);
//    }
//}
//
//#pragma mark 删除动画节点
//RCT_REMAP_METHOD(deleteAnimationNode,deleteAnimationNode:(NSString*)nodeName resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//
//        sMap = [SMap singletonInstance];
//        //        MapControl* mapControl=sMap.smMapWC.mapControl;
//
//
//        //        NSString* animationGroupName=@"Create_Animation_Instance_#";   //动画动画组名，名称特殊，保证唯一
//        int count=[AnimationManager.getInstance getGroupCount];
//        //组件缺陷，group的count等于0调用getGroupByName还是能返回一个对象
//        //        AnimationGroup* animationGroup=[AnimationManager.getInstance getGroupByName:animationGroupName];
//        AnimationGroup* animationGroup;
//        if(count==0){
//            resolve([NSNumber numberWithBool:NO]);
//            return;
//        }else{
//            animationGroup=[AnimationManager.getInstance getGroupByIndex:0];
//        }
//        BOOL result=[animationGroup deleteAnimationByName:nodeName];
//        resolve([NSNumber numberWithBool:result]);
//    } @catch (NSException *exception) {
//        reject(@"deleteAnimationNode", exception.reason, nil);
//    }
//}
//
//#pragma mark 修改动画节点名称
//RCT_REMAP_METHOD(modifyAnimationNodeName,modifyAnimationNodeName:(int)index withNewName:(NSString*)newNodeName resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//
//        sMap = [SMap singletonInstance];
//        //        MapControl* mapControl=sMap.smMapWC.mapControl;
//
//        //        NSString* animationGroupName=@"Create_Animation_Instance_#";   //动画动画组名，名称特殊，保证唯一
//        int count=[AnimationManager.getInstance getGroupCount];
//        //组件缺陷，group的count等于0调用getGroupByName还是能返回一个对象
//        //        AnimationGroup* animationGroup=[AnimationManager.getInstance getGroupByName:animationGroupName];
//        AnimationGroup* animationGroup;
//        if(count==0){
//            resolve([NSNumber numberWithBool:NO]);
//            return;
//        }else{
//            animationGroup=[AnimationManager.getInstance getGroupByIndex:0];
//        }
//        AnimationGO* animationGo=[animationGroup getAnimationByIndex:index];
//        [animationGo setName:newNodeName];
//
//        resolve([NSNumber numberWithBool:YES]);
//    } @catch (NSException *exception) {
//        reject(@"getAnimationNodeList", exception.reason, nil);
//    }
//}
//
//#pragma mark 移动节点位置
//RCT_REMAP_METHOD(moveAnimationNode,moveAnimationNode:(int)index isUp:(BOOL)isUp resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//
//        sMap = [SMap singletonInstance];
//        //        MapControl* mapControl=sMap.smMapWC.mapControl;
//
//        NSString* animationGroupName=@"Create_Animation_Instance_#";   //动画动画组名，名称特殊，保证唯一
//        int count=[AnimationManager.getInstance getGroupCount];
//        //组件缺陷，group的count等于0调用getGroupByName还是能返回一个对象
//        //        AnimationGroup* animationGroup=[AnimationManager.getInstance getGroupByName:animationGroupName];
//        AnimationGroup* animationGroup;
//        AnimationGroup* tempGroup;
//        if(count==0){
//            resolve([NSNumber numberWithBool:NO]);
//            return;
//        }
//        animationGroup=[AnimationManager.getInstance getGroupByIndex:0];
//        int size=[animationGroup getAnimationCount];
//        if((isUp&&index==0)||(!isUp&&index==size-1)){
//            resolve([NSNumber numberWithBool:NO]);
//            return;
//        }
//        AnimationGO* tempAnimationGo;
//        int tempIndex=isUp?index-1:index;
//
//        NSString* tempGroupName=@"temp";
//        tempGroup=[AnimationManager.getInstance addAnimationGroup:tempGroupName];
//        for (int i=0; i<size; i++) {
//            AnimationGO* animationGo=[animationGroup getAnimationByIndex:i];
//            if(tempIndex==i){
//                NSString* xmlStr=[animationGo toXML];
//                tempAnimationGo=[AnimationManager.getInstance createAnimation:animationGo.getAnimationType];
//                [tempAnimationGo fromXML:xmlStr];
//
//                NSString* xmlStr2=[[animationGroup getAnimationByIndex:i+1] toXML];
//                AnimationGO* animationGo2=[AnimationManager.getInstance createAnimation:[animationGroup getAnimationByIndex:i+1].getAnimationType];
//                [animationGo2 fromXML:xmlStr2];
//
//                [tempGroup addAnimation:animationGo2];
//                [tempGroup addAnimation:tempAnimationGo];
//                i++;
//            }
//            else{
//                AnimationGO* animationGo2=[AnimationManager.getInstance createAnimation:animationGo.getAnimationType];
//                NSString* xmlStr=[animationGo toXML];
//                [animationGo2 fromXML:xmlStr];
//                [tempGroup addAnimation:animationGo2];
//            }
//        }
//
////        NSString *tempAnimationDic = [NSString stringWithFormat: @"%@%@",NSHomeDirectory(),@"/Documents/iTablet/Cache"];
////        NSString *tempAnimationXmlPath = [NSString stringWithFormat: @"%@%@",tempAnimationDic,@"/tempAnimation.xml"];
////        NSFileManager *fileManager = [NSFileManager defaultManager];
////        BOOL isDir = FALSE;
////        BOOL isDirExist = [fileManager fileExistsAtPath:tempAnimationDic isDirectory:&isDir];
////        if(!(isDirExist && isDir))
////        {
////            [fileManager createDirectoryAtPath:tempAnimationDic withIntermediateDirectories:YES attributes:nil error:nil];
////        }
////        [AnimationManager.getInstance saveAnimationToXML:tempAnimationXmlPath];
////        [AnimationManager.getInstance deleteAll];   //这个地方报错，不知道什么原因
////        isDirExist = [fileManager fileExistsAtPath:tempAnimationXmlPath isDirectory:&isDir];
////        if(isDirExist&&!isDir){
////            [AnimationManager.getInstance getAnimationFromXML:tempAnimationXmlPath];
////            int groupCount=[AnimationManager.getInstance getGroupCount];
////            if(groupCount==2){
////                [AnimationManager.getInstance deleteGroupByName:animationGroupName];
////                [[AnimationManager.getInstance getGroupByIndex:0] setName:animationGroupName];
////            }
////            [fileManager removeItemAtPath:tempAnimationXmlPath error:nil];
////        }
//
//        [[AnimationManager.getInstance getGroupByIndex:0] setName:animationGroupName];
//        [AnimationManager.getInstance deleteGroupByName:animationGroupName];
//        [[AnimationManager.getInstance getGroupByIndex:0] setName:animationGroupName];
//
//
//        resolve([NSNumber numberWithBool:YES]);
//    } @catch (NSException *exception) {
//        reject(@"getAnimationNodeList", exception.reason, nil);
//    }
//}



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

-(void)clearLayerSelection:(LayerGroup*)layerGroup{
    for (int i = 0; i < layerGroup.getCount; i++) {
        Layer* layer = [layerGroup getLayer:i];
        if([layer isKindOfClass:[LayerGroup class]]){
            [self clearLayerSelection:layer];
        }else{
            Selection* selection = [layer getSelection];
            [selection clear];
            [selection dispose];
        }
    }
}
#pragma mark 清除Selection
RCT_REMAP_METHOD(clearSelection, clearSelectionWithResolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Layers* layers = sMap.smMapWC.mapControl.map.layers;
        for (int i = 0; i < layers.getCount; i++) {
            
            Layer* layer = [layers getLayerAtIndex:i];
            if([layer isKindOfClass:[LayerGroup class]]){
                [self clearLayerSelection:layer];
            }else{
                Selection* selection = [layer getSelection];
                [selection clear];
                [selection dispose];
            }
        }
        [sMap.smMapWC.mapControl.map refresh];
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
                    //另存后从maps移除当前另存的地图，以免添加地图失败
                    [sMap.smMapWC.workspace.maps removeMapName:mapName];
                } else if (mapName == nil) {
                    mapName = @"";
                }
                [sMap.smMapWC.mapControl.map refresh];
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
RCT_REMAP_METHOD(newTaggingDataset, newTaggingDatasetWithName:(NSString *)Name path:(NSString *)userpath editable:(BOOL)editable type:(NSString *)type resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Workspace *workspace =sMap.smMapWC.mapControl.map.workspace;
        NSString *labelName = [NSString  stringWithFormat:@"%@%@%@",@"Label_",userpath,@"#"];
        Datasource *opendatasource = [workspace.datasources getAlias:labelName];
        NSString *datasetName = @"";
        Layer *layer;
        if(opendatasource == nil){
            DatasourceConnectionInfo *info = [[DatasourceConnectionInfo alloc]init];
            info.alias = labelName;
            info.engineType = ET_UDB;
            NSString *path = [NSString stringWithFormat: @"%@%@%@%@%@",NSHomeDirectory(),@"/Documents/iTablet/User/",userpath,@"/Data/Datasource/",labelName];
            info.server = path;
            Datasource *datasource = [workspace.datasources open:info];
            
            if(datasource != nil && [datasource.description isEqualToString: @"Label"]){
                Datasets *datasets = datasource.datasets;
                datasetName = [datasets availableDatasetName: Name];
                DatasetVectorInfo *datasetVectorInfo = [[DatasetVectorInfo alloc]init];
                [datasetVectorInfo setDatasetType:CAD];
                [datasetVectorInfo setEncodeType:NONE];
                [datasetVectorInfo setName:datasetName];
                DatasetVector *datasetVector = [datasets create:datasetVectorInfo];
                datasetVector.prjCoordSys = sMap.smMapWC.mapControl.map.prjCoordSys;
                
                //创建数据集时创建好字段
                [SMap addFieldInfo:datasetVector Name:@"name" FieldType:FT_TEXT Required:NO Value:@"" Maxlength:255];
                [SMap addFieldInfo:datasetVector Name:@"remark" FieldType:FT_TEXT Required:NO Value:@"" Maxlength:255];
                [SMap addFieldInfo:datasetVector Name:@"address" FieldType:FT_TEXT Required:NO Value:@"" Maxlength:255];
                
                
                Dataset *ds = [datasets getWithName:datasetName];
                ds.description = [NSString stringWithFormat:@"{\"type\":\"%@\"}", type];
                Map *map = sMap.smMapWC.mapControl.map;
                layer = [map.layers addDataset:ds ToHead:YES];
                
                [layer setEditable:editable];
                layer.isSnapable = NO;
                [datasetVectorInfo dispose];
                [datasetVector close];
                [info dispose];
            }
        }else{
            Datasets *datasets = opendatasource.datasets;
            datasetName = [datasets availableDatasetName:Name];
            DatasetVectorInfo *datasetVectorInfo = [[DatasetVectorInfo alloc] init];
            [datasetVectorInfo setDatasetType:CAD];
            [datasetVectorInfo setEncodeType:NONE];
            [datasetVectorInfo setName:datasetName];
            
            DatasetVector *datasetVector = [datasets create:datasetVectorInfo];
            datasetVector.prjCoordSys = sMap.smMapWC.mapControl.map.prjCoordSys;
            //创建数据集时创建好字段
            [SMap addFieldInfo:datasetVector Name:@"name" FieldType:FT_TEXT Required:NO Value:@"" Maxlength:255];
            [SMap addFieldInfo:datasetVector Name:@"remark" FieldType:FT_TEXT Required:NO Value:@"" Maxlength:255];
            [SMap addFieldInfo:datasetVector Name:@"address" FieldType:FT_TEXT Required:NO Value:@"" Maxlength:255];
            
            Dataset *ds = [datasets getWithName:datasetName];
            ds.description = [NSString stringWithFormat:@"{\"type\":\"%@\"}", type];
            Map *map =sMap.smMapWC.mapControl.map;
            layer = [map.layers addDataset:ds ToHead:YES];
            
            [layer setEditable:editable];
            layer.isSnapable = NO;
            [datasetVectorInfo dispose];
            [datasetVector close];
        }
        resolve(@{
                  @"datasetName": datasetName,
                  @"layerName": layer ? layer.name : @"",
                  });
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
            NSString *path = [NSString stringWithFormat: @"%@%@%@%@%@.udb",NSHomeDirectory(),@"/Documents/iTablet/User/",userpath,@"/Data/Datasource/",labelName];
            info.server = path;//[path stringByAppendingString:@".udb"];
            
            Datasource *datasource = nil;
            if([[NSFileManager defaultManager] fileExistsAtPath:path]){
                datasource = [workspace.datasources open:info];
            }else{
                datasource = [workspace.datasources create:info];
            }
//            Datasource *datasource = [workspace.datasources open:info];
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
        if(opendatasource != nil){
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
                                break;
                            }
                        }
                    }
                    if (isEditable) break;
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

#pragma mark 判断是否有标注图层，并获取当前标注图层信息
RCT_REMAP_METHOD(getCurrentTaggingLayer, getCurrentTaggingLayerWithPath:(NSString *)userpath resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Workspace *workspace = sMap.smMapWC.mapControl.map.workspace;
        NSString *udbName = [NSString stringWithFormat: @"%@%@%@",@"Label_",userpath,@"#"];
        Datasource *opendatasource = [workspace.datasources getAlias:udbName];
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        BOOL isEditable = NO;
        if(opendatasource != nil){
            Datasets *datasets = opendatasource.datasets;
            Layers *layers = sMap.smMapWC.mapControl.map.layers;
            
            Layer *layer = nil;
            for(int i = 0, count = [layers getCount]; i < count; i++){
                if(!isEditable){
                    layer = [layers getLayerAtIndex:i];
                    for(int j = 0,dCount = datasets.count; j < dCount; j++){
                        Dataset *dataset = [datasets get:j];
                        if(layer.dataset == dataset){
                            if(layer.editable){
                                isEditable = YES;
                                break;
                            }
                        }
                    }
                    if (isEditable) break;
                }
            }
            [dic setObject:@(isEditable) forKey:@"isTaggingLayer"];
            
            if (isEditable) {
                NSMutableDictionary* layerInfo = [[NSMutableDictionary alloc] init];
                [layerInfo setObject:@(isEditable) forKey:@"isEditable"];
                [layerInfo setObject:@(layer.visible) forKey:@"isVisible"];
                [layerInfo setObject:layer.name forKey:@"name"];
                [layerInfo setObject:layer.dataset.name forKey:@"datasetName"];
                [layerInfo setObject:layer.dataset.description forKey:@"datasetDescription"];
                [layerInfo setObject:layer.description forKey:@"description"];
                
                [dic setObject:layerInfo forKey:@"layerInfo"];
            }
        } else {
            [dic setObject:@(isEditable) forKey:@"isTaggingLayer"];
        }
        resolve(dic);
    } @catch (NSException *exception) {
        reject(@"Tagging",@"getCurrentTaggingLayer() Failed.",nil);
    }
}

#pragma mark 获取标注图层
RCT_REMAP_METHOD(getTaggingLayers, getTaggingLayersWithUserpath:(NSString *)userpath resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Workspace *workspace = sMap.smMapWC.mapControl.map.workspace;
        NSString *labelName = [NSString  stringWithFormat:@"%@%@%@",@"Label_",userpath,@"#"];
        Datasource *opendatasource = [workspace.datasources getAlias:labelName];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
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
            }
        } else {
            Datasets *datasets = opendatasource.datasets;
            Map *map = sMap.smMapWC.mapControl.map;
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
        }
        resolve(arr);
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
        [recordset dispose];
        return;
    }
    [recordset setFieldValueWithString:fieldInfoName Obj:value];
    
    b = [recordset update];
    
    // [recordset close];
    [recordset dispose];
}
#pragma mark 添加数据集属性字段
RCT_REMAP_METHOD(addRecordset, addRecordsetWithDatasourceName:(NSString *)datasourceName DatasetName:(NSString *)datasetName FieldInfoName:(NSString *)fieldInfoName Value:(NSString *)value Path:(NSString *)userpath Resolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    
    @try {
        sMap = [SMap singletonInstance];
        Workspace *workspace = sMap.smMapWC.mapControl.map.workspace;
        Datasource *opendatasource = [workspace.datasources getAlias:datasourceName];
        
        if(opendatasource == nil){
            DatasourceConnectionInfo *info = [[DatasourceConnectionInfo alloc]init];
            info.alias = datasourceName;
            info.engineType = ET_UDB;
            NSString *path = [NSString stringWithFormat: @"%@%@%@%@%@%@",NSHomeDirectory(),@"/Documents/iTablet/User/",userpath,@"/Data/Datasource/",datasourceName,@".udb"];
            info.server = path;
            Datasource *datasource = [workspace.datasources open:info];
            
            if(datasource != nil){
                Datasets *datasets = datasource.datasets;
                DatasetVector *dataset = (DatasetVector *)[datasets getWithName:datasetName];
                [SMap modifyLastAttributeWithDatasets:dataset FieldInfoName:fieldInfoName Value:value];
            }
            [info dispose];
            [sMap.smMapWC.mapControl.map refresh];
            resolve(@(YES));
        }else{
            Datasets *datasets = opendatasource.datasets;
            DatasetVector *dataset = (DatasetVector *)[datasets getWithName:datasetName];
            [SMap modifyLastAttributeWithDatasets:dataset FieldInfoName:fieldInfoName Value:value];
            [sMap.smMapWC.mapControl.map refresh];
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
        } else {
            resolve(0);
        }
    } @catch (NSException *exception) {
        reject(@"getTaggingLayerCount",exception.reason,nil);
    }
}

#pragma mark 获取最小可见比例尺范围
RCT_REMAP_METHOD(getMinVisibleScale, getMinVisibleScaleWithName:(NSString *)name Resolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    @try{
        sMap = [SMap singletonInstance];
        Layer *layer = [SMLayer findLayerByPath:name];
        double scale = [layer minVisibleScale];
        if(scale != 0) {
            scale = 1 / scale;
        }
        resolve([NSNumber numberWithDouble:scale]);
    }@catch(NSException *exception){
        reject(@"getMinVisibleScale",exception.reason,nil);
    }
}

#pragma mark 获取最大可见比例尺范围
RCT_REMAP_METHOD(getMaxVisibleScale, getMaxVisibleScaleWithName:(NSString *)name Resolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    @try{
        sMap = [SMap singletonInstance];
        Layer *layer = [SMLayer findLayerByPath:name];
        double scale = [layer maxVisibleScale];
        if(scale != 0) {
            scale = 1 / scale;
        }
        resolve([NSNumber numberWithDouble:scale]);
    }@catch(NSException *exception){
        reject(@"getMaxVisibleScale",exception.reason,nil);
    }
}

#pragma mark 设置最小比例尺范围
RCT_REMAP_METHOD(setMinVisibleScale, setMinVisibleScaleWithName:(NSString *)name Number:(double)number Resolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    @try{
        sMap = [SMap singletonInstance];
        Layer *layer = [SMLayer findLayerByPath:name];//[sMap.smMapWC.mapControl.map.layers getLayerWithName:name];
        double scale = number;
        if(number != 0) {
            scale = 1 / number;
        }
        [layer setMinVisibleScale:scale];
        resolve(@(YES));
    }@catch(NSException *exception){
        reject(@"setMinVisibleScale",exception.reason,nil);
    }
}

#pragma mark 设置最大比例尺范围
RCT_REMAP_METHOD(setMaxVisibleScale, setMaxVisibleScaleWithName:(NSString *)name Number:(double)number Resolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    @try{
        sMap = [SMap singletonInstance];
        Layer *layer = [SMLayer findLayerByPath:name];//[sMap.smMapWC.mapControl.map.layers getLayerWithName:name];
        double scale = number;
        if(number != 0) {
            scale = 1 / number;
        }
        [layer setMaxVisibleScale:scale];
        resolve(@(YES));
    }@catch(NSException *exception){
        reject(@"setMaxVisibleScale",exception.reason,nil);
    }
}

#pragma mark 添加文字标注
RCT_REMAP_METHOD(addTextRecordset, addTextRecordsetWithDatasourceName:(NSString *)datasourceName DatasetName:(NSString *)datasetName Name:(NSString *)name X:(int)x Y:(int)y Resolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        Point2D *p =[sMap.smMapWC.mapControl.map pixelTomap:CGPointMake(x, y)];
        Workspace *workspace = sMap.smMapWC.mapControl.map.workspace;
        Datasource *opendatasource = [workspace.datasources getAlias:datasourceName];
        Datasets *datasets = opendatasource.datasets;
        DatasetVector *dataset =(DatasetVector *)[datasets getWithName:datasetName];
        if(dataset != nil){
            [dataset setReadOnly:NO];
        }
        Recordset *recordset = [dataset recordset:NO cursorType:DYNAMIC];
        TextPart *textpart = [[TextPart alloc]init];
        TextStyle *textStyle = [[TextStyle alloc]init];
        [textStyle setFontWidth:6];
        [textStyle setFontHeight:8];
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
//        g_mapControl = sMap.smMapWC.mapControl;
        Workspace *workspace = sMap.smMapWC.mapControl.map.workspace;
        NSString *labelName = [NSString  stringWithFormat:@"%@%@%@",@"Label_",userpath,@"#"];
        Datasource *opendatasource = [workspace.datasources getAlias:labelName];
        DatasetVector* dataset = (DatasetVector *)[[opendatasource datasets] getWithName:name];
        if(dataset != nil){
            sMap.smMapWC.mapControl.geometryAddedDelegate = self;
        }
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setTaggingGrid",exception.reason,nil);
    }
}

#pragma mark 设置MapControl 画笔样式
RCT_REMAP_METHOD(setMapControlStyle, setMapControlStyle:(NSDictionary *)style setLabelColorWithResolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    @try {
        sMap = [SMap singletonInstance];
        MapControl *mapControl = sMap.smMapWC.mapControl;
        
        if ([style objectForKey:@"nodeStyle"]) {
            NSString* nodeStyleJson = [style objectForKey:@"nodeStyle"];
            GeoStyle* nodeStyle = [[GeoStyle alloc] init];
            [nodeStyle fromJson:nodeStyleJson];
            [mapControl setNodeStyle:nodeStyle];
        }
        if ([style objectForKey:@"nodeColor"]) {
            NSNumber* strokeColor = [style objectForKey:@"nodeColor"];
            [mapControl setNodeColor:[[Color alloc] initWithValue:strokeColor.intValue]];
        }
        if ([style objectForKey:@"nodeSize"]) {
            NSNumber* nodeSize = [style objectForKey:@"nodeSize"];
            [mapControl setNodeSize:nodeSize.doubleValue];
        }
        if ([style objectForKey:@"strokeColor"]) {
            NSNumber* strokeColor = [style objectForKey:@"strokeColor"];
            [mapControl setStrokeColor:[[Color alloc] initWithValue:strokeColor.intValue]];
        }
        if ([style objectForKey:@"strokeWidth"]) {
            NSNumber* strokeWidth = [style objectForKey:@"strokeWidth"];
            [mapControl setStrokeWidth:strokeWidth.intValue];
        }
        if ([style objectForKey:@"strokeFillColor"]) {
            NSNumber* strokeFillColor = [style objectForKey:@"strokeFillColor"];
            [mapControl setStrokeFillColor:[[Color alloc] initWithValue:strokeFillColor.intValue]];
        }
        
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setLabelColor",exception.reason,nil);
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

//#pragma mark 更新图例
//RCT_REMAP_METHOD(updateLegend, updateLegendWithResolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
//    @try {
//        sMap = [SMap singletonInstance];
//        MapControl *mapControl = sMap.smMapWC.mapControl;
//        [mapControl setStrokeColor: [[Color alloc] initWithValue:0x3999FF]];
//        [mapControl setStrokeWidth:1];
//
//        GeoStyle *geoStyle_P = [[GeoStyle alloc] init];
//
//        Workspace *workspace = mapControl.map.workspace;
//        Resources *m_resources = workspace.resources;
//        SymbolMarkerLibrary *symbol_m = [m_resources markerLibrary];
//
//        if([symbol_m containID:332]){
//            [geoStyle_P setMarkerSymbolID:332];
//            [mapControl setNodeStyle:geoStyle_P];
//        }else if([symbol_m containID:313]){
//            [geoStyle_P setMarkerSymbolID:313];
//            [mapControl setNodeStyle:geoStyle_P];
//        }else if([symbol_m containID:321]){
//            [geoStyle_P setMarkerSymbolID:321];
//            [mapControl setNodeStyle:geoStyle_P];
//        }else {
//            [mapControl setNodeColor:[[Color alloc] initWithValue:0x3999FF]];
//            [mapControl setNodeSize:2.0];
//        }
//        resolve(@(YES));
//    } @catch (NSException *exception) {
//        reject(@"setLabelColor",exception.reason,nil);
//    }
//}

#pragma mark 智能配图
RCT_REMAP_METHOD(matchPictureStyle, matchPictureStyle:(NSString *)picPath resolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    @try {
        [[SMap.singletonInstance.smMapWC.mapControl getEditHistory] addMapHistory];
        SMMapRender* mapRender = [SMMapRender sharedInstance];
        mapRender.delegate = self;
        [mapRender setCompressMode:2];
        [mapRender matchPictureStyle:picPath];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setLabelColor",exception.reason,nil);
    }
}

#pragma mark 智能配图
RCT_REMAP_METHOD(deleteMatchPictureListener, deleteMatchPictureListenerWithResolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    @try {
        SMMapRender* mapRender = [SMMapRender sharedInstance];
        mapRender.delegate = nil;
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setLabelColor",exception.reason,nil);
    }
}

#pragma mark 调整智能配图 亮度、饱和度、色调
RCT_REMAP_METHOD(updateMapFixColorsMode, updateMapFixColorsMode:(int)mode value:(int)value resolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    @try {
        SMMapFixColors* mapFixColors = [SMMapFixColors sharedInstance];
        [mapFixColors updateMapFixColorsMode:mode value:value];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setLabelColor",exception.reason,nil);
    }
}

#pragma mark 获取智能配图 亮度、饱和度、色调
RCT_REMAP_METHOD(getMapFixColorsModeValue, getMapFixColorsModeValue:(int)mode resolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    @try {
        SMMapFixColors* mapFixColors = [SMMapFixColors sharedInstance];
        int value = [mapFixColors getMapFixColorsModeValue:mode];
        resolve(@(value));
    } @catch (NSException *exception) {
        reject(@"setLabelColor",exception.reason,nil);
    }
}

#pragma mark 重置智能配图 亮度、饱和度、色调 的值
RCT_REMAP_METHOD(resetMapFixColorsModeValue, resetMapFixColorsModeValue:(BOOL)isReset resolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    @try {
        SMMapFixColors* mapFixColors = [SMMapFixColors sharedInstance];
        [mapFixColors reset:isReset];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"setLabelColor",exception.reason,nil);
    }
}

#pragma mark 激活许可
RCT_REMAP_METHOD(activateLicense, activateLicense:(NSString*)serialNumber resolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    @try {
        RecycleLicenseManager* licenseManagers = [RecycleLicenseManager getInstance];

        [Environment setLicenseType:1];
        NSArray *moudles=[licenseManagers query:serialNumber];
        [Environment setUserLicInfo:serialNumber Modules:moudles];
        //激活
        BOOL isActive = [licenseManagers activateDevice:serialNumber modules:moudles];
        if(isActive){
            [KeychainUtil saveKeychainValue:serialNumber key:KEYCHAIN_STORAGE_SERIAL_NUMBER_KEY];
            [KeychainUtil saveKeychainValue:[moudles componentsJoinedByString:@","] key:KEYCHAIN_STORAGE_SERIAL_MODULES_KEY];
        }
        resolve([NSNumber numberWithBool:isActive]);
    } @catch (NSException *exception) {
        reject(@"setLabelColor",exception.reason,nil);
    }
}

#pragma mark 获取正式许可所含模块
RCT_REMAP_METHOD(licenseContainModule, licenseContainModule:(NSString*)serialNumber resolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    @try {
        RecycleLicenseManager* licenseManagers = [RecycleLicenseManager getInstance];
        
        NSArray *moudles=[licenseManagers query:serialNumber];
        
        NSString* serialNumber=[KeychainUtil readKeychainValue:KEYCHAIN_STORAGE_SERIAL_NUMBER_KEY];
        if(serialNumber&&![serialNumber isEqualToString:@""]){
            NSString* modulesStr=[KeychainUtil readKeychainValue:KEYCHAIN_STORAGE_SERIAL_MODULES_KEY];
            NSArray* modulesArray=[modulesStr componentsSeparatedByString:@","];
            [Environment setUserLicInfo:serialNumber Modules:modulesArray];
        }
        
        resolve(moudles);
    } @catch (NSException *exception) {
        reject(@"setLabelColor",exception.reason,nil);
    }
}

#pragma mark 归还许可
RCT_REMAP_METHOD(recycleLicense, recycleLicense:(NSString*)serialNumber resolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    @try {
        RecycleLicenseManager* licenseManagers = [RecycleLicenseManager getInstance];
        BOOL isRecycle = [licenseManagers recycleLicense:nil];
        if(isRecycle){
            [Environment setLicensePath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/iTablet/%@/",@"license"]];
        }
        resolve([NSNumber numberWithBool:isRecycle]);
    } @catch (NSException *exception) {
        reject(@"recycleLicense",exception.reason,nil);
    }
}

#pragma mark 清除许可，清除本地许可文件，不归还
RCT_REMAP_METHOD(clearLocalLicense, clearLocalLicense:(NSString*)serialNumber resolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    @try {
        RecycleLicenseManager* licenseManagers = [RecycleLicenseManager getInstance];
        [licenseManagers clearLocalLicense];
        [Environment setLicensePath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/iTablet/%@/",@"license"]];
        [KeychainUtil saveKeychainValue:@"" key:KEYCHAIN_STORAGE_SERIAL_NUMBER_KEY];
        [KeychainUtil saveKeychainValue:@"" key:KEYCHAIN_STORAGE_SERIAL_MODULES_KEY];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"recycleLicense",exception.reason,nil);
    }
}

#pragma mark 获取剩余许可数量
RCT_REMAP_METHOD(getLicenseCount, getLicenseCount:(NSString*)serialNumber resolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    @try {
        RecycleLicenseManager* licenseManagers = [RecycleLicenseManager getInstance];
        NSArray *moudles=[licenseManagers queryLicenseCount:serialNumber];
        int count=[moudles count];
        int minRemindNum=0;
        for(int i=0;i<count;i++){
            NSDictionary* dic=moudles[i];
            int remindNum=[[dic objectForKey:@"LicenseRemainedCount"] intValue];
            if(i==0||minRemindNum>remindNum){
                minRemindNum=remindNum;
            }
        }
        resolve(@(minRemindNum));
    } @catch (NSException *exception) {
        reject(@"recycleLicense",exception.reason,nil);
    }
}

#pragma mark 初始化许可序列号
RCT_REMAP_METHOD(initSerialNumber, initSerialNumber:(NSString*)serialNumber resolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    @try {
        NSString* serialNumber=[KeychainUtil readKeychainValue:KEYCHAIN_STORAGE_SERIAL_NUMBER_KEY];
        if(serialNumber&&![serialNumber isEqualToString:@""]){
            [Environment setLicenseType:1];
            NSString* modulesStr=[KeychainUtil readKeychainValue:KEYCHAIN_STORAGE_SERIAL_MODULES_KEY];
            NSArray* modulesArray=[modulesStr componentsSeparatedByString:@","];
            [Environment setUserLicInfo:serialNumber Modules:modulesArray];
            resolve(serialNumber);
        }
        
        resolve(@"");
    } @catch (NSException *exception) {
        reject(@"initSerialNumber",exception.reason,nil);
    }
}
#pragma mark 离线获取序列号和模块编号数组
RCT_REMAP_METHOD(getSerialNumberAndModules, getSerialNumberAndModules:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    @try {
        NSString* serialNumber=[KeychainUtil readKeychainValue:KEYCHAIN_STORAGE_SERIAL_NUMBER_KEY];
        if(serialNumber&&![serialNumber isEqualToString:@""]){
            NSMutableDictionary* dic=[[NSMutableDictionary alloc] init];
            [Environment setLicenseType:1];
            NSString* modulesStr=[KeychainUtil readKeychainValue:KEYCHAIN_STORAGE_SERIAL_MODULES_KEY];
            NSArray* modulesArray=[modulesStr componentsSeparatedByString:@","];
            [dic setObject:serialNumber forKey:@"serialNumber"];
            [dic setObject:modulesArray forKey:@"modulesArray"];
            resolve(dic);
        }
        resolve(NULL);
    } @catch (NSException *exception) {
        reject(@"initSerialNumber",exception.reason,nil);
    }
}
#pragma mark 初始化使用许可的路径
RCT_REMAP_METHOD(initTrailLicensePath, initTrailLicensePath:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    @try {
        [Environment setLicensePath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/iTablet/%@/",@"license"]];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"initSerialNumber",exception.reason,nil);
    }
}


#pragma mark 登记购买
RCT_REMAP_METHOD(licenseBuyRegister, licenseBuyRegister:(int)moduleCode userName:(NSString*)userName resolver:(RCTPromiseResolveBlock)resolve Rejector:(RCTPromiseRejectBlock)reject){
    @try {
        
        NSMutableDictionary* dic=[[NSMutableDictionary alloc] init];
        [dic setValue:userName forKey:@"LICENSE_BUY_REGISTER_USER_NAME"];
        [dic setValue:[NSString stringWithFormat:@"%d",moduleCode] forKey:@"LICENSE_BUY_REGISTER_MODULE_CODE"];
        //上传数据
        [LogInfoService sendAPPLogInfo:dic completionHandler:^(BOOL result) {
            resolve([NSNumber numberWithBool:result]);
        }];
    } @catch (NSException *exception) {
        reject(@"licenseBuyRegister",exception.reason,nil);
    }
}


#pragma mark /************************************************ 监听事件 ************************************************/
#pragma mark 监听事件
/*
 * 对象添加事件代理
 */
-(void)aftergeometryAddedCallBack:(GeometryArgs*)geometryArgs{
    
    NSArray *ids =[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:geometryArgs.id], nil];
    DatasetVector* dataset = (DatasetVector *)geometryArgs.layer.dataset;
    Recordset *recordset = [dataset queryWithID:ids Type:DYNAMIC];
    if(recordset != nil){
        [recordset moveFirst];
        [recordset edit];
        Geometry *geometry = recordset.geometry;
        if(geometry != nil){
            GeoStyle* geoStyle = [[GeoStyle alloc]init];
            [geoStyle setFillForeColor:[SMap getFillColor]];
            [geoStyle setFillBackColor:[SMap getFillColor]];
            [geoStyle setMarkerSize: [[Size2D alloc] initWithWidth:10 Height:10]];
            [geoStyle setLineColor: [[Color alloc] initWithR:80 G:80 B:80]];
            [geoStyle setFillOpaqueRate:50]; //透明度
            [geometry setStyle:geoStyle];
            [recordset setGeometry:geometry];
            [recordset update];
        }
    }
    [recordset dispose];
    SMap.singletonInstance.smMapWC.mapControl.geometryAddedDelegate = nil;
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
    FloorListView *floorListView = [SMap singletonInstance].smMapWC.floorListView;
    NSString *floorID = floorListView.currentFloorId;
    NSString *currentFloorID = floorID == nil ? @"" : floorID;
    [self sendEventWithName:IS_FLOOR_HIDDEN body:@{@"currentFloorID":currentFloorID}];
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
    Point2D* point2D = [SMap.singletonInstance.smMapWC.mapControl.map pixelTomap:pressedPos];
    
    Point2D *LLpoint2D = [SMap getPointWithX:point2D.x Y:point2D.y];
    [self sendEventWithName:MAP_LONG_PRESS
                       body:@{@"mapPoint": @{
                                      @"x":@(point2D.x == INFINITY ? 0 : point2D.x),
                                      @"y":@(point2D.y == INFINITY ? 0 : point2D.y),
                                      },
                              @"screenPoint": @{
                                      @"x":nsX,
                                      @"y":nsY
                                      },
                              @"LLPoint":@{
                                      @"x":@(LLpoint2D.x),
                                      @"y":@(LLpoint2D.y),
                                      },
                              }];
}

static BOOL bDouble = false;
- (void)onDoubleTap:(CGPoint)onDoubleTapPos{
    CGFloat x = onDoubleTapPos.x;
    CGFloat y = onDoubleTapPos.y;
    NSNumber* nsX = [NSNumber numberWithFloat:x];
    NSNumber* nsY = [NSNumber numberWithFloat:y];
    Point2D* point2D = [SMap.singletonInstance.smMapWC.mapControl.map pixelTomap:onDoubleTapPos];
    bDouble = true;
    [self sendEventWithName:MAP_DOUBLE_TAP
                       body:@{@"mapPoint": @{
                                      @"x":@(point2D.x == INFINITY ? 0 : point2D.x),
                                      @"y":@(point2D.y == INFINITY ? 0 : point2D.y),
                                      },
                              @"screenPoint": @{
                                      @"x":nsX,
                                      @"y":nsY
                                      },
                              }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    CGFloat x = point.x;
    CGFloat y = point.y;
    NSNumber* nsX = [NSNumber numberWithFloat:x];
    NSNumber* nsY = [NSNumber numberWithFloat:y];
    
    Point2D* point2D = [SMap.singletonInstance.smMapWC.mapControl.map pixelTomap:point];
    [self sendEventWithName:MAP_TOUCH_BEGAN
                       body:@{@"mapPoint": @{
                                      @"x":@(point2D.x == INFINITY ? 0 : point2D.x),
                                      @"y":@(point2D.y == INFINITY ? 0 : point2D.y),
                                      },
                              @"screenPoint": @{
                                      @"x":nsX,
                                      @"y":nsY
                                      },
                              }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    CGFloat x = point.x;
    CGFloat y = point.y;
    NSNumber* nsX = [NSNumber numberWithFloat:x];
    NSNumber* nsY = [NSNumber numberWithFloat:y];
    
    Point2D* point2D = [SMap.singletonInstance.smMapWC.mapControl.map pixelTomap:point];
    [self sendEventWithName:MAP_TOUCH_END
                       body:@{@"mapPoint": @{
                                      @"x":@(point2D.x == INFINITY ? 0 : point2D.x),
                                      @"y":@(point2D.y == INFINITY ? 0 : point2D.y),
                                      },
                              @"screenPoint": @{
                                      @"x":nsX,
                                      @"y":nsY
                                      },
                              }];
}

-(void)onSingleTap:(CGPoint)onSingleTapPos{
    CGFloat x = onSingleTapPos.x;
    CGFloat y = onSingleTapPos.y;
    NSNumber* nsX = [NSNumber numberWithFloat:x];
    NSNumber* nsY = [NSNumber numberWithFloat:y];
    Point2D* point2D = [SMap.singletonInstance.smMapWC.mapControl.map pixelTomap:onSingleTapPos];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(bDouble){
            bDouble = false;
            return ;
        }
        [self sendEventWithName:MAP_SINGLE_TAP
                           body:@{@"mapPoint": @{
                                          @"x":@(point2D.x == INFINITY ? 0 : point2D.x),
                                          @"y":@(point2D.y == INFINITY ? 0 : point2D.y),
                                          },
                                  @"screenPoint": @{
                                          @"x":nsX,
                                          @"y":nsY
                                          },
                                  }];
    });
   
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch1 = [touches anyObject];
    CGPoint startPoint = [touch1 locationInView:[touch1 view]];
    CGFloat x = startPoint.x;
    CGFloat y = startPoint.y;
    NSNumber* nsX = [NSNumber numberWithFloat:x];
    NSNumber* nsY = [NSNumber numberWithFloat:y];
    
    Point2D* point2D = [SMap.singletonInstance.smMapWC.mapControl.map pixelTomap:startPoint];
    [self sendEventWithName:MAP_SCROLL
                       body:@{@"mapPoint": @{
                                      @"x":@(point2D.x == INFINITY ? 0 : point2D.x),
                                      @"y":@(point2D.y == INFINITY ? 0 : point2D.y),
                                      },
                              @"screenPoint": @{
                                      @"x":nsX,
                                      @"y":nsY
                                      },
                              }];
}

-(void)geometrySelected:(int)geometryID Layer:(Layer*)layer{
    if(!layer)
        return;
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
    
    Selection* selection = layer.getSelection;
    Recordset* recordset = selection.toRecordset;
    [recordset moveFirst];
    NSMutableArray* fields = [NativeUtil getFieldInfos:recordset filter:nil];
    NSMutableArray *fieldInfo = [NativeUtil parseRecordset:recordset fieldsArr:fields];
    
    [recordset dispose];
    
    [self sendEventWithName:MAP_GEOMETRY_SELECTED body:@{@"layerInfo":layerInfo,
                                                         @"fieldInfo":fieldInfo,
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

#pragma mark - 智能配图结果监听
-(void)matchImageFinished:(NSDictionary*)result {
    [self sendEventWithName:MATCH_IMAGE_RESULT body:result];
}

@end

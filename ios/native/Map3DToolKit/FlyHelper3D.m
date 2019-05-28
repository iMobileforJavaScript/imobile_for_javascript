//
//  FlyHelper3D.m
//  HypsometricSetting
//
//  Created by wnmng on 2018/11/21.
//  Copyright © 2018年 SuperMap. All rights reserved.
//

#import "FlyHelper3D.h"
#import "SuperMap/Scene.h"
#import "SuperMap/Route.h"
#import "SuperMap/Routes.h"
#import "SuperMap/RouteStops.h"
#import "SuperMap/Point3Ds.h"
#import "SuperMap/FlyManager.h"
#import "SuperMap/Camera.h"
#import "SuperMap/GeoStyle3D.h"
#import "SuperMap/GeoLine3D.h"
#import "SuperMap/TrackingLayer3D.h"
#import "SScene.h"

@interface FlyHelper3D()<FlyManagerDelegate>{
    SceneControl* m_sceneControl;
    NSString *m_strSceneDirPath;
    
    int m_nRouteIndex;
    //FlyManager * m_flymanager;
    //NSString* m_sceneDirPath;
    //NSArray *m_arrFlyRouteNames;
    BOOL m_bRoutesLoaded ;
//    BOOL m_bFlying;
//    BOOL m_bPause;
    NSTimer *m_timer;
    RouteStops* m_RouteStops;
    Point3Ds* m_point3Ds;
    Route* m_route;
}



@end


@implementation FlyHelper3D
    SUPERMAP_SIGLETON_IMP(FlyHelper3D);


///**
// * 初始化飞行场景
// *
// * @param control
// * @return true表示初始化成功，false表示"该场景下无飞行路线"
// */
//-(BOOL)initialize:(SceneControl*)control{
//    m_sceneControl = control;
//    return YES
//}

-(void)resetSceneControl:(SceneControl*)control SceneDir:(NSString*)sceneDirPath{
    m_sceneControl = control;
    m_strSceneDirPath = sceneDirPath;
    m_bRoutesLoaded = false;

    [self LoadRoutes];
    
}
//-(void)setSceneDir:(NSString*)sceneDirPath{
//    m_strSceneDirPath = sceneDirPath;
//}
-(void)LoadRoutes{
    if (m_bRoutesLoaded) {
        return;
    }
    if (m_sceneControl==nil || m_sceneControl.scene == nil || m_sceneControl.scene.flyManager == nil || m_strSceneDirPath == nil || m_strSceneDirPath.length==0) {
        return ;
    }
    FlyManager* flymanager = [m_sceneControl.scene flyManager];
    if ([flymanager status]!=STOP) {
        [flymanager stop];
    }
    
    NSString *currentSceneName = [m_sceneControl.scene name];
    NSString *strFlyRoute= [self flyRoutePath:m_strSceneDirPath scenceName:currentSceneName];
    if (strFlyRoute){
        Routes *routes = [flymanager routes];
        m_bRoutesLoaded = [routes fromFile:strFlyRoute];
        flymanager.flyManagerDelegate = self;
        return ;
    }else{
        return ;
    }
}



/**
 * 获取飞行路径列表
 *
 * @return
 */
-(NSArray*)getFlyRouteNames{
    if (m_bRoutesLoaded) {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        Routes *routes = m_sceneControl.scene.flyManager.routes;
        NSInteger routeCount = routes.count;
        for (int i=0; i<routeCount; i++) {
            [arr addObject:[routes getRouteNameWithIndex:i]];
        }
        return arr;
    }else{
        return nil;
    }
}

/**
 *   根据场景名称获取同名的飞行路线，需要确认飞行文件的存放位置
 */
-(NSString*)flyRoutePath:(NSString*)localDataPath scenceName:(NSString*)strScenceName{
    NSString *filePath = nil;
    NSArray* arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:localDataPath error:nil];
    for(NSString* eachFile in arr){
        if([eachFile hasSuffix:@".fpf"]){
            filePath = [NSString stringWithFormat:@"%@%@",localDataPath,eachFile];
            break;
        }
    }
    return filePath;
}

/**
 * 设置飞行路径
 *
 * @param position
 */
-(void)chooseFlyRoute:(int)routeIndex{
    m_nRouteIndex = routeIndex;
}

/**
 * 开始飞行
 */
-(void)flyStart{
    if (!m_bRoutesLoaded) {
        return;
    }

    FlyManager *flyManager = m_sceneControl.scene.flyManager;
    if ([flyManager status]!=PLAY) {

        Routes *routes = flyManager.routes;
        
        if ([flyManager status]==STOP) {
            NSInteger routeCount = routes.count;
            if (m_nRouteIndex>=0 && m_nRouteIndex<routeCount) {
                [routes setCurrentRouteIndex:m_nRouteIndex];
                [self startRefreashFlyProgress];
            }else{
                return;
            }
        }
        
        [SScene setActionHelper:PAN3D];
//        [m_sceneControl setAction3D:PAN3D];
        [flyManager play];
        
        
    }
    
}

/**
 * 暂停飞行
 */
-(void)flyPause{
    if (!m_bRoutesLoaded) {
        return;
    }
    if ([m_sceneControl.scene.flyManager status]==PLAY) {
        [m_sceneControl.scene.flyManager pause];
         [SScene setActionHelper:PANSELECT3D];
//        [m_sceneControl setAction3D:PANSELECT3D];
    }
}

/**
 * 开始飞行或者暂停飞行
 */
-(void)flyPauseOrStart{
    if (!m_bRoutesLoaded) {
        return;
    }
    
    FlyManager *flyManager = m_sceneControl.scene.flyManager;
    if ([flyManager status]!=PLAY) {
        
        Routes *routes = flyManager.routes;
        
        if ([flyManager status]==STOP) {
            NSInteger routeCount = routes.count;
            if (m_nRouteIndex>=0 && m_nRouteIndex<routeCount) {
                [routes setCurrentRouteIndex:m_nRouteIndex];
            }else{
                return;
            }
        }
        
        [SScene setActionHelper:PAN3D];
//        [m_sceneControl setAction3D:PAN3D];
        [flyManager play];
        [self startRefreashFlyProgress];
        
    }else{
        [flyManager pause];
        [SScene setActionHelper:PANSELECT3D];
//        [m_sceneControl setAction3D:PANSELECT3D];
    }
}

/**
 * 停止飞行
 */
-(void)flyStop{
    if ( [m_sceneControl.scene.flyManager status]!=STOP) {
        [m_sceneControl.scene.flyManager stop];
        [SScene setActionHelper:PANSELECT3D];
//        [m_sceneControl setAction3D:PANSELECT3D];
    }
}

-(void)startRefreashFlyProgress{
    if (m_timer==nil) {
       m_timer = [NSTimer scheduledTimerWithTimeInterval:0.50 target:self selector:@selector(refreshFlyProgress) userInfo:nil repeats:YES];
    }
}

-(void)stopRefreashFlyProgress{
    if (m_timer!=nil) {
        [m_timer invalidate];
        m_timer = nil;
    }
}

-(void)refreshFlyProgress{
    if (self.flyProgressDelegate!=nil && [self.flyProgressDelegate respondsToSelector:@selector(flyProgressPercent:)]) {
        FlyManager *flymanager = m_sceneControl.scene.flyManager;
        if (flymanager.status != STOP) {
            double duration = [flymanager duration];
            if (duration==0) {
                [self.flyProgressDelegate flyProgressPercent:100];
            }else{
                double progress = [flymanager progress];
                double percent = progress / duration * 100;
                [self.flyProgressDelegate flyProgressPercent:percent];
            }
        }
    }
}

- (void)statuschanged:(FlyStatus)status{
    if (status == STOP) {
        [self stopRefreashFlyProgress];
    }
}

/**
 *保存当前飞行站点
 */
-(void)saveCurrentRouteStop{
    
    NSString* bundleId=[[NSBundle mainBundle] bundleIdentifier];
    NSLog(@"%@",bundleId);
//    sendTextContent();
    
    if(!m_RouteStops){
        m_route=[[Route alloc]init];
        [m_route setIsStopsVisible:false];
        [m_route setIsLinesVisible:false];
        [m_route setIsFlyAlongTheRoute:true];
        m_RouteStops=m_route.routeStops;
    }
    RouteStop* routeStop=[[RouteStop alloc]init];
    Camera tempCamera=m_sceneControl.scene.firstPersonCamera;
    Camera camera=tempCamera;
    [routeStop setCamera:camera];
    [m_RouteStops addRouteStop:routeStop];
    Point3D point3d={camera.longitude,camera.latitude,camera.altitude};
    if(!m_point3Ds){
        m_point3Ds =[[Point3Ds alloc]init];
    }
    [m_point3Ds addPoint3D:point3d];
    if(m_point3Ds.count>2){
        GeoStyle3D* lineStyle3D=[[GeoStyle3D alloc]init];
        [lineStyle3D setLineColor:[[Color alloc] initWithR:255 G:255 B:0]];
        [lineStyle3D setAltitudeMode:Absolute3D];
        [lineStyle3D setLineWidth:5];
        GeoLine3D* geoLine3D=[[GeoLine3D alloc]initWithPoint3Ds:m_point3Ds];
        [geoLine3D setStyle3D:lineStyle3D];
        [m_sceneControl.scene.trackingLayer3D AddGeometry:geoLine3D Tag:@"line"];
    }
}

/**
 *保存所有记录的站点并开始飞行
 */
-(void)saveRoutStop{
    FlyManager *flymanager = m_sceneControl.scene.flyManager;
    Routes* routes=flymanager.routes;
    int index=(int)[routes addRoute:m_route];
    [routes setCurrentRouteIndex:index];
    [flymanager play];
    [m_sceneControl.scene.workspace save];
}

/**
 *清除所有站点
 */
-(void)clearRoutStops{
    m_point3Ds =[[Point3Ds alloc]init];
    [m_sceneControl.scene.trackingLayer3D clear];
    int count=(int)m_RouteStops.count;
    for (int i=0; i<count; i++) {
        [m_RouteStops removeRouteStopAtIndex:0];
    }
}
/**
 * 站点暂停飞行
 */
-(void)routStopPasue{
    FlyManager *flyManager = m_sceneControl.scene.flyManager;
    if(flyManager != nil){
        [flyManager pause];
    }
}

/**
 *获取站点列表
 */
-(NSArray*)getStopList{
    NSArray* array=[[NSArray alloc] init];
    int count=m_RouteStops.count;
    for(int i=0;i<count;i++){
        NSMutableDictionary* dictoinary=[[NSMutableDictionary alloc] init];
        [dictoinary setObject:@"Name" forKey:[m_RouteStops routeStopAtIndex:i].name];
        [array arrayByAddingObject:dictoinary];
    }
    return array;
}

/**
 *获取站点
 */
-(RouteStop*) getStop:(NSString*) name{
    RouteStop* routeStop=[m_RouteStops routeStopWithName:name];
    return routeStop;
}

/**
 *移除站点
 */
-(BOOL)removeStop:(NSString*) name{
    if([m_RouteStops routeStopWithName:name]){
        [m_RouteStops removeRouteStopWithName:name];
        return true;
    }else{
        return false;
    }
}

@end

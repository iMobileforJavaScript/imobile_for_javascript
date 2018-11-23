//
//  FlyHelper3D.m
//  HypsometricSetting
//
//  Created by wnmng on 2018/11/21.
//  Copyright © 2018年 SuperMap. All rights reserved.
//

#import "FlyHelper3D.h"
#import "SuperMap/Scene.h"
#import "SuperMap/Routes.h"
#import "SuperMap/FlyManager.h"

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
    NSString *filePath = [NSString stringWithFormat:@"%@%@%@",localDataPath,strScenceName,@".fpf"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath]){
        return filePath;
    }else{
        return nil;
    }
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
        
        [m_sceneControl setAction3D:PAN3D];
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
        [m_sceneControl setAction3D:PANSELECT3D];
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
        
        [m_sceneControl setAction3D:PAN3D];
        [flyManager play];
        [self startRefreashFlyProgress];
        
    }else{
        [flyManager pause];
        [m_sceneControl setAction3D:PANSELECT3D];
    }
}

/**
 * 停止飞行
 */
-(void)flyStop{
    if ( [m_sceneControl.scene.flyManager status]!=STOP) {
        [m_sceneControl.scene.flyManager stop];
        [m_sceneControl setAction3D:PANSELECT3D];
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

@end

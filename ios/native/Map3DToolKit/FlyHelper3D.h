//
//  FlyHelper3D.h
//  HypsometricSetting
//
//  Created by wnmng on 2018/11/21.
//  Copyright © 2018年 SuperMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonObject_SuperMap.h"
#import "SuperMap/SceneControl.h"
#import "SuperMap/RouteStop.h"

@protocol FlyHelper3DProgressDelegate <NSObject>
@optional
-(void)flyProgressPercent:(int)percent;
@end


@interface FlyHelper3D : NSObject

/* 单例类 +(FlyHelper3D *)sharedInstance 获取实例 */
    SUPERMAP_SIGLETON_DEF(FlyHelper3D);

/**
 * 初始化飞行场景参数
 */
//-(void)LoadRoutes;
//-(void)setSceneControl:(SceneControl*)control;
//-(void)setSceneDir:(NSString*)sceneDirPath;
-(void)resetSceneControl:(SceneControl*)control SceneDir:(NSString*)sceneDirPath;

/**
 * 设置飞行进度回调
 *
 * @param flyProgress
 * @return
 */

/**
 * 获取飞行路径列表
 *
 * @return
 */
-(NSArray*)getFlyRouteNames;

/**
 * 设置飞行路径
 *
 * @param position
 */
-(void)chooseFlyRoute:(int)routeIndex;

/**
 * 开始飞行
 */
-(void)flyStart;

/**
 * 暂停飞行
 */
-(void)flyPause;

/**
 * 开始飞行或者暂停飞行
 */
-(void)flyPauseOrStart;

/**
 * 停止飞行
 */
-(void)flyStop;

/**
 * 进度接口
 */
@property(nonatomic) id<FlyHelper3DProgressDelegate> flyProgressDelegate;

/**
 *保存当前飞行站点
 */
-(void)saveCurrentRouteStop;

/**
 *保存所有记录的站点并开始飞行
 */
-(void)saveRoutStop;

/**
 *清除所有站点
 */
-(void)clearRoutStops;

/**
 *获取站点列表
 */
-(NSArray*)getStopList;

/**
 *获取站点
 */
-(RouteStop*) getStop:(NSString*) name;

/**
 *移除站点
 */
-(BOOL)removeStop:(NSString*) name;

@end

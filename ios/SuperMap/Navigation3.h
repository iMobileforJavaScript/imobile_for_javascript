//
//  Navigation3.h
//  LibUGC
//
//  Created by imobile-xzy on 16/8/5.
//  Copyright © 2016年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NaviDelegate.h"

@class GeoLine,NaviPath,Point2D,GPSData,Datasource,GeoStyle;
@protocol Navigation3ChangedDelegate;

@interface Navigation3 : NSObject

/**
 * 是否允许在引导的时候拖动地图
 */
@property(nonatomic)BOOL enablePanOnGuide;

/*
 加密回调
 */
@property(nonatomic,assign)id<Encryption> encryptionDelegate;

/*
 楼层变化回调
 */
@property(nonatomic,assign)id<Navigation3ChangedDelegate> navigation3ChangedDelegate;

//导航回调
@property(nonatomic,assign)id<NaviListener> navDelegate;

/**
 * 设置是否加密GPS数据，默认加密
 * @return
 */
@property(nonatomic)BOOL isEncryptGPS;

/**
 * 设置,获取小车车头向上
 * @param carBmp
 */
@property(nonatomic)BOOL isCarUpFront;

/**
 * 获得路径分析结果。Navistep数组
 */
-(NSArray*)getNaviPath;
/**
 * 开始引导
 * @param type 0：真实导航， 1：模拟导航   ,2：巡航 ,3：步行导航
 * @return
 */
-(BOOL)startGuide:(int)mode;

/**
 * 设置分析路径是否可见
 * @param isVisible 是否可见
 */
-(void)setPathVisible:(BOOL)pathVisible;
/**
 * 获取小车角度
 */
-(double)getCarAngle;

/**
 * 获取小车位置
 */
-(Point2D*)getCarPosition;

/**
 * 获取小车所在道路ID
 */
-(int)getPathID;

-(void)locateMap;
-(BOOL)isGuiding;

/**
 * 清除路径分析结果
 */
-(void)cleanPath;

/**
 * 停止引导
 */
-(BOOL)stopGuide;

/**
 * 设置GPS数据
 * @param newGps GPS数据
 */
-(void)setGPSData:(GPSData*)newGps;

/**
 * 设置室内地图所在的数据源。必选。
 * @param value
 */
-(void)setDatasource:(Datasource*)value;

/**
 * 设置起点与楼层ID
 * @param x 起点x坐标
 * @param y 起点y坐标
 */
-(void)setStartPoint:(double)x Y:(double)y ID:(NSString*)Id;

/**
 * 设置目的点与楼层ID
 * @param x 终点x坐标
 * @param y 终点y坐标
 */
-(void)setDestinationPoint:(double)x Y:(double)y ID:(NSString*)Id;

/**
 * 设置途经点与楼层ID
 * @param x 终点x坐标
 * @param y 终点y坐标
 */
-(void)addWayPoint:(double)x Y:(double)y ID:(NSString*)Id;

/**
 * 设置当前显示的楼层ID
 * @param value
 */
-(void)setCurrentFloorId:(NSString*)ID;

/**
 * 最佳路径分析
 * @return
 */
-(BOOL)routeAnalyst;

/**
 * 设置小车图标
 * @param carBmp
 */
-(void)setCarPicture:(UIImage*)carBmp;

/**
 * 设置是否自动采集GPS。默认自动采集
 * @param isAutoNavi
 */
-(void)setIsAutoNavi:(BOOL)isAutoNavi;

/**
 * 设置小车图标尺寸
 * @param carBmp
 */
-(void)setCarSize:(float)width height:(float)height;

/**
 * 设置当前楼层引导路径的样式
 * @param value 引导路径的样式
 */
-(void)setRouteStyle:(GeoStyle*)value;

/**
 * 设置其他楼层引导路径的样式
 * @param value 引导路径的样式
 */
-(void)setHintRouteStyle:(GeoStyle*)value;

-(void)resumeGuide;
-(void)pauseGuide;

/**
 * 设置模拟导航速度(单位m/s)
 */
-(void)setSimulationSpeed:(double)speed;

/**
 * 设置模拟导航间隔时间(单位ms)
 */
-(void)setSimulationInterval:(int)interval;

/**
 * 添加导航偏移容限，单位米
 * @param tolerance
 */
-(void)setDeviateTolerance:(double)tolerance;
@end
@protocol Navigation3ChangedDelegate <NSObject>

-(void)floorChangeCallBack:(NSString*)floorId;
-(void)azimuthChange:(double)dngle;
@end
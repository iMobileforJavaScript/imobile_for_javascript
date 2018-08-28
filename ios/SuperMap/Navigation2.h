//
//  Navigation2.h
//  LibUGC
//
//  Created by R3 on 14-8-13.
//  Copyright (c) 2014年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class GeoStyle;
@class GeoLine;
@class Point2D,GPSData;
@class Point2Ds;
@class DatasetVector,NaviStep;
@protocol navigation2ChangedDelegate;
@protocol Encryption;


@interface Navigation2 : NSObject

/**@brief 设置导航引导图层小车图片
 @param  carImage用户指定的图片（图片车头方向向下，默认图片为bundle中的carlocation.png）。
*/
@property (nonatomic,strong) UIImage *carImage;

/**@brief 设置导航引导图层左转图片
 @param  turnLeftImage用户指定的图片（默认图片为bundle中的carturnleft.png）。
 */
@property (nonatomic,strong) UIImage *turnLeftImage;

/**@brief 设置导航引导图层右转图片
 @param  turnRightImage用户指定的图片（默认图片为bundle中的carturnright.png）。
 */
@property (nonatomic,strong) UIImage *turnRightImage;

/**@brief 设置导航引导图层直行图片
 @param  straightImage用户指定的图片（默认图片为bundle中的carstraight.png）。
 */
@property (nonatomic,strong) UIImage *straightImage;

/**@brief 设置导航引导图层掉头图片
 @param  turnBackImage用户指定的图片（默认图片为bundle中的carturnback.png）。
 */
@property (nonatomic,strong) UIImage *turnBackImage;


/*
 加密回调
 */
@property(nonatomic,assign)id<Encryption> encryptionDelegate;

/**@brief 设置导航引导图层小车图片宽度
 @param  carWidth用户指定的图片宽度（默认为40px）。
 */
@property (nonatomic,assign) float carWidth;

/**@brief 设置导航引导图层小车图片高度
 @param  carHeight用户指定的图片高度（默认为40px）。
 */
@property (nonatomic,assign) float carHeight;

//是否设置小车车头向上
@property(nonatomic,assign) BOOL isCarUpFront;
@property (nonatomic,unsafe_unretained) id<navigation2ChangedDelegate> navi2Delegate;

/**@brief 设置路径规划的起点。
 @param  x 起点经度坐标（度）。
 @param  y 起点纬度坐标（度）。
 */
-(void)setStartPoint:(double)x sPointY:(double)y;

/**@brief 设置路径规划的终点。
 @param  x 终点经度坐标（度）。
 @param  y 终点纬度坐标（度）。
 */
-(void)setDestinationPoint:(double)x dPointY:(double)y;

/**@brief 执行路径分析。
 @return  路径分析成功返回1，路径分析失败返回0，起点周围无道路返回-1，终点周围无道路返回-2。
 */
-(BOOL)routeAnalyst;

/**
 *获取导航路径详情
 */
-(NSArray*)getNaviPath;

///获得路径分析线路 。
-(GeoLine *)getRoute;

/** @brief 开始引导。
 <p> 引导状态的值为[0，1，2，3]，其分别表示执行真实导航、执行模拟导航、执行定位点巡航、执行步行导航。
 @param  status 引导状态。
 @return  启动导航成功，返回true， 否则返回false。
 */
-(BOOL)startGuide:(int)status;

/**@brief 获取车辆行驶角度。
 <P> 返回角度为车辆前进方向与正北方向的顺时针夹角，角度为“度”。
 @return  车辆行驶角度。
 */
-(double)getCarAngle;

/**@brief 获取车辆当前位置。
 <p> 即获取当前车辆所在地的经纬度坐标，单位为“度”。
 @return  车辆当前位置。
 */
-(Point2D *)getCarPosition;


/**@brief 获取车辆当前屏幕像素点。
 @return  车辆当前屏幕像素点。
 */
-(Point2D *)getCarPiexl;

/**@brief 设置导航数据集。
 @param  dataset 导航数据集。
 */
-(void)setNetworkDataset:(DatasetVector*)dataset;

/**@brief 设置转向数据集。
 @param  dataset 导航转向数据集。
 */
-(void)setTurnDataset:(DatasetVector*)dataset;

/**@brief 设置高程点数据集。
 @param  dataset 导航高程点数据集。
 */
-(void)setDatasetPoint:(DatasetVector *)dataset;

/**@brief 加载导航模型。
 */
-(BOOL)load;

/**@brief 加载导航模型。
 @param  filePath 加载内存文件路径。
 */
-(BOOL) loadModel:(NSString*)filePath;


/**@brief 当前是否在引导过程中。
 @return  当前在引导过程中，返回true，否则返回false。
 */
-(BOOL)isGuiding;

///清除路径分析结果。
-(void)cleanPath;

/**@brief 停止引导。
 @return  停止引导成功，返回true，否则返回false。
 */
-(BOOL)stopGuide;

/**@brief 设置是否高亮显示规划出的路线。
 @param  isVisible 一个布尔值，用来指示是否高亮显示规划出的路线，true，表示高亮显示，false,表示不高亮显示。
 */
-(void)setPathVisible:(BOOL)isVisible;

/**@brief 设置GPS数据。
 @param  newGps GPS数据。
 */
-(void)setGPSData:(GPSData *)newGps;

/**@brief 设置导航时是否可以移动
 @param  bPan是否移动
 */
-(void)enablePanOnGuide:(BOOL)bPan;

/**@brief 获取小车所在道路ID
 */
-(int)getPathID;

/**@brief 设置GPS是否加密
 */
-(void)setIsEncryptGPS:(BOOL)bEncrypt;

/**@brief 设置GPS是否自动采集
 */
-(void)setIsAutoNavi:(BOOL)bAuto;

/**@brief 设置隐藏导航信息
 */
-(void)setNaviInfoVisible:(BOOL)bVisible;

/**
 * 设置引导路径的样式
 * @param value 引导路径的样式
 */
-(void)setRouteStyle:(GeoStyle*)style;
/**
 * 设置起点和终点的引导线
 * @param value 引导路径的样式
 */
-(void)setShowGuideLine:(GeoStyle*)style;

/**
 *@brief  设置途经点
 * @param x 终点x坐标
 * @param y 终点y坐标
 */
-(void)addWayPointWithX:(double)x y:(double)y;

/**
 * 障碍节点集合
 */
@property (nonatomic)NSMutableArray *barrierNodeArray;
/**
 障碍点集合
 */
@property (nonatomic)Point2Ds *barrierPoints;
/**
 * 设置障碍边
 * @param value 障碍边集合（参数为null时，为清空障碍边）
 */
-(void) setBarrierEdges:(NSMutableArray *)barrierEdgeArray;
-(void) locateMap;
-(void) pauseGuide;
-(void) resumeGuide;
/**
 * 设置模拟导航速度(单位m/s)
 */
-(void) setSimulationSpeed:(double)speed;
/**
 * 设置模拟导航间隔时间(单位ms)
 */
-(void) setSimulationInterval:(int)interval;
/**
 * 添加导航偏移容限，单位米
 * @param tolerance
 */
-(void) setDeviateTolerance:(double)deviateTolerance;


@end

@protocol navigation2ChangedDelegate<NSObject>
@optional
-(void)navi2ClimbRise:(double)dRise drop:(double)dDrop;
-(void)navi2GuideStart;
-(void)navi2GuideStop;
-(void)navi2GuideArrive;
-(void)navi2DistanceChanged:(double)distance;
-(void)navi2AzimuthChanged:(double)dAngle;
@end

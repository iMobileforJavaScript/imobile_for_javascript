//
//  Navigation.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "NaviDelegate.h"

@class GeoLine;
@class Point2D;
@class GeoStyle;
@class NaviInfo,GPSData;



/**导航类，导航类提供路径分析和引导功能。
 1. 设置起点和目的地后，可以进行路径分析，并在分析成功后进行导航；
 2. 路径分析包含四种模式：推荐、时间最快、距离最短和最少收费；
 3. 引导分为真实导航、模拟导航以及定位点巡航等三种模式。
 <p>  引导中提供引导信息的显示。

*/
@interface Navigation : NSObject

/*
 加密回调
 */
@property(nonatomic,assign)id<Encryption> encryptionDelegate;
///导航回调
@property(nonatomic,assign)id<NaviListener> navDelegate;

/**
 * 设置,获取小车车头向上
 * @param carBmp
 */
@property(nonatomic,assign)BOOL isCarUpFront;
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
 <p>  路径分析模式的值为[0，1，2，3]， 其分别表示推荐模式、时间最快模块、距离最短模式、和最少收费模式。
 @param  mode 路径分析模式。
 @return  路径分析成功返回1，路径分析失败返回0，起点周围无道路返回-1，终点周围无道路返回-2。
 */
-(int)routeAnalyst:(int)mode;

 ///获得路径分析线路 。
-(GeoLine *)getRoute;

/** @brief 开始引导。
 <p> 引导状态的值为[0，1，2]，其分别表示执行真实导航、执行模拟导航、执行定位点巡航。
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

/**@brief 链接导航数据，包括路径分析数据和引导数据。
 @param  dataPath 导航数据文件所在路径。
 @return  链接导航数据成功，返回true，否则返回false。
 */
-(BOOL)connectNaviData:(NSString *)dataPath;

/**@brief 引导过程中是否允许平移地图。
 @param  bPan 一个布尔值，用来指示在导航过程中是否允许平移地图，true，表示允许，false，表示不允许。
 */
-(void)enablePanOnGuide:(BOOL)bPan;

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

/**@brief 根据屏幕设置导航过程中引导信息布局，以适应横竖屏切换。
 @param  width 屏幕宽度。
 @param  height 屏幕高度。
 @return  根据屏幕设置导航过程中引导信息布局成功，返回true，否则返回false。
 */
-(BOOL)setViewSize:(int)width height:(int)height;

//
// * 底层回调的语音播报,回调函数的反问权限一定不能写成private的
//
//+(void)playInfo:(NSString *)info;

/**@brief 设置是否高亮显示规划出的路线。
 @param  isVisible 一个布尔值，用来指示是否高亮显示规划出的路线，true，表示高亮显示，false,表示不高亮显示。
 */
-(void)setPathVisible:(BOOL)isVisible;

/**@brief 设置GPS数据。
 @param  newGps GPS数据。
 */
-(void)setGPSData:(GPSData *)newGps;
/**
 * 设置引导路径的样式
 * @param value 引导路径的样式
 */
-(void)setRouteStyle:(GeoStyle*)style;

/**
 * 添加途经点
 * @param x 途经点x坐标
 * @param y 途经点y坐标
 */
-(BOOL)addWayPoint:(double)x Y:(double)y;

/**
 * 获取当前位置到目的地距离
 */
-(double)getDisToDestination;
/**
 * 获取当前位置到下一路口距离
 */
-(double)getDisToSwerve;
/**
 * 获取当前道路名称
 */
-(NSString*)getCurRoadName;
/**
 * 获取下一道路名称
 */
-(NSString*)getNextRoadName;
/**
 * 获取导航主动作
 */
-(int)getNaviAction;
/**
 * 继续导航
 */
-(void)resumeGuide;
/**
 * 暂停导航
 */
-(void)pauseGuide;
/**
 *地图移动到小车位置
 */
-(void)locateMap;

/**
 *获取导航路径详情
 */
-(NSArray*)getNaviPath;

/**
 * 设置模拟导航速度(单位m/s)
 */
-(BOOL)setSimulationSpeed:(double)speed;

/**
 * 设置模拟导航间隔时间(单位ms)
 */
-(BOOL)setSimulationInterval:(int)interval;

@end


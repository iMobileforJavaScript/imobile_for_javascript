//
//  Route.h
//  LibUGC
//
//  Created by LK on 15/11/25.
//  Copyright © 2015年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RouteStops, GeoStyle3D, GeoLine3D;
@interface Route : NSObject

//  设置或获取站点集合
@property (nonatomic, strong) RouteStops *routeStops;

//  设置或获取路线风格
@property (nonatomic, strong) GeoStyle3D *geoStyle3D;

//  设置或获取路线名称
@property (nonatomic, copy) NSString *name;

//  站点是否可见
@property (nonatomic, assign) BOOL isStopsVisible;

//  路线是否可见
@property (nonatomic, assign) BOOL isLinesVisible;

//  高度是否固定
@property (nonatomic, assign) BOOL isAltitudeFixed;

//  仰角是否固定
@property (nonatomic, assign) BOOL isHeadingFixed;

//  倾斜角是否固定
@property (nonatomic, assign) BOOL isTiltFixed;

//  设置或获取是否循环飞行
@property (nonatomic, assign) BOOL isFlyingLoop;

//  设置或获取是否沿线飞行
@property (nonatomic, assign) BOOL isFlyAlongTheRoute;

//  设置或获取路线的速度
@property (nonatomic, assign) double speed;

/**@brief 将路线输出为XML字符串。
 @return  XML字符串。
 */
- (NSString *)toXML;

/**@brief 通过XML字符串得到飞行路线。
 @param  xml XML字符串。
 @return  获取成功返回 YES，否则返回 NO。
 */
- (BOOL)fromXML:(NSString *)xml;

/**@brief 将路线输出为线对象。
 @return  线对象。
 */
- (GeoLine3D *)toGeoLine3D;

/**@brief 通过线对象得到飞行路线。
 @param  geoLine3D 线对象。
 @return  获取成功返回 YES，否则返回 NO。
 */
- (BOOL)fromGeoLine3D:(GeoLine3D *)geoLine3D;

@end

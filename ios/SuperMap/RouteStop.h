//
//  RouteStop.h
//  LibUGC
//
//  Created by LK on 15/11/25.
//  Copyright © 2015年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Camera.h"

@class GeoStyle3D;
@interface RouteStop : NSObject

//  设置或获取站点名称
@property (nonatomic, copy) NSString *name;

//  设置或获取站点风格
@property (nonatomic, strong) GeoStyle3D *geoStyle3D;

//  设置或获取站点相机
@property (nonatomic, assign) Camera camera;

//  设置或获取站点等待时间
@property (nonatomic, assign) double waitTime;

//  设置或获取间隔时间
@property (nonatomic, assign) double duration;

//  获取绕站点飞行时间
@property (nonatomic, readonly, assign) double rotationDuration;

//  是否被排除
@property (nonatomic, assign) BOOL isExcluded;

//  设置或获取站点速度
@property (nonatomic, assign) double speed;

//  设置或获取转弯时间
@property (nonatomic, assign) double turnTime;

//  是否慢速过弯
@property (nonatomic, assign) BOOL isSlowTurning;

//  设置或获取绕站点飞行的角速度
@property (nonatomic, assign) double angularSpeed;

/**@brief 将站点输出为XML字符串。
 @return  XML字符串。
 */
- (NSString *)toXML;

/**@brief 通过XML字符串得到飞行站点。
 @param  xml XML字符串。
 @return  获取成功返回 YES，否则返回 NO。
 */
- (BOOL)fromXML:(NSString *)xml;

@end
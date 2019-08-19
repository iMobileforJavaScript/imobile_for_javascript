//
//  LookAt.h
//  LibUGC
//
//  Created by zyd on 17/8/30.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AltitudeMode3D.h"

/**
 相机类
 通过指定镜头所观察点位置、方向角、俯仰角及镜头和所观察点的距离,确定场景位置
 */

@interface LookAt : NSObject

// 返回或设置镜头所查看点的高度
@property (assign, nonatomic) double altitude;

// 返回或设置方位角。值范围0-360度,与正北方向的夹角,顺时针
@property (assign, nonatomic) double heading;

// 返回或设置镜头所查看点的维度
@property (assign, nonatomic) double latitude;

// 返回或设置镜头所查看点的经度
@property (assign, nonatomic) double longitude;

// 返回或设置俯仰角。值范围0-90度。0度表示从正上方垂直地表查看,90度表示沿地平线方向查看
@property (assign, nonatomic) double tilt;

// 返回或设置镜头到镜头所查看点的距离。单位:米
@property (assign, nonatomic) double range;

// 返回或设置镜头所查看点的海拔高度模式
@property (assign, nonatomic) double altitudeMode;

// 返回有效性
@property (assign, readonly, getter=isValid, nonatomic) BOOL valid;

/**
 @brief 通过经度、维度、高度、俯仰角、方位角、距离和高度模式初始化
 @param longitude 经度
 @param latitude 维度
 @param altitude 高度
 @param tilt 俯仰角
 @param heading 方位角
 @param range 距离
 @param mode 高度模式
 @return LookAt实例
 */
- (instancetype)initWithLongitude:(double)longitude latitude:(double)latitude altitude:(double)altitude tilt:(double)tilt heading:(double)heading range:(double)range altitudeMode:(AltitudeMode3D)mode;

@end

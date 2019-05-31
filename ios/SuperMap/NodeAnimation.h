//
//  NodeAnimation.h
//  LibUGC
//
//  Created by zyd on 16/12/1.
//  Copyright © 2016年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NodeAnimationPlayMode.h"
//#import "Point3D.h"

@class Geometry3D;
@protocol NodeAnimationDelegate;

@interface NodeAnimation : NSObject

/* 获取或设置节点动画运行周期的时长, 单位是秒 */
@property (nonatomic, assign) double length;

/* 获取或设置节点动画是否启用 */
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;

/* 获取或设置节点动画的播放模式 */
@property (nonatomic, assign) NodeAnimationPlayMode playMode;

/* 获取或设置节点动画所处的时间位置, 单位是秒 */
@property (nonatomic, assign) double timePosition;

/* 获取节点动画的位置 */
//@property (nonatomic, readonly, assign) Point3D position;

/* 获取前进方向角, 水平方向上与正北方向的夹角 */
@property (nonatomic, readonly, assign) double direction;

/* 倾斜方向角, 与水平面的夹角, 向上为正 */
@property (nonatomic, readonly, assign) double pitch;

/* 节点动画代理 */
@property (nonatomic, assign) id<NodeAnimationDelegate> delegate;

/**
 @brief   为节点动画设置运动轨迹
 @param   运行轨迹
 @return  true 设置成功, false 设置失败
 */
- (BOOL)setTrack:(Geometry3D *)trackLine;

/**
 @brief   获取节点动画的运动轨迹
 @return  运动轨迹
 */
- (Geometry3D *)track;

@end

//  节点动画代理类
@protocol NodeAnimationDelegate <NSObject>

@optional

//  节点动画时间位置改变时触发
- (void)nodeAnimationTimePositionDidChange:(NodeAnimation *)nodeAnimation;

@end

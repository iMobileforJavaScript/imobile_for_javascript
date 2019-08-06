//
//  NaviEncryption.h
//  Transportion3D
//
//  Created by imobile-xzy on 16/8/23.
//  Copyright © 2016年 imobile. All rights reserved.
//
@class Point2D,NaviInfo;
@protocol Encryption <NSObject>

/**
 * 数据加密算法
 * @param GPS 	加密前的GPS点
 * @return 		加密后的GPS点
 */
-(Point2D*)encryptGPS:(Point2D*)GPS;

@end

@protocol NaviListener<NSObject>
@optional

/**
 * 导航引导信息更新回调
 * @param naviInfo 引导信息
 */
-(void)onNaviInfoUpdate:(NaviInfo*)naviInfo;

/**
 * 启动导航后回调
 */
-(void)onStartNavi;

/**
 * 到达目的地回调
 */
-(void)onAarrivedDestination;

/**
 * 停止导航后回调
 */
-(void)onStopNavi;

@end
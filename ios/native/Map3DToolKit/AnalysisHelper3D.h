//
//  AnalysisHelper3D.h
//  HypsometricSetting
//
//  Created by wnmng on 2018/11/21.
//  Copyright © 2018年 SuperMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonObject_SuperMap.h"
#import "SuperMap/SceneControl.h"

@protocol Analysis3DDelegate <NSObject>
@optional
/**
 * 测量距离回调
 */
-(void)distanceResult:(NSDictionary*)distance;
/**
 * 测量面积回调
 */
-(void)areaResult:(NSDictionary*)area;

-(void)perspectiveResultX:(NSString*)strLocationX Y:(NSString*)strLocationY Z:(NSString*)strLocationZ count:(int) count;

@end


@interface AnalysisHelper3D : NSObject

/* 单例类 +(FlyHelper3D *)sharedInstance 获取实例 */
    SUPERMAP_SIGLETON_DEF(AnalysisHelper3D);

-(void)initializeWithSceneControl:(SceneControl*)control;

@property (nonatomic) id<Analysis3DDelegate> delegate;

// 开启距离测量分析
-(void)startMeasureAnalysis;

// 开启测量面积分析
-(void)startSureArea;

// 关闭所有分析
-(void)closeAnalysis;

- (void)tracking3DEvent:(Tracking3DEvent*)event;

@end

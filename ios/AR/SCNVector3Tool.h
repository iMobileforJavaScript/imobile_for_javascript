//
//  SCNVector3Tool.h
//  ARRanging
//
//  Created by zhang_jian on 2018/4/19.
//  Copyright © 2018年 zhangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

@interface SCNVector3Tool : NSObject

//将相机世界坐标的x,y,z轴值转换并回传出去
+ (SCNVector3)positionTranform:(matrix_float4x4)tranform;

//转换平面坐标
+ (SCNVector3)positionExtent:(vector_float3)extent;

//计算三维坐标系中两点间的距离
+ (CGFloat)distanceWithVector:(SCNVector3)vector StartVector:(SCNVector3)startVector;

//对比两个SCNVector3
+ (BOOL)isEqualBothSCNVector3WithLeft:(SCNVector3)leftVector Right:(SCNVector3)rightVector;

//文字位置放在center
+ (SCNVector3)computTextPostionWithVector:(SCNVector3)vector StartVector:(SCNVector3)startVector;

@end

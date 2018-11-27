//
//  ClipUtil3D.h
//  Supermap
//
//  Created by wnmng on 2018/11/22.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SUperMap/Point3D.h"
#import "SuperMap/BoxClipPart.h"

@class Point2D,SceneControl,GeoBox;
@interface ClipUtil3D : NSObject


/**
 * cross裁剪
 * @param sceneControl
 * @param position   裁剪的位置点
 * @param dimension   裁剪面积的长和宽
 * @param rotX      x旋转值
 * @param rotY      y旋转值
 * @param rotZ      z旋转值
 * @param extrudeDistance   拉伸高度
 */
+(void)clipSceneCross:(SceneControl*)sceneControl position:(Point3D)position dimension:(Point2D*)dimension rotX:(double)rotX rotY:(double)rotY rotZ:(double)rotZ extrudeDistance:(double)extrudeDistance;

/**
 * Box裁剪
 * @param sceneControl
 * @param box   指定的长方体盒子
 * @param part  指定裁剪区域
 */
+(void)clipSceneBox:(SceneControl*)sceneControl box:(GeoBox*)box  part:(BoxClipPart)part;

/**
 * 裁剪面分析，按顺序设置三个顶点的位置，裁剪面分析的结果指只显示该面法线方向的部分
 * @param sceneControl
 * @param firstPoint    第一个点
 * @param secondPoint   第二个点
 * @param thirdPoint    第三个点
 */
+(void)clipScenePlane:(SceneControl*)sceneControl firstPoint:(Point3D)firstPoint secondPoint:(Point3D)secondPoint thirdPoint:(Point3D)thirdPoint;

@end

//
//  LableHelper3D.h
//  Supermap
//
//  Created by imobile-xzy on 2018/11/21.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperMap/SceneControl.h"
#import "SuperMap/Layer3Ds.h"
#import "SuperMap/Layer3D.h"
#import "SuperMap/Scene.h"
#import "SuperMap/GeoLine3D.h"
#import "SuperMap/PixelToGlobeMode.h"
#import "SuperMap/TrackingLayer3D.h"

@interface LableHelper3D : NSObject
+(void)initSceneControl:(SceneControl*)control path:(NSString*)path kml:(NSString*)kmlName;

/**
 * 开始绘制面积
 */
+(void)startDrawArea;

/**
 * 开始绘制文本
 */
+(void)startDrawText;

/**
 * 开始绘制线段
 */
+(void)startDrawLine;

/**
 * 开始绘制点
 */
+(void)startDrawPoint;

/**
 * 返回
 */
+(void)back;

/**
 * 清除所有标注
 */
+(void)clearAllLabel;

/**
 * 保存
 */
+(void)save;

/**
 * 添加文本标注
 * @param point
 * @param text
 */
+(void)addGeoText:(CGPoint)point test:(NSString*)text;

+(void)setDelegate:(id)delegate;
@end

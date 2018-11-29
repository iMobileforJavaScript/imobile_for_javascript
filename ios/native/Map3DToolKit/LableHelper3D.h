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
#import "SingletonObject_SuperMap.h"

@protocol LableHelper3DDelegate<NSObject>
@optional
-(void)drawTextAtPoint:(Point3D)pnt;
-(void)drawFavoriteAtPoint:(Point3D)pnt;
@end


@interface LableHelper3D : NSObject
SUPERMAP_SIGLETON_DEF(LableHelper3D);
-(void)initSceneControl:(SceneControl*)control path:(NSString*)path kml:(NSString*)kmlName;

/**
 * 开始绘制面积
 */
-(void)startDrawArea;

/**
 * 开始绘制文本
 */
-(void)startDrawText;

/**
 * 开始绘制线段
 */
-(void)startDrawLine;

/**
 * 开始绘制点
 */
-(void)startDrawPoint;
/**
 * 开始绘制兴趣点
 */
-(void)startDrawFavorite;
/**
 * 设置兴趣点文本
 */
-(void)setFavoriteText:(NSString*)text;
/**
 * 保存兴趣点
 */
-(void)saveFavoritePoint;
/**
 * 添加环绕飞行的点
 *
 * @param point
 */
-(void)addCirclePoint:(Point3D)pnt3D;
/**
 * 清除环绕飞行的点
 */
-(void) clearCirclePoint;
/**
 * 环绕飞行
 */
-(void)circleFly;

/**
 * 返回
 */
-(void)back;

/**
 * 清除所有标注
 */
-(void)clearAllLabel;

/**
 * 保存
 */
-(void)save;

/**
 * 添加文本标注
 * @param point
 * @param text
 */
-(void)addGeoText:(Point3D)pnt test:(NSString*)text;

@property (nonatomic,assign) id<LableHelper3DDelegate> delegate;

- (void)tracking3DEvent:(Tracking3DEvent*)event;

-(void)reset;

@end

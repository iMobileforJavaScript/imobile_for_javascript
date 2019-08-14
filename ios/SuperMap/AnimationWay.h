//
//  AnimationWay.h
//  Objects_iOS
//
//  Created by imobile-xzy on 2019/7/11.
//  Copyright © 2019 beijingchaotu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationGO.h"
#import "Point3D.h"
#include "Point3Ds.h"
#import "Color.h"


@interface AnimationWay : AnimationGO

/**
 * 路径动画的路径类型  0);//折线 1);//曲线
 */
@property(nonatomic)int pathType;
@property(nonatomic)BOOL showPathTrack;
@property(nonatomic)double trackLineWidth;
@property(nonatomic,strong)Color* trackLineColor;

//! \brief 路径动画是否沿轨迹切线方向。
//! \param bPathTrack [in]路径动画是否沿轨迹切线方向。
@property(nonatomic)BOOL pathTrackDir;

-(BOOL)addPathPt:(Point3D)vecPath;
-(BOOL)insertPathPt:(int)index pt:(Point3D)vecPath;
-(BOOL)setPathPt:(int)index pt:(Point3D)vecPath;
-(BOOL)removePathPtAt:(int)index;
-(int)getPathPtCount;
-(void)removeAllPathPt;
-(Point3Ds*)getAllPathPt;
@end

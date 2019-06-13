//
//  ScaleViewHelper.h
//  ScaleView辅助显示类 返回信息给RN层，由RN层绘制View显示比例尺
//  Supermap
//
//  Created by supermap on 2019/6/3.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperMap/Map.h"
#import "SuperMap/Point2D.h"
#import "SuperMap/Point2Ds.h"
#import "SuperMap/MapControl.h"
#import "SuperMap/PrjCoordSys.h"
#import "SuperMap/ScaleView.h"


@interface ScaleViewHelper : NSObject
@property(nonatomic,assign)MapControl *mMapControl;
/*缩放等级*/
@property(nonatomic,assign)int mScaleLevel;
/*要显示的文字*/
@property(nonatomic,assign)NSString *mScaleText;
/*比例尺宽度*/
@property(nonatomic,assign)float mScaleWidth;
/*显示值类型*/
@property(nonatomic,assign)ScaleType mScaleType;

-(id)initWithMapControl:(MapControl *)mapcontrol;
-(id)initWithMapControl:(MapControl *)mapcontrol Type:(ScaleType)scaleType;

-(int)getScaleLevel;
-(double)getPixMapScale;
-(NSString *)getScaleText:(int)level;
-(float)getScaleWidth:(int)level;

@end

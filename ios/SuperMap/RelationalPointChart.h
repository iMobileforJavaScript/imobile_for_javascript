//
//  RelationalPointChart.h
//  HotMap
//
//  Created by imobile-xzy on 16/12/16.
//  Copyright © 2016年 imobile-xzy. All rights reserved.
//

#import "ChartView.h"

@class MapControl;
@class Color;

@interface RelationalPointChart : ChartView

//是否开启动画效果，默认NO
@property(nonatomic)BOOL isAnimation;
//动态效果Image
@property(nonatomic,strong)UIImage* animationImage;
//设置子关系点颜色
@property(nonatomic,strong)Color* childRelationalPointColor;
//关系线终点颜色，默认为子关系点颜色
@property(nonatomic,strong)Color* endPointColor;
//子关系点大小，默认2
@property(nonatomic)float childPointSize;
//线宽，默认1.5
@property(nonatomic)float lineWidth;

-(id)initWithMapControl:(MapControl*)mapControl;
//设置关系点调色板
-(void)setColorScheme:(ColorScheme*)colorScheme;

//设置聚合点显示最大半径,默认40，最小20
-(void)setMaxRadious:(float)maxRadious;
@end



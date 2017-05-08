//
//  GridHotChart.h
//  HotMap
//
//  Created by imobile-xzy on 17/3/17.
//  Copyright © 2017年 imobile-xzy. All rights reserved.
//

#import "ChartView.h"

@class ColorScheme,Color,MapControl;
@interface GridHotChart : ChartView
//初始化，参数 1.绘制层
-(id)initWithMapControl:(MapControl*)mapControl;
//设置调色板
-(void)setColorScheme:(ColorScheme*)colorScheme;

//格网大小，地理范围。默认5KM,单位：米
@property(nonatomic)float gridSize;
@end

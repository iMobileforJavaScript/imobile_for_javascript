//
//  DensityPlotChart.h
//  HotMap
//
//  Created by imobile-xzy on 16/11/28.
//  Copyright © 2016年 imobile-xzy. All rights reserved.
//

#import "ChartView.h"

@class MapControl;
@interface PointDensityChart : ChartView
-(id)initWithMapControl:(MapControl*)mapControl;
//默认3
-(void)setRadius:(float)radious;
//设置调色板
-(void)setColorScheme:(ColorScheme*)colorScheme;
@end

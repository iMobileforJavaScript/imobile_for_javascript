//
//  ScatterChart.h
//  HotMap
//
//  Created by imobile-xzy on 17/5/24.
//  Copyright © 2017年 imobile-xzy. All rights reserved.
//

#import "ChartView.h"

@class MapControl;
@interface ScatterChart : ChartView
-(id)initWithMapControl:(MapControl*)mapControl;
//默认10;
-(void)setRadius:(float)radious;
//设置调色板
-(void)setColorScheme:(ColorScheme*)colorScheme;
@end

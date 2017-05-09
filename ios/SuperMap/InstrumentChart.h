//
//  InstrumentChart.h
//  HotMap
//
//  Created by imobile-xzy on 17/1/13.
//  Copyright © 2017年 imobile-xzy. All rights reserved.
//

#import "ChartView.h"

@interface InstrumentChart : ChartView

//是否显示当前值，默认显示
@property(nonatomic)BOOL isShowCurValue;

//仪表显示最小值
@property (nonatomic) float minValue;

//仪表值显示最大值
@property (nonatomic) float maxValue;

//仪表分段数
@property(nonatomic)int splitCount;

//仪表绘制起始角度，默认45度
@property (nonatomic) CGFloat startAngle;

//仪表绘制结束角度，默认315度
@property (nonatomic) CGFloat endAngle;

//仪表背景色
@property(nonatomic,strong)UIColor* backgroundColor;

//设置刻度调色板
@property(nonatomic,strong)ColorScheme* gradient;


@end

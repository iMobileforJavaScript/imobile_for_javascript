//
//  JSBarChart.m
//  Supermap
//
//  Created by 王子豪 on 2017/8/10.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSBarChart.h"

@implementation JSBarChart{
    BarChart* _barChart;
}

-(void)layoutSubviews{
    _barChart = [[BarChart alloc]initWithFrame:self.bounds];
     [self addSubview:_barChart];
    
    if (self.title) {
         _barChart.title = self.title;
        [_barChart update];
    }
   
    if (self.textSize) {
        _barChart.textSize = self.textSize;
        [_barChart update];
    }
    
    _barChart.isValueAlongXAxis = self.isValueAlongXAxis;
    [_barChart update];
    
    if (self.axisLableSize) {
        _barChart.axisLableSize = self.axisLableSize;
        [_barChart update];
    }
    
    if (self.axisTitleSize) {
        _barChart.axisTitleSize = self.axisTitleSize;
        [_barChart update];
    }
    
    if (self.xAxisTitle) {
        _barChart.xAxisTitle = self.xAxisTitle;
        [_barChart update];
    }
    
    if (self.yAxisTitle) {
        _barChart.yAxisTitle = self.yAxisTitle;
        [_barChart update];
    }
    
    if (self.hightLightColor) {
        _barChart.hightLightColor = self.hightLightColor;
        [_barChart update];
    }
    
    if (self.chartDatas) {
        [_barChart addChartDatas:self.chartDatas];
        [_barChart update];
        
    }
}

@end

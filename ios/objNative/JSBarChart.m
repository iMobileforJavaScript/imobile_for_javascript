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
    }
   
    if (self.textSize) {
        _barChart.textSize = self.textSize;
    }
    
    _barChart.isValueAlongXAxis = self.isValueAlongXAxis;
    
    if (self.axisLableSize) {
        _barChart.axisLableSize = self.axisLableSize;
    }
    
    if (self.axisTitleSize) {
        _barChart.axisTitleSize = self.axisTitleSize;
    }
    
    if (self.xAxisTitle) {
        _barChart.xAxisTitle = self.xAxisTitle;
    }
    
    if (self.yAxisTitle) {
        _barChart.yAxisTitle = self.yAxisTitle;
    }
    
    if (self.hightLightColor) {
        _barChart.hightLightColor = self.hightLightColor;
    }
    
    if (self.chartDatas) {
        [_barChart addChartDatas:self.chartDatas];
        [_barChart update];
        
    }
}

@end

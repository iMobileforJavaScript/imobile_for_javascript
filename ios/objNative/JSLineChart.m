//
//  JSLineChart.m
//  Supermap
//
//  Created by 王子豪 on 2017/8/10.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSLineChart.h"

@implementation JSLineChart{
    LineChart* _lineChart;
}
-(void)layoutSubviews{
    _lineChart = [[LineChart alloc]initWithFrame:self.bounds];
    [self addSubview:_lineChart];
    
    if (self.title) {
        _lineChart.title = self.title;
    }
    
    if (self.textSize) {
        _lineChart.textSize = self.textSize;
    }
    
    if (self.axisTitleSize) {
        _lineChart.axisTitleSize = self.axisTitleSize;
    }
    
    if (self.axisLableSize) {
        _lineChart.axisLableSize = self.axisLableSize;
    }
    
    if (self.xAxisTitle) {
        _lineChart.xAxisTitle = self.xAxisTitle;
    }
    
    if (self.yAxisTitle) {
        _lineChart.yAxisTitle = self.yAxisTitle;
    }
    
    _lineChart.allowsUserInteraction = self.allowsUserInteraction;
    
    if (self.hightLightColor) {
        _lineChart.hightLightColor = self.hightLightColor;
    }
    
    if (self.geoId) {
        [_lineChart setSelectedGeoID:self.geoId];
    }
    
    if (self.chartDatas) {
        [_lineChart addChartDatas:self.chartDatas];
        [_lineChart update];
    }
}
@end

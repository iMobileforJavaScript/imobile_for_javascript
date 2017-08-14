//
//  JSPieChart.m
//  Supermap
//
//  Created by 王子豪 on 2017/8/14.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSPieChart.h"

@implementation JSPieChart{
    PieChart* _pieChart;
}
    @dynamic center;
-(void)layoutSubviews{
    _pieChart = [[PieChart alloc]initWithFrame:self.bounds];
    [self addSubview:_pieChart];
    
    if (self.title) {
        _pieChart.title = self.title;
    }
    
    if (self.textSize) {
        _pieChart.textSize = self.textSize;
    }
    
    if (self.radious) {
        _pieChart.radious = self.radious;
    }
    
    if (self.geoId) {
        [_pieChart setSelectedGeoID:self.geoId];
    }
    
    if (self.textColor) {
        _pieChart.textColor = self.textColor;
    }
    
    if (self.chartDatas) {
        [_pieChart addChartDatas:self.chartDatas];
        [_pieChart update];
    }
}
@end

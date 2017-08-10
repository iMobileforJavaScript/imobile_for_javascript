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
    
    
}
@end

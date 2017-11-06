//
//  ChartOnSelectedDelagate.h
//  HotMap
//
//  Created by imobile-xzy on 16/12/29.
//  Copyright © 2016年 imobile-xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChartData;
@protocol ChartOnSelectedDelegate <NSObject>
-(void)chartOnselected:(ChartData*)pieChartData selected:(BOOL)bSelected;
@end

//
//  JSBarChart.h
//  Supermap
//
//  Created by 王子豪 on 2017/8/10.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SuperMap/BarChart.h"

@interface JSBarChart : UIView
@property(nonatomic,copy)NSString* title;
@property(nonatomic,assign)float textSize;
@property(nonatomic,assign)BOOL isValueAlongXAxis;
@property(nonatomic,assign)float axisTitleSize;
@property(nonatomic,assign)float axisLableSize;
@property(nonatomic,copy) NSString* xAxisTitle;
@property(nonatomic,copy) NSString* yAxisTitle;
@property(nonatomic,copy)UIColor* hightLightColor;
@property(nonatomic,copy)NSArray* chartDatas;
@end

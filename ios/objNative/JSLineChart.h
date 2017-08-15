//
//  JSLineChart.h
//  Supermap
//
//  Created by 王子豪 on 2017/8/10.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SuperMap/LineChart.h"

@interface JSLineChart : UIView
@property(nonatomic,copy)NSString* title;
@property(nonatomic,assign)float textSize;
@property(nonatomic,assign)float axisTitleSize;
@property(nonatomic,assign)float axisLableSize;
@property(nonatomic,copy) NSString* xAxisTitle;
@property(nonatomic,copy) NSString* yAxisTitle;
@property(nonatomic,assign)BOOL allowsUserInteraction;
@property(nonatomic,copy)UIColor* hightLightColor;
@property(nonatomic,assign)int geoId;
@property(nonatomic,copy)NSArray* chartDatas;
@end

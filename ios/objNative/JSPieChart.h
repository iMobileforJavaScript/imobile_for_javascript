//
//  JSPieChart.h
//  Supermap
//
//  Created by 王子豪 on 2017/8/14.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SuperMap/PieChart.h"

@interface JSPieChart : UIView
@property(nonatomic,copy)NSString* title;
@property(nonatomic,assign)float textSize;
@property(nonatomic,assign)float radious;
@property(nonatomic)CGPoint center;
@property(nonatomic,assign)int geoId;
@property(nonatomic,copy) UIColor* textColor;
@property(nonatomic,copy)NSArray* chartDatas;
@end

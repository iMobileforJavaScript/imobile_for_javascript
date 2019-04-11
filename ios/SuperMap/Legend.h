//
//  Legend.h
//  LibUGC
//
//  Created by imobile-xzy on 15/11/24.
//  Copyright © 2015年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LegendView;
@class LegendItem;
@class ColorLegendItem;
@interface Legend : NSObject

@property(nonatomic,strong,readonly)LegendView* legendView;

//添加用户自定义颜色图例标示，colorType，0点，1线，2面
-(void)addColorLegendItem:(int)colorType ColorItem:(ColorLegendItem*)colorItem;
//移除用户自定义颜色图例标示，colorType，0点，1线，2面
-(void)removeColorLegendItem:(int)colorType ColorItem:(ColorLegendItem*)colorItem;
//添加用户自定义标示
-(void)addUserDefinedLegendItem:(LegendItem*)item;
//移除用户自定义标示
-(void)removeUserDefinedLegendItem:(LegendItem*)item;
-(void)dispose;

/** 设置关联的图例控件*/
-(void) connectLegendView:(LegendView *)legendView;
-(void) disConnectLegendView;
@end

//
//  ChartLegend.h
//  DynamicView
//
//  Created by imobile-xzy on 16/4/13.
//  Copyright © 2016年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
    BOTTOMLEFT,  ///< The bottom left corner
    BOTTOM,      ///< The bottom center
    BOTTOMRIGHT, ///< The bottom right corner
    LEFT,        ///< The left middle
    RIGHT,       ///< The right middle
    TOPLEFT,     ///< The top left corner
    TOP,         ///< The top center
    TOPRIGHT,    ///< The top right
}ChartLegendAlignment;

//图例类
@interface ChartLegend : NSObject

//是否隐藏
@property(nonatomic)BOOL visible;
//竖直或者水平显示,默认是竖直显示
@property(nonatomic)BOOL orient;
//图例位置
@property(nonatomic)ChartLegendAlignment alignment;
//图例背景色，默认白色
@property(nonatomic,strong)UIColor* backGroundColor;
//字体颜色,默认10
@property(nonatomic)float fontSize;
//字体颜色,默认白色
@property(nonatomic,strong)UIColor* fontColor;

//更新图例，更改属性后需要更新
-(void)update;
@end

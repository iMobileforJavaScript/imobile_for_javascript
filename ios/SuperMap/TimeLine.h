//
//  ChartTimeLine.h
//  HotMap
//
//  Created by imobile-xzy on 17/3/10.
//  Copyright © 2017年 imobile-xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChartView;
@interface TimeLine : NSObject


-(id)initWithHostView:(UIView*)hostView;
//滑块大小,默认25
@property(nonatomic)float sliderSize;
//滑块风格
@property(nonatomic,strong)UIImage* sliderImage;
//滑块选中风格
@property(nonatomic,strong)UIImage* sliderSelectedImage;

//时间线颜色
@property(nonatomic,strong)UIColor* timeLineColor;

//滑块标签字体大小,默认8
@property(nonatomic)float sliderTextSize;
//滑块标签颜色
@property(nonatomic,strong)UIColor* sliderTextColor;

//后退风格
@property(nonatomic,strong)UIImage* backwardImage;
//前进风格
@property(nonatomic,strong)UIImage* forwardsImage;

//播放按钮风格
@property(nonatomic,strong)UIImage* playImage;
//暂停按钮风格
@property(nonatomic,strong)UIImage* pausePlayImage;

//添加关联图表
-(void)addChart:(ChartView*)chart;
//移除关联图表
-(void)removeChart:(ChartView*)chart;
//清空所有关联图表
-(void)clearChart;
//加载
-(void)load;
//销毁
-(void)dispose;
@end

//
//  ChartView.h
//  HotMap
//
//  Created by imobile-xzy on 16/11/21.
//  Copyright © 2016年 imobile-xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChartLegend,Point2D;
@class ColorScheme;

//图表层
@interface ChartView : UIView

//图标标题
@property(nonatomic,strong)NSString* title;
@property(nonatomic)float textSize;

//实时数据更新隔时间，默认未开启。当设置值大于等于1秒时 开启,设置0关闭
@property(nonatomic)float updataInterval;

//染时空数据 跳时时间的百分比
@property(nonatomic)float playTimePercent;

//渲染时空数据,时间间隔 单位秒，默认2s
@property(nonatomic)float playInterval;

//图例
@property(nonatomic,strong,readonly)ChartLegend* legend;

//数据接入
-(void)addChartDataset:(NSArray*)chartDatas timeTag:(NSString*)timeTag;
-(void)removeChartDataWith:(NSString*)timeTag;
//接入实时数据，浅拷贝
-(void)addChartDatas:(NSArray*)chartDatas;
-(void)removeAllData;

//渲染时空数据
-(void)startPlay;
-(void)stopPlay;

//销毁
-(void)dispose;
////更新图表
-(void)update;

@end


//调色板
@interface ColorScheme : NSObject
//设置分段颜色,类型Color
@property(nonatomic,strong)NSArray* colors;
//设置颜色分段值,类型NSNumber
@property(nonatomic,strong)NSArray* segmentValue;
//设置每个分段标签，可以不设置,类型NSString
@property(nonatomic,strong)NSArray* segmentLable;
@end


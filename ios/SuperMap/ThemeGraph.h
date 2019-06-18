//
//  ThemeGraph.h
//  HotMap
//
//  Created by zhouyuming on 2019/4/26.
//  Copyright © 2019年 imobile-xzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Theme.h"
#import "ThemeGraphItem.h"
#import "ThemeGraphType.h"
#import "GraduatedMode.h"
#import "TextStyle.h"
#import "Layer.h"

@interface ThemeGraph : Theme

@property(nonatomic)Layer *mLayer;

-(NSArray *)getGraphItemList;

-(int)getCount;

-(ThemeGraphItem*)getItem:(int)index;

-(void)setItemAt:(int)nIndex with:(ThemeGraphItem*) item;

-(int)indexOf:(NSString*) graphExpresson;

// 移除
-(BOOL) remove:(int)index;
// 添加
-(int)addItem:(ThemeGraphItem*) item;
//交换
-(BOOL)exchangeItemAtIndex:(int)index1 with:(int)index2;
//插入
-(BOOL) insert:(int)index item:(ThemeGraphItem*) item;

// 统计图显示最大值
@property(nonatomic,assign) double maxGraphSize;

// 统计图显示最小值
@property(nonatomic,assign) double minGraphSize;

// 是否固定大小
@property(nonatomic,assign) BOOL isGraphSizeFixed;

// 水平偏移表达式。
@property(nonatomic,strong) NSString * strOffsetXExpression;

// 垂直偏表达式。
@property(nonatomic,strong) NSString * strOffsetYExpression;

// 统计图类型
@property(nonatomic,assign) ThemeGraphType graphType;

//double barWidth
//double startAngle
//double roseAngle
//boolean isFlowEnabled
////GeoStyle leaderLineStyle   // 对象之间的牵引线的风格
////boolean isLeaderLineDisplayed    // 是否显示统计图和它表示的对象之间的牵引线
//boolean isNegativeDisplayed    // 是否显示负值
//Color axesColor    // 坐标轴颜色，对应UGC的DefaultColor
//---boolean isAxesDisplayed     //是否显示坐标轴
//---TextStyle axesTextStyle    //坐标轴文字风格
//boolean isAxesTextDisplayed    //坐标轴文字是否显示
//boolean isAxesGridDisplayed
//---TextStyle graphTextStyle    //统计图文字风格
//boolean isGraphTextDisplayed    //是否显示统计图上的文字标注
//boolean isOffsetFixed
//---GraduatedMode graduatedMode
//boolean isOverlapAvoided
//---GraphAxesTextDisplayMode axesTextDisplayMode    //显示坐标轴文本时，显示的文本模式，X轴或Y轴或全部显示
//boolean isAllDirectionsOverlappedAvoided    //标签专题图是否全方位自动避让，默认为false
//fromXML
//toXML

//是否显示坐标轴
@property(nonatomic,assign) BOOL isAxesDisplayed;
//坐标轴文字风格
@property(nonatomic,strong) TextStyle* axesTextStyle;
//统计图文字风格
@property(nonatomic,strong) TextStyle* graphTextStyle;
//设置分级模式
@property(nonatomic,assign) GraduatedMode graduatedMode;
//显示坐标轴文本时，显示的文本模式，X轴或Y轴或全部显示
@property(nonatomic,assign) GraphAxesTextDisplayMode axesTextDisplayMode;

@property(nonatomic,strong) NSArray* memoryKeys;



@end

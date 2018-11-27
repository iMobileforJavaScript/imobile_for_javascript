//
//  SymbolLibLegend.h
//  Sources_812_ugc
//
//  Created by lucd on 2018/10/26.
//  Copyright © 2018年 supermap. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SymbolGroup,Color,Symbol;
//typedef enum {
//    UISymbolGroupSrcollHorizontal,
//    UISymbolGroupSrcollVertical
//} UISymbolGroupSrcollDirection;

@protocol SymbolLibLegendDelegate<NSObject>
@optional
/*
 @param symbol 单元格中symbol符号
 */
-(void)onSymbolClick:(Symbol*)symbol;
@end

@interface SymbolLibLegend : UIView

@property (weak,nonatomic) id<SymbolLibLegendDelegate> delegate;

/*滑动方向，默认滑动方向是垂直方向滑动, scrollDirection可取两个值，0代表横向滚动 1代表垂直滚动*/
@property (nonatomic,assign) BOOL isScrollDirectionVertical;
/*行与行之间的最小行间距*/
@property (nonatomic,assign) CGFloat itemLineSpacing;
/*同一行的cell中互相之间的最小间隔，设置这个值之后，那么cell与cell之间至少为这个值，若达不到则为0*/
@property (nonatomic,assign) CGFloat itemInteritemSpacing;
/*一行多少item，若为0则自适应*/
@property (nonatomic,assign) int itemCountPerLine;
/*内容缩进*/
@property (nonatomic) UIEdgeInsets legendContentInset;
/*image尺寸，若为0则自适应，若大于计算的cellsize则设为0*/
@property (nonatomic,assign) int imageSize;
/*text字体字号,若为0则自适应为0.25*imagesize,若小于5则为5*/
@property (nonatomic,assign) int textSize;
/* 设置cell单元格的背景色*/
@property (nonatomic,strong) Color* textColor;
/* 设置cell单元格的背景色*/
@property (nonatomic,strong) Color* legendBackgroundColor;

/* 根据传入参数调整布局，布局参数更改后需要手动调用（show函数中有隐式调用） */
-(void)reloadLegend;

/* 显示symbolGroup中所有symbol */
-(void)showSymbolGroup:(SymbolGroup*)symbolGroup;
/* 显示symbolArray中所有symbol */
-(void)showSymbols:(NSArray*)symbolArray;

@end


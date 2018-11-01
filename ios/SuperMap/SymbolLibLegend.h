//
//  SymbolLibLegend.h
//  Sources_812_ugc
//
//  Created by lucd on 2018/10/26.
//  Copyright © 2018年 supermap. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SymbolGroup,Color;
//typedef enum {
//    UISymbolGroupSrcollHorizontal,
//    UISymbolGroupSrcollVertical
//} UISymbolGroupSrcollDirection;

@protocol SymbolLibLegendDelegate<NSObject>
@optional
/*
 @param symbolID 单元格中symbol符号的id
 @param symbolName 单元格中symbol符号的名称
 */
-(void)onCellViewClickEvent:(NSInteger)symbolID symbolName:(NSString*)symbolName;
@end

@interface SymbolLibLegend : UIView

-(instancetype)initWithFrame:(CGRect)frame symbolGroup:(SymbolGroup*)symbolGroup;
@property (weak,nonatomic) id<SymbolLibLegendDelegate> delegate;
/*行与行之间的最小行间距*/
@property (nonatomic) CGFloat cellMinimumLineSpacing;
/*同一行的cell中互相之间的最小间隔，设置这个值之后，那么cell与cell之间至少为这个值*/
@property (nonatomic) CGFloat cellMinimumInteritemSpacing;
/*每个cell统一尺寸*/
@property (nonatomic) CGSize cellSize;
/*滑动方向，默认滑动方向是垂直方向滑动, scrollDirection可取两个值，0代表横向滚动 1代表垂直滚动*/
@property (nonatomic) NSInteger scrollDirection;
@property (nonatomic) CGFloat textSize;
/*内容缩进*/
@property (nonatomic) UIEdgeInsets contentInset;
/* 设置cell单元格的背景色*/
@property (nonatomic,strong) Color* cellBackgroundColor;
/* 设置cell单元格的背景色*/
@property (nonatomic,strong) Color* cellLabelTextColor;
@end


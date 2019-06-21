//
//  ThemeGridRange.h
//  Objects_iOS
//
//  Created by wnmng on 2019/5/28.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#import "Theme.h"
#import "RangeMode.h"
#import "ColorGradientType.h"
#import "ThemeGridRangeItem.h"

@class Color,DatasetGrid;

@interface ThemeGridRange : Theme

@property (nonatomic,assign) int specialValue;
@property (nonatomic,assign) BOOL isSpecialValueTransparent;

-(id)initWithThemeGridRange:(ThemeGridRange*)themeGridRange;

-(RangeMode)getRangeMode;

-(int)getCount;

-(NSArray*)getRangeItemList;

-(ThemeGridRangeItem*)getItem:(int)index;

-(BOOL)addToHead:(ThemeGridRangeItem*)itemTemp;

-(BOOL)addToTail:(ThemeGridRangeItem*)itemTemp;

//拆分一个分段值splitValue必须在拆分的范围之内
-(BOOL)split:(int)index value:(double)splitValue color1:(Color*)color1 caption1:(NSString*)caption1
      color2:(Color*)color2 caption2:(NSString*)caption2;

//合并一个分段值
-(BOOL)merge:(int)index count:(int)count color:(Color*)color caption:(NSString*)caption;

//查找某段分段值的序号, 如果不存在,返回-1
-(int)indexOf:(double)value;

-(void)reverseColor;

-(NSString *)toString;

-(void)dispose;

-(BOOL)fromXML:(NSString *)xml;

+(ThemeGridRange*)makeDefault:(DatasetGrid*)dataset rangeMode:(RangeMode)nRangeMode parameter:(double)dRangeParameter gradientType:(ColorGradientType)nGradientType;

@end

//
//  ThemeGraduatedSymbol.h
//  HotMap
//
//  Created by zhouyuming on 2019/5/6.
//  Copyright © 2019年 imobile-xzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Theme.h"
#import "GraduatedMode.h"
@class GeoStyle;
@class DatasetVector;


@interface ThemeGraduatedSymbol : Theme

+(ThemeGraduatedSymbol*)makeDefault:(DatasetVector*)dataset expression:(NSString*)expression graduatedMode:(GraduatedMode)GraduatedMode;

-(void)setGraduatedMode:(GraduatedMode) value;
//返回/设置 是否允许统计图追随其对应的对象流动显示。缺省为False，即不允许对象流动显示
-(BOOL)isFlowEnable;
//返回/设置 是否允许统计图追随其对应的对象流动显示。缺省为False，即不允许对象流动显示
-(void)setFlowEnabled:(BOOL) value;

-(NSString*)getExpression;

-(void)setExpression:(NSString*) value;

-(GeoStyle*)getPositiveStyle;

-(void)setPositiveStyle:(GeoStyle*) style;

//每个符号的显示大小=PositiveStyle（或ZeroStyle,NegativeStyle）.SymbolSize*value/basevalue，但是这里的Value是经过分级计算之后的值，value就是Expression所对应的值
-(double) getBaseValue;

//每个符号的显示大小=PositiveStyle（或ZeroStyle,NegativeStyle）.SymbolSize*value/basevalue，但是这里的Value是经过分级计算之后的值，value就是Expression所对应的值
-(void)setBaseValue:(double) value;

@end

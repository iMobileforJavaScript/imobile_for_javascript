//
//  ThemeGraphItem.h
//  HotMap
//
//  Created by zhouyuming on 2019/4/28.
//  Copyright © 2019年 imobile-xzy. All rights reserved.
//

#import "GeoStyle.h"
#import "ThemeRange.h"
@class ThemeGraph;

@interface ThemeGraphItem : NSObject



//初始化
-(id)initWithThemeGraphItem:(ThemeGraphItem*) themeGraphItem;

//-(id)initWithThemeGraph:(ThemeGraph*) themeGraph;

@property (nonatomic,strong) NSString* caption;
@property (nonatomic,strong) NSString* graphExpression;
@property (nonatomic,strong) GeoStyle* uniformStyle;
@property (nonatomic,strong) ThemeRange* rangeSetting;
@property (nonatomic,strong) NSArray* arrMemoryDoubleValues;

-(void)dispose;

//-(GeoStyle *)mStyle;

//-(void) setCaption:(NSString*) caption;

//统计专题图字段表达式
//-(NSString*) getGraphExpression;

//统计专题图字段表达式
//-(void) setGraphExpression:(NSString*) graphExpression;

//统计专题图分段表达式
//-(GeoStyle*) getUniformStyle;
//
//-(NSMutableArray *) getMemoryDoubleValues;


@end

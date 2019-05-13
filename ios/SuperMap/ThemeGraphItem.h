//
//  ThemeGraphItem.h
//  HotMap
//
//  Created by zhouyuming on 2019/4/28.
//  Copyright © 2019年 imobile-xzy. All rights reserved.
//

#import "GeoStyle.h"
#import "Map/UGGraphItem.h"
@class ThemeGraph;

@interface ThemeGraphItem : NSObject{
    @private
    BOOL _mIsVisible;
    GeoStyle * _mStyle;
    ThemeGraph* m_themeGraph;
    BOOL m_isUserThemeGraph;
}

@property(nonatomic,retain)ThemeGraph * mThemeGraph;

//初始化
-(id)initWithThemeGraphItem:(ThemeGraphItem*) themeGraphItem;

-(id)initWithThemeGraphItem:(UGGraphItem *) themeGraphItem graph:(ThemeGraph*)graph;

-(id)initWithThemeGraph:(ThemeGraph*) themeGraph;

-(BOOL)mIsUserThemeGraph;

-(GeoStyle *)mStyle;

-(void) setCaption:(NSString*) caption;

//统计专题图字段表达式
-(NSString*) getGraphExpression;

//统计专题图字段表达式
-(void) setGraphExpression:(NSString*) graphExpression;

//统计专题图分段表达式
-(GeoStyle*) getUniformStyle;

-(NSMutableArray *) getMemoryDoubleValues;


@end

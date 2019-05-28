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

@interface ThemeGraph : Theme{
    @public
    Layer* _mLayer;
    @private
    NSMutableArray * _mGraphItems;
}
@property(nonatomic)Layer *mLayer;

-(NSMutableArray *)getGraphItemList;

-(int)getCount;

-(ThemeGraphItem*)getItem:(int)index;

-(int)indexOf:(NSString*) graphExpresson;

// 统计图显示最大值
-(double)getMaxGraphSize;

// 统计图显示最大值
-(void) setMaxGraphSize:(double) value;

// 统计图显示最小值
-(void) setMinGraphSize:(double) value;

// 移除
-(BOOL) remove:(int)index;

//插入
-(BOOL) insert:(int)index item:(ThemeGraphItem*) item;

-(NSMutableArray*) getMemoryKeys;

// 是否显示坐标轴
-(TextStyle*) getAxesTextStyle;

//设置统计图类型
-(void) setGraphType:(ThemeGraphType) type;

//设置分级模式
-(void) setGraduatedMode:(GraduatedMode) mode;
@end

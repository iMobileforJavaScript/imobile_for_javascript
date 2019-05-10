//
//  ThemeDotDensity.h
//  HotMap
//
//  Created by zhouyuming on 2019/4/30.
//  Copyright © 2019年 imobile-xzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeoStyle.h"
#import "Theme.h"

@interface ThemeDotDensity : Theme

//返回 点密度专题图中点的风格
-(GeoStyle*) getStyle;

//设置 点密度专题图中点的风格
-(void) setStyle:(GeoStyle*) geoStyle;

//返回专题图中每一个点所代表的数值。
-(double) getValue;
//设置专题图中每一个点所代表的数值。
-(void)setValue:(double) value;

//设置用于创建点密度专题图的字段或字段表达式。
-(void) setDotExpression:(NSString*)value;

@end

//
//  ThemeGridRangeItem.h
//  Objects_iOS
//
//  Created by wnmng on 2019/5/28.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ThemeGridRange,Color;

@interface ThemeGridRangeItem : NSObject

@property(nonatomic,assign) double start;
@property(nonatomic,assign) double end;
@property(nonatomic,strong) NSString *caption;
@property(nonatomic,strong) Color *color;
@property(nonatomic,assign) BOOL isVisable;


-(id)initWithStart:(double)start end:(double)end color:(Color*)color caption:(NSString*)caption;
-(id)initWithThemeGridRangeItem:(ThemeGridRangeItem*)item;
-(id)initWithThemeGridRange:(ThemeGridRange*)themeGridRange;

-(NSString *)toString;


@end

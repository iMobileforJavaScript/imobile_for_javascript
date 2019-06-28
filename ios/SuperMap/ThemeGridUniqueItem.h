//
//  ThemeGridUniqueItem.h
//  HotMap
//
//  Created by zhouyuming on 2019/5/7.
//  Copyright © 2019年 imobile-xzy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ThemeGridUnique;
@class Color;

@interface ThemeGridUniqueItem : NSObject
//@property(nonatomic,retain)ThemeGridUnique* themeGridUnique;
@property(nonatomic)Color* color;
@property(nonatomic,assign) double unique;
@property(nonatomic,strong) NSString* caption;
@property(nonatomic,assign) BOOL visable;


-(id)initWithThemeGridUnique:(ThemeGridUnique*)themeGridUnique;

-(id)initWithThemeGridUniqueItem:(ThemeGridUniqueItem*) themeGridUniqueItem;

-(id)initWithUnique:(double)unique color:(Color*)color caption:(NSString*)caption;

@end

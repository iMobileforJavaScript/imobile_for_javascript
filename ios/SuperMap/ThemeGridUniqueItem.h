//
//  ThemeGridUniqueItem.h
//  HotMap
//
//  Created by zhouyuming on 2019/5/7.
//  Copyright © 2019年 imobile-xzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThemeGridUnique.h"
@class Color;

@interface ThemeGridUniqueItem : NSObject{
    ThemeGridUnique* _themeGridUnique;
    Color* _color;
    @private
    BOOL _isUserThemeGridUnique;
}
@property(nonatomic,retain)ThemeGridUnique* themeGridUnique;
@property(nonatomic)Color* color;

-(id)initWithThemeGridUnique:(ThemeGridUnique*)themeGridUnique;

-(id)initWithThemeGridUniqueItem:(ThemeGridUniqueItem*) themeGridUniqueItem;

-(void)setColor:(Color*)color;

-(Color*)getColor;

@end

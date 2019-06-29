//
//  ThemeLabelUniqueItem.h
//  LibUGC
//
//  Created by wnmng on 2019/6/21.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TextStyle,ThemeLabel;

@interface ThemeLabelUniqueItem : NSObject

@property(nonatomic,strong) NSString* unique;
@property(nonatomic,assign) BOOL isVisable;
@property(nonatomic,assign) double offsetX;
@property(nonatomic,assign) double offsetY;
@property(nonatomic,strong) NSString* caption;
@property(nonatomic,strong) TextStyle* textStyle;

-(id)initWithUniqueItem:(ThemeLabelUniqueItem*)item;
-(id)initWithThemeLabel:(ThemeLabel*)themeLabel;

@end

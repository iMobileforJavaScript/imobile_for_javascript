//
//  ThemeGridUnique.h
//  HotMap
//
//  Created by zhouyuming on 2019/5/7.
//  Copyright © 2019年 imobile-xzy. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Theme.h"
@class Color;
@class ThemeGridUniqueItem;
/**
 *栅格专题图类
 */
 
@interface ThemeGridUnique : Theme{
    NSMutableArray * _mGradUniqueItems;
    
}

-(NSMutableArray *)getGradUniqueItemList;

-(void)setSpecialValue:(int) nSpecialValue;

-(void)setDefaultColor:(Color*) color;

-(void)setSpecialValueTransparent:(BOOL) bSpecialValueTransparent;

-(int)getCount;

-(ThemeGridUniqueItem*)getItem:(int)index;

@end

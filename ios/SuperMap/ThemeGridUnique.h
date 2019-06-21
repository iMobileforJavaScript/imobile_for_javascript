//
//  ThemeGridUnique.h
//  HotMap
//
//  Created by zhouyuming on 2019/5/7.
//  Copyright © 2019年 imobile-xzy. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Theme.h"
#import "ThemeGridUniqueItem.h"
#import "ColorGradientType.h"
@class Color,DatasetGrid;

/**
 *栅格专题图类
 */
 
@interface ThemeGridUnique : Theme

@property (nonatomic,strong) Color* defaultColor;
@property (nonatomic,assign) BOOL isSpecialValueTransparent;
@property (nonatomic,assign) int specialValue;

-(NSMutableArray *)getGradUniqueItemList;

-(int)getCount;

-(ThemeGridUniqueItem*)getItem:(int)index;

-(int)add:(ThemeGridUniqueItem*)item;

-(BOOL)insert:(ThemeGridUniqueItem*)item at:(int)index;

-(BOOL)removeAt:(int)index;

-(void)clear;

-(int)indexOfValue:(double)unique;

-(void)reverseColor;

-(NSString*)toString;

-(BOOL)fromXML:(NSString*)strXML;

+(ThemeGridUnique*)makeDefault:(DatasetGrid*)dataset;

+(ThemeGridUnique*)makeDefault:(DatasetGrid*)dataset colorGradientType:(ColorGradientType)colorGradientType;



@end

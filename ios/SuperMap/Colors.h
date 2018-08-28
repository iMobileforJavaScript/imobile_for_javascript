//
//  Colors.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "ColorGradientType.h"
@class Color;
/**  颜色集合类。
*
* <p> 该类主要作用是提供颜色序列。提供各种渐变色和随机色的生成，以及 SuperMap 预定义渐变色的生成。
* <p> 颜色集合类可用于各个专题图对象及各个空间对象中颜色属性的设置。
*/
@interface Colors : NSObject{

    BOOL _isForDataset;
    
}
/** 根据指定的参数来构造一个 Colors 的新对象。
* 
* @param colorsArray 指定的颜色列表。
*/
-(id)initColorsArray:(NSMutableArray *)colorsArray;

/** 根据给定的 Colors 对象构造一个与其完全相同的新对象。
* 
* @param colors 给定的 Colors 对象。
*/
-(id)initColors:(Colors*)colors;

/**
* 将颜色集合数组添加到当前颜色集合对象中。
* @param colors 要添加到此颜色集合对象实例的颜色几何数组。
* @return 添加的个数。
*/
-(int)addRange:(NSMutableArray *)colors;

/**
* 将当前颜色集合对象转换为一个颜色对象数组。
* @return 当前颜色集合对象转换成的一个颜色对象数组。
*/
-(NSMutableArray *)toArray;

/**
* 返回颜色集合中颜色的个数。 默认值为0。
*
* @return 颜色集合中颜色的个数。
*/
-(int)getCount;

/**
* 返回颜色集合中指定序号的颜色值。
* @param index 指定的颜色值的序号（从0开始）。
* @return 颜色集合中指定序号的颜色值。
*/
-(Color *)get:(int)index;

/**
* 用于生成一定数量的随机颜色。
* @param count 要生成的随机颜色的数量。
* @return 一个随机颜色类型。
*/
+(Colors *)makeRandom:(int)count;

-(int) add:(Color *)color;
-(void) clear;
-(void) dispose;
-(BOOL) insertAtIndex:(int)index color:(Color *)color;
+(Colors *)makeGradient:(int)count gradientColorArray:(NSMutableArray *)gradientColorArray;
+(Colors *)makeGradient2:(int)count colorGradientType:(ColorGradientType)colorGradientType reverse:(BOOL)reverse;
-(BOOL) removeAtIndex:(int)index;
-(void) setAtIndex:(int)index color:(Color *)color;
-(Colors *) makeRandom2:(int)count colorArray:(NSMutableArray *)colorArray;

@end

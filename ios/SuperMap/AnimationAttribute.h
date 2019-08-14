//
//  AnimationAttribute.h
//  Objects_iOS
//
//  Created by imobile-xzy on 2019/7/11.
//  Copyright © 2019 beijingchaotu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationGO.h"
#import "Color.h"

@interface AnimationAttribute : AnimationGO

/**
 * 线色属性是否有效。
 */
@property(nonatomic)BOOL lineColorAttr;

/**
 * 开始线色。
 */
@property(nonatomic,strong)Color* startLineColor;

/**
 * 结束线色。
 */
@property(nonatomic,strong)Color* endLineColor;

/**
 * 线宽属性是否有效
 */
@property(nonatomic)BOOL lineWidthAttr;

/**
 * 开始线宽。
 */
@property(nonatomic)double startLineWidth;
/**
 * 结束线宽。
 */
@property(nonatomic)double endLineWidth;

/**
 * 衬线宽属性是否有效。
 */
@property(nonatomic)BOOL surroundLineWidthAttr;

/**
 * 开始衬线宽。
 */
@property(nonatomic)double startSurroundLineWidth;
/**
 * 结束衬线宽。
 */
@property(nonatomic)double endSurroundLineWidth;

/**
 * 衬线颜色属性是否有效。
 */
@property(nonatomic)BOOL surroundLineColorAttr;

/**
 * 开始衬线颜色。
 */
@property(nonatomic,strong)Color* startSurroundLineColor;

/**
 * 结束衬线颜色。
 */
@property(nonatomic,strong)Color* endSurroundLineColor;

@end

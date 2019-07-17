//
//  AnimationBlink.h
//  Objects_iOS
//
//  Created by imobile-xzy on 2019/7/11.
//  Copyright © 2019 beijingchaotu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationGO.h"

@class Color;
@interface AnimationBlink : AnimationGO
/**
 * 闪烁间隔
 * @param blinkinterval 闪烁间隔
 */
@property(nonatomic)double blinkinterval;

/**
 * 指定时间内的闪烁次数
 * @return
 */
@property(nonatomic)int blinkNumberofTimes;

/**
 *闪烁类型，是按照次数闪烁还是按照间隔闪烁
 * @param type 闪烁类型 0);//频率闪烁 1);//次数闪烁
 */
@property(nonatomic)int blinkStyle;

/**
 *颜色替换还是有无
 * @return 颜色替换还是有无 0);//无颜色交替 1);//有颜色交替
 */
@property(nonatomic)int blinkAnimationReplaceStyle;

/**
 *交替的颜色
 * @param replacecolor 交替的颜色
 */
@property(nonatomic,strong)Color* blinkAnimationReplaceColor;

/**
 *交替的起始颜色
 * @param replacecolor 交替的颜色
 */
@property(nonatomic,strong)Color* blinkAnimationStartColor;
@end

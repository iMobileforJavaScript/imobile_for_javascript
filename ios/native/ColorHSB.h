//
//  ColorHSB.h
//  Supermap
//
//  Created by wnmng on 2020/1/17.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Color;

@interface ColorHSB:NSObject
-(id)initWithH:(float)h s:(float)s b:(float)b;
-(id)initWithColor:(Color*)rgb;
-(Color*)toColor;
@property (nonatomic,assign) float hue;
@property (nonatomic,assign) float saturation;
@property (nonatomic,assign) float brightness;
@end

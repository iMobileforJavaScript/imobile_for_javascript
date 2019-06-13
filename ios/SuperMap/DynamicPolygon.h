//
//  DynamicPolygon.h
//  LibUGC
//
//  Created by iMobile2D on 14-8-11.
//  Copyright (c) 2014年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DynamicElement.h"

@interface DynamicPolygon : DynamicElement

//设置面对象边框颜色，默认没有
@property(nonatomic,strong)UIColor* borderColor;
@property(nonatomic)NSUInteger borderWidth;


-(ElementType)getType;

@end

//
//  DynamicPoint.h
//  LibUGC
//
//  Created by iMobile2D on 14-8-11.
//  Copyright (c) 2014年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DynamicElement.h"
#import "DynamicAlignment.h"

@interface DynamicPoint : DynamicElement

-(ElementType)getType;
//对其方式
@property(nonatomic,assign)DynamicAlignment alignment;
@property(nonatomic,assign)DynamicAlignment textLableAlignment;
@end

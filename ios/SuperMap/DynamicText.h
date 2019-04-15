//
//  DynamicText.h
//  LibUGC
//
//  Created by iMobile2D on 14-8-11.
//  Copyright (c) 2014年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DynamicElement.h"
#import "DynamicAlignment.h"

@interface DynamicText : DynamicElement

@property (nonatomic, strong) NSString* text;

//对其方式
@property(nonatomic,assign)DynamicAlignment alignment;
-(ElementType)getType;
// 是否有效的元素
-(BOOL)isValidElement;

-(id)initWithText:(NSString*)text;
@end

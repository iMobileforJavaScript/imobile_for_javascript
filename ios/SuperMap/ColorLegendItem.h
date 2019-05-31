//
//  ColorLegendItem.h
//  LibUGC
//
//  Created by imobile-xzy on 15/11/24.
//  Copyright © 2015年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Color;
@interface ColorLegendItem : NSObject

@property(nonatomic,strong)NSString* caption;
@property(nonatomic,strong)Color* color;
@end

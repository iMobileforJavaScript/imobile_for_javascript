//
//  JSColorGradientType.m
//  Supermap
//
//  Created by supermap on 2018/8/9.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSColorGradientType.h"

@implementation JSColorGradientType
RCT_EXPORT_MODULE();
-(NSDictionary*)constantsToExport{
    return @{@"BLACKWHITE":@(0),
             @"REDWHITE":@(1),
             @"GREENWHITE":@(2),
             @"BLUEWHITE":@(3),
             @"YELLOWWHITE":@(4),
             @"PINKWHITE":@(5),
             @"CYANWHITE":@(6),
             @"REDBLACK":@(7),
             @"GREENBLACK":@(8),
             @"BLUEBLACK":@(9),
             @"YELLOWBLACK":@(10),
             @"PINKBLACK":@(11),
             @"CYANBLACK":@(12),
             @"YELLOWRED":@(13),
             @"YELLOWGREEN":@(14),
             @"YELLOWBLUE":@(15),
             @"GREENBLUE":@(16),
             @"GREENRED":@(17),
             @"BLUERED":@(18),
             @"PINKRED":@(19),
             @"PINKBLUE":@(20),
             @"CYANBLUE":@(21),
             @"CYANGREEN":@(22),
             @"RAINBOW":@(23),
             @"GREENORANGEVIOLET":@(24),
             @"TERRAIN":@(25),
             @"SPECTRUM":@(26)
             };
}
@end

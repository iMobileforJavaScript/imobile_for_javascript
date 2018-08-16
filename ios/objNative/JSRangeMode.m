//
//  JSRangeMode.m
//  Supermap
//
//  Created by imobile-xzy on 2018/8/15.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSRangeMode.h"
#import "SuperMap/RangeMode.h"

@implementation JSRangeMode
RCT_EXPORT_MODULE();
-(NSDictionary*)constantsToExport{
    return @{@"NONE":@(6),
             @"EQUALINTERVAL":@(0),
             @"SQUAREROOT":@(1),
             @"STDDEVIATION":@(2),
             @"LOGARITHM":@(3),
             @"QUANTILE":@(4),
             @"CUSTOMINTERVAL":@(5)
             };
}
@end

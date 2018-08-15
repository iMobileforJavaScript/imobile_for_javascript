//
//  JSTextAlignment.m
//  Supermap
//
//  Created by wnmng on 2018/8/7.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSTextAlignment.h"
#import "SuperMap/TextAlignment.h"

@implementation JSTextAlignment
RCT_EXPORT_MODULE();
-(NSDictionary*)constantsToExport{
    return @{@"TOPLEFT":@(TA_TOPLEFT),
             @"TOPCENTER":@(TA_TOPCENTER),
             @"TOPRIGHT":@(TA_TOPRIGHT),
             @"BASELINELEFT":@(TA_BASELINELEFT),
             @"BASELINECENTER":@(TA_BASELINECENTER),
             @"BASELINERIGHT":@(TA_BASELINERIGHT),
             @"BOTTOMLEFT":@(TA_BOTTOMLEFT),
             @"BOTTOMCENTER":@(TA_BOTTOMCENTER),
             @"BOTTOMRIGHT":@(TA_BOTTOMRIGHT),
             @"MIDDLELEFT":@(TA_MIDDLELEFT),
             @"MIDDLECENTER":@(TA_MIDDLECENTER),
             @"MIDDLERIGHT":@(TA_MIDDLERIGHT)};
}
@end

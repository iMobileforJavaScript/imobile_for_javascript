//
//  SMStatisticMode.m
//  Supermap
//
//  Created by Shanglong Yang on 2019/11/26.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "SMStatisticMode.h"
#import "SuperMap/StatisticMode.h"

@implementation SMStatisticMode
RCT_EXPORT_MODULE(StatisticMode);
-(NSDictionary*)constantsToExport{
    return @{@"MAX":@(MAX),
             @"MIN":@(MIN),
             @"AVERAGE":@(AVERAGE),
             @"SUM":@(SUM),
             @"STDDEVIATION":@(STDDEVIATION),
             @"VARIANCE":@(VARIANCE),
             };
}

@end

//
//  JSRadiusUnit.m
//  Supermap
//
//  Created by 王子豪 on 2017/8/16.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSRadiusUnit.h"
#import "SuperMap/BufferRadiusUnit.h"
@implementation JSRadiusUnit
        RCT_EXPORT_MODULE();
-(NSDictionary*)constantsToExport{
    return @{@"MiliMeter":@(MiliMeter),
             @"CentiMeter":@(CentiMeter),
             @"DeciMeter":@(DeciMeter),
             @"Meter":@(Meter),
             @"KiloMeter":@(KiloMeter),
             @"Yard":@(Yard),
             @"Inch":@(Inch),
             @"Foot":@(Foot),
             @"Mile":@(Mile)};
}
@end

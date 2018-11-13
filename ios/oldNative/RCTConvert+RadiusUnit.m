//
//  RCTConvert+RadiusUnit.m
//  Supermap
//
//  Created by 王子豪 on 2017/8/16.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "RCTConvert+RadiusUnit.h"
@implementation RCTConvert (RadiusUnit)
    RCT_ENUM_CONVERTER(BufferRadiusUnit, (@{@"MiliMeter":@(MiliMeter),
                                            @"CentiMeter":@(CentiMeter),
                                            @"DeciMeter":@(DeciMeter),
                                            @"Meter":@(Meter),
                                            @"KiloMeter":@(KiloMeter),
                                            @"Yard":@(Yard),
                                            @"Inch":@(Inch),
                                            @"Foot":@(Foot),
                                            @"Mile":@(Mile)}), Meter, intValue);
@end

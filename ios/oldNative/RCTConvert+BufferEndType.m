//
//  RCTConvert+BufferEndType.m
//  Supermap
//
//  Created by 王子豪 on 2017/8/16.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "RCTConvert+BufferEndType.h"

@implementation RCTConvert (BufferEndType)
    RCT_ENUM_CONVERTER(BufferEndType, (@{@"ROUND":@(ROUND),
                                  @"FLAT":@(FLAT)}), ROUND, intValue);
@end

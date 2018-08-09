//
//  RCTConvert+EncodeType.m
//  Supermap
//
//  Created by 王子豪 on 2017/8/16.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "RCTConvert+EncodeType.h"

@implementation RCTConvert (EncodeType)
    RCT_ENUM_CONVERTER(EncodeType, (@{@"NONE":@(NONE),
                                            @"BYTE":@(BYTE),
                                            @"INT16":@(INT16),
                                            @"INT24":@(INT24),
                                            @"INT32":@(INT32),
                                            @"DCT":@(DCT),
                                            @"SGL":@(SGL),
                                            @"LZW":@(LZW)}), NONE, intValue);
@end

//
//  JSEncodeType.m
//  Supermap
//
//  Created by 王子豪 on 2017/8/16.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSEncodeType.h"
#import "SuperMap/EncodeType.h"
@implementation JSEncodeType
    RCT_EXPORT_MODULE();
-(NSDictionary*)constantsToExport{
    return @{@"NONE":@(NONE),
             @"BYTE":@(BYTE),
             @"INT16":@(INT16),
             @"INT24":@(INT24),
             @"INT32":@(INT32),
             @"DCT":@(DCT),
             @"SGL":@(SGL),
             @"LZW":@(LZW)};
}
@end

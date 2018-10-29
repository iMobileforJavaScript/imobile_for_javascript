//
//  JSSymbolType.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/15.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSSymbolType.h"

@implementation JSSymbolType
RCT_EXPORT_MODULE();

-(NSDictionary*)constantsToExport{
    return @{
             @"MARKER":@(0), // 点符号
             @"Line":@(1),   // 线填充符号
             @"Fill":@(2),   // 面填充符号
             };
}
@end

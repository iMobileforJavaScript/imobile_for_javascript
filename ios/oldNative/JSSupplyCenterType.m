//
//  JSSupplyCenterType.m
//  Supermap
//
//  Created by wnmng on 2018/8/8.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSSupplyCenterType.h"

@implementation JSSupplyCenterType
RCT_EXPORT_MODULE();

-(NSDictionary*)constantsToExport{
    return @{@"NULL":@(0),
             @"OPTIONALCENTER":@(1),
             @"FIXEDCENTER":@(2)
             };
}

@end

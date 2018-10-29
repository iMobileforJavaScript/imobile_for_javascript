//
//  JSGPSElementType.m
//  Supermap
//
//  Created by imobile-xzy on 2018/8/23.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSGPSElementType.h"

@implementation JSGPSElementType
RCT_EXPORT_MODULE();
-(NSDictionary*)constantsToExport{
    return @{@"LINE":@"LINE",
             @"POINT":@"POINT",
             @"POLYGON":@"POLYGON"};

}
@end

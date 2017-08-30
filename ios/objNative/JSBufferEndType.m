//
//  JSBufferEndType.m
//  Supermap
//
//  Created by 王子豪 on 2017/8/16.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSBufferEndType.h"
#import "SuperMap/BufferEndType.h"
@implementation JSBufferEndType
    RCT_EXPORT_MODULE();
-(NSDictionary*)constantsToExport{
    return @{@"ROUND":@(ROUND),
             @"FLAT":@(FLAT)};
}
@end

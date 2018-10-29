//
//  JSFieldType.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/9/19.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSFieldType.h"
#import "SuperMap/FieldType.h"

@implementation JSFieldType
RCT_EXPORT_MODULE();

-(NSDictionary*)constantsToExport{
    return @{
             @"BOOLEAN":@(FT_BOOLEAN),
             @"BYTE":@(FT_BOOLEAN),
             @"INT16":@(FT_INT16),
             @"INT32":@(FT_INT32),
             @"INT64":@(FT_INT64),
             @"SINGLE":@(FT_SINGLE),
             @"DOUBLE":@(FT_DOUBLE),
             @"DATE":@(FT_DATE),
             @"DATETIME":@(FT_DATETIME),
             @"LONGBINARY":@(FT_LONGBINARY),
             @"TEXT":@(FT_TEXT),
             @"CHAR":@(FT_CHAR),
             @"WTEXT":@(FT_WTEXT),
             };
}
@end

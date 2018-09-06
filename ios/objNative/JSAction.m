//
//  JSAction.m
//  Supermap
//
//  Created by 王子豪 on 2017/8/15.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSAction.h"
#import "SuperMap/Action.h"
@implementation JSAction
RCT_EXPORT_MODULE();
-(NSDictionary*)constantsToExport{
    return @{@"NONEACTION":@(NONEACTION),
             @"PAN":@(PAN),
             @"SELECT":@(SELECT),
             @"VERTEXEDIT":@(VERTEXEDIT),
             @"VERTEXADD":@(VERTEXADD),
             @"VERTEXDELETE":@(DELETENODE),
             @"CREATEPOINT":@(CREATEPOINT),
             @"CREATEPOLYLINE":@(CREATEPOLYLINE),
             @"CREATEPOLYGON":@(CREATEPOLYGON),
             @"MEASURELENGTH":@(MEASURELENGTH),
             @"MEASUREAREA":@(MEASUREAREA),
             @"MEASUREANGLE":@(MEASUREANGLE),
             @"FREEDRAW":@(CREATE_FREE_DRAW),
             @"SPLIT_BY_LINE":@(SPLIT_BY_LINE),
             @"UNION_REGION":@(UNION_REGION),
             @"DRAWREGION_HOLLOW_REGION":@(DRAWREGION_HOLLOW_REGION),
             @"FILL_HOLLOW_REGION":@(FILL_HOLLOW_REGION),
             @"PATCH_HOLLOW_REGION":@(PATCH_HOLLOW_REGION),
             @"SPLIT_BY_LINE":@(SPLIT_BY_LINE),
             @"CREATEPLOT":@(CREATE_PLOT)};
}
@end

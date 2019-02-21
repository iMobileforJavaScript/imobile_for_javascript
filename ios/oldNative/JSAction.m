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
             @"DRAWPLOYGON":@(CREATE_FREE_DRAWPOLYGON),
             @"DRAWLINE":@(CREATE_FREE_POLYLINE),
             @"SPLIT_BY_LINE":@(SPLIT_BY_LINE),
             @"UNION_REGION":@(UNION_REGION),
             @"DRAW_HOLLOW_REGION":@(DRAW_HOLLOW_REGION),
             @"DRAWREGION_HOLLOW_REGION":@(DRAWREGION_HOLLOW_REGION),
             @"FILL_HOLLOW_REGION":@(FILL_HOLLOW_REGION),
             @"PATCH_HOLLOW_REGION":@(PATCH_HOLLOW_REGION),
             @"SPLIT_BY_LINE":@(SPLIT_BY_LINE),
             @"ERASE_REGION":@(ERASE_REGION),
             @"DRAWREGION_ERASE_REGION":@(DRAWREGION_ERASE_REGION),
             @"CREATEPLOT":@(CREATE_PLOT),
             @"MOVE_GEOMETRY":@(MOVE_GEOMETRY),
             @"SELECT_BY_RECTANGLE":@(SELECT_BY_RECTANGLE),
             };
}
@end

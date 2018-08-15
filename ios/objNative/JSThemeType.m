//
//  JSThemeType.m
//  Supermap
//
//  Created by imobile-xzy on 2018/8/8.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSThemeType.h"
#import "SuperMap/ThemeType.h"

@implementation JSThemeType
RCT_EXPORT_MODULE();
-(NSDictionary*)constantsToExport{
    return @{@"UNIQUE":@(TT_Unique),
             @"RANGE":@(TT_Range),
             @"GRAPH":@(TT_Graph),
             @"GRADUATEDSYMBOL":@(TT_GraduatedSymbol),
             @"DOTDENSITY":@(TT_DotDensity),
             @"LABEL":@(TT_label),
             @"CUSTOM":@(TT_Custom),
             @"GRIDUNIQUE":@(TT_GridUnique),
             @"GRIDRANGE":@(TT_GridRange),
           };
}

@end

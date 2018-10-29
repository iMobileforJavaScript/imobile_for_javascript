//
//  JSWorkspaceType.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/9/6.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSWorkspaceType.h"
#import "SuperMap/WorkspaceType.h"

@implementation JSWorkspaceType
RCT_EXPORT_MODULE();
-(NSDictionary*)constantsToExport{
    return @{
             @"DEFAULT":@(SM_DEFAULT),
             @"SXW":@(SM_SXW),
             @"SMW":@(SM_SMW),
             @"SXWU":@(SM_SXWU),
             @"SMWU":@(SM_SMWU),
             };
}
@end

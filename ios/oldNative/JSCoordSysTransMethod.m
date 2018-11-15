//
//  JSCoordSysTransMethod.m
//  Supermap
//
//  Created by wnmng on 2018/8/9.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSCoordSysTransMethod.h"
#import "SuperMap/CoordSysTransMethod.h"
#import "JSObjManager.h"

@implementation JSCoordSysTransMethod
RCT_EXPORT_MODULE();

-(NSDictionary*)constantsToExport{
    return @{@"MTH_GEOCENTRIC_TRANSLATION":@(MTH_GEOCENTRIC_TRANSLATION),
             @"MTH_MOLODENSKY":@(MTH_MOLODENSKY),
             @"MTH_MOLODENSKY_ABRIDGED":@(MTH_MOLODENSKY_ABRIDGED),
             @"MTH_POSITION_VECTOR":@(MTH_POSITION_VECTOR),
             @"MTH_COORDINATE_FRAME":@(MTH_COORDINATE_FRAME),
             @"MTH_BURSA_WOLF":@(MTH_BURSA_WOLF)
             };
}

@end

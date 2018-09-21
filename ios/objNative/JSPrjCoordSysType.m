//
//  JSPrjCoordSysType.m
//  Supermap
//
//  Created by wnmng on 2018/8/9.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSPrjCoordSysType.h"
#import "SuperMap/PrjCoordSysType.h"
#import "JSObjManager.h"

@implementation JSPrjCoordSysType
RCT_EXPORT_MODULE();

-(NSDictionary*)constantsToExport{
    return @{@"PCS_USER_DEFINED":@(PCST_USER_DEFINED),
             @"PCS_NON_EARTH":@(PCST_NON_EARTH),
             @"PCS_EARTH_LONGITUDE_LATITUDE":@(PCST_EARTH_LONGITUDE_LATITUDE),
             @"PCS_SPHERE_MERCATOR":@(PCST_SPHERE_MERCATOR),
             };
}



@end

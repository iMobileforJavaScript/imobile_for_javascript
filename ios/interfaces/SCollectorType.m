//
//  SCollectorType.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/31.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "SCollectorType.h"

@implementation SCollectorType
RCT_EXPORT_MODULE();

-(NSDictionary*)constantsToExport{
    return @{@"POINT_GPS": @(0),              // 打点
             @"POINT_HAND": @(1),             // 点手绘
             
             @"LINE_GPS_POINT": @(2),         // 线GPS打点
             @"LINE_GPS_PATH": @(3),          // 线GPS轨迹
             @"LINE_HAND_POINT": @(4),        // 线打点
             @"LINE_HAND_PATH": @(5),         // 线手绘
             
             @"REGION_GPS_POINT": @(6),       // 面GPS打点
             @"REGION_GPS_PATH": @(7),        // 面GPS轨迹
             @"REGION_HAND_POINT": @(8),      // 面打点
             @"REGION_HAND_PATH": @(9),       // 面手绘
             };
}
@end

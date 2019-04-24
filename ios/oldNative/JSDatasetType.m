//
//  JSDatasetType.m
//  Supermap
//
//  Created by 王子豪 on 2017/8/16.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSDatasetType.h"
#import "SuperMap/DatasetType.h"
@implementation JSDatasetType
    RCT_EXPORT_MODULE();
-(NSDictionary*)constantsToExport{
    return @{@"TABULAR":@(TABULAR),
             @"POINT":@(POINT),
             @"LINE":@(LINE),
             @"Network":@(Network),
             @"REGION":@(REGION),
             @"TEXT":@(TEXT),
             @"IMAGE":@(IMAGE),
             @"GRID":@(Grid),
             @"DEM":@(DEM),
             @"WMS":@(WMS),
             @"WCS":@(WCS),
             @"MBImage":@(MBImage),
             @"PointZ":@(PointZ),
             @"LineZ":@(LineZ),
             @"RegionZ":@(RegionZ),
             @"VECTORMODEL":@(VECTORMODEL),
             @"TIN":@(TIN),
             @"CAD":@(CAD),
             @"WFS":@(WFS),
             @"NETWORK3D":@(NETWORK3D)};
}
@end

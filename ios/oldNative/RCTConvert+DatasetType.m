//
//  RCTConvert+DatasetType.m
//  Supermap
//
//  Created by 王子豪 on 2017/8/16.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "RCTConvert+DatasetType.h"

@implementation RCTConvert (DatasetType)
    RCT_ENUM_CONVERTER(DatasetType, (@{@"TABULAR":@(TABULAR),
                                      @"POINT":@(POINT),
                                      @"LINE":@(LINE),
                                      @"Network":@(Network),
                                      @"REGION":@(REGION),
                                      @"TEXT":@(TEXT),
                                      @"IMAGE":@(IMAGE),
                                      @"Grid":@(Grid),
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
                                      @"NETWORK3D":@(NETWORK3D)}), TABULAR, intValue);
@end

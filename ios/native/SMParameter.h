//
//  SMParameter.h
//  Supermap
//
//  Created by Shanglong Yang on 2019/6/20.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperMap/FacilityAnalystSetting.h"
#import "SuperMap/WeightFieldInfo.h"
#import "SuperMap/TransportationAnalystParameter.h"
#import "SuperMap/WeightFieldInfos.h"
#import "SuperMap/Layer.h"
#import "SMLayer.h"

@interface SMParameter : NSObject
+ (FacilityAnalystSetting *)setFacilitySetting:(NSDictionary *)data;
+ (WeightFieldInfo *)setWeightFieldInfo:(NSDictionary *)data;
@end

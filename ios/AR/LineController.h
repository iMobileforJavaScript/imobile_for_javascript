//
//  LineController.h
//  ARRanging
//
//  Created by zhang_jian on 2018/4/19.
//  Copyright © 2018年 zhangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCNVector3Tool.h"

typedef NS_ENUM(NSUInteger, Enum_LengthUnit) {
    Enum_LengthUnit_meter,          //米
    Enum_LengthUnit_cenitMeter,     //厘米
    Enum_LengthUnit_kilometer,      //千米
};

@interface LineController : NSObject

- (instancetype)initWithSceneView:(ARSCNView *)sceneView StartVector:(SCNVector3)startVector LengthUnit:(Enum_LengthUnit)unit;

- (double)updateLineContentWithVector:(SCNVector3)vector;

- (double)getDistanceWithVector:(SCNVector3)vector;

- (void)removeLine;
@end

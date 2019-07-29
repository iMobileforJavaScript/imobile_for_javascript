//
//  ComputeDistanceResult.h
//  LibUGC
//
//  Created by wnmng on 2019/7/10.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComputeDistanceResult : NSObject

@property (nonatomic,assign) int sourceGeometryID;

@property (nonatomic,assign) double distance;

@property (nonatomic,strong) NSArray* referenceGeometryIDs;


@end

//
//  InterpolationIDWParameter.h
//  LibUGC
//
//  Created by wnmng on 2019/7/15.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#import "InterpolationParameter.h"

@class DatasetVector;

@interface InterpolationIDWParameter : InterpolationParameter

@property(nonatomic,assign) int power;
@property(nonatomic,strong) DatasetVector *breakDataset;

-(id)initWithResolution:(double)resolution searchMode:(SearchMode)mode searchRadius:(double)searchRadius expectedCount:(int)expectedCount;
-(id)initWithResolution:(double)resolution searchMode:(SearchMode)mode searchRadius:(double)searchRadius expectedCount:(int)expectedCount power:(int)power;

@end

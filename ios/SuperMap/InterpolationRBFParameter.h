//
//  InterpolationRBFParameter.h
//  LibUGC
//
//  Created by wnmng on 2019/7/15.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#import "InterpolationParameter.h"

@interface InterpolationRBFParameter : InterpolationParameter

@property(nonatomic,assign) double tension;
@property(nonatomic,assign) double smooth;

-(id)initWithResolution:(double)resolution tension:(double)tension  smooth:(double)smooth;


-(id)initWithResolution:(double)resolution searchMode:(SearchMode)mode searchRadius:(double)searchRadius expectedCount:(int)expectedCount tension:(double)tension  smooth:(double)smooth;

@end

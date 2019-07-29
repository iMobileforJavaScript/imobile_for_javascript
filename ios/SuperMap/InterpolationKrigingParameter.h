//
//  InterpolationKrigingParameter.h
//  LibUGC
//
//  Created by wnmng on 2019/7/16.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#import "InterpolationParameter.h"

typedef  enum {

    //    Exponential	0	球函数（Spherical Variogram Mode）
    VM_EXPONENTIAL = 0,
    
    //Gaussian	1	高斯函数（Gaussian  Variogram Mode）//改类型对应的算法可能存在问题，需要测试
    VM_GAUSSIAN = 1,
    
    //Spherical	9	指数函数（Exponential Variogram Mode）
    VM_SPHERICAL = 9

    
}VariogramMode;

typedef  enum {
    Exponent_1 = 1,
    Exponent_2 = 2
}Exponent_Value;

@interface InterpolationKrigingParameter : InterpolationParameter

@property(nonatomic,assign) VariogramMode variogramMode;
@property(nonatomic,assign) double range;
@property(nonatomic,assign) double sill;
@property(nonatomic,assign) double angle;
@property(nonatomic,assign) double nugget;
@property(nonatomic,assign) double mean;
@property(nonatomic,assign) Exponent_Value exponent;

-(id)initWithType:(InterpolationAlgorithmType)type;

-(id)initWithResolution:(double)resolution searchMode:(SearchMode)mode searchRadius:(double)searchRadius expectedCount:(int)expectedCount variogramMode:(VariogramMode)variogramMode;

-(id)initWithType:(InterpolationAlgorithmType)type resolution:(double)resolution searchMode:(SearchMode)mode searchRadius:(double)searchRadius expectedCount:(int)expectedCount variogramMode:(VariogramMode)variogramMode;

@end

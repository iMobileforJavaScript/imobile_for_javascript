//
//  DensityAnalystParameter.h
//  LibUGC
//
//  Created by wnmng on 2019/7/11.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NeighbourShape,Rectangle2D;

@interface DensityAnalystParameter : NSObject

-(id)init;
-(id)initWithResolution:(double)resolution searchRadius:(double)searchRadius;

@property(nonatomic,assign) double resolution;
@property(nonatomic,assign) double searchRadius;

@property(nonatomic,strong) NeighbourShape* searchNeighbourhood;

@property(nonatomic,strong) Rectangle2D* bounds;

-(void)dispose;

@end

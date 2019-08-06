//
//  NeighbourShapeCircle.h
//  LibUGC
//
//  Created by wnmng on 2019/7/11.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#import "NeighbourShape.h"

@interface NeighbourShapeCircle : NeighbourShape

-(id)initWith:(NeighbourShapeCircle *)shape;

-(NeighbourShapeType)shapeType;

@property(nonatomic,assign) double radius;

@end

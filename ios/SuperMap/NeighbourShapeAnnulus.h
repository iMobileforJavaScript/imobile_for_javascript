//
//  NeighbourShapeAnnulus.h
//  LibUGC
//
//  Created by wnmng on 2019/7/11.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#import "NeighbourShape.h"

@interface NeighbourShapeAnnulus : NeighbourShape

-(id)initWith:(NeighbourShapeAnnulus *)shape;

-(NeighbourShapeType)shapeType;

@property(nonatomic,assign) double innerRadius;
@property(nonatomic,assign) double outerRadius;

@end

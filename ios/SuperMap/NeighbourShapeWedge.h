//
//  NeighbourShapeWedge.h
//  LibUGC
//
//  Created by wnmng on 2019/7/11.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#import "NeighbourShape.h"

@interface NeighbourShapeWedge : NeighbourShape


-(id)initWith:(NeighbourShapeWedge *)shape;

-(NeighbourShapeType)shapeType;

@property(nonatomic,assign) double radius;
@property(nonatomic,assign) double startAngle;
@property(nonatomic,assign) double endAngle;

@end

//
//  NeighbourShapeRectangle.h
//  LibUGC
//
//  Created by wnmng on 2019/7/11.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#import "NeighbourShape.h"

@interface NeighbourShapeRectangle : NeighbourShape

-(id)initWith:(NeighbourShapeRectangle *)shape;

-(NeighbourShapeType)shapeType;

@property(nonatomic,assign) double width;
@property(nonatomic,assign) double height;

@end

//
//  NeighbourShape.h
//  LibUGC
//
//  Created by wnmng on 2019/7/11.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  enum {
    
    NST_NONE = 0,
    //Rectangle   1 	矩形
    NST_RECTANGLE =  1,
    
    //Circle	2	圆
    NST_CIRCLE = 2,
    
    //Annulus	3	圆环
    NST_ANNULUS = 3,
    
    //Wedge	 4	扇形
    NST_WEDGE =  4
    
}NeighbourShapeType;

typedef  enum {
    
    //    Cell	栅格坐标
    NUT_CELL =  1,
    
    //Map	2	地理坐标
    NUT_MAP = 2,
    
}NeighbourUnitType;

@interface NeighbourShape : NSObject

-(NeighbourShapeType)shapeType;
@property(nonatomic,assign)NeighbourUnitType unitType;

-(NeighbourShape*)clone;

@end

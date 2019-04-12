//
//  ChartPoint.h
//  HotMap
//
//  Created by imobile-xzy on 16/12/20.
//  Copyright © 2016年 imobile-xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Point2D;
@interface ChartPoint : NSObject

//位置点
@property(nonatomic,strong)Point2D* point;
//数据权值
@property(nonatomic)float weighted;
-(id)initWithPoint:(Point2D*)point weight:(float)weighted;
@end

@interface RelationalChartPoint:ChartPoint
@property(nonatomic,strong)NSString* relationalName;
//关系点
@property(nonatomic,strong)NSMutableArray* relationalPoints;
@end

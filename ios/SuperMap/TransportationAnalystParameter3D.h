//
//  TransportationAnalystParameter3D.h
//  DynamicView
//
//  Created by imobile-xzy on 16/3/26.
//  Copyright © 2016年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Point3Ds;
@interface TransportationAnalystParameter3D : NSObject

@property(nonatomic)BOOL isRoutesReturn;
@property(nonatomic)BOOL isNodesReturn;
@property(nonatomic)BOOL isEdgesReturn;
@property(nonatomic)BOOL isPathGuidesReturn;
@property(nonatomic)BOOL isStopsReturn;

@property(nonatomic,strong)NSArray* nodes;
@property(nonatomic,strong)Point3Ds* points;
@property(nonatomic,strong)NSString* weightName;
@property(nonatomic,strong)NSArray* barrierNodes;
@property(nonatomic,strong)NSArray* barrierEdges;
@property(nonatomic,strong)Point3Ds* barrierPoints;
@property(nonatomic,strong)NSString* turnWeightField;

-(void)reset;
-(void)dispose;
@end

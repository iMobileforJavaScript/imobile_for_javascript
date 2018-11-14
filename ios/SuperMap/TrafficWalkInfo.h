//
//  TrafficWalkInfo.h
//  LibUGC
//
//  Created by wnmng on 2017/9/15.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Point2D,Point2Ds;
@interface TrafficWalkInfo : NSObject

//步行距离
@property(nonatomic,assign) double walkDistance;

//中心点
@property(nonatomic,strong) Point2D *center;

//几何对象唯一标识符
@property(nonatomic,strong) NSString *strID;

//描述几何对象中各个子对象所包含的节点的个数
@property(nonatomic,strong) NSArray *partsNodeCounts;

//组成几何对象的节点的二维坐标对数组
@property(nonatomic,strong) Point2Ds *points;

//几何对象的类型
@property(nonatomic,strong) NSString *geometryType;

@end

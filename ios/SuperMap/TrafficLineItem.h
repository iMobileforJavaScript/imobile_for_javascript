//
//  TrafficLineItem.h
//  LibUGC
//
//  Created by wnmng on 2017/9/15.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  Point2D,Point2Ds;

@interface TrafficLineItem : NSObject

//分段线路的方向
@property(nonatomic,strong) NSString* lineDirection;

//当前分段距离
@property(nonatomic,assign) double distance;

//从起始点到公交（地铁）起点的步行距离
@property (nonatomic,assign) double walkDistance;

//当前分段起始公交（地铁）站经纬度坐标
@property (nonatomic,strong) Point2D *upLocation;
//当前分段终点公交（地铁）站经纬度坐标
@property (nonatomic,strong) Point2D *downLocation;

//上车站相较全程的索引
@property (nonatomic,assign) int startStopIndex;
//下车站相较全程的索引
@property (nonatomic,assign) int endStopIndex;

//当前分段起始公交（地铁）站名称
@property(nonatomic,strong) NSString* startStopName;

//当前分段终点公交（地铁）站名称
@property(nonatomic,strong) NSString* endStopName;

//当前分段乘坐的公交（地铁）线路名称
@property(nonatomic,strong) NSString* lineName;

//当前公交（或地铁）的早晚运营时间
@property(nonatomic,strong) NSString* lineTime;

//当前线路类型
@property(nonatomic,strong) NSString* lineType;

//总经历的站次数
@property (nonatomic,assign) int passStopCount;


@end

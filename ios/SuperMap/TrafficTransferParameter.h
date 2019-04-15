//
//  TrafficTransferParameter.h
//  LibUGC
//
//  Created by wnmng on 2017/9/15.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoordinateType.h"

@interface TrafficTransferParameter : NSObject

//起点名称
@property (nonatomic,strong) NSString* startName;
//终点名称
@property (nonatomic,strong) NSString* destinationName;
//公交换乘服务查询范围
@property (nonatomic,strong) NSString* queryCity;
//公交换乘策略 0表示正常模式，1表示不走地铁
@property (nonatomic,assign) int trafficType;
//最大换乘方案个数
@property (nonatomic,assign) int resultCount;
//坐标类型
@property (nonatomic,assign) CoordinateType coordinateType;

@end

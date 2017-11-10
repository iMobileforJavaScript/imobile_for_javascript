//
//  OnlinePathInfo.h
//  LibUGC
//
//  Created by wnmng on 2017/9/15.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Point2D;
@interface OnlinePathInfo : NSObject

//下一条道路的转弯方向
// 下一条道路的转弯方向。0代表直行，1代表左前转弯，2代表右前转弯，3代表左转弯，4代表右转弯，5代表走后转弯，6代表右后转弯，7代表掉头，8代表右转弯绕行至左，9代表直角斜边右转弯，10代表环岛。
@property(nonatomic,assign) int nextDirection;

//下一条道路的路口点坐标
@property(nonatomic,strong) Point2D* crossLocation;

//道路的长度
@property(nonatomic,assign) double length;

//当前道路的名称
@property(nonatomic,strong) NSString* roadName;

@end

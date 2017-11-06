//
//  NavigationOnlineParamater.h
//  LibUGC
//
//  Created by wnmng on 2017/9/15.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoordinateType.h"

@class Point2D,Point2Ds;

typedef enum {
    /**
     * 距离最短
     */
    MIN_LENGTH,
    /**
     * 不走高速
     */
    NO_HIGHWAY,
    /**
     * 推荐模式
     */
    RE_COMMEND
}OLRouteType;

@interface NavigationOnlineParamater : NSObject

//分析导航的起点
@property (nonatomic,strong) Point2D *startPoint;

//分析导航的终点
@property (nonatomic,strong) Point2D *endPoint;

//导航分析中间点
@property (nonatomic,strong) Point2Ds *passPoints;

//导航分析模式
@property (nonatomic,assign) OLRouteType routeType;

//是否返回路径导引信息
@property (nonatomic,assign) BOOL isReturnPathInfo;

//是否返回路径
@property (nonatomic,assign) BOOL isReturnPathPoint;

//坐标类型
@property (nonatomic,assign) CoordinateType coordationType;

@end

//
//  TrafficStartInfo.h
//  LibUGC
//
//  Created by wnmng on 2017/9/15.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Point2D;

@interface TrafficPositionInfo : NSObject

//起点名称
@property (nonatomic,strong) NSString *name;
//起点地理坐标
@property (nonatomic,strong) Point2D *location;
//从起点到公交站的步行距离
@property (nonatomic,assign) double walkDistance;

@end

//
//  NavigationOnlineData.h
//  LibUGC
//
//  Created by wnmng on 2017/9/15.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GeoLine;

@interface NavigationOnlineData : NSObject

//返回分析结果的点集合
@property (nonatomic,strong) GeoLine* route;

//返回分析结果的引导信息集合
@property (nonatomic,strong) NSArray* pathInfos;

//导航花费时间
@property (nonatomic,strong) NSString* time;

//返回分析结果的总长度
@property (nonatomic,strong) NSString* length;


@end

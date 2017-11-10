//
//  TrafficSolutionItem.h
//  LibUGC
//
//  Created by wnmng on 2017/9/15.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrafficWalkInfo.h"
#import "TrafficPositionInfo.h"
#import "TrafficLineItemArray.h"


@interface TrafficSolutionItem : NSObject

//起点信息
@property (nonatomic,strong) TrafficPositionInfo *startInfo;

//终点信息
@property (nonatomic,strong) TrafficPositionInfo *destinationInfo;

//具体公交换乘线路信息
@property (nonatomic,strong) NSArray *linesItems;

//当前方案换乘次数
@property (nonatomic,assign) int transferCount;

//换乘中间的步行线路信息
@property (nonatomic,strong) NSArray *walkInfos;


@end

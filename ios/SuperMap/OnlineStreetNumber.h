//
//  OnlineStreetNumber.h
//  LibUGC
//
//  Created by wnmng on 2017/9/14.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnlineStreetNumber : NSObject

/**
 * 门牌地址到请求坐标的距离(m)
 */
@property(nonatomic,strong) NSString *distance;

/**
 * 街道名称
 */
@property(nonatomic,strong) NSString *street;

/**
 * 门牌号
 */
@property(nonatomic,strong) NSString *number;

@end

//
//  GeocodingData.h
//  LibUGC
//
//  Created by wnmng on 2017/9/14.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OnlineAddress.h"

@class  Point2D;
@interface GeocodingData : NSObject


/**
 * 符合地理编码规范的规范地名地址描述
 */
@property (nonatomic,strong) NSString *formatedAddress;

/**
 * 地理编码分析的具体地址描述
 */
@property (nonatomic,strong) OnlineAddress *address;

/**
 * 匹配输入地址描述的地理坐标
 */
@property (nonatomic,strong) Point2D *location;

/**
 * 匹配的数据记录名称
 */
@property (nonatomic,strong) NSString *name;

/**
 * 匹配结果的可信度
 */
@property (nonatomic,assign) int confidence;



@end

//
//  SolarRadiationParameter.h
//  LibUGC
//
//  Created by wnmng on 2019/7/17.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  enum {
    // 时刻，需要指定日期和小时时间点，其计算的范围是用户指定的小时间隔
    //STM_MOMENT = 1,

    // 计算一天内的太阳辐射，需要指定日期DayA、开始时间HourA和结束时间HourB
    STM_WITHINDAY = 2,

    // 计算多天的太阳辐射总量，需要指定开始日期DayA、结束日期DayB、每天开始时间HourA和结束时间HourB
    STM_MULTIDAYS = 3
    
}SolarTimeMode;

@interface SolarRadiationParameter : NSObject

/**
 * 设置待计算区域的纬度值
 */
@property(nonatomic,assign) double latitude;
/**
 * 设置时间模式
 */
@property(nonatomic,assign) SolarTimeMode timeMode;
/**
 * 起始日期（年内的第几天），一天内计算时为指定日期
 */
@property(nonatomic,assign) int dayStart;
/**
 * 结束日期（年内的第几天）
 */
@property(nonatomic,assign) int dayEnd;
/**
 * 设置起始时点
 */
@property(nonatomic,assign) double hourStart;
/**
 * 设置结束时点
 */
@property(nonatomic,assign) double hourEnd;
/**
 * 天数间隔，单位为天
 */
@property(nonatomic,assign) int dayInterval;
/**
 * 小时间隔，单位为小时
 */
@property(nonatomic,assign) double hourInterval;
/**
 * 太阳辐射穿过大气的透射率
 */
@property(nonatomic,assign) double transmittance;
/**
 * 高程缩放系数
 */
@property(nonatomic,assign) double zFactor;

@end

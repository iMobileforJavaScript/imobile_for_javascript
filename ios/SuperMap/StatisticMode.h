//
//  StatisticMode.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

/** 该类定义了字段统计方法类型常量。
 * 
 * 对单一字段提供常用统计功能。SuperMap 提供的统计功能有6种，统计字段的最大值，最小值，平均值，总和，标准差以及方差。</p>
 */
typedef enum {
  /**
     * 最大值。
     */
	MAX = 1,
 /**
     * 最小值。
     */
    MIN = 2,
/**
     * 平均值。
     */
    AVERAGE = 3,
/**
     * 总值。
     */
    SUM = 4,
/**
     * 标准差。
     */
    STDDEVIATION = 5,
/**
     * 方差。
     */
    VARIANCE = 6
}StatisticMode;

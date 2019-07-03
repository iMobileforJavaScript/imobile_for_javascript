//
//  LayerHeatmap.h
//  Objects_iOS
//
//  Created by imobile-xzy on 2019/7/2.
//  Copyright © 2019 beijingchaotu. All rights reserved.
//

#import "Layer.h"

typedef enum {
    AggregationFunctionType_SUM = 0,
    AggregationFunctionType_AVG = 1,
    AggregationFunctionType_MAX = 2,
    AggregationFunctionType_MIN = 3,
    AggregationFunctionType_COUNT=4,
} AggregationFunctionType;

//typedef enum {
//   HSB = 1,
//   RGB = 2,
//} ColorType;

@class Color,Colors;
@interface LayerHeatmap : Layer

/**
 * 核半径
 * @return 返回用于计算密度的核半径 单位：屏幕坐标
 */
@property(nonatomic)int kernelRadius;

/**
 * 高密度点的颜色
 * @return 返回高密度点的颜色
 */
@property(nonatomic,strong)Color* maxColor;

/**
 * 低密度点的颜色
 * @return 返回低密度点的颜色
 */
@property(nonatomic,strong)Color* minColor;

/**
 * 最大值
 * @param vlaue
 */
@property(nonatomic)double maxValue;

/**
 * 最小值
 * @param vlaue
 */
@property(nonatomic)double minValue;

/**
 * 高点密度颜色比重
 * @param value 热力图中高点密度颜色(MaxColor)和低点密度颜色(MinColor)确定渐变色带中高点
 *                 密度颜色所占的比重，该值越大，表示色带中高点密度颜色所占比重越大。
 */
@property(nonatomic)double intensity;


/**
 * 设置热力图中颜色渐变的模糊程度
 * @param value 热力图中颜色渐变的模糊程度
 */
@property(nonatomic)double fuzzyDegree;


/**
 * 设置权重字段
 * @param field 权重字段，热力图图层除了可一反映点要素的相对密度，还可以表示根据权重字段进行加权的点密度，
 *                 以此考虑点本身的权重对于密度的贡献。
 */

@property(nonatomic,strong)NSString* weightField;




/**
 * 获取热力图聚合字段应用的聚合函数
 * @return 获取热力图聚合字段应用的聚合函数。聚合函数支持对聚合字段进行求和、求最值、平均值等。
 */
@property(nonatomic)AggregationFunctionType aggregationFun;

/**
 * 设置颜色集合
 * @param colors 颜色集合
 */
@property(nonatomic,strong)Colors* colorset;

/**
 * 设置热力图中颜色渐变模式
 * @param type 设置热力图中颜色渐变模式，包含两种模式：HSB和RGB
 HSB = 1,
 RGB = 2,
 */
@property(nonatomic)int gradientColorType;
@end

//
//  KernelDensityOnlineChart.h
//  HotMap
//
//  Created by imobile-xzy on 17/6/29.
//  Copyright © 2017年 imobile-xzy. All rights reserved.
//

#import "DistributeAnalyst.h"
@class Rectangle2D;
/**
*  在线密度分析类
*/
@interface DensityAnalystOnline : DistributeAnalyst

/**
 * 分辨率（网格大小）
 */
@property(nonatomic)double resolution;
/**
 * 半径
 */
@property(nonatomic)double radius;
/**
 * 权重值
 */
@property(nonatomic)NSString* weight;
/**
 * 网络面类型 其中0：四边形网格，1：六边形网格
 */
@property(nonatomic)int meshType;
/**
 * 分析方法 其中0：简单点密度分析，1：核密度分析
 */
@property(nonatomic)int analystMethod;
/**
 * 面积单位
 * <p>面积单位：SquareMile(默认),SquareMeter,SquareKiloMeter,Hectare,Are,Acre,SquareFoot,SquareYard</p>
 */
@property(nonatomic,strong)NSString* areaUnit;
/**
 * 网格单位
 * <p>网格大小单位：Meter(默认),Kilometer,Yard,Foot,Mile</p>
 */
@property(nonatomic,strong)NSString* meshSizeUnit;
/**
 * 搜索半径单位
 * <p>搜索半径单位：Meter(默认),Kilometer,Yard,Foot,Mile</p>
 */
@property(nonatomic,strong)NSString* radiusUnit;
/**
 * 数据路径
 */
@property(nonatomic,strong)NSString* dataPath;
/**
 * 分析范围
 */
@property(nonatomic,strong)Rectangle2D* bounds;

/**
 * 专题图分段个数
 * 默认为:0
 */
@property(nonatomic)NSInteger rangeCount;
/**
 * 专题图分段模式: EQUALINTERVAL(等距离分段)、LOGARITHM(对数分段)、QUANTILE(等计数分段)、SQUAREROOT(平方根分段)、STDDEVIATION (标准差分段)
 * 默认为:EQUALINTERVAL(等距离分段)
 */
@property(nonatomic,strong)NSString* rangeMode;
/**
 * 专题图颜色渐变模式: GREENORANGEVIOLET(绿橙紫渐变色)、GREENORANGERED(绿橙红渐变)、RAINBOW(彩虹色)、SPECTRUM(光谱渐变)、TERRAIN (地形渐变)
 * 默认为:GREENORANGEVIOLET(绿橙紫渐变色)
 */
@property(nonatomic,strong)NSString* colorGradientType;
@end

//
//  ChartBar.h
//  
//
//  Created by imobile-xzy on 16/4/18.
//
//

#import "ChartView.h"
#import "ChartAxis.h"

@protocol ChartOnSelectedDelegate;

@interface BarChart : ChartView


//设置高亮色，默认白色
@property(nonatomic,strong)UIColor* hightLightColor;

/**
 * 设置数值是否按X轴分布
 * 如果设为true, 每个数值对应一个X轴坐标显示, 从第一个坐标逐次显示;
 * 如果设为false,所有数值在同一个坐标轴显示,位置和改组数据加入到显示控件的顺序有关
 * @param enabled boolean值, 是否按X轴分布
 */
@property(nonatomic)BOOL isValueAlongXAxis;

//x坐标轴,显示标签
@property(nonatomic,strong)NSArray* xAxisLables;

//x,y轴标题
@property(nonatomic,strong)NSString* xAxisTitle;
@property(nonatomic,strong)NSString* yAxisTitle;
//坐标轴标题大小
@property(nonatomic)float axisTitleSize;
//最标轴标签大小
@property(nonatomic)float axisLableSize;

@property(nonatomic)id<ChartOnSelectedDelegate>deleagate;


//设置选中的对象ID
-(void)setSelectedGeoID:(int)geoID;


@end

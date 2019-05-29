//
//  ChartLine.h
//  
//
//  Created by imobile-xzy on 16/4/18.
//
//

#import "ChartView.h"


@protocol ChartOnSelectedDelegate;

@interface LineChart : ChartView

//x坐标轴,显示标签
@property(nonatomic,strong)NSArray* xAxisLables;

//x,y轴标题
@property(nonatomic,strong)NSString* xAxisTitle;
@property(nonatomic,strong)NSString* yAxisTitle;
//坐标轴标题大小
@property(nonatomic)float axisTitleSize;
//最标轴标签大小
@property(nonatomic)float axisLableSize;

//设置高亮色，默认白色
@property(nonatomic,strong)UIColor* hightLightColor;

//是否开启用户平移，缩放
@property(nonatomic)BOOL allowsUserInteraction;

//设置选中的对象ID
-(void)setSelectedGeoID:(int)geoID;
@property(nonatomic)id<ChartOnSelectedDelegate>deleagate;
@end


//
//  ChartPie.h
//  
//
//  Created by imobile-xzy on 16/4/13.
//
//

#import "ChartView.h"

@protocol ChartOnSelectedDelegate;
//饼图
@interface PieChart : ChartView

/**
 * 设置图表上文字颜色
 * @param color
 */
@property(nonatomic,strong)UIColor* textColor;

//饼图半径
@property(nonatomic)float radious;
//饼图中心点
@property(nonatomic)CGPoint center;
//设置选中的对象ID
-(void)setSelectedGeoID:(int)geoID;

@property(nonatomic)id<ChartOnSelectedDelegate>deleagate;
@end


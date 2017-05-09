//
//  PolymePlotChart.h
//  
//
//  Created by imobile-xzy on 16/11/21.
//
//

#import "ChartView.h"

@class MapControl;
@class Color;
@interface PolymerChart : ChartView

//聚合像素半径，默认12
//@property(nonatomic)int polymerRadious;
//使用聚合算法类型 1:聚类 2:网格 默认聚类
@property(nonatomic)int polymeriztionType;
//设置展开高亮色
@property(nonatomic,strong)Color* foldColor;
//设置未展开暗处色
@property(nonatomic,strong)Color* unfoldColor;

-(id)initWithMapControl:(MapControl*)mapControl;
//设置关系点调色板
-(void)setColorScheme:(ColorScheme*)colorScheme;
@end

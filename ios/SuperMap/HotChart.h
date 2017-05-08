//
//  GLView.h
//  
//
//  Created by imobile-xzy on 16/11/7.
//
//


#import "ChartView.h"

@class ColorScheme,Color,MapControl;

//热力图
@interface HotChart : ChartView

//是否开启颜色平滑过渡，默认开启
@property(nonatomic)BOOL isSmoothTransColor;
//初始化，参数 1.绘制层
-(id)initWithMapControl:(MapControl*)mapControl;
//设置调色板
-(void)setColorScheme:(ColorScheme*)colorScheme;
//默认20
-(void)setRadius:(float)radious;
@end




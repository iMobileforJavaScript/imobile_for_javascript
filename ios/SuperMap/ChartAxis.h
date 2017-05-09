//
//  ChartAxis.h
//  
//
//  Created by imobile-xzy on 16/4/19.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    VALUE=0,//数值类型
    TIME,//时间类型
    USER,//自定义类型eg: [A条目,B条目,C条目]
} AxisType;
//坐标轴类(该类不对外开放)
@interface ChartAxis : NSObject

//坐标轴类型
@property(nonatomic)AxisType type;
//坐标轴标题
@property(nonatomic,strong)NSString* title;
//分段数
@property(nonatomic)int spliteNumber;
//每个分段小格数量
@property(nonatomic)int axisTick;
//USER模式设置有效
@property(nonatomic,strong)NSArray* axisData;
@end

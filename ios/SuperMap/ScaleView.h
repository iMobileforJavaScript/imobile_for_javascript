//
//  ScaleView.h
//  TestProject
//
//  Created by imobile on 15/6/24.
//  Copyright (c) 2015年 imobile. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum{
    
    SV_Global = 0,//国际化类型(m/km)
    SV_Chinese = 1//汉字类型(米/千米)
}ScaleType;

@class MapControl;
@interface ScaleView : UIView

//设置显示类型,默认Global
@property(nonatomic)ScaleType scaleType;
//是否分级，默认分级
@property(nonatomic,assign)BOOL levelEnable;
//是否可见，默认可见
@property(nonatomic,assign)BOOL showEnable;

//用于用户设置X轴比例尺位置，默认在左下角
@property(nonatomic)double xOffset;
//用于用户设置y轴比例尺位置，默认在左下角
@property(nonatomic)double yOffset;

-(id)initWithMapControl:(MapControl*)mapcontrol;
@end

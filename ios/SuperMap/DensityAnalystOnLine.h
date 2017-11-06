//
//  KernelDensityOnlineChart.h
//  HotMap
//
//  Created by imobile-xzy on 17/6/29.
//  Copyright © 2017年 imobile-xzy. All rights reserved.
//

#import "DistributeAnalyst.h"

@interface DensityAnalystOnline : DistributeAnalyst

//分辨率（网格大小）
@property(nonatomic)double resolution;
//半径
@property(nonatomic)double radius;
//权值索引
@property(nonatomic)NSString* weight;
//网络面类型
@property(nonatomic)int meshType;
//分析方法
@property(nonatomic)int analystMethod;
//面积单位
@property(nonatomic,strong)NSString* areaUnit;
//网格大小单位
@property(nonatomic,strong)NSString* meshSizeUnit;
//半径单位
@property(nonatomic,strong)NSString* radiusUnit;
@end

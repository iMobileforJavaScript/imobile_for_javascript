//
//  SummaryRegionOnline.h
//  HotMap
//
//  Created by lucd on 2017/9/30.
//  Copyright © 2017年 imobile-lucd. All rights reserved.
//

#import "DistributeAnalyst.h"
@interface SummaryRegionOnline : DistributeAnalyst
/**
 * 设置汇总类型
 */
@property(nonatomic,strong)NSString* summaryType;
//设置网格面汇总类型
@property(nonatomic)int meshType;
//设置网格单位
@property(nonatomic,strong)NSString* meshSizeUnit;
//设置网格大小
@property(nonatomic)int resolution;
//设置是否统计长度或者面积
@property(nonatomic)BOOL lengthOrArea;

//设置标准属性字段统计
-(void) setStandardFields:(NSString*) fieldName andStatisticModes:(NSString*) statisticModes;

//设置权重字段统计
-(void) setWeightedFields:(NSString*) fieldName andStaticModes:(NSString*) statisticModes;

@end

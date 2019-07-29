//
//  SolarRadiationAnalyst.h
//  LibUGC
//
//  Created by wnmng on 2019/7/17.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SolarRadiationParameter.h"
#import "SolarRadiationResult.h"

@class Datasource;
@interface SolarRadiationAnalyst : NSObject

/**
 * 计算区域太阳辐射，即整个DEM范围内每个栅格的太阳辐射情况
 *
 * @param sourceDatasetGrid
 *            待计算太阳辐射的栅格数据
 * @param parameter
 *            太阳辐射计算参数
 * @param targetDatasource
 *            输出数据所在数据源
 * @param totalGridName
 *            输出总辐射量数据集的名称
 * @param directGridName
 *            输出直射辐射量数据集的名称，可选，允许传null
 * @param diffuseGridName
 *            输出散射辐射量数据集的名称，可选，允许传null
 * @param durationGridName
 *            输出太阳直射持续时间数据集的名称，可选，允许传null
 * @return 太阳辐射结果对象
 */
+(SolarRadiationResult*)areaSolarRadiation:(DatasetGrid*)srcDataset parameter:(SolarRadiationParameter*)parameter targetDatasource:(Datasource*)targetDatasource totalGridName:(NSString*)totalGridName directGridName:(NSString*)directGridName diffuseGridName:(NSString*)diffuseGridName durationGridName:(NSString*)durationGridName;

@end

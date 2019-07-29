//
//  SolarRadiationResult.h
//  LibUGC
//
//  Created by wnmng on 2019/7/17.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  DatasetGrid;

@interface SolarRadiationResult : NSObject

-(id)initWithTotal:(DatasetGrid*)total direct:(DatasetGrid*)direct diffuse:(DatasetGrid*)diffuse duration:(DatasetGrid*)duration;

/**
 * 返回总辐射量数据集
 */
@property(nonatomic,strong,readonly) DatasetGrid* totalDatasetGrid;
/**
 * 返回直射辐射量数据集
 */
@property(nonatomic,strong,readonly) DatasetGrid* directDatasetGrid;
/**
 * 返回散射辐射量数据集
 */
@property(nonatomic,strong,readonly) DatasetGrid* diffuseDatasetGrid;
/**
 * 返回太阳直射持续时间数据集
 */
@property(nonatomic,strong,readonly) DatasetGrid* durationDatasetGrid;

@end

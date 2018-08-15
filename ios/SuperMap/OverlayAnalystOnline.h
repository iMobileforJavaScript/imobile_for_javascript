//
//  OverlayAnalystOnline.h
//  900bSources_ugc2_92
//
//  Created by lucd on 2018/2/26.
//  Copyright © 2018年 supermap. All rights reserved.
//

#import "DistributeAnalyst.h"
/**
 *  在线叠加分析
 */
@interface OverlayAnalystOnline : DistributeAnalyst
/**
 * 叠加对象数据集
 */
@property(nonatomic,strong)NSString* datasetName;

/**
 * 源数据集
 */
@property(nonatomic,strong)NSString* datasetSourceName;

/**
 * 叠加分析模式
 * <p>空间叠加分析模式支持：裁剪clip、擦除erase、合并union、相交intersect、同一identity、对称差xOR、更新update</p>
 */
@property(nonatomic,strong)NSString* overlayMode;

/**
 * 源数据集保留字段
 */
@property(nonatomic,strong)NSString* saveFields;
@end

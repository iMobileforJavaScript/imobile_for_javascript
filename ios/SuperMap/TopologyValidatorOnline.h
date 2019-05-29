//
//  TopologyValidatorOnline.h
//  900bSources_ugc2_92
//
//  Created by lucd on 2018/2/26.
//  Copyright © 2018年 supermap. All rights reserved.
//

#import "DistributeAnalyst.h"
/**
 * 在线拓扑检查分析
 */
@interface TopologyValidatorOnline : DistributeAnalyst
/**
 * 设置/获取源数据集
 *
 */
@property (nonatomic,strong)NSString *datasetSourceName;
/**
 * 设置/获取拓扑检查规则
 * <p>检查规则有：REGIONNOOVERLAP面数据集内部无交叠 REGIONNOOVERLAPWITH面数据集和面数据集无交叠 REGIONCONTAINEDBYREGION面数据集被面数据集包含 REGIONCOVEREDBYREGION面数据集被面数据集覆盖 LINENOOVERLAP线数据集内部无交叠 LINENOOVERLAPWITH线数据集与线数据集无交叠 POINTNOIDENTICAL点数据集内部无重复点</p>
 */
@property (nonatomic,strong)NSString *topologyRule;
/**
 *  设置/获取容限
 */
@property (nonatomic)NSInteger tolerance;
/**
 * 设置外部拓扑检查数据集
 * @param datasetTopology 拓扑检查数据集
 * <p>说明：该方法针对不同数据集才有效</p>
 */
-(void) setExternalDatasetTopology:(NSString *) datasetTopology;
@end

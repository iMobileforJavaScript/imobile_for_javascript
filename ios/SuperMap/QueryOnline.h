//
//  QueryOnline.h
//  HotMap
//
//  Created by lucd on 2017/10/13.
//  Copyright © 2017年 imobile-lucd. All rights reserved.
//

#import "DistributeAnalyst.h"
@interface QueryOnline : DistributeAnalyst
/**
 * 叠加对象数据集
 */
@property(nonatomic,strong)NSString* datasetName;

/**
 * 源数据集
 */
@property(nonatomic,strong)NSString* datasetSourceName;

/**
 * 空间查询模式
 * 空间查询模式支持：CONTAIN包含,CROSS交叉,DISJOINT分离,IDENTITY重合,INTERSECT相交,OVERLAP叠加,TOUCH邻接,WITHIN被包含</p>
 */
@property(nonatomic,strong)NSString* queryMode;
@end


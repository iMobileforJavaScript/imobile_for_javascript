//
//  GridIndexOnline.h
//  900bSources_ugc2_92
//
//  Created by lucd on 2018/2/27.
//  Copyright © 2018年 supermap. All rights reserved.
//

#import "DistributeAnalyst.h"
@class Rectangle2D;
/**
 * 在线网格索引
 */
@interface GridIndexOnline : DistributeAnalyst
/**
 * 设置/获取输入数据路径
 */
@property(nonatomic,strong)NSString* dataPath;
//@property(nonatomic)NSString *indexType;
/**
 * 设置/获取索引文件配置
 * <p>注：当设置索引文件配置时，不需要再设置计算范围、网格行列数、容限值等，只需要在设置输出的HDFS路径</p>
 */
@property(nonatomic,strong)NSString *indexFile;
///**
// * 设置/获取索引参数配置
// */
//@property(nonatomic)BOOL isParamSetting;

/**
 * 设置/获取计算范围
 */
@property(nonatomic,strong)Rectangle2D* bounds;
/**
 * 设置/获取网格索引行数目
 */
@property(nonatomic)NSInteger gridRows;
/**
 * 设置/获取网格索引列数目
 */
@property(nonatomic)NSInteger gridCols;
/**
 * 设置/获取对象计算分区时向外扩充的容限值
 */
@property(nonatomic)NSInteger intervalTolerance;
/**
 * 设置/获取输出到HDFS的路径
 */
@property(nonatomic,strong)NSString *outputHDFSPath;
@end

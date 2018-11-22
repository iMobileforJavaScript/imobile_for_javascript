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
 * 查询对象数据集
 */
@property(nonatomic,strong)NSString* datasetQuery;

/**
 * 源数据集
 */
@property(nonatomic,strong)NSString* datasetSourceName;

/**
 * 空间查询模式
 * 空间查询模式支持：CONTAIN包含,CROSS交叉,DISJOINT分离,IDENTITY重合,INTERSECT相交,OVERLAP叠加,TOUCH邻接,WITHIN被包含</p>
 */
@property(nonatomic,strong)NSString* queryMode;

/**
 * 设置查询几何对象，以及是否生成缓冲区
 * @param geometryQuery 几何对象
 * @param isBuffer  是否生成缓冲区
 */
-(void) setGeometryQuery:(NSString *)geometryQuery isBuffer:(BOOL)isBuffer;
/**
 * 缓冲半径单位
 */
@property(nonatomic,strong)NSString* bufferRadiusUnit;
/**
 * 左侧缓冲距离
 */
@property(nonatomic)NSInteger bufferLeftDistance;
/**
 * 右侧缓冲距离
 */
@property(nonatomic)NSInteger bufferRightDistance;
/**
 * 缓冲区端点类型
 */
@property(nonatomic,strong)NSString* bufferEndType;
/**
 * 圆弧线段个数
 */
@property(nonatomic)NSInteger semicircleLineSegment;
@end


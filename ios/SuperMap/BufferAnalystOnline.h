//
//  BufferAnalystOnline.h
//  812Sources_ugc2_91
//
//  Created by lucd on 2018/2/7.
//  Copyright © 2018年 supermap. All rights reserved.
//

#import "DistributeAnalyst.h"
@class Rectangle2D;
/**
 * 在线缓冲分析
 */
@interface BufferAnalystOnline : DistributeAnalyst{
    Rectangle2D* _bounds;
    NSString* _datasetName;
    NSString* _distanceField;
    NSString* _distanceUnit;
    NSString* _dissolveField;
    NSInteger _distance;
}
/**
 * 设置数据源集
 */
@property (nonatomic,strong) NSString* datasetSourceName;
/**
 * 设置分析范围
 */
@property (nonatomic,strong) Rectangle2D* bounds;
/**
 * 设置缓冲字段
 */
@property (nonatomic,strong) NSString* bufferField;
/**
 * 设置缓冲距离单位
 */
@property (nonatomic,strong) NSString* bufferDistanceUnit;
/**
 * 设置融合字段
 */
@property (nonatomic,strong) NSString* dissolveField;
/**
 * 设置缓冲距离
 */
@property (nonatomic) NSInteger bufferDistance;
@end

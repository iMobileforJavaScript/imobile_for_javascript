//
//  OverlayOnlineChart.h
//  HotMap
//
//  Created by imobile-xzy on 17/7/11.
//  Copyright © 2017年 imobile-xzy. All rights reserved.
//

#import "DistributeAnalyst.h"
/**
*  在线矢量裁剪分析类
*/
@interface VectorClipAnalystOnline : DistributeAnalyst

/**
 * 源数据集
 */
@property(nonatomic,strong)NSString* datasetSourceName;

/**
 * 裁剪对象数据集
 */
@property(nonatomic,strong)NSString* datasetVectorClip;


/**
 * 裁剪分析模式
 * 裁剪分析模式支持：clip内部裁剪、intersect外部裁剪
 */
@property(nonatomic,strong)NSString* clipMode;

/////////////////////////////////////////////// add by-luchd 2018.2.26

/**
 * 设置裁剪几何对象，以及是否生成缓冲区
 * @param geometryClip 几何对象
 * @param isBuffer  是否生成缓冲区
 */
-(void) setGeometryClip:(NSString *)geometryClip isBuffer:(BOOL)isBuffer;
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

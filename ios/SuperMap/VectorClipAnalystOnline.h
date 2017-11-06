//
//  OverlayOnlineChart.h
//  HotMap
//
//  Created by imobile-xzy on 17/7/11.
//  Copyright © 2017年 imobile-xzy. All rights reserved.
//

#import "DistributeAnalyst.h"

@interface VectorClipAnalystOnline : DistributeAnalyst

/**
 * 叠加对象数据集
 */
@property(nonatomic,strong)NSString* datasetName;

/**
 * 源数据集
 */
@property(nonatomic,strong)NSString* datasetSourceName;

/**
 * 设置叠加分析模式
 * 叠加分析模式支持：clip内部裁剪、intersect外部裁剪 </p>
 */
@property(nonatomic,strong)NSString* analystMode;
@end

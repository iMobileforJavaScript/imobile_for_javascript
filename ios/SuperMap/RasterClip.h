//
//  RasterClip.h
//  LibUGC
//
//  Created by Apple on 16/5/18.
//  Copyright © 2016年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dataset.h"
#import "GeoRegion.h"

typedef enum {
    RCF_TIF = 103,
    RCF_IMG = 101,
    RCF_SIT = 204,
    RCF_BMP = 121,
    RCF_JPG = 122,
    RCF_PNG = 123,
    RCF_GIF = 124,
}RasterClipFileType;

@interface RasterClip : NSObject

/**
 * 栅格裁剪 支持影像数据集
 *
 * @param sourceDataset
 *            待裁剪的栅格数据
 * @param userRegion
 *            裁剪区域
 * @param bClipInRegion
 *            是否裁剪面内的部分
 * @param bExactClip
 *            是否精确裁剪
 * @param datasource
 *            输出数据所在数据源。
 * @param targetName
 *            输出数据集的名称。
 * @return 结果栅格
 */
+(Dataset*)clipDataset:(Dataset *)sourceDataset withRegion:(GeoRegion*)userRegion isClipInRegion:(BOOL)bClipInRegion isExactClip:(BOOL)bExactClip targetDatasource:(Datasource*)datasource targetDatasetName:(NSString *)targetName;

/**
 * 栅格裁剪 保存为影像文件
 *
 * @param sourceDataset
 *            待裁剪的栅格数据
 * @param userRegion
 *            裁剪区域
 * @param bClipInRegion
 *            是否裁剪面内的部分
 * @param targetFile
 *            输出影像文件名称
 * @param targetType
 *            输出影像文件类型
 * @return 栅格裁剪是否成功
 */
+(BOOL)clipDataset:(Dataset *)sourceDataset withRegion:(GeoRegion*)userRegion isClipInRegion:(BOOL)bClipInRegion targetFileName:(NSString *)targetFile targetFileType:(RasterClipFileType)targetType;
/**
 * 栅格切割 支持影像数据集
 *
 * @param sourceDataset
 *            待切割的栅格数据
 * @param splitLine
 *            切割线
 * @param targetDatasource
 *            输出数据所在数据源。
 * @param targetLeftName
 *            位于线左侧的输出数据集的名称。
 * @param targetRightName
 *            位于线右侧的输出数据集的名称。
 * @return 是否成功
 */
+(BOOL)splitDataset:(Dataset *)sourceDataset withLine:(GeoLine*)splitLine targetDatasource:(Datasource*)targetDatasource targetLeftRasterName:(NSString *)targetLeftName targetRightRasterName:(NSString *)targetRightName;

//UGC还未开放
//+(void)addSteppedListener:(id<RasterClipDelegate>)listener;
//+(void)removeStepped:(id<RasterClipDelegate>)listener;
@end

//@protocol RasterClipDelegate <NSObject>
//
//-(void)steppedEvent:(id)source percent:(int)percent remainTime:(NSInteger)remainTime;
//
//@end

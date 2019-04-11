//
//  MapCacheService.h
//  CarsMonitorDemo
//
//  Created by imobile-xzy on 16/2/2.
//  Copyright © 2016年 supermap. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MapCacheService;
@class Rectangle2D,Dataset;
@interface MapCacheService : NSObject

@property(nonatomic)id<MapCacheService> delegate;

//初始化
-(id)initWithDataset:(Dataset*)dataset;
//开始下载指定范围bounds 内缓存图片
-(void)startDownload:(Rectangle2D*)bounds NS_DEPRECATED_IOS(2_0,8_0);

// 预缓存接口，会根据用户设置的最大最小比例尺，找到相应的缓存级别进行缓存
// 如果某一层级计算出的瓦片总数 > 100万  张，则直接退出。
//! \param maxScale 最大比例尺
//! \param minScale 最小比例尺
//! \param rcBounds 出缓存范围
-(void)startDownload:(double)maxScale minScal:(double)minScale rect:(Rectangle2D*)rcBounds;

//停止下载
-(void)stopDownload;

-(void)removeCache;
@end

@protocol MapCacheService <NSObject>

//下载结束回调，nFaildCount 失败的数目
-(void)onComplete:(int)nFaildCount;
//进度从1-100，每增加一次执行一次。nStep 当前进度
-(void)onProgess:(int)nStep;
//当累计超过10张下载失败，执行。
-(void)onChecked;
// 详细进度信息，反馈给用户已下载缓存张数nDownLoadCout，总张数nTotalCount
-(void)onCacheStatus:(int)nDownLoadCout total:(long long)nTotalCount;
@end
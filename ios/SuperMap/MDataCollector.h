//
//  MDataCollector.h
//  TestProject
//
//  Created by imobile on 14/11/13.
//  Copyright (c) 2014年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Rectangle2D;
@class Dataset;
@class Datasource;
@class LocationData;

@protocol MDataCollectorMediaFileListener <NSObject>

//下载完成后回调
-(void)onDownloadMediaFiles:(NSString* )response;
//上传完成后回调
-(void)onUploadMediaFiles:(NSString* )response;

//下载指定文件名多媒体文件
-(void)downloadMediaFile:(NSString*)mediaFile;
//上传指定文件名多媒体文件
-(void)uploadMediaFile:(NSString*)mediaFile;
//采集完成回调,参数:是否成功 :文件名，文件类型:1 图片 2 视频 3 音频
-(void)onCaptureMediaFile:(BOOL)isSuccess fileName:(NSString*)mediaFileName type:(int)type;

@end

@interface MDataCollector : NSObject

/**
 *  设置LocationData数据，其数据来自自定义的定位功能
 */
-(void)setLocationData:(LocationData *)locationData;


//设置多媒体采集文件相对路径，设置后最好不要修改
@property(nonatomic,strong) NSString* localFilePath;

//代理
@property(nonatomic,strong)id<MDataCollectorMediaFileListener> delegate;
//设置多媒体数据，如果数据源没有对应名称的数据集创建符合规则的数据集，如果存在同名数据集则失败
-(BOOL)setMediaDataset:(Datasource* )datasource datasetName:(NSString* )datasetName;
//获取多媒体轨迹数据集
-(Dataset* )getMediaDataset;

//根据地理范围查询处所有在范围内的多媒体文件，本地删除
-(BOOL)removeMediaFilesWithBounds:(Rectangle2D*)bounds;

//根据文件ID，本地删除
-(BOOL)removeMediaFilesWithID:(int)mediaFileID;

//打开定位服务
-(BOOL)openGPS;
//停止定位服务
-(void)closeGPS;
//播放多媒体文件,支持.acc .mp4 .jpeg后缀名
+(void)playMultiMedia:(NSString*)mediaName;
@end

@interface MDataCollector (netWork)
//登陆
-(BOOL)login:(NSString*)urlString username:(NSString*)username password:(NSString*)password ;
//注销
-(void)logout;
//根据地理范围查询处所有在范围内的多媒体文件，然后从服务器下载
-(void)downloadMediaFiles:(Rectangle2D* )bounds;
//根据地理范围查询所有多媒体文件，然后上传服务器
-(void)uploadMediaFiles:(Rectangle2D* )bounds;
//根据文件名上传服务器
-(void)uploadMediaFilesByFileName:(NSString*)fileName;
@end

@interface MDataCollector (capture)
//捕获图像
-(BOOL)captureImage;
//捕获视频
-(BOOL)captureVideo;
//开始采集音频
-(void) startCaptureAudio;
//完成采集音频
-(BOOL)stopCaptureAudio;
@end


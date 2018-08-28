//
//  OnlineService.h
//  LibUGC
//
//  Created by wnmng on 2017/9/13.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^OnlineServiceCompletionCallback)(NSError *error);
typedef void(^OnlineServiceInfoCompletionCallback)(NSDictionary *info, NSError *error);

@protocol OnlineServiceUploadDelegate <NSObject>
@optional
/**
 上传结果
 @param error   若为nil，则成功
 */
-(void)uploadResult:(NSString*)error;
@end

@protocol OnlineServiceDownloadDelegate <NSObject>
@optional

/**
 下载进度显示
 @param bytesWritten    当前需要下载的大小
 @param totalBytesWritten   当前已经下载的总大小
 @param totalBytesExpectedToWrite  当前下载文件的总大小
 */
-(void)bytesWritten:(int64_t) bytesWritten totalBytesWritten:(int64_t) totalBytesWritten
totalBytesExpectedToWrite:(int64_t) totalBytesExpectedToWrite;
/**
 下载结果
 @param error    若为nil，则成功
 */
-(void)downloadResult:(NSString*)error;

@end

@interface OnlineService : NSObject

+ (instancetype)sharedService;

// 登录
- (void)loginWithUsername:(NSString *)username password:(NSString *)password completionCallback:(OnlineServiceCompletionCallback)completionCallback;

// 登出
- (void)logoutWithCompletionCallback:(OnlineServiceCompletionCallback)completionCallback;

// 获取账号信息
- (void)infoWithCompletionCallback:(OnlineServiceInfoCompletionCallback)completionCallback;
/**
 上传online在线数据,需要在登录过后才能调用
 @param filePath 完整的数据路径
 @param fileName 服务器上数据的名称
 注：目前仅支持上传.zip压缩包
 */
-(void)uploadFilePath:(NSString*)filePath onlineFileName:(NSString*)fileName;
/**
 上传协议
 */
@property(nonatomic)id<OnlineServiceUploadDelegate> uploadDelegate;
/**
 下载online在线数据,需要在登录过后才能调用
 @param onlineFileName 服务器上的数据名称
 @param filePath 保存完整的数据路径 ，默认保存在/Library/Caches/SupermapOnlineData/服务器上的数据名称.zip
 */
-(void)downloadFileName:(NSString*)onlineFileName filePath:(NSString*)filePath;
/**
 下载协议
 */
@property(nonatomic)id<OnlineServiceDownloadDelegate> downloadDelegate;

@end

//
//  DownLoadManager.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//


#import <Foundation/Foundation.h>

///下载状态回调。
@protocol DownloadState <NSObject>

/** 实时回调下载文件的Size和当前已经下载文件的Size。
 @param  dltotal 文件Size
 @param  dlnow 已经下载文件的Size。
 */
- (void)progressTotal:(double) dltotal Now:(double)dlnow;


///  下载结束。
- (void)downloaded;


/// 下载错误。

//和苹果废弃API 命名冲突。影响APP审核，修改下
- (void)downloaderror;
@end

 ///离线包数据下载管理器类。
@interface DownloadManager : NSObject {
    id<DownloadState> _downloadDelegate;
}

/// 下载离线包会触发进度回调事件。
@property(nonatomic,retain)id<DownloadState> downloadDelegate;

///获取离线包数据总大小。
@property(nonatomic,readonly)long dataSize;

///  获取已下载离线包数据大小。
@property(nonatomic,readonly)long downloadedDataSize;

/** 根据指定的离线包地址，以及指定的场景、图层名称读取图层文件信息。
 @param  url 离线包地址
 @param  sceneName 给定的场景名称。
 @param layerName 给定的图层名称
 @return  读取文件是否成功，成功返回 true，失败返回 false。
 */
- (BOOL)loadWithUrl:(NSString *)url SceneName:(NSString *) sceneName LayerName:(NSString *)layerName;

/** 根据指定的离线包地址，以及指定的场景名称读取符号等资源文件信息。
 @param  url 离线包地址
 @param  sceneName 给定的场景名称。
  @return  读取文件是否成功，成功返回 true，失败返回 false。
 */
- (BOOL)loadWithUrl:(NSString *)url SceneName:(NSString *) sceneName;


///下载离线包数据。
- (void)downloadData;


///停止下载离线包数据。
- (void)stopDownload;


/** 清除图层缓存
  @param  url 离线包地址
  @param  layerName 给定的图层名称
 */
+ (BOOL)clearCacheFileWithUrl:(NSString *)url LayerName:(NSString *)layerName;

/** 清除资源缓存
 @param  url 离线包地址
 */
+ (BOOL)clearCacheFileWithUrl:(NSString *)url;
@end

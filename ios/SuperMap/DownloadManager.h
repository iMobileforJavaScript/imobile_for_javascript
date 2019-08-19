//
//  DownLoadManager.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//


#import <Foundation/Foundation.h>



 ///离线包数据下载管理器类。
@interface DownloadManager : NSObject {
}

/** 根据指定的离线包地址，以及指定的场景、图层名称读取图层文件信息。
 @param  url 离线包地址
 @param  sceneName 给定的场景名称。
 @param layerName 给定的图层名称
 @return  读取文件是否成功，成功返回 true，失败返回 false。
 */
- (BOOL)loadWithUrl:(NSString *)url SceneName:(NSString *) sceneName LayerName:(NSString *)layerName;


///下载离线包数据。
- (void)downloadData;


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

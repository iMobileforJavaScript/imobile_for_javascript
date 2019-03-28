//
//  DataDownloadService.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import "ServiceBase.h"
#import "FeatureSet.h"
#import "Datasource.h"
@protocol DownLoadDelegate; 

/** 数据下载类，用于从iServer服务器上下载数据到本地。
 <p>  用户需要设置相应downLoadDelegate，通过设置该Delegate并重写相应回调函数getDownLoadData获取操作结果和服务器响应等。</P>
*/
@interface DataDownloadService : ServiceBase{
    @private
      id<DownLoadDelegate> _downLoadDelegate;
}


///数据下载时通知委托。
@property(nonatomic,retain)id<DownLoadDelegate> downLoadDelegate;

/**@brief 从iServer服务器上下载所有对象集合。
 @param  strUrl 数据服务地址。
 @param  serviceName 服务名称。
 @param  datasourceName 数据源名。
 @param  datasetName 数据集名。
 */
-(FeatureSet *)downloadAll:(NSString *)strUrl serviceName:(NSString *)serviceName dsName:(NSString *)datasourceName datasetName:(NSString *)datasetName;

/**@brief 从iServer服务器上下载对象集合。
 @param  strURL 数据服务地址。
 @param  serviceName 服务名称。
 @param  datasourceName 数据源名。
 @param  datasetName 数据集名。
 @param  fromIndex 起始下标。
 @param  toIndex 结束下标。
 */
-(FeatureSet *)download:(NSString *)strURL serviceName:(NSString *)serviceName datasourceName:(NSString *)datasourceName datasetName:(NSString *)datasetName fromIndex:(int)fromIndex toIndex:(int)toIndex;

/**@brief 获取指定的数据服务地址下对象集合。
 @param  fullUri 数据服务地址，如：http://192.168.120.139:8090/iserver/services/data-China400/rest/data/datasources/China400/datasets/City_R。
 @param  fromIndex 起始下标。
 @param  toIndex 结束下标。
 */
-(FeatureSet *)downLoadUrl:(NSString *)fullUri fromIndex:(int)fromIndex toIndex:(int)toIndex;

/**@brief 获取指定数据服务下所有对象集合。
 @param  fullUrl 数据服务地址， 如：http://192.168.120.139:8090/iserver/services/data-China400/rest/data/datasources/China400/datasets/City_R。
 */
-(FeatureSet *)downLoadUrlAll:(NSString *)fullUrl;

// 下载web端的iServer数据集到指定的本地数据源中，本地和web端的数据集信息完全一致。
// 数据集类型只支持点、线、面、属性数据集。
// 下载时web不存在同步属性表数据集的，给web端创建。同步属性表命名为 数据集名_Table
// 下载时本地存在同名数据集 或 同名属性表，则下载失败。保证本地不存在名称冲突的数据集
// 注意：web端数据集 和 下载的数据集 的结构和属性都不能修改，否则可能导致不可预测的后果
-(void)downloadDatasetFrom:(NSString*)urlDataset toDatasource:(Datasource*)dataSource;

// 更新web端数据集新增的Feature到对应的本地数据集中
// 优先更新 web端数据集的同步属性数据集 中的记录到本地的同步属性数据集，并根据相应记录删除本地需要删除的Feature
// 其次更新 web端数据集的新增Feature
// 注意：web端数据集 和 下载的数据集 的结构和属性都不能修改，否则可能导致不可预测的后果
-(void)updateDatasetFrom:(NSString*)urlDataset toDatasetVector:(DatasetVector*)dataset;

@end

 ///响应回调函数，在客户端与服务器交互过程中自动回调。

@protocol DownLoadDelegate <NSObject>
@optional
/** 收到服务器响应结果时回调。
* 当用户使用特定服务后，服务端返回的数据结果将以此回调返回。
 @param  result 从服务端返回的要素集合。
 @param  exception 服务端返回的异常信息，当服务请求成功时；exception为空，服务请求失败时，该参数存储服务端返回的异常信息。
 */
-(void)getDownLoadData:(FeatureSet *)result exception:(NSException *)exception;

-(void)downloadDatasetEndFrom:(NSString*)urlDataset toDatasource:(Datasource*)dataSource exception:(NSException*)exception returningResponse:(NSURLResponse *)response error:(NSError *)error;

-(void)updateDatasetEndFrom:(NSString*)urlDataset toDatasetVector:(DatasetVector*)dataset exception:(NSException*)exception returningResponse:(NSURLResponse *)response error:(NSError *)error;

@end

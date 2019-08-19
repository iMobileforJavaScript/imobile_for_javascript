//
//  DataUploadService.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import "ServiceBase.h"
#import "Feature.h"
#import "Recordset.h"
#import "DatasetType.h"

@protocol UploadDelegate;

/** 数据上传类，用于将本地数据上传到iServer服务器。
*  
* 用户需要设置相应UploadDelegate，通过设置该Delegate并重写相应回调函数upLoadStatus获取操作结果和服务器响应等。</p>
*/
@interface DataUploadService : ServiceBase{
    id<UploadDelegate> _uploadDelegate;
}

///数据上传时通知委托。
@property(nonatomic,retain)id<UploadDelegate> uploadDelegate;
/**
 * @brief 向iServer服务器中添加对象。
 * @param strUrl 数据服务地址。
 * @param serviceName 服务名称。
 * @param datasourceName 数据源名。
 * @param datasetName 数据集名。
 * @param feature 待添加对象。
 */
-(id)addFeature:(NSString *)strUrl serviceName:(NSString *)serviceName datasourceName:(NSString *)datasourceName datasetName:(NSString *)datasetName   feature:(Feature *)feature;

/**
 * @brief 向指定的数据服务地址添加对象。
 * @param fullUrl 指定的数据服务地址，如：http://192.168.120.139:8090/iserver/services/data-China400/rest/data/datasources/China400/datasets/City_R。
 * @param feature 待添加对象。
 */
-(id)addFeatureFullUrl:(NSString *)fullUrl feature:(Feature *)feature;

/**
 * @brief 根据指定的对象ID数组删除iServer服务器中的对象。
 * @param strUrl 数据服务地址。
 * @param serviceName 服务名称。
 * @param datasourceName 数据源名。
 * @param datasetName 数据集名。
 * @param featureIDs 对象ID数组。
 */
-(id)deleteFeature:(NSString *)strUrl serviceName:(NSString *)serviceName datasourceName:(NSString *)datasourceName datasetName:(NSString *)datasetName featureIDs:(NSMutableArray *)featureIDs;

/**
 * @brief 指定数据服务地址下的对象。
 * @param fullUrl 指定的数据服务地址，如：http://192.168.120.139:8090/iserver/services/data-China400/rest/data/datasources/China400/datasets/City_R。
 * @param featureIDs 对象ID数组。
 */
-(id)deleteFeatureFullUrl:(NSString *)fullUrl featureIDs:(NSMutableArray *)featureIDs;

/**
 * @brief 根据指定的资源定位符删除iServer服务器中的对象。
 * @param featureUrl 指定的资源定位符。
 */
-(id)deleteFeatureUrl:(NSString *)featureUrl;

/**
 * @brief 根据指定的ID修改对象。
 * @param strUrl 数据服务地址。
 * @param serviceName 服务名称。
 * @param datasourceName 数据源名。
 * @param datasetName 数据集名。
 * @param featureID 要修改的对象ID。
 * @param feature  结果对象。
 */
-(id)modifyFeature:(NSString *)strUrl serviceName:(NSString *)serviceName datasourceName:(NSString *)datasourceName datasetName:(NSString *)datasetName featureID:(int)featureID feature:(Feature *)feature;

/**
 * @brief 修改指定地址下的对象。
 * @param fullUrl 要修改的对象地址，如：http://192.168.120.139:8090/iserver/services/data-China400/rest/data/datasources/China400/datasets/City_R。
 * @param featureID 要修改的对象ID。
 * @param feature  修改的值。
 */
-(id)modifyFeatureFullUrl:(NSString *)fullUrl featureID:(int)featureID feature:(Feature *)feature;

/**
 * @brief 向指定服务指定数据源中的指定数据集中添加记录集。
 * @param strUrl 数据服务地址。
 * @param serviceName 服务名称。
 * @param datasourceName 数据源名。
 * @param datasetName 数据集名。
 * @param recordset 待添加的记录集。
 * @return 一个布尔值，指示记录集是否添加成功，添加成功则返回true,否则返回false。
 */
-(BOOL)addRecordSet:(NSString *)strUrl serviceName:(NSString *)serviceName datasourceName:(NSString *)datasourceName datasetName:(NSString *)datasetName recordSet:(Recordset *)recordset;

/**
 * @brief 向指定的数据地址下添加记录集。
 * @param fullUrl 指定的数据服务地址，如：http://192.168.120.139:8090/iserver/services/data-China400/rest/data/datasources/China400/datasets/City_R。
 * @param recordset 要添加的记录集。
 * @return 一个布尔值，指示记录集是否添加成功，添加成功返回true,否则返回false。
 */
-(BOOL)addRecordSetFullUrl:(NSString *)fullUrl recordset:(Recordset *)recordset;

/**
 * @brief 根据指定的数据集名称和数据类型添加数据集。
 * @param strUrl 数据服务地址。
 * @param serviceName 服务名称。
 * @param datasourceName 数据源名。
 * @param datasetName 数据集名。
 * @param type 数据类型。
 */
-(id)addDataset:(NSString *)strUrl serviceName:(NSString *)serviceName datasourceName:(NSString *)datasourceName datasetName:(NSString *)datasetName datasetType:(DatasetType)type;

/**
 * @brief 向指定的数据源添加数据集。
 * @param fullUrl 指定的数据服务地址，如：http://192.168.120.139:8090/iserver/services/data-China400/rest/data/datasources/China400。
 * @param datasetName 数据集名。
 * @param datasetType 数据类型。
 */
-(id)addDataset:(NSString *)fullUrl datasetName:(NSString *)datasetName datasetType:(DatasetType)datasetType;

/**
 * @brief 通过复制指定数据源中的指定数据集向服务中添加数据集。
 * @param strUrl 数据服务地址。
 * @param serviceName 服务名称。
 * @param datasourceName 数据源名。
 * @param destDatasetName 目标数据集名。
 * @param srcDatasourceName 源数据源名。
 * @param srcDatasetName 源数据集名。
 */
-(id)addDataset:(NSString *)strUrl serviceName:(NSString *)serviceName datasourceName:(NSString *)datasourceName destDatasetName:(NSString *)destDatasetName srcDatasourceName:(NSString *)srcDatasourceName srcDatasetName:(NSString *)srcDatasetName;

/**
 * @brief 删除数据集。
 * @param strUrl 数据服务地址。
 * @param serviceName 服务名称。
 * @param datasourceName 数据源名。
 * @param datasetName 数据集名。
 */
-(id)deleteDataset:(NSString *)strUrl serviceName:(NSString *)serviceName datasourceName:(NSString *)datasourceName datasetName:(NSString *)datasetName;

/**
 * 删除数据集。
 * @param fullUrl 要删除的数据集地址，，如：http://192.168.120.1:8090/iserver/services/data-world/rest/data/datasources/World/datasets/Lakes。
 */
-(id)deleteDataset:(NSString *)fullUrl;


// 提交本地数据集新增的Feature到对应的web端数据集中
// 优先提交 本地同步属性数据集 中的记录到web的同步属性数据集，并删除相应web端数据集的待删除记录
// 其次提交本地新增的Feature到web端数据集中
// 本地修改下载的Feature，会删除原有Feature，并把修改结果作为新增Feature
// 注意：web端数据集 和 下载的数据集 的结构和属性都不能修改，否则可能导致不可预测的后果
-(void)commitDatasetFrom:(DatasetVector*)dataset toDatasetURL:(NSString*)urlDataset;

@end

/**
* 响应回调函数，在客户端与服务器交互过程中自动回调。
*/
@protocol UploadDelegate <NSObject>

@optional
/** 收到服务器响应结果时回调。
*  
*  当用户使用特定服务后，服务端返回的数据结果将以此回调返回。
* @param resMsg  服务端返回的异常信息，当服务请求成功时，exception为空，服务请求失败时，该参数存储服务端返回的异常信息。
* @param result  上传成功信息。
*/
-(void)upLoadStatus:(NSString *)result exception:(NSException *)resMsg;

-(void)commitDatasetEndFrom:(DatasetVector*)dataset toDatasetURL:(NSString*)urlDataset exception:(NSException*)exception returningResponse:(NSURLResponse *)response error:(NSError *)error;

@end

//
//  QueryService.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "QueryMode.h"
#import "ServiceBase.h"
#define URL_HEARDER @"/queryResults.json?returnPostAction=true&getMethodForm=true&returnContent=true"
@protocol QueryServiceDelegate;
@class FeatureSet;
@class ServiceQueryParameter;

/** 查询服务类。
*  
* <p>用户需要设置相应queryServiceDelegate，通过设置该Delegate和重写相应的回调函数来获取操作结果和服务器响应等。</p>
*/
@interface QueryService : ServiceBase{
@private
    id<QueryServiceDelegate> _queryServiceDelegate;
}

/**
* 查询服务时通知委托。
*/
@property(nonatomic,retain)id<QueryServiceDelegate> queryServiceDelegate;

/** 
* @brief 对Rest服务进行查询。
* @param seviceParam 查询参数。
* @param queryMode 查询模式。
 */
-(FeatureSet*) queryWithServiceParam:(ServiceQueryParameter*)seviceParam QueryMode:(QueryMode)queryMode;

/** 
* @brief 根据指定的数据服务地址和服务名称查询地图集合。
* @param serviceURL 指定的数据服务地址。
* @param serviceName 服务名称。
* @return 根据指定的数据服务地址和服务名称查询到的地图集合。
 */
-(NSArray*) mapsOfServiceURL:(NSString*) serviceURL ServiceName:(NSString*) serviceName;

//-(BOOL) isContainMapServiceURL:(NSString*) serviceURL ServiceName:(NSString*) serviceName mapName:(NSString*) mapName;

/** 
* @brief 根据指定的数据服务地址、服务名称和地图名称查询图层集合。
* @param serviceURL 指定的数据服务地址。
* @param serviceName 服务名称。
* @param mapName 地图名称。
* @return 根据制定的数据服务地址、服务名称和地图名称查询到的图层集合。
 */
-(NSArray*) layersOfMapServiceURL:(NSString*) serviceURL ServiceName:(NSString*) serviceName mapName:(NSString*) mapName;

 //iServer查询是否存名为name的Layer

//-(BOOL) isContainLayerServiceURL:(NSString*) serviceURL ServiceName:(NSString*) serviceName mapName:(NSString*) mapName layerName:(NSString*) layerName;
@end

/**
*  响应回调函数，在客户端与服务器交互过程中自动回调。
*/
@protocol QueryServiceDelegate <NSObject>
@optional
/** 获取对Rest服务进行查询的查询结果。
* 
* @param queryResult 对Rest服务进行查询的查询结果。
* @param exception 服务端返回的异常信息，当服务请求成功时；exception为空，服务请求失败时，该参数存储服务端返回的异常信息。
 */
-(void)getQueryResult:(FeatureSet *)queryResult exception:(NSException *)exception;

/** 获取根据指定的数据服务地址和服务名称查询到的地图集合。
*  
* @param maps 根据指定的数据服务地址和服务名称查询到的地图集合。
* @param exception 服务端返回的异常信息，当服务请求成功时；exception为空，服务请求失败时，该参数存储服务端返回的异常信息。
 */
-(void)getMapsOfService:(NSArray *)maps exception:(NSException *)exception;

/** 获取根据指定的数据服务地址、服务名称和地图名称查询到的图层集合。
* 
* @param layers 根据指定的数据服务地址、服务名称和地图名称查询到的图层集合。
* @param exception 服务端返回的异常信息，当服务请求成功时；exception为空，服务请求失败时，该参数存储服务端返回的异常信息。
 */
-(void)getLayersOfService:(NSArray *)layers exception:(NSException *)exception;
@end

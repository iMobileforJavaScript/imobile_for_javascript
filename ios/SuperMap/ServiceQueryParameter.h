//
//  ServiceQueryParameter.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "QueryOption.h"
#import "QueryParameter.h"
@class Geometry;
//@class QueryParameter;


///iServer服务查询参数类。

@interface ServiceQueryParameter : QueryParameter{
    NSString * _mMapName;         // 要查询的地图名称
    NSString * _mServiceName;     // 要查询的rest服务名称
    NSString * _mServiceAddress;     // 要查询的rest服务地址
    NSString * _mQueryLayerName;  // 查询的图层名称
    int _mRecordStart;            // 记录其始位置
    int _mRecordCount;            // 期望返回的记录数
    Geometry * _m_pGeometry;      // 要查询的几何对象，在距离和空间查询中有效
    QueryOption _nqueryOption;    // 查询选项
    double _mDistance;            // 查询距离
}
/**
* @brief 获取或设置服务查询的地图的名称。
* @return 查询的地图的名称。
*/
@property(nonatomic,retain) NSString *mMapName;

/**
* @brief 获取或设置当前查询的服务的实例的服务名称。
* <p>默认值为Rest。</p>
* @return 实例的服务名称。
*/
@property(nonatomic,retain) NSString * mServiceName;

/**
* @brief 获取或设置当前查询的服务的实例的服务地址。
* @return 实例的服务地址，如：http://192.168.120.1:8090
*/
@property(nonatomic,retain) NSString * mServiceAddress;

/**
* @brief 获取或设置当前查询的图层的名称。
* @return 当前查询的图层的名称。
*/
@property(nonatomic,retain) NSString * mQueryLayerName;

/**
* @brief 获取或设置查询记录的起始位置。
* @return 查询记录的起始位置。
*/
@property(nonatomic) int mRecordStart;

/**
* @brief 获取或设置期望返回的查询记录个数。
* @return 期望返回的查询记录个数。
*/
@property(nonatomic) int mRecordCount;

/**
* @brief 获取或设置查询的几何对象。
* @return 几何对象。
*/
@property(nonatomic,copy) Geometry * m_pGeometry;

/**
* @brief 获取或设置查询结果内容类型。
* @return 查询结果内容类型。
*/
@property(nonatomic) QueryOption nqueryOption;

/**
* @brief 获取或设置查询的距离。
* @return 查询的距离值。
*/
@property(nonatomic) double mDistance;

/**
* @brief 将查询参数转换成 JSON 字符串。
* @return 查询参数转换成 的JSON 字符串。
*/
-(NSString*) toJson;

@end

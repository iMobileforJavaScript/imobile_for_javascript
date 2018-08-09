//
//  Datasources.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

@class Workspace,Datasource,DatasourceConnectionInfo,WebParams;
@class OnlineTileServer;
/**  数据源的集合类。
 * 
 * <p> 对数据源进行管理，包括创建、打开、关闭数据源等功能。
 * <p> 一个工作空间的所有数据源都由一个数据源集合对象来进行管理。该类可以同时管理多种类型的数据源，即在一个数据源集合对象中可以同时包括各种类型的数据源。实现了对数据源的无缝管理。
 */
@interface Datasources : NSObject{
@private
    Workspace* _workspace;
    
    NSMutableArray* _datasources;
    
    NSRecursiveLock* _lock;
    
    OnlineTileServer *m_onlineTileServer;
}

/**
* @brief 根据指定的连接信息创建数据源。
* <p> 如果待创建的数据源已经存在则返回 null。
* @param info  数据源连接信息。
* @return 新创建的数据源。
 */
-(Datasource*) create:(DatasourceConnectionInfo*) info;

/**
 * @brief 数据源集合中数据源的个数。
 * @return 数据源集合中数据源的个数。
 */
-(NSInteger) count;

/**
 * @brief  返回指定序号的数据源。
 * @param index 指定的数据源的序号。
* @return 指定序号的数据源。
 */
-(Datasource*) get:(NSInteger) index;

/**
 * @brief 指定别名的数据源。
 * @param alias 指定的数据源的别名。
 * @return 指定别名的数据源。
 */
-(Datasource*) getAlias:(NSString*) alias;

/**
 *@brief  指定别名的数据源对象在当前数据源集合中的序号。
 * @param alias 指定的数据源的别名。
 * @return 指定别名的数据源对象在当前数据源集合中的序号。如果数据源对象不存在，返回-1。
 */
-(NSInteger) indexOf:(NSString*) alias; 

/** 根据指定的连接信息打开已经存在的数据源。指定数据源不存在时返回Null。在打开数据源的时候需要注意的是，要明确数据源对应的数据引擎，才能正确的打开数据源。
 * <p> 1.当用户想打开某一个文件型数据源（UDBPlus）时，必须要有对应的空间数据库引擎（SDX+ for UDB）；
 * <p> 2.当用户打开 GoogleMaps 类型的数据源时，必须要有对应的空间数据库引擎（SDX+ for GoogleMaps）；
 * <p> 3.当用户打开超图云服务类型的数据源时，必须要有对应的空间数据库引擎（SDX+ for SuperMapCloud）；
 * <p> 4.当用户打开 REST 地图服务类型的数据源时，必须要有对应的空间数据库引擎（SDX+ for REST）；
  * <p> 5.当用户打开天地图服务类型的数据源时，必须要有对应的空间数据库引擎（SDX+ for MAPWORLD）；
 * @param info 指定的数据源连接信息。
 * @return 打开的数据源。
 */
-(Datasource*) open:(DatasourceConnectionInfo*) info;

/**
 * 打开数据源,通过Web服务参数打开
 */
-(Datasource*)open:(DatasourceConnectionInfo*)connectionInfo webParams:(WebParams*)params;
/**
 * @brief 关闭指定序号的数据源。
 * 
 * @param index 指定的数据源的序号。
 * @return 如果关闭数据源成功返回 true，否则返回 false。
 */
-(BOOL) close:(NSInteger) index;

/**
	 * @brief 关闭指定别名的数据源。
	 * 
	 * @param alias 指定的数据源的别名。
	 * @return 如果关闭数据源成功返回 true，否则返回 false。
	 */
-(BOOL) closeAlias:(NSString*) alias;

/**
	 *  @brief 关闭所有数据源。
	 */
-(void) closeAll;

@end

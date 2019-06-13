//
//  Layer3Ds.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "Layer3DType.h"
#import "ImageFormatType.h"

@class Layer3D;

/** 三维图层集合类。
 <p> 该类对一个三维场景中的所有三维图层进行管理。
 <p> 一个三维场景窗口对应一个三维场景，即一个三维场景窗口中只能显示一个三维场景，一个三维场景相应的有一个三维图层集合，由三维图层集合负责管理三维场景中显示的所有三维图层。
 <p> 三维图层集合类提供了三维图层的添加，删除，移动，查找等方法，可以实现向三维场景中添加各种类型的三维图层，将不需要显示在三维场景中的三维图层移除，查找三维场景中是否包含指定名称的三维图层以及调整三维场景中各个三维图层的叠放次序等。
 */
@interface Layer3Ds : NSObject

/**
 * @brief 向三维图层中集合中添加三维图层。
 *
 * @param dataName 数据名称。该参数对应 KML 图层所对应的数据全路径。
 * @param type 三维图层的类型。如果添加的数据名称与图层类型不匹配，则添加失败。
 * @param toHead 是否将新添加的三维图层加到最上面。
 * @param name 指定新添加的三维图层的名称，不区分大小写。如果图层名称已存在，则抛出异常。
 * @return 三维图层对象。
 */
- (Layer3D *)addLayerWith:(NSString *)dataName Type:(Layer3DType)type ToHead:(BOOL)toHead LayerName:(NSString *)name;

/**
 * @brief 通过iServer数据服务向三维图层集合中添加三维图层对象。
 *
 * @param URL iServer数据服务的URL。
 * @param type 三维图层类型。
 * @param dataLayerName 发布iServer数据时指定的三维图层名称。
 * @param toHead 是否将添加的三维图层置顶。
 * @return 返回添加的三维图层对象。
 */
- (Layer3D *)addLayerWithURL:(NSString *)iserverURL type:(Layer3DType)type dataLayerName:(NSString *)dataLayerName toHead:(BOOL)toHead;

/**
 * @brief 通过天地图数据服务向三维图层集合中添加三维图层对象。
 *
 * @param tiandituURL 天地图数据服务的URL。
 * @param type 三维图层类型。
 * @param dataLayerName 天地图数据指定的三维图层名称。
 * @param imageFormatType 图片格式
 * @param dpi 设备分辨率
 * @param toHead 是否将添加的三维图层置顶。
 * @return 返回添加的三维图层对象。
 */
- (Layer3D *)addLayerWithTiandituURL:(NSString *)tiandituURL type:(Layer3DType)type dataLayerName:(NSString *)dataLayerName imageFormatType:(ImageFormatType)imageFormatType dpi:(double)dpi toHead:(BOOL)toHead;

/**@brief 返回三维图层集合中指定索引的三维图层对象，三维图层集合中三维图层的索引从0开始编号。
 @param  index 要查找的三维图层对象的索引。
 @return  三维图层集合中指定索引的三维图层对象。
 */
- (Layer3D *)getLayerWithIndex:(NSInteger)index;

/**@brief 返回三维图层集合中指定名称的三维图层对象。
 @param  name 要查找的三维图层对象的名称。
 @return  三维图层集合中指定名称的三维图层对象。
 */
- (Layer3D *)getLayerWithName:(NSString *)name;

/**@brief 返回给定的三维图层集合中三维图层对象的总数。
 @return  给定的三维图层集合中三维图层对象的总数。
 */
- (NSInteger)count;

/**
 * @brief 仅用于 KML 图层,对应于 KML 图层的添加方法，用于从三维图层集合中删除一个指定索引的三维图层。
 *
 * @param index 要删除的三维图层的索引。
 * @return 删除成功则返回 true，否则返回 false。
 */
- (BOOL)removeLayerWithIndex:(NSInteger)index;

/**
 * @brief 仅用于 KML 图层,对应于 KML 图层的添加方法, 用于从三维图层集合中删除一个指定名称的三维图层，删除成功则返回 true。
 *
 * @param layerName 要删除的三维图层的名称。
 * @return 删除成功则返回 true，否则返回 false。
 */
- (BOOL)removeLayerWithName:(NSString *)layerName;

@end

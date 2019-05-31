//
//  TerrainLayers.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
@class TerrainLayer;
/**
 * @brief 三维地形图层集合类。
 */
@interface TerrainLayers : NSObject

/**
 * @brief 返回给定的三维地形图层集合中三维图地形层对象的总数。
 */
@property (nonatomic,readonly)NSInteger count;

/**
 * @brief 返回三维地形图层集合中指定索引的三维地形图层对象，三维地形图层集合中三维地形图层的索引从0开始编号。
 *
 * @param index 要查找的三维地形图层对象的索引。
 * @return 三维地形图层集合中指定索引的三维地形图层对象。
 */
- (TerrainLayer *)getLayerAtIndex:(NSInteger)index;

/**
 * @brief 返回三维地形图层集合中指定名称的三维地形图层对象。
 *
 * @param name 要查找的三维地形图层对象的名称。
 * @return 三维地形图层集合中指定名称的三维地形图层对象。
 */
- (TerrainLayer *)getLayerWithName:(NSString *)name;

/**
 * @brief 返回三维地形图层集合中指定名称的index。
 *
 * @param name 三维地形图层的名称。
 * @return 三维地形图层的index。
 */
- (NSInteger)indexOfName:(NSString *)name;

/**
 * @brief 三维地形图层集合是否包含指定名称的三维地形图层对象。
 *
 * @param name 三维地形图层的名称。
 * @return 包含则返回 YES，否则返回 NO。
 */
- (BOOL)contains:(NSString *)name;

/**
 * @brief 向三维地形图层中集合中添加三维地形图层。
 *
 * @param path 数据路径。该参数对应三维地形图层所对应的数据全路径。
 * @param toHead 是否将新添加的三维地形图层加到最上面。
 * @param name 指定新添加的三维地形图层的名称，不区分大小写。如果图层名称已存在，则抛出异常。
 * @param password 指定路径的大文件密码
 * @return 三维图层对象。
 */
- (TerrainLayer *)addLayerWithPath:(NSString *)path toHead:(BOOL)toHead name:(NSString *)name password:(NSString *)password;

/**
 * @brief 向三维地形图层中集合中添加在线三维地形图层。
 *
 * @param URL stk地形URL。该参数对应三维地形图层所对应的URL。
 * @return 三维图层对象。
 */
- (TerrainLayer *)addLayerWithURL:(NSString *)URL;

/**
 * @brief 从三维地形图层中集合中移除三维地形图层。
 *
 * @param index 要删除的三维地形图层的索引。
 * @return 删除成功则返回 YES，否则返回 NO。
 */
- (BOOL)removeLayerAtIndex:(NSInteger)index;

/**
 * @brief 从三维地形图层中集合中移除三维地形图层。
 *
 * @param layerName 要删除的三维地形图层的名称。
 * @return 删除成功则返回 YES，否则返回 NO。
 */
- (BOOL)removeLayerWithName:(NSString *)layerName;

/**
 * @brief 从三维地形图层中集合中移除所以三维地形图层。
 */
- (void)clear;

@end

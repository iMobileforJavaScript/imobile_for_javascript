//
//  Routes.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

@class Route;
 ///路线集合类。路线集合包含了零个或多个路线对象。 
@interface Routes : NSObject 

///获取或设置当前选中的路线，默认没有 Route 时为 -1，添加 Route 后则不再是非法值。
@property(nonatomic)NSInteger currentRouteIndex;

//  获取当前飞行路线
@property (strong, nonatomic, readonly) Route *currentRoute;

/// 获取路线集合中路线的个数。
@property(nonatomic,readonly)NSInteger count;

/**@brief 从指定的文件中导入路线集合对象。
 @param  filePath 指定的文件全路径。
 @return  导入成功返回 true，否则返回 false。
 */
- (BOOL)fromFile:(NSString *)filePath;

/**@brief 获取指定索引的路线的名字
 @param  index 路线索引。
 @return  返回路线名称
 */
- (NSString*)getRouteNameWithIndex:(NSInteger) index;

/**@brief 获取指定名字的路线的索引。
 @param  name 路线名字。
 @return  返回路线索引
 */
- (NSInteger)indexOfName:(NSString *)name;

/**@brief 获取指定索引的路线。
 @param  index 路线索引。
 @return  返回路线对象。
 */
- (Route *)routeAtIndex:(NSInteger)index;

/**@brief 设置路线的索引值。
 @param   index 路线索引, route 路线。
 */
- (void)setIndex:(NSInteger)index forRoute:(Route *)route;

/**@brief 获取指定名字的路线。
 @param  name 路线名称。
 @return  返回路线对象。
 */
- (Route *)routeWithName:(NSString *)name;

/**@brief 设置路线的名字。
 @param   name 路线名字, route 路线。
 */
- (void)setName:(NSString *)name forRoute:(Route *)route;

/**@brief 添加路线。
 @param  route 路线。
 @return  返回路线索引。
 */
- (NSInteger)addRoute:(Route *)route;

/**@brief 移除指定索引的路线。
 @param  index 路线索引。
 @return  移除成功返回 YES，否则返回 NO。
 */
- (BOOL)removeRouteAtIndex:(NSInteger)index;

/**@brief 移除指定名字的路线。
 @param  name 路线名字。
 @return  移除成功返回 YES，否则返回 NO。
 */
- (BOOL)removeRouteWithName:(NSString *)name;

/**@brief 确认是否包含指定名字的路线。
 @param  name 路线名字。
 @return  包含成功返回 YES，否则返回 NO。
 */
- (BOOL)containsRouteWithName:(NSString *)name;

/**@brief 将路线集合输出为XML字符串。
 @return  路线集合的XML字符串。
 */
- (NSString *)toXML;

/**@brief 通过XML字符串得到飞行路线集合。
 @param  xml XML字符串。
 @return  获取成功返回 YES，否则返回 NO。
 */
- (BOOL)fromXML:(NSString *)xml;

/**@brief 将路线集合输出为文件。
 @param  filePath 文件路径。
 */
- (void)toFile:(NSString *)filePath;

///清除路线集合中所有路线。
- (void)clear;

@end

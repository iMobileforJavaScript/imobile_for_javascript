//
//  RouteStops.h
//  LibUGC
//
//  Created by LK on 15/11/25.
//  Copyright © 2015年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RouteStop;
@interface RouteStops : NSObject

//  获取站点个数
@property (nonatomic, readonly, assign) NSInteger count;

//  设置或获取起始站点
@property (nonatomic, assign) NSInteger startIndex;

/* 初始化方法 */
- (instancetype)initWithRouteStops:(NSArray *)routeStops;

/**@brief 获取指定名字的站点的索引。
 @param  name 站点名字。
 @return  返回站点索引
 */
- (NSInteger)indexOfName:(NSString *)name;

/**@brief 获取指定索引的站点。
 @param  index 站点索引。
 @return  返回站点。
 */
- (RouteStop *)routeStopAtIndex:(NSInteger)index;

/**@brief 设置站点的索引值。
 @param   index 路线索引, routeStop 站点。
 */
- (void)setIndex:(NSInteger)index forRouteStop:(RouteStop *)routeStop;

/**@brief 获取指定名称的站点。
 @param  name 站点名称。
 @return  返回站点。
 */
- (RouteStop *)routeStopWithName:(NSString *)name;

/**@brief 设置站点的名字。
 @param   name 站点名字, routeStop 站点。
 */
- (void)setName:(NSString *)name forRouteStop:(RouteStop *)routeStop;

/**@brief 添加站点。
 @param  routeStop 站点。
 @return  返回站点索引。
 */
- (NSInteger)addRouteStop:(RouteStop *)routeStop;

/**@brief 插入站点。
 @param  routeStop 站点, index 索引。
 @return  成功返回YES, 否则返回NO。
 */
- (BOOL)insertRouteStop:(RouteStop *)routeStop atIndex:(NSInteger)index;

/**@brief 删除指定索引的站点。
 @param  index 索引。
 @return  成功返回YES, 否则返回NO。
 */
- (BOOL)removeRouteStopAtIndex:(NSInteger)index;

/**@brief 删除指定名称的站点。
 @param  name 名称。
 @return  成功返回YES, 否则返回NO。
 */
- (BOOL)removeRouteStopWithName:(NSString *)name;

/**@brief 清除站点集合。
 */
- (void)clear;

/**@brief 判断站点集合中是否包含指定名称。
 @param  name 名称。
 @return  包含返回YES, 否则返回NO。
 */
- (BOOL)containsRouteStopWithName:(NSString *)name;

@end

//
//  SupplyCenters.h
//  SourcesCode_Objects
//
//  Created by supermap on 2018/8/13.
//  Copyright © 2018年 supermap. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SupplyCenter;
@interface SupplyCenters : NSObject

-(id)initWithSupplyCenters:(SupplyCenters*)supplyCenters;

/**
 * 返回资源供给中心点的个数。
 *
 * @return 返回资源供给中心点的个数。
 */
-(int) getCount;

/**
 * 返回此资源供给中心集合对象中指定序号的资源供给中心对象。
 *
 * @return 返回指定序号的资源供给中心对象。
 */
-(SupplyCenter*) get:(int)index;
/**
 * 设置此资源供给中心集合对象中指定序号的资源供给中心对象。
 *
 * @param supplyCenter
 *            指定的序号。
 */
-(void)setIndex:(int)index supplyCenter:(SupplyCenter *)supplyCenter;
/**
 * 添加资源供给中心对象到此集合中，添加成功返回被添加对象的序号。
 *
 * @param supplyCenter
 *            待添加的资源供给中心对象。
 * @return 返回被添加对象的序号。
 */
-(int)addSupplyCenter:(SupplyCenter *)supplyCenter;
/**
 * 以数组形式向集合中添加资源供给中心对象，添加成功，返回添加的资源供给中心对象的个数。
 *
 * @param supplyCenters
 *            待添加的资源供给中心对象。
 * @return 返回添加资源供给中心对象的个数。
 */
-(int)addRange:(NSArray*)supplyCenters;

/**
 * 在资源供给中心集合中删除指定序号的资源供给中心对象。
 *
 * @param index
 *            指定的序号。
 * @return 删除成功返回 true，否则返回 false。
 */
-(BOOL)remove:(int)index;
/**
 * 在资源供给中心集合中从指定序号开始，删除指定个数的资源供给中心对象。
 *
 * @param index
 *            指定的序号。
 * @param count
 *            待删除的资源供给中心个数。
 * @return 返回被成功删除的对象的个数。
 */
-(BOOL)removeRange:(int)index count:(int)count;
/**
 * 清空集合中的资源供给中心对象。
 */
-(void)clear;
/**
 * 将资源供给中心集合对象转换为资源供给中心对象数组。
 *
 * @return 返回资源供给中心对象数组。
 */
-(NSMutableArray *)toArray;
@end

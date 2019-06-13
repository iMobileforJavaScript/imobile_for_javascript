//
//  Sightline.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "Point3D.h"


@class Scene;
/**三维分析类。
 <p>视线分析，即通视分析，根据观察者点位和目标点建立视线分析，在指定场景中，分析出结果。
 */
@interface Sightline : NSObject

// 获取视线分析中目标点的个数
@property(nonatomic,readonly)NSInteger pointCount;

// 获取或设置观察者位置属性
@property(nonatomic)Point3D viewerPosition;

/** 根据指定的Scene对象，构造一个新的Sightline对象
 @param  scene 指定的Scene对象
 @return  id Sightline对象
 */
- (id)initWith:(Scene*)scene;

/** 添加目标点
 @param  value 指定的目标点对象
 @return  指定目标点对象的索引号
 */
- (NSInteger)addTargetPoint:(Point3D)value;

/** 根据指定索引号，返回指定的目标点对象
 @param  index 指定的索引号
 @return  指定的目标点对象
 */
- (Point3D)targetPointOfIndex:(NSInteger)index;

/** 设置指定索引的目标点 在指定的索引位置，添加目标点
 @param  point 指定的目标点对象
 @param  index 指定的索引号
 */
- (void)setTargetPoint:(Point3D)point forIndex:(NSInteger)index;

/** 移除指定索引的目标点
 @param  index 指定的索引号
 @return  移除成功，返回YES，否则为NO
 */
- (BOOL)removeTargetPointofIndex:(NSInteger)index;

// 移除所有目标点
- (void)removeAllTargetPoints;

// 执行视线分析
- (BOOL)build;

// 清除分析结果
- (void)clearResult;
@end

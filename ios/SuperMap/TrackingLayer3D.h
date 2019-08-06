//
//  TrackingLayer3D.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>


@class Geometry,Point2D;
/**三维跟踪图层类
 <p>三维跟踪图层的作用与二维跟踪图层相似，每个场景窗口都有一个跟踪图层，确切地说，每个场景显示时都有一个跟踪图层。跟踪图层是一个空白的透明图层，总是在地图各图层的最上层，主要用于在一个处理或分析过程中，临时存放一些图形对象，以及一些文本等。只要场景显示，跟踪图层就会存在，你不可以删除跟踪图层，也不可以改变其位置。三维跟踪图层除了支持二维对象的添加，还支持三维点、线、面、模型对象的添加。
 */
@interface TrackingLayer3D : NSObject

/// 返回三维跟踪图层中几何事件对象的个数
@property(nonatomic,readonly)NSInteger count;

/// 三维跟踪图层是否可见
@property(nonatomic) BOOL visible;

/** 
 * @brief 向三维跟踪图层中添加几何事件对象
 * @param geometry 要添加的几何对象
 * @param tag 要添加的几何对象的标签
 * @return index 待添加的几何对象的索引
 */
- (NSInteger)AddGeometry:(Geometry *)geometry Tag:(NSString *)tag;

/**
 * @brief 从三维跟踪图层中删除几何事件对象
 * @param index 几何对象的索引
 * @return BOOL 删除结果
 */
- (BOOL)removeWithIndex:(NSInteger)index;

/**
 * @brief 返回三维跟踪图层中指定索引的几何对象
 * @param index 几何对象的索引
 * @return Geometry 返回的几何对象
 */
- (Geometry *)getWithIndex:(NSInteger)index;

/**
 * @brief 将三维跟踪图层中的指定索引对应的几何对象替换为指定的几何对象，若此索引已有对应的几何对象，则会删除该几何对象，替换为指定的新几何对象。
 * @param index 几何对象的索引
 * @param Geometry 几何对象
 * @return BOOL 设置结果
 */
- (BOOL)setGeometry:(Geometry *)geometry Index:(NSInteger)index;

/**
 * @brief 获取三维跟踪图层中指定序号的几何事件对象的标签
 * @param index 几何对象的索引
 * @return tag 几何对象的标签
 */
- (NSString *)getTagWithIndex:(NSInteger)index;

/**
 * @brief 设置三维跟踪图层中指定索引的几何对象的标签
 * @param index 几何对象的索引
 * @return tag 几何对象的标签
 */
- (BOOL)setTag:(NSString *)tag forIndex:(NSInteger)index;
/**
 * @brief 返回选中的屏幕像素点所对应的三维几何对象的 ID
 * @param point 屏幕像素点
 * @return NSInteger 几何对象的标签
 */
- (NSInteger)hitTest:(Point2D *)point;

/**
 * @brief清空三维跟踪图层中的几何事件对象
 */
- (void)clear;
@end

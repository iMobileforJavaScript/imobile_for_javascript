//
//  Layer3DOSGBFile.h
//  LibUGC
//
//  Created by LK on 16/1/12.
//  Copyright © 2016年 beijingchaotu. All rights reserved.
//

#import "Layer3D.h"

@class GeoStyle3D, Color, Geometry, HypsometricSetting;
@interface Layer3DOSGBFile : Layer3D

/*
 ** 设置、获得切换的缩放系数
 */
@property (assign, nonatomic) double lodRangeScale;

/*
 ** 获取或设置图层的风格
 */
@property (strong, nonatomic) GeoStyle3D *style;

/*
** 获取当前场景的压平区域个数
*/
@property (assign, nonatomic, readonly) NSInteger flattenRegionCount;

/*
 ** 返回三维OSGB图层的属性字段信息集合对象。
 */
@property (nonatomic,readonly) FieldInfos *fieldInfos;

/*
 ** 获取或设置分层设色对象
 */
@property (strong, nonatomic) HypsometricSetting *hypsometricSetting;

- (instancetype)initWithLayer3D:(Layer3D *)layer3D;
+ (Layer3DOSGBFile *)layer3DOSGBFileWithLayer3D:(Layer3D *)layer3D;

/*
 ** 根据BIM模型(FBX)ID队列指定是否可见
 */
- (void)makeObjectsVisibleWithIndexs:(NSArray *)indexs visible:(BOOL)visible;

- (void)makeOnlyObjectsVisibleWithIndexs:(NSArray *)indexs visible:(BOOL)visible;

/*
** 设置、获取、重置或清除对象的颜色
*/
- (void)colorObjectsWithIndexs:(NSArray *)indexs color:(Color *)color;
- (NSDictionary *)objectsColor;
- (void)resetObjectsColorWithIndexs:(NSArray *)indexs;
- (void)clearObjectsColor;

/*
** 添加压平区域来压平当前的osgb模型
*/
- (NSInteger)addFlattenRegionWithGeometry:(Geometry *)geometry tag:(NSString *)tag;

/*
** 清除所有压平区域，恢复osgb模型初始状态
*/
- (void)clearFlattenRegions;

/*
** 获取指定索引的压平区域对象
*/
- (Geometry *)getFlattenRegionAtIndex:(NSInteger)index;

/*
** 获取指定索引值的压平区域的标签
*/
- (NSString *)getFlattenRegionTagAtIndex:(NSInteger)index;

/*
** 设置指定索引值的压平区域的标签
*/
- (BOOL)setFlattenRegionAtIndex:(NSInteger)index tag:(NSString *)tag;

/*
** 获取指定标签的压平区域的索引值
*/
- (NSInteger)indexOfFlattenRegionTag:(NSString *)tag;

/*
** 移除指定索引值的压平区域
*/
- (BOOL)removeFlattenRegionAtIndex:(NSInteger)index;

/*
** 获取ID获取属性值
*/
- (id)fieldValueOfSelectedObjectWithIndex:(NSInteger)index;

/*
** 获取最后一个选中的对象的所有属性
*/
- (NSArray *)allFieldValuesOfLastSelectedObject;

//获取多数据集属性信息接口
-(NSMutableArray *)getDatasetInfos:(NSMutableArray *)startid Endid:(NSMutableArray *)endid;


@end

//
//  GeoText3D.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import "Geometry3D.h"


@class TextPart3D,TextStyle;
/**三维文本几何对象类
 <p>该类提供了三维文本几何对象的编辑信息，可以通过设置此类来对三维文本几何对象以及其子对象进行编辑操作
 */
@interface GeoText3D : Geometry3D

/// 获取三维文本几何对象的子对象个数
@property(nonatomic,readonly)NSInteger partCount;

/// 获取三维文本几何对象的文本字符串。如果该三维文本几何对象有子对象，则其值为子对象的字符串之和
@property(nonatomic,readonly)NSString* text;

/// 获取或设置三维文本几何对象的文本风格。文本风格用于指定文本对象显示时的透明度、缩放比、固定大小、高度和颜色，目前不支持字体
@property(nonatomic)TextStyle* textStyle;
/** 构造一个新的 GeoText3D 对象
 @param  region3D 根据给定的 GeoText3D 对象来构造一个与其完全相同的新对象
 @return  GeoText3D对象
 */
- (id)init;

/** 根据指定的参数来构造一个 GeoText3D 的新对象
 @param geoText3D 指定的三维文本几何对象
 @return  GeoText3D对象
 */
- (id)initWithGeoText3D:(GeoText3D*)geoText3D;

/** 根据指定的参数来构造一个 GeoText3D 的新对象
 @param  part 指定的子对象
 @return  GeoText3D对象
 */
- (id)initWithTextPart3D:(TextPart3D*)part;

/** 根据指定的参数来构造一个 GeoText3D 的新对象
 @param  part 指定的子对象
 @param  style 给定的文本风格
 @return  GeoText3D对象
 */
- (id)initWithTextPart3D:(TextPart3D*)part style:(TextStyle*)style;

/** 在三维文本几何对象中添加子对象
 @param  part 指定的子对象
 @return  子对象的索引号
 */
- (NSInteger)addPart:(TextPart3D*)part;

/** 获取指定子对象在在此三维文本几何对象中的索引
 @param  part 指定的子对象
 @return  子对象的索引号
 */
- (NSInteger)indexOfPart:(TextPart3D*)part;
 
/** 获取指定索引在此三维文本几何对象中的子对象。
 @param  index 指定的索引号
 @return  指定索引号的子对象
 */
- (TextPart3D*)partOfIndex:(NSInteger)index;

/** 在三维文本几何对象的指定位置插入一个子对象
 @param  part 指定的子对象
 @param  index 插入的位置，即子对象的索引值
 @return  插入成功返回YES，否则返回NO
 */
- (BOOL)insertPart:(TextPart3D*)part forIndex:(NSInteger)index;

/** 在三维文本几何对象的指定位置替换一个子对象
 @param  part 指定的子对象
 @param  index 替换的位置
 @return  替换成功返回YES，否则返回NO
 */
- (BOOL)setPart:(TextPart3D*)part forIndex:(NSInteger)index;

/** 移除指定索引位置的几何子对象
 @param  index 替换的位置
 @return  替换成功返回YES，否则返回NO
 */
- (BOOL)removePartForIndex:(NSInteger)index;

/// 返回当前对象的一个拷贝
/** 返回当前对象的一个拷贝
 @return  当前GeoStyle3D对象的一个拷贝。
 */
- (GeoText3D*)clone;
@end

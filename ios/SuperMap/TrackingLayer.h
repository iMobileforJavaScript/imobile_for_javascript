//
//  TrackingLayer.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
@class TextStyle;
@class FieldInfo,FieldInfos;
@class Map,Geometry,Point2D;

/** 跟踪图层类。
 *  
 * <p>在 SuperMap 中，每个地图窗口都有一个跟踪图层，确切地说，每个地图显示时都有一个跟踪图层。
 * 跟踪图层是一个空白的透明图层，总是在地图各图层的最上层，主要用于在一个处理或分析过程中，临时存放一些图形对象，以及一些文本等。
 * 只要地图显示，跟踪图层就会存在，不可以删除跟踪图层，也不可以改变其位置。</p>
 * <p>在 SuperMap iMobile中跟踪图层的作用主要有以下方面：</p>
 * 1. 当不想往记录集中添加几何对象，而又需要这个几何对象的时候，就可以把这个几何对象临时添加到跟踪图层上，用完该几何对象之后清除跟踪图层即可。例如，当需要测量距离时，需要在地图上拉一条线，但是这一条线在地图上并不存在，此时就可以使用跟踪图层来实现。
 * 2. 当需要对目标进行动态跟踪的时候，如果把目标放到记录集中，要实现动态跟踪就得不断地刷新整个图层，这样会大大影响效率，如果将这个需要进行跟踪地目标放到跟踪层上，这样就只需要刷新跟踪图层即可实现动态跟踪。
 * 3. 当需要进行批量地往记录集中添加几何对象的时候，可以先将这些对象临时放在跟踪图层上，确定需要添加之后再把跟踪图层上的几何对象批量地添加到记录集中。
 *  <p> <b>注意 ：<b> <p>
 * <p>请注意避免把跟踪图层作为存储大量临时几何对象的容器，如果有大量的临时数据，建议在本地计算机临时目录下（如：c:\\temp）创建临时数据源，并在临时数据源中创建相应的临时数据集来保存临时数据。</p>
 * <p>可以对跟踪图层进行控制，包括控制跟踪图层是否可显示以及符号是否随图缩放。跟普通图层不同的是，跟踪图层中的对象是不保存的，只是在地图显示时，临时存在内存中。当地图关闭后，跟踪图层中的对象依然存在，相应内存释放掉才会消失，当地图再次被打开后，跟踪图层又显示为一个空白而且透明的图层。</p>
 * <p>该类提供了对跟踪图层上的几何对象进行添加，删除等管理的方法。并且可以通过设置标签的方式对跟踪图层上的几何对象进行分类，可以将标签理解为对几何对象的描述，相同用途的几何对象可以具有相同的标签。</p>
 */
@interface TrackingLayer : NSObject{
    @private
    Map *_map;
}

 /**
     * @brief  返回当前跟踪图层的几何对象的个数。
     * <p> 默认值为 0。
     * @return 当前跟踪图层的几何对象的个数。
     */
@property(nonatomic,readonly)int count;

/**
     * @brief  获取或设置此跟踪图层是否可见。
     * <p>   true 表示此跟踪图层可见，false 表示此跟踪图层不可见。当此跟踪图层不可见时，其他的设置都将无效。
    * <p>   默认值为 true。
     * @return 一个布尔值指示此图层是否可见。
     */
@property(nonatomic)BOOL visible;

 /**
     * @brief 返回跟踪图层的符号大小是否随图缩放。
     * <p>   true 表示当随着地图的缩放而缩放，在地图放大的同时，符号同时也放大。
       * <p>   默认值为 false。
     * @return 一个布尔值指示跟踪图层的符号大小是否随图缩放。
     */
-(BOOL)isSymbolScalable;

 /**
     * @brief 向当前跟踪图层中添加一个几何对象，并给出该几何对象的标签信息。
     * @param geometry 要添加的几何对象。
     * @param tag 要添加的几何对象的标签信息。
     * @return 添加到跟踪图层的几何对象的索引，即该几何对象的ID。
     */
-(int)addGeometry:(Geometry *)geometry WithTag:(NSString *)tag;

 /**
     * @brief 在当前跟踪图层中删除指定ID的几何对象。
     * @param index 要删除的几何对象的ID。
     * @return 删除成功返回 true；否则返回 false。
     */
-(BOOL)removeAt:(int)index;

/**
     * @brief 返回此跟踪图层中指定索引的几何对象。
     * @param index 要返回的几何对象的ID。
     * @return 指定ID的几何对象。
     */
-(Geometry *)getAt:(int)index;

/**
     * @brief 将跟踪图层中的指定的索引处的几何对象替换为指定的几何对象，若此索引处原先有其他几何对象，则会被删除。
     * @param geometry 用来替换的新 {@link Geometry Geometry} 对象。
     * @param index 要替换几何对象的索引。
     * @return 替换成功返回 true；否则返回 false。
     */
-(BOOL)setGeometry:(Geometry *)geometry At:(int)index;

 /**
     * @brief 返回此跟踪图层中指定ID的几何对象的标签信息。
     * @param index 要返回标签的几何对象的索引。
     * @return 此跟踪图层中指定索引的几何对象的标签。
     */
-(NSString *)getTagAt:(int)index;

/**
     * @brief 设置此跟踪图层中指定ID的几何对象的标签信息。
     * @param tag 几何对象的新标签信息。
    * @param index 要设置标签的几何对象的索引。
     * @return 设置成功返回 true；否则返回 false。
     */
-(BOOL)setTag:(NSString *)tag At:(int)index;

/**
     * @brief 返回第一个与指定标签信息相同的几何对象的ID。
     * @param tag 需要进行索引检查的标签信息。
     * @return 第一个与指定标签信息相同的几何对象的ID。
     */
-(int)indexof:(NSString *)tag;

/**
     *@brief  清空此跟踪图层中的所有几何对象。
     */
-(void)clear;

 /**
     * @brief 返回满足条件的几何对象的 ID。
     * <p> 若指定的点与几何对象上最近点的距离是在指定容限范围的范围内，则该几何对象的 ID 被返回。
     * <p>  如果跟踪图层中没有符合条件的几何对象，则返回 -1；
     * <p>  如果地图上有多个重叠的几何对象都满足条件，则返回最上面的几何对象的 ID。
     * @param point 要测试的点，为地理坐标点。
     * @param tolerance 指定的容限，为地理长度。
     * @return 几何对象的 ID号。
     */
-(int)hitTest:(Point2D *)point Tolerance:(double)tolerance;

 /**
     * @brief  在当前跟踪图层中开启批量更新。
     * @param isEditBuck 布尔值，true为开启，false为不开启。
     * @return isEditBuck 的值为true时则返回 true；否则返回 false。
     */
- (void)setEditBuck:(BOOL)isEditBuck;

/**
     * @brief  对跟踪图层进行批量更新。
     */	
- (void)flushBuck;

//! \brief 添加字段的显示风格
//! \detail 每一个风格对应一个显示字段
//! \param tag 对应的字段名称
//! \param style 文本风格
//! \param visible 是否可见
//! \param tail true是加到末尾，false是加到开头
-(BOOL) addLabel:(NSString *)tag textStyle:(TextStyle *)textStyle visible:(BOOL)visible tail:(BOOL)tail;
//! \brief 创建double型字段
-(BOOL) createUserFieldDouble:(NSString *)fieldName size:(int)size attribute:(int)attribute;
//! \brief 创建int型字段
-(BOOL) createUserFieldInt:(NSString *)fieldName size:(int)size attribute:(int)attribute;
//! \brief 创建string型字段
-(BOOL) createUserFieldString:(NSString *)fieldName size:(int)size attribute:(int)attribute;
//! \brief 删除所有对象(保留表结构)
-(void) deleteAllFeatures;
//! \brief 删除指定字段
-(BOOL) deleteUserField:(NSString *)fieldName;
//! \brief 获取GeoEvent
//! \param tag 几何对象的标签名称[in]
//! \return 返回几何对象的ID
-(int) getEvent:(NSString *)tag ;
-(double) getFieldDouble:(int)index fieldName:(NSString *)fieldName;
-(FieldInfo *) getFieldInfo:(NSString *)fieldName ;
//! \brief 获取字段信息
-(FieldInfos *) getFieldInfos;
-(int) getFieldInt:(int)index fieldName:(NSString *)fieldName ;
//! \brief 获取字段名
-(NSString *) getFieldName:(int)index;
-(NSString *) getFieldString:(int)index fieldName:(NSString *)fieldName;
//! \biref 将指定标签移动到底部
-(BOOL) labelMoveBottom:(NSString *)tag ;
//! \biref 将指定标签的显示下移
-(BOOL) labelMoveDown:(NSString *)tag ;
//! \biref 将指定标签移动到顶部
-(BOOL) labelMoveTop:(NSString *)tag ;
//! \biref 将指定标签上移
-(BOOL) labelMoveUp:(NSString *)tag ;
//! \brief 移除字段的显示风格
//! \param 字段名
-(BOOL) removeLabel:(NSString *)fieldName;
//! \brief 设置double类型的值
-(BOOL) setFieldDouble:(NSString *)fieldName fieldValue:(double)fieldValue;
//! \brief 设置指定记录指定字段的double类型的值
-(BOOL) setFieldDoubleEx:(NSString *)fieldName fieldValue:(double)fieldValue index:(int)index;
//! \brief 设置int类型的值
-(BOOL) setFieldInt:(NSString *)fieldName fieldValue:(int)fieldValue;
//! \brief 设置指定记录指定字段的int类型的值
-(BOOL) setFieldIntEx:(NSString *)fieldName fieldValue:(int)fieldValue index:(int)index;
//! \brief 设置string类型的值
-(BOOL) setFieldString:(NSString *)fieldName fieldValue:(NSString *)fieldValue;
//! \brief 设置指定记录指定字段的string类型的值
-(BOOL) setFieldStringEx:(NSString *)fieldName fieldValue:(NSString *)fieldValue index:(int)index;
//! \brief  设置标签对应的字段
//! \param tag 目前对应的字段
//! \param Caption 修改后的字段
-(BOOL) setLabelCaption:(NSString *)tag caption:(NSString *)caption;
//! \brief 设置字段文本的偏移
//! \param tag 字段名
//! \param x x方向偏移
//! \param y y方向偏移
-(BOOL) setLabelOffset:(NSString *)tag x:(short)x y:(short)y;
//! \brief 设置标签的文本风格
//! \brief style 文本风格
-(BOOL) setLabelTextStyle:(NSString *)tag textStyle:(TextStyle *)textStyle;
//! \brief 设置风格是否可见
//! \param tag 字段名
//! \param visible 是否可见
-(BOOL) setLabelVisible:(NSString *)tag visible:(BOOL)visible;
//! \brief 设置符号偏移
//! \param x x方向偏移
//! \param y y方向偏移
-(void) setSymbolOffset:(short)x y:(short) y;
// end
@end

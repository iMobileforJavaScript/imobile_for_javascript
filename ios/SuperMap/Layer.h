//
//  Layer.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import "ThemeType.h"
#import <CoreGraphics/CGGeometry.h>
@class Map,Layers,Selection,Dataset,Theme,GeoRegion,m_selfEventHandle,Point2D,QueryParameter,LayerGroup;
@class ChartView;
@protocol LayerSetting;
@protocol LayerStateDelegate;
/**  图层类。
 * 
  *  <p>该l类提供了图层显示和控制等的便于地图管理的一系列方法。当数据集被加载到地图窗口中显示的时，就形成了一个图层，因此图层是数据集的可视化显示。一个图层是对一个数据集的引用或参考。通过对可视化的图层的编辑，可以对
  *  相应的数据集的要素进行编辑。一个图层或多个图层叠加显示则形成了地图。图层分为普通图层和专题图层，矢量的普通图层中所有要素采用相同的渲染风格，栅格图层采用颜色表来显示其像元；而专题图层则采用指定类型的专题图风格来渲染其中的
  *  要素或像元。</p>
  *  <p>该类的实例不可被创建，只可以通过在 <Layers Layers> 类中的   add 方法来创建。</p>
  */
@interface Layer : NSObject
   

/**
     * @brief 获取图层的名称。
     * <p> 图层的名称在图层所在的地图中唯一标识此图层。该标识不区分大小写。
     * @return 图层的名称。
     */
@property(nonatomic,copy,readonly)NSString *name; 

@property(nonatomic,assign)id<LayerStateDelegate>layerDelegate;

/**
 * @brief 设置,获取 图层卷帘模式
 */
@property(nonatomic)BOOL isSwipe;
/**
     * @brief 获取或设置图层的标题。
     * <p> 图层的标题为图层的显示名称，例如在图例或排版制图时显示的图层的名称即为图层的标题。注意与图层的名称相区别。
     * @return 图层的标题。
     */
@property(nonatomic,copy)NSString *caption;

/**
     * @brief 获取或设置此图层的描述信息。
     * @return 此图层的描述信息。
     */
@property(nonatomic,copy)NSString *description;

/**
     * @brief 获取或设置图层的符号大小是否随图缩放。
     * @return 一个布尔值，指示图层的符号大小是否随图缩放，true,表示图层的符号大小随图缩放，false,表示不随图缩放。
     */
@property(nonatomic)BOOL symbolScalable;

/**
     * @brief 获取或设置此图层是否可见。true 表示此图层可见，false 表示图层不可见。当图层不可见时，其他所有的属性的设置将无效。
     * @return 图层是否可见。
     */
@property(nonatomic)BOOL visible;

/**
     *  @brief 获取或设置图层中对象是否可以选择。
     * <p>当需要对图层进行一些选择或查询时，需要将图层设置为可选择。当图层为可选择状态时，可以选择感兴趣的要素，查询其相关属性及统计信息等。</p>
     * @return 一个布尔值，指示图层中对象是否可以选择，true 表示此图层中的对象可被选择，false 表示此图层中对象不可选。
     */
@property(nonatomic)BOOL selectable;

/**
     * @brief 获取或设置图层是否处于可编辑状态。该方法控制是否对图层所引用的数据进行修改。
     * <p>当图层为可编辑时，意味着可以对图层所引用的数据进行修改和编辑，通过图层，可以对数据进行可视化的编辑。当你只希望对图层所引用的数据进行渲染或相关分析操作而不希望影响原数据时，建议将图层设置为不可编辑，以免不经意的操作修改了数据。
     * @return 图层是可编辑状态，返回true；否则返回false。
     */
@property(nonatomic)BOOL editable;

/**
     * @brief 获取或设置此图层的最大可见比例尺。
     *  <p>最大可见比例尺不可为负，当地图的当前显示比例尺大于或等于图层最大可见比例尺时，此图层将不显示。
     * @return 图层的最大可见比例尺。
     */
@property(nonatomic)double maxVisibleScale;

 /**
     *@brief  获取或设置此图层的最小可见比例尺。
     *  <p> 最小可见比例尺不可为负。当地图的当前显示比例尺小于图层最小可见比例尺时，此图层将不显示。
     * @return 图层的最小可见比例尺。
     */
@property(nonatomic)double minVisibleScale;

  /**
     * @brief 设置此图层对应的数据集对象。
     * <p> 图层是对数据集的引用，因而，一个图层与一个数据集相对应。
    * <p>当该方法设置为 null 时，抛出异常。</p>
    * @param dataset 此图层对应的数据集对象。
     */
@property(nonatomic,readonly)Dataset* dataset;

/**
     * @brief  设置普通图层的风格。
     * <p> 普通图层风格的设置对矢量数据图层、栅格数据图层以及影像数据图层是不相同的。 LayerSettingVector 类用来对矢量数据图层的风格进行设置和修改。
     */
@property(nonatomic)id<LayerSetting> layerSetting;


/**
 * @brief  获取当前专题图类
 * <p> 只读
 */
@property(nonatomic,readonly)Theme* theme;

/**
 * 设置,获取图层是否可捕捉。True 表示该图层可捕捉，False 表示该图层不可捕捉。
 *
 * @param value
 *            boolean
 */
@property(nonatomic)BOOL isSnapable;

/**
 *  @brief  获取/设置 图层所在分组。
 */
@property(nonatomic,strong)LayerGroup* parentGroup;

/**
 * 设置图层不透明度
 * @param value 不透明度   取值为0-100
 */
-(void)setOpaqueRate:(int)value;
    
/**
     *  @brief  获取此图层中的选择集对象。
     *  <p>  选择集是个集合，其中包含选择的图层中的一个或多个要素。在选择集中的要素才可以被编辑。注意选择集只适用于矢量数据集，栅格数据集和影像数据集没有选择集。
     * @return 此图层中的选择集对象。
 */
-(Selection *)getSelection;

 /**
     *  @brief  设置此图层中的选择集对象。
     *  <p>  选择集是个集合，其中包含选择的图层中的一个或多个要素。在选择集中的要素才可以被编辑。注意选择集只适用于矢量数据集，栅格数据集和影像数据集没有选择集。
     * @param selection 指定图层中的选择集对象。
    */
-(void)setSelection:(Selection *)selection;

//添加图表对象(饼图，折线，柱状图，仪表图)
-(void)addChart:(ChartView*)chart;
/**
 *  @brief  设置显示过滤条件，可以使图层中的一些要素显示，而另一些要素不显示，以便重点分析感兴趣的要素，而过滤掉其他要素。

 *  <p>QueryParameter 查询参数类,用于描述一个条件查询的限制条件,只对QueryParameter中的AttributeFilter、JoinItems、LinkItems起效果。
 * @param queryParameter 指定QueryParameter对象。
 */
-(void)setDisplayFilter:(QueryParameter*) queryParameter;

/**
 *  @brief  获取此图层中获取图层显示过滤条件。
 *  <p>  QueryParameter 查询参数类,用于描述一个条件查询的限制条件,只对QueryParameter中的AttributeFilter、JoinItems、LinkItems起效果。
 * @return 此图层中QueryParameter对象。
 */
-(QueryParameter*) getDisplayFilter;
/**
 * @brief 返回选中的对象的集合。
 *  <p>  若指定的点与对象上最近点的距离在指定容限范围的范围内，则该对象被选中。如果地图上有多个重叠的对象都满足条件，则都被选中，并返回多个对象。
 * @param point 要测试的点，为地理坐标点。
 * @param tolerance 指定的容限，为地理长度。
 * @return 被选中的对象的集合。
 */
-(Selection *)hitTest:(Point2D *)point With:(double)tolerance;

/**
 * @brief 返回选中的对象的集合。
 *  <p>  若指定的点与对象上最近点的距离在指定容限范围的范围内，则该对象被选中。如果地图上有多个重叠的对象都满足条件，则都被选中，并返回多个对象。
 * @param point 要测试的点，为屏幕点。
 * @param tolerance 指定的容限，为屏幕坐标点。
 * @return 被选中的对象的集合。
 */
-(Selection *)hitTestEx:(CGPoint)point With:(double)tolerance;

/**
     * @brief  返回指定的比例尺是否为可视比例尺，即在设定的最小显示比例尺和最大显示比例尺之间。
     * @param scale 指定的显示比例尺。
     * @return  指定的比例尺为可视比例尺则返回true；否则为 false。
 */
-(BOOL)isVisibleScale:(double)scale;

/**
     * @brief 返回对象是否已被释放。若为 true时，操作该类的其他方法，都会抛出异常，意味着对象已被释放。
     * @return 对象已经被释放，返回 true；否则返回 false。
 */
-(BOOL)isDiaposed;

-(void)removeCache;
@end

@protocol LayerStateDelegate <NSObject>

/**  添加新图层时回调。
 *
 * @param  layerAdded 添加的新图层。
 */
-(void) layerAdded:(Layer*) layerAdded index:(int)index;

/** 移除图层前回调。
 *
 * @param  layerRemove 被移除的图层。
 */
-(void) layerRemoving:(NSString*)layerName index:(int)index;

@end

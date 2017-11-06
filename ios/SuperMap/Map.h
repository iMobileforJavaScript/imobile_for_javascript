//
//  Map.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import "CoordSysTransMethod.h"

@class Workspace,GeoStyle,Legend,LayerManager;
@class Point2D,Rectangle2D,PrjCoordSys,CoordSysTransParameter;
@class Layers,TrackingLayer,MapControl,ScreenLayer;



@protocol MapParameterChangedDelegate;
@protocol MapLoadDelegate;

typedef enum{
    MCM_DEFAULT = 0,
    MCM_BLACKWHITE = 1,
    MCM_GRAY = 2,
    MCM_BLACK_WHITE_REVERSE = 3,
    MCM_ONLY_BLACK_WHITE_REVERSE = 4
}MapColorMode;

/** 地图类，负责地图显示环境的管理。
 <p> 地图是对地理数据的可视化，通常由一个或多个图层组成。一个地图对象通常通过其图层集合对象 Layers 来管理其中的所有图层，并且地图必须与一个工作空间相关联，以便来显示该工作空间中的数据。另外，对地图的显示方式的设置将对其中的所有图层起作用。该类提供了对地图的各种显示方式的返回和设置，如地图的显示范围，比例尺，坐标以及量度单位，坐标系统以及文本、点等图层的默认显示方式等，并提供了对地图进行的相关操作的方法，如地图的打开与关闭，缩放、平移与全幅显示，以及地图的输出等。</p>
 <p>注意：</p>
 <p> 对于从工作空间获取的 Map，编辑之后，必须保存到工作空间的 Maps 中，否则对于 Map 的编辑不能够保存。</p>
 <p>当用户使用该工作空间对象进行编程时，如果将 Workspace 与 MapControl 建立了关联，那么在进行对象的关闭时，一定需要注意关闭的顺序，如下：</p>
 1. 关闭 Map 对象；
 2. 关闭 MapControl 对象；
 3. 关闭 Workspace 对象。
 */
@interface Map : NSObject{

}
#pragma Mark Construct


///构造一个新的地图对象。
-(id) init;

/**@brief 构造一个新的地图对象，并将该地图对象关联到指定的工作空间。
 @param  workspace 指定的工作空间。
     */
-(id) initWithWorkspace:(Workspace*) workspace;
#pragma Mark Property


/// 地图参数变化时通知委托。
@property (nonatomic) id<MapParameterChangedDelegate> delegate;

/// 地图第一次加载完成时通知委托。
@property (nonatomic) id<MapLoadDelegate> mapLoadDelegate;
/**@brief  获取或设置当前地图的名称。
 @return  当前地图的名称。
     */
@property (strong,nonatomic,readonly) NSString* name;

 /**@brief 获取当前地图的空间范围。
 <p> 地图的空间范围是其所显示的各数据集的范围的最小外接矩形，即包含各数据集范围的最小的矩形。当地图显示的数据集增加或删除时，其空间范围也会相应发生变化。
 @return  当前地图的空间范围。
     */
@property (strong,nonatomic,readonly) Rectangle2D* bounds;

/**@brief 获取和设置当前地图的可编辑范围。
 @return  当前地图的可编辑范围（默认为0）。
 */
@property (strong,nonatomic) Rectangle2D* userEditBounds;

/**@brief 获取或设置当前地图的描述信息。
 @return  当前地图的描述信息。
     */
@property (strong,nonatomic) NSString* description;

 /**@brief 获取或设置当前地图的旋转角度。
 <p>  单位为度，精度到 0.1 度。逆时针方向为正方向，如果用户输入负值，地图则以顺时针方向旋转。
 @return  当前地图的旋转角度。
     */
@property (assign,nonatomic) double angle;

/**@brief  获取或设置当前地图的背景风格。
 @return  当前地图的背景风格。
     */
@property (strong,nonatomic) GeoStyle* backgroundStyle;

/**@brief 获取或设置当前地图的可见范围，也称显示范围。
 <p> 当前地图的可见范围除了可以通过 setViewBounds()  方法来进行设置，还可以通过设置显示范围的中心点（Center）和显示比例尺（Scale）的方式来进行设置。
 @return  当前地图的可见范围。
     */
@property (strong,nonatomic) Rectangle2D* viewBounds;

/**@brief 获取或设置 MapControl 地图控件中是否锁定地图的可视范围。
  @return  一个布尔值，用于指定此地图控件的可视范围是否锁定。
     */
@property (assign,nonatomic) BOOL isViewBoundsLocked;

/**@brief 获取或设置 MapControl 地图控件中锁定的地图可视范围。
 <p> 当地图控件的可视范围被锁定后，则地图控件只显示指定的可视范围内的地图，其余的地图内容不显示。
 @return  地图控件锁定的可视范围。
     */
@property (strong,nonatomic) Rectangle2D* lockedViewBounds;

 /**@brief  获取或设置当前地图的显示范围的中心点。
 @return  当前地图的显示范围的中心点。
     */
@property (strong,nonatomic) Point2D* center;

/**@brief  获取或设置一个布尔值指定是否反走样地图。
 <p>  文本、线型被设置为反走样后，可以去除一些显示锯齿，使显示更加美观。如图分别为线型和文本反走样前和反走样后的效果对比。
 @return  用一个布尔值指定是否反走样地图。
     */
@property (assign,nonatomic) BOOL isAntialias;

 /**@brief 获取或设置一个布尔值指定当前地图是否被修改了。
 <p>  当地图的任何显示属性发生变化，或者其中的 layers 或 layer 对象发生变化，都认为该地图被修改。
 @return  一个布尔值，用于指定当前地图是否被修改了。
     */
@property (assign,nonatomic) BOOL isModified;

 /**@brief  获取或设置一个布尔值指定是否绘制地图背景。
 @return  一个布尔值指定是否绘制地图背景。
     */
@property (assign,nonatomic) BOOL isPaintBackground;

/**
 *获取是否使用全屏绘制模式
*/
@property (assign,nonatomic) BOOL isFullScreenDrawModel;

 /**@brief 获取当前地图的跟踪图层。
 <p>  跟踪图层是覆盖在地图的其他图层之上的一个空白的透明的图层，详细信息请参见 <TrackingLayer> 类。
 @return  当前地图的跟踪图层。
     */
@property (strong,nonatomic,readonly) TrackingLayer* trackingLayer;

//设置地图透明度 0.0-1.0
@property(assign,nonatomic)CGFloat mapAlpha;
/**
 * 屏幕图层
 *
 * @return ScreenLayer
 */
@property(strong,nonatomic,readonly) ScreenLayer* screenLayer;
/**@brief  获取或设置地图的投影坐标系统。
 <p>   投影坐标系类请参见 <PrjCoordSys>。
 @return 地图的投影坐标系统。
     */
@property (strong,nonatomic) PrjCoordSys* prjCoordSys;

/**@brief  获取当前地图所包含的图层集合对象。
 <p> 地图的图层集合对象管理地图中的所有图层。
 @return  当前地图所包含的图层集合对象。
     */
@property (strong,nonatomic,readonly) Layers* layers;

/**@brief  获取或设置当前地图所关联的工作空间。
 <p> 地图是对其所关联的工作空间中的数据的显示。
 @return  当前地图所关联的工作空间。
     */
@property (strong,nonatomic) Workspace* workspace;

 /**@brief 获取或设置 当前地图的显示比例尺。
 @return  当前地图的显示比例尺。
     */
@property (assign,nonatomic) double scale;

/**@brief 获取,设置地图的最大比例尺。
 @return  地图的最大比例尺。
     */
@property (assign,nonatomic) double maxScale;

/**@brief 获取,设置地图的最小比例尺。
 <p> 默认值为 0，表示地图按照默认值可缩放到无穷远或无穷近。
 @return  返回地图的最小比例尺。
   */
@property (assign,nonatomic) double minScale;

/**@brief 获取图片大小的宽度。
 @return  图片大小的宽度。
     */
@property (assign,nonatomic,readonly) NSInteger imageSizeWidth;

/**@brief  获取图片的高。
 @return  图片的高。
	 */
@property (assign,nonatomic,readonly) NSInteger imageSizeHeight;

//获取图例
@property(strong,nonatomic,readonly)Legend* legend;

//获取图层管理控件
@property(strong,nonatomic,readonly)LayerManager* layerManager;

/**
 * 设置，获取 使用固定比例尺来显示地图
 * @return  返回是否使用固定比例尺来显示地图
 */
@property(assign,nonatomic)BOOL isVisibleScalesEnabled;

/**
 * 获取,设置 固定比例尺数组,即固定比例尺显示时,可显示的比例尺
 * @return  返回取固定比例尺数组
 */
@property(strong,nonatomic)NSArray* visibleScales;

/**
 * 地图颜色模式
 *
 */
@property(nonatomic)MapColorMode mapColorMode;

/**
 * 设置,获取地图动态投影时所使用的投影算法，在不同椭球体时需要设置。默认值为：MTH_GEOCENTRIC_TRANSLATION
 */
@property(nonatomic)CoordSysTransMethod dynamicPrjTransMethond;

/**
 * 设置,获取地图动态投影时所使用的参数，默认7个参数全为0
 */
@property(nonatomic,strong)CoordSysTransParameter* dynamicPrjTransParameter;

#pragma Mark functions

/**
 * 设置投影坐标系统和是否动态投影
 *
 * @param value 投影坐标系
 * @param bDynamic 地图是否动态投影
 *            PrjCoordSys
 */
-(void)setDynamicProjection:(BOOL)bDynamic prj:(PrjCoordSys*)value;

/**@brief  设置图片的大小。
 @param  width 图片的宽。
 @param  height 图片的高。
	 */
-(void) setImageSizeWith:(NSInteger) width Height:(NSInteger) height NS_DEPRECATED_IOS(2_0,8_0);

/**@brief 将地图中指定点的像素坐标转换为地图坐标。
 <p>  这个方法必须在设置  setImageSize()  方法之后才能正常工作。
 @param  point 要转换坐标的指定点。
 @return  指定点的地图坐标。
     */
-(Point2D*) pixelTomap:(CGPoint) point;

/**@brief  将地图中指定点的地图坐标转换为像素坐标。
 <p>  这个方法必须在设置  setImageSize()  方法之后才能正常工作。
 @param  point2D 要转换坐标的指定点。
 @return  指定点的像素坐标。
     */
-(CGPoint) mapToPixel:(Point2D*) point2D;
 
/**@brief  打开指定名称的地图。
 <p>   该指定名称为地图所关联的工作空间中的地图集合对象中的一个地图的名称，注意与地图的显示名称相区别。
 @param  name 地图名称。
 @return  打开成功则返回 true，否则返回 false。
     */
-(BOOL) open:(NSString*) name;

 ///关闭当前地图。
-(void) close;

/**@brief  将地图放大或缩小指定的比例。
 <p> 缩放之后地图的比例尺=原比例尺 *ratio，其中 ratio 必须为正数，当 ratio 为大于1时，地图被放大；当 ratio 小于1时，地图被缩小。
 @param  ratio 缩放地图比例，此值不可以为负。
     */
-(void) zoom:(double) ratio;

 /**@brief  将地图平移指定的距离。
 @param  offsetX X 方向上的移动距离，单位为坐标单位。
 @param  offsetY Y 方向上的移动距离，单位为坐标单位。
     */
-(void) panOffsetX:(double) offsetX offsetY:(double) offsetY;

///全幅显示此地图。
-(void) viewEntire;


 ///释放对象所占用的资源。调用该方法之后，此对象不再可用。
-(void) dispose;

 ///重新绘制当前地图,刷新当前地图窗口。
-(void) refresh;

/**@brief  重新绘制当前地图,刷新设定比例尺的特定范围的地图。
 @param  dScale 刷新的地图比例尺。
 @param  bound  刷新的地图范围。
 */
-(void) refreshEx:(double)dScale Bound:(Rectangle2D*)bound;

/** 返回此地图对象的 XML 字符串形式的描述。
 <p>任何地图都可以导出成 xml 字符串，而地图的 xml 字符串也可以导入成为一个地图来显示。地图的 xml 字符串中存储了关于地图及其图层的显示设置以及关联的数据信息等。此外，可以将地图的 xml 字符串保存成一个 xml 文件。</p>
 @return  地图的 XML 形式的描述。
     */
-(NSString*) toXML;

/**设置地图可编辑图层的索引。
 <p>在嵌入式设备上,地图只能有一个可编辑图层,此处设置的是可编辑图层在地图的所有图层中的索引。</p>
 @param  index 可编辑图层的索引。
 */
-(void) setEditLayerIndex:(int)index;

/**获取可编辑图层的索引。
 <p>在嵌入式设备上,地图只能有一个可编辑图层,此处设置的是可编辑图层在地图的所有图层中的索引。</p>
 */
-(int) getEditLayerIndex;

/**@brief 设置是否允许地图动态投影显示。
 <p> 地图动态投影显示是指如果当前地图窗口中地图的投影信息与数据源的投影信息不同，利用地图动态投影显示可以将当前地图的投影信息转换为数据源的投影信息。
 @param  value 一个布尔值，用于指定是否允许地图动态投影显示。
 */
-(void)setDynamicProjection:(BOOL)value;


/**
 * 保存当前地图到工作空间
 * @return  返回boolean类型,保存成功返回true;否则返回false.
 * <p>
 * 1.若当前地图已经关闭,保存失败;
 * 2.若当前地图没有绑定的工作空间,保存失败;
 * </p>
 * @throws Exception
 */
-(BOOL)save;

/**
 * 以指定名称保存当前地图，但不能与工作空间中现有地图重名
 * @param mapName
 * @return
 * @throws Exception
 */
-(BOOL)save:(NSString*)mapName;

/**
 * 将当前地图另存为指定名称的地图
 * @param mapName      地图名称,不能为null或空串("").
 * @param isOverWrite  重名时是否覆盖,如果为false,地图重名时将不会保存地图。
 * @return             返回boolean类型,保存成功返回true;否则返回false.
 *<p>
 * 1.若指定的地图名称为null或为空串(""),保存失败;
 * 2.若当前地图已经关闭,保存失败;
 * 3.若当前地图没有绑定的工作空间,保存失败;
 * </p>
 */
-(BOOL)saveAs:(NSString*)mapName;

@end


///响应回调函数，地图参数发生变化时回调。</p>
@protocol MapParameterChangedDelegate <NSObject>
@optional
/**  地图范围发生变化时回调。
 @param  newMapCenter 地图范围变化后的地图中心点。
 */
-(void) boundsChanged:(Point2D*) newMapCenter;

/**   地图比例尺发生变化时回调。
 @param  newscale 新比例尺。
*/
-(void) scaleChanged:(double) newscale;


///地图打开时回调。
-(void) mapOpened;


 ///地图关闭时回调。
@optional
-(void) mapClosed;

///** 惯性开始
// @param
// @return
// @since1.0
// */
//-(void) inertiaStart;
//
///** 惯性结束
// @param
// @return
// @since1.0
// */
//-(void) inertiaFinish;

@end


/// 响应回调函数，地图第一次加载完成时回调。
@protocol MapLoadDelegate <NSObject>
@optional

/// 地图从打开到显示出来整个过程完成的回调。

-(void) onMapLoaded;
@end

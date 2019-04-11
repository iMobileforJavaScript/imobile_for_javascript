//
//  MapControlGroup.h
//  HotMap
//
//  Created by imobile-xzy on 2017/9/30.
//  Copyright © 2017年 imobile-xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapControl,Point2D,Rectangle2D;
//多个Mapcontrol管理类
@interface MapControlGroup : NSObject
/**@brief 获取或设置一个布尔值指定当前地图是否启用放大镜功能，默认不启动。。
 */
@property (assign,nonatomic) BOOL isMagnifierEnabled;
@property (assign,nonatomic) int magnifierRadius;

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

/**@brief 获取或设置当前地图的旋转角度。
 <p>  单位为度，精度到 0.1 度。逆时针方向为正方向，如果用户输入负值，地图则以顺时针方向旋转。
 @return  当前地图的旋转角度。
 */
@property (assign,nonatomic) double angle;

//添加mapcontrol，第一个为底图层级，其他为叠加层
-(void)addMapControl:(MapControl *)mapControl;
-(void)removeMapControl:(MapControl*)mapControl;

//开启、关闭 OpenGL模式下的旋转和倾斜手势
-(void)enableRotateTouch:(BOOL)value;
-(void)enableSlantTouch:(BOOL)value;

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

/**
 * 在指定的时间内到指定的比例尺
 * @param scaleDest 目标比例尺
 * @param time 持续时间
 * @return
 */
-(void) zoomTo:(double)scaleDest time:(int)time;
/**
 * 在指定的时间内平移到指定的点
 * @param ptnDest 目标点
 * @param time 持续时间
 * @return
 */
-(void) panTo:(Point2D*)ptnDest time:(int)time;

/**
 * 取消平移和缩放的动画
 * @return
 */
-(void) cancelAnimation;


@end

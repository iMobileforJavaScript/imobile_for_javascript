//
//  MapControl.h
//  LibUGC
//
//  Created by Apple on 15/7/12.
//  Copyright (c) 2015年 beijingchaotu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Action.h"
#import "SelectionMode.h"

@class Map,Navigation,Navigation2,Navigation3;
@class Workspace,Collector;
@class Callout;
@class Geometry;
@class Layer,Point2D;
@class Color;
@class DynamicView,SnapSetting;
@class DatasourceConnectionInfo;
@protocol TouchableViewDelegate;
@protocol MapEditDelegate;
@protocol MapMeasureDelegate;
@protocol GeometrySelectedDelegate;


/** 地图控件类。
 <p> 该类是用于为地图的显示提供界面的，同时为地图与数据的互操作提供了途径。
 <p>地图控件是一个对地图进行显示的控件。通过地图控件，不仅可以对地图进行显示，而且可以通过对地图的可视化编辑，从而对地图所引用的数据进行编辑。</p>
 <p>当一个地图对象与一个地图控件相关联，该地图控件即可以对该地图对象进行显示，地图的显示属性以及显示操作都将在该地图对象中设置。然而对地图的可视化编辑的设置和操作将在 MapControl
 对象中设置。</p>
 <p>注意：</p>
 <p>当用户使用该工作空间对象进行编程时，如果将 Workspace 与 MapControl
 建立了关联，那么在进行对象的关闭时，一定需要注意关闭的顺序，如下：</p>
 1. 关闭 Map 对象；
 2. 关闭 MapControl 对象；
 3. 关闭 Workspace 对象。
 */
@interface MapControl : UIView

/**@brief 获取在地图控件中显示的地图对象。
 <p> 默认值为空的Map对象
 @return  在地图控件中显示的地图对象。
 */
@property(nonatomic,retain)Map *map;

/**@brief 获取或设置地图控件中地图的当前操作状态。在  Action 类中定义了目前支持的所有的对地图的操作模式。
 @return  地图控件中地图的当前操作状态。
 <p>  默认值为NULL。
 @exception  EnumConstantNotPresentException 当取出的值错误时。
 */
@property(nonatomic,assign)Action action;

/**@brief  获取或设置选择空间对象的容限。
 <p>  即要素上距离鼠标指针最近点到鼠标指针的距离在多大范围以内，可以认为该空间对象被选中，单位为毫米，精确到 0.1
 毫米。针对点选方式。
 <p>  默认值为 1。
 @return  选择空间对象的容限。
 */
@property(nonatomic,assign)double selectionTolerance;

/**@brief  获取或设置对象的选择模式。
 <p> 参见  SelectionMode 常量。针对除点选之外的区域选择方式。
 <p>  默认的对象选择模式为 {@link SelectionMode#CONTAIN_INNER_POINT SelectionMode.CONTAIN_INNER_POINT}，即对象的内点在选择范围内的就选中。
 @return  对象的选择模式。
 */
@property(nonatomic,assign)SelectionMode selectionMode;

/**@brief  获取用户设置的控件高度。
 @return  控件高度。
 */
@property(nonatomic,readonly)NSInteger mapHeight;

/**@brief  关联动态层。
 */
@property(nonatomic,readonly)NSInteger mapWidth;

/**
 * @brief 绘制对象画笔宽度。
 * @return 绘制对象画笔宽度。
 */
@property(nonatomic)double strokeWidth;

/**
 * @brief 绘制对象画笔颜色。
 * @return 绘制对象画笔颜色。
 */
@property(nonatomic,retain)Color* strokeColor;

/**
 * @brief 绘制对象填充颜色。
 * @return 绘制对象填充颜色。
 */
@property(nonatomic,retain)Color* strokeFillColor;


/**
 * @brief 绘制对象节点大小。
 * @return 绘制对象节点大小。
 */
@property(nonatomic)double nodeSize;

///获取当前MapControl中存储的Callout对象集合。
@property(nonatomic,retain)NSMutableArray *callouts;

///用户的手势回调。
@property (nonatomic) id<TouchableViewDelegate> delegate;

///编辑地图时用户回调。
@property (nonatomic) id<MapEditDelegate> mapEditdelegate;


/**
 * @brief 地图量算时通知委托。
 */
@property(nonatomic) id<MapMeasureDelegate> mapMeasureDelegate;

/**
 * @brief 几何对象选中时通知委托。
 */
@property(nonatomic) id<GeometrySelectedDelegate> geometrySelectedDelegate;

/**@brief 获取或设置一个布尔值指定当前地图是否启用放大镜功能，默认不启动。。
 */
@property (assign,nonatomic) BOOL isMagnifierEnabled;
@property (assign,nonatomic) int magnifierRadius;

//mapControl frame 跟随横竖屏变化
@property(nonatomic,assign)CGRect rect;


/**
 * 设置,获取 地图控件的捕捉设置
 * @param value
 */
@property(nonatomic,strong)SnapSetting* snapSetting;

///默认构造函数，构造一个新的MapControl对象。
-(id)init;

/** @brief 根据指定的CGRect（尺寸）构造一个新的MapControl对象。
 @param  frame 指定的CGRect（尺寸）。
 */
-(id) initWithFrame:(CGRect)frame;

/**@brief 构造一个新的MapControl对象，并将其中Map对象关联到指定的工作空间。
 @param  workspace 指定的工作空间。
 */
-(id) initWithWorkspace:(Workspace*) workspace;

///初始化MapControl的新实例，无返回值。
-(void)mapControlInit;

//开启、关闭 OpenGL模式下的旋转和倾斜手势
-(void)enableRotateTouch:(BOOL)value;
-(void)enableSlantTouch:(BOOL)value;

/**@brief 设置用户的宽度和高度。
 @param  width 设置高度。
 @param  height 设置宽度 。
 */
-(void)setSizeWithHeight:(NSInteger)height Width:(NSInteger)width;

/**@brief 添加动态层。
 */
-(void)addDynamicView:(DynamicView*)dyView;

/**@brief 删除动态层。
 */
-(void)removeDynamivView:(DynamicView*)dyView;

/**@brief 从Mapcontrol上移除指定序号的Callout对象。
 @param  index 指定的 Callout 对象的索引。
 */
-(void) removeCalloutAtIndex:(int)index;

/**@brief 从Mapcontrol上移除calloutArr内的callout。
 @param callout数组
 */
-(void)removeCalloutWithArr:(NSArray*)calloutArr;

///移除 Mapcontrol上所有Callout对象。
-(void) removeAllCallouts;

///获取MapControl上Callout对象的个数。
-(int) getCalloutCount;
//}} Add by guanzl 2013-01-25 移除callout

///释放对象所占用的资源。调用该方法之后，此对象不再可用。
-(void)dispose;

/**@brief   地图控件上撤消上一次的操作。
 @return  成功完成撤销操作返回 true；否则返回 false。
 */
-(void)undo;

/**@brief  地图窗口上恢复上一步的操作。恢复操作必须以撤销操作为前提。
 @return  成功完成恢复操作返回 true；否则返回 false。
 */
-(void)redo;

/** 获取当前的编辑对象。
 *
 * @return
 */
-(Geometry*)getCurrentGeometry;

/// 地图窗口上提交编辑绘制对象。提交对象操作必须以地图编辑为前提。
-(BOOL)submit;

/** 取消当前的操作。
 *
 * @return
 */
-(void)cancel;

/// 地图窗口上删除编辑对象操作。删除对象操作必须以地图编辑且地图上有选中的编辑对象为前提。
-(void)deleteCurrentGeometry;

/// 获取导航模块。
-(Navigation *)getNavigation;

-(Navigation2 *)getNavigation2;

-(Navigation3 *)getNavigation3;

/**
 * 将当前显示内容绘制到指定位图上
 * @param image 需要被绘制的位图
 * @return
 */
-(CGImageRef)outputMap:(CGRect)rect;

/**
 * 选择事件
 * @param x 选择点的x坐标
 * @param y 选择点的y坐标
 * @return 是否选择成功,选上对象返回true,未选中返回false
 */
-(BOOL)onSelectX:(int)x Y:(int)y;

/**
 * 指定编辑对象
 * @param geomety 要编辑的对象
 * @param layer 要编辑对象所属的图层
 * @return
 */
-(BOOL)appointEditGeometryWithID:(int)ID Layer:(Layer*)layer;

/**
 * 获取GPS采集对象
 */
-(Collector*)getCollector;

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

//加载符号库，若地图中使用了相关库，需要在打开地图前加载
-(int)addPlotLibrary:(NSString*)libraryPath;
//删除符号库
-(void)removePlotLibrary:(int)libraryID;
//通过libraryID 和 symbolCode绘制态势标绘符号
-(void)setPlotSymbol:(int)libraryID symbolCode:(long)symbolCode;

@end

///手势回调函数，用户需要实现自定义手势时回调。
@protocol TouchableViewDelegate <NSObject>
@optional
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)longpress:(CGPoint)pressedPos;
- (void)onDoubleTap:(CGPoint)onDoubleTapPos;
- (void)onSingleTap:(CGPoint)onDoubleTapPos;
@end

///地图编辑用户回调。
@protocol MapEditDelegate <NSObject>

/// 绘制对象提交后回调。
@optional
- (void)submitGeometry:(NSInteger)ID;
-(void)finishEditedEvent:(Layer*)layer ids:(NSArray*)ids;
@end

/**
 * @brief 地图量算用户回调。
 */
@protocol MapMeasureDelegate <NSObject>
@optional
/**
 * @brief 获取地图量算结果。
 * @param  result 地图量算结果,单位米。
 * @param lastPoint 量算时绘制的最后一个点 。
 */
-(void)getMeasureResult:(double)result lastPoint:(Point2D*)lastPoint type:(int)type;
-(void)measureState;
@end

/**
 * @brief 几何对象选中时用户回调。
 */
@protocol GeometrySelectedDelegate <NSObject>
@optional
/**
 * @brief 几何对象被选中时响应。
 * @param geometryID 被选中对象的SmID。
 * @param layer 选中对象所在图层。
 */
-(void)geometrySelected:(int)geometryID Layer:(Layer*)layer;
//框选回调 数据类 [layer,[id1,id2]]; 组成的列表
-(void)geometryMultiSelected:(NSArray*)layersAndIds;
@end



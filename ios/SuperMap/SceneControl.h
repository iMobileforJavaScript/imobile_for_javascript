//
//  SceneControl.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <UIKit/UIKit.h>
#import "Action3D.h"
#import "Point3D.h"


@protocol SceneControlTouchDelegate,Tracking3DDelegate,Tracked3DDelegate,PointInputDelegate;
@class Scene,Tracking3DEvent,Tracked3DEvent
#ifndef _NO2D_
,Navigation3D
#endif
;
/// 三维场景控件。
@interface SceneControl : UIView {
    id<SceneControlTouchDelegate> _sceneControlDelegate;
    id<Tracking3DDelegate> _tracking3DDelegate;
    id<Tracked3DDelegate> _tracked3DDelegate;
    id<PointInputDelegate> _pointInputDelegate;
    Scene *_scene;
    BOOL _statusBarVisible;
    Action3D _action3D;
    BOOL _isRender;
}

/// 返回或设置三维场景是否渲染，当设置为false时，场景将不再绘制。
@property(nonatomic)BOOL isRender;

///当触摸三维场景控件时会触发该委托。所实现的委托类必须符合 SceneControlTouchDelegate 的协议。
@property(nonatomic)id<SceneControlTouchDelegate> sceneControlDelegate;

///在三维场景窗口的跟踪图层中鼠标交互绘制几何对象时会触发该事件。所实现的委托类必须符合 Tracking3DDelegate 的协议。
@property(nonatomic)id<Tracking3DDelegate> tracking3DDelegate;

///在三维场景窗口的跟踪图层中鼠标交互绘制几何对象结束时会触发该事件。所实现的委托类必须符合 Tracked3DDelegate 的协议。
@property(nonatomic)id<Tracked3DDelegate> tracked3DDelegate;

///返回三维场景控件中的场景对象。
@property(nonatomic,readonly)Scene *scene;
#ifndef _NO2D_
//三维导航
@property(nonatomic,readonly)Navigation3D *navi3D;
#endif
///返回或设置三维场景操作状态。
@property(nonatomic)Action3D action3D;

///返回或设置状态条是否可见。
@property(nonatomic)BOOL statusBarVisible;

///返回或设置导航条是否可见。
@property (assign, nonatomic, getter=isNavigationControlVisible) BOOL navigationControlVisible;

/**@brief 在指定的视图控件上初始化三维场景控件。
 @param  viewControl 指定的视图控件。
 */
- (void)initSceneControl:(UIViewController *)viewControl;

 /// 当用户手动改变SceneControl时需调用resize方法来强制重绘
 - (void)resize;
@end


///三维场景控件触控动作委托类。
@protocol SceneControlTouchDelegate <NSObject>
/** 第一次触摸屏幕时响应该方法。
 @param  touches UITouch对象的集合，它只包含 Began 状态的触控动作。
 @param  event 触控动作引发的UI事件，它关联了一些列UITouch对象来代表发生该事件时所处于各种状态下（Began、Moved、Ended和Cancelled）的触控动作。
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
/**手指移过屏幕时响应该方法。
 @param  touches UITouch对象的集合，它只包含 Moved 状态的触控动作。
 @param  event 触控动作引发的UI事件，它关联了一些列UITouch对象来代表发生该事件时所处于各种状态下（Began、Moved、Ended和Cancelled）的触控动作。
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
/**手指离开屏幕时响应该方法。
 @param  touches UITouch对象的集合，它只包含 Ended 状态的触控动作。
 @param  event 触控动作引发的UI事件，它关联了一些列UITouch对象来代表发生该事件时所处于各种状态下（Began、Moved、Ended和Cancelled）的触控动作。
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
/**当发生某些事件导致手势中断时响应该方法，调用该方法就不会响应 touchesEnded方法。
 @param  touches UITouch对象的集合，它只包含 Cancelled 状态的触控动作。
 @param  event 触控动作引发的UI事件，它关联了一些列UITouch对象来代表发生该事件时所处于各种状态下（Began、Moved、Ended和Cancelled）的触控动作。
 */
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
@end

///三维场景窗口跟踪动作委托类。
@protocol Tracking3DDelegate <NSObject>

/**三维场景窗口跟踪时响应该方法。
 @param  event 跟踪动作引发的动作。
 */
- (void)tracking3DEvent:(Tracking3DEvent*)event;
@end

///三维场景窗口跟踪结束动作委托类。
@protocol Tracked3DDelegate <NSObject>

/**三维场景窗口跟踪结束时响应该方法。
 @param  event 跟踪动作结束引发的动作。
 */
- (void)tracked3DEvent:(Tracked3DEvent*)event;
@end
//
//  Callout.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//
#import <UIKit/UIKit.h>
@class MapControl;
@class Point2D;

// The ArrowPostion

/// 该类设置了点标注对齐方式类型常量。
typedef enum{
	/// 无对齐方式。
    CALLOUT_NONE = -1,   
	/// 左对齐。
    CALLOUT_LEFT = 0,    
	/// 上对齐。
    CALLOUT_TOP = 1,    
	/// 右对齐。
    CALLOUT_RIGHT = 2,   
	/// 下对齐。
    CALLOUT_BOTTOM = 3,  
	/// 中心对齐。
    CALLOUT_CENTER = 4,  
	/// 左上对齐。
    CALLOUT_LEFTTOP = 5,   
	/// 右上对齐。
    CALLOUT_RIGHTTOP = 6,  
	/// 左下对齐。
    CALLOUT_LEFTBOTTOM = 7, 
	/// 右下对齐。
    CALLOUT_RIGHTBOTTOM = 8,  
}CalloutAlignment;
#define ORC_RADIUS 10


/// 点标注类。
@interface Callout : UIView {
}


/**获取或设置点标注（Callout）的高度。
 @return  点标注（Callout）的高度。
 */
@property(nonatomic)CGFloat height;

/**获取或设置点标注（Callout）的宽度。
 @return  点标注（Callout）的宽度。
 */
@property(nonatomic)CGFloat width;
@property(nonatomic,strong)NSString* tag;
//The User Custom Arrow style
// @since 1.0
// */
//@property(nonatomic) CGPoint arrowPoint;

/** 获取或设置用于显示点标注（Callout）的地图控件。
 @return  用于显示点标注（Callout）的地图控件。
*/
@property (nonatomic, retain) MapControl *mapControl;

/** 获取或设置点标注（Callout）是否采用默认风格。
 @return  一个布尔值，点标注（Callout）采用默认风格返回 true,否则返回false。
*/
@property(nonatomic)BOOL isUseDefalutStyle;

/**根据指定的参数构造一个新的带默认风格的点标注（Callout）对象。
 @param  mapControl   点标注（Callout）对象关联的地图控件。
 @param  customcolor  点标注（Callout）的背景颜色。
 @param  calloutAlignment 点标注（Callout）的默认的箭头方向。
 */
- (id)initWithMapControl:(MapControl *)mapControl BackgroundColor:(UIColor*)customcolor Alignment:(CalloutAlignment)calloutAlignment;

/**  根据指定的参数构造一个空的点标注对象（Callout）。
 @param  mapControl  点标注对象 Callout 关联的地图控件 MapControl。
 */
- (id)initWithMapControl:(MapControl *)mapControl;

/** 点标注对象（Callout）在地图控件（MapControl）上的显示坐标。
 <p>当使用默认带箭头的点标注对象（Callout）时显示坐标为箭头的指向位置的坐标，否则为点标注对象（CallOut）的左上角坐标。</p>
 @param  position2D 点标注对象（Callout）的显示坐标。
 @return  一个布尔值，点标注对象（Callout）显示成功返回true,否则返回false。
 */
- (BOOL) showAt:(Point2D *)position2D Tag:(NSString*)tag;

///获取Callout的显示位置
- (Point2D *)getLocation;

/** 设置点标注对象（Callout）的显示坐标。
 @param  pointX 点标注对象（Callout）显示位置的X坐标（屏幕坐标）。
 @param  pointY 点标注对象（Callout）显示位置的Y坐标（屏幕坐标）。
 */
- (void)setLocationX:(CGFloat)pointX LocationY:(CGFloat)pointY;

/** 更新点标注对象（Callout）的显示位置。
 @param  point 点标注对象（Callout）的显示坐标（屏幕坐标）。
 */
- (void)updateFrame:(CGPoint)point;

@end

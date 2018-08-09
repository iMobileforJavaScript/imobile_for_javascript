//
//  ARMapControl.h
//  LibUGC
//
//  Created by wnmng on 2018/5/17.
//  Copyright © 2018年 beijingchaotu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ARView ,              // 普通地图浏览视角
    ARSelect             // AR模式的地图浏览基础上支持选择
}ARAction;

@class Rectangle2D,Point2D,Layer;

/**
 * @brief 几何对象选中时用户回调。
 */
@protocol ARSelectedDelegate <NSObject>
@optional
/**
 * @brief 几何对象被选中时响应。
 * @param geometryID 被选中对象的SmID。
 * @param layer 选中对象所在图层。
 */
-(void)selectedGeometry:(int)geometryID Layer:(Layer*)layer;
@end


@interface ARControl : UIView

/**@brief  获取或设置观察点。
 @return  当前地图的观察点。
 */
@property (strong,nonatomic) Point2D* viewPoint;
/**@brief  获取地图中心点。
 @return  当前地图的中心点。
 */
@property (strong,nonatomic) Point2D* centerPoint;
/**@brief 获取或设置 当前地图的显示比例尺。
 @return  当前地图的显示比例尺。
 */
@property (assign,nonatomic) double scale;
/**@brief 获取或设置 当前地图的朝向角度。
 @return  当前地图的朝向角度。
 */
@property (assign,nonatomic) double angle;
/**@brief 获取或设置 当前地图的操作状态。
 @return  当前地图的操作状态。
 */
@property (nonatomic,assign) ARAction action;
/**@brief 获取或设置 当前地图对象的选择回调。
 @return  当前地图对象的选择回调。
 */
@property (nonatomic) id<ARSelectedDelegate> selectedDelegate;
/**@brief 获取或设置 当前地图是否自动更新位置信息。
 @return  当前地图是否自动更新位置信息。
 */
@property (nonatomic,assign) BOOL isAutoUpdateLocation;
/**@brief 获取或设置 当前地图是否自动更新朝向。
 @return  当前地图是否自动更新朝向。
 */
@property (nonatomic,assign) BOOL isAutoUpdateHeading;
/**@brief 获取或设置 罗盘控件可见性 罗盘控件提供指北功能，点击开启自动更新地图位置。
 @return  罗盘控件可见性。
 */
@property (nonatomic,assign) BOOL isCompossVisable;

// 添加图层到AR控件
-(BOOL)addLayer:(Layer*)layer ToHead:(BOOL)bHead;
// 清除所有图层
-(void)removeAllLayer;
// 控件中图层数量
-(int)getLayerCount;
// 通过index删除图层
-(BOOL)removeLayerAt:(int)index;
// 通过name删除图层
-(BOOL)removeLayerWithName:(NSString*)name;
// 获取图层名
-(NSString*)layerNameAt:(int)index;
// 获取图层index
-(int)layerIndexWithName:(NSString*)name;
// 移动图层
-(BOOL)moveLayerAt:(int)srcIndex to:(int)desIndex;
//释放对象所占用的资源。调用该方法之后，此对象不再可用。
-(void)dispose;
@end

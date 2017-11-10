//
//  GeoStyle3D.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "Color.h"
#import "AltitudeMode3D.h"
#import <UIKit/UIKit.h>
/**三维场景中的几何对象风格类
 <p>该类主要用于设置三维场景中几何对象的显示风格
 */

@interface GeoStyle3D : NSObject

/// 三维场景中的几何对象的高度模式
@property(nonatomic)AltitudeMode3D altitudeMode;
/// 底部高程值
@property(nonatomic)double bottomAltitude;
/// 拉伸高度值
@property(nonatomic)double extendedHeight;
/// 线颜色
@property(nonatomic)Color* lineColor;
/// 线宽
@property(nonatomic)double lineWidth;
/// 点颜色
@property(nonatomic)Color* markerColor;
/// 点大小
@property(nonatomic)double markerSize;
///点图标缩放比例
@property (nonatomic, assign) double markerScale;
//点图标锚点
@property (nonatomic, assign) CGPoint markerAncherPoint;
/// 点图标
@property(nonatomic) NSString* markerFile;
/// 填充前景色
@property(nonatomic)Color* fillForeColor;
/// 填充背景色
@property(nonatomic)Color* fillBackColor;

/** 构造一个新的 GeoStyle3D 对象
 @return  GeoStyle3D对象
 */
- (id)init;
/** 根据指定的GeoStyle3D对象，构造一个新的GeoStyle3D对象
 @param  style3D GeoStyle3D 对象
 @return  GeoStyle3D对象
 */
- (id)initWithGeoStyle3D:(GeoStyle3D*)style3D;
 
/** 克隆当前三维场景中的几何对象风格类对象
 @return  克隆的GeoStyle3D对象
 */
- (GeoStyle3D*)clone;
@end

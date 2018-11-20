//
//  Tracked3DEvent.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "Point3D.h"


@class Geometry3D;
/**三维场景窗口跟踪结束事件参数类
 <p>该类主要为三维场景窗口中的跟踪结束事件，即为SceneControl类的 Tracked事件提供数据。
 */
@interface Tracked3DEvent : NSObject

/// 获取当前绘制完的几何对象的面积，单位为平方米
@property(nonatomic)double area;
/// 获取当前绘制完的三维几何对象
@property(nonatomic)Geometry3D *geometry3D;
/// 获取当在进行高度量算时，两点之间的垂直距离，单位为米
@property(nonatomic)double height;
/// 获取当前绘制完的几何对象的长度，单位为米
@property(nonatomic)double length;
/// 返回描述三维场景窗口跟踪事件参数类对象的字符串，格式为：{Length = , Area= ,Height=}
@property(nonatomic)NSString *text;
@end

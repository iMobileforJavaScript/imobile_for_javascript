//
//  Tracking3DEvent.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "Point3D.h"


@class Geometry3D;
/**三维场景窗口跟踪事件参数类
 <p>该类主要为三维场景窗口中的跟踪事件，即为SceneControl类的 Tracking事件提供数据
 */
@interface Tracking3DEvent : NSObject

/// 当前绘制的线段的长度，单位为米
@property(nonatomic)double currentLength;

/// 获取所绘多边形的面积（大圆面积），如果所绘制的内容为折线，则返回为零。单位为平方米
@property(nonatomic)double totalArea;

/// 获取当前正在绘制的三维几何对象
@property(nonatomic)Geometry3D *geometry3D;

/// 获取所绘制的线段的总长度，单位为米
@property(nonatomic)double totalLength;

/// 获取当前绘制的最后一个节点位置（X，Y坐标为经纬度，Z高度为米）
@property(nonatomic)Point3D position;

/// 返回描述三维场景窗口跟踪事件参数类对象的字符串，格式为：{CurrentLength=,TotalArea=,TotalLength=,X=0.0,Y=0.0,Z=0.0}。
@property(nonatomic)NSString *text;
@end

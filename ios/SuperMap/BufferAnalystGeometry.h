//
//  BufferAnalystGeometry.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
#import "PrjCoordSys.h"
@class GeoRegion;
@class Geometry;
@class BufferAnalystParameter;

/// 几何对象缓冲区分析类。
@interface BufferAnalystGeometry : NSObject

/**@brief 根据给定的几何对象及缓冲区分析参数对象创建缓冲区。
 @param  sourceGeometry 几何对象。
 @param  bufferParam 缓冲区分析参数对象。有关缓冲分析参数对象，请参见 <BufferAnalystParameter> 类。
 @param  prjCoordSys 地图的投影坐标系。
 @return  根据几何对象创建缓冲区，成功返回一个面对象，失败则返回空值。
 <p>注意：对点或面对象进行缓冲分析时，只能采用圆头缓冲模式，即：参数BufferAnalystParameter对象中的 setEndType() 方法，只能设置为BufferEndType.ROUND。</p>
*/
+(GeoRegion*) CreateBufferSourceGeometry:(Geometry*)sourceGeometry BufferParam:(BufferAnalystParameter*)bufferParam prjCoordSys:(PrjCoordSys*)prjCoordSys;
@end

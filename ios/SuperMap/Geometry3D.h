//
//  Geometry3D.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import "Geometry.h"
#import "Point3D.h"
@class GeoStyle3D,GeoModel;

/// 所有三维几何类的基类，提供了基本的三维几何类的属性和方法。
@interface Geometry3D : Geometry

/// 三维几何对象的位置
@property(nonatomic)Point3D position;

/// 三维几何对象的风格
@property(nonatomic)GeoStyle3D *style3D;

/// 三维几何对象沿 X 轴方向的旋转角度，单位为度
@property(nonatomic)double rotationX;

/// 三维几何对象沿 Y 轴方向的旋转角度，单位为度
@property(nonatomic)double rotationY;

/// 三维几何对象沿 Z 轴方向的旋转角度，单位为度
@property(nonatomic)double rotationZ;

/// 三维几何对象沿 X 轴方向的缩放比例
@property(nonatomic)double scaleX;

/// 三维几何对象沿 Y 轴方向的缩放比例
@property(nonatomic)double scaleY;

/// 三维几何对象沿 Z 轴方向的缩放比例
@property(nonatomic)double scaleZ;

/// 三维几何对象的内点，即在三维几何对象的内部且靠近中央的点
@property(nonatomic,readonly)Point3D innerPoint3D;

/** @brief 三维几何对象的内点，即在三维几何对象的内部且靠近中央的点
 *  @param dx - 沿 X 轴方向的偏移量
 *  @param dy - 沿 Y 轴方向的偏移量
 *  @param dz - 沿 Z 轴方向的偏移量
   @return  如果成功，返回添加子对象的序号。
 */
- (void)offsetX:(double)dx Y:(double)dy Z:(double)dz;

/** @brief 根据横向细分数和纵向细分数来获得三维模型对象。
 细分数越大，三维模型对象将被拆分的越细小、越细致，从而渲染对象的表面和边缘也就更平滑、更精细
 * param slices - 横向细分数
 * param stacks - 纵向细分数
 @return  如果成功，返回添加模型对象。
 */
- (GeoModel *)getModelWith:(NSInteger)slices Stacks:(NSInteger)stacks;
@end

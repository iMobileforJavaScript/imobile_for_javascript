//
//  Point3D.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

/** 三维点类。
*
* <p>三维点类，其实例为三维点对象，用于表示坐标值精度为 double 的三维点对象，即其坐标值大致范围为±5.0*1e-324到±1.7*1e308，有效位为15-16位。
*/
struct Point3D {
	/// 三维点对象的经度坐标值。单位为度。
    double x; 
	/// 三维点对象的纬度坐标值。单位为度。
    double y; 
	///  三维点对象的高度坐标值。单位为米。
    double z;
};
typedef struct Point3D Point3D;
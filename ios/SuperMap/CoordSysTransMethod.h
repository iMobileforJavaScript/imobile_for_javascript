//
//  ServiceQueryParameter.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

/** 该枚举定义了投影转换方法类型常量。
 * 
 * 1. 在投影转换中，如果源投影和目标投影的地理坐标系不同，则需要进行参照系的转换。
 * 2. 参照系的转换有两种，基于网格的转换和基于公式的转换。本类所提供的转换方法均为基于公式的转换。依据转换参数的不同可以分为三参数法和七参数法。目前使用最广泛的是七参数法。参数信息参见
 *  <CoordSysTransParameter> 。本版本所提供的方法除了基于地心的三参数转换法之外都是七参数法。
 */
typedef enum{

	///基于地心的三参数转换法。

    MTH_GEOCENTRIC_TRANSLATION = 9603,

	///莫洛金斯基（Molodensky）转换法。

    MTH_MOLODENSKY = 9604,

	///简化的莫洛金斯基转换法。

    MTH_MOLODENSKY_ABRIDGED = 9605,

	///位置矢量法。

    MTH_POSITION_VECTOR = 9606,

	///基于地心的七参数转换法。

    MTH_COORDINATE_FRAME = 9607,

	///布尔莎方法。
    MTH_BURSA_WOLF = 9608
}CoordSysTransMethod;

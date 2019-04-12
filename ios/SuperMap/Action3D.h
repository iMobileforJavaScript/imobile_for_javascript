//
//  Action3D.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

/// 该类定义了场景操作状态类型常量。

typedef enum {
    /// 空操作。
    NONEACTION3D = 0,  
	/// 平移。
    PAN3D = 1,
    /// 量算距离
    MEASUREDISTANCE3D  = 31,
    /// 量算面积
    MEASUREAREA3D = 32,
	/// 平移且可以选择。
    PANSELECT3D = 105,
    /// 画点
    CREATEPOINT3D		= 106,
	/// 画线
	CREATELINE3D		= 107,
	/// 画折线
	CREATEPOLYLINE3D	= 108,
	/// 画多边形
	CREATEPOLYGON3D	= 109
}Action3D;

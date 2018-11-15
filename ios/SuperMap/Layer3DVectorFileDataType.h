//
//  Layer3DVectorFileDataType.h
//  LibUGC6R
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//
//

///该类定义了三维矢量缓存图层对应的数据类型常量。
typedef enum {
	/// 点数据集类型。
    POINT = 1 ,
	///  线数据类型。
    LINE = 3 ,
	/// 面数据类型。
    REGION = 5 ,
	/// 本文数据类型。
    TEXT = 7 ,
	/// 模型数据类型。
    VECTORMODEL = 106 ,
}Layer3DVectorFileDataType DEPRECATED_ATTRIBUTE;
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

/// 该类定义了三维图层类型常量。
typedef enum {
    /// 影像文件缓存。
    IMAGEFILE      = 1,
    /// 类型三维图层KML。
    KML            = 2,
    /// 矢量文件图层，特指矢量文件缓存所对应的图层类别。该类型图层包含的数据包括点、线、面的矢量文件数据，以及模型矢量缓存文件（SCV文件）。
    VECTORFILE     DEPRECATED_ATTRIBUTE = 10,
    /// WMTS服务
    WMTS           = 12,
    /// OSGB图层
    OSGBFILE       = 15,
    /// 在线BingMaps
    BINGMAPS       = 22,
}Layer3DType;
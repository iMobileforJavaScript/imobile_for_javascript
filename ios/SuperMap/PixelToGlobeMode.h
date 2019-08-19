//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//


/// 该类定义了屏幕坐标转换为地理坐标的两种方式。
typedef enum {
    /// 同时考虑地形和模型。
    TerrainAndModel      = 1,
    /// 只有模型数据的情况。
    Terrain            = 2,
}PixelToGlobeMode;

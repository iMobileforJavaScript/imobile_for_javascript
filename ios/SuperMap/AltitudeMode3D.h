//
//  AltitudeMode3D.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//
/// 该枚举定义了高度模式类型常量，高度模式用于指示 SuperMap 组件产品解析三维数据海拔高度值的方式。
typedef enum{
    /// 贴地表模式
    ClampToGround = 0,
    /// 相对地表模式
    RelativeToGround = 1,
    /// 绝对海拔模式
    Absolute3D = 2,
}AltitudeMode3D;


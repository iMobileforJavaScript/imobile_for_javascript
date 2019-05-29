//
//  EngineType.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

/** 该枚举定义了空间数据库引擎类型常量。
 *  
 *<p> 1. 空间数据库引擎是在常规数据库管理系统之上的，除具备常规数据库管理系统所必备的功能之外，还提供特定的针对空间数据的存储和管理能力。
 *<p> 2.SuperMap SDX+ 是 SueprMap 的空间数据库技术，也是 SuperMap GIS 软件数据模型的重要组成部分。各种空间几何对象和影像数据都可以通过 SDX+ 引擎，存放到关系型数据库中，形成空间数据和属性数据一体化的空间数据库。
 *<p> 3.对不同类型的空间数据源，需要不同的空间数据库引擎来存储和管理，对文件型数据源，即 UDB 数据源，需要 SDX+ for UDB，引擎类型为  UDB。目前版本支持的引擎类型包括 UDB 引擎，影像只读引擎 IMAGEPLUGINS。
 *<p> 4.天地图，百度地图，Google 地图等 Web地图，出于数据保护原则，在地图发布时进行过整体偏移，所以在使用对应的 Web 地图数据时，可能会存在与 GPS 数据不能吻合的情况。此时，请联系数据提供商，获取相关纠偏服务。
 *
 */
typedef enum{
/** 影像只读引擎类型。针对通用影像格式如 BMP，JPG，TIFF 以及超图自定义影像格式 SIT，二维地图缓存配置文件格式SCI等。
     *  
     *<p>  用户在进行二维地图缓存加载的时候，需要设置为此引擎类型，另外还需要使用 DatasourceConnectionInfo 类中的 setServer() 方法，将参数设置为二维地图缓存配置文件（SCI）。
     */
    //废弃
    ET_IMAGEPLUGINS = 5,
    
    /// OGC引擎类型，针对于 Web 数据源。
    ET_OGC = 23,
    

    ///   UDB 引擎类型。
    ET_UDB = 219,
	
	///  超图云服务引擎类型，该引擎为只读引擎，且不能创建。针对超图发布的云服务。
    ET_SuperMapCloud = 224,
	
	/// GoogleMaps 引擎类型，该引擎为只读引擎，且不能创建。针对 GoogleMaps 数据源。
    ET_GOOGLEMAPS = 223,
	
	///  REST 地图服务引擎类型，该引擎为只读引擎，且不能创建。针对基于 REST 协议发布的地图服务。
    ET_REST = 225,

	/// Baidu 天地图地图服务引擎类型，该引擎为只读引擎，且不能创建。针对天地图发布的服务。
    //接口废弃，不能再使用
  //  ET_MapWorldMaps = 226,
      
	///Baidu 百度地图服务引擎类型。 
    ET_BAIDU = 227,
    
    //openstreet地图
    ET_OPENSTREEMAPS = 228,
    
    //必应地图
    ET_BingMaps = 230,
    
    //OpenGLCache,用于打开OpenGLCache数据源
    ET_OPENGLCACHE = 305,
    
    //mvt类型数据源
    ET_MVTCACHE = 306
}EngineType;

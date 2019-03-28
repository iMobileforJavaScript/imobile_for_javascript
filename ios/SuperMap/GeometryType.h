//
//  GeometryType.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//


/// 该类定义了一系列几何对象的类型常量。
    typedef enum{
		/// 点几何对象。
        GT_GEOPOINT  = 1,
		/// 线几何对象。
        GT_GEOLINE   = 3,	
		///  面几何对象。
        GT_GEOREGION = 5,	
		/// 文本几何对象。
        GT_GEOTEXT   = 7,
        /// 路由几何对象。
        GT_GEOLINEM = 35,
        GT_GEOCIRCLE = 15,
        ///
        GT_GEOPOINT3D = 101,
        
        GT_GEOLINE3D = 103,
        
        GT_GEOREGION3D = 105,
        
        GT_GEOTEXT3D = 107,
        
        GT_GEOPLACEMARK = 108,
        
        GT_GEOMODEL = 1201,
        
        GT_PLOT = 3000
        
}GeometryType;



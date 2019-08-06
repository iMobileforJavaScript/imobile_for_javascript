//
//  GeoSpatialRefType.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

/** 该类定义了空间坐标系类型常量。
 <p> 空间坐标系类型，用以区分平面坐标系、地理坐标系、投影坐标系，其中地理坐标系又称为经纬度坐标系。 
 */
typedef enum {
   /** 平面坐标系。
         *   
         *  当坐标系为平面坐标系时，不能进行投影转换。
         */
    SPATIALREFT_NONEARTH = 0 ,
	
  /** 地理坐标系。
     *  
     *   地理坐标系由大地参照系、中央经线、坐标单位组成。在地理坐标系中，单位可以是度，分，秒。东西向（水平方向）的范围为-180度至180度。南北向（垂直方向）的范围为-90度至90度。
     */
    SPATIALREFT_EARTH_LONGITUDE_LATITUDE = 1 ,
	
  /** 投影坐标系。
     *   
    * 投影坐标系统由地图投影方式、投影参数、坐标单位和地理坐标系组成。SuperMap Objects Java 中提供了很多预定义的投影系统，用户可以直接使用，此外，用户还可以定制自己的投影系统。
     */
    SPATIALREFT_EARTH_LONGITUDE_PROJECTION = 2
    
}GeoSpatialRefType;
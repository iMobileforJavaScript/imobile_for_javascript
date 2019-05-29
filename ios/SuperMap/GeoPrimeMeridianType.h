//
//  GeoPrimeMeridianType.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//


 /// 该枚举定义了中央经线类型常量。
typedef enum {
	/// 用户自定义 。
    PRIMEMERIDIAN_USER_DEFINED = -1 ,    
	/// 格林威治本初子午线，即0°经线。
    PRIMEMERIDIAN_GREENWICH = 8901 ,  
	///  9°07'54".862 W。
    PRIMEMERIDIAN_LISBON = 8902 ,     
	///  2°20'14".025 E。   
    PRIMEMERIDIAN_PARIS = 8903 ,     
	///  74°04'51".3 W。   
    PRIMEMERIDIAN_BOGOTA = 8904 ,    
	/// 3°41'16".58 W。
    PRIMEMERIDIAN_MADRID = 8905 ,     
	///  12°27'08".4 E。
    PRIMEMERIDIAN_ROME = 8906 ,      
	/// 7°26'22".5 E。
    PRIMEMERIDIAN_BERN = 8907 ,       
	///  106°48'27".79 E。
    PRIMEMERIDIAN_JAKARTA = 8908 ,    
	///  17°40'00" W。
    PRIMEMERIDIAN_FERRO = 8909 ,     
	///  4°22'04".71 E。 
    PRIMEMERIDIAN_BRUSSELS = 8910 ,   
	/// 18°03'29".8 E。
    PRIMEMERIDIAN_STOCKHOLM = 8911 ,  
	/// 23°42'58".815 E。
    PRIMEMERIDIAN_ATHENS = 8912      
}GeoPrimeMeridianType;

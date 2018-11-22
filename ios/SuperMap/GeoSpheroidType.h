//
//  GeoSpheroidType.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//


 /// 该类定义了地球椭球体参数对象类型常量。
typedef enum {
	/// 用户自定义 类型。
    SPHEROID_USER_DEFINED          =   -1,    
	/// Airy 1830 
    SPHEROID_AIRY_1830				=   7001 ,  
	/// Airy modified 
    SPHEROID_AIRY_MOD				=   7002 ,   
	/// Average Terrestrial System 1977
    SPHEROID_ATS_1977				=   7041 ,  
	/// Australian National 
    SPHEROID_AUSTRALIAN			=   7003 ,   
	/// Bessel 1841
    SPHEROID_BESSEL_1841			=   7004 ,   
	/// Bessel modified
    SPHEROID_BESSEL_MOD			=   7005 ,   
	/// Bessel Namibia
    SPHEROID_BESSEL_NAMIBIA		=   7006 ,   
	/// Clarke 1858
    SPHEROID_CLARKE_1858			=   7007 ,   
	/// Clarke 1866  
    SPHEROID_CLARKE_1866			=   7008 ,   
	/// Clarke 1866 Michigan
    SPHEROID_CLARKE_1866_MICH		=   7009 ,  
	/// Clarke 1880
    SPHEROID_CLARKE_1880			=   7034 ,   
	/// Clarke 1880 (Arc)  
    SPHEROID_CLARKE_1880_ARC		=   7013 ,  
	/// Clarke 1880 (Benoit)
    SPHEROID_CLARKE_1880_BENOIT	=   7010 ,   
	/// Clarke 1880 (IGN) 
    SPHEROID_CLARKE_1880_IGN		=   7011 ,  
	/// Clarke 1880 (RGS)
    SPHEROID_CLARKE_1880_RGS		=   7012 ,  
    /// Clarke 1880 (SGA)
    SPHEROID_CLARKE_1880_SGA		=   7014 ,   
	/// Everest 1830
    SPHEROID_EVEREST_1830			=   7015 ,   
	/// Everest (definition 19  = 67)
    SPHEROID_EVEREST_DEF_1967		=   7016 ,  
	/// Everest (definition 1975) 
    SPHEROID_EVEREST_DEF_1975		=   7017 ,   
	///  Everest modified       
    SPHEROID_EVEREST_MOD			=   7018 ,   
	/// GEM gravity potential model  
    SPHEROID_GEM_10C				=   7031 , 
	/// GRS 1967 = International 1967
    SPHEROID_GRS_1967				=   7036 ,  
	/// GRS 1980   
    SPHEROID_GRS_1980				=   7019 ,  
	/// Helmert 1906
    SPHEROID_HELMERT_1906			=   7020 ,  
	/// Indonesian National
    SPHEROID_INDONESIAN			=   7021 ,   
	///  International 1924
    SPHEROID_INTERNATIONAL_1924	=   7022 ,   
	/// International 1967
    SPHEROID_INTERNATIONAL_1967	=   7023 ,   
	/// Krasovsky 1940   
    SPHEROID_KRASOVSKY_1940		=   7024 ,  
	/// Transit precise ephemeris  
    SPHEROID_NWL_9D				=   7025 ,   
	/// OSU 1986 geoidal model 
    SPHEROID_OSU_86F				=   7032 ,   
	///  OSU 1991 geoidal model
    SPHEROID_OSU_91A				=   7033 ,  
	/// Plessis 1817   
    SPHEROID_PLESSIS_1817			=   7027 ,  
	/// Authalic sphere 
    SPHEROID_SPHERE				=   7035 ,   
	/// Struve 1860  
    SPHEROID_STRUVE_1860			=   7028 ,   
	/// War Office	
    SPHEROID_WAR_OFFICE			=   7029 ,   
	/// NWL_10D
    SPHEROID_NWL_10D				=   7026 ,   
	/// WGS 1972 	
    SPHEROID_WGS_1972				=   7043 ,  
	/// WGS 1984
    SPHEROID_WGS_1984				=   7030 ,   
	/// WGS 1966
    SPHEROID_WGS_1966				=   (7001+33000) ,   
	/// Fischer 1960 
    SPHEROID_FISCHER_1960			=   (7002+33000) ,  
	/// Fischer 1968 
    SPHEROID_FISCHER_1968			=   (7003+33000) ,   
	/// Fischer modified
    SPHEROID_FISCHER_MOD			=   (7004+33000) ,  
	/// Hough 1960
    SPHEROID_HOUGH_1960			=   (7005+33000) ,   
	///  Everest modified 1969
    SPHEROID_EVEREST_MOD_1969		=   (7006+33000) ,  
	/// Walbeck
    SPHEROID_WALBECK				=   (7007+33000) ,  
	/// Authalic sphere (ARC/INFO)
    SPHEROID_SPHERE_AI				=   (7008+33000) ,   
	/// International 1975,Used By China Xian-1980 
    SPHEROID_INTERNATIONAL_1975    =   (7023+33000) ,  
    //{{added by qianjn in 2008-12-30 10:31:41 ‘ˆº”‘≠“Ú£∫÷–π˙◊Ó–¬±Í◊ºÕ∂”∞µƒÕ÷«ÚÃÂ£¨China 2000
    /// 中国最新标准投影的椭球体：China 2000。  
    SPHEROID_CHINA_2000			=   7044 
}GeoSpheroidType;
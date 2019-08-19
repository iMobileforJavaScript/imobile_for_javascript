//
//  ProjectionType.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//


///  该枚举定义了投影坐标系统的投影方式类型常量。
typedef enum ProjectionType
{
    ///非投影
	PRJT_NONPROJECTION					= 43000,	  
    ///Plate Carree
	PRJT_PLATE_CARREE				    = 43001,     
	///Equidistant Cylindrical
	PRJT_EQUIDISTANT_CYLINDRICAL		= 43002,      
	///Miller Cylindrical
	PRJT_MILLER_CYLINDRICAL			    = 43003,      
	/// Mercator
	PRJT_MERCATOR					    = 43004,      
    ///Gauss-Kruger
	PRJT_GAUSS_KRUGER				    = 43005,     
    ///Transverse Mercator ==43005
	PRJT_TRANSVERSE_MERCATOR			 = 43006,     
	///Albers
	PRJT_ALBERS                          = 43007,      
    ///Sinusoidal
	PRJT_SINUSOIDAL                      = 43008,     
    ///Mollweide
	PRJT_MOLLWEIDE                       = 43009,     
	
    ///Eckert VI
	PRJT_ECKERT_VI                       = 43010,      
	///Eckert V
	PRJT_ECKERT_V                        = 43011,      
	///Eckert IV
	PRJT_ECKERT_IV                       = 43012,      
	 ///Eckert III
	PRJT_ECKERT_III                      = 43013,     
	///Eckert II
	PRJT_ECKERT_II                       = 43014,      
	///Eckert I
	PRJT_ECKERT_I                        = 43015,      
	 ///Gall Stereographic
	PRJT_GALL_STEREOGRAPHIC              = 43016,     
	 ///Behrmann
	PRJT_BEHRMANN                        = 43017,     
	///Winkel I
	PRJT_WINKEL_I                        = 43018,      
	  ///Winkel II
	PRJT_WINKEL_II                       = 43019,    
	 ///Lambert Conformal Conic
	PRJT_LAMBERT_CONFORMAL_CONIC         = 43020,     
	///Polyconic
	PRJT_POLYCONIC                       = 43021,      
	///Quartic Authalic
	PRJT_QUARTIC_AUTHALIC                = 43022,      
	  ///Loximuthal
	PRJT_LOXIMUTHAL                      = 43023,    
	 ///Bonne
	PRJT_BONNE                           = 43024,     
	///Hotine
	PRJT_HOTINE                          = 43025,      
	///Stereographic
	PRJT_STEREOGRAPHIC                   = 43026,      
	 ///Equidistant Conic
	PRJT_EQUIDISTANT_CONIC               = 43027,     
	 ///Cassini
	PRJT_CASSINI                         = 43028,     
	///Van der Grinten I
	PRJT_VAN_DER_GRINTEN_I               = 43029,      
	///Robinson
	PRJT_ROBINSON                        = 43030,      
	 ///Two-Point Equidistant
	PRJT_TWO_POINT_EQUIDISTANT           = 43031,     
	 ///Equidistant Azimuthal
	PRJT_EQUIDISTANT_AZIMUTHAL           = 43032,     
	///Lambert Azimuthal Equal Area
	PRJT_LAMBERT_AZIMUTHAL_EQUAL_AREA    = 43033,      
	 ///Conformal Azimuthal
	PRJT_CONFORMAL_AZIMUTHAL		     = 43034,     
	///ortho_graphic 正射
	PRJT_ORTHO_GRAPHIC			        = 43035,      
	 ///Gnomonic 球心
	PRJT_GNOMONIC				        = 43036,     
	///中国全图方位投影
	PRJT_CHINA_AZIMUTHAL			    = 43037,      
	
     /// 空投影I
	PRJT_NONPROJECTION_I				= 43038,	 
	  /// 空投影II
	PRJT_NONPROJECTION_II				= 43039,    
     ///桑逊投影——正弦曲线等积伪圆柱投影
	PRJT_SANSON					        = 43040,	 
	 ///EqualArea Cylindrical
	PRJT_EQUALAREA_CYLINDRICAL          = 43041,     
	
	PRJT_HOTINE_AZIMUTH_NATORIGIN       = 43042,
	///斜轴墨卡托投影
	PRJT_OBLIQUE_MERCATOR				= 43043,		
	///Hotine斜轴墨卡托投影
	PRJT_HOTINE_OBLIQUE_MERCATOR		= 43044,		
	///正球墨卡托
	PRJT_SPHERE_MERCATOR				= 43045,			
	///南半球彭纳投影
	PRJT_BONNE_SOUTH_ORIENTATED			= 43046,		
	///Oblique stereographic , Esri 称为 double stereographic
	PRJT_OBLIQUE_STEREOGRAPHIC          = 43047,     
    
} ProjectionType;

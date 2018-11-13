//
//  BufferRadiusUnit.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#ifndef SM_iMobile_BufferRadiusUnit_h
#define SM_iMobile_BufferRadiusUnit_h

///  该枚举定义了缓冲区分析半径单位类型常量。
typedef enum{
    /// 毫米。
    MiliMeter = 10,          
	/// 厘米。
    CentiMeter = 100,       
	/// 分米。
    DeciMeter = 1000,       
	/// 米。
    Meter = 10000,         
    /// 千米。	
    KiloMeter = 10000000,  
    /// 码。	
    Yard = 9144,            
    /// 英寸。	
    Inch = 254,             
	/// 英尺。
    Foot = 3048,           
	/// 英里。
    Mile = 16090000,       
}BufferRadiusUnit;
#endif

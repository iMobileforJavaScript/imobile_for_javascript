//
//  Unit.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//


///该类定义了表示单位的类型常量。
typedef enum {
   ///  毫米。
    MILIMETER = 10,
    /// 平方毫米。
    SQUAREMILIMETER = 11,
	///  厘米。
    CENTIMETER = 100,
    /// 平方厘米。
    SQUARECENTIMETER = 101,
	/// 英寸。
    INCH = 254,
    /// 平方英寸。
    SQUAREINCH = 255,
	/// 分米。 
    DECIMETER = 1000,
    /// 平方分米。
    SQUAREDECIMETER = 1001,
	///  英尺。
    FOOT = 3048,
    ///  平方英尺。
    SQUAREFOOT = 3049,
	///  码。
    YARD = 9144,
    ///  平方码。
    SQUAREYARD = 9145,
	///  米。
    METER	= 10000,
    ///  平方米。
    SQUAREMETER	= 10001,
    /// 千米。
    KILOMETER = 10000000,
    /// 平方千米。
    SQUAREKILOMETER = 10000001,
	/// 平方英里。
    MILE      = 16090000,
    /// 英里。
    SQUAREMILE      = 16090001,
	///  秒。
    SECOND    = 1000000000 + 485,                  
	///  分。
    MINUTE    = 1000000000 + 29089,                
	///  度。
    DEGREE    = 1000000000 + 1745329,              
	/// 弧度。
    RADIAN    = 100000000 + 1000000000             
}Unit;

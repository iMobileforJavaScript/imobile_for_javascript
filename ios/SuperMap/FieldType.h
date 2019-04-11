//
//  FieldType.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//


#import <Foundation/Foundation.h>

/** 该枚举定义了字段类型常量。
 * 
 * 定义一系列常量表示存储不同类型值的字段。
 */
typedef enum{
	/// 布尔型字段。
    FT_BOOLEAN = 1,	 
	///字节型字段。
    FT_BYTE = 2,	 
	/// 16位整型字段。
    FT_INT16 = 3,	
	/// 32位整型字段。
    FT_INT32 = 4,	 
	/// 64位整型字段。
    FT_INT64 = 16,	 
	///  32位精度浮点型字段。
    FT_SINGLE = 6,	 
	/// 64位精度浮点型字段。
    FT_DOUBLE = 7,	 
	/// 时间型字段。
	FT_DATE = 8,     
	/// 日期型字段。
    FT_DATETIME = 23, 
	/// 二进制型字段。
    FT_LONGBINARY = 11, 
	/// 变长的文本型字段。
    FT_TEXT = 10,	 
    
	/** 定长的文本类型字段。
	* 
	*<p> 例如指定的字符串长度为10，那么输入的字符串只有3个字符，则其他都用0来占位。
	*/ 
    FT_CHAR = 18,
	/// 宽字符类型字段。
    FT_WTEXT = 127  
}FieldType;

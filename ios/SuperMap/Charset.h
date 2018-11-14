//
//  Charset.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//



///该类定义了矢量数据集的字符集类型常量。 
typedef enum {
	///ASCII 字符集。
    ANSI       = 0,

	///扩展的 ASCII 字符集。
    CH_DEFAULT    = 1,

	///符号字符集。
    SYMBOL     = 2,
	
	/// Macintosh 使用的字符。
    MAC        = 77,

	///日语字符集。
    SHIFTJIS   = 128,

	///朝鲜字符集的其它常用拼写。
    HANGEUL    = 129,
	
	///朝鲜字符集。
    JOHAB      = 130,

	///在中国大陆使用的中文字符集。
    GB18030    = 134,

	///在中国香港特别行政区和台湾最常用的中文字符集。
    CHINESEBIG5  = 136,

	///希腊字符集。
    GREEK      = 161,

	///土耳其语字符集。
    TURKISH    = 162,

	///越南语字符集。
    VIETNAMESE = 163,
	
	///希伯来字符集。
    HEBREW     = 177,

	///阿拉伯字符集。

    ARABIC     = 178,

	///波罗的海字符集。

    BALTIC     = 186,

	///俄语字符集。

    RUSSIAN    = 204,

	///泰语字符集。

    THAI       = 222,

	///东欧字符集。

    EASTEUROPE = 238,

	///扩展的 ASCII 字符集。

    OEM        = 255,

	///UTF-8（8 位元 Universal Character Set/Unicode Transformation Format）是针对Unicode 的一种可变长度字符编码。它可以用来表示 Unicode 标准中的任何字符，而且其编码中的第一个字节仍与 ASCII 相容，使得原来处理 ASCII 字符的软件无需或只作少部份修改后，便可继续使用。
    UTF8       = 250, 

	///UTF-7 (7-位元 Unicode 转换格式（Unicode Transformation Format，简写成 UTF）) 是一种可变长度字符编码方式，用以将 Unicode 字符以 ASCII 编码的字符串来呈现。
    UTF7       = 7,

	///UTF-32 (or UCS-4)是一种将 Unicode 字符编码的协定， 对每一个 Unicode 码位使用恰好32位元。
    UTF32      = 8,

	///英文常用的编码。Windows1252（Window 9x标准for西欧语言）。
    WINDOWS1252  = 137,

	///韩语字符集。
    KOREAN     = 131,

	///在计算机科学领域中，Unicode（统一码、万国码、单一码、标准万国码）是业界的一种标准。
    UNICODE    = 132,

	///Cyrillic (Windows)
    CYRILLIC   = 135,

	///IA5
    XIA5       = 3,

	///IA5 (German)
    XIA5GERMAN = 4,

	///IA5 (Swedish)
    XIA5SWEDISH  = 5,

	///IA5 (Norwegian)
    XIA5NORWEGIAN  = 6
    
}Charset;

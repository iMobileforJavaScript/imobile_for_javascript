//
//  ThemeType.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//


///  该类定义了专题图类型常量。
typedef enum {

  ///无专题图 。
    TT_None = 0,
	
/** 单值专题图。
     *  
    *  单值专题图中，专题变量的值相同的要素归为一类，为每一类设定一种渲染风格，如颜色或符号等，作为专题变量的字段或表达式的值相同的要素采用相同的渲染风格，从而用来区分不同的类别。
     */
    TT_Unique = 1,
	
 /** 分段专题图。
     * 
       *   在分段专题图中，专题变量的值被分成多个范围段，在同一个范围段中要素或记录使用相同的颜色或符号风格进行显示。可使用的分段的方法有等距离分段法，平方根分段法，标准差分段法，对数分段法，等计数分段法。分段专题图所基于的专题变量必须为数值型。
     */
    TT_Range = 2,
	
    //! \brief GRAPH专题图
    TT_Graph = 	3,
    
    //! \brief GRADUATED_SYMBOL专题图
    TT_GraduatedSymbol = 4,
    
    //! \brief DENSITY专题图
    TT_DotDensity =		5,
    
    //	TT_SymbolShade =	6,	//SYMBOL_SHADE专题图
    
    //! \brief LABEL专题图
	/// 标签专题图 。
    TT_label	= 7,
	
	///自定义专题图 。
    TT_Custom = 8,
    
    //! \brief GRIDUNIQUE专题图
    TT_GridUnique = 11,
    //! \brief GRIDRANGE专题图
    TT_GridRange = 	12,
    //! \brief 扩展专题图
    TT_Plugin = 13,
    
}ThemeType;
//
//  QueryOption.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#ifndef SM_iMobile_QueryOption_h
#define SM_iMobile_QueryOption_h


/// 查询结果类型枚举类。
typedef enum {


	///查询结果中只有属性。
    ATTRIBUTE = 0,                   


	///查询结果中包含属性和几何对象。
    ATTRIBUTEANDGEOMETRY = 1,       

	 ///查询结果中只有几何对象。
    GEOMETRY = 2,                    
}QueryOption;

#endif

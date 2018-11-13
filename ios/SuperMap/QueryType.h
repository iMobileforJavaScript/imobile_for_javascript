//
//  QueryType.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//


 /// 该类定义了空间查询操作算子类型常量。
typedef enum {
	///  一般查询
    GENERAL = 0 ,  
	/// 范围查询 
    BOUNDS = 1 , 
	/// ID 查询 
    IDS = 2      
}QueryType;

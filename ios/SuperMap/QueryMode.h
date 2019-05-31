//
//  QueryMode.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#ifndef SM_iMobile_QueryMode_h
#define SM_iMobile_QueryMode_h

/**
* 该类定义了针对iServer进行查询操作模式的类型常量。
*/
typedef enum {
	/// Sql查询。
    SqlQuery = 0,                   
	/// 最近地物查询。  
    FindNearest = 1,                
	/// 距离查询。
    DistanceQuery = 2,              
	/// 空间查询。
    SpatialQuery = 3,               
	/// 范围查询。  
    BoundsQuery = 4,                
}QueryMode;

#endif

//
//  JoinType.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#ifndef SM_iMobile_JoinType_h
#define SM_iMobile_JoinType_h

/** 该类定义了定义两个表之间连接类型常量。
* 
* 该类用于对相连接的两个表之间进行查询时，决定了查询结果中得到的记录的情况。
*/
typedef enum{
	/// 完全内连接，只有两个表中都有相关的记录才加入查询结果集。
    INNERJOIN =0,   
	/// 左连接，左边表中所有查询记录进入查询结果集中，右边表中无相关的记录则其对应的字段值显示为空。
    LEFTJOIN =1,    
   // RIGHTJOIN =2,    // 右连接
   // FULLJOIN =3     // 全连接
    
}JoinType;

#endif

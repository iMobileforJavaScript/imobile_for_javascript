//
//  BufferEndType.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#ifndef SM_iMobile_BufferEndType_h
#define SM_iMobile_BufferEndType_h
/** 该类定义了缓冲区端点类型常量。
*
 *  用以区分线对象缓冲区分析时的端点是圆头缓冲还是平头缓冲。</p>
 */
typedef enum{
    /// 圆头缓冲。圆头缓冲区是在生成缓冲区时，在线段的端点处做半圆弧处理。
    ROUND = 1, 
	/// 平头缓冲。平头缓冲区是在生成缓冲区时，在线段的端点处做圆弧的垂线。
    FLAT = 2,  
}BufferEndType;
#endif

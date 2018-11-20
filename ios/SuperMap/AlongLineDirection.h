//
//  AlongLineDirection.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#ifndef SM_iMobile_AlongLineDirection_h
#define SM_iMobile_AlongLineDirection_h

/** 该类定义了标签沿线标注方向类型常量。
*
*  路线与水平方向的锐角夹角在60度以上表示上下方向，60度以下表示左右方向。
*/
typedef enum{
    /// 沿线的法线方向放置标签。
    ALONG_LINE_NORMAL = 0,          
	/// 从上到下，从左到右放置。
    LEFT_TOP_TO_RIGHT_BOTTOM = 1,   
	/// 从上到下，从右到左放置。
    RIGHT_TOP_TO_LEFT_BOTTOM = 2,   
	/// 从下到上，从左到右放置。
    LEFT_BOTTOM_TO_RIGHT_TOP = 3,   
	/// 从下到上，从右到左放置。
    RIGHT_BOTTOM_TO_LEFT_TOP = 4,   
}AlongLineDirection;

#endif

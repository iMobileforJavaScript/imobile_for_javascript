//
//  OverLengthLabelMode.h
//  ObjectDemo
//
//  Created by iMobile on 13-7-19.
//
//

#ifndef ObjectDemo_OverLengthLabelMode_h
#define ObjectDemo_OverLengthLabelMode_h
/** 该类定义了标签专题图中超长标签的处理模式类型常量。
 <p>用以区分线对象缓冲区分析时的端点是圆头缓冲还是平头缓冲。
 */
typedef enum {
	/// 最对超长标签不进行处理。此为默认模式，即在一行中全部显示此超长标签。
    SM_NONE = 0, 
    /// 省略超出部分。此模式将超长标签中超出指定的标签最大长度（MaxLabelLength）的部分用省略号表示。
    SM_OMIT = 1,  
    /// 换行显示。此模式将超长标签中超出指定的标签最大长度的部分换行显示，即用多行来显示超长标签。
    SM_NEWLINE = 2,  

}smOverLengthLabelMode;

#endif

//
//  ThemeGraphType.h
//  HotMap
//
//  Created by zhouyuming on 2019/4/28.
//  Copyright © 2019年 imobile-xzy. All rights reserved.
//

//#ifndef ThemeGraphType_h
//#define ThemeGraphType_h
//
//
//#endif /* ThemeGraphType_h */

///  该类定义了专题图类型常量。
typedef enum {
    
    //面积图
    TGT_Area = 0,
    
    //阶梯图
    TGT_Step = 1,
    
    //折线图
    TGT_Line = 2,
    
    //点状图
    TGT_Point = 3,
    
    //柱状图
    TGT_Bar = 4,
    
    //三维柱状图
    TGT_Bar3D = 5,
    
    //饼图
    TGT_Pie = 6,
    
    //三维饼图
    TGT_Custom = 7,
    
    //玫瑰图
    TGT_Rose = 8,
    //三维饼图
    TGT_Rose3D =9,
    //条状金字塔图
    //面状金字塔图
    //堆叠柱状图
    TGT_Stack_Bar = 12,
    //三维堆叠柱状图
    TGT_Stack_Bar3D = 13,
    //环状图
    TGT_Ring = 14,
    
}ThemeGraphType;

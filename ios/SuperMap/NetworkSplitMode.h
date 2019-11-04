//
//  NetworkSplitMode.h
//  SuperMap
//
//  Created by zhouyuming on 2019/10/23.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#ifndef NetworkSplitMode_h
#define NetworkSplitMode_h
/**
 * @brief 该类定义了用在行驶导引子项类中的转弯方向的型常量。
 */

typedef enum {
    
    NSM_NONE = 0,  //不打断
    
    NSM_LINE_SPLIT_BY_POINT = 1,  //点打断线
    
    NSM_LINE_SPLIT_BY_POINT_AND_LINE = 2,  //线与线打断，同时点打断线
    
    NSM_TOPOLOGY_PROCESSING = 3, //拓扑处理方式处理几何对象
    
}NetworkSplitMode;

#endif /* NetworkSplitMode_h */

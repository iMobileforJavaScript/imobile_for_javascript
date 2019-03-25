//
//  TurnType.h
//  prjTest
//
//  Created by imobile on 14-2-20.
//  Copyright (c) 2014年 imobile. All rights reserved.
//

#ifndef SM_iMobile_TurnType_h
#define SM_iMobile_TurnType_h

/**
 * @brief 该类定义了用在行驶导引子项类中的转弯方向的型常量。
 */

typedef enum {
    
    TURN_END = 0,  //终点，不转弯
    
    TURN_LEFT = 1, //左转弯
    
    TURN_RIGHT = 2,  //右转弯
    
    TURN_AHEAD = 3, //向前直行
    
    TURN_BACK = 4,  //掉头
    
    TURN_NONE = 255 //无效值
    
}TurnType;

#endif

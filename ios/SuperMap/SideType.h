//
//  SideType.h
//  prjTest
//
//  Created by imobile on 14-2-20.
//  Copyright (c) 2014年 imobile. All rights reserved.
//

#ifndef SM_iMobile_SideType_h
#define SM_iMobile_SideType_h

/**
 * @brief 该类定义了用在行驶导引子项类中的表示在路的左边、右边还是在路上的类型常量。
 */
typedef enum {
    
    SIDE_NONE = -1,       //无效值
    
    SIDE_MIDDLE = 0,     //在路上（路的中间）
    
    SIDE_LEFT = 1 ,     //路的左侧
    
    SIDE_RIGHT = 2      //路的右侧
    
}SideType;

#endif

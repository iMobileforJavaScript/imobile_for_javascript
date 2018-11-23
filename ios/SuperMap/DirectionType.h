//
//  DirectionType.h
//  prjTest
//
//  Created by imobile on 14-2-12.
//  Copyright (c) 2014年 imobile. All rights reserved.
//

#ifndef SM_iMobile_DirectionType_h
#define SM_iMobile_DirectionType_h

/**
 * 定义了用在行驶导引子项类中方向类型常量
 */

typedef enum {
   
    Dir_EAST = 0,  //东
 
    Dir_SOUTH = 1, //南
 
    Dir_WEST = 2,  //西
    
    Dir_NORTH = 3, //北
    
    Dir_NONE = 255, //结点没有方向
    
}DirectionType;


#endif

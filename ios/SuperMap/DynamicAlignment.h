//
//  DynamicAlignment.h
//  TourApp
//
//  Created by Ryan on 15-1-28.
//  Copyright (c) 2015年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    /// 左对齐。
    DYN_LEFT = 0,
    /// 上对齐。
    DYN_TOP = 1,
    /// 右对齐。
    DYN_RIGHT = 2,
    /// 下对齐。
    DYN_BOTTOM = 3,
    /// 中心对齐。
    DYN_CENTER = 4,
    //左上
    DYN_LEFT_TOP,
    //右上
    DYN_RIGHT_TOP,
    //左下
    DYN_LEFT_BOTTOM,
    //右下
    DYN_RIGHT_BOTTOM,
    
}DynamicAlignment;


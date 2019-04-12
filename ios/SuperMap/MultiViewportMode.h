//
//  MultiViewportMode.h
//  LibUGC
//
//  Created by zyd on 16/10/20.
//  Copyright © 2016年 beijingchaotu. All rights reserved.
//

#ifndef MultiViewportMode_h
#define MultiViewportMode_h

typedef NS_ENUM(NSInteger, RealspaceMultiViewportMode) {
    RealspaceMultiViewportModeNone = 0,     // 非多视口，也就是只有一个视口
    RealspaceMultiViewportModeHorizontal,   // 水平跨越多视口
    RealspaceMultiViewportModeVertical,     // 垂直跨越多视口
    RealspaceMultiViewportModeQuad,         // 四视口
    RealspaceMultiViewportModeTriple,       // 三分屏（水平方向上）
};

#endif /* MultiViewportMode_h */

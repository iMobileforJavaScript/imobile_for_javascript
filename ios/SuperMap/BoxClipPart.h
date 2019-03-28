//
//  BoxClipPart.h
//  LibUGC
//
//  Created by zyd on 2018/4/18.
//  Copyright © 2018年 beijingchaotu. All rights reserved.
//

#ifndef BoxClipPart_h
#define BoxClipPart_h

// 裁剪面裁剪模式
typedef enum {
    BoxClipPartNothing,         //不裁剪
    BoxClipPartInner,           //裁剪掉盒子内部的部分
    BoxClipPartOuter,           //裁剪掉盒子外部的部分
    BoxClipPartOnlyKeepLine,    //只保留裁剪线
} BoxClipPart;

#endif /* BoxClipPart_h */

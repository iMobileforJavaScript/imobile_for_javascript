//
//  SymbolMarker.h
//  LibUGC
//
//  Created by wnmng on 2018/8/13.
//  Copyright © 2018年 beijingchaotu. All rights reserved.
//

#import "Symbol.h"

@class Point2D,SymbolMarkerStroke;

// 点符号类
@interface SymbolMarker : Symbol

// 点符号原点
@property(nonatomic,strong) Point2D *origin;
// 计算点符号显示尺寸
-(int) computeDisplaySize:(int)nSymbolSize;
-(int) computeSymbolSize:(int )nDispalySize;
// 获得点符号构成笔画数
-(int)getStrokeCount;
// 获得点符号构成笔画
-(SymbolMarkerStroke*)getStroke:(int)index;

-(void)dispose;

@end

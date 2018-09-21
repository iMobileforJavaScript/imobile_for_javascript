//
//  SymbolMarkerStroke.h
//  LibUGC
//
//  Created by wnmng on 2018/8/13.
//  Copyright © 2018年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StrokeType.h"

// 构成点符号的基本笔画
@interface SymbolMarkerStroke : NSObject
-(id)init;
-(void)dispose;
// 获得基本笔画类型
-(StrokeType)getStrokeType;
@end

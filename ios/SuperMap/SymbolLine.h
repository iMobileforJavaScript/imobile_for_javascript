//
//  SymbolLine.h
//  LibUGC
//
//  Created by wnmng on 2018/8/15.
//  Copyright © 2018年 beijingchaotu. All rights reserved.
//

#import "Symbol.h"

// 线填充符号类
@interface SymbolLine : Symbol

-(void)dispose;

// 线符号用到的第三方点符号的id
-(NSArray*)customizedPointSymbolIDs;

@end

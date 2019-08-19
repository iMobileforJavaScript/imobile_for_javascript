//
//  SymbolFill.h
//  LibUGC
//
//  Created by wnmng on 2018/8/15.
//  Copyright © 2018年 beijingchaotu. All rights reserved.
//

#import "Symbol.h"
// 面填充符号类
@interface SymbolFill : Symbol

// 填充符号用到的第三方点符号的id
-(NSArray*)customizedPointSymbolIDs;

-(void)dispose;
@end

//
//  SymbolMarkerStroke.h
//  LibUGC
//
//  Created by wnmng on 2018/8/13.
//  Copyright © 2018年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StrokeType.h"

@interface SymbolMarkerStroke : NSObject
-(id)init;
-(void)dispose;
-(StrokeType)getStrokeType;
@end

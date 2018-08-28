//
//  SymbolMarker.h
//  LibUGC
//
//  Created by wnmng on 2018/8/13.
//  Copyright © 2018年 beijingchaotu. All rights reserved.
//

#import "Symbol.h"

@class Point2D,SymbolMarkerStroke;

@interface SymbolMarker : Symbol

@property(nonatomic,strong) Point2D *origin;

-(int) computeDisplaySize:(int)nSymbolSize;

-(int)getStrokeCount;

-(SymbolMarkerStroke*)getStroke:(int)index;

-(void)dispose;

@end

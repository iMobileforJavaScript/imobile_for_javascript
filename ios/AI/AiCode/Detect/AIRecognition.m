//
//  AIRecognition.m
//  SuperMapAI
//
//  Created by zhouyuming on 2019/11/14.
//  Copyright © 2019年 wnmng. All rights reserved.
//

#import "AIRecognition.h"

@implementation AIRecognition
@synthesize label,confidence,rect,displayColor,count;

-(id)initWith:(NSString *)name confidence:(float)value rect:(CGRect)bounds displayColor:(nonnull UIColor *)color count:(int)nCount{
    if (self = [super init]) {
        label = name;
        confidence = value;
        rect = bounds;
        displayColor = color;
        count = nCount;
    }
    return self;
}
@end

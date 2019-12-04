//
//  Recognition.m
//  SuperMapAI
//
//  Created by zhouyuming on 2019/11/13.
//  Copyright © 2019年 wnmng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recognition.h"

@implementation Recognition
@synthesize label,confidence;

-(id)initWith:(NSString *)name confidence:(float)value{
    if (self = [super init]) {
        label = name;
        confidence = value;
    }
    return self;
}

@end

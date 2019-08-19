//
//  TranslateAnimator.h
//  TestProject
//
//  Created by imobile on 14-8-14.
//  Copyright (c) 2014年 imobile. All rights reserved.
//

#import "Animator.h"
#import <UIKit/UIKit.h>

@class Point2D;
@interface TranslateAnimator : Animator
{
    CGPoint _offest;
}


@property(nonatomic,assign)CGPoint offest;


-(id)initWithOffest:(Point2D*)destinationPos durTime:(float)time;
@end

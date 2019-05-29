//
//  SpinAnimatior.h
//  TestProject
//
//  Created by imobile on 14-8-16.
//  Copyright (c) 2014年 imobile. All rights reserved.
//

#import "Animator.h"

@interface SpinAnimatior : Animator
{
    float _rotaAngle;
}
@property(nonatomic,assign)float rotaAngle;

-(id)initWithRota:(float)rotaAngle durTime:(float)time;
@end

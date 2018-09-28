//
//  JSSceneView.m
//  Supermap
//
//  Created by 王子豪 on 2017/8/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSSceneView.h"

@interface JSSceneView()
{
    NSTimer* timer;
    UIView* oldView;
}
@end
@implementation JSSceneView

-(id)init{
    
     UIWindow *si  = [[UIApplication sharedApplication].windows objectAtIndex:0];
    oldView = si.subviews[0];
    if(self=[super init]){
        if (_sceneCtrl==nil) {
            _sceneCtrl = [[SceneControl alloc]init];
            _sceneCtrl.multipleTouchEnabled = YES;
           //  [self addSubview:_sceneCtrl];
            [_sceneCtrl setFrame:self.bounds];
            id target=_sceneCtrl;
            while (target) {
                target = ((UIResponder *)target).nextResponder;
                if ([target isKindOfClass:[UIViewController class]]) {
                    break;
                }
            }
            [_sceneCtrl initSceneControl:(UIViewController*)target];
        }
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(change) userInfo:nil repeats:YES];
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//static bool b = false;
-(void)change{
    if([_sceneCtrl.superview isEqual:self]){
        [timer invalidate];
        timer = nil;
    }else{
        UIWindow *si  = [[UIApplication sharedApplication].windows objectAtIndex:0];
        [_sceneCtrl removeFromSuperview];
        [si addSubview:oldView];
        [self addSubview:_sceneCtrl];
        [_sceneCtrl setFrame:self.bounds];
        oldView = nil;
    }
}

-(void)layoutSubviews{
 
    
   
}
@end

//
//  JSSceneView.m
//  Supermap
//
//  Created by 王子豪 on 2017/8/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSSceneView.h"
#import "SScene.h"

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
//            [_sceneCtrl setFrame:self.bounds];
            [_sceneCtrl initSceneControl:nil windows:nil];
            [SScene setInstance:_sceneCtrl];
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [oldView removeFromSuperview];
        [_sceneCtrl.superview addSubview:oldView];
        [_sceneCtrl removeFromSuperview];
        [self addSubview:_sceneCtrl];
        
    });
    return self;
}

-(void)layoutSubviews{
 
    
   
}

-(void)dealloc{
    NSLog(@"scence destory !!!");
}
@end

//
//  JSSceneView.m
//  Supermap
//
//  Created by 王子豪 on 2017/8/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSSceneView.h"


@implementation JSSceneView

-(id)init{
    
    if(self=[super init]){
        if (_sceneCtrl==nil) {
            _sceneCtrl = [[SceneControl alloc]init];
            _sceneCtrl.multipleTouchEnabled = true;
             [self addSubview:_sceneCtrl];
            
            [_sceneCtrl setFrame:self.bounds];
            //UIViewController* vc = [[UIViewController alloc]init];
            //[_sceneCtrl addSubview:vc.view];
            
        }
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    UIViewController* target= [self getCurrentVC];
//    while (target) {
//        target = ((UIResponder *)target).nextResponder;
//        if ([target isKindOfClass:[UIViewController class]]) {
//            NSLog(@"%@",target);
//            break;
//        }
//    }
    [_sceneCtrl initSceneControl:target];
    //_sceneCtrl.hidden = YES;
}
@end

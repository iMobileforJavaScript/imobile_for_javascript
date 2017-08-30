//
//  JSSceneView.m
//  Supermap
//
//  Created by 王子豪 on 2017/8/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSSceneView.h"


@implementation JSSceneView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)layoutSubviews{
 
    if (_sceneCtrl==nil) {
        _sceneCtrl = [[SceneControl alloc]init];
    }
    [_sceneCtrl setFrame:self.bounds];
    [self addSubview:_sceneCtrl];
    id target=_sceneCtrl;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    [_sceneCtrl initSceneControl:(UIViewController*)target];
}
@end

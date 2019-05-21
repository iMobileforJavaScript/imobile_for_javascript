//
//  Orientation.m
//  iTablet
//
//  Created by supermap on 2019/5/21.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import "SOrientation.h"

@interface SOrientation()

@end

@implementation SOrientation
//添加方向监听
-(id) initDelegateWithTarget:(id)target{
    self = [super init];
    //默认竖直方向
    self.orientation = UIInterfaceOrientationPortrait;
    [self addApplicationOrientationObserve:target];
    return self;
}

-(void) addApplicationOrientationObserve:(id)target{
  [[NSNotificationCenter defaultCenter] addObserver:target selector:@selector(handleDeviceOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}
-(void)handleDeviceOrientationChanged:(NSNotification *)notification{
}

-(void)removeOrientationObserverWithId:(id)ID{
    [[NSNotificationCenter defaultCenter]removeObserver:ID];
}
@end

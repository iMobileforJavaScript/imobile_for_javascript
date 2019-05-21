//
//  Orientation.h
//  iTablet
//
//  Created by supermap on 2019/5/21.
//  Copyright © 2019年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol  OrientationChangeDelegate;

@interface SOrientation : NSObject
//当前设备方向
@property(nonatomic,assign) UIInterfaceOrientation orientation;

@property(nonatomic,assign) id<OrientationChangeDelegate> OrientationChangeDelegate;

-(id) initDelegateWithTarget:(id)target;
-(void)removeOrientationObserverWithId:(id)ID;

@end

@protocol OrientationChangeDelegate <NSObject>
@required
-(void)handleDeviceOrientationChanged:(NSNotification *)notification;

@end

//
//  NavigationOnline.h
//  LibUGC
//
//  Created by wnmng on 2017/9/15.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NavigationOnlineParamater.h"
#import "NavigationOnlineData.h"
#import "OnlinePathInfo.h"

@protocol  NavigationOnlineCallback<NSObject>
@required
-(void)caculateSuccess:(NavigationOnlineData*)data;
-(void)caculateFailed:(NSString *)errorInfo;

@end

@interface NavigationOnline : NSObject

@property (nonatomic) id<NavigationOnlineCallback> delegate;

-(void)setKey:(NSString*)strKey;

-(NavigationOnlineData*)routeAnalyst:(NavigationOnlineParamater*)param;


@end

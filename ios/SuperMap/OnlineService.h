//
//  OnlineService.h
//  LibUGC
//
//  Created by wnmng on 2017/9/13.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^OnlineServiceCompletionCallback)(NSError *error);
typedef void(^OnlineServiceInfoCompletionCallback)(NSDictionary *info, NSError *error);


@interface OnlineService : NSObject

+ (instancetype)sharedService;

// 登录
- (void)loginWithUsername:(NSString *)username password:(NSString *)password completionCallback:(OnlineServiceCompletionCallback)completionCallback;

// 登出
- (void)logoutWithCompletionCallback:(OnlineServiceCompletionCallback)completionCallback;

// 获取账号信息
- (void)infoWithCompletionCallback:(OnlineServiceInfoCompletionCallback)completionCallback;



@end

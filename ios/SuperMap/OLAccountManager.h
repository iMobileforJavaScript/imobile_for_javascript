//
//  OLAccountManager.h
//  LibUGC
//
//  Created by zyd on 17/1/17.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OLAccountManagerCompletionHandler)(NSError *error);
typedef void(^OLAccountManagerInfoCompletionHandler)(NSDictionary *info, NSError *error);
typedef void(^OLAccountManagerServiceCompletionHandler)(NSArray *services, NSError *error);

@interface OLAccountManager : NSObject

+ (id)sharedManager;

// 登录
- (void)loginWithUsername:(NSString *)username password:(NSString *)password completionHandler:(OLAccountManagerCompletionHandler)completionHandler;

// 登出
- (void)logoutWithCompletionHandler:(OLAccountManagerCompletionHandler)completionHandler;

// 获取账号信息
- (void)infoWithCompletionHandler:(OLAccountManagerInfoCompletionHandler)completionHandler;

// 获取公用服务
- (void)publicServiceWithCompletionHandler:(OLAccountManagerServiceCompletionHandler)completionHandler;

// 获取私有服务
- (void)privateServiceWithCompletionHandler:(OLAccountManagerServiceCompletionHandler)completionHandler;

@end

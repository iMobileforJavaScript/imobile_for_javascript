//
//  OnlineService3D.h
//  LibUGC
//
//  Created by zyd on 17/10/11.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OnlineService3DCompletionCallback)(NSArray *services, NSError *error);

@interface OnlineService3D : NSObject

// 获取公用服务
- (void)publicServiceWithCompletionCallback:(OnlineService3DCompletionCallback)completionCallback;

// 获取私有服务
- (void)privateServiceWithCompletionCallback:(OnlineService3DCompletionCallback)completionCallback;

@end

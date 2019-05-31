//
//  LogInfoService.h
//  HotMap
//
//  Created by zhouyuming on 2019/5/9.
//  Copyright © 2019年 imobile-xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogInfoService : NSObject

//发送日志信息 info字典为额外的日志信息
+(void)sendAPPLogInfo:(NSMutableDictionary*)info completionHandler:(void(^)(BOOL result))completionHandler;

//获取app信息
+(NSMutableDictionary*)getAppInfo;

@end

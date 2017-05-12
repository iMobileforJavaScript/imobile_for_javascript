//
//  STOMPSender.h
//  MessageQueue
//
//  Created by imobile on 15/6/9.
//  Copyright (c) 2015年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STOMPSender : NSObject

//给指定name的队列或订阅发送消息message
-(void)sendMessage:(NSString*)message;
//必须显示调用来释放资源
-(void)dispose;

@end

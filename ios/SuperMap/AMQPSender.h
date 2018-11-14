//
//  AMQPSender.h
//  MessageQueue
//
//  Created by imobile on 15/5/28.
//  Copyright (c) 2015年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMQPSender : NSObject

//发送
-(void)sendMessage:(NSString*)exchange routingKey:(NSString*)routingKey message:(NSString*)message;
//释放占用
-(void)dispose;
@end

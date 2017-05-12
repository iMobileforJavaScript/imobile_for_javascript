//
//  AMQPReceiver.h
//  MessageQueue
//
//  Created by imobile on 15/5/28.
//  Copyright (c) 2015年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMQPReceiver : NSObject

//接受消息，消息通过参数message传出，阻塞等待消息，需要在子线程执行
-(void)receiveMessage:(NSString**)name message:(NSString**)message;
//释放占用
-(void)dispose;
@end

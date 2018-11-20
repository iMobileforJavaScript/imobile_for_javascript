//
//  AMQPManager.h
//  MessageQueue
//
//  Created by imobile on 15/5/28.
//  Copyright (c) 2015年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMQPReceiver;
@class AMQPSender;

typedef enum{
    Direct=0,
    Fanout,
    Topic,
}AMQPExchangeType;


//amqp 管理类，负责队列，交换机，接收端，发送端的创建，以及绑定。使用前需要连接服务器。
@interface AMQPManager : NSObject

+(AMQPManager*)newAmqpManager;
//连接服务 参数: ip 端口  虚拟机主机  账户 密码
-(BOOL)connection:(NSString*)ip port:(int)port hostname:(NSString*)hostName usrname:(NSString*)usrName password:(NSString*)password clientId:(NSString*)clientId;
//断开连接
-(void)disconnection;
//创建发送端
-(AMQPSender*)newSender;
//创建接受端
-(AMQPReceiver*)newReceiver:(NSString*)queue;
//创建一个交换器，参数：交换机名  交换机类型
-(BOOL)declareExchange:(NSString*)exchange Type:(AMQPExchangeType)type;
//删除交换机 参数：交换机名
-(BOOL)deleteExchange:(NSString*)exchange;
//创建队列 参数：队列名
-(BOOL)declareQueue:(NSString*)queue;
//删除队列 参数：队列名
-(BOOL)deleteQueue:(NSString*)queue;
//绑定交换机，队列，路由键值
-(BOOL)bindQueue:(NSString*)queue exchange:(NSString*)exchange routingkey:(NSString*)routingKey;
//解除绑定
-(BOOL)unbindQueue:(NSString*)queue exchange:(NSString*)exchange routingkey:(NSString*)routingKey;

-(BOOL)resume;
-(void)suspend;
@end

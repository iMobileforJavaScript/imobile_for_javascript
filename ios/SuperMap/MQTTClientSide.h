//
//  MQTTClientSide.h
//  MessageQueue
//
//  Created by imobile on 15/5/29.
//  Copyright (c) 2015年 imobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MQTTClientSide : NSObject

//只能获取，不能设置
@property(nonatomic,strong,readonly)NSString* clientId;
//创建并连接客户端
-(BOOL)create:(NSString*)serverURI username:(NSString*)userName password:(NSString*)passWord clientId:(NSString*)clientId;
//订阅名称为topic的主题，pos 传输质量
-(BOOL)subscribe:(NSString*)topic quality:(int)pos;
//取消订阅名为topic的主题
-(BOOL)unsubscribe:(NSString*)topic;
//取消连接，并销毁对象
-(void)dispose;
//给topic主题发送message消息
-(BOOL)sendMessage:(NSString*)topic message:(NSString*)message;
//获取名为topic的主题消息message
-(void)receiveMessage:(NSString**)topic message:(NSString**)message;

-(BOOL)resume;
-(void)suspend;
@end

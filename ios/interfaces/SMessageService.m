//
//  SMessageService.m
//  Supermap
//
//  Created by imobile-xzy on 2019/3/13.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "SMessageService.h"
#import "Constants.h"
#import "SuperMap/AMQPManager.h"
#import "SuperMap/AMQPReceiver.h"
#import "SuperMap/AMQPSender.h"


@interface SMessageService()
{
    //

    
    //AMQPSender* g_messageAMQPSender;
    
//    AMQPManager* g_fileAMQPManager;
//    AMQPSender* g_fileAMQPSender;
}
@end
//静态的，保证线程能共享
static AMQPManager* g_AMQPManager;
static AMQPSender* g_AMQPSender;
static AMQPReceiver* g_AMQPReceiver;
static BOOL bStopRecieve = true;
//
//分发消息的交换机
static NSString* sExchange = @"message";
//分发群消息的交换机
static NSString* sGroupExchange = @"message.group";

@implementation SMessageService
#pragma mark -- 定义宏，让该类暴露给RN层
RCT_EXPORT_MODULE();
- (NSArray<NSString *> *)supportedEvents{
    return @[MESSAGE_SERVICE_RECEIVE];
}

#pragma mark -- 连接服务
RCT_REMAP_METHOD(connectService, ip:(NSString*)serverIP port:(int)port hostName:(NSString*)hostName userName:(NSString*)userName passwd:(NSString*)passwd userID:(NSString*)userID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    if(g_AMQPManager){
        [g_AMQPManager suspend];
    }
    g_AMQPReceiver = nil;
    g_AMQPSender = nil;
    g_AMQPManager = nil;
    
    //假如有接收线程未停止，在这等待
    while (!bStopRecieve) {
        [NSThread sleepForTimeInterval:0.5];
    }
    @try {
        NSLog(@"______ %@",userID);
        BOOL bRes = false;
        if(g_AMQPManager==nil){
            //构造AMQPManager
            g_AMQPManager = [[AMQPManager alloc]init];
            //建立与服务器的链接
            bRes = [g_AMQPManager connection:serverIP port:port hostname:hostName usrname:userName password:passwd clientId:userID];
            //声明普通消息交换机
            bRes = [g_AMQPManager declareExchange:sExchange Type:Direct];
            //声明群消息交换机
            bRes = [g_AMQPManager declareExchange:sGroupExchange Type:Direct];
            //构造AMQP发送端
            g_AMQPSender = [g_AMQPManager newSender];
        }
        NSNumber* number =[NSNumber numberWithBool:bRes];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"SMessageService", exception.reason, nil);
    }
}

#pragma mark -- 断开服务链接
RCT_REMAP_METHOD(disconnectionService, disconnectionServiceResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        BOOL bRes = true;
        if(g_AMQPManager!=nil){
            [g_AMQPManager disconnection];
            g_AMQPManager = nil;
            g_AMQPSender = nil;
        }
//        if(g_fileAMQPManager!=nil){
//            [g_fileAMQPManager disconnection];
//            g_fileAMQPManager = nil;
//            g_fileAMQPSender = nil;
//        }
        NSNumber* number =[NSNumber numberWithBool:bRes];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"SMessageService", exception.reason, nil);
    }
}


#pragma mark -- 声明多人会话
RCT_REMAP_METHOD(declareSession, memmbers:(NSArray*)memmbers groupId:(NSString*)groupId declareSessionResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        BOOL bRes = true;
         if(g_AMQPManager!=nil){
             for(NSDictionary* memId in memmbers){
                 NSString* sQueue = [@"Message_"  stringByAppendingString:memId[@"id"]];
                 [g_AMQPManager declareQueue:sQueue];
                 [g_AMQPManager bindQueue:sQueue exchange:sGroupExchange routingkey:groupId];// bindQueue(sExchange, sQueue, sRoutingKey);
             }
         }
        NSNumber* number =[NSNumber numberWithBool:bRes];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"SMessageService", exception.reason, nil);
    }
}
#pragma mark -- 退出多人会话
RCT_REMAP_METHOD(exitSession, memmber:(NSString*)memmberId groupId:(NSString*)groupId  exitSessionResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        BOOL bRes = true;
        if(g_AMQPManager!=nil){
            NSString* sQueue = [@"Message_"  stringByAppendingString:memmberId];
            [g_AMQPManager unbindQueue:sQueue exchange:sGroupExchange routingkey:groupId];
        }
        NSNumber* number =[NSNumber numberWithBool:bRes];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"SMessageService", exception.reason, nil);
    }
}
#pragma mark -- 消息发送
RCT_REMAP_METHOD(sendMessage, message:(NSString*)message  targetID:(NSString*)targetID disconnectionServiceResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        BOOL bGroup = [targetID containsString:@"Group_"];
        BOOL bRes = true;
        //需要声明对方的消息队列并绑定routingkey
        NSString* sQueue = [@"Message_"  stringByAppendingString:targetID];
        NSString* sRoutingKey = [@"Message_" stringByAppendingString:targetID];
        if(g_AMQPManager!=nil && !bGroup){
            
            [g_AMQPManager declareQueue:sQueue];
            [g_AMQPManager bindQueue:sQueue exchange:sExchange routingkey:sRoutingKey];// bindQueue(sExchange, sQueue, sRoutingKey);
            //发送消息
        }
        if(!bGroup){
            [g_AMQPSender sendMessage:sExchange routingKey:sRoutingKey message:message];
        }else{//群组发送到广播交换机
            [g_AMQPSender sendMessage:sGroupExchange routingKey:targetID message:message];
        }
        NSNumber* number =[NSNumber numberWithBool:bRes];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"SMessageService", exception.reason, nil);
    }
}

#pragma mark -- 文件发送
RCT_REMAP_METHOD(sendFile, file:(NSString*)filePath  targetID:(NSString*)targetID disconnectionServiceResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        BOOL bRes = true;
        NSNumber* number =[NSNumber numberWithBool:bRes];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"SMessageService", exception.reason, nil);
    }
}

#pragma mark -- 消息接收
RCT_REMAP_METHOD(receiveMessage, uuid:(NSString*)uuid  reciveMessageResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        BOOL bRes = false;
        if(g_AMQPManager!=nil && uuid!=nil){
            if(g_AMQPReceiver==nil){
                NSString* sQueue = [@"Message_"  stringByAppendingString:uuid];
                [g_AMQPManager declareQueue:sQueue];
                g_AMQPReceiver = [g_AMQPManager newReceiver:sQueue];
            }
        }
       
        
        // NSLog(@"+++ receive +++ %@",[NSThread currentThread]);
        if(g_AMQPReceiver!=nil){
            NSString* str1 = nil,* str2 = nil;
            [g_AMQPReceiver receiveMessage:&str1 message:&str2];
            if (str1!=nil && str2!=nil) {
                resolve(@{@"clientId":str1,@"message":str2});
                return;
            }
        }
        
        NSNumber* number =[NSNumber numberWithBool:bRes];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"SMessageService", exception.reason, nil);
    }
}


#pragma mark -- 开启消息接收
RCT_REMAP_METHOD(startReceiveMessage, uuid:(NSString*)uuid  startReceiveMessageResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        BOOL bRes = false;
        if(g_AMQPManager!=nil && uuid!=nil){
            if(g_AMQPReceiver==nil){
                NSString* sQueue = [@"Message_"  stringByAppendingString:uuid];
                [g_AMQPManager declareQueue:sQueue];
                g_AMQPReceiver = [g_AMQPManager newReceiver:sQueue];
            }
        }
        //异步消息发送
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            int n = 0;
            while (1) {
                
               // NSLog(@"+++ receive +++ %@",[NSThread currentThread]);
                if(g_AMQPReceiver!=nil){
                    NSString* str1 = nil,* str2 = nil;
                    [g_AMQPReceiver receiveMessage:&str1 message:&str2];
                    if (str1!=nil && str2!=nil) {
                        [self sendEventWithName:MESSAGE_SERVICE_RECEIVE body:@{@"clientId":str1,@"message":str2}];
                    }
                    bStopRecieve = false;
                }else{
                   // NSLog(@"+++ receive  stop +++ %@",[NSThread currentThread]);
                    bStopRecieve = true;
                    g_AMQPReceiver = nil;
                    break;
                }
                [NSThread sleepForTimeInterval:1];
                
                //一分钟重新连接一次：
                if(n++ == 60){
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [g_AMQPManager suspend];
                        [g_AMQPManager resume];
                    });
                  
                    n = 0;
                }
            }
        });
        
        
        NSNumber* number =[NSNumber numberWithBool:bRes];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"SMessageService", exception.reason, nil);
    }
}
//挂起操作，用于APP状态切换后台
RCT_REMAP_METHOD(suspend,suspendResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject ){
    if(g_AMQPManager){
        [g_AMQPManager suspend];
    }
    NSNumber* number =[NSNumber numberWithBool:YES];
    resolve(number);
}

//恢复操作，用户APP唤醒
RCT_REMAP_METHOD(resume,resumeResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject ){
    BOOL b = false;
    if(g_AMQPManager){
        b = [g_AMQPManager resume];
    }
    NSNumber* number =[NSNumber numberWithBool:b];
    resolve(number);
}

#pragma mark -- 停止消息接收
RCT_REMAP_METHOD(stopReceiveMessage, stopReceiveMessageResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        BOOL bRes = false;
        g_AMQPReceiver = nil;
        NSNumber* number =[NSNumber numberWithBool:bRes];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"SMessageService", exception.reason, nil);
    }
}
@end

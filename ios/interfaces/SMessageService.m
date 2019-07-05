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
#include <CommonCrypto/CommonDigest.h>

@interface SMessageService()
{
    //
    
    
    //AMQPSender* g_messageAMQPSender;
    
    //    AMQPManager* g_fileAMQPManager;
    //    AMQPSender* g_fileAMQPSender;
}
@end
//静态的，保证线程能共享
static AMQPManager* g_AMQPManager = nil;
static AMQPSender* g_AMQPSender = nil;
static AMQPReceiver* g_AMQPReceiver = nil;
static BOOL bStopRecieve = true;
static BOOL isRecieving = true;
//
//分发消息的交换机
static NSString* sExchange = @"message";
//分发群消息的交换机
static NSString* sGroupExchange = @"message.group";

@implementation SMessageService
#pragma mark -- 定义宏，让该类暴露给RN层
RCT_EXPORT_MODULE();
- (NSArray<NSString *> *)supportedEvents{
    return @[MESSAGE_SERVICE_RECEIVE,
             MESSAGE_SERVICE_SEND_FILE,
             MESSAGE_SERVICE_RECEIVE_FILE];
}

#pragma mark -- 连接服务
RCT_REMAP_METHOD(connectService, ip:(NSString*)serverIP port:(int)port hostName:(NSString*)hostName userName:(NSString*)userName passwd:(NSString*)passwd userID:(NSString*)userID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    //假如有接收线程未停止，在这等待
//    while (!bStopRecieve) {
//        [NSThread sleepForTimeInterval:0.5];
//    }
    
//    if(g_AMQPManager){
//        [g_AMQPManager suspend];
//    }
//
//    if(g_AMQPReceiver){
//        [g_AMQPReceiver dispose];
//    }
//    g_AMQPReceiver = nil;
//    g_AMQPSender = nil;
//    g_AMQPManager = nil;
    
    BOOL bRes = true;
    @try {
        NSLog(@"______ %@",userID);
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
            
            if(!bRes){
                g_AMQPManager = nil;
                g_AMQPSender = nil;
            }
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
RCT_REMAP_METHOD(sendFile, connectInfo:(NSString*)connectInfo message:(NSString*)message file:(NSString*)filePath  talkId:(NSString*)talkId msgId:(int)msgId disconnectionServiceResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString* fileName=[filePath lastPathComponent];

            NSOutputStream* outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:YES];
            [outputStream open];

            NSDictionary *fileDic = [fileManager attributesOfItemAtPath:filePath error:nil];//获取文件的属性
            //文件大小
            unsigned long long fileSize = [[fileDic objectForKey:NSFileSize] longLongValue];
            //单个文件大小
            unsigned int singleFileSize=1024 * 1024 * 2;
            //2M为单位切割文件后的总个数
            long total = (long)ceil((double)fileSize / ((double) singleFileSize));

            //BASE64编码的单个文件
            NSString* sFileBlock;
            //可以直接发送的json字符串
            NSString* jsonMessage;

            //转成JSON
            //            NSData *jMessage = [NSJSONSerialization dataWithJSONObject:message options:NSJSONWritingPrettyPrinted error:nil];
            NSData* jMessage=[message dataUsingEncoding:NSUTF8StringEncoding];

            NSMutableDictionary *messageDic = [NSJSONSerialization JSONObjectWithData:jMessage options:NSJSONReadingMutableContainers error:nil];

            //对方的文件队列名和key,最好随机生成

            NSString* sQueue =[NSString stringWithFormat:@"File_%@_%@", [[messageDic valueForKey:@"user"] valueForKey:@"id"], [messageDic valueForKey:@"time"]];
            NSString* sRoutingKey=[NSString stringWithFormat:@"File_%@_%@", [[messageDic valueForKey:@"user"] valueForKey:@"id"], [messageDic valueForKey:@"time"]];

            //            NSData* jConnectinfo = [NSJSONSerialization dataWithJSONObject:connectInfo options:NSJSONWritingPrettyPrinted error:nil];
            NSData* jConnectinfo = [connectInfo dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *connectinfoDic = [NSJSONSerialization JSONObjectWithData:jConnectinfo options:NSJSONReadingMutableContainers error:nil];
            //传送文件时新建一个连接
            AMQPManager* mAMQPManager_File = [[AMQPManager alloc]init];
            [mAMQPManager_File connection:[connectinfoDic valueForKey:@"serverIP"]
                                     port:[[connectinfoDic valueForKey:@"port"] intValue]
                                 hostname:[connectinfoDic valueForKey:@"hostName"]
                                  usrname:[connectinfoDic valueForKey:@"userName"]
                                 password:[connectinfoDic valueForKey:@"passwd"]
                                 clientId:[connectinfoDic valueForKey:@"userID"]];

            [mAMQPManager_File declareQueue:sQueue];

            //由于错误可能会有未删除的队列
            [mAMQPManager_File deleteQueue:sQueue];
            [mAMQPManager_File declareQueue:sQueue];
            [mAMQPManager_File bindQueue:sQueue exchange:sExchange  routingkey:sRoutingKey];
            AMQPSender* fileSender=[mAMQPManager_File newSender];

            NSFileHandle* fh = [NSFileHandle fileHandleForReadingAtPath:filePath];


            for(int index=1;index<=total;index++){
                NSData* data;
                if(index==total){
                    data=[fh readDataToEndOfFile];
                }else{
                    data=[fh readDataOfLength:total];
                }
                NSString * decodeStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                sFileBlock=decodeStr;
                NSMutableDictionary *sub_messageDic=[[messageDic objectForKey:@"message"] objectForKey:@"message"];

                [sub_messageDic setObject:sFileBlock forKey:@"data"];
                [sub_messageDic setValue:@(total) forKey:@"length"];
                [sub_messageDic setValue:@(index) forKey:@"index"];

                NSData *message_data=[NSJSONSerialization dataWithJSONObject:messageDic options:NSJSONWritingPrettyPrinted error:nil];
                NSString *message_str=[[NSString alloc]initWithData:message_data encoding:NSUTF8StringEncoding];

                [fileSender sendMessage:sExchange routingKey:sRoutingKey  message:message_str];

                int percentage=(index*100)/total;
                NSMutableDictionary* infoDic = [[NSMutableDictionary alloc] init];

                [infoDic setObject:talkId forKey:@"talkId"];
                [infoDic setValue:@(msgId) forKey:@"msgId"];
                [infoDic setValue:@(percentage) forKey:@"percentage"];

                [self sendEventWithName:MESSAGE_SERVICE_SEND_FILE body:infoDic];
            }
            [fh closeFile];
            [mAMQPManager_File disconnection];

            NSMutableDictionary* dic=[[NSMutableDictionary alloc] init];

            [dic setObject:sQueue forKey:@"queueName"];
            [dic setObject:fileName forKey:@"fileName"];
            [dic setValue:@(fileSize) forKey:@"fileSize"];

            resolve(dic);
        });
    } @catch (NSException *exception) {
        reject(@"SMessageService", exception.reason, nil);
    }

}

#pragma mark -- 文件发送，第三方服务器方式发送
RCT_REMAP_METHOD(sendFileWithThirdServer,  message:(NSString*)message file:(NSString*)filePath  talkId:(NSString*)talkId msgId:(int)msgId disconnectionServiceResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString* fileName=[filePath lastPathComponent];
            
            NSOutputStream* outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:YES];
            [outputStream open];
            
            NSDictionary *fileDic = [fileManager attributesOfItemAtPath:filePath error:nil];//获取文件的属性
            //文件大小
            unsigned long long fileSize = [[fileDic objectForKey:NSFileSize] longLongValue];
            //单个文件大小
            unsigned int singleFileSize=1024 * 1024 * 2;
            //2M为单位切割文件后的总个数
            long total = (long)ceil((double)fileSize / ((double) singleFileSize));
            
            //BASE64编码的单个文件
            NSString* sFileBlock;

            NSData* jMessage=[message dataUsingEncoding:NSUTF8StringEncoding];
            
            NSMutableDictionary *messageDic = [NSJSONSerialization JSONObjectWithData:jMessage options:NSJSONReadingMutableContainers error:nil];
            
            NSString* md5=[self getFileMD5StrFromPath:filePath];
            
            NSFileHandle* fh = [NSFileHandle fileHandleForReadingAtPath:filePath];
            
            NSMutableDictionary *sub_messageDic=[[NSMutableDictionary alloc] init];
            [sub_messageDic setObject:md5 forKey:@"md5"];
            [sub_messageDic setObject:[[messageDic valueForKey:@"user"] valueForKey:@"id"] forKey:@"userId"];
            
            for(int index=1;index<=total;index++){
                NSData* data;
                if(index!=total){
                    data=[fh readDataToEndOfFile];
                    [sub_messageDic setValue:@(singleFileSize) forKey:@"dataLength"];
                }else{
                    data=[fh readDataOfLength:singleFileSize];
                    [sub_messageDic setValue:@(fileSize%singleFileSize) forKey:@"dataLength"];
                }
                NSString * decodeStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                sFileBlock=decodeStr;
                [sub_messageDic setObject:sFileBlock forKey:@"data"];
                [sub_messageDic setValue:@(index) forKey:@"index"];
                
                NSURL *url =[NSURL URLWithString:@"http://111.202.121.144:8124/upload"];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                   timeoutInterval:15.0];
                [request setHTTPMethod:@"POST"];
                NSData *message_data=[NSJSONSerialization dataWithJSONObject:sub_messageDic options:NSJSONWritingPrettyPrinted error:nil];
                NSString *message_str=[[NSString alloc]initWithData:message_data encoding:NSUTF8StringEncoding];
                NSData *body = [message_str dataUsingEncoding:NSUTF8StringEncoding];
                
                [request setHTTPBody:body];
                
                NSURLResponse * response;
                NSError * error;
                NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                if(error == nil){
                    int percentage=(index*100)/total;
                    NSMutableDictionary* infoDic = [[NSMutableDictionary alloc] init];
                    [infoDic setObject:talkId forKey:@"talkId"];
                    [infoDic setValue:@(msgId) forKey:@"msgId"];
                    [infoDic setValue:@(percentage) forKey:@"percentage"];
                    
                    [self sendEventWithName:MESSAGE_SERVICE_SEND_FILE body:infoDic];
                    
                    if(index==total){
                        NSMutableDictionary* dic=[[NSMutableDictionary alloc] init];
                        
                        [dic setObject:md5 forKey:@"queueName"];
                        [dic setObject:fileName forKey:@"fileName"];
                        [dic setValue:@(fileSize) forKey:@"fileSize"];
                        
                        [fh closeFile];
                        resolve(dic);
                    }
                }
            }
        });
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

#pragma mark --接收文件，每次接收时运行
RCT_REMAP_METHOD(receiveFile, fileName:(NSString*)fileName queueName:(NSString* )queueName receivePath:(NSString*)receivePath talkId:(NSString*)talkId  msgId:(int)msgId  receiveFileResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        dispatch_queue_t urls_queue = dispatch_queue_create("receiveFile", NULL);
        dispatch_async(urls_queue, ^{
            //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL isDir = NO;
            BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:receivePath isDirectory:&isDir];
            if (!isExist || !isDir) {
                [[NSFileManager defaultManager] createDirectoryAtPath:receivePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSString* filePath=[NSString stringWithFormat:@"%@/%@",receivePath,fileName];
            if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
            }

            NSFileHandle* fh = [NSFileHandle fileHandleForWritingAtPath:filePath];

            NSData* jsonReceived;

            [g_AMQPManager declareQueue:queueName];
            AMQPReceiver* fileReceiver=[g_AMQPManager newReceiver:queueName];

            while (fileReceiver) {
                NSString const *  name=queueName;
                NSString* msg=nil;
                //接收消息
                [fileReceiver receiveMessage:&name message:&msg];
                if(msg){
                    jsonReceived=[msg dataUsingEncoding:NSUTF8StringEncoding];
                    //                    [fh writeData:jsonReceived];

                    NSMutableDictionary *receivedDic = [NSJSONSerialization JSONObjectWithData:jsonReceived options:NSJSONReadingMutableContainers error:nil];
                    NSString* dataStr=[[[receivedDic objectForKey:@"message"] objectForKey:@"message"] objectForKey:@"data"];
                    NSData *data = [[NSData alloc]initWithBase64EncodedString:dataStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    [fh writeData:data];


                    int index =[[[[receivedDic objectForKey:@"message"] objectForKey:@"message"] objectForKey:@"index"] intValue];
                    long length =[[[[receivedDic objectForKey:@"message"] objectForKey:@"message"] objectForKey:@"length"] intValue];
                    int percentage = (int)((float) index / length * 100);
                    NSMutableDictionary* infoMap = [[NSMutableDictionary alloc] init];
                    [infoMap setObject:talkId forKey:@"talkId"];
                    [infoMap setObject:@(msgId) forKey:@"msgId"];
                    [infoMap setObject:@(percentage) forKey:@"percentage"];

                    [self sendEventWithName:MESSAGE_SERVICE_RECEIVE_FILE body:infoMap];

                    if(index == length){
                        break;
                    }
                }
            }
            [fh closeFile];
            //接收完后删除队列
            [g_AMQPManager deleteQueue:queueName];
            resolve([NSNumber numberWithBool:true]);
        });
    } @catch (NSException *exception) {
        reject(@"SMessageService", exception.reason, nil);
    }
  
}

#pragma mark --接收文件，每次接收时运行，接收第三方服务器的文件
RCT_REMAP_METHOD(receiveFileWithThirdServer, fileName:(NSString*)fileName queueName:(NSString* )queueName receivePath:(NSString*)receivePath talkId:(NSString*)talkId  msgId:(int)msgId userid:(NSString*)userId fileSize:(int)fileSize receiveFileResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        dispatch_queue_t urls_queue = dispatch_queue_create("receiveFile", NULL);
        dispatch_async(urls_queue, ^{
            BOOL isDir = NO;
            BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:receivePath isDirectory:&isDir];
            if (!isExist || !isDir) {
                [[NSFileManager defaultManager] createDirectoryAtPath:receivePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSString* filePath=[NSString stringWithFormat:@"%@/%@",receivePath,fileName];
            if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
            }
            
            NSFileHandle* fh = [NSFileHandle fileHandleForWritingAtPath:filePath];
            //单个文件大小
            unsigned int singleFileSize=1024 * 1024 * 2;
            int count=(int)ceil((double)fileSize / ((double) singleFileSize));
            
            NSMutableDictionary *sub_messageDic=[[NSMutableDictionary alloc] init];
            [sub_messageDic setValue:queueName forKey:@"md5"];
            [sub_messageDic setValue:@(singleFileSize) forKey:@"dataLength"];
            [sub_messageDic setObject:userId forKey:@"userID"];
            
            static long  start=0;
            for(int index=1;index<=count;index++) {
                [sub_messageDic setObject:@(start) forKey:@"startPos"];
                NSURL *url =[NSURL URLWithString:@"http://111.202.121.144:8124/download"];
                
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                   timeoutInterval:60.0];
                [request setHTTPMethod:@"POST"];
                
                NSData *message_data=[NSJSONSerialization dataWithJSONObject:sub_messageDic options:NSJSONWritingPrettyPrinted error:nil];
                NSString *message_str=[[NSString alloc]initWithData:message_data encoding:NSUTF8StringEncoding];
                
                NSString *httpBody = message_str;
                
                NSString *percentEncoding = [httpBody stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                [request setHTTPBody:[percentEncoding dataUsingEncoding:NSUTF8StringEncoding]];
                //                NSURLSessionDataTask *dataTask = nil;
                
                [request setHTTPBody:message_data];
                
                NSURLResponse * response;
                NSError * error;
                NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                if (error) {
                    NSLog(@"error : %@",[error localizedDescription]);
                }else{
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:backData options:NSJSONReadingMutableContainers error:nil];
                    long dataLength=[[dic valueForKey:@"dataLength"] longValue];
                    NSString* dataStr=[dic objectForKey:@"value"];
                    NSData *data = [[NSData alloc]initWithBase64EncodedString:dataStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    [fh writeData:data];
                    start+=dataLength;
                    
                    int percentage = (int)((float) index / count * 100);
                    NSMutableDictionary* infoMap = [[NSMutableDictionary alloc] init];
                    [infoMap setObject:talkId forKey:@"talkId"];
                    [infoMap setObject:@(msgId) forKey:@"msgId"];
                    [infoMap setObject:@(percentage) forKey:@"percentage"];
                    
                    [self sendEventWithName:MESSAGE_SERVICE_RECEIVE_FILE body:infoMap];
                }
            }
            [fh closeFile];
            resolve([NSNumber numberWithBool:true]);
        });
    } @catch (NSException *exception) {
        reject(@"SMessageService", exception.reason, nil);
    }
}


#pragma mark -- 开启消息接收
RCT_REMAP_METHOD(startReceiveMessage, uuid:(NSString*)uuid  startReceiveMessageResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    @try {
        BOOL bRes = false;
        NSString* sQueue = [@"Message_"  stringByAppendingString:uuid];
        if(g_AMQPManager!=nil && uuid!=nil){
            [g_AMQPManager declareQueue:sQueue];
            g_AMQPReceiver = [g_AMQPManager newReceiver:sQueue];
        }
        
        isRecieving=true;
        //异步消息发送
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            int n = 0;
            while (1) {
                // NSLog(@"+++ receive +++ %@",[NSThread currentThread]);
                if(isRecieving && g_AMQPReceiver != nil){
                    bStopRecieve = false;
                    NSString* str1 = nil,* str2 = nil;
                    [g_AMQPReceiver receiveMessage:&str1 message:&str2];
                    if (str1!=nil && str2!=nil) {
                        [self sendEventWithName:MESSAGE_SERVICE_RECEIVE body:@{@"clientId":str1,@"message":str2}];
                    }
                }else{
                    // NSLog(@"+++ receive  stop +++ %@",[NSThread currentThread]);
                    if(g_AMQPReceiver != nil){
                        g_AMQPReceiver = nil;
                    }
                    bStopRecieve=true;
                    break;
                }
                [NSThread sleepForTimeInterval:1];
                
                //一分钟重新连接一次：
                if(n++ == 60){
                    if(g_AMQPManager!=nil){
                        [g_AMQPManager suspend];
                        [g_AMQPManager resume];
                    }
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
        isRecieving=false;
        while (!bStopRecieve) {
            [NSThread sleepForTimeInterval:0.5];
        }
        NSNumber* number =[NSNumber numberWithBool:bRes];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"SMessageService", exception.reason, nil);
    }
}

- (NSString *)getFileMD5StrFromPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path isDirectory:nil])
    {
        NSData *data = [NSData dataWithContentsOfFile:path];
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5( data.bytes, (CC_LONG)data.length, digest );
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        for( int i = 0; i < CC_MD5_DIGEST_LENGTH; i++ )
        {
            [output appendFormat:@"%02x", digest[i]];
        }
        return output;
    }
    else
    {
        return @"";
        
    }
    
}

@end

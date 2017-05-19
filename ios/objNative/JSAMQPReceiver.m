//
//  JSAMQPReceiver.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/17.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSAMQPReceiver.h"

#import "SuperMap/AMQPReceiver.h"
#import "JSObjManager.h"
@implementation JSAMQPReceiver
RCT_EXPORT_MODULE();

//所有导出方法名
- (NSArray<NSString *> *)supportedEvents
{
    return @[@"com.supermap.RN.JSAMQPReceiver.receive_message1",@"com.supermap.RN.JSAMQPReceiver.receive_message2",@"com.supermap.RN.JSAMQPReceiver.receive_message3",@"com.supermap.RN.JSAMQPReceiver.receive_message4",@"com.supermap.RN.JSAMQPReceiver.receive_message5"];
}

/*
 RCT_REMAP_METHOD(createObj,createObjWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
 @try {
 AMQPReceiver* receiver = [[AMQPReceiver alloc]init];
 NSInteger nsKey = (NSInteger)receiver;
 [JSObjManager addObj:receiver];
 resolve(@{@"_AMQPReceiverId":@(nsKey).stringValue});
 } @catch (NSException *exception) {
 reject(@"AMQPReceiver",@"create Obj expection",nil);
 }
 }
 */

RCT_REMAP_METHOD(receiveMessage,receiveMessageById:(NSString*)receiverId queueName:(NSString*)queueName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (1) {
            
            @try {
                AMQPReceiver* receiver = [JSObjManager getObjWithKey:receiverId];
                
                NSString* str1 = nil,* str2 = nil;
                [receiver receiveMessage:&str1 message:&str2];
                
                if (str1!=nil && str2!=nil) {
                    [self sendEventWithName:queueName body:@{@"clientId":str1,@"message":str2}];
                   // resolve(@{@"message":dic});
                    [NSThread sleepForTimeInterval:3];
                }
            } @catch (NSException *exception) {
                reject(@"AMQPReceiver",@"receive Message expection",nil);
            }
        }
    });
}
@end

//
//  JSAMQPSender.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/12.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSAMQPSender.h"

#import "SuperMap/AMQPSender.h"
#import "JSObjManager.h"
@implementation JSAMQPSender
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj,createObjWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        AMQPSender* sender = [[AMQPSender alloc]init];
        NSInteger nsKey = (NSInteger)sender;
        [JSObjManager addObj:sender];
        resolve(@{@"_AMQPSenderId":@(nsKey).stringValue});
    } @catch (NSException *exception) {
        reject(@"AMQPManager",@"create Obj expection",nil);
    }
}

RCT_REMAP_METHOD(sendMessage,sendMessageById:(NSString*)senderId exchange:(NSString*)exchange routingKey:(NSString*)routingKey message:(NSString*)message resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        AMQPSender* sender = [JSObjManager getObjWithKey:senderId];
        [sender sendMessage:exchange routingKey:routingKey message:message];
        resolve(@"sent message");
    } @catch (NSException *exception) {
        reject(@"AMQPManager",@"send Message expection",nil);
    }
}
@end

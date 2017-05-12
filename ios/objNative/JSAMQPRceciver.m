//
//  JSAMQPRceciver.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/12.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSAMQPRceciver.h"

#import "SuperMap/AMQPReceiver.h"
#import "JSObjManager.h"
@implementation JSAMQPRceciver
RCT_EXPORT_MODULE();
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

RCT_REMAP_METHOD(receiveMessage,receiveMessageById:(NSString*)receiverId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            AMQPReceiver* receiver = [JSObjManager getObjWithKey:receiverId];
            NSString* str1 = nil,* str2 = nil;
            [receiver receiveMessage:&str1 message:&str2];
            if (str1!=nil && str2!=nil) {
                NSDictionary* dic = @{@"clientId":str1,@"message":str2};
                resolve(@{@"message":dic});
            }
        } @catch (NSException *exception) {
            reject(@"AMQPReceiver",@"receive Message expection",nil);
        }
    });
}
@end

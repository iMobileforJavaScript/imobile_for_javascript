//
//  JSMQTTClientSide.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/16.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSMQTTClientSide.h"

#import "SuperMap/MQTTClientSide.h"
#import "JSObjManager.h"
@implementation JSMQTTClientSide
RCT_EXPORT_MODULE();

//所有导出方法名
- (NSArray<NSString *> *)supportedEvents
{
    return @[@"com.supermap.RN.JSMQTTClientSide.receive_message1",@"com.supermap.RN.JSMQTTClientSide.receive_message2",@"com.supermap.RN.JSMQTTClientSide.receive_message3",@"com.supermap.RN.JSMQTTClientSide.receive_message4",@"com.supermap.RN.JSMQTTClientSide.receive_message5"];
}

 RCT_REMAP_METHOD(createObj,createObjWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
     @try {
         MQTTClientSide* side = [[MQTTClientSide alloc]init];
         NSInteger nsKey = (NSInteger)side;
         [JSObjManager addObj:side];
         resolve(@{@"_MQTTClientSideId":@(nsKey).stringValue});
     } @catch (NSException *exception) {
         reject(@"MQTTClientSide",@"create Obj expection",nil);
     }
 }

RCT_REMAP_METHOD(create,createWithId:(NSString*)sideId URI:(NSString*)URI userName:(NSString*)name password:(NSString*)password clientId:(NSString*)clientId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MQTTClientSide* side = [JSObjManager getObjWithKey:sideId];
        BOOL isConnection = [side create:URI username:name password:password clientId:clientId];
        NSNumber* num = [NSNumber numberWithBool:isConnection];
        resolve(@{@"isConnection":num});
    } @catch (NSException *exception) {
        reject(@"MQTTClientSide",@"create connection expection",nil);
    }
}

RCT_REMAP_METHOD(sendMessage,sendMessageWithId:(NSString*)sideId topic:(NSString*)topic message:(NSString*)message resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MQTTClientSide* side = [JSObjManager getObjWithKey:sideId];
        BOOL sent = [side sendMessage:topic message:message];
        NSNumber* num = [NSNumber numberWithBool:sent];
        resolve(@{@"send":num});
    } @catch (NSException *exception) {
        reject(@"MQTTClientSide",@"send Message expection",nil);
    }
}

RCT_REMAP_METHOD(receiveMessage,receiveMessageWithId:(NSString*)sideId queueName:(NSString*)queueName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            while (1) {
                @try {
                    MQTTClientSide* side = [JSObjManager getObjWithKey:sideId];
                    NSString* str1 = nil,* str2 = nil;
                    [side receiveMessage:&str1 message:&str2];
                    if (str1!=nil&&str2!=nil) {
                        [self sendEventWithName:queueName body:@{@"topic":str1,@"message":str2}];
//                    NSDictionary* dic = @{@"topic":str1,@"message":str2};
//                    resolve(@{@"message":dic});
                        [NSThread sleepForTimeInterval:3];
                    }
                } @catch (NSException *exception) {
                    reject(@"STOMPReceiver",@"receive Message expection",nil);
                }
            }
        });
    resolve(@"done");
}

RCT_REMAP_METHOD(subscribe,subscribeWithId:(NSString*)sideId topic:(NSString*)topicName qos:(int)qos resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MQTTClientSide* side = [JSObjManager getObjWithKey:sideId];
        BOOL isSubscribe = [side subscribe:topicName quality:qos];
        NSNumber* num = [NSNumber numberWithBool:isSubscribe];
        resolve(@{@"isSubscribe":num});
    } @catch (NSException *exception) {
        reject(@"MQTTClientSide",@"subscribe expection",nil);
    }
}

RCT_REMAP_METHOD(unsubscribe,unsubscribeWithId:(NSString*)sideId topic:(NSString*)topicName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MQTTClientSide* side = [JSObjManager getObjWithKey:sideId];
        BOOL unSubscribe = [side unsubscribe:topicName];
        NSNumber* num = [NSNumber numberWithBool:unSubscribe];
        resolve(@{@"unSubscribe":num});
    } @catch (NSException *exception) {
        reject(@"MQTTClientSide",@"unSubscribe expection",nil);
    }
}

RCT_REMAP_METHOD(suspend,suspendWithId:(NSString*)sideId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MQTTClientSide* side = [JSObjManager getObjWithKey:sideId];
        [side suspend];
        resolve(@"suspend");
    } @catch (NSException *exception) {
        reject(@"MQTTClientSide",@"suspend expection",nil);
    }
}

RCT_REMAP_METHOD(resume,resumeWithId:(NSString*)sideId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MQTTClientSide* side = [JSObjManager getObjWithKey:sideId];
        BOOL isResume = [side resume];
        NSNumber* num = [NSNumber numberWithBool:isResume];
        resolve(@{@"isResume":num});
    } @catch (NSException *exception) {
        reject(@"MQTTClientSide",@"resume expection",nil);
    }
}

RCT_REMAP_METHOD(dispose,disposeWithId:(NSString*)sideId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MQTTClientSide* side = [JSObjManager getObjWithKey:sideId];
        [JSObjManager removeObj:sideId];
        [side dispose];
        resolve(@"dispose");
    } @catch (NSException *exception) {
        reject(@"MQTTClientSide",@"dispose expection",nil);
    }
}
@end

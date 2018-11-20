//
//  JSSTOMPReceiver.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/15.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSSTOMPReceiver.h"

#import "SuperMap/STOMPReceiver.h"
#import "JSObjManager.h"
@implementation JSSTOMPReceiver
RCT_EXPORT_MODULE();

//所有导出方法名
- (NSArray<NSString *> *)supportedEvents
{
    return @[@"com.supermap.RN.JSSTOMPReceiver.receive_message1",@"com.supermap.RN.JSSTOMPReceiver.receive_message2",@"com.supermap.RN.JSSTOMPReceiver.receive_message3",@"com.supermap.RN.JSSTOMPReceiver.receive_message4",@"com.supermap.RN.JSSTOMPReceiver.receive_message5"];
}

/*
RCT_REMAP_METHOD(createObj,createObjWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        STOMPReceiver* receiver = [[STOMPReceiver alloc]init];
        NSInteger nsKey = (NSInteger)receiver;
        [JSObjManager addObj:receiver];
        resolve(@{@"_STOMPReceiverId":@(nsKey).stringValue});
    } @catch (NSException *exception) {
        reject(@"STOMPReceiver",@"create Obj expection",nil);
    }
}
*/
RCT_REMAP_METHOD(receiveMessage,receiveById:(NSString*)receiverId queueName:(NSString*)queueName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (1) {
            @try {
                STOMPReceiver* receiver = [JSObjManager getObjWithKey:receiverId];
                NSString* str1 = nil;
                [receiver receiveMessage:&str1];
                
                if (str1!=nil) {
                    [self sendEventWithName:queueName body:@{@"message":str1}];
                    //  resolve(@{@"message":str1});
                    [NSThread sleepForTimeInterval:3];
                }
                
            } @catch (NSException *exception) {
                reject(@"STOMPReceiver",@"receive Message expection",nil);
            }
        }
    });
    resolve(@"done");
}

RCT_REMAP_METHOD(dispose,disposeById:(NSString*)receiverId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        STOMPReceiver* receiver = [JSObjManager getObjWithKey:receiverId];
        BOOL isDispose = [receiver dispose];
        [JSObjManager removeObj:receiverId];
        NSNumber* num = [NSNumber numberWithBool:isDispose];
        resolve(@{@"isDispose":num});
    } @catch (NSException *exception) {
        reject(@"STOMPReceiver",@"dispose expection",nil);
    }
}
@end

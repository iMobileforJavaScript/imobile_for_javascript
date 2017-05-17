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
RCT_REMAP_METHOD(receive,receiveById:(NSString*)receiverId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            STOMPReceiver* receiver = [JSObjManager getObjWithKey:receiverId];
            NSString* str1 = nil;
            [receiver receiveMessage:&str1];
            if (str1!=nil) {
                resolve(@{@"message":str1});
            }
        } @catch (NSException *exception) {
            reject(@"STOMPReceiver",@"receive Message expection",nil);
        }
    });
}

RCT_REMAP_METHOD(dispose,disposeById:(NSString*)receiverId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        STOMPReceiver* receiver = [JSObjManager getObjWithKey:receiverId];
        [JSObjManager removeObj:receiverId];
        BOOL isDispose = [receiver dispose];
        NSNumber* num = [NSNumber numberWithBool:isDispose];
        resolve(@{@"isDispose":num});
    } @catch (NSException *exception) {
        reject(@"STOMPReceiver",@"dispose expection",nil);
    }
}
@end

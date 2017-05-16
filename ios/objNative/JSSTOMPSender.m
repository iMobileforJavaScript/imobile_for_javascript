//
//  JSSTOMPSender.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/15.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSSTOMPSender.h"

#import "SuperMap/STOMPSender.h"
#import "JSObjManager.h"
@implementation JSSTOMPSender
RCT_EXPORT_MODULE();
/*
RCT_REMAP_METHOD(createObj,createObjWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        STOMPSender* sender = [[STOMPSender alloc]init];
        NSInteger nsKey = (NSInteger)sender;
        [JSObjManager addObj:sender];
        resolve(@{@"_STOMPSenderId":@(nsKey).stringValue});
    } @catch (NSException *exception) {
        reject(@"STOMPSender",@"create Obj expection",nil);
    }
}
*/
RCT_REMAP_METHOD(sendMessage,sendMessageById:(NSString*)senderId message:(NSString*)message resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        STOMPSender* sender = [JSObjManager getObjWithKey:senderId];
        [sender sendMessage:message];
        resolve(@"sent");
    } @catch (NSException *exception) {
        reject(@"STOMPSender",@"send Message expection",nil);
    }
}

RCT_REMAP_METHOD(dispose,disposeById:(NSString*)senderId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        STOMPSender* sender = [JSObjManager getObjWithKey:senderId];
        [JSObjManager removeObj:sender];
        [sender dispose];
        resolve(@"sent");
    } @catch (NSException *exception) {
        reject(@"STOMPSender",@"dispose expection",nil);
    }
}
@end

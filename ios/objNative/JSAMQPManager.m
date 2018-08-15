//
//  JSAMQPManager.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/12.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSAMQPManager.h"

#import "SuperMap/AMQPManager.h"
#import "JSObjManager.h"
@implementation JSAMQPManager
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj,createObjWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        AMQPManager* manager = [[AMQPManager alloc]init];
        NSInteger nsKey = (NSInteger)manager;
        [JSObjManager addObj:manager];
        resolve(@{@"_AMQPManagerId":@(nsKey).stringValue});
    } @catch (NSException *exception) {
        reject(@"AMQPManager",@"create Obj expection",nil);
    }
}

RCT_REMAP_METHOD(newReceiver,newReceiverById:(NSString*)managerId queueName:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        AMQPManager* manager = [JSObjManager getObjWithKey:managerId];
        AMQPReceiver* receiver = [manager newReceiver:name];
        NSInteger nsKey = (NSInteger)receiver;
        [JSObjManager addObj:receiver];
        resolve(@{@"AMQPReceiverId":@(nsKey).stringValue});
    } @catch (NSException *exception) {
        reject(@"AMQPManager",@"new Receiver expection",nil);
    }
}

RCT_REMAP_METHOD(newSender,newSenderById:(NSString*)managerId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        AMQPManager* manager = [JSObjManager getObjWithKey:managerId];
        AMQPSender* sender = [manager newSender];
        NSInteger nsKey = (NSInteger)sender;
        [JSObjManager addObj:sender];
        resolve(@{@"AMQPSenderId":@(nsKey).stringValue});
    } @catch (NSException *exception) {
        reject(@"AMQPManager",@"new Sender expection",nil);
    }
}

RCT_REMAP_METHOD(connection,connectionById:(NSString*)managerId paramDic:(NSDictionary*)paramDic resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        AMQPManager* manager = [JSObjManager getObjWithKey:managerId];
        NSString* ip = [paramDic objectForKey:@"IP"];
        int port = ((NSNumber*)[paramDic objectForKey:@"Port"]).intValue;
        NSString* hostName = [paramDic objectForKey:@"HostName"];
        NSString* userName = [paramDic objectForKey:@"UserName"];
        NSString* passWord = [paramDic objectForKey:@"PassWord"];
        NSString* clientId = [paramDic objectForKey:@"ClientId"];
        BOOL isConnection = [manager connection:ip port:port hostname:hostName usrname:userName password:passWord clientId:clientId];
        NSNumber* nsConnection = [NSNumber numberWithBool:isConnection];
        resolve(@{@"isConnection":nsConnection});
    } @catch (NSException *exception) {
        reject(@"AMQPManager",@"connection expection",nil);
    }
}

RCT_REMAP_METHOD(disconnection,disconnectionById:(NSString*)managerId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        AMQPManager* manager = [JSObjManager getObjWithKey:managerId];
        [manager disconnection];
        resolve(@"disconnection");
    } @catch (NSException *exception) {
        reject(@"AMQPManager",@"disconnection expection",nil);
    }
}
@end

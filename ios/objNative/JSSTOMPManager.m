//
//  JSSTOMPManager.m
//  Supermap
//
//  Created by 王子豪 on 2017/5/15.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "JSSTOMPManager.h"

#import "SuperMap/STOMPManager.h"
#import "JSObjManager.h"
@implementation JSSTOMPManager
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj,createObjWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        STOMPManager* manager = [[STOMPManager alloc]init];
        NSInteger nsKey = (NSInteger)manager;
        [JSObjManager addObj:manager];
        resolve(@{@"_STOMPManagerId":@(nsKey).stringValue});
    } @catch (NSException *exception) {
        reject(@"STOMPManager",@"create Obj expection",nil);
    }
}

RCT_REMAP_METHOD(initializeLibrary,initializeLibraryWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [STOMPManager initializeLibrary];
        resolve(@"initializeLibrary");
    } @catch (NSException *exception) {
        reject(@"STOMPManager",@"initialize Library expection",nil);
    }
}

RCT_REMAP_METHOD(shutdownLibrary,shutdownLibraryWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [STOMPManager shutdownLibrary];
        resolve(@"shutdown Library");
    } @catch (NSException *exception) {
        reject(@"STOMPManager",@"shutdown Library expection",nil);
    }
}

RCT_REMAP_METHOD(newSender,newSenderWithId:(NSString*)managerId useTopic:(BOOL)UseTopic name:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        STOMPManager* manager = [JSObjManager getObjWithKey:managerId];
        STOMPSender* sender = [manager newSender:UseTopic name:name];
        NSInteger nsKey = (NSInteger)sender;
        [JSObjManager addObj:sender];
        resolve(@{@"STOMPSenderId":@(nsKey).stringValue});
    } @catch (NSException *exception) {
        reject(@"STOMPManager",@"shutdown Library expection",nil);
    }
}

RCT_REMAP_METHOD(newReceiver,newReceiverWithId:(NSString*)managerId useTopic:(BOOL)UseTopic name:(NSString*)name clientID:(NSString*)clientID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        STOMPManager* manager = [JSObjManager getObjWithKey:managerId];
        STOMPReceiver* receiver = [manager newReceiver:UseTopic name:name clientid:clientID];
        NSInteger nsKey = (NSInteger)receiver;
        [JSObjManager addObj:receiver];
        resolve(@{@"STOMPReceiverId":@(nsKey).stringValue});
    } @catch (NSException *exception) {
        reject(@"STOMPManager",@"shutdown Library expection",nil);
    }
}

RCT_REMAP_METHOD(connection,connectionWithId:(NSString*)managerId URI:(NSString*)URI name:(NSString*)name passWord:(NSString*)passWord resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        STOMPManager* manager = [JSObjManager getObjWithKey:managerId];
        BOOL isConnection = [manager connection:URI username:name password:passWord];
        NSNumber* num = [NSNumber numberWithBool:isConnection];
        resolve(@{@"isConnection":num});
    } @catch (NSException *exception) {
        reject(@"STOMPManager",@"connection expection",nil);
    }
}

RCT_REMAP_METHOD(disconnection,disconnectionWithId:(NSString*)managerId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        STOMPManager* manager = [JSObjManager getObjWithKey:managerId];
        [manager disConnection];
        resolve(@"disConnection");
    } @catch (NSException *exception) {
        reject(@"STOMPManager",@"disConnection expection",nil);
    }
}
@end

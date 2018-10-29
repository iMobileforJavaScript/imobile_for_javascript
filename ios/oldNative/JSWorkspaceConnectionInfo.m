//
//  JSWorkspaceConnectionInfo.m
//  iMobileRnIos
//
//  Created by imobile-xzy on 16/5/12.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSWorkspaceConnectionInfo.h"
#import "SuperMap/WorkspaceConnectionInfo.h"
#import "JSObjManager.h"




@implementation JSWorkspaceConnectionInfo


//注册为Native模块
RCT_EXPORT_MODULE();
#pragma mark - Public APIs

RCT_REMAP_METHOD(createJSObj,resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  WorkspaceConnectionInfo* info = [[WorkspaceConnectionInfo alloc]init];
  if(info){
    NSInteger key = (NSInteger)info;
    [JSObjManager addObj:info];
    resolve(@{@"ID":@(key).stringValue});
  }else{
    reject(@"WorkSpaceInfo",@"create workSaceInfo failed!!!",nil);
  }
}


RCT_REMAP_METHOD(destroyObj,destroyJSObjKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  WorkspaceConnectionInfo* info = [JSObjManager getObjWithKey:key];
  if(info){
    [info dispose];
    [JSObjManager removeObj:key];
    resolve(@"1");
  }else
    reject(@"WorkSpaceInfo",@"destroy obj failed!!!",nil);
}

RCT_REMAP_METHOD(getName,getNameKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  WorkspaceConnectionInfo* info = [JSObjManager getObjWithKey:key];
  if(info){
    resolve(info.name);
  }else
    reject(@"WorkSpaceInfo",@"workSpaceInfo not exeist!!!",nil);
}

RCT_REMAP_METHOD(setName,setNameKey:(NSString*)key name:(NSString*)name  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  WorkspaceConnectionInfo* info = [JSObjManager getObjWithKey:key];
  if(info){
    info.name = name;
    resolve(@"1");
  }else
    reject(@"WorkSpaceInfo",@"set name failed!!!",nil);
}

RCT_REMAP_METHOD(getPassWord,getPassWordByKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  WorkspaceConnectionInfo* info = [JSObjManager getObjWithKey:key];
  if(info){
    resolve(info.password);
  }else
    reject(@"WorkSpaceInfo",@"workSpaceInfo not exeist!!!",nil);
}

RCT_REMAP_METHOD(setPassWord,setPassWordByKey:(NSString*)key password:(NSString*)password resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  WorkspaceConnectionInfo* info = [JSObjManager getObjWithKey:key];
  if(info){
    info.password = password;
    resolve(@"1");
  }else
    reject(@"WorkSpaceInfo",@"set passeord failed!!!",nil);
}

RCT_REMAP_METHOD(getServer,getServerKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  WorkspaceConnectionInfo* info = [JSObjManager getObjWithKey:key];
  if(info){
      resolve(@{@"Server":info.server} );
  }else
    reject(@"WorkSpaceInfo",@"workSpaceInfo not exeist!!!",nil);
}

RCT_REMAP_METHOD(setServer,setServerKey:(NSString*)key server:(NSString*)server  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  WorkspaceConnectionInfo* info = [JSObjManager getObjWithKey:key];
  if(info){
    info.server = server;
    resolve(@"1");
  }else
    reject(@"WorkSpaceInfo",@"set server failed!!!",nil);
}

RCT_REMAP_METHOD(getUser,getUserKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  WorkspaceConnectionInfo* info = [JSObjManager getObjWithKey:key];
  if(info){
    resolve(info.user);
  }else
    reject(@"WorkSpaceInfo",@"workSpaceInfo not exeist!!!",nil);
}

RCT_REMAP_METHOD(setUser,setUserKey:(NSString*)key user:(NSString*)user  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  WorkspaceConnectionInfo* info = [JSObjManager getObjWithKey:key];
  if(info){
    info.user = user;
    resolve(@"1");
  }else
    reject(@"WorkSpaceInfo",@"set user failed!!!",nil);
}

RCT_REMAP_METHOD(setType,setTypeKey:(NSString*)key user:(int)type  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  WorkspaceConnectionInfo* info = [JSObjManager getObjWithKey:key];
  if(info){
    info.type = type;
    resolve(@"1");
  }else
    reject(@"WorkSpaceInfo",@"setType failed!!!",nil);
}

@end

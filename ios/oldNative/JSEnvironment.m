//
//  JSEnvironment.m
//  iMobileRnIos
//
//  Created by imobile-xzy on 16/5/26.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSEnvironment.h"
#import "SuperMap/Environment.h"
#import "JSObjManager.h"

@implementation JSEnvironment
//注册为Native模块
RCT_EXPORT_MODULE();

#pragma mark - Public APIs

RCT_REMAP_METHOD(setUserLicInfo,userSerialNumber:(NSString*)userSN Modules:(NSArray *)modules resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  
  [Environment setUserLicInfo:userSN Modules:modules];
  //resolve(@"1");
}
RCT_REMAP_METHOD(activateDevice,resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  
  [Environment activateDevice];
  //resolve(@"1");
}
RCT_REMAP_METHOD(setOpenGLMode,bOpenGL:(BOOL)bOpenGL resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  
  [Environment setOpenGLMode:bOpenGL];
 // resolve(@"1");
}

//RCT_REMAP_METHOD(setMainScreenScale,dScale:(BOOL)dScale resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//  
//  [Environment setMainScreenScale:dScale];
// // resolve(@"1");
//}

@end

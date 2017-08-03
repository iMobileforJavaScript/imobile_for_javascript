//
//  JSServiceBase.m
//  HelloWorldDemo
//
//  Created by 王子豪 on 2016/11/24.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSServiceBase.h"
#import "SuperMap/ServiceBase.h"
#import "JSObjManager.h"
@implementation JSServiceBase
RCT_EXPORT_MODULE();
    
RCT_REMAP_METHOD(getUrl, getUrlById:(NSString*)id resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
}
@end

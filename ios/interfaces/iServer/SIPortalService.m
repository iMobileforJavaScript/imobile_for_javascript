//
//  SIPortalService.m
//  Supermap
//
//  Created by apple on 2019/8/6.
//  Copyright © 2019 Facebook. All rights reserved.
//
#import "SIPortalService.h"

static IPortalService* m_iportalService;

@interface SIPortalService(){
   
}
@end

@implementation SIPortalService
static NSString* TAG =  @"SIPortalService";
static RCTPromiseResolveBlock _resolve;

#pragma mark -- 定义宏，让该类暴露给RN层
RCT_EXPORT_MODULE();
- (NSArray<NSString *> *)supportedEvents{
    return @[ONLINE_SERVICE_DOWNLOADING,
             ONLINE_SERVICE_UPLOADING,
             ];
}

#pragma mark -- 定义宏的方法，让该类的方法暴露给RN层
#pragma mark ---------------------------- init
RCT_REMAP_METHOD(init, initWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    m_iportalService = [IPortalService sharedInstance];
    m_iportalService.responseDelegate = self;
    resolve([NSNumber numberWithBool:YES]);
}

#pragma mark ---------------------------- 网络请求失败回调
-(void) onFailedException:(NSException*)exception{
    _resolve([NSNumber numberWithBool:NO]);
}

#pragma mark ---------------------------- login
RCT_REMAP_METHOD(login, loginWithUrl:(NSString *) url name:(NSString*)name password:(NSString*) password rememberme:(BOOL)rememberme initWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    _resolve = resolve;
    [m_iportalService loginPortalUrl:url user:name password:password remembered:rememberme];
}

#pragma mark ---------------------------- login回调
-(void) onLoginFinished:(BOOL)bSucc message:(NSString*)strInfo {
    if(bSucc){
         _resolve([NSNumber numberWithBool:bSucc]);
    } else {
        _resolve(@"登陆失败:请检查用户名和密码");
    }
}

#pragma mark ---------------------------- logout
RCT_REMAP_METHOD(logout, logoutWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    [m_iportalService logout];
    resolve([NSNumber numberWithBool:YES]);
}

#pragma mark ---------------------------- getMyAccount
RCT_REMAP_METHOD(getMyAccount, getMyAccountWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    _resolve = resolve;
    [m_iportalService getMyAccount];
}

#pragma mark ---------------------------- getMyAccount回调
-(void)myAccountResult:(NSDictionary*)result{
    _resolve([SIPortalService convertDicToString:result]);
}


+(NSString*) convertDicToString:(NSDictionary*)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}
@end

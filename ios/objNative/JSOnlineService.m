//
//  JSOnlineService.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/8/27.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSOnlineService.h"
#import "SuperMap/OnlineService.h"
#import "Constants.h"

@implementation JSOnlineService
RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents {
    return @[ONLINE_SERVICE_DOWNLOADING, ONLINE_SERVICE_DOWNLOADED, ONLINE_SERVICE_LOGIN, ONLINE_SERVICE_LOGOUT];
}

RCT_REMAP_METHOD(login, loginByUserName:(NSString *)userName password:(NSString *)password resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        OnlineService* onlineService = [OnlineService sharedService];
        [onlineService loginWithUsername:userName password:password completionCallback:^(NSError *error) {
            if ([error isEqual:nil]) {
                
            }
        }];
        NSNumber* number =[NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSOnlineService", @"download failed", nil);
    }
}

RCT_REMAP_METHOD(download, downloadByPath:(NSString *)path fileName:(NSString *)fileName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        OnlineService* onlineService = [OnlineService sharedService];
        [onlineService downloadFileName:path filePath:fileName];
        
        NSNumber* number =[NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSOnlineService", @"download failed", nil);
    }
}

- (void)bytesWritten:(int64_t) bytesWritten totalBytesWritten:(int64_t) totalBytesWritten
totalBytesExpectedToWrite:(int64_t) totalBytesExpectedToWrite {
    @try {
        long progeress = totalBytesWritten / totalBytesExpectedToWrite;
        [self sendEventWithName:ONLINE_SERVICE_DOWNLOADING
                           body:@{
                                  @"progeress": [NSNumber numberWithLong:progeress],
                                  @"downloaded": [NSNumber numberWithLong:totalBytesWritten],
                                  @"total": [NSNumber numberWithLong:totalBytesExpectedToWrite],
                                  }];
    } @catch (NSException *exception) {
        
    }
}

- (void)downloadResult:(NSString*)error {
    @try {
        [self sendEventWithName:ONLINE_SERVICE_DOWNLOADED
                           body:@{
                                  @"error": error,
                                  }];
    } @catch (NSException *exception) {
        
    }
}

@end

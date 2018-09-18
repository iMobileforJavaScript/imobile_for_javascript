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
    return @[
             ONLINE_SERVICE_DOWNLOADING,
             ONLINE_SERVICE_DOWNLOADED,
             ONLINE_SERVICE_LOGIN,
             ONLINE_SERVICE_LOGOUT,
             ONLINE_SERVICE_DOWNLOADFAILURE,
             ONLINE_SERVICE_UPLOADING,
             ONLINE_SERVICE_UPLOADED,
             ONLINE_SERVICE_UPLOADFAILURE,
             ];
}

RCT_REMAP_METHOD(login, loginByUserName:(NSString *)userName password:(NSString *)password resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        OnlineService* onlineService = [OnlineService sharedService];
        [onlineService loginWithUsername:userName password:password completionCallback:^(NSError *error) {
            if (error == nil) {
                NSLog(@"login success");
                NSNumber* number =[NSNumber numberWithBool:YES];
                resolve(number);
            } else {
                NSNumber* number =[NSNumber numberWithBool:NO];
                resolve(number);
            }
        }];
    } @catch (NSException *exception) {
        reject(@"JSOnlineService", @"download failed", nil);
    }
}

RCT_REMAP_METHOD(download, downloadByPath:(NSString *)path fileName:(NSString *)fileName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        OnlineService* onlineService = [OnlineService sharedService];
        onlineService.downloadDelegate = self;
        NSLog(@"start download");
        [onlineService downloadFileName:fileName filePath:path];
        
        NSNumber* number =[NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSOnlineService", @"download failed", nil);
    }
}

- (void)bytesWritten:(int64_t) bytesWritten totalBytesWritten:(int64_t) totalBytesWritten
totalBytesExpectedToWrite:(int64_t) totalBytesExpectedToWrite {
    @try {
        NSNumber* written = [NSNumber numberWithLongLong:totalBytesWritten];
        NSNumber* total = [NSNumber numberWithLongLong:totalBytesExpectedToWrite];
        float progress = [written floatValue] / [total floatValue] * 100;
//        float progress = totalBytesWritten / totalBytesExpectedToWrite;
        NSLog(@"downloading: %f", progress);
        [self sendEventWithName:@"com.supermap.RN.JSMapcontrol.online_service_downloading"
                           body:@{
                                  @"progress": [NSNumber numberWithFloat:progress],
                                  @"downloaded": [NSNumber numberWithLongLong:totalBytesWritten],
                                  @"total": [NSNumber numberWithLongLong:totalBytesExpectedToWrite],
                                  }];
    } @catch (NSException *exception) {
        [self sendEventWithName:ONLINE_SERVICE_DOWNLOADFAILURE
                           body:exception.reason];
    }
}

- (void)downloadResult:(NSString*)error {
    @try {
        if (error != nil) {
            [self sendEventWithName:ONLINE_SERVICE_DOWNLOADFAILURE
                               body:error];
        } else {
            [self sendEventWithName:ONLINE_SERVICE_DOWNLOADED
                               body:[NSNumber numberWithBool:YES]];
        }
        
    } @catch (NSException *exception) {
        
    }
}

RCT_REMAP_METHOD(upload, uploadByPath:(NSString *)path fileName:(NSString *)fileName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        OnlineService* onlineService = [OnlineService sharedService];
        onlineService.uploadDelegate = self;
        [onlineService uploadFilePath:path onlineFileName:fileName];
        
        NSNumber* number =[NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"JSOnlineService", @"download failed", nil);
    }
}

- (void)uploadResult:(NSString*)error {
    @try {
        if (error != nil) {
            [self sendEventWithName:ONLINE_SERVICE_UPLOADED
                               body:error];
        } else {
            [self sendEventWithName:ONLINE_SERVICE_UPLOADFAILURE
                               body:[NSNumber numberWithBool:YES]];
        }
        
    } @catch (NSException *exception) {
        
    }
}

@end

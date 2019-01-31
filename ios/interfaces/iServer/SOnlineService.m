//
//  SOnlineService.m
//  Supermap
//
//  Created by lucd on 2018/11/6.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "SOnlineService.h"
#import "Constants.h"
@interface SOnlineService(){
    OnlineService* m_onlineService;
}
@end
@implementation SOnlineService
static NSString* kTAG =  @"SOnlineService";
static NSString* downloadId = @"fileName";
static NSString* uploadId = @"uploadId";
#pragma mark -- 定义宏，让该类暴露给RN层
RCT_EXPORT_MODULE();
- (NSArray<NSString *> *)supportedEvents{
    return @[ONLINE_SERVICE_LOGIN,
             ONLINE_SERVICE_DOWNLOADFAILURE,
             ONLINE_SERVICE_DOWNLOADED,
             ONLINE_SERVICE_UPLOADED,
             ONLINE_SERVICE_UPLOADFAILURE,
             ONLINE_SERVICE_DOWNLOADING,
             ONLINE_SERVICE_UPLOADING];
}

#pragma mark -- 定义宏的方法，让该类的方法暴露给RN层
#pragma mark ---------------------------- init
RCT_REMAP_METHOD(init, initWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    m_onlineService = [OnlineService sharedService];
}
#pragma mark ---------------------------- login
RCT_REMAP_METHOD(login, loginByUserName:(NSString *)userName password:(NSString *)password resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
//        OnlineService* m_onlineService = [OnlineService sharedService];
        [m_onlineService loginWithUsername:userName password:password completionCallback:^(NSError *error) {
            if (error == nil) {
                NSNumber* number =[NSNumber numberWithBool:YES];
                resolve(number);
            } else {
                NSNumber* number =[NSNumber numberWithBool:NO];
                resolve(number);
            }
        }];
    } @catch (NSException *exception) {
        reject(kTAG, @"login failed", nil);
    }
}
#pragma mark ---------------------------- loginWithPhone
RCT_REMAP_METHOD(loginWithPhone, loginByPhoneNumber:(NSString *)phoneNumber password:(NSString *)password resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [m_onlineService loginWithPhoneNumber:phoneNumber password:password completionCallback:^(NSError *error) {
            if (error == nil) {
                NSNumber* number =[NSNumber numberWithBool:YES];
                resolve(number);
            } else {
                NSNumber* number =[NSNumber numberWithBool:NO];
                resolve(number);
            }
        }];
    } @catch (NSException *exception) {
        reject(kTAG, @"login failed", nil);
    }
}
#pragma mark ---------------------------- logout
RCT_REMAP_METHOD(logout,logoutWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
//        OnlineService* m_onlineService = [OnlineService sharedService];
        [m_onlineService logoutWithCompletionCallback:^(NSError *error) {
            if (error == nil) {
                NSLog(@"logout success");
                NSNumber* number =[NSNumber numberWithBool:YES];
                resolve(number);
            } else {
                NSNumber* number =[NSNumber numberWithBool:NO];
                resolve(number);
            }
        }];
    } @catch (NSException *exception) {
        reject(kTAG, @"logout failed", nil);
    }
}
#pragma mark ---------------------------- publishService
RCT_REMAP_METHOD(publishService,dataName:(NSString*) dataName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
//        OnlineService* m_onlineService = [OnlineService sharedService];
        [m_onlineService publishService:dataName completionHandler:^(BOOL result, NSString * _Nullable error) {
            if(result){
                NSNumber* number =[NSNumber numberWithBool:YES];
                resolve(number);
            }else{
                resolve(error);
            }
        }];
    } @catch (NSException *exception) {
        reject(kTAG, @"publishService failed", nil);
    }
}
#pragma mark ---------------------------- publishServiceWithDataId
RCT_REMAP_METHOD(publishServiceWithDataId,dataId:(NSString*) dataId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        [m_onlineService publishServiceWithDataId:dataId completionHandler:^(BOOL result, NSString * _Nullable error) {
            if(result){
                NSNumber* number =[NSNumber numberWithBool:YES];
                resolve(number);
            }else{
                resolve(error);
            }
        }];
    } @catch (NSException *exception) {
        reject(kTAG, @"publishService failed", nil);
    }
}
#pragma mark ---------------------------- getDataList
RCT_REMAP_METHOD(getDataList,getDataListCurrentPage:(NSInteger)currentPage pageSize:(NSInteger)pageSize resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
//        OnlineService* m_onlineService = [OnlineService sharedService];
        [m_onlineService getDataList:currentPage pageSize:pageSize completionHandler:^(NSString *dataJson, NSString *error) {
            if(error){
                resolve(@(NO));
            }else{
                resolve(dataJson);
            }
        }];
    } @catch (NSException *exception) {
        reject(kTAG, @"getDataList failed", nil);
    }
}
#pragma mark ---------------------------- getServiceList
RCT_REMAP_METHOD(getServiceList,getServiceListCurrentPage:(NSInteger)currentPage pageSize:(NSInteger)pageSize resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
//        OnlineService* m_onlineService = [OnlineService sharedService];
        [m_onlineService getServiceList:currentPage pageSize:pageSize completionHandler:^(NSString *serviceJson, NSString *error) {
            if(error){
                resolve(@(NO));
            }else{
                resolve(serviceJson);
            }
        }];
    } @catch (NSException *exception) {
        reject(kTAG, @"getServiceList failed", nil);
    }
}
#pragma mark ---------------------------- registerWithEmail
RCT_REMAP_METHOD(registerWithEmail, registerWithEmail:(NSString*)email  nickname:(NSString*)nickname password:(NSString*)password resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
//        OnlineService* m_onlineService = [OnlineService sharedService];
        [m_onlineService registerWithEmail:email nickname:nickname password:password completionHandler:^(BOOL result, NSString * _Nullable info) {
            if(result){
                NSNumber* number =[NSNumber numberWithBool:YES];
                resolve(number);
            }else{
                resolve(info);
            }
            
        }];
    }@catch(NSException* exception){
        reject(kTAG,@"register failed",nil);
    }
}
#pragma mark ---------------------------- registerWithPhone
RCT_REMAP_METHOD(registerWithPhone,registerWithPhone:(NSString*)phoneNumber smsVerifyCode:(NSString*)smsVerifyCode nickname:(NSString*)nickname password:(NSString*)password resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
//        OnlineService* m_onlineService = [OnlineService sharedService];
        [m_onlineService registerWithPhone:phoneNumber smsVerifyCode:smsVerifyCode nickname:nickname password:password completionHandler:^(BOOL result, NSString * _Nullable info) {
            if(result){
                NSNumber* number =[NSNumber numberWithBool:YES];
                resolve(number);
            }else{
                resolve(info);
            }
            
        }];
    }@catch(NSException* exception){
        reject(kTAG,@"RegisterPhone failed",nil);
    }
}
#pragma mark ---------------------------- sendSMSVerifyCode
RCT_REMAP_METHOD(sendSMSVerifyCode,sendSMSVerifyCodePhoneNumber:(NSString*)phoneNumber resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
//        OnlineService* m_onlineService = [OnlineService sharedService];
        [m_onlineService sendSMSVerifyCodeWithPhoneNumber:phoneNumber completionHandler:^(BOOL result, NSString * _Nullable info) {
            NSNumber* number=nil;
            if(result){
                number =[NSNumber numberWithBool:YES];
            }else{
                number =[NSNumber numberWithBool:NO];
            }
            resolve(number);
        }];
    }@catch(NSException* exception){
        reject(kTAG,@"sendSMSVerifyCode failed",nil);
    }
}

#pragma mark ---------------------------- download
RCT_REMAP_METHOD(download, downloadByPath:(NSString *)path fileName:(NSString *)fileName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
//        OnlineService* m_onlineService = [OnlineService sharedService];
        if( m_onlineService.downloadDelegate == nil){
             m_onlineService.downloadDelegate = self;
        }
        downloadId = fileName;
        if([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:nil]){
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }

        [m_onlineService downloadFileName:fileName filePath:path];
        
        NSNumber* number =[NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(kTAG, @"download failed", nil);
    }
}
#pragma mark ---------------------------- downloadWithDataId
RCT_REMAP_METHOD(downloadWithDataId, filePath:(NSString *)filePath dataId:(NSString *)dataId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        //        OnlineService* m_onlineService = [OnlineService sharedService];
        if( m_onlineService.downloadDelegate == nil){
            m_onlineService.downloadDelegate = self;
        }
        downloadId = dataId;
        [m_onlineService downloadFileWithDataId:dataId filePath:filePath];
    } @catch (NSException *exception) {
        reject(kTAG, @"download failed", nil);
    }
}
#pragma mark ---------------------------- cancelDownload
RCT_REMAP_METHOD(cancelDownload, cancelDownloadResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSInteger count = [m_onlineService downloadTasks].count;
        for(int i =0;i<count;i++){
            [m_onlineService cancelDownloadTask:i];
        }
        NSNumber* number =[NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(kTAG, @"cancelDownload failed", nil);
    }
}
#pragma mark ---------------------------- cancelAllDownload
//RCT_REMAP_METHOD(cancelAllDownload, cancelAllDownloadResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        NSInteger count = [m_onlineService downloadTasks].count;
//        for(int i =0;i<count;i++){
//            [m_onlineService cancelDownloadTask:count];
//        }
//        NSNumber* number =[NSNumber numberWithBool:YES];
//        resolve(number);
//    } @catch (NSException *exception) {
//        reject(kTAG, @"download failed", nil);
//    }
//}
#pragma mark ---------------------------- upload
RCT_REMAP_METHOD(upload, uploadByPath:(NSString *)path fileName:(NSString *)fileName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
//        OnlineService* m_onlineService = [OnlineService sharedService];
        if(m_onlineService.uploadDelegate == nil){
             m_onlineService.uploadDelegate = self;
        }
       
        [m_onlineService uploadFilePath:path onlineFileName:fileName];
        uploadId = fileName;
        NSNumber* number =[NSNumber numberWithBool:YES];
        resolve(number);
    } @catch (NSException *exception) {
        reject(kTAG, @"upload failed", nil);
    }
}

#pragma mark ---------------------------- verifyCodeImage
RCT_REMAP_METHOD(verifyCodeImage,verifyCodeImageResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
//        OnlineService* m_onlineService = [OnlineService sharedService];
        [m_onlineService verifyCodeImage:^(UIImage * _Nullable verifyCodeImage, NSString *error) {
            if(error){
                resolve(@(NO));
                return;
            }
            NSData* data = UIImagePNGRepresentation(verifyCodeImage);
            NSString* pictruePath = [NSHomeDirectory() stringByAppendingString:@"/tmp/SuperMapCaches/vefityCodeImage.png"];
            if([[NSFileManager defaultManager] fileExistsAtPath:pictruePath] ){
                [[NSFileManager defaultManager] removeItemAtPath:pictruePath error:nil];
            }else{
                [[NSFileManager defaultManager] createDirectoryAtPath:[pictruePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
            }
            [[NSFileManager defaultManager] createFileAtPath:pictruePath contents:data attributes:nil];
            resolve(pictruePath);
        }];
    }@catch(NSException* exception){
        reject(kTAG,@"verifyCodeImage failed",nil);
    }
}
#pragma mark ---------------------------- retrievePassword
RCT_REMAP_METHOD(retrievePassword,account:(NSString*)account verifyCodeImage:(NSString*)verifyCode isPhoneAccount:(BOOL)isPhoneAccount resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
//        OnlineService* m_onlineService = [OnlineService sharedService];
        [m_onlineService retrievePassword:account verifyCodeImage:verifyCode isPhoneAccount:isPhoneAccount completionHandler:^(BOOL result, NSString *error) {
            NSNumber* number=nil;
            if(result){
                NSLog(@"retrievePassword success");
                number =[NSNumber numberWithBool:YES];
            }else{
                number =[NSNumber numberWithBool:NO];
            }
            resolve(number);
        }];
    }@catch(NSException* exception){
        reject(kTAG,@"retrievePassword failed",nil);
    }
}
#pragma mark ---------------------------- retrievePasswordSecond
RCT_REMAP_METHOD(retrievePasswordSecond,firstResult:(BOOL)firstResult resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
//        OnlineService* m_onlineService = [OnlineService sharedService];
        [m_onlineService retrievePasswordSecond:firstResult completionHandler:^(BOOL result, NSString *error) {
            NSNumber* number=nil;
            if(result){
                NSLog(@"retrievePasswordSecond success");
                number =[NSNumber numberWithBool:YES];
            }else{
                number =[NSNumber numberWithBool:NO];
            }
            resolve(number);
        }];
    }@catch(NSException* exception){
        reject(kTAG,@"retrievePasswordSecond failed",nil);
    }
}
#pragma mark ---------------------------- retrievePasswordThrid
RCT_REMAP_METHOD(retrievePasswordThrid,secondResult:(BOOL)secondResult safeCode:(NSString*)safeCode resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
//        OnlineService* m_onlineService = [OnlineService sharedService];
        [m_onlineService retrievePasswordThrid:secondResult safeCode:safeCode completionHandler:^(BOOL result, NSString *error) {
            NSNumber* number=nil;
            if(result){
                NSLog(@"retrievePasswordThrid success");
                number =[NSNumber numberWithBool:YES];
            }else{
                number =[NSNumber numberWithBool:NO];
            }
            resolve(number);
        }];
    }@catch(NSException* exception){
        reject(kTAG,@"retrievePasswordThrid failed",nil);
    }
}
#pragma mark ---------------------------- retrievePasswordFourth
RCT_REMAP_METHOD(retrievePasswordFourth,thridResult:(BOOL)thridResult newPassword:(NSString*)newPassword resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
//        OnlineService* m_onlineService = [OnlineService sharedService];
        [m_onlineService retrievePasswordFourth:thridResult newPassword:newPassword completionHandler:^(BOOL result, NSString *error) {
            NSNumber* number=nil;
            if(result){
                NSLog(@"retrievePasswordFourth success");
                number =[NSNumber numberWithBool:YES];
            }else{
                number =[NSNumber numberWithBool:NO];
            }
            resolve(number);
        }];
    }@catch(NSException* exception){
        reject(kTAG,@"retrievePasswordFourth failed",nil);
    }
}
#pragma mark ---------------------------- deleteDataWithDataName
RCT_REMAP_METHOD(deleteData,deleteData:(NSString*)dataName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
//        OnlineService* m_onlineService = [OnlineService sharedService];
        [m_onlineService deleteData:dataName completionHandler:^(BOOL result, NSString *error) {
            if(result){
                NSNumber*  number =[NSNumber numberWithBool:YES];
                resolve(number);
            }else{
                resolve(error);
            }
        }];
    }@catch(NSException* exception){
        reject(kTAG,@"deleteData failed",nil);
    }
}
#pragma mark ---------------------------- deleteDataWithDataId
RCT_REMAP_METHOD(deleteDataWithDataId,deleteDataWithDataId:(NSString*)dataNameId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
        [m_onlineService deleteDataWithDataId:dataNameId completionHandler:^(BOOL result, NSString *error) {
            if(result){
                NSNumber*  number =[NSNumber numberWithBool:YES];
                resolve(number);
            }else{
                resolve(error);
            }
        }];
    }@catch(NSException* exception){
        reject(kTAG,@"deleteData failed",nil);
    }
}
#pragma mark ---------------------------- deleteServiceWithDataName
RCT_REMAP_METHOD(deleteService,deleteService:(NSString*)dataName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
//        OnlineService* m_onlineService = [OnlineService sharedService];
        [m_onlineService deleteService:dataName completionHandler:^(BOOL result, NSString *error) {
            if(result){
                NSNumber*  number =[NSNumber numberWithBool:YES];
                resolve(number);
            }else{
                resolve(error);
            }
        }];
    }@catch(NSException* exception){
        reject(kTAG,@"deleteService failed",nil);
    }
}
#pragma mark ---------------------------- deleteServiceWithServiceName
RCT_REMAP_METHOD(deleteServiceWithServiceName,deleteServiceWithServiceName:(NSString*)serviceName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
        //        OnlineService* m_onlineService = [OnlineService sharedService];
        [m_onlineService deleteServiceWithServiceName:serviceName completionHandler:^(BOOL result, NSString *error) {
            if(result){
                NSNumber*  number =[NSNumber numberWithBool:YES];
                resolve(number);
            }else{
                resolve(error);
            }
        }];
    }@catch(NSException* exception){
        reject(kTAG,@"deleteService failed",nil);
    }
}
#pragma mark ---------------------------- deleteServiceWithServiceId
RCT_REMAP_METHOD(deleteServiceWithServiceId,deleteServiceWithServiceId:(NSString*)serviceId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
        [m_onlineService deleteServiceWithServiceId:serviceId completionHandler:^(BOOL result, NSString *error) {
            if(result){
                NSNumber*  number =[NSNumber numberWithBool:YES];
                resolve(number);
            }else{
                resolve(error);
            }
        }];
    }@catch(NSException* exception){
        reject(kTAG,@"deleteService failed",nil);
    }
}
#pragma mark ---------------------------- changeServiceVisibility
RCT_REMAP_METHOD(changeServiceVisibility,changeServiceVisibility:(NSString*)serviceName isPublic:(BOOL)isPublic resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
//        OnlineService* m_onlineService = [OnlineService sharedService];
        [m_onlineService changeServiceVisibility:serviceName isPublic:isPublic completionHandler:^(BOOL result, NSString *error) {
            if(result){
                NSNumber*  number =[NSNumber numberWithBool:YES];
                resolve(number);
            }else{
                resolve(error);
            }
        }];
    } @catch (NSException *exception) {
        reject(kTAG, @"changeServiceVisibility failed", nil);
    }
}
#pragma mark ---------------------------- changeServiceVisibilityWithServiceId
RCT_REMAP_METHOD(changeServiceVisibilityWithServiceId,changeServiceVisibilityWithServiceId:(NSString*)serviceNameId isPublic:(BOOL)isPublic resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        //        OnlineService* m_onlineService = [OnlineService sharedService];
        [m_onlineService changeServiceVisibilityWithServiceId:serviceNameId isPublic:isPublic completionHandler:^(BOOL result, NSString *error) {
            if(result){
                NSNumber*  number =[NSNumber numberWithBool:YES];
                resolve(number);
            }else{
                resolve(error);
            }
        }];
    } @catch (NSException *exception) {
        reject(kTAG, @"changeServiceVisibility failed", nil);
    }
}
#pragma mark ---------------------------- changeDataVisibilityWithDataId
RCT_REMAP_METHOD(changeDataVisibilityWithDataId,changeDataVisibilityWithDataId:(NSString*)dataNameId isPublic:(BOOL)isPubilc resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
        //        OnlineService* m_onlineService = [OnlineService sharedService];
        [m_onlineService changeDataVisibilityWithDataId:dataNameId isPublic:isPubilc completionHandler:^(BOOL result, NSString *error) {
            if(result){
                NSNumber*  number =[NSNumber numberWithBool:YES];
                resolve(number);
            }else{
                resolve(error);
            }
        }];
    }@catch(NSException* exception){
        reject(kTAG,@"changeDataVisibility failed",nil);
    }
}
#pragma mark ---------------------------- changeDataVisibility
RCT_REMAP_METHOD(changeDataVisibility,changeDataVisibility:(NSString*)dataName isPublic:(BOOL)isPubilc resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
//        OnlineService* m_onlineService = [OnlineService sharedService];
        [m_onlineService changeDataVisibility:dataName isPublic:isPubilc completionHandler:^(BOOL result, NSString *error) {
            if(result){
                NSNumber*  number =[NSNumber numberWithBool:YES];
                resolve(number);
            }else{
                resolve(error);
            }
        }];
    }@catch(NSException* exception){
        reject(kTAG,@"changeDataVisibility failed",nil);
    }
}
#pragma mark ---------------------------- getAllUserDataList
RCT_REMAP_METHOD(getAllUserDataList,getAllUserDataList:(NSInteger)currentPage resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
//        OnlineService* m_onlineService = [OnlineService sharedService];
        [m_onlineService getAllUserDataList:currentPage completionHandler:^(NSString *dataJson, NSString *error) {
            if(error){
                resolve(@(NO));
            }else{
                resolve(dataJson);
            }
        }];
    }@catch(NSException* exception){
        reject(kTAG,@"getAllUserDataList failed",nil);
    }
}
#pragma mark ---------------------------- getAllUserSymbolLibList
RCT_REMAP_METHOD(getAllUserSymbolLibList,getAllUserSymbolLibList:(NSInteger)currentPage resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
//        OnlineService* m_onlineService = [OnlineService sharedService];
        [m_onlineService getAllUserSymbolLibList:currentPage completionHandler:^(NSString *dataJson, NSString *error) {
            if(error){
                resolve(@(NO));
            }else{
                resolve(dataJson);
            }
        }];
    }@catch(NSException* exception){
        reject(kTAG,@"getAllUserSymbolLibList failed",nil);
    }
}
#pragma mark ---------------------------- removeCookie
RCT_REMAP_METHOD(removeCookie, removeCookieResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try{
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in cookieStorage.cookies) {
            [cookieStorage deleteCookie:cookie];
        }
    }@catch(NSException* exception){
        reject(kTAG,@"getAllUserSymbolLibList failed",nil);
    }
}
# pragma mark ---------------------------- 下载协议
- (void)bytesWritten:(int64_t) bytesWritten totalBytesWritten:(int64_t) totalBytesWritten
totalBytesExpectedToWrite:(int64_t) totalBytesExpectedToWrite {
    @try {
        NSNumber* written = [NSNumber numberWithLongLong:totalBytesWritten];
        NSNumber* total = [NSNumber numberWithLongLong:totalBytesExpectedToWrite];
        float progress = [written floatValue] / [total floatValue] * 100;
        //        float progress = totalBytesWritten / totalBytesExpectedToWrite;
        NSLog(@"downloading: %f", progress);
        [self sendEventWithName:ONLINE_SERVICE_DOWNLOADING
                           body:@{
                                  @"progress": [NSNumber numberWithFloat:progress],
                                  @"downloaded": [NSNumber numberWithLongLong:totalBytesWritten],
                                  @"total": [NSNumber numberWithLongLong:totalBytesExpectedToWrite],
                                  @"id":downloadId
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

# pragma mark ---------------------------- 上传协议
-(void)didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    @try {
        float progress = 1.0 * totalBytesSent / totalBytesExpectedToSend * 100;
        //        float progress = totalBytesWritten / totalBytesExpectedToWrite;
        NSLog(@"uploading: %f", progress);
        [self sendEventWithName:ONLINE_SERVICE_UPLOADING
                           body:@{
                                  @"progress": [NSNumber numberWithFloat:progress],
                                  @"id":uploadId
                                  }];
    } @catch (NSException *exception) {
        [self sendEventWithName:ONLINE_SERVICE_UPLOADFAILURE
                           body:exception.reason];
    }
}


- (void)uploadResult:(NSString*)error {
    @try {
        if (error == nil) {
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

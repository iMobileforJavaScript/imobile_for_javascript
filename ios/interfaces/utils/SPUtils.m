//
//  SPUtils.m
//  Supermap
//
//  Created by xianglong li on 2019/1/15.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "SPUtils.h"
#import "SuperMap/SuperMap.h"

@implementation SPUtils
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(createFile, createFileWithResolver:(NSString*) fileName resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSDictionary* dic = [[NSDictionary alloc] init];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:dic forKey:fileName];
        resolve([NSNumber numberWithBool:true]);
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(putInt, putIntWithResolver:(NSString*)fileName key:(NSString*)key value:(int)value resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSDictionary* dic = [user objectForKey:fileName];
        NSMutableDictionary* mulDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        [mulDic setObject:([NSNumber numberWithInt:value]) forKey:key];
        NSDictionary* dicModify = [[NSDictionary alloc] initWithDictionary:mulDic];
        [user setObject:dicModify forKey:key];
        [user synchronize];
        resolve([NSNumber numberWithBool:true]);
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(putBoolean, putBooleanWithResolver:(NSString*)fileName key:(NSString*) key value:(int) value resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSDictionary* dic = [user objectForKey:fileName];
        NSMutableDictionary* mulDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        [mulDic setObject:([NSNumber numberWithBool:value]) forKey:key];
        NSDictionary* dicModify = [[NSDictionary alloc] initWithDictionary:mulDic];
        [user setObject:dicModify forKey:fileName];
        [user synchronize];
        resolve([NSNumber numberWithBool:true]);
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(putString, putStringWithResolver:(NSString*)fileName key:(NSString*) key value:(NSString*) value resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSDictionary* dic = [user objectForKey:fileName];
        NSMutableDictionary* mulDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        [mulDic setObject:value forKey:key];
        NSDictionary* dicModify = [[NSDictionary alloc] initWithDictionary:mulDic];
        [user setObject:dicModify forKey:key];
        [user synchronize];
        resolve([NSNumber numberWithBool:true]);
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(getInt, getIntWithResolver:(NSString*)fileName key:(NSString*) key value:(int) value resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSDictionary* dic = [user objectForKey:fileName];
        NSArray* arrKeys = dic.allKeys;
        if ([arrKeys containsObject:key]) {
            NSNumber* num = [dic objectForKey:key];
            resolve(num);
        }
        else{
            resolve([NSNumber numberWithInt:value]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(getBoolean, getBooleanWithResolver:(NSString*)fileName key:(NSString*) key value:(int) value resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSDictionary* dic = [user objectForKey:fileName];
        NSArray* arrKeys = dic.allKeys;
        if ([arrKeys containsObject:key]) {
            NSNumber* num = [dic objectForKey:key];
            resolve(num);
        }
        else{
            resolve([NSNumber numberWithBool:value]);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}

RCT_REMAP_METHOD(getString, getStringWithResolver:(NSString*)fileName key:(NSString*)key value:(NSString*)value resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject){
    @try{
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSDictionary* dic = [user objectForKey:fileName];
        NSArray* arrKeys = dic.allKeys;
        if ([arrKeys containsObject:key]) {
            NSString* str = [dic objectForKey:key];
            resolve(str);
        }
        else{
            resolve(value);
        }
    }
    @catch(NSException *exception){
        reject(@"workspace", exception.reason, nil);
    }
}
@end

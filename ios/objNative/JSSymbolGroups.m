//
//  JSSymbolGroups.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/15.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSSymbolGroups.h"
#import "SuperMap/SymbolGroups.h"
#import "JSObjManager.h"

@implementation JSSymbolGroups
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(createObj, createObjWithresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolGroups* groups = [[SymbolGroups alloc]init];
        NSString* key = [JSObjManager addObj:groups];
        resolve(key);
    } @catch (NSException *exception) {
        reject(@"JSSymbolGroups", exception.reason, nil);
    }
}

#pragma mark 测试指定的名称在分组集合中是否已经存在
RCT_REMAP_METHOD(contains, containsById:(NSString *)groupsId name:(NSString *)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolGroups* groups = [JSObjManager getObjWithKey:groupsId];
        bool result = [groups contains:name];
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"JSSymbolGroups", exception.reason, nil);
    }
}

#pragma mark 在该分组集合中创建子分组
RCT_REMAP_METHOD(create, createById:(NSString *)groupsId name:(NSString *)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolGroups* groups = [JSObjManager getObjWithKey:groupsId];
        SymbolGroup* group = [groups createGroupWith:name];
        NSString* groupId = [JSObjManager addObj:group];
        resolve(groupId);
    } @catch (NSException *exception) {
        reject(@"JSSymbolGroups", exception.reason, nil);
    }
}

#pragma mark 返回该分组集合中指定索引处的子分组
RCT_REMAP_METHOD(getByIndex, getById:(NSString *)groupsId index:(int)index resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolGroups* groups = [JSObjManager getObjWithKey:groupsId];
        SymbolGroup* group = [groups getGroupWithIndex:index];
        NSString* groupId = [JSObjManager addObj:group];
        resolve(groupId);
    } @catch (NSException *exception) {
        reject(@"JSSymbolGroups", exception.reason, nil);
    }
}

#pragma mark 根据给定的名称，返回分组集合中相对应的子分组
RCT_REMAP_METHOD(getByName, getGroupById:(NSString *)groupsId name:(NSString *)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolGroups* groups = [JSObjManager getObjWithKey:groupsId];
        SymbolGroup* group = [groups getGroupWithName:name];
        NSString* groupId = [JSObjManager addObj:group];
        
        resolve(groupId);
    } @catch (NSException *exception) {
        reject(@"JSSymbolGroups", exception.reason, nil);
    }
}

#pragma mark 返回该分组集合中的子分组的个数
RCT_REMAP_METHOD(getCount, getCountById:(NSString *)groupsId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolGroups* groups = [JSObjManager getObjWithKey:groupsId];
        NSInteger count = groups.count;
        
        resolve([NSNumber numberWithInteger:count]);
    } @catch (NSException *exception) {
        reject(@"JSSymbolGroups", exception.reason, nil);
    }
}

#pragma mark 返回指定名称的子分组对象（即 SymbolGroup 类对象）在该分组集合中的索引值
RCT_REMAP_METHOD(indexOf, indexOfById:(NSString *)groupsId name:(NSString *)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolGroups* groups = [JSObjManager getObjWithKey:groupsId];
        NSInteger count = [groups indexofGroup:name];
        
        resolve([NSNumber numberWithInteger:count]);
    } @catch (NSException *exception) {
        reject(@"JSSymbolGroups", exception.reason, nil);
    }
}

#pragma mark 移除该分组集合中指定名称的子分组对象
RCT_REMAP_METHOD(remove, removeById:(NSString *)groupsId name:(NSString *)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolGroups* groups = [JSObjManager getObjWithKey:groupsId];
        bool result = [groups removeGroupWith:name];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"JSSymbolGroups", exception.reason, nil);
    }
}

@end

//
//  JSSymbolGroup.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/15.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSSymbolGroup.h"
#import "SuperMap/SymbolGroup.h"
#import "SuperMap/SymbolLibrary.h"
#import "JSObjManager.h"

@implementation JSSymbolGroup
RCT_EXPORT_MODULE();

#pragma mark 测试指定的名称在分组集合中是否已经存在
RCT_REMAP_METHOD(dispose, disposeById:(NSString *)groupId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolGroup* group = [JSObjManager getObjWithKey:groupId];
//        group dispose
        [JSObjManager removeObj:groupId];
        
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"JSSymbolGroup", exception.reason,nil);
    }
}

#pragma mark 返回该分组对象中指定索引处的符号对象
RCT_REMAP_METHOD(get, getById:(NSString *)groupId index:(int)index resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolGroup* group = [JSObjManager getObjWithKey:groupId];
        Symbol* symbol = [group getSymbolWithIndex:index];
        NSString* symbolId = [JSObjManager addObj:symbol];
        
        resolve(symbolId);
    } @catch (NSException *exception) {
        reject(@"JSSymbolGroup", exception.reason,nil);
    }
}

#pragma mark 返回该分组对象的子分组集合
RCT_REMAP_METHOD(getChildGroups, getChildGroupsById:(NSString *)groupId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolGroup* group = [JSObjManager getObjWithKey:groupId];
        SymbolGroups* groups = group.childSymbolGroups;
        NSString* groupslId = [JSObjManager addObj:groups];
        
        resolve(groupslId);
    } @catch (NSException *exception) {
        reject(@"JSSymbolGroup", exception.reason,nil);
    }
}

#pragma mark 返回该分组对象中的符号对象的个数
RCT_REMAP_METHOD(getCount, getCountById:(NSString *)groupId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolGroup* group = [JSObjManager getObjWithKey:groupId];
        
        resolve([NSNumber numberWithInteger:group.count]);
    } @catch (NSException *exception) {
        reject(@"JSSymbolGroup", exception.reason,nil);
    }
}

#pragma mark 返回与该符号库分组对象相关联的符号库
RCT_REMAP_METHOD(getLibrary, getLibraryById:(NSString *)groupId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolGroup* group = [JSObjManager getObjWithKey:groupId];
        SymbolLibrary* lib = group.symbolLibrary;
        NSString* libId = [JSObjManager addObj:lib];
        
        resolve(libId);
    } @catch (NSException *exception) {
        reject(@"JSSymbolGroup", exception.reason,nil);
    }
}

#pragma mark getName() 返回该分组对象的名称，如果该分组对象的名称在其父分组中已经存在，则会抛出异常
RCT_REMAP_METHOD(getName, getNameById:(NSString *)groupId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolGroup* group = [JSObjManager getObjWithKey:groupId];
        
        resolve(group.name);
    } @catch (NSException *exception) {
        reject(@"JSSymbolGroup", exception.reason,nil);
    }
}

#pragma mark getParent() 返回该分组对象的父分组
RCT_REMAP_METHOD(getParent, getParentById:(NSString *)groupId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolGroup* group = [JSObjManager getObjWithKey:groupId];
        NSString* parentGroupId = [JSObjManager addObj:group.parentSymbolGroup];
        
        resolve(parentGroupId);
    } @catch (NSException *exception) {
        reject(@"JSSymbolGroup", exception.reason,nil);
    }
}

#pragma mark indexOf(int id)返回指定 ID 号的符号对象在该分组下的索引值。
RCT_REMAP_METHOD(indexOf, indexOfById:(NSString *)groupId targetId:(int)targetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolGroup* group = [JSObjManager getObjWithKey:groupId];
        int index = [group symbolIndexOfId:targetId];
        
        resolve([NSNumber numberWithInt:index]);
    } @catch (NSException *exception) {
        reject(@"JSSymbolGroup", exception.reason,nil);
    }
}
@end

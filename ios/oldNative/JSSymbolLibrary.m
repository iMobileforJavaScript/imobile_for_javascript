//
//  JSSymbolLibrary.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/16.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JSSymbolLibrary.h"
#import "SuperMap/SymbolLibrary.h"
#import "JSObjManager.h"

@implementation JSSymbolLibrary
RCT_EXPORT_MODULE();

#pragma mark add(Symbol) 将指定的符号对象添加到当前符号库中
RCT_REMAP_METHOD(add, addById:(NSString *)libId symbolId:(NSString *)symbolId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolLibrary* lib = [JSObjManager getObjWithKey:libId];
        Symbol* symbol = [JSObjManager getObjWithKey:symbolId];
        int index = [lib add:symbol];
        
        resolve([NSNumber numberWithInt:index]);
    } @catch (NSException *exception) {
        reject(@"SymbolLibrary", exception.reason, nil);
    }
}

#pragma mark addToGroup(Symbol, SymbolGroup) 向符号库中添加指定的符号对象
RCT_REMAP_METHOD(addToGroup, addToGroupById:(NSString *)libId symbolId:(NSString *)symbolId symbolGroupId:(NSString *)symbolGroupId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolLibrary* lib = [JSObjManager getObjWithKey:libId];
        Symbol* symbol = [JSObjManager getObjWithKey:symbolId];
        SymbolGroup* group = [JSObjManager getObjWithKey:symbolGroupId];
        int index = [lib add:symbol toGroup:group];
        
        resolve([NSNumber numberWithInt:index]);
    } @catch (NSException *exception) {
        reject(@"SymbolLibrary", exception.reason, nil);
    }
}

#pragma mark clear()清空该符号库中的所有符号对象
RCT_REMAP_METHOD(clear, clearById:(NSString *)libId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolLibrary* lib = [JSObjManager getObjWithKey:libId];
        [lib clear];
        
        resolve([NSNumber numberWithBool:YES]);
    } @catch (NSException *exception) {
        reject(@"SymbolLibrary", exception.reason, nil);
    }
}

#pragma mark contains(int id) 测试当前符号库是否包含指定的 ID 号
RCT_REMAP_METHOD(contains, containsById:(NSString *)libId targetId:(int)targetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolLibrary* lib = [JSObjManager getObjWithKey:libId];
        bool result = [lib containID:targetId];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"SymbolLibrary", exception.reason, nil);
    }
}

#pragma mark findGroup(int id) 根据指定符号的 ID 号，查找该符号所属的分组
RCT_REMAP_METHOD(findGroup, findGroupById:(NSString *)libId targetId:(int)targetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolLibrary* lib = [JSObjManager getObjWithKey:libId];
        SymbolGroup* group = [lib findGroupWithID:targetId];
        NSString* groupId = [JSObjManager addObj:group];
        
        resolve(groupId);
    } @catch (NSException *exception) {
        reject(@"SymbolLibrary", exception.reason, nil);
    }
}

#pragma mark findSymbol(int id) 在该符号库中查找指定 ID 号的符号对象
RCT_REMAP_METHOD(findSymbol, findSymbolById:(NSString *)libId targetId:(int)targetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolLibrary* lib = [JSObjManager getObjWithKey:libId];
        Symbol* symbol = [lib findSymbolWithID:targetId];
        NSString* symbolId = [JSObjManager addObj:symbol];
        
        resolve(symbolId);
    } @catch (NSException *exception) {
        reject(@"SymbolLibrary", exception.reason, nil);
    }
}

#pragma mark findSymbol(NSString* name) 根据指定的名称，在该符号库中查找该名称所对应的符号对象，返回第一个与指定名称相同的符号对象
RCT_REMAP_METHOD(findSymbolWithName, findSymbolWithNameById:(NSString *)libId name:(NSString *)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolLibrary* lib = [JSObjManager getObjWithKey:libId];
        Symbol* symbol = [lib findSymbolWithName:name];
        NSString* symbolId = [JSObjManager addObj:symbol];
        
        resolve(symbolId);
    } @catch (NSException *exception) {
        reject(@"SymbolLibrary", exception.reason, nil);
    }
}

#pragma mark fromFile(NSString* fileName) 导入符号库文件，该操作会先删除当前符号库中已经存在的符号
RCT_REMAP_METHOD(fromFile, fromFileById:(NSString *)libId fileName:(NSString *)fileName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolLibrary* lib = [JSObjManager getObjWithKey:libId];
        bool result = [lib fromFile:fileName];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"SymbolLibrary", exception.reason, nil);
    }
}

#pragma mark getRootGroup() 返回符号库的根组对象
RCT_REMAP_METHOD(getRootGroup, getRootGroupById:(NSString *)libId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolLibrary* lib = [JSObjManager getObjWithKey:libId];
        SymbolGroup* group = lib.rootGroup;
        NSString* rootGroupId = [JSObjManager addObj:group];
        
        resolve(rootGroupId);
    } @catch (NSException *exception) {
        reject(@"SymbolLibrary", exception.reason, nil);
    }
}

#pragma mark moveTo(int id, SymbolGroup group) 把指定的符号对象移动到指定的符号分组中
RCT_REMAP_METHOD(moveTo, moveToById:(NSString *)libId targetId:(int)targetId groupId:(NSString *)groupId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolLibrary* lib = [JSObjManager getObjWithKey:libId];
        SymbolGroup* group = [JSObjManager getObjWithKey:groupId];
        bool result = [lib moveSymbolByID:targetId toGroup:group];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"SymbolLibrary", exception.reason, nil);
    }
}

#pragma mark remove(int id) 根据指定的 ID 号，移除该符号库中相应的符号对象
RCT_REMAP_METHOD(remove, removeById:(NSString *)libId targetId:(int)targetId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SymbolLibrary* lib = [JSObjManager getObjWithKey:libId];
        bool result = [lib removeWithID:targetId];
        
        resolve([NSNumber numberWithBool:result]);
    } @catch (NSException *exception) {
        reject(@"SymbolLibrary", exception.reason, nil);
    }
}
@end

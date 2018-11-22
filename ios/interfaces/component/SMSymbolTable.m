//
//  SMSymbolTable.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/11/13.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "SMSymbolTable.h"

@implementation SMSymbolTable
RCT_EXPORT_MODULE()
- (NSArray<NSString *> *)supportedEvents
{
    return @[
             SYMBOL_CLICK,
             ];
}

- (UIView *)view
{
    return [[SymbolLibLegend alloc] init];
}

-(void)onCellViewClickEvent:(NSInteger)symbolID symbolName:(NSString*)symbolName {
    
}

#pragma mark 获取指定SymbolGroup中所有的group
RCT_REMAP_METHOD(findSymbolGroups, findSymbolGroups:(NSString *)type path:(NSString *)path resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Resources* resoures = [SMap singletonInstance].smMapWC.workspace.resources;
        NSArray* groups = [SMSymbol getSymbolGroups:resoures type:type path:path];
        
        resolve(groups);
    } @catch (NSException *exception) {
        reject(@"MapControl", exception.reason, nil);
    }
}

@end

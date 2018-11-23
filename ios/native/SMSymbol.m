//
//  SMSymbolLibrary.m
//  Supermap
//
//  Created by Yang Shang Long on 2018/11/13.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "SMSymbol.h"

@implementation SMSymbol
+ (NSArray *)getSymbolGroups:(Resources *)resources type:(NSString *)type path:(NSString *)path {
    SymbolLibrary* symbolLib;
    NSMutableArray* groupArr = [[NSMutableArray alloc] init];
    SymbolGroup* group;
    
    if ([type isEqualToString:@""] && [path isEqualToString:@""]) {
        [groupArr addObject:@{
                              @"name": resources.fillLibrary.rootGroup.name,
                              @"count": [NSNumber numberWithInteger:resources.fillLibrary.rootGroup.count],
                              @"childGroups": [self findAllSymbolGroups:resources.fillLibrary.rootGroup type:@"fill" path:resources.fillLibrary.rootGroup.name],
                              @"path": resources.fillLibrary.rootGroup.name,
                              @"type": @"fill",
                              }];
        [groupArr addObject:@{
                              @"name": resources.lineLibrary.rootGroup.name,
                              @"count": [NSNumber numberWithInteger:resources.lineLibrary.rootGroup.count],
                              @"childGroups": [self findAllSymbolGroups:resources.lineLibrary.rootGroup type:@"line" path:resources.lineLibrary.rootGroup.name],
                              @"path": resources.lineLibrary.rootGroup.name,
                              @"type": @"line",
                              }];
        [groupArr addObject:@{
                              @"name": resources.markerLibrary.rootGroup.name,
                              @"count": [NSNumber numberWithInteger:resources.lineLibrary.rootGroup.count],
                              @"childGroups": [self findAllSymbolGroups:resources.markerLibrary.rootGroup type:@"marker" path:resources.markerLibrary.rootGroup.name],
                              @"path": resources.markerLibrary.rootGroup.name,
                              @"type": @"marker",
                              }];
        NSLog(@"%@", resources.markerLibrary.rootGroup.name);
    } else if ([type isEqualToString:@""] && ![path isEqualToString:@""]) {
        [groupArr addObject:[self findAllSymbolGroups:resources.fillLibrary.rootGroup type:@"fill" path:path]];
        [groupArr addObject:[self findAllSymbolGroups:resources.lineLibrary.rootGroup type:@"line" path:path]];
        [groupArr addObject:[self findAllSymbolGroups:resources.markerLibrary.rootGroup type:@"marker" path:path]];
    } else if (![type isEqualToString:@""]) {
        if ([type isEqualToString:@"fill"]) {
            symbolLib = resources.fillLibrary;
        } else if ([type isEqualToString:@"line"]) {
            symbolLib = resources.lineLibrary;
        } else {
            symbolLib = resources.markerLibrary;
        }
        NSString* _path;
        if ([path isEqualToString:@""]) {
            group = symbolLib.rootGroup;
            _path = group.name;
        } else {
            group = [self findSymbolGroups:resources type:type path:path];
            _path = path;
        }
        [groupArr addObject:@{
                              @"name": group.name,
                              @"count": [NSNumber numberWithInteger:group.count],
                              @"childGroups": [self findAllSymbolGroups:group type:type path:_path],
                              @"path": _path,
                              @"type": type,
                              }];
    }
    
    return groupArr;
}

+ (NSMutableArray *)findAllSymbolGroups:(SymbolGroup *)symbolGroup type:(NSString *)type path:(NSString *)path {
    NSMutableArray* groupArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < symbolGroup.childSymbolGroups.count; i++) {
        SymbolGroup* group = [symbolGroup.childSymbolGroups getGroupWithIndex:i];
        NSMutableArray* childGroupArr = [[NSMutableArray alloc] init];
        if (group.childSymbolGroups.count > 0) {
            childGroupArr = [self findAllSymbolGroups:group type:type path:[NSString stringWithFormat:@"%@/%@", path, group.name]];
        }
        [groupArr addObject:@{
                              @"name": group.name,
                              @"count": [NSNumber numberWithInteger:group.count],
                              @"childGroups": childGroupArr,
                              @"path": [NSString stringWithFormat:@"%@/%@", path, group.name],
                              @"type": type,
                              }];
    }
    
    return groupArr;
}

+ (SymbolGroup *)findSymbolGroups:(Resources *)resources type:(NSString *)type path:(NSString *)path {
    if ([type isEqualToString:@""] || [path isEqualToString:@""]) return nil;
    
    SymbolGroup* group;
    NSArray* pathParams = [path componentsSeparatedByString:@"/"];
    
    if ([type isEqualToString:@"fill"]) {
        group = resources.fillLibrary.rootGroup;
    } else if ([type isEqualToString:@"line"]) {
        group = resources.lineLibrary.rootGroup;
    } else {
        group = resources.markerLibrary.rootGroup;
    }
    
    if (pathParams.count > 1) {
        for (int i = 1; i < pathParams.count; i++) {
            group = [group.childSymbolGroups getGroupWithName:pathParams[i]];
        }
    }
    
    return group;
}

+ (NSArray *)findSymbolsByGroups:(Resources *)resources type:(NSString *)type path:(NSString *)path {
    if ([type isEqualToString:@""] || [path isEqualToString:@""]) return nil;
    NSMutableArray* symbols = [[NSMutableArray alloc] init];
    SymbolGroup* group = [self findSymbolGroups:resources type:type path:path];
    
    for (int i = 0; i < group.count; i++) {
        Symbol* symbol = [group getSymbolWithIndex:i];
        NSMutableDictionary *symbolInfo = [[NSMutableDictionary alloc] init];
        
        [symbolInfo setObject:path forKey:@"groupPath"];
        [symbolInfo setObject:[symbol getName] forKey:@"name"];
        [symbolInfo setObject:[NSNumber numberWithInteger:[symbol getID]] forKey:@"id"];
        [symbolInfo setObject:type forKey:@"type"];
        
        [symbols addObject:symbolInfo];
    }
    
    return symbols;
}

+ (NSArray *)findSymbolsByIDs:(Resources *)resources type:(NSString *)type IDs:(NSArray *)IDs {
    if (IDs == nil || IDs.count == 0) return nil;
    NSMutableArray* symbols = [[NSMutableArray alloc] init];
    
    SymbolLibrary* lib;
    if ([type isEqualToString:@"fill"]) {
        lib = resources.fillLibrary;
    } else if ([type isEqualToString:@"line"]) {
        lib = resources.lineLibrary;
    } else if ([type isEqualToString:@"marker"]) {
        lib = resources.markerLibrary;
    }
    
    for (int i = 0; i < IDs.count; i++) {
        Symbol* symbol;
        if (type == nil) {
            symbol = [self findSymbolsByID:resources ID:[(NSNumber *)IDs[i] intValue]];
        } else {
            symbol = [lib findSymbolWithID:[(NSNumber *)IDs[i] intValue]];
        }
        [symbols addObject:symbol];
    }
    
    return symbols;
}

+ (Symbol *)findSymbolsByID:(Resources *)resources ID:(int)ID {
    
    Symbol* symbol;
    symbol = [resources.fillLibrary findSymbolWithID:ID];
    if (symbol) return symbol;
    
    symbol = [resources.lineLibrary findSymbolWithID:ID];
    if (symbol) return symbol;
    
    symbol = [resources.markerLibrary findSymbolWithID:ID];
    if (symbol) return symbol;
    
    return symbol;
}


@end

//
//  SMSymbolLibrary.h
//  Supermap
//
//  Created by Yang Shang Long on 2018/11/13.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperMap/Resources.h"
#import "SuperMap/SymbolLibrary.h"
#import "SuperMap/SymbolFillLibrary.h"
#import "SuperMap/SymbolLineLibrary.h"
#import "SuperMap/SymbolMarkerLibrary.h"
#import "SuperMap/SymbolGroup.h"
#import "SuperMap/SymbolGroups.h"
#import "SuperMap/Symbol.h"

@interface SMSymbol : NSObject

+ (NSArray*)getSymbolGroups:(Resources *)resources type:(NSString *)type path:(NSString *)path;
//+ (NSMutableArray *)findAllSymbolGroups:(SymbolGroup *)symbolGroup type:(NSString *)type path:(NSString *)path;
+ (SymbolGroup *)findSymbolGroups:(Resources *)resources type:(NSString *)type path:(NSString *)path;
+ (NSArray *)findSymbolsByGroups:(Resources *)resources type:(NSString *)type path:(NSString *)path;
+ (NSArray *)findSymbolsByIDs:(Resources *)resources type:(NSString *)type IDs:(NSArray *)IDs;
@end

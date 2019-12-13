//
//  SLanguage.m
//  Supermap
//
//  Created by zhiyan xie on 2019/12/6.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "SLanguage.h"
#import "SuperMap/Toolkit.h"


static NSString* g_language = @"CN";
@implementation SLanguage
RCT_EXPORT_MODULE();

+(NSString*)getLanguage{
    return g_language;
}
RCT_REMAP_METHOD(setLanguage,language:(NSString*)language setLanguageResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
   @try {
       g_language = language;
       [Toolkit setLanguage:g_language];
       NSLog(@"-- current language %@",g_language);
       resolve(@(YES));
   }@catch (NSException *exception) {
       reject(@"SScene", exception.reason, nil);
   }
}

@end

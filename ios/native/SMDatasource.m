//
//  SMDatasource.m
//  Supermap
//
//  Created by Shanglong Yang on 2018/12/7.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "SMDatasource.h"

@implementation SMDatasource
+ (DatasourceConnectionInfo *)convertDicToInfo:(NSDictionary *)dicInfo {
    DatasourceConnectionInfo* info = [[DatasourceConnectionInfo alloc] init];
    
    NSArray* keyArr = [dicInfo allKeys];
    BOOL bDefault = YES;
    if ([keyArr containsObject:@"alias"]){
        info.alias = [dicInfo objectForKey:@"alias"];
        bDefault = NO;
    }
    
    if ([keyArr containsObject:@"engineType"]){
        NSNumber* num = [dicInfo objectForKey:@"engineType"];
        long type = num.floatValue;
        info.engineType = (EngineType)type;
    } else {
        info.engineType = ET_UDB;
    }
    
    if ([keyArr containsObject:@"server"]){
        NSString* path = [dicInfo objectForKey:@"server"];
        info.server = path;
        if(bDefault){
            info.alias = [[path lastPathComponent] stringByDeletingPathExtension];
        }
    }
    if ([keyArr containsObject:@"driver"]) info.driver = [dicInfo objectForKey:@"driver"];
    if ([keyArr containsObject:@"user"]) info.user = [dicInfo objectForKey:@"user"];
    if ([keyArr containsObject:@"readOnly"]) info.readOnly = ((NSNumber*)[dicInfo objectForKey:@"readOnly"]).boolValue;
    if ([keyArr containsObject:@"password"]) info.password = [dicInfo objectForKey:@"password"];
    if ([keyArr containsObject:@"webCoordinate"]) info.webCoordinate = [dicInfo objectForKey:@"webCoordinate"];
    if ([keyArr containsObject:@"webVersion"]) info.webVersion = [dicInfo objectForKey:@"webVersion"];
    if ([keyArr containsObject:@"webFormat"]) info.webFormat = [dicInfo objectForKey:@"webFormat"];
    if ([keyArr containsObject:@"webVisibleLayers"]) info.webVisibleLayers = [dicInfo objectForKey:@"webVisibleLayers"];
    if ([keyArr containsObject:@"webExtendParam"]) info.webExtendParam = [dicInfo objectForKey:@"webExtendParam"];
    
    return info;
}

@end

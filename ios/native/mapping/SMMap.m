//
//  SMMap.m
//  Supermap
//
//  Created by Shanglong Yang on 2019/8/7.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "SMMap.h"

@implementation SMMap
+ (NSArray *)setLayersInvisibleByGroup:(LayerGroup *)layerGroup except:(NSString *)layerPath {
    NSMutableArray* layerArr = [[NSMutableArray alloc] init];
    NSArray* paths = [layerPath componentsSeparatedByString:@"/"];
    Layer* layer = nil;
    for (int i = 0; i < [layerGroup getCount]; i++) {
        Layer* temp = [layerGroup getLayer:i];
        if (temp.visible && ![temp.name isEqualToString:paths[0]]) {
            temp.visible = NO;
            [layerArr addObject:temp];
        }
        if ([temp.name isEqualToString:paths[0]]) {
            layer = temp;
        }
    }
    
    if ([layer isKindOfClass:[LayerGroup class]] && paths.count > 1) {
        NSString* tempPath = @"";
        for (int i = 1; i < paths.count; i++) {
            tempPath = [NSString stringWithFormat:@"%@/%@", tempPath, paths[i]];
        }
        NSArray* tempArr = [self setLayersInvisibleByGroup:layerGroup except:tempPath];
        [layerArr arrayByAddingObjectsFromArray:tempArr];
    }
    
    return layerArr;
}
@end

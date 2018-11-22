//
//  SMLayer.h
//  Supermap
//
//  Created by Yang Shang Long on 2018/11/16.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperMap/Theme.h"
#import "SuperMap/LayerGroup.h"
#import "SMap.h"

@interface SMLayer : NSObject
+ (NSArray *)getLayersByType:(int)type path:(NSString *)path;
+ (NSArray *)getLayersByGroupPath:(NSString *)path;
+ (void)setLayerVisible:(NSString *)path value:(BOOL)value;
@end

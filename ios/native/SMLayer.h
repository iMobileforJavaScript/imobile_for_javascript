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
#import "SuperMap/Selection.h"
#import "SuperMap/Dataset.h"
#import "SuperMap/DatasetVector.h"
#import "SuperMap/Recordset.h"
#import "SuperMap/CursorType.h"
#import "SuperMap/Layer.h"
#import "SMap.h"
#import "NativeUtil.h"

@interface SMLayer : NSObject
+ (NSArray *)getLayersByType:(int)type path:(NSString *)path;
+ (NSArray *)getLayersByGroupPath:(NSString *)path;
+ (void)setLayerVisible:(NSString *)path value:(BOOL)value;
+ (NSDictionary *)getLayerAttribute:(NSString *)path;
+ (NSDictionary *)getSelectionAttributeByLayer:(NSString *)path ids:(NSArray *)ids;
+ (NSDictionary *)getSelectionAttributeByLayer:(NSString *)path;
@end

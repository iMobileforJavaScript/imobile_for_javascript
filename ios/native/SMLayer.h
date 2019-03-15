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
#import "SuperMap/QueryParameter.h"
#import "SuperMap/FieldInfos.h"
#import "SuperMap/FieldInfo.h"
#import "SMap.h"
#import "NativeUtil.h"

@interface SMLayer : NSObject
+ (NSArray *)getLayersByType:(int)type path:(NSString *)path;
+ (NSArray *)getLayersByGroupPath:(NSString *)path;
+ (void)setLayerVisible:(NSString *)path value:(BOOL)value;
+ (void)setLayerEditable:(NSString *)path value:(BOOL)value;
+ (NSDictionary *)getLayerAttribute:(NSString *)path page:(int)page size:(int)size;
+ (NSDictionary *)getSelectionAttributeByLayer:(NSString *)path page:(int)page size:(int)size;
+ (NSDictionary *)getAttributeByLayer:(NSString *)path ids:(NSArray *)ids;
+ (Layer *)findLayerByPath:(NSString *)path;
+ (NSString *)getLayerPath:(Layer *)layer;
+ (Layer *)findLayerByDatasetName:(NSString *)datasetName;
//+ (NSArray *)searchLayerAttribute:(NSString *)path key:(NSString *)key filter:(NSString *)filter page:(int *)page size:(int *)size;
+ (NSMutableDictionary *)searchLayerAttribute:(NSString *)path params:(NSDictionary *)params page:(int *)page size:(int *)size;
+ (NSMutableDictionary *)searchSelectionAttribute:(NSString *)path searchKey:(NSString *)searchKey page:(int)page size:(int)size;
@end

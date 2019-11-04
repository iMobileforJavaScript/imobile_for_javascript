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
#import "MediaUtil.h"
#import "InfoCallout.h"

@interface SMLayer : NSObject
+ (NSArray *)getLayersByType:(int)type path:(NSString *)path;
+ (NSArray *)getLayersByGroupPath:(NSString *)path;
+ (void)setLayerVisible:(NSString *)path value:(BOOL)value;
+ (void)setLayerEditable:(NSString *)path value:(BOOL)value;
+ (NSDictionary *)getLayerAttribute:(NSString *)path page:(int)page size:(int)size;
+ (NSDictionary *)getSelectionAttributeByLayer:(NSString *)path page:(int)page size:(int)size;
+ (NSDictionary *)getAttributeByLayer:(NSString *)path ids:(NSArray *)ids;
+ (Layer *)findLayerByPath:(NSString *)path;
+ (void)findLayerAndGroupByPath:(NSString *)path layer:(Layer**)pLayer group:(LayerGroup**)pGroup;
+ (Layer *)findLayerWithName:(NSString *)name;
+ (NSString *)getLayerPath:(Layer *)layer;
+ (Layer *)findLayerByDatasetName:(NSString *)datasetName;
//+ (NSArray *)searchLayerAttribute:(NSString *)path key:(NSString *)key filter:(NSString *)filter page:(int *)page size:(int *)size;
+ (NSMutableDictionary *)searchLayerAttribute:(NSString *)path params:(NSDictionary *)params page:(int *)page size:(int *)size;
+ (NSMutableDictionary *)searchSelectionAttribute:(NSString *)path searchKey:(NSString *)searchKey page:(int)page size:(int)size;
+ (NSMutableDictionary *)getLayerInfo:(Layer *)layer path:(NSString *)path;
+ (Layer *)addLayerByName:(NSString *)datasourceName datasetName:(NSString *)datasetName;
+ (Layer *)addLayerByName:(NSString *)datasourceName datasetIndex:(int)datasetIndex;
+ (Layer *)addLayerByIndex:(int)datasourceIndex datasetName:(NSString *)datasetName;
+ (Layer *)addLayerByIndex:(int)datasourceIndex datasetIndex:(int)datasetIndex;
+ (BOOL)setLayerFieldInfo:(Layer *)layer fieldInfos:(NSArray *)fieldInfos params:(NSDictionary *)params;
+ (InfoCallout *)addCallOutWithLongitude:(double)longitude latitude:(double)latitude image:(NSString *)imagePath;
+ (BOOL)addRecordsetFieldInfo:(NSString *)path isSelectOrLayer:(BOOL)isSelect fieldInfo:(NSDictionary*)fieldInfo;
@end

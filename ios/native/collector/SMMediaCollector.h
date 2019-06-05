//
//  SMMediaCollector.h
//  Supermap
//
//  Created by Shanglong Yang on 2019/5/24.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperMap/Point2D.h"
#import "SuperMap/Datasource.h"
#import "SuperMap/Dataset.h"
#import "SuperMap/Datasets.h"
#import "SuperMap/DatasetVector.h"
#import "SuperMap/FieldInfo.h"
#import "SuperMap/FieldInfos.h"
#import "SuperMap/DatasetVectorInfo.h"
#import "SuperMap/PrjCoordSys.h"
#import "SuperMap/GeoPoint.h"
#import "SuperMap/GeoPoint.h"
#import "SuperMap/Recordset.h"
#import "SMap.h"
#import "SMLayer.h"
#import "FileUtils.h"
#import "SMMedia.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMMediaCollector : NSObject
@property (nonatomic, strong) NSString* mediaPath;

+ (instancetype)singletonInstance;

/**
 * 根据图层名称和geoID，返回对应的SMMedia对象
 **/
+ (SMMedia *)findMediaByLayer:(Layer *)layer geoID:(int)geoID;

/**
 * 根据图层名称，返回对应的SMMedia对象列表
 **/
+ (NSArray *)findMediasByLayer:(Layer *)layer;

+ (void)addMediasByLayer:(Layer *)layer gesture:(UITapGestureRecognizer *)gesture;

+ (void)addCalloutByMedia:(SMMedia *)media recordset:(Recordset *)rs layerName:(NSString *)layerName segesturelector:(UITapGestureRecognizer *)gesture;
@end

NS_ASSUME_NONNULL_END

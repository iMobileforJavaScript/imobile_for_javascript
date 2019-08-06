//
//  ProximityAnalyst.h
//  LibUGC
//
//  Created by wnmng on 2019/7/10.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  enum {

    CDT_MINDISTANCE = 1,
    
    CDT_RANGEDISTANCE = 2
    
}ComputeDistanceType;

@class Datasource;
@class DatasetVector;
@class Recordset;
@class Point2Ds;
@class GeoRegion;


@interface ProximityAnalyst : NSObject

+(DatasetVector*)createThiessenPolygonByDataset:(DatasetVector *)sourceDataset
                                 withDatasource:(Datasource*) outputDatasource
                                          named:(NSString *) outputDatasetName
                                           clip:(GeoRegion*)clipRegion;

//+(DatasetVector*)createThiessenPolygonByRecordset:(Recordset *)sourceRecordset
//                                   withDatasource:(Datasource*) outputDatasource
//                                            named:(NSString *) outputDatasetName
//                                             clip:(GeoRegion*)clipRegion;
//
//+(DatasetVector*)createThiessenPolygonByPoints:(Point2Ds *)sourcePoints
//                                withDatasource:(Datasource*) outputDatasource
//                                         named:(NSString *) outputDatasetName
//                                          clip:(GeoRegion*)clipRegion;
//
//+(NSArray*)createThiessenPolygonByDataset:(DatasetVector *)sourceDataset
//                                     clip:(GeoRegion*)clipRegion;
//
//+(NSArray*)createThiessenPolygonByRecordset:(DatasetVector *)sourceDataset
//                                       clip:(GeoRegion*)clipRegion;
//
//+(NSArray*)createThiessenPolygonByPoints:(DatasetVector *)sourceDataset
//                                    clip:(GeoRegion*)clipRegion;

+(BOOL)computeMinDistanceOfRecordset:(Recordset*)sourceRecordset
                           reference:(Recordset*)referenceRecordset
                                 min:(double)minDistance
                                 max:(double)maxDistance
                      withDatasource:(Datasource*)outputDatasource
                               named:(NSString *) outputDatasetName;

//+(BOOL)computeMinDistanceOfGeometries:(NSArray*)sourceGeometries
//                           reference:(Recordset*)referenceRecordset
//                                 min:(double)minDistance
//                                 max:(double)maxDistance
//                      withDatasource:(Datasource*)outputDatasource
//                               named:(NSString *) outputDatasetName;

//+(NSArray*)computeMinDistanceOfRecordset:(Recordset*)sourceRecordset
//                               reference:(Recordset*)referenceRecordset
//                                     min:(double)minDistance
//                                     max:(double)maxDistance;
//
//+(NSArray*)computeMinDistanceOfGeometries:(NSArray*)sourceGeometries
//                                reference:(Recordset*)referenceRecordset
//                                      min:(double)minDistance
//                                      max:(double)maxDistance;

+(BOOL)computeRangeDistanceOfRecordset:(Recordset*)sourceRecordset
                           reference:(Recordset*)referenceRecordset
                                 min:(double)minDistance
                                 max:(double)maxDistance
                      withDatasource:(Datasource*)outputDatasource
                               named:(NSString *) outputDatasetName;

//+(BOOL)computeRangeDistanceOfGeometries:(NSArray*)sourceGeometries
//                            reference:(Recordset*)referenceRecordset
//                                  min:(double)minDistance
//                                  max:(double)maxDistance
//                       withDatasource:(Datasource*)outputDatasource
//                                named:(NSString *) outputDatasetName;
//
//+(NSArray*)computeRangeDistanceOfRecordset:(Recordset*)sourceRecordset
//                               reference:(Recordset*)referenceRecordset
//                                     min:(double)minDistance
//                                     max:(double)maxDistance;
//
//+(NSArray*)computeRangeDistanceOfGeometries:(NSArray*)sourceGeometries
//                                reference:(Recordset*)referenceRecordset
//                                      min:(double)minDistance
//                                      max:(double)maxDistance;

@end

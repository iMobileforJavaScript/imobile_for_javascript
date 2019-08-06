//
//  InterpolationAnalyst.h
//  LibUGC
//
//  Created by wnmng on 2019/7/16.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PixelFormat.h"

@class DatasetGrid,InterpolationParameter,DatasetVector,Recordset,Point2Ds,PrjCoordSys,Datasource;

@interface InterpolationAnalyst : NSObject

+(DatasetGrid*)interpolate:(InterpolationParameter*)param pointDataset:(DatasetVector*)dataset zValueField:(NSString*)zValueFieldName zValueScale:(double)zValueScale targetDatasource:(Datasource *)targetDatasource targetDataset:(NSString*)targetDatasetName pixelFormat:(OCPixelFormat)pixelFormate;

+(DatasetGrid*)interpolate:(InterpolationParameter*)param pointRecordset:(Recordset*)recordset zValueField:(NSString*)zValueFieldName zValueScale:(double)zValueScale targetDatasource:(Datasource *)targetDatasource targetDataset:(NSString*)targetDatasetName pixelFormat:(OCPixelFormat)pixelFormate;

+(DatasetGrid*)interpolate:(InterpolationParameter*)param interpolatedPoint:(Point2Ds*)points values:(NSArray*)values zValueScale:(double)zValueScale prjCoordsys:(PrjCoordSys*)prjCoordSys targetDatasource:(Datasource *)targetDatasource targetDataset:(NSString*)targetDatasetName pixelFormat:(OCPixelFormat)pixelFormate;



@end

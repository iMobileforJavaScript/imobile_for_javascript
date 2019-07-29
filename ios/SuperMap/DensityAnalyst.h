//
//  DensityAnalyst.h
//  LibUGC
//
//  Created by wnmng on 2019/7/12.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DensityAnalystParameter.h"

@class DatasetGrid,DatasetVector,Datasource,Recordset;

@interface DensityAnalyst : NSObject

+(DatasetGrid*)kernelDensity:(DensityAnalystParameter*)param dataset:(DatasetVector*)sourceDataset fieldName:(NSString*)valueFieldName targetDatasource:(Datasource*)targetDatasource  targetDataset:(NSString*) targetDatasetName;


+(DatasetGrid*)kernelDensity:(DensityAnalystParameter*)param recordset:(Recordset*)sourceRecordset fieldName:(NSString*)valueFieldName targetDatasource:(Datasource*)targetDatasource  targetDataset:(NSString*) targetDatasetName;

+(DatasetGrid*)pointDensity:(DensityAnalystParameter*)param dataset:(DatasetVector*)sourceDataset fieldName:(NSString*)valueFieldName targetDatasource:(Datasource*)targetDatasource  targetDataset:(NSString*) targetDatasetName;


+(DatasetGrid*)pointDensity:(DensityAnalystParameter*)param recordset:(Recordset*)sourceRecordset fieldName:(NSString*)valueFieldName targetDatasource:(Datasource*)targetDatasource  targetDataset:(NSString*) targetDatasetName;


@end

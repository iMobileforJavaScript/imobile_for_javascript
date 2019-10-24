//
//  NetworkBuilder.h
//  LibUGC
//
//  Created by zhouyuming on 2019/10/23.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkSplitMode.h"
@class DatasetVector;
@class Datasource;

@interface NetworkBuilder : NSObject

//构建网络数据集
+(DatasetVector *) buildNetwork:(NSArray*)lineDatasets pointDatasets:(NSArray*)pointDatasets lineFieldNames:(NSArray*)lineFieldNames pointFieldNames:(NSArray*)pointFieldNames outputDatasource:(Datasource *)outputDatasource networkDatasetName:(NSString *)networkDatasetName networkSplitMode:(NetworkSplitMode)networkSplitMode tolerance:(double)tolerance;

@end

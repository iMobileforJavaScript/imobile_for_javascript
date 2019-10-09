//
//  TopologyProcessing.h
//  LibUGC
//
//  Created by zhouyuming on 2019/10/8.
//  Copyright © 2019年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recordset.h"
@class TopologyProcessingOptions,DatasetVector;

@interface TopologyProcessing : NSObject
//根据拓扑处理选项进行拓扑处理
+ (BOOL)clean:(DatasetVector*) datasetVector withOptions:(TopologyProcessingOptions*) options;
@end

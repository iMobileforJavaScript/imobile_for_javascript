//
//  JSDatasetVectorInfo.m
//  HelloWorldDemo
//
//  Created by 王子豪 on 2016/11/21.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSDatasetVectorInfo.h"
#import "SuperMap/DatasetVectorInfo.h"
#import "JSObjManager.h"
@implementation JSDatasetVectorInfo
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObjByNameType,name:(NSString*)name type:(DatasetType)type resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        DatasetVectorInfo* info = [[DatasetVectorInfo alloc]initWithName:name datasetType:type];
        if(info){
            NSInteger key = (NSInteger)info;
            [JSObjManager addObj:info];
            resolve(@{@"datasetVectorInfoId":@(key).stringValue});
        }
    } @catch (NSException *exception) {
        reject(@"datasetVectorInfo",@"create failed!!!",nil);
    } 
}
@end

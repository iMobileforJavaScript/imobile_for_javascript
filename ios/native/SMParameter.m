//
//  SMParameter.m
//  Supermap
//
//  Created by Shanglong Yang on 2019/6/20.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "SMParameter.h"

@implementation SMParameter

+ (FacilityAnalystSetting *)setFacilitySetting:(NSDictionary *)data {
    FacilityAnalystSetting* setting = [[FacilityAnalystSetting alloc] init];
//    if ([data objectForKey:@"networkDataset"]) {
//        Layer* layer = [SMLayer findLayerByDatasetName:[data objectForKey:@"networkDataset"]];
//        setting.netWorkDataset = (DatasetVector *)layer.dataset;
//    } else if ([data objectForKey:@"networkLayer"]) {
//        Layer* layer = [SMLayer findLayerWithName:[data objectForKey:@"networkLayer"]];
//        setting.netWorkDataset = (DatasetVector *)layer.dataset;
//    } else {
//        return nil;
//    }
    
    if ([data objectForKey:@"weightFieldInfos"]) {
        NSArray* infos = [data objectForKey:@"weightFieldInfos"];
        WeightFieldInfos* weightFieldInfos = [[WeightFieldInfos alloc] init];
        for (int i = 0; i < [infos count]; i++) {
            WeightFieldInfo* info = [SMParameter setWeightFieldInfo:infos[i]];
            [weightFieldInfos add:info];
        }
        setting.weightFieldInfos = weightFieldInfos;
    }
    
    if ([data objectForKey:@"barrierEdges"]) setting.barrierEdges = [data objectForKey:@"barrierEdges"];
    if ([data objectForKey:@"barrierNodes"]) setting.barrierNodes = [data objectForKey:@"barrierNodes"];
    if ([data objectForKey:@"directionField"] != nil) setting.directionField = [data objectForKey:@"directionField"];
    if ([data objectForKey:@"edgeIDField"]) setting.edgeIDField = [data objectForKey:@"edgeIDField"];
    if ([data objectForKey:@"fNodeIDField"]) setting.fNodeIDField = [data objectForKey:@"fNodeIDField"];
    if ([data objectForKey:@"nodeIDField"]) setting.nodeIDField = [data objectForKey:@"nodeIDField"];
    if ([data objectForKey:@"tNodeIDField"]) setting.fNodeIDField = [data objectForKey:@"tNodeIDField"];
    if ([data objectForKey:@"tolerance"]) setting.tolerance = [(NSNumber *)[data objectForKey:@"tolerance"] integerValue];
    
    return setting;
}

+ (WeightFieldInfo *)setWeightFieldInfo:(NSDictionary *)data {
    WeightFieldInfo* info = [[WeightFieldInfo alloc] init];
    if ([data objectForKey:@"name"]) info.name = [data objectForKey:@"name"];
    if ([data objectForKey:@"ftWeightField"]) info.ftWeightField = [data objectForKey:@"ftWeightField"];
    if ([data objectForKey:@"tfWeightField"]) info.tfWeightField = [data objectForKey:@"tfWeightField"];
    
    return info;
}

@end

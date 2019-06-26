//
//  STransportationAnalyst.m
//  Supermap
//
//  Created by Shanglong Yang on 2019/6/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "STransportationAnalyst.h"

static TransportationAnalyst* transportationAnalyst = nil;
static Selection* selection = nil;

@implementation STransportationAnalyst
RCT_EXPORT_MODULE();

- (TransportationAnalyst *)getTransportationAnalyst{
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        transportationAnalyst = [[TransportationAnalyst alloc] init];
    });
    
    return transportationAnalyst;
}

#pragma mark 加载设施网络分析模型
RCT_REMAP_METHOD(loadModel, loadModelByDatasource:(NSDictionary *)datasourceParams datasetName:(NSString *)datasetName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Workspace* workspace = [SMap singletonInstance].smMapWC.workspace;
        NSString* alias = [datasourceParams objectForKey:@"alias"];
        Datasource* datasource = [workspace.datasources getAlias:alias];
        
        if (!datasource) {
            DatasourceConnectionInfo* info = [SMDatasource convertDicToInfo:datasourceParams];
            datasource = [workspace.datasources open:info];
        }
        
        DatasetVector* dv = (DatasetVector *)[datasource.datasets getWithName:datasetName];
        
        Layers* layers = [SMap singletonInstance].smMapWC.mapControl.map.layers;
        Layer* layer = [layers getLayerWithName:datasetName];
        if (!layer) {
            layer = [[SMap singletonInstance].smMapWC.mapControl.map.layers addDataset:dv ToHead:true];
        }
        
        // 设置除网络数据节点图层之外的图层不可选
        for (int i = 0; i < layers.getCount; i++) {
            Layer* curLayer = [layers getLayerAtIndex:i];
            if ([curLayer.name isEqualToString:layer.name]) {
                [[layers getLayerAtIndex:i] setSelectable:YES];
            } else {
                [[layers getLayerAtIndex:i] setSelectable:NO];
            }
        }
        
        selection = [layer getSelection];
        
        TransportationAnalystSetting* setting = [[TransportationAnalystSetting alloc] init];
        [setting setNetworkDataset:dv];
        [setting setNodeIDField:@"SmNodeID"];
        [setting setEdgeIDField:@"SmID"];
        [setting setFNodeIDField:@"SmFNode"];
        [setting setTNodeIDField:@"SmTNode"];
        
        WeightFieldInfo* fieldInfo = [[WeightFieldInfo alloc] init];
        [fieldInfo setName:@"length"];
        [fieldInfo setFtWeightField:@"SmLength"];
        [fieldInfo setTfWeightField:@"SmLength"];
        
        WeightFieldInfos* fieldInfos = [[WeightFieldInfos alloc] init];
        [fieldInfos add:fieldInfo];
        
        [setting setWeightFieldInfos:fieldInfos];
        
        transportationAnalyst = [self getTransportationAnalyst];
        [transportationAnalyst setAnalystSetting:setting];
        
        BOOL result = transportationAnalyst.load;
        NSNumber* number = [NSNumber numberWithBool:result];
        
        [[SMap singletonInstance].smMapWC.mapControl setAction:PAN];
        
        resolve(number);
    } @catch (NSException *exception) {
        reject(@"STransportationAnalyst", exception.reason, nil);
    }
}
@end

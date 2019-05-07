//
//  SMediaCollector.m
//  Supermap
//
//  Created by Shanglong Yang on 2019/5/7.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "SMediaCollector.h"

@implementation SMediaCollector
RCT_EXPORT_MODULE();
- (NSArray<NSString *> *)supportedEvents
{
    return @[
             MEDIA_CAPTURE,
             ];
}

#pragma mark 初始化MDataCollector
RCT_REMAP_METHOD(initMediaCollector, initMediaCollector:(NSString*)datasourceName dataset:(NSString*)datasetName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        mDataCollector = [[MDataCollector alloc] init];
        
        Datasource* ds = [mapControl.map.workspace.datasources getAlias:datasourceName];
        if (![mDataCollector setMediaDataset:ds datasetName:datasetName]) {
            mDataCollector.delegate = self;
            reject(@"SMediaCollector", @"Failed to set dataset", nil);
        } else {
            resolve([[NSNumber alloc] initWithBool:YES]);
        }
    } @catch (NSException *exception) {
        reject(@"SMediaCollector", exception.reason, nil);
    }
}

#pragma mark 采集图片
RCT_REMAP_METHOD(captureImage, captureImageWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if (mDataCollector) {
            [mDataCollector captureImage];
            resolve([[NSNumber alloc] initWithBool:YES]);
        } else {
            reject(@"SMediaCollector", @"MDataCollector should be set first", nil);
        }
    } @catch (NSException *exception) {
        reject(@"SMediaCollector", exception.reason, nil);
    }
}

-(void)onCaptureMediaFile:(BOOL)isSuccess fileName:(NSString*)mediaFileName type:(int)type {
    NSString* typeStr = @"";
    switch (type) {
        case 1:
            typeStr = @"image";
            break;
        case 2:
            typeStr = @"video";
            break;
        case 3:
            typeStr = @"audio";
            break;
            
        default:
            break;
    }
    [self sendEventWithName:MEDIA_CAPTURE
                       body:@{@"result":isSuccess,
                              @"mediaFileName":mediaFileName,
                              @"type":typeStr,
                              }];
}
@end

//
//  SMediaCollector.m
//  Supermap
//
//  Created by Shanglong Yang on 2019/5/7.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "SMediaCollector.h"

static MDataCollector* mDataCollector = nil;
static Layer* mediaLayer = nil;

@implementation SMediaCollector
RCT_EXPORT_MODULE();
- (NSArray<NSString *> *)supportedEvents
{
    return @[
             MEDIA_CAPTURE,
             MEDIA_CAPTURE_TAP_ACTION,
             ];
}

#pragma mark 初始化多媒体采集
RCT_REMAP_METHOD(initMediaCollector, initMediaCollector:(NSString *)path resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        SMMediaCollector* collector = [SMMediaCollector singletonInstance];
        collector.mediaPath = path;
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"SMediaCollector", exception.reason, nil);
    }
}

#pragma mark 添加多媒体采集
RCT_REMAP_METHOD(addMedia, addMedia:(NSDictionary*)info addToMap:(BOOL)addToMap resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        BOOL result = NO;
        SMMediaCollector* collector = [SMMediaCollector singletonInstance];
        if (!collector || [collector.mediaPath isEqualToString:@""])  {
            reject(@"SMediaCollector", @"MediaCollector should be initialized", nil);
        } else {
            MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
            NSArray* sourcePaths = [info objectForKey:@"mediaPaths"];
            NSString* datasourceName = [info objectForKey:@"datasourceName"];
            NSString* datasetName = [info objectForKey:@"datasetName"];
            
            NSString* mediaName = [NSString stringWithFormat:@"%ld", (long)[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970] * 1000];
            if (sourcePaths.count > 0) {
                mediaName = [[sourcePaths[0] lastPathComponent] stringByDeletingPathExtension];
            }
            
            SMMedia* media = [[SMMedia alloc] initWithName:mediaName];
            
            Datasource* ds = [mapControl.map.workspace.datasources getAlias:datasourceName];
            if ([media setMediaDataset:ds datasetName:datasetName]) {
                if (addToMap) {
                    mediaLayer = [SMLayer findLayerByDatasetName:datasetName];
                    if (!mediaLayer) {
                        mediaLayer = [SMLayer addLayerByName:datasourceName datasetName:datasetName];
                    }
                    
                    result = [media saveMedia:sourcePaths toDictionary:collector.mediaPath addNew:YES];
                    
                    //                sMediaCollector = [SMediaCollector singletonInstance];
                    //                [sMediaCollector addCallout:media layer:mediaLayer];
                    [self addCallout:media layer:mediaLayer];
                    
                    
                }
                
            }
            resolve(@(result));
        }
        
    } @catch (NSException *exception) {
        reject(@"SMediaCollector", exception.reason, nil);
    }
}

#pragma mark 保存/修改 多媒体采集
RCT_REMAP_METHOD(saveMediaByLayer, saveMediaByLayer:(NSString *)layerName geoID:(int)geoID toPath:(NSString *)toPath fieldInfos:(NSArray *)fieldInfos resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
   
    Layer* layer = [SMLayer findLayerWithName:layerName];
    
    @try {
        BOOL saveResult = [self saveMedia:layer geoID:geoID toPath:toPath fieldInfos:fieldInfos];
        resolve(@(saveResult));
    } @catch (NSException *exception) {
        reject(@"SMediaCollector", exception.reason, nil);
    }
}

#pragma mark 保存/修改 多媒体采集
RCT_REMAP_METHOD(saveMediaByDataset, saveMediaByDataset:(NSString *)datasetName geoID:(int)geoID toPath:(NSString *)toPath fieldInfos:(NSArray *)fieldInfos resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    
    Layer* layer = [SMLayer findLayerByDatasetName:datasetName];
    
    @try {
        BOOL saveResult = [self saveMedia:layer geoID:geoID toPath:toPath fieldInfos:fieldInfos];
        resolve(@(saveResult));
    } @catch (NSException *exception) {
        reject(@"SMediaCollector", exception.reason, nil);
    }
}

- (BOOL)saveMedia:(Layer *)layer geoID:(int)geoID toPath:(NSString *)toPath fieldInfos:(NSArray *)fieldInfos {
    @try {
        if (layer == nil) return NO;
        NSMutableArray* infos = [[NSMutableArray alloc] init];
        NSArray* copyPaths = nil;
        for (int i = 0; i < [fieldInfos count]; i++) {
            NSDictionary* dic = (NSDictionary *)fieldInfos[i];
            if ([[dic objectForKey:@"name"] isEqualToString:@"MediaFilePaths"]) {
                // MediaFilePaths 数组转成字符串
                NSString* mediaPaths = @"";
                NSArray* files = (NSArray *)[dic objectForKey:@"value"];
                if ([files count]) {
                    copyPaths = [FileUtils copyFiles:files targetDictionary:toPath];
                    for (int i = 0; i < [copyPaths count]; i++) {
                        if (i == 0) {
                            mediaPaths = copyPaths[i];
                        } else {
                            mediaPaths = [NSString stringWithFormat:@"%@,%@", mediaPaths, copyPaths[i]];
                        }
                    }
                }
                [dic setValue:mediaPaths forKey:@"value"];
            }
            
            [infos addObject:dic];
        }
        
        BOOL saveResult = NO;
        if (copyPaths != nil) {
            NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
            NSString* filter = [NSString stringWithFormat:@"SmID=%d", geoID];
            [params setObject:filter forKey:@"filter"];
            saveResult = [SMLayer setLayerFieldInfo:layer fieldInfos:infos params:params];
        }
        
        
        return saveResult;
    } @catch (NSException *exception) {
        @throw exception;
    }
}

#pragma mark 移除多媒体callout
RCT_REMAP_METHOD(removeMedia, removeMediaWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        [mapControl removeAllCallouts];
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"SMediaCollector", exception.reason, nil);
    }
}

#pragma mark 显示指定图层多媒体采集callouts
RCT_REMAP_METHOD(showMedia, showMediaWithLayerName:(NSString *)layerName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Layer* layer = [SMLayer findLayerWithName:layerName];
        
        if (layer) {
            SEL selector = @selector(callOutAction:);
            UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
            
            [tapGesture setNumberOfTapsRequired:1];
            
            [SMMediaCollector addMediasByLayer:layer gesture:tapGesture];
            resolve(@(YES));
        } else {
            reject(@"SMediaCollector", @"The layer is not exist", nil);
        }
    } @catch (NSException *exception) {
        reject(@"SMediaCollector", exception.reason, nil);
    }
}

#pragma mark 移除指定图层多媒体采集callouts
RCT_REMAP_METHOD(hideMedia, hideMediaWithLayerName:(NSString *)layerName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
        dispatch_async(dispatch_get_main_queue(), ^{
            int i = 0;
            while(i < mapControl.callouts.count) {
                InfoCallout* callout = (InfoCallout *)mapControl.callouts[i];
                if (callout && [callout.layerName isEqualToString:layerName]) {
                    [mapControl removeCalloutAtIndex:i];
                } else {
                    i++;
                }
            }
            
            [mapControl.map refresh];
        });
        
        resolve(@(YES));
    } @catch (NSException *exception) {
        reject(@"SMediaCollector", exception.reason, nil);
    }
}

//#pragma mark 初始化MDataCollector
//RCT_REMAP_METHOD(initMediaCollector, initMediaCollector:(NSString*)datasourceName dataset:(NSString*)datasetName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
//        if (!mDataCollector) {
//            mDataCollector = [[MDataCollector alloc] init];
//        }
//
//        Datasource* ds = [mapControl.map.workspace.datasources getAlias:datasourceName];
//        mDataCollector.delegate = self;
//        if (![mDataCollector setMediaDataset:ds datasetName:datasetName]) {
//            reject(@"SMediaCollector", @"Failed to set dataset", nil);
//        } else {
//            resolve([[NSNumber alloc] initWithBool:YES]);
//        }
//    } @catch (NSException *exception) {
//        reject(@"SMediaCollector", exception.reason, nil);
//    }
//}
//
//#pragma mark 捕获图像
//RCT_REMAP_METHOD(captureImage, captureImage:(NSString*)datasourceName dataset:(NSString*)datasetName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        mDataCollector = [SMediaCollector initMediaCollector:datasourceName dataset:datasetName];
//        if (mDataCollector) {
//            if (mDataCollector.delegate == nil) {
//                mDataCollector.delegate = self;
//            }
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                [mDataCollector captureImage];
//            });
//            resolve([[NSNumber alloc] initWithBool:YES]);
//        } else {
//            reject(@"SMediaCollector", @"MDataCollector should be set first", nil);
//        }
//    } @catch (NSException *exception) {
//        reject(@"SMediaCollector", exception.reason, nil);
//    }
//}
//
//#pragma mark 捕获视频
//RCT_REMAP_METHOD(captureVideo, captureVideo:(NSString*)datasourceName dataset:(NSString*)datasetName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        mDataCollector = [SMediaCollector initMediaCollector:datasourceName dataset:datasetName];
//        if (mDataCollector) {
//            if (mDataCollector.delegate == nil) {
//                mDataCollector.delegate = self;
//            }
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                [mDataCollector captureVideo];
//            });
//            resolve([[NSNumber alloc] initWithBool:YES]);
//        } else {
//            reject(@"SMediaCollector", @"MDataCollector should be set first", nil);
//        }
//    } @catch (NSException *exception) {
//        reject(@"SMediaCollector", exception.reason, nil);
//    }
//}

#pragma mark 开始采集音频
RCT_REMAP_METHOD(startCaptureAudio, startCaptureAudio:(NSString*)datasourceName dataset:(NSString*)datasetName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        mDataCollector = [SMediaCollector initMediaCollector:datasourceName dataset:datasetName];
        if (mDataCollector) {
            if (mDataCollector.delegate == nil) {
                mDataCollector.delegate = self;
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                [mDataCollector startCaptureAudio];
            });
            resolve([[NSNumber alloc] initWithBool:YES]);
        } else {
            reject(@"SMediaCollector", @"MDataCollector should be set first", nil);
        }
    } @catch (NSException *exception) {
        reject(@"SMediaCollector", exception.reason, nil);
    }
}

#pragma mark 完成采集音频
RCT_REMAP_METHOD(stopCaptureAudio, stopCaptureAudioWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        if (mDataCollector) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [mDataCollector stopCaptureAudio];
            });
            resolve([[NSNumber alloc] initWithBool:YES]);
        } else {
            reject(@"SMediaCollector", @"MDataCollector should be set first", nil);
        }
    } @catch (NSException *exception) {
        reject(@"SMediaCollector", exception.reason, nil);
    }
}

//#pragma mark 添加多媒体文件
//RCT_REMAP_METHOD(addMediaFiles, addMediaFiles:(NSArray *)files layerName:(NSString *)layerName calloutID:(int)calloutID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        if (files.count == 0) {
//            reject(@"SMediaCollector", @"files can not be empty.", nil);
//        } else if (layerName == nil || [layerName isEqualToString:@""]) {
//            reject(@"SMediaCollector", @"layerName can not be empty.", nil);
//        } else if (calloutID < 0) {
//            reject(@"SMediaCollector", @"calloutID can not be empty.", nil);
//        } else {
//            Layer* layer = [SMLayer findLayerWithName:layerName];
//            SMMedia* media = [SMMediaCollector findMediaByLayer:layer geoID:calloutID];
//            BOOL result = [media addMediaFiles:files];
//            resolve(@(result));
//        }
//    } @catch (NSException *exception) {
//        reject(@"SMediaCollector", exception.reason, nil);
//    }
//}
//
//#pragma mark 删除多媒体文件
//RCT_REMAP_METHOD(deleteMediaFiles, deleteMediaFiles:(NSArray *)files layerName:(NSString *)layerName calloutID:(int)calloutID resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
//    @try {
//        if (files.count == 0) {
//            reject(@"SMediaCollector", @"files can not be empty.", nil);
//        } else if (layerName == nil || [layerName isEqualToString:@""]) {
//            reject(@"SMediaCollector", @"layerName can not be empty.", nil);
//        } else if (calloutID < 0) {
//            reject(@"SMediaCollector", @"calloutID can not be empty.", nil);
//        } else {
//            Layer* layer = [SMLayer findLayerWithName:layerName];
//            SMMedia* media = [SMMediaCollector findMediaByLayer:layer geoID:calloutID];
//            BOOL result = [media deleteMediaFiles:files];
//            resolve(@(result));
//        }
//    } @catch (NSException *exception) {
//        reject(@"SMediaCollector", exception.reason, nil);
//    }
//}

#pragma mark 获取视频文件缩略图
RCT_REMAP_METHOD(getVideoInfo, getVideoInfo:(NSString*)path withresolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        NSDictionary* thumbnail = [MediaUtil getScreenShotImage:path];
        int duration = [MediaUtil getVideoTimeByPath:path];
        NSMutableDictionary* info = [[NSMutableDictionary alloc] initWithDictionary:thumbnail];
        [info setObject:@(duration) forKey:@"duration"];
        
        resolve(info);
    } @catch (NSException *exception) {
        reject(@"SMediaCollector", exception.reason, nil);
    }
}

+ (MDataCollector *)initMediaCollector:(NSString*)datasourceName dataset:(NSString*)datasetName {
    MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
    if (!mDataCollector) {
        mDataCollector = [[MDataCollector alloc] init];
    }
    
    Datasource* ds = [mapControl.map.workspace.datasources getAlias:datasourceName];
    if (![mDataCollector setMediaDataset:ds datasetName:datasetName]) {
        return nil;
    }
    
    mediaLayer = [SMLayer findLayerByDatasetName:datasetName];
    if (!mediaLayer) {
        mediaLayer = [SMLayer addLayerByName:datasourceName datasetName:datasetName];
    }
    
    
    return mDataCollector;
}


/** 回调 **/
- (void)callOutAction:(UITapGestureRecognizer *)tapGesture {
    InfoCallout* callout = (InfoCallout *)tapGesture.view;
    Point2D* pt = [callout getLocation];
    SMap* sMap = [SMap singletonInstance];
    if ([sMap.smMapWC.mapControl.map.prjCoordSys type] != PCST_EARTH_LONGITUDE_LATITUDE) {//若投影坐标不是经纬度坐标则进行转换
        Point2Ds *points = [[Point2Ds alloc]init];
        [points add:pt];
        PrjCoordSys *srcPrjCoorSys = [[PrjCoordSys alloc]init];
        [srcPrjCoorSys setType:PCST_EARTH_LONGITUDE_LATITUDE];
        CoordSysTransParameter *param = [[CoordSysTransParameter alloc]init];
        
        //根据源投影坐标系与目标投影坐标系对坐标点串进行投影转换，结果将直接改变源坐标点串
        [CoordSysTranslator convert:points PrjCoordSys:[sMap.smMapWC.mapControl.map prjCoordSys] PrjCoordSys:srcPrjCoorSys CoordSysTransParameter:param CoordSysTransMethod:MTH_GEOCENTRIC_TRANSLATION];
        pt = [points getItem:0];
    }
    
    Layer* layer = [SMLayer findLayerWithName:callout.layerName];
    DatasetVector* dv = (DatasetVector*) layer.dataset;

    QueryParameter* qp = [[QueryParameter alloc] init];
    Recordset* recordset;
    qp.attriButeFilter = [NSString stringWithFormat:@"SmID=%d", callout.geoID];
    qp.cursorType = STATIC;
    recordset = [dv query:qp];

    NSString* modifiedDate = (NSString *)[recordset getFieldValueWithString:@"ModifiedDate"];
    NSString* mediaFileName = (NSString *)[recordset getFieldValueWithString:@"MediaFileName"];
    
    NSString* mediaFilePaths = (NSString *)[recordset getFieldValueWithString:@"MediaFilePaths"];
    NSArray* paths = [mediaFilePaths componentsSeparatedByString:@","];
    
    NSString* httpAddress = (NSString *)[recordset getFieldValueWithString:@"HttpAddress"];
    NSString* description = (NSString *)[recordset getFieldValueWithString:@"Description"];
    [recordset dispose];

    if (self.bridge) {
        [self sendEventWithName:MEDIA_CAPTURE_TAP_ACTION
                           body:@{@"coordinate": @{@"x": @(pt.x), @"y": @(pt.y)},
                                  @"layerName": callout.layerName,
                                  @"geoID": @(callout.geoID),
                                  @"medium": @[],
                                  @"modifiedDate": modifiedDate ? modifiedDate : @"",
                                  @"mediaFileName": mediaFileName ? mediaFileName : @"",
                                  @"mediaFilePaths": paths ? paths : @[],
                                  @"httpAddress": httpAddress ? httpAddress : @"",
                                  @"description": description ? description : @"",
//                                  @"type": callout.type,
                                  }];
    }
}

- (void)addCallout:(SMMedia *)media layer:(Layer *)layer {
    if (layer) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Recordset* rs = [((DatasetVector *)layer.dataset) recordset:NO cursorType:DYNAMIC];
            [rs moveLast];
            
            SEL selector = @selector(callOutAction:);
            UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
            [tapGesture setNumberOfTapsRequired:1];
            
            [SMMediaCollector addCalloutByMedia:media recordset:rs layerName:layer.name segesturelector:tapGesture];
            
            [rs dispose];
        });
    }
}

- (void)addCalloutsByLayer:(Layer *)layer {
    if (layer) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SEL selector = @selector(callOutAction:);
            UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
            [tapGesture setNumberOfTapsRequired:1];
            
            [SMMediaCollector addMediasByLayer:layer gesture:tapGesture];
        });
    }
}

//- (void)addCalloutByMedia:(SMMedia *)media layer:(Layer *)layer {
//    Recordset* rs = [((DatasetVector *)layer.dataset) recordset:NO cursorType:DYNAMIC];
//    [rs moveLast];
//
//    double longitude = [rs.geometry getInnerPoint].x;
//    double latitude =  [rs.geometry getInnerPoint].y;
//
//
//    InfoCallout* callout = [SMLayer addCallOutWithLongitude:longitude latitude:latitude image:media.paths[0]];
//    callout.mediaFileName = media.fileName;
//    callout.mediaFilePaths = media.paths;
//    //            callout.type = media.mediaType;
//    callout.layerName = layer.name;
//    callout.httpAddress = @"";
//    callout.description = @"";
//    NSDate* date = [NSDate date];
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    callout.modifiedDate = [dateFormatter stringFromDate:date];
//
//    callout.geoID = ((NSNumber *)[rs getFieldValueWithString:@"SmID"]).intValue;
//
//    [rs edit];
//
//    NSMutableString* paths = [NSMutableString string];
//    //            for (NSString* path in callout.mediaFilePaths) {
//    //                paths appendFormat:<#(nonnull NSString *), ...#>
//    //            }
//    for (int i = 0; i < callout.mediaFilePaths.count; i++) {
//        [paths appendString:callout.mediaFilePaths[i]];
//        if (i < callout.mediaFilePaths.count - 1) {
//            [paths appendString:@","];
//        }
//    }
//
//    [rs setFieldValueWithString:@"ModifiedDate" Obj:callout.modifiedDate];
//    [rs setFieldValueWithString:@"MediaFilePaths" Obj:paths];
//    [rs setFieldValueWithString:@"Description" Obj:callout.description];
//    [rs setFieldValueWithString:@"HttpAddress" Obj:callout.httpAddress];
//
//    [rs update];
//
//    [rs dispose];
//
//    SEL selector = @selector(callOutAction:);
//    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
//
//    [callout addGestureRecognizer:tapGesture];
//    [tapGesture setNumberOfTapsRequired:1];
//}


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
    NSString* mediaFilePath = [NSString stringWithFormat:@"%@/%@", mDataCollector.localFilePath, mediaFileName];
    if (mediaLayer) {
        Recordset* rs = [((DatasetVector *)mediaLayer.dataset) recordset:NO cursorType:DYNAMIC];
        [rs moveLast];
        FieldInfo* modifiedDateInfo = [[FieldInfo alloc] initWithName:@"modifiedDate" fieldType:FT_DATE];
        FieldInfo* descriptionInfo = [[FieldInfo alloc] initWithName:@"Description" fieldType:FT_DATE];
        [rs.fieldInfos add:modifiedDateInfo];
        [rs.fieldInfos add:descriptionInfo];
        
        double longitude = [((NSNumber *)[rs getFieldValueWithString:@"SmX"]) doubleValue];
        double latitude =  [((NSNumber *)[rs getFieldValueWithString:@"SmY"]) doubleValue];
        NSString* imagePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", mediaFilePath];

        SEL selector = @selector(callOutAction:);
        InfoCallout* callout = [SMLayer addCallOutWithLongitude:longitude latitude:latitude image:imagePath];
        callout.mediaFileName = mediaFileName;
        callout.mediaFilePaths = [[NSMutableArray alloc] initWithObjects:mediaFilePath, nil];
//        callout.type = typeStr;
        callout.layerName = mediaLayer.name;
        callout.httpAddress = @"";
        callout.description = @"";
        NSDate* date = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        callout.modifiedDate = [dateFormatter stringFromDate:date];
        
        callout.geoID = ((NSNumber *)[rs getFieldValueWithString:@"SmID"]).intValue;
        
        [rs dispose];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
        
        [callout addGestureRecognizer:tapGesture];
        [tapGesture setNumberOfTapsRequired:1];
    }
    [self sendEventWithName:MEDIA_CAPTURE
                       body:@{@"result":@(isSuccess),
                              @"mediaFileName":mediaFileName,
                              @"mediaFilePaths":[[NSMutableArray alloc] initWithObjects:mediaFilePath, nil],
                              @"type":typeStr,
                              }];
}

@end

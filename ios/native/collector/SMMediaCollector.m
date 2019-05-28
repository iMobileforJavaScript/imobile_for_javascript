//
//  SMMediaCollector.m
//  Supermap
//
//  Created by Shanglong Yang on 2019/5/24.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "SMMediaCollector.h"

static SMMediaCollector* sMediaCollector = nil;

@implementation SMMediaCollector

+ (instancetype)singletonInstance{
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sMediaCollector = [[self alloc] init];
    });
    
    return sMediaCollector;
}

+ (SMMedia *)findMediaByLayer:(Layer *)layer geoID:(int)geoID {
    SMMedia* media = [[SMMedia alloc] init];
    
    DatasetVector* dsVector = (DatasetVector *)layer.dataset;
    Recordset* recordset;
    
    int tag1 = (int)[dsVector.fieldInfos indexOfWithFieldName:@"MediaFileName"];
    //        int tag2 = (int)[dsVector.fieldInfos indexOfWithFieldName:@"MediaFileType"];
    int tag3 = (int)[dsVector.fieldInfos indexOfWithFieldName:@"ModifiedDate"];
    int tag4 = (int)[dsVector.fieldInfos indexOfWithFieldName:@"MediaFilePaths"];
    int tag5 = (int)[dsVector.fieldInfos indexOfWithFieldName:@"Description"];
    int tag6 = (int)[dsVector.fieldInfos indexOfWithFieldName:@"HttpAddress"];
    
    if(tag1==-1 || tag3==-1 || tag4==-1 || tag5==-1 || tag6==-1)
        return nil;
    if([dsVector.fieldInfos get:tag1].fieldType!=FT_TEXT)
        return nil;
    //        if([dsVector.fieldInfos get:tag2].fieldType!=FT_INT16)
    //            return NO;
    if([dsVector.fieldInfos get:tag3].fieldType!=FT_TEXT)
        return nil;
    if([dsVector.fieldInfos get:tag4].fieldType!=FT_TEXT)
        return nil;
    if([dsVector.fieldInfos get:tag5].fieldType!=FT_TEXT)
        return nil;
    if([dsVector.fieldInfos get:tag6].fieldType!=FT_TEXT)
        return nil;
    if(dsVector.prjCoordSys.type != PCST_EARTH_LONGITUDE_LATITUDE)
        return nil;
    
    NSString* filter = [NSString stringWithFormat:@"SmID=%d", geoID];
    QueryParameter* queryParams = [[QueryParameter alloc] init];
    [queryParams setAttriButeFilter:filter];
    [queryParams setCursorType:STATIC];
    recordset = [dsVector query:queryParams];
    
    media.datasourse = layer.dataset.datasource;
    media.dataset = layer.dataset;
    media.fileName = (NSString *)[recordset getFieldValueWithString:@"MediaFileName"];
    
    NSString* paths = (NSString *)[recordset getFieldValueWithString:@"MediaFilePaths"];
    media.paths = [paths componentsSeparatedByString:@","];
    
//    if ([media.paths count] > 0) {
//        media.mediaDicPath = [media.paths[0] stringByDeletingLastPathComponent];
//    }
    
    double x =  [((NSNumber *)[recordset getFieldValueWithString:@"SmX"]) doubleValue];
    double y =  [((NSNumber *)[recordset getFieldValueWithString:@"SmX"]) doubleValue];
    media.location = [[Point2D alloc] initWithX:x Y:y];
    
    [recordset dispose];
    
    return media;
}

@end

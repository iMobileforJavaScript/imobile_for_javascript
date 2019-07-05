//
//  SMMedia.m
//  Supermap
//
//  Created by Shanglong Yang on 2019/5/15.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "SMMedia.h"

@implementation SMMedia

-(id)init {
    if (self = [super init]) {
        _location = [self getCurrentLocation];
    }
    return self;
}

- (id)initWithName:(NSString *)name {
    if (self = [super init]) {
        _fileName = name;
        
        self.location = [self getCurrentLocation];
    }
    return self;
}

-(Point2D *)getCurrentLocation {
    GPSData* gpsData = [NativeUtil getGPSData];
    Point2D* pt = [[Point2D alloc] initWithX:gpsData.dLongitude Y:gpsData.dLatitude];
    return pt;
}

-(BOOL)setMediaDataset:(Datasource *)datasource datasetName:(NSString *)datasetName {
    self.datasourse = datasource;
    
    DatasetVector* pDatasetVector;
    FieldInfo* fieldInfo;
    int index = (int)[datasource.datasets indexOf:datasetName];
    if (index != -1) {
        pDatasetVector = (DatasetVector*)[datasource.datasets get:index];
//        if(pDatasetVector.datasetType != POINT)
//            return NO;
//        int tag1 = (int)[pDatasetVector.fieldInfos indexOfWithFieldName:@"MediaFileName"];
////        int tag2 = (int)[pDatasetVector.fieldInfos indexOfWithFieldName:@"MediaFileType"];
//        int tag3 = (int)[pDatasetVector.fieldInfos indexOfWithFieldName:@"ModifiedDate"];
//        int tag4 = (int)[pDatasetVector.fieldInfos indexOfWithFieldName:@"MediaFilePaths"];
//        int tag5 = (int)[pDatasetVector.fieldInfos indexOfWithFieldName:@"Description"];
//        int tag6 = (int)[pDatasetVector.fieldInfos indexOfWithFieldName:@"HttpAddress"];
        
        if ((int)[pDatasetVector.fieldInfos indexOfWithFieldName:@"MediaFileName"] == -1) {
            fieldInfo = [[FieldInfo alloc]init];
            fieldInfo.fieldType = FT_TEXT;
            fieldInfo.name = @"MediaFileName";
            [pDatasetVector.fieldInfos add:fieldInfo];
            [fieldInfo dispose];
        }
        
        if ((int)[pDatasetVector.fieldInfos indexOfWithFieldName:@"ModifiedDate"] == -1) {
            fieldInfo = [[FieldInfo alloc]init];
            fieldInfo.fieldType = FT_TEXT;
            fieldInfo.name = @"ModifiedDate";
            [pDatasetVector.fieldInfos add:fieldInfo];
            [fieldInfo dispose];
        }
        
        if ((int)[pDatasetVector.fieldInfos indexOfWithFieldName:@"Description"] == -1) {
            fieldInfo = [[FieldInfo alloc]init];
            fieldInfo.fieldType = FT_TEXT;
            fieldInfo.name = @"Description";
            [pDatasetVector.fieldInfos add:fieldInfo];
            [fieldInfo dispose];
        }
        
        if ((int)[pDatasetVector.fieldInfos indexOfWithFieldName:@"MediaFilePaths"] == -1) {
            fieldInfo = [[FieldInfo alloc]init];
            fieldInfo.fieldType = FT_TEXT;
            fieldInfo.name = @"MediaFilePaths";
            fieldInfo.maxLength = 600;
            [pDatasetVector.fieldInfos add:fieldInfo];
            [fieldInfo dispose];
        }
        
        if ((int)[pDatasetVector.fieldInfos indexOfWithFieldName:@"HttpAddress"] == -1) {
            fieldInfo = [[FieldInfo alloc]init];
            fieldInfo.fieldType = FT_TEXT;
            fieldInfo.name = @"HttpAddress";
            [pDatasetVector.fieldInfos add:fieldInfo];
            [fieldInfo dispose];
        }
        
//        if(tag1==-1 || tag3==-1 || tag4==-1 || tag5==-1)
//            return NO;
//        if([pDatasetVector.fieldInfos get:tag1].fieldType!=FT_TEXT)
//            return NO;
////        if([pDatasetVector.fieldInfos get:tag2].fieldType!=FT_INT16)
////            return NO;
//        if([pDatasetVector.fieldInfos get:tag3].fieldType!=FT_TEXT)
//            return NO;
//        if([pDatasetVector.fieldInfos get:tag4].fieldType!=FT_TEXT)
//            return NO;
//        if([pDatasetVector.fieldInfos get:tag5].fieldType!=FT_TEXT)
//            return NO;
//        if([pDatasetVector.fieldInfos get:tag6].fieldType!=FT_TEXT)
//            return NO;
//        if(pDatasetVector.prjCoordSys.type != PCST_EARTH_LONGITUDE_LATITUDE)
//            return NO;
    } else {
        @try {
            DatasetVectorInfo *vectInfo = [[DatasetVectorInfo alloc]initWithName:datasetName datasetType:CAD];
            pDatasetVector = [datasource.datasets create:vectInfo];
        }
        @catch (NSException *exception) {
            NSLog(@"ERROR { mediaDataset set failed: %@ }",exception);
            return NO;
        }
        
        if (!pDatasetVector) {
            return NO;
        }
        
        fieldInfo = [[FieldInfo alloc]init];
        fieldInfo.fieldType = FT_TEXT;
        fieldInfo.name = @"MediaFileName";
        [pDatasetVector.fieldInfos add:fieldInfo];
        [fieldInfo dispose];
        
        //        fieldInfo = [[FieldInfo alloc]init];
        //        fieldInfo.fieldType = FT_INT16;
        //        fieldInfo.name = @"MediaFileType";
        //        [pDatasetVector.fieldInfos add:fieldInfo];
        
        fieldInfo = [[FieldInfo alloc]init];
        fieldInfo.fieldType = FT_TEXT;
        fieldInfo.name = @"ModifiedDate";
        [pDatasetVector.fieldInfos add:fieldInfo];
        [fieldInfo dispose];
        
        fieldInfo = [[FieldInfo alloc]init];
        fieldInfo.fieldType = FT_TEXT;
        fieldInfo.name = @"Description";
        [pDatasetVector.fieldInfos add:fieldInfo];
        [fieldInfo dispose];
        
        fieldInfo = [[FieldInfo alloc]init];
        fieldInfo.fieldType = FT_TEXT;
        fieldInfo.name = @"MediaFilePaths";
        fieldInfo.maxLength = 600;
        [pDatasetVector.fieldInfos add:fieldInfo];
        [fieldInfo dispose];
        
        fieldInfo = [[FieldInfo alloc]init];
        fieldInfo.fieldType = FT_TEXT;
        fieldInfo.name = @"HttpAddress";
        [pDatasetVector.fieldInfos add:fieldInfo];
        [fieldInfo dispose];

        pDatasetVector.prjCoordSys = [[PrjCoordSys alloc]initWithType:PCST_EARTH_LONGITUDE_LATITUDE];
    }
    
    self.dataset = pDatasetVector;
    
    return YES;
}

-(void)saveLocationDataToDataset
{
    GeoPoint* mGeoPointTem = [[GeoPoint alloc]init];
    GeoStyle* style = [[GeoStyle alloc] init];
    [style setMarkerSize:[[Size2D alloc] initWithWidth:2 Height:2]];
    [style setLineColor:[[Color alloc] initWithR:50 G:240 B:50]];
    [style setMarkerSymbolID:351];
    [style setFillForeColor:[[Color alloc] initWithR:244 G:50 B:50]];
    [mGeoPointTem setStyle:style];
    
    Recordset* mRecordset = [(DatasetVector*)_dataset recordset:NO cursorType:DYNAMIC];
    
    Point2D* pt = [[Point2D alloc]initWithX:_location.x Y:_location.y];
    if ([[SMap singletonInstance].smMapWC.mapControl.map.prjCoordSys type] != PCST_EARTH_LONGITUDE_LATITUDE) {//若投影坐标不是经纬度坐标则进行转换
        Point2Ds *points = [[Point2Ds alloc]init];
        [points add:pt];
        PrjCoordSys *srcPrjCoorSys = [[PrjCoordSys alloc]init];
        [srcPrjCoorSys setType:PCST_EARTH_LONGITUDE_LATITUDE];
        CoordSysTransParameter *param = [[CoordSysTransParameter alloc]init];

        //根据源投影坐标系与目标投影坐标系对坐标点串进行投影转换，结果将直接改变源坐标点串
        [CoordSysTranslator convert:points PrjCoordSys:srcPrjCoorSys PrjCoordSys:[[SMap singletonInstance].smMapWC.mapControl.map prjCoordSys] CoordSysTransParameter:param CoordSysTransMethod:(CoordSysTransMethod)9603];
        pt = [points getItem:0];
    }
    
    [mGeoPointTem setX:pt.x];
    [mGeoPointTem setY:pt.y];
    [mRecordset addNew:mGeoPointTem];
    
    [mRecordset edit];
    [mRecordset moveLast];
    [mRecordset setStringWithName:@"MediaFileName" StringValue:_fileName];
    
//    if([_fileName hasSuffix:@".mp4"] || [_fileName hasSuffix:@".mov"])
//        [ mRecordset setInt16WithName:@"MediaFileType" shortValue:3];
//    else if ([_fileName hasSuffix:@".jpeg"] || [_fileName hasSuffix:@".jpg"])
//        [ mRecordset setInt16WithName:@"MediaFileType" shortValue:1];
//    else if ([_fileName hasSuffix:@".acc"])
//        [ mRecordset setInt16WithName:@"MediaFileType" shortValue:2];
    
//    if ([_mediaType isEqualToString:@"video"]) {
//        [ mRecordset setInt16WithName:@"MediaFileType" shortValue:3];
//    } else if ([_mediaType isEqualToString:@"image"]) {
//        [ mRecordset setInt16WithName:@"MediaFileType" shortValue:1];
//    } else if ([_mediaType isEqualToString:@"audio"]) {
//        [ mRecordset setInt16WithName:@"MediaFileType" shortValue:2];
//    }
//    [mRecordset setStringWithName:@"MediaFileType" StringValue:_mediaType];
    
    [mRecordset update];
    
    [mRecordset dispose];
}

-(BOOL)saveMedia:(NSArray *)filePaths toDictionary:(NSString *)toDictionary addNew:(BOOL)addNew {
    BOOL res = NO;
    if (_paths.count < 0) return res;

    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error = nil;
    
    NSMutableArray* paths = [[NSMutableArray alloc] initWithArray:filePaths];
    NSString* appHomePath = [NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), @"Documents"];
    
    for (int i = 0; i < paths.count; i++) {
        NSString* filePath = [NSString stringWithFormat:@"%@%@", toDictionary, [paths[i] lastPathComponent]];
        if(
           [fileManager fileExistsAtPath:paths[i]] &&
           ![fileManager fileExistsAtPath:filePath]
           ) {
            if ([fileManager copyItemAtPath:paths[i] toPath:filePath error:&error]) {
                res = YES;
                [fileManager removeItemAtPath:paths[i] error:&error];
                paths[i] = [filePath stringByReplacingOccurrencesOfString:appHomePath withString:@""];
            } else {
                res = NO;
            }
        }
    }
    _paths = paths;
    
    if (res && addNew) [self saveLocationDataToDataset];
    return res;
}

-(BOOL)addMediaFiles:(NSArray *)files {
    if (files == nil || files.count == 0) return NO;
    NSMutableArray* addingArr = [[NSMutableArray alloc] init];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSMutableArray* paths = [[NSMutableArray alloc] initWithArray:_paths];
    
    for (int i = 0; i < files.count; i++) {
        BOOL exsit = NO;
        if (![fileManager fileExistsAtPath:files[i]]) continue;
        for (int j = 0; j < paths.count; j++) {
            if ([files[i] isEqualToString:paths[j]]) {
                exsit = YES;
                break;
            }
        }
        if (!exsit) {
            [addingArr addObject:files[i]];
        }
    }

    _paths = [paths arrayByAddingObjectsFromArray:addingArr];

    return YES;
}

-(BOOL)deleteMediaFiles:(NSArray *)files {
    if (files == nil || files.count == 0) return NO;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;
    NSMutableArray* paths = [[NSMutableArray alloc] initWithArray:_paths];

    for (int i = 0; i < files.count; i++) {
        if (![fileManager fileExistsAtPath:files[i]]) continue;
        for (int j = 0; j < paths.count; j++) {
            if ([files[i] isEqualToString:_paths[j]] && [fileManager removeItemAtPath:files[i] error:&error]) {
                [paths removeObjectAtIndex:j];
                break;
            }
        }
    }
    _paths = paths;
    return YES;
}

@end

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
    MapControl* mapControl = [SMap singletonInstance].smMapWC.mapControl;
    Collector* collector = [mapControl getCollector];
    Point2D* pt = [[Point2D alloc]initWithPoint2D:[collector getGPSPoint]];
    return pt;
}

-(BOOL)setMediaDataset:(Datasource *)datasource datasetName:(NSString *)datasetName {
    self.datasourse = datasource;
    
    DatasetVector* pDatasetVector;
    FieldInfo* fieldInfo;
    int index = (int)[datasource.datasets indexOf:datasetName];
    if (index != -1) {
        pDatasetVector = (DatasetVector*)[datasource.datasets get:index];
        if(pDatasetVector.datasetType != POINT)
            return NO;
        int tag1 = (int)[pDatasetVector.fieldInfos indexOfWithFieldName:@"MediaFileName"];
//        int tag2 = (int)[pDatasetVector.fieldInfos indexOfWithFieldName:@"MediaFileType"];
        int tag3 = (int)[pDatasetVector.fieldInfos indexOfWithFieldName:@"ModifiedDate"];
        int tag4 = (int)[pDatasetVector.fieldInfos indexOfWithFieldName:@"MediaFilePaths"];
        int tag5 = (int)[pDatasetVector.fieldInfos indexOfWithFieldName:@"Description"];
        int tag6 = (int)[pDatasetVector.fieldInfos indexOfWithFieldName:@"HttpAddress"];
        
        if(tag1==-1 || tag3==-1 || tag4==-1 || tag5==-1)
            return NO;
        if([pDatasetVector.fieldInfos get:tag1].fieldType!=FT_TEXT)
            return NO;
//        if([pDatasetVector.fieldInfos get:tag2].fieldType!=FT_INT16)
//            return NO;
        if([pDatasetVector.fieldInfos get:tag3].fieldType!=FT_TEXT)
            return NO;
        if([pDatasetVector.fieldInfos get:tag4].fieldType!=FT_TEXT)
            return NO;
        if([pDatasetVector.fieldInfos get:tag5].fieldType!=FT_TEXT)
            return NO;
        if([pDatasetVector.fieldInfos get:tag6].fieldType!=FT_TEXT)
            return NO;
        if(pDatasetVector.prjCoordSys.type != PCST_EARTH_LONGITUDE_LATITUDE)
            return NO;
    } else {
        @try {
            DatasetVectorInfo *vectInfo = [[DatasetVectorInfo alloc]initWithName:datasetName datasetType:POINT];
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
    
    Recordset* mRecordset = [(DatasetVector*)_dataset recordset:NO cursorType:DYNAMIC];
    [mRecordset edit];
    
    [mGeoPointTem setX:_location.x];
    [mGeoPointTem setY:_location.y];
    [mRecordset addNew:mGeoPointTem];
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
    
    for (int i = 0; i < paths.count; i++) {
        NSString* filePath = [NSString stringWithFormat:@"%@%@", toDictionary, [paths[i] lastPathComponent]];
        if(
           [fileManager fileExistsAtPath:paths[i]] &&
           ![fileManager fileExistsAtPath:filePath]
           ) {
            if ([fileManager copyItemAtPath:paths[i] toPath:filePath error:&error]) {
                res = YES;
                [fileManager removeItemAtPath:paths[i] error:&error];
                paths[i] = filePath;
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

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

+ (BOOL)hasMediaData:(Layer *)layer {
    DatasetVector* dsVector = (DatasetVector *)layer.dataset;
    int tag1 = (int)[dsVector.fieldInfos indexOfWithFieldName:@"MediaName"];
    //        int tag2 = (int)[dsVector.fieldInfos indexOfWithFieldName:@"MediaFileType"];
    int tag3 = (int)[dsVector.fieldInfos indexOfWithFieldName:@"ModifiedDate"];
    int tag4 = (int)[dsVector.fieldInfos indexOfWithFieldName:@"MediaFilePaths"];
    int tag5 = (int)[dsVector.fieldInfos indexOfWithFieldName:@"Description"];
    int tag6 = (int)[dsVector.fieldInfos indexOfWithFieldName:@"HttpAddress"];
    
    if(tag1==-1 || tag3==-1 || tag4==-1 || tag5==-1 || tag6==-1)
        return NO;
    if([dsVector.fieldInfos get:tag1].fieldType!=FT_TEXT)
        return NO;
    //        if([dsVector.fieldInfos get:tag2].fieldType!=FT_INT16)
    //            return NO;
    if([dsVector.fieldInfos get:tag3].fieldType!=FT_TEXT)
        return NO;
    if([dsVector.fieldInfos get:tag4].fieldType!=FT_TEXT)
        return NO;
    if([dsVector.fieldInfos get:tag5].fieldType!=FT_TEXT)
        return NO;
    if([dsVector.fieldInfos get:tag6].fieldType!=FT_TEXT)
        return NO;
//    if(dsVector.prjCoordSys.type != PCST_EARTH_LONGITUDE_LATITUDE)
//        return NO;
    
    return YES;
}

+ (SMMedia *)findMediaByLayer:(Layer *)layer geoID:(int)geoID {
    SMMedia* media = [[SMMedia alloc] init];
    
    DatasetVector* dsVector = (DatasetVector *)layer.dataset;
    Recordset* recordset;
    
    if (![SMMediaCollector hasMediaData:layer]) {
        return nil;
    }
    
    NSString* filter = [NSString stringWithFormat:@"SmID=%d", geoID];
    QueryParameter* queryParams = [[QueryParameter alloc] init];
    [queryParams setAttriButeFilter:filter];
    [queryParams setCursorType:STATIC];
    recordset = [dsVector query:queryParams];
    
    media.datasourse = layer.dataset.datasource;
    media.dataset = layer.dataset;
    media.fileName = (NSString *)[recordset getFieldValueWithString:@"MediaName"];
    media.httpAddress = (NSString *)[recordset getFieldValueWithString:@"HttpAddress"];
    media.Description = (NSString *)[recordset getFieldValueWithString:@"Description"];
    
    NSString* paths = (NSString *)[recordset getFieldValueWithString:@"MediaFilePaths"];
    media.paths = [paths componentsSeparatedByString:@","];
    
//    if ([media.paths count] > 0) {
//        media.mediaDicPath = [media.paths[0] stringByDeletingLastPathComponent];
//    }
    
    double x =  [recordset.geometry getInnerPoint].x;
    double y =  [recordset.geometry getInnerPoint].y;
    
    
    media.location = [[Point2D alloc] initWithX:x Y:y];
    
    [recordset dispose];
    
    return media;
}

+ (NSArray *)findMediasByLayer:(Layer *)layer {
    NSMutableArray* medias = [[NSMutableArray alloc] init];
    
    DatasetVector* dsVector = (DatasetVector *)layer.dataset;
    Recordset* recordset;
    
    if (![SMMediaCollector hasMediaData:layer]) {
        return nil;
    }
    
    recordset = [dsVector recordset:NO cursorType:STATIC];
    
    [recordset moveFirst];
    
    while (![recordset isEOF]) {
        SMMedia* media = [[SMMedia alloc] init];
        
        media.datasourse = layer.dataset.datasource;
        media.dataset = layer.dataset;
        media.fileName = (NSString *)[recordset getFieldValueWithString:@"MediaName"];
        media.httpAddress = (NSString *)[recordset getFieldValueWithString:@"HttpAddress"];
        media.Description = (NSString *)[recordset getFieldValueWithString:@"Description"];
        
        NSString* paths = (NSString *)[recordset getFieldValueWithString:@"MediaFilePaths"];
        media.paths = [paths componentsSeparatedByString:@","];
        
        double x =  [recordset.geometry getInnerPoint].x;
        double y =  [recordset.geometry getInnerPoint].y;
        media.location = [[Point2D alloc] initWithX:x Y:y];
        
        [medias addObject:media];
        
        [recordset moveNext];
    }
    
    [recordset dispose];
    
    return medias;
}

+ (void)addMedias:(Layer *)layer gesture:(UITapGestureRecognizer *)gesture {
    DatasetVector* dsVector = (DatasetVector *)layer.dataset;
    Recordset* recordset;
    
    if ([SMMediaCollector hasMediaData:layer]) {
        recordset = [dsVector recordset:NO cursorType:STATIC];
        
        [recordset moveFirst];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            int recordsetIndex = 0;
            while (![recordset isEOF]) {
                SMMedia* media = [[SMMedia alloc] init];
                
                media.datasourse = layer.dataset.datasource;
                media.dataset = layer.dataset;
                media.fileName = (NSString *)[recordset getFieldValueWithString:@"MediaName"];
                media.httpAddress = (NSString *)[recordset getFieldValueWithString:@"HttpAddress"];
                media.Description = (NSString *)[recordset getFieldValueWithString:@"Description"];
                
                NSString* paths = (NSString *)[recordset getFieldValueWithString:@"MediaFilePaths"];
                media.paths = [paths componentsSeparatedByString:@","];
                
                double x =  [recordset.geometry getInnerPoint].x;
                double y =  [recordset.geometry getInnerPoint].y;
                media.location = [[Point2D alloc] initWithX:x Y:y];
                
                NSString* imgPath = [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingString:@"/Documents"], media.paths[0]];
                
                InfoCallout* callout = [SMLayer addCallOutWithLongitude:x latitude:y image:imgPath];
                callout.mediaName = media.fileName;
                callout.mediaFilePaths = media.paths;
                //            callout.type = media.mediaType;
                callout.layerName = layer.name;
                callout.httpAddress = @"";
                callout.description = @"";
                NSDate* date = [NSDate date];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                callout.modifiedDate = [dateFormatter stringFromDate:date];
                
                callout.geoID = ((NSNumber *)[recordset getFieldValueWithString:@"SmID"]).intValue;
                
                if (gesture) {
                    [callout addGestureRecognizer:gesture];
                }
                
                if ([recordset moveNext]) {
                    recordsetIndex++;
                }
            }
            
            [recordset dispose];
        });
    }
}

+ (void)showMediasByLayer:(Layer *)layer gesture:(UITapGestureRecognizer *)gesture {
    DatasetVector* dsVector = (DatasetVector *)layer.dataset;
    Recordset* recordset;
    
    if ([SMMediaCollector hasMediaData:layer]) {
        recordset = [dsVector recordset:NO cursorType:STATIC];
        
        [recordset moveFirst];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            SMap* sMap = [SMap singletonInstance];
            int recordsetIndex = 0;
            Point2D* center = nil;
            while (![recordset isEOF]) {
                SMMedia* media = [[SMMedia alloc] init];
                
                media.datasourse = layer.dataset.datasource;
                media.dataset = layer.dataset;
                media.fileName = (NSString *)[recordset getFieldValueWithString:@"MediaName"];
                media.httpAddress = (NSString *)[recordset getFieldValueWithString:@"HttpAddress"];
                media.Description = (NSString *)[recordset getFieldValueWithString:@"Description"];
                
                NSString* paths = (NSString *)[recordset getFieldValueWithString:@"MediaFilePaths"];
                if (paths && paths.length > 0) {
                    media.paths = [paths componentsSeparatedByString:@","];
                    
                    double x =  [recordset.geometry getInnerPoint].x;
                    double y =  [recordset.geometry getInnerPoint].y;
                    media.location = [[Point2D alloc] initWithX:x Y:y];
                    
                    InfoCallout* callout = [SMMediaCollector getCalloutByMedia:media recordset:recordset layerName:layer.name segesturelector:gesture];
                    
                    [callout showAt:media.location Tag:callout.layerName];
                    
                    if (!center) center = callout.getLocation;
                }
                
                if ([recordset moveNext]) {
                    recordsetIndex++;
                }
            }
            
            [recordset dispose];
            
            sMap.smMapWC.mapControl.map.center = center;
            if (sMap.smMapWC.mapControl.map.scale < 0.000011947150294723098) {
                sMap.smMapWC.mapControl.map.scale = 0.000011947150294723098;
            }
            [sMap.smMapWC.mapControl.map refresh];
        });
    }
}

+ (InfoCallout *)getCalloutByMedia:(SMMedia *)media recordset:(Recordset *)recordset layerName:(NSString *)layerName segesturelector:(UITapGestureRecognizer *)gesture {
    SMap* sMap = [SMap singletonInstance];
//    Point2D* pt = [[Point2D alloc] initWithX:media.location.x Y:media.location.y];
    
    InfoCallout* callout = [[InfoCallout alloc] initWithMapControl:sMap.smMapWC.mapControl BackgroundColor:nil Alignment:CALLOUT_BOTTOM];
    callout.width = 50;
    callout.height = 50;
    callout.userInteractionEnabled = YES;
    NSString* imagePath = [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingString:@"/Documents"], media.paths[0]];
    
    NSString* extension = [[imagePath pathExtension] lowercaseString];
    UIImage* img;
    
    if ([extension isEqualToString:@"mp4"] || [extension isEqualToString:@"mov"]) {
        img = [MediaUtil getScreenShotImageFromVideoPath:imagePath];
    } else {
        img = [UIImage imageWithContentsOfFile:imagePath];
        // TODO 压缩图片
    }
    
    UIImageView* image = [[UIImageView alloc]initWithImage:img];
    image.frame = CGRectMake(0, 0, 50, 50);
    [callout addSubview:image];
    
    callout.mediaName = media.fileName;
    callout.mediaFilePaths = media.paths;
    callout.layerName = layerName;
    callout.httpAddress = @"";
    callout.description = @"";
    NSDate* date = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    callout.modifiedDate = [dateFormatter stringFromDate:date];
    
    callout.geoID = ((NSNumber *)[recordset getFieldValueWithString:@"SmID"]).intValue;
    
    if (gesture) {
        [callout addGestureRecognizer:gesture];
    }
    
    return callout;
}

+ (InfoCallout *)createCalloutByMedia:(SMMedia *)media recordset:(Recordset *)recordset layerName:(NSString *)layerName segesturelector:(UITapGestureRecognizer *)gesture {
    SMap* sMap = [SMap singletonInstance];
    Point2D* pt = [[Point2D alloc] initWithX:media.location.x Y:media.location.y];
    
    InfoCallout* callout = [[InfoCallout alloc] initWithMapControl:sMap.smMapWC.mapControl BackgroundColor:nil Alignment:CALLOUT_BOTTOM];
    callout.width = 50;
    callout.height = 50;
    callout.userInteractionEnabled = YES;
    NSString* imagePath = [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingString:@"/Documents"], media.paths[0]];
    
    NSString* extension = [[imagePath pathExtension] lowercaseString];
    UIImage* img;
    
    if ([extension isEqualToString:@"mp4"] || [extension isEqualToString:@"mov"]) {
        img = [MediaUtil getScreenShotImageFromVideoPath:imagePath];
    } else {
        img = [UIImage imageWithContentsOfFile:imagePath];
        // TODO 压缩图片
    }
    
    UIImageView* image = [[UIImageView alloc]initWithImage:img];
    image.frame = CGRectMake(0, 0, 50, 50);
    [callout addSubview:image];
    
    callout.mediaName = media.fileName;
    callout.mediaFilePaths = media.paths;
    callout.layerName = layerName;
    callout.httpAddress = media.httpAddress;
    callout.description = media.Description;
    NSDate* date = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    callout.modifiedDate = [dateFormatter stringFromDate:date];
    
    callout.geoID = ((NSNumber *)[recordset getFieldValueWithString:@"SmID"]).intValue;
    
    [recordset edit];
    
    NSMutableString* paths = [NSMutableString string];
    for (int i = 0; i < callout.mediaFilePaths.count; i++) {
        [paths appendString:callout.mediaFilePaths[i]];
        if (i < callout.mediaFilePaths.count - 1) {
            [paths appendString:@","];
        }
    }
    
    [recordset setFieldValueWithString:@"ModifiedDate" Obj:callout.modifiedDate];
    [recordset setFieldValueWithString:@"MediaFilePaths" Obj:paths];
    [recordset setFieldValueWithString:@"Description" Obj:callout.description];
    [recordset setFieldValueWithString:@"HttpAddress" Obj:callout.httpAddress];
    
    [recordset update];
    
    if (gesture) {
        [callout addGestureRecognizer:gesture];
    }
    
    [callout setLocationX:pt.x LocationY:pt.y];
    
    return callout;
}

+ (void)addCalloutByMedia:(SMMedia *)media recordset:(Recordset *)rs layerName:(NSString *)layerName segesturelector:(UITapGestureRecognizer *)gesture {
    
//    double longitude = [rs.geometry getInnerPoint].x;
//    double latitude =  [rs.geometry getInnerPoint].y;
    
    Point2D* pt = [[Point2D alloc]initWithX:media.location.x Y:media.location.y];
//    if ([[SMap singletonInstance].smMapWC.mapControl.map.prjCoordSys type] != PCST_EARTH_LONGITUDE_LATITUDE) {//若投影坐标不是经纬度坐标则进行转换
//        Point2Ds *points = [[Point2Ds alloc]init];
//        [points add:pt];
//        PrjCoordSys *srcPrjCoorSys = [[PrjCoordSys alloc]init];
//        [srcPrjCoorSys setType:PCST_EARTH_LONGITUDE_LATITUDE];
//        CoordSysTransParameter *param = [[CoordSysTransParameter alloc]init];
//
//        //根据源投影坐标系与目标投影坐标系对坐标点串进行投影转换，结果将直接改变源坐标点串
//        [CoordSysTranslator convert:points PrjCoordSys:srcPrjCoorSys PrjCoordSys:[[SMap singletonInstance].smMapWC.mapControl.map prjCoordSys] CoordSysTransParameter:param CoordSysTransMethod:(CoordSysTransMethod)9603];
//        pt = [points getItem:0];
//    }
    
    NSString* imgPath = [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingString:@"/Documents"], media.paths[0]];
//    InfoCallout* callout = [SMLayer addCallOutWithLongitude:longitude latitude:latitude image:imgPath];
    InfoCallout* callout = [SMLayer addCallOutWithLongitude:pt.x latitude:pt.y image:imgPath];
    callout.mediaName = media.fileName;
    callout.mediaFilePaths = media.paths;
    //            callout.type = media.mediaType;
    callout.layerName = layerName;
    callout.httpAddress = media.httpAddress;
    callout.description = media.Description;
    NSDate* date = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    callout.modifiedDate = [dateFormatter stringFromDate:date];
    
    callout.geoID = ((NSNumber *)[rs getFieldValueWithString:@"SmID"]).intValue;
    
    [rs edit];
    
    NSMutableString* paths = [NSMutableString string];
    //            for (NSString* path in callout.mediaFilePaths) {
    //                paths appendFormat:<#(nonnull NSString *), ...#>
    //            }
    for (int i = 0; i < callout.mediaFilePaths.count; i++) {
        [paths appendString:callout.mediaFilePaths[i]];
        if (i < callout.mediaFilePaths.count - 1) {
            [paths appendString:@","];
        }
    }
    
    [rs setFieldValueWithString:@"ModifiedDate" Obj:callout.modifiedDate];
    [rs setFieldValueWithString:@"MediaFilePaths" Obj:paths];
    [rs setFieldValueWithString:@"Description" Obj:callout.description];
    [rs setFieldValueWithString:@"HttpAddress" Obj:callout.httpAddress];
    
    [rs update];
    
    if (gesture) {
        [callout addGestureRecognizer:gesture];
    }
}

+ (void)addLineByMedias:(NSArray *)medias dataset:(DatasetVector *)dataset {
    Point2Ds* mPoints = [[Point2Ds alloc] init];
    for (SMMedia* media in medias) {
        Point2D* pt = [[Point2D alloc] initWithX:media.location.x Y:media.location.y];
        [mPoints add:pt];
    }
//    if ([[SMap singletonInstance].smMapWC.mapControl.map.prjCoordSys type] != PCST_EARTH_LONGITUDE_LATITUDE) {//若投影坐标不是经纬度坐标则进行转换
//        PrjCoordSys *srcPrjCoorSys = [[PrjCoordSys alloc]init];
//        [srcPrjCoorSys setType:PCST_EARTH_LONGITUDE_LATITUDE];
//        CoordSysTransParameter *param = [[CoordSysTransParameter alloc]init];
//
//        //根据源投影坐标系与目标投影坐标系对坐标点串进行投影转换，结果将直接改变源坐标点串
//        [CoordSysTranslator convert:mPoints PrjCoordSys:srcPrjCoorSys PrjCoordSys:[[SMap singletonInstance].smMapWC.mapControl.map prjCoordSys] CoordSysTransParameter:param CoordSysTransMethod:(CoordSysTransMethod)9603];
//    }
    
    GeoLine* mLine = [[GeoLine alloc] initWithPoint2Ds:mPoints];
    GeoStyle* style = [[GeoStyle alloc] init];
    [style setMarkerSize:[[Size2D alloc] initWithWidth:2 Height:2]];
    [style setLineColor:[[Color alloc] initWithR:70 G:128 B:223]];
    [style setLineWidth:1];
    [style setMarkerSymbolID:351];
    [style setFillForeColor:[[Color alloc] initWithR:70 G:128 B:223]];
    [mLine setStyle:style];
    
    Recordset* mRecordset = [dataset recordset:NO cursorType:DYNAMIC];
    
    [mRecordset addNew:mLine];
    
    [mRecordset moveLast];
    if ([mRecordset edit]) {
        [mRecordset setStringWithName:@"MediaName" StringValue:@"TourLine"];
    }
    
    [mRecordset update];
    
    [mRecordset dispose];
}

@end

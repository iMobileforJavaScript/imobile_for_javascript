//
//  NativeUtil.m
//  Supermap
//
//  Created by 王子豪 on 2017/11/14.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "AMapFoundationKit.h"
#import "AMapLocationKit.h"
#import "NativeUtil.h"
#import "SuperMap/Recordset.h"
#import "SuperMap/FieldInfos.h"
#import "SuperMap/FieldInfo.h"
//#import "SuperMap/GPSData.h"
@interface locationChangedDelegate :NSObject<AMapLocationManagerDelegate>
{
//    LocationManagePlugin* LocationPlugin;
//    GPSData* mGPSData;
}
@property(nonatomic,strong)GPSData* gpsData;
@property(nonatomic,strong)AMapLocationManager* Plugin;
@end
@implementation locationChangedDelegate
-(id)init{
    
    if(self = [super init]){
        [AMapServices sharedServices].apiKey = @"cbeda0d0a5c465620be7bd6cccbf39ce";
        _Plugin = [[AMapLocationManager alloc]init];
        _Plugin.delegate = self;
        //设置不允许系统暂停定位
        [_Plugin setPausesLocationUpdatesAutomatically:NO];
        //设置允许在后台定位
        [_Plugin setAllowsBackgroundLocationUpdates:YES];
        //设置允许连续定位逆地理
        [_Plugin setLocatingWithReGeocode:YES];
    }
    return self;
}
#pragma mark GPS
- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager *)locationManager
{
    [locationManager requestAlwaysAuthorization];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f; reGeocode:%@}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy, reGeocode.formattedAddress);
    _gpsData = [[GPSData alloc]init];
    _gpsData.dLatitude = location.coordinate.latitude;
    _gpsData.dLongitude = location.coordinate.longitude;
    
    //获取到定位信息，更新annotation
//    if (self.pointAnnotaiton == nil)
//    {
//        self.pointAnnotaiton = [[MAPointAnnotation alloc] init];
//        [self.pointAnnotaiton setCoordinate:location.coordinate];
//
//        [self.mapView addAnnotation:self.pointAnnotaiton];
//    }
//
//    [self.pointAnnotaiton setCoordinate:location.coordinate];
//
//    [self.mapView setCenterCoordinate:location.coordinate];
//    [self.mapView setZoomLevel:15.1 animated:NO];
}
@end

@implementation NativeUtil

+(UIColor*)uiColorTransFromArr:(NSArray<NSNumber*>*)arr{
    @try{
        NSInteger red = arr[0].integerValue;
        NSInteger green = arr[1].integerValue;
        NSInteger blue = arr[2].integerValue;
        NSInteger alpha = 1;
        
        if(arr.count>3) alpha = arr[3].integerValue;
        UIColor* color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha/1.0];
        
        return color;
    }@catch(NSException *exception){
        @throw exception;
    }
}

+(Color*)smColorTransFromArr:(NSArray<NSNumber*>*)arr{
    @try{
        NSInteger red = arr[0].integerValue;
        NSInteger green = arr[1].integerValue;
        NSInteger blue = arr[2].integerValue;
        NSInteger alpha = 255;
        
        if(arr.count>3) alpha = arr[3].integerValue;
        Color* color = [[Color alloc]initWithR:(int)red G:(int)green B:(int)blue A:(int)alpha];
        
        return color;
    }@catch(NSException *exception){
        @throw exception;
    }
}

+(NSMutableArray *)getFieldInfos:(Recordset*)recordset filter:(NSDictionary *)filter {
    FieldInfos* fieldInfos = [recordset fieldInfos];
//    NSMutableDictionary* fieldsDics= [[NSMutableDictionary alloc] initWithCapacity:7];
    NSMutableArray* fieldsArr = [[NSMutableArray alloc] init];
    int count2 = (int)[fieldInfos count];
    NSMutableArray* typeFilter;
    if (filter && [filter objectForKey:@"typeFilter"]) {
        typeFilter = [filter objectForKey:@"typeFilter"];
    }
    for(int i = 0;i < count2;i++){
        FieldType type = [fieldInfos get:i].fieldType;
        NSNumber* typeNum = @(type);
        BOOL isAdd = NO;
        if (typeFilter && typeFilter.count > 0) {
            for (int j = 0; j < typeFilter.count; j++) {
                if ([typeNum isEqualToNumber:typeFilter[j]]) {
                    isAdd = YES;
                    break;
                }
            }
        } else {
            isAdd = YES;
        }
        if (isAdd) {
            NSMutableDictionary* fieldsDic = [[NSMutableDictionary alloc] initWithCapacity:7];
            NSString* caption = [fieldInfos get:i].caption;
            NSString* defaultValue = [fieldInfos get:i].defaultValue;
            NSString* fieldName = [fieldInfos get:i].name;
            NSInteger maxLength = [fieldInfos get:i].maxLength;
            BOOL isRequired = [fieldInfos get:i].isRequired;
            BOOL isSystemField = [fieldInfos get:i].isSystemField;
            [fieldsDic setObject:caption forKey:@"caption"];
            [fieldsDic setObject:defaultValue forKey:@"defaultValue"];
            [fieldsDic setObject:@(type) forKey:@"type"];
            [fieldsDic setObject:fieldName forKey:@"name"];
            [fieldsDic setObject:@(maxLength) forKey:@"maxLength"];
            [fieldsDic setObject:@(isRequired) forKey:@"isRequired"];
            [fieldsDic setObject:@(isSystemField) forKey:@"isSystemField"];
            
//            [fieldsDics setObject:fieldsDic forKey:fieldName];
            [fieldsArr addObject:fieldsDic];
        }
    }
    return fieldsArr;
}

+(NSMutableDictionary *)recordsetToDictionary:(Recordset*)recordset page:(NSInteger)page size:(NSInteger)size {
    return [self recordsetToDictionary:recordset page:page size:size filterKey:nil];
}

+(NSMutableDictionary *)recordsetToDictionary:(Recordset*)recordset page:(NSInteger)page size:(NSInteger)size filterKey:(NSString *)filterKey {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    NSMutableArray* recordArray = [[NSMutableArray alloc] init];
    
    // 获取recordset中fieldInfo的属性
    NSMutableArray* fieldsArr = [NativeUtil getFieldInfos:recordset filter:nil];
    
    // 计算分页，并移动到指定起始位置
    long currentIndex = page * size;
    long endIndex = currentIndex + size;
    
    [dic setObject:[NSNumber numberWithInteger:recordset.recordCount] forKey:@"total"];
    [dic setObject:[NSNumber numberWithInteger:page] forKey:@"currentPage"];
    
    if (currentIndex < recordset.recordCount) {
        [recordset moveTo:currentIndex];
        
        // 获取所有recordset中fieldInfo属性对应的值
        while(( ![recordset isEOF] && currentIndex < endIndex ) ){
            //while(recordset.recordCount > 0 && ![recordset isEOF]){
            NSMutableArray* arr;
            
            if (filterKey != nil && ![filterKey isEqualToString:@""]) {
                arr = [NativeUtil parseRecordset:recordset fieldsArr:fieldsArr filterKey:filterKey];
            } else {
                arr = [NativeUtil parseRecordset:recordset fieldsArr:fieldsArr];
            }
            
            if (arr != nil) {
                [recordArray addObject:arr];
                currentIndex++;
            }
            [recordset moveNext];
        }
    }
    [dic setObject:recordArray forKey:@"data"];
    [dic setObject:@(page * size) forKey:@"startIndex"];
    
    return dic;
}

+(NSMutableArray *)parseRecordset:(Recordset *)recordset fieldsArr:(NSMutableArray*)fieldsArr {
    NSMutableArray* arr = [self parseRecordset:recordset fieldsArr:fieldsArr filterKey:@""];
    return arr;
}

+(NSMutableArray *)parseRecordset:(Recordset *)recordset fieldsArr:(NSMutableArray*)fieldsArr filterKey:(NSString *)filterKey {
//    int fieldsDicsCount = (int)[fieldsDics count];
    NSMutableArray* array =[[NSMutableArray alloc]init];
//    NSArray* keys = fieldsDics.allKeys;
//    NSArray* values = fieldsDics.allValues;
    
    BOOL isMatching = NO;
    
    for(int i = 0; i < fieldsArr.count; i++){
        NSMutableDictionary* keyMap = [[NSMutableDictionary alloc]init];
        NSMutableDictionary* itemWMap =[[NSMutableDictionary alloc]init];
        
//        NSString* keyName =(NSString*)keys[i];
//        NSMutableDictionary* fieldsDic = (NSMutableDictionary*)values[i];
        
        NSMutableDictionary* fieldsDic = fieldsArr[i];
        NSArray* keys2 = fieldsDic.allKeys;
        NSArray* values2 = fieldsDic.allValues;
        NSString* keyName = [fieldsDic objectForKey:@"name"];

        int fieldsDicCount = (int)[keys2 count];
        for(int a = 0;a < fieldsDicCount;a++){
            NSString* keyName2 =(NSString*)keys2[a];
            if(values2[a] == nil){
                [itemWMap setObject:@"" forKey:keyName2];
                continue;
            }

            [itemWMap setObject:values2[a] forKey:keyName2];
            if([keyName2 isEqualToString:@"type"]){
                NSObject* object = [recordset getFieldValueWithString:keyName];
                NSString* objStr = [NSString stringWithFormat: @"%@", object];
                if (filterKey != nil && ![filterKey isEqualToString:@""] && !isMatching) {
                    isMatching = [objStr containsString:filterKey]; // 判断是否匹配
                }
                
                if(object == nil){
                    [keyMap setObject:@"" forKey:@"value"];
                } else {
                    [keyMap setObject:object forKey:@"value"];
                }
            }
        }
        [keyMap setObject:itemWMap forKey:@"fieldInfo"];
        [keyMap setObject:keyName forKey:@"name"];
        
        if ([keyName.lowercaseString isEqualToString:@"smid"]) {
            [array insertObject:keyMap atIndex:0];
        } else {
            [array addObject:keyMap];
        }
        
        
//        [map setObject:keyMap forKey:keyName];
    }
    
    if (filterKey != nil && ![filterKey isEqualToString:@""]) {
        return isMatching ? array : nil;
    }
    
    return array;
}

static locationChangedDelegate* LocationPlugin = nil;

+(void)openGPS{
   dispatch_async(dispatch_get_main_queue(), ^{
       if(!LocationPlugin){
           LocationPlugin = [[locationChangedDelegate alloc]init];
       }
       
       [LocationPlugin.Plugin startUpdatingLocation];
   });
}
+(void)closeGPS{
    @synchronized(LocationPlugin) {
        [LocationPlugin.Plugin stopUpdatingLocation];
    }
    
}
+(GPSData*)getGPSData{
    return [LocationPlugin.gpsData clone];
}


@end

//
//  NativeUtil.h
//  Supermap
//
//  Created by 王子豪 on 2017/11/14.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SuperMap/Color.h>
#import <SuperMap/LocationManagePlugin.h>
@class Recordset;
//@class GPSD
@interface NativeUtil : NSObject
+(UIColor*)uiColorTransFromArr:(NSArray<NSNumber*>*)arr;
+(Color*)smColorTransFromArr:(NSArray<NSNumber*>*)arr;
+(NSMutableArray *)getFieldInfos:(Recordset*)recordset filter:(NSDictionary *)filter;
+(NSMutableDictionary *)recordsetToDictionary:(Recordset*)recordset page:(NSInteger)page size:(NSInteger)size;
+(NSMutableDictionary *)recordsetToDictionary:(Recordset*)recordset page:(NSInteger)page size:(NSInteger)size filterKey:(NSString *)filterKey;
+(NSMutableArray *)parseRecordset:(Recordset *)recordset fieldsArr:(NSMutableArray*)fieldsArr;
+(NSMutableArray *)parseRecordset:(Recordset *)recordset fieldsDics:(NSMutableDictionary*)fieldsDics filterKey:(NSString *)filterKey;
+(void)openGPS;
+(void)closeGPS;
+(GPSData*)getGPSData;
@end

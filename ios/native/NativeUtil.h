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
@class Recordset;
@interface NativeUtil : NSObject
+(UIColor*)uiColorTransFromArr:(NSArray<NSNumber*>*)arr;
+(Color*)smColorTransFromArr:(NSArray<NSNumber*>*)arr;
+(NSMutableArray *)recordsetToJsonArray:(Recordset*)recordset page:(NSInteger)page size:(NSInteger)size;
+(NSMutableArray *)recordsetToJsonArray:(Recordset*)recordset page:(NSInteger)page size:(NSInteger)size filterKey:(NSString *)filterKey;
+(NSMutableArray *)parseRecordset:(Recordset *)recordset fieldsDics:(NSMutableDictionary*)fieldsDics filterKey:(NSString *)filterKey;
@end

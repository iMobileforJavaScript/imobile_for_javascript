//
//  NativeUtil.m
//  Supermap
//
//  Created by 王子豪 on 2017/11/14.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "NativeUtil.h"
#import "SuperMap/Recordset.h"
#import "SuperMap/FieldInfos.h"
#import "SuperMap/FieldInfo.h"
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
+(NSMutableArray *)recordsetToJsonArray:(Recordset*)recordset count:(NSInteger)count size:(NSInteger)size{
    FieldInfos* fieldInfos = [recordset fieldInfos];
    NSMutableDictionary* fieldsDics= [[NSMutableDictionary alloc]initWithCapacity:7];
    int count2 = (int)[fieldInfos count];
    for(int i = 0;i < count2;i++){
        NSMutableDictionary* fieldsDic = [[NSMutableDictionary alloc]initWithCapacity:7];
        NSString* caption = [fieldInfos get:i].caption;
        NSString* defaultValue = [fieldInfos get:i].defaultValue;
        FieldType type = [fieldInfos get:i].fieldType;
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
        
        [fieldsDics setObject:fieldsDic forKey:fieldName];
    }
    
    NSMutableArray* recordArray = [[NSMutableArray alloc] init];
//    while(( ![recordset isEOF] && count < size ) ){
    while(recordset.recordCount > 0 && ![recordset isEOF]){
        NSMutableArray* arr = [NativeUtil parseRecordset:recordset fieldsDics:fieldsDics];
        [recordArray addObject:arr];
        [recordset moveNext];
        count++;
    }
    return recordArray;
}
+(NSMutableArray *)parseRecordset:(Recordset *)recordset fieldsDics:(NSMutableDictionary*)fieldsDics{
    int fieldsDicsCount = (int)[fieldsDics count];
    NSMutableArray* array =[[NSMutableArray alloc]init];
    NSArray* keys = fieldsDics.allKeys;
    NSArray* values = fieldsDics.allValues;
    
    for(int i = 0;i < fieldsDicsCount;i++){
        NSMutableDictionary* keyMap =[[NSMutableDictionary alloc]init];
        NSMutableDictionary* itemWMap =[[NSMutableDictionary alloc]init];
        
        NSString* keyName =(NSString*)keys[i];
        NSMutableDictionary* fieldsDic = (NSMutableDictionary*)values[i];
        
        NSArray* keys2 = fieldsDic.allKeys;
        NSArray* values2 = fieldsDic.allValues;

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
    return array;
}
@end

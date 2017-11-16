//
//  NativeUtil.m
//  Supermap
//
//  Created by 王子豪 on 2017/11/14.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "NativeUtil.h"

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
@end

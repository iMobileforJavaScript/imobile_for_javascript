//
//  JSPoint.h
//  HelloWorldDemo
//
//  Created by 王子豪 on 2016/11/23.
//  Copyright © 2016年 Facebook. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface JSPoint : NSObject<RCTBridgeModule>
+(NSString*)createObjWithX:(double)xNum Y:(double)yNum;
@end

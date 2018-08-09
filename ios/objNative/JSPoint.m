//
//  JSPoint.m
//  HelloWorldDemo
//
//  Created by 王子豪 on 2016/11/23.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSPoint.h"
#import "JSObjManager.h"
#import <CoreGraphics/CGGeometry.h>
@implementation JSPoint
+(NSString*)createObjWithX:(double)xNum Y:(double)yNum{
    NSNumber* xObj = [NSNumber numberWithDouble:xNum];
    NSNumber* yObj = [NSNumber numberWithDouble:yNum];
    NSDictionary* pointDic = @{@"x":xObj,@"y":yObj};
    NSInteger key = (NSInteger)pointDic;
    [JSObjManager addObj:pointDic];
    NSString* pointId = @(key).stringValue;
    return pointId;
}
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObj,createObjByX:(double)xNum Y:(double)yNum resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  NSNumber* xObj = [NSNumber numberWithDouble:xNum];
  NSNumber* yObj = [NSNumber numberWithDouble:yNum];
  NSDictionary* pointDic = @{@"x":xObj,@"y":yObj};
  if (pointDic) {
    NSInteger key = (NSInteger)pointDic;
    [JSObjManager addObj:pointDic];
    resolve(@{@"pointId":@(key).stringValue});
  }else{
    reject(@"point",@"create point failed!!!",nil);
  }
}
@end

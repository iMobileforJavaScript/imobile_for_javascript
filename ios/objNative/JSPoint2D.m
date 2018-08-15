//
//  JSPoint2D.m
//  HelloWorldDemo
//
//  Created by 王子豪 on 2016/11/23.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSPoint2D.h"
#import "SuperMap/Point2D.h"
#import "JSObjManager.h"

@implementation JSPoint2D
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObjByXY,createObjByX:(double)xNum Y:(double)yNum resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Point2D* point = [[Point2D alloc]initWithX:xNum Y:yNum];
  if (point) {
    NSInteger key = (NSInteger)point;
    [JSObjManager addObj:point];
    resolve(@{@"point2DId":@(key).stringValue});
  }else{
    reject(@"point",@"create point failed!!!",nil);
  }
}

RCT_REMAP_METHOD(createObj,resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Point2D* point = [[Point2D alloc]init];
  if (point) {
    NSInteger key = (NSInteger)point;
    [JSObjManager addObj:point];
    resolve(@{@"point2DId":@(key).stringValue});
  }else{
    reject(@"point",@"create point failed!!!",nil);
  }
}
@end

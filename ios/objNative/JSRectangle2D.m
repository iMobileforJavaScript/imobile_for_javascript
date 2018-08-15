//
//  JSRectangle2D.m
//  HelloWorldDemo
//
//  Created by 王子豪 on 2016/11/24.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSRectangle2D.h"
#import "JSObjManager.h"
#import "SuperMap/Point2D.h"
@implementation JSRectangle2D
+(NSDictionary*)reactangle2DToDic:(Rectangle2D*)reactangle{
    NSNumber* nsLeft = [NSNumber numberWithDouble:reactangle.left];
    NSNumber* nsBottom = [NSNumber numberWithDouble:reactangle.bottom];
    NSNumber* nsRight = [NSNumber numberWithDouble:reactangle.right];
    NSNumber* nsTop = [NSNumber numberWithDouble:reactangle.top];
    NSNumber* nsHeight = [NSNumber numberWithDouble:reactangle.height];
    NSNumber* nsWidth = [NSNumber numberWithDouble:reactangle.width];
    Point2D* centerPoint = reactangle.center;
    NSNumber* nsX = [NSNumber numberWithDouble:centerPoint.x];
    NSNumber* nsY = [NSNumber numberWithDouble:centerPoint.y];
    NSDictionary* dic = @{@"left":nsLeft,@"bottom":nsBottom,@"right":nsRight,@"top":nsTop,@"height":nsHeight,@"width":nsWidth,@"center":@{@"x":nsX,@"y":nsY}};
    return dic;
}

+(Rectangle2D*)dicToReactangle2D:(NSDictionary*)dic{
    Rectangle2D* reactangle = nil;
    NSNumber* nsLeft = [dic objectForKey:@"left"];
    double left = nsLeft.doubleValue;
    NSNumber* nsBottom = [dic objectForKey:@"bottom"];
    double bottom = nsBottom.doubleValue;
    NSArray* keyArr = [dic allKeys];
    if ([keyArr containsObject:@"right"]&&[keyArr containsObject:@"top"]) {
        NSNumber* nsRight = [dic objectForKey:@"right"];
        double right = nsRight.doubleValue;
        NSNumber* nsTop = [dic objectForKey:@"top"];
        double top = nsTop.doubleValue;
        reactangle = [[Rectangle2D alloc]initWith:left bottom:bottom right:right top:top];
    }else if ([keyArr containsObject:@"width"]&&[keyArr containsObject:@"height"]){
        NSNumber* nsWidth = [dic objectForKey:@"width"];
        double width = nsWidth.doubleValue;
        NSNumber* nsHeight = [dic objectForKey:@"height"];
        double height = nsHeight.doubleValue;
        Point2D* leftBottom = [[Point2D alloc]initWithX:left Y:bottom];
        reactangle = [[Rectangle2D alloc]initWithLeftBottom:leftBottom Width:width Height:height];
    }
    return reactangle;
}
RCT_EXPORT_MODULE();
RCT_REMAP_METHOD(createObjBy2Pt,createObjBy2Pt:(NSString*)point2DId1 point2:(NSString*)point2DID2 resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Point2D* point1 = [JSObjManager getObjWithKey:point2DId1];
  Point2D* point2 = [JSObjManager getObjWithKey:point2DID2];
  if (point1&&point2) {
    Rectangle2D* rectangle = [[Rectangle2D alloc]initWithLeftBottom:point1 RightTop:point2];
    NSInteger key = (NSInteger)rectangle;
    [JSObjManager addObj:rectangle];
    resolve(@{@"rectangle2DId":@(key).stringValue});
  }else{
    reject(@"rectangle2D",@"create failed!!!",nil);
  }
}

RCT_REMAP_METHOD(createObj,resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Rectangle2D* rectangle = [[Rectangle2D alloc]init];
  if (rectangle) {
    NSInteger key = (NSInteger)rectangle;
    [JSObjManager addObj:rectangle];
    resolve(@{@"rectangle2DId":@(key).stringValue});
  }else{
    reject(@"rectangle2D",@"create failed!!!",nil);
  }
}
@end

//
//  JSCallOut.m
//  HelloWorldDemo
//
//  Created by 王子豪 on 2016/11/21.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSCallOut.h"
#import "SuperMap/Callout.h"
#import "SuperMap/Point2D.h"
#import "JSObjManager.h"

@implementation JSCallOut
-(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
  UIGraphicsBeginImageContext(size);
  [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
  UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return scaledImage;
}

RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(createObj,createObjWithMapControlId:(NSString*)mapControlId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl * mapCtrl = [JSObjManager getObjWithKey:mapControlId];
        Callout *callout = [[Callout alloc]initWithMapControl:mapCtrl];
        NSInteger key = (NSInteger)callout;
        [JSObjManager addObj:callout];
        resolve(@{@"_SMCalloutId":@(key).stringValue});
    } @catch (NSException *exception) {
        reject(@"Callout",@"create callout failed.",nil);
    }
}

RCT_REMAP_METHOD(createObjWithStyle,createObjWithMapControlId:(NSString*)mapControlId colorArr:(NSArray*)arr type:(int)typeNum resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        MapControl * mapCtrl = [JSObjManager getObjWithKey:mapControlId];
        NSNumber* red = arr[0];
        NSNumber* green = arr[1];
        NSNumber* blue = arr[2];
        NSNumber* alpha = arr[3];
        UIColor *color = [UIColor colorWithRed:red.doubleValue/255 green:green.doubleValue/255 blue:blue.doubleValue/255 alpha:alpha.doubleValue];
        Callout *callout = [[Callout alloc]initWithMapControl:mapCtrl BackgroundColor:color Alignment:typeNum];
        NSInteger key = (NSInteger)callout;
        [JSObjManager addObj:callout];
        resolve(@{@"_SMCalloutId":@(key).stringValue});
    } @catch (NSException *exception) {
        reject(@"Callout",@"create callout failed.",nil);
    }
}

RCT_REMAP_METHOD(showAtPoint2d,showByCalloutId:(NSString*)calloutId point2dId:(NSString*)point2dId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 2), ^{
            Callout * callout = [JSObjManager getObjWithKey:calloutId];
            Point2D *point2d = [JSObjManager getObjWithKey:point2dId];
//            [callout showAt:point2d];
        });
    } @catch (NSException *exception) {
        reject(@"Callout",@"show at point2d failed.",nil);
    }
}

RCT_REMAP_METHOD(showAtXY,showByCalloutId:(NSString*)calloutId x:(double)x y:(double)y resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            Callout * callout = [JSObjManager getObjWithKey:calloutId];
            Point2D *point2d = [[Point2D alloc]initWithX:x Y:y];
//            [callout showAt:point2d];
        });
    } @catch (NSException *exception) {
        reject(@"Callout",@"show at xy failed.",nil);
    }
}

RCT_REMAP_METHOD(updataByPoint2d,updataByCalloutId:(NSString*)calloutId point2dId:(NSString*)point2dId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            Callout * callout = [JSObjManager getObjWithKey:calloutId];
            Point2D *point2d = [JSObjManager getObjWithKey:point2dId];
            CGPoint point = CGPointMake(point2d.x, point2d.y);
            [callout updateFrame:point];
        });
    } @catch (NSException *exception) {
        reject(@"Callout",@"updata at point2d failed.",nil);
    }
}

RCT_REMAP_METHOD(updataByXY,updataByCalloutId:(NSString*)calloutId x:(double)x y:(double)y resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            Callout * callout = [JSObjManager getObjWithKey:calloutId];
            CGPoint point = CGPointMake(x, y);
            [callout updateFrame:point];
        });
    } @catch (NSException *exception) {
        reject(@"Callout",@"updata at xy failed.",nil);
    }
}

RCT_REMAP_METHOD(setHeight,setHeightBycalloutId:(NSString*)calloutId height:(double)height resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Callout * callout = [JSObjManager getObjWithKey:calloutId];
        callout.height = (CGFloat)height;
        NSNumber* trueNum = [NSNumber numberWithBool:true];
        resolve(trueNum);
    } @catch (NSException *exception) {
        reject(@"Callout",@"set height failed.",nil);
    }
}

RCT_REMAP_METHOD(setWidth,setWidthBycalloutId:(NSString*)calloutId width:(double)width resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    @try {
        Callout * callout = [JSObjManager getObjWithKey:calloutId];
        callout.width = (CGFloat)width;
        NSNumber* trueNum = [NSNumber numberWithBool:true];
        resolve(trueNum);
    } @catch (NSException *exception) {
        reject(@"Callout",@"set width failed.",nil);
    }
}

RCT_REMAP_METHOD(addImage,addImageBycalloutId:(NSString*)calloutId name:(NSString*)name resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Callout * callout = [JSObjManager getObjWithKey:calloutId];
  if (callout) {
    UIImageView* leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,50, 50)];
    UIImage* imageObj = [UIImage imageNamed:name];
    leftView.image = [self scaleToSize:imageObj size:CGSizeMake(50,50)];
    [callout addSubview:leftView];
    resolve(@"1");
  }else{
    reject(@"callOut",@"add image failed!!!",nil);
  }
}

RCT_REMAP_METHOD(showAtPoint,showAtPointBycalloutId:(NSString*)calloutId point2DId:(NSString*)point2DId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Callout * callout = [JSObjManager getObjWithKey:calloutId];
  if (callout) {
    Point2D * point2D = [JSObjManager getObjWithKey:point2DId];
//    [callout showAt:point2D];
    resolve(@"1");
  }else{
    reject(@"callOut",@"show failed!!!",nil);
  }
}

RCT_REMAP_METHOD(setStyle,calloutId:(NSString*)calloutId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){

}

RCT_REMAP_METHOD(setCustomize,calloutId:(NSString*) calloutId isSet:(BOOL)isSet resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  Callout* callout = [JSObjManager getObjWithKey:calloutId];
  callout.isUseDefalutStyle = isSet;
}

RCT_REMAP_METHOD(setLocation,calloutId:(NSString*)calloutId p2DId:(NSString*)p2DId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Point2D* point2d = [JSObjManager getObjWithKey:p2DId];
    Callout* callout = [JSObjManager getObjWithKey:calloutId];
//    BOOL isDone = [callout showAt:point2d];
//    if (isDone) {
//      resolve(@"done");
//    }else{
//        reject(@"callout",@"callout location set failed",nil);
//    }
}

RCT_REMAP_METHOD(setContentView,calloutId:(NSString*) calloutId imageViewId:(NSString*)imageViewId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  
}
@end

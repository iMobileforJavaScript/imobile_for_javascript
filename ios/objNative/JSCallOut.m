//
//  JSCallOut.m
//  HelloWorldDemo
//
//  Created by 王子豪 on 2016/11/21.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSCallOut.h"
#import "SuperMap/Callout.h"
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

RCT_REMAP_METHOD(createObj,mapViewId:(NSString*)mapViewId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    id mapView = [JSObjManager getObjWithKey:mapViewId];
    
}

RCT_REMAP_METHOD(createObjByMapCtrl,mapControlId:(NSString*)mapControlId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  MapControl * mapCtrl = [JSObjManager getObjWithKey:mapControlId];
  Callout *callout = [[Callout alloc]initWithMapControl:mapCtrl];
  if(callout){
    callout.height = 50;
    callout.width = 50;
    NSInteger key = (NSInteger)callout;
    [JSObjManager addObj:callout];
    resolve(@{@"callOutId":@(key).stringValue});
  }else{
    reject(@"callOut",@"create callout failed!!!",nil);
  }
}

RCT_REMAP_METHOD(setHeight,setHeightBycalloutId:(NSString*)calloutId height:(double)height resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Callout * callout = [JSObjManager getObjWithKey:calloutId];
  if (callout) {
    callout.height = (CGFloat)height;
    resolve(@"1");
  }else{
    reject(@"callOut",@"set height failed!!!",nil);
  }
}

RCT_REMAP_METHOD(setWidth,setWidthBycalloutId:(NSString*)calloutId width:(double)width resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    Callout * callout = [JSObjManager getObjWithKey:calloutId];
  if (callout) {
    callout.width = (CGFloat)width;
    resolve(@"1");
  }else{
    reject(@"callOut",@"set width failed!!!",nil);
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
    [callout showAt:point2D];
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
    BOOL isDone = [callout showAt:point2d];
    if (isDone) {
      resolve(@"done");
    }else{
        reject(@"callout",@"callout location set failed",nil);
    }
}

RCT_REMAP_METHOD(setContentView,calloutId:(NSString*) calloutId imageViewId:(NSString*)imageViewId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  
}
@end

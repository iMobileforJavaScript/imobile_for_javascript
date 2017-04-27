//
//  JSMapView.m
//  rnTest
//
//  Created by imobile-xzy on 16/7/12.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import <React/RCTEventDispatcher.h>

#import "JSMapView.h"
#import "JSObjManager.h"

@implementation JSMapView

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(getMapControl,getMapControlKey:(NSString*)key resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  MapControl* mapcontrol = [JSObjManager getObjWithKey:key];
  if(mapcontrol){
      mapcontrol.mapMeasureDelegate = self;
      mapcontrol.delegate = self;
      mapcontrol.geometrySelectedDelegate = self;
      NSInteger key = (NSInteger)mapcontrol;
      resolve(@{@"mapControlId":@(key).stringValue});
  }else
      reject(@"MapControl",@"getMapControl:mapcontrol init faild!!!",nil);
}
@end

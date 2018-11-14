//
//  JSLocationManager.m
//  HelloWorldDemo
//
//  Created by 王子豪 on 2016/11/22.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "JSLocationManager.h"
#import "JSObjManager.h"
@implementation JSLocationManager
@synthesize bridge = _bridge;
@synthesize oldDataCache;
RCT_EXPORT_MODULE();

RCT_REMAP_METHOD(createObj,resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  dispatch_queue_t mainQueue = dispatch_get_main_queue();
  dispatch_async(mainQueue,^{
    LocationManagePlugin* LMP = [[LocationManagePlugin alloc]init];
    self.oldDataCache = [[GPSData alloc]init];
    if(LMP){
      NSInteger key = (NSInteger)LMP;
      [JSObjManager addObj:LMP];
      resolve(@{@"_locationManagePluginId_":@(key).stringValue});
    }else{
      reject(@"locationManagePlugin",@"create obj failed!!!",nil);
    }
  });

}

RCT_REMAP_METHOD(openGpsDevice,openGpsDeviceById:(NSString*)LMPId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  LocationManagePlugin* LMP = [JSObjManager getObjWithKey:LMPId];
  BOOL isOpen = [LMP openGpsDevice];
  if (isOpen) {
    resolve(@"open location");
  }else{
    reject(@"locationManagePlugin",@"open failed!!!",nil);
  }
}

RCT_REMAP_METHOD(closeGpsDevice,closeGpsDeviceById:(NSString*)LMPId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
  LocationManagePlugin* LMP = [JSObjManager getObjWithKey:LMPId];
  if (LMP) {
    [LMP closeGpsDevice];
    resolve(@"close location");
  }else{
    reject(@"locationManagePlugin",@"close failed!!!",nil);
  }
}

RCT_REMAP_METHOD(getLocationInfo,getLocationInfoById:(NSString*)LMPId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    LocationManagePlugin* LMP = [JSObjManager getObjWithKey:LMPId];
    if (LMP) {
        LMP.locationChangedDelegate = self;
        resolve(@"set delegate");
    }else{
        reject(@"locationManagePlugin",@"set delegate failed!!!",nil);
    }
    
  
}

- (NSArray<NSString *> *)supportedEvents{
  return @[@"com.supermap.RN.JSLocationManager.location_changed_event", @"locationNewDirection", @"locationError"];
}

-(void)locationChanged:(GPSData *)oldData newGps:(GPSData *)newData{
  if (self.oldDataCache.dLatitude == newData.dLatitude && self.oldDataCache.dLongitude == newData.dLongitude) {
    self.oldDataCache = newData;
    return;
  }
  self.oldDataCache = newData;
  NSNumber *oldLong = [NSNumber numberWithDouble:oldData.dLongitude];
  NSNumber *oldLat = [NSNumber numberWithDouble:oldData.dLatitude];
  NSNumber *newLong = [NSNumber numberWithDouble:newData.dLongitude];
  NSNumber *newLat = [NSNumber numberWithDouble:newData.dLatitude];
  NSDictionary* event = @{
                          @"oldData":@[oldLong,oldLat],
                          @"newData":@[newLong,newLat],
                          };

  [self sendEventWithName:@"com.supermap.RN.JSLocationManager.location_changed_event" body:event];
}
-(void)locationNewDirection:(CLHeading *)newHeading{
  NSLog(@"1111");
}
-(void)locationError:(NSString *)error{
  NSLog(@"error");
}
  @end

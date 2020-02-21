//
//  SLocation.h
//  Supermap
//
//  Created by apple on 2020/2/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import "AMapFoundationKit.h"
#import "AMapLocationKit.h"
#import <SuperMap/LocationManagePlugin.h>
#import "Constants.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
@interface SLocation : RCTEventEmitter<RCTBridgeModule>
+(instancetype)sharedInstance;
+ (id)allocWithZone:(NSZone *)zone;
-(void)openGPS;
-(void)closeGPS;
-(GPSData*)getGPSData;
@end

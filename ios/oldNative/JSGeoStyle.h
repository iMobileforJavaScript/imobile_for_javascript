//
//  JSGeoStyle.h
//  HelloWorldDemo
//
//  Created by 王子豪 on 2016/11/22.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import "SuperMap/GeoStyle.h"

@interface JSGeoStyle : NSObject<RCTBridgeModule>
+(GeoStyle *)createByObj:(NSDictionary *)dic;
@end

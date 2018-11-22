//
//  SCollectorType.h
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/31.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>

typedef enum {
    POINT_GPS = 0,
    POINT_HAND ,
    
    LINE_GPS_POINT,
    LINE_GPS_PATH,
    LINE_HAND_POINT,
    LINE_HAND_PATH,
    
    REGION_GPS_POINT,
    REGION_GPS_PATH,
    REGION_HAND_POINT,
    REGION_HAND_PATH,
} CollectorType;

@interface SCollectorType : NSObject<RCTBridgeModule>

@end

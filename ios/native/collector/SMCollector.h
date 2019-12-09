//
//  SMCollector.h
//  Supermap
//
//  Created by Yang Shang Long on 2018/10/30.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperMap/Collector.h"

@interface SMCollector : NSObject

+ (BOOL)setCollector:(Collector *)collector mapControl:(MapControl *)mapControl type:(int)type;
+ (void)openGPS:(Collector *)collector;
+ (void)closeGPS:(Collector *)collector;
+ (GPSData*) getGPSPoint;
@end

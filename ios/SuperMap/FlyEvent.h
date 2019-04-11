//
//  FlyEvent.h
//  LibUGC
//
//  Created by LK on 15/11/25.
//  Copyright © 2015年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlyEvent : NSObject

@end

@class Route, RouteStop;
@interface StopArrivedEvent : FlyEvent

@property (nonatomic, strong) Route *route;
@property (nonatomic, strong) RouteStop *routeStop;

/* 初始化方法和类方法 */
- (instancetype)initWithRoute:(Route *)route andRouteStop:(RouteStop *)routeStop;
+ (instancetype)stopArrivedEventWithRoute:(Route *)route andRouteStop:(RouteStop *)routeStop;

@end

@interface StatusChangedEvent : FlyEvent

@end

@interface PropertiesChangedEvent : FlyEvent

@end
//
//  LocationData.h
//  LibUGC
//
//  Created by iMobile2D on 14-8-15.
//  Copyright (c) 2014年 beijingchaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationData : NSObject {
@private
    /**
     * ///纬度，单位是度。
     */
    double _Latitude;
    /**
     * ///经度，单位是度。
     */
    double _Longitude;
    /**
     * ///高程，用高于平均海平面即海拔表示。单位是米。
     */
    double _Altitude;
    /**
     * ///方位角，表示行进的方向，单位是度。正北为0，顺时针方向，值域为0-360。
     */
    double _Bearing;
    /**
     * ///行进速度，单位是米/秒。
     */
    double _Speed;
    /**
     * ///时间。
     */
    NSDate* _Date;
}

-(id)initWithLocationData:(LocationData*)locationData;

///纬度，单位是度。
@property(nonatomic,assign)double Latitude;

///经度，单位是度。
@property(nonatomic,assign)double Longitude;

///高程，用高于平均海平面即海拔表示。单位是米。
@property(nonatomic,assign)double Altitude;

///方位角，表示行进的方向，单位是度。正北为0，顺时针方向，值域为0-360。
@property(nonatomic,assign)double Bearing;

///行进速度，单位是米/秒。
@property(nonatomic,assign)double Speed;

///时间。
@property(nonatomic)NSDate* Date;

@end

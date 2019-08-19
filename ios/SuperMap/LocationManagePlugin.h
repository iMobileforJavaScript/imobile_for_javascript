//
//  LocationManagePlugin.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <CoreLocation/CoreLocation.h>

@protocol locationChangedDelegate;
@class GPSData;
/** 位置管理插件，目前仅支持从GPS设备中获取当前位置。
 <p> 使用导航功能时必须使用此类来获取GPSData来进行真实导航和巡航。
*/
@interface LocationManagePlugin : CLLocationManager<CLLocationManagerDelegate>{
    
    id <locationChangedDelegate> locationChangedDelegate;
    CLLocationManager *mLocMgr;
}

///位置变化时回调。
@property(nonatomic)id<locationChangedDelegate> locationChangedDelegate;

/**@brief 开启GPS服务。
 @return  一个布尔值，开启GPS设备成功返回true，否则返回false。
 */
-(BOOL)openGpsDevice;

///关闭GPS服务。
-(void)closeGpsDevice;

/**@brief  设置当位置发生多大改变时，通知委托更新。
 @param  distance 位置改变值。
*/
-(void)setLocationDistanceFilter:(double)distance;

@end


///该类为LocationManagePlugin类的内部类，标识当前获取的GPS数据的详细信息，如：经度、纬度、方位角等信息。
@interface GPSData : NSObject{
@public
    /**
     * ///纬度，单位是度。
     */
    double _dLatitude;
    /**
     * ///经度，单位是度。
     */
    double _dLongitude;
    /**
     * ///南北半球标识。0表示南半球；1表示北半球。
     */
    int nNorthing;
    /**
     * ///东西半球标识。0表示西半球；1表示东半球。
     */
    int nEasting;
    /**
     * ///GPS状态标识。0表示GPS未定位；1表示GPS定位
     */
    int nQualityIndicator;
    /**
     * ///定位模式标识。0表示GPS未定位；1表示2D定位；2表示3D定位。
     */
    int nFixMode;
    /**
     * ///可见卫星数目。
     */
//    int nSatellites;
    /**
     * ///方位角，表示行进的方向，单位是度。正北为0，顺时针方向，值域为0-360。
     */
    double _dBearing;
    /**
     * ///行进速度，单位是米/秒。
     */
    double _dSpeed;
    /**
     * ///高程，用高于平均海平面即海拔表示。单位是米。
     */
    double _dAltitude;
    /**
     * ///位置的精度信息(水平经度)
     */
    double _dAcurracy;
    /**
     * ///年。
     */
    int nYear;
    /**
     * ///月。
     */
    int nMonth;
    /**
     * ///日。
     */
    int nDay;
    /**
     * ///时。
     */
    int nHour;
    /**
     * ///分。
     */
    int nMinute;
    /**
     * ///秒。
     */
    int nSecond;
}
 ///纬度，单位是度。
@property(nonatomic,assign)double dLatitude;

///经度，单位是度。
@property(nonatomic,assign)double dLongitude;

///高程，用高于平均海平面即海拔表示。单位是米。
@property(nonatomic,assign)double dAltitude;

///方位角，表示行进的方向，单位是度。正北为0，顺时针方向，值域为0-360。
@property(nonatomic,assign)double dBearing;

///行进速度，单位是米/秒。
@property(nonatomic,assign)double dSpeed;

///可见卫星数目。
//@property(nonatomic,assign)int nSatellites;

///定位模式标识。0表示GPS未定位；1表示2D定位；2表示3D定位。
@property(nonatomic,assign)int nFixMode;

///南北半球标识。0表示南半球；1表示北半球。
@property(nonatomic,assign)int nNorthing;

///东西半球标识。0表示西半球；1表示东半球。
@property(nonatomic,assign)int nEasting;

///位置的精度信息(水平经度)
@property(nonatomic,assign)double dAccuracy;

///GPS状态标识。0表示GPS未定位；1表示GPS定位
@property(nonatomic,assign)int nQualityIndicator;

///年。
@property(nonatomic,assign)int nYear;

///月。
@property(nonatomic,assign)int nMonth;

/// 日。
@property(nonatomic,assign)int nDay;

/// 时。
@property(nonatomic,assign)int nHour;

/// 分。
@property(nonatomic,assign)int nMinute;

/// 秒。
@property(nonatomic,assign)int nSecond;
@property(nonatomic)NSString* time;
-(GPSData*)clone;
@end

///位置变化监听器，用于返回最新的位置信息。
@protocol locationChangedDelegate<CLLocationManagerDelegate>
@optional
-(void)locationChanged:(GPSData *)oldData newGps:(GPSData *)newData;
-(void)locationNewDirection:(CLHeading *)newHeading;
-(void)locationError:(NSString *)error;

@end

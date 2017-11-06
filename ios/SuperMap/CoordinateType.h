//
//  CoordinateType.h
//  LibUGC
//
//  Created by wnmng on 2017/9/13.
//  Copyright © 2017年 beijingchaotu. All rights reserved.
//

typedef enum{
    
    COORDINATE_NONE = 0,
    /**
     * GPS经纬度
     */
    GPS_LONGITUDE_LATITUDE = 0x10e6,
    
    /**
     * GPS墨卡托
     */
    GPS_MERCATOR = 0xf11,
    
    /**
     * 搜狗墨卡托
     */
    SOGOU_MERCATOR = 0xde321,
    
    /**
     * 百度经纬度
     */
    BAIDU_LONGITUDE_LATITUDE = 0xde316,
    
    /**
     * 百度墨卡托
     */
    BAIDU_MERCATOR = 0xde320,
    
    /**
     * 四维、高德经纬度
     */
    NAVINFO_AMAP_LONGITUDE_LATITUDE = 0xde315,
    
    /**
     * 四维、高德墨卡托
     */
    NAVINFO_AMAP_MERCATOR = 0xde31f

    
}CoordinateType;




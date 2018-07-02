package com.supermap.RNUtils;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.supermap.plugin.LocationManagePlugin;

/**
 * Created by will on 2017/3/13.
 */

public class GPSUtil {
    /**
     * GPSData Json对象转换成JAVA LocationManagePlugin.GPSData对象
     * @param gpsData
     * @return
     */
    public static LocationManagePlugin.GPSData convertToGPSData(ReadableMap gpsData){
        LocationManagePlugin.GPSData data = new LocationManagePlugin.GPSData();

        data.lTime = DateUtil.stringToLong(gpsData.getString("lTime"));
        data.dAltitude = gpsData.getDouble("dAltitude");
        data.dBearing = gpsData.getDouble("dBearing");
        data.dLatitude = gpsData.getDouble("dLatitude");
        data.dLongitude = gpsData.getDouble("dLongitude");
        data.dSpeed = gpsData.getDouble("dSpeed");

        data.nDay = gpsData.getInt("nDay");
        data.nEasting = gpsData.getInt("nEasting");
        data.nFixMode = gpsData.getInt("nFixMode");
        data.nHour = gpsData.getInt("nHour");
        data.nMinute = gpsData.getInt("nMinute");
        data.nMonth = gpsData.getInt("nMonth");
        data.nNorthing = gpsData.getInt("nNorthing");
        data.nQualityIndicator = gpsData.getInt("nQualityIndicator");
        data.nSatellites = gpsData.getInt("nSatellites");
        data.nSecond = gpsData.getInt("nSecond");
        data.nYear = gpsData.getInt("nYear");

        return data;
    }

    /**
     * 转换GPS属性成JSON
     * @param gps
     * @return
     */
    public static WritableMap parseGps(LocationManagePlugin.GPSData gps) {
        WritableMap gpsMap = Arguments.createMap();
        gpsMap.putDouble("dAltitude",gps.dAltitude);
        gpsMap.putDouble("dBearing",gps.dBearing);
        gpsMap.putDouble("dLatitude",gps.dLatitude);
        gpsMap.putDouble("dLongitude",gps.dLongitude);
        gpsMap.putDouble("dSpeed",gps.dSpeed);

//        Calendar c = Calendar.getInstance();
//        c.setTimeInMillis(gps.lTime);
//        String lTime = c.getTime().toString();
        String lTime = DateUtil.longToString(gps.lTime);
        gpsMap.putString("lTime",lTime);

        gpsMap.putInt("nDay",gps.nDay);
        gpsMap.putInt("nEasting",gps.nEasting);
        gpsMap.putInt("nFixMode",gps.nFixMode);
        gpsMap.putInt("nHour",gps.nHour);
        gpsMap.putInt("nMinute",gps.nMinute);
        gpsMap.putInt("nMonth",gps.nMonth);
        gpsMap.putInt("nNorthing",gps.nNorthing);
        gpsMap.putInt("nQualityIndicator",gps.nQualityIndicator);
        gpsMap.putInt("nSatellites",gps.nSatellites);
        gpsMap.putInt("nSecond",gps.nSecond);
        gpsMap.putInt("nYear",gps.nYear);

        return gpsMap;
    }
}

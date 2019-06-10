package com.supermap.smNative.collector;

import android.content.Context;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.supermap.RNUtils.LocationTencent;
import com.supermap.interfaces.collector.SCollectorType;
import com.supermap.mapping.Action;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.SnapSetting;
import com.supermap.mapping.collector.Collector;
import com.supermap.mapping.collector.CollectorElement;
import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationClient;
import com.amap.api.location.AMapLocationClientOption;
import com.amap.api.location.AMapLocationListener;
import com.supermap.plugin.LocationManagePlugin;

public class SMCollector {
//    static LocationTencent locationTencent = null;
    private static AMapLocationClient locationClient;
    private static LocationManagePlugin.GPSData m_gpsData = new LocationManagePlugin.GPSData();
    static SnapSetting snapSeting = null;
    public static boolean setCollector(Collector collector, MapControl mapControl, int type) {
        boolean result = false;
        switch (type) {
            case SCollectorType.POINT_GPS: // POINT_GPS
                result = collector.createElement(CollectorElement.GPSElementType.POINT);
                if (collector.IsSingleTapEnable()) {
                    collector.setSingleTapEnable(false);
                }
                break;
            case SCollectorType.POINT_HAND: // POINT_HAND
//                result = collector.createElement(CollectorElement.GPSElementType.POINT);
//                if (!collector.IsSingleTapEnable()) {
//                    collector.setSingleTapEnable(true);
//                }
                mapControl.setAction(Action.CREATEPOINT);
                result = true;
                break;
            case SCollectorType.LINE_GPS_POINT: // LINE_GPS_POINT
                result = collector.createElement(CollectorElement.GPSElementType.LINE);
                if (collector.IsSingleTapEnable()) {
                    collector.setSingleTapEnable(false);
                }
                break;
            case SCollectorType.LINE_GPS_PATH: // LINE_GPS_PATH
                result = collector.createElement(CollectorElement.GPSElementType.LINE);
                if (collector.IsSingleTapEnable()) {
                    collector.setSingleTapEnable(false);
                }
                break;
            case SCollectorType.LINE_HAND_POINT: // LINE_HAND_POINT
                mapControl.setAction(Action.CREATEPOLYLINE);
                result = true;
                break;
            case SCollectorType.LINE_HAND_PATH: // LINE_HAND_PATH
                mapControl.setAction(Action.FREEDRAW);
                result = true;
                break;
            case SCollectorType.REGION_GPS_POINT: // REGION_GPS_POINT
                result = collector.createElement(CollectorElement.GPSElementType.POLYGON);
                if (collector.IsSingleTapEnable()) {
                    collector.setSingleTapEnable(false);
                }
                break;
            case SCollectorType.REGION_GPS_PATH: // REGION_GPS_PATH
                result = collector.createElement(CollectorElement.GPSElementType.POLYGON);
                if (collector.IsSingleTapEnable()) {
                    collector.setSingleTapEnable(false);
                }
                break;
            case SCollectorType.REGION_HAND_POINT: // REGION_HAND_POINT
                mapControl.setAction(Action.CREATEPOLYGON);
                result = true;
//                result = collector.createElement(CollectorElement.GPSElementType.POLYGON);
//                if (!collector.IsSingleTapEnable()) {
//                    collector.setSingleTapEnable(true);
//                }
                break;
            case SCollectorType.REGION_HAND_PATH: // REGION_HAND_PATH
                mapControl.setAction(Action.DRAWPLOYGON);
                result = true;
                break;
            default:
                result = false;
                break;
        }

        if(snapSeting==null){
            snapSeting = new SnapSetting();
            snapSeting.openDefault();
        }
        mapControl.setSnapSetting(snapSeting);
        return result;
    }

    public static void openGPS(Context context) {
//        boolean result = collector.openGPS();

        if (locationClient == null) {
            AMapLocationClient.setApiKey("078057f0e29931c173ad8ec02284a897");
            locationClient = new AMapLocationClient(context);
            locationClient.setLocationListener(new AMapLocationListener() {
                @Override
                public void onLocationChanged(AMapLocation aMapLocation) {
                    if (aMapLocation != null) {
                        if (aMapLocation.getErrorCode() == 0) {
                            m_gpsData.dLatitude = aMapLocation.getLatitude();
                            m_gpsData.dLongitude = aMapLocation.getLongitude();
                            m_gpsData.dAccuracy = aMapLocation.getAccuracy();
                            m_gpsData.dAltitude = aMapLocation.getAltitude();
                            m_gpsData.dSpeed = aMapLocation.getSpeed();
                            m_gpsData.dBearing = aMapLocation.getBearing();
                            // eventEmitter.emit("AMapGeolocation", toReadableMap(location));
                        }
                        // TODO: 返回定位错误信息
                    }
                }
            });

            AMapLocationClientOption option = new AMapLocationClientOption();
            option.setInterval(8000);
            locationClient.setLocationOption(option);
        }

        locationClient.startLocation();
//
//        locationTencent = LocationTencent.getInstance(context);
//        locationTencent.openLocation(context);
    }

    public  static LocationManagePlugin.GPSData getGPSPoint(){
        LocationManagePlugin.GPSData data = new LocationManagePlugin.GPSData();
        data.dLatitude = m_gpsData.dLatitude;
        data.dLongitude = m_gpsData.dLongitude ;
        data.dAccuracy = m_gpsData.dAccuracy ;
        data.dAltitude = m_gpsData.dAltitude ;
        data.dSpeed = m_gpsData.dSpeed ;
        data.dBearing = m_gpsData.dBearing;
        return  data;
    }
    public static void closeGPS() {
        locationClient.stopLocation();
//        collector.closeGPS();
        locationClient.onDestroy();
       // locationTencent.closeLocation();
    }

//    public static boolean addGPSPoint(Collector collector) {
//        boolean result = collector.addGPSPoint(locationTencent.getGPSPoint());
//        if (!result) {
//            result = collector.addGPSPoint();
//        }
//        return result;
//    }
}

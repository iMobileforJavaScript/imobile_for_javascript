package com.supermap.smNative;

import com.facebook.react.bridge.ReactContext;
import com.supermap.RNUtils.LocationTencent;
import com.supermap.interfaces.collector.SCollectorType;
import com.supermap.mapping.Action;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.collector.Collector;
import com.supermap.mapping.collector.CollectorElement;

public class SMCollector {
    static LocationTencent locationTencent = null;

    public static boolean setCollector(Collector collector, MapControl mapControl, int type) {
        boolean result = false;
        switch (type) {
            case SCollectorType.POINT_GPS: // POINT_GPS
                result = collector.createElement(CollectorElement.GPSElementType.POINT);
                collector.setSingleTapEnable(false);
                break;
            case SCollectorType.POINT_HAND: // POINT_HAND
                result = collector.createElement(CollectorElement.GPSElementType.POINT);
                collector.setSingleTapEnable(true);
                break;
            case SCollectorType.LINE_GPS_POINT: // LINE_GPS_POINT
                result = collector.createElement(CollectorElement.GPSElementType.LINE);
                collector.setSingleTapEnable(false);
                break;
            case SCollectorType.LINE_GPS_PATH: // LINE_GPS_PATH
                result = collector.createElement(CollectorElement.GPSElementType.LINE);
                collector.setSingleTapEnable(false);
                break;
            case SCollectorType.LINE_HAND_POINT: // LINE_HAND_POINT
                result = collector.createElement(CollectorElement.GPSElementType.LINE);
                collector.setSingleTapEnable(true);
                break;
            case SCollectorType.LINE_HAND_PATH: // LINE_HAND_PATH
                mapControl.setAction(Action.FREEDRAW);
                result = true;
                break;
            case SCollectorType.REGION_GPS_POINT: // REGION_GPS_POINT
                result = collector.createElement(CollectorElement.GPSElementType.POLYGON);
                collector.setSingleTapEnable(false);
                break;
            case SCollectorType.REGION_GPS_PATH: // REGION_GPS_PATH
                result = collector.createElement(CollectorElement.GPSElementType.POLYGON);
                collector.setSingleTapEnable(false);
                break;
            case SCollectorType.REGION_HAND_POINT: // REGION_HAND_POINT
                result = collector.createElement(CollectorElement.GPSElementType.POLYGON);
                collector.setSingleTapEnable(true);
                break;
            case SCollectorType.REGION_HAND_PATH: // REGION_HAND_PATH
                mapControl.setAction(Action.DRAWPLOYGON);
                result = true;
                break;
            default:
                result = false;
                break;
        }
        return result;
    }

    public static void openGPS(Collector collector, ReactContext context) {
        boolean result = collector.openGPS();

        locationTencent = LocationTencent.getInstance(context);
        locationTencent.openLocation(context);
    }

    public static void closeGPS(Collector collector) {
        collector.closeGPS();
        locationTencent.closeLocation();
    }

    public static boolean addGPSPoint(Collector collector) {
        boolean result = collector.addGPSPoint(locationTencent.getGPSPoint());
        if (!result) {
            result = collector.addGPSPoint();
        }
        return result;
    }
}

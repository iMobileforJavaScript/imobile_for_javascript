package com.supermap.smNative.collector;

import android.content.Context;

import com.supermap.interfaces.collector.SCollectorType;
import com.supermap.interfaces.utils.SLocation;
import com.supermap.mapping.Action;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.SnapSetting;
import com.supermap.mapping.collector.Collector;
import com.supermap.mapping.collector.CollectorElement;
import com.supermap.plugin.LocationManagePlugin;

public class SMCollector {
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
        SLocation.openGPS();
    }

    public  static LocationManagePlugin.GPSData getGPSPoint(){
        return SLocation.getGPSPoint();
    }
    public static void closeGPS() {
        SLocation.closeGPS();
    }

}

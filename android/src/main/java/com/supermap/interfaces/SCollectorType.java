package com.supermap.interfaces;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;

import java.util.HashMap;
import java.util.Map;

public class SCollectorType extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "SCollectorType";

    public static final int POINT_GPS = 0;                    // 打点
    public static final int POINT_HAND = 1;                   // 点手绘
    public static final int LINE_GPS_POINT = 2;               // 线GPS打点
    public static final int LINE_GPS_PATH = 3;                // 线GPS轨迹
    public static final int LINE_HAND_POINT = 4;              // 线打点
    public static final int LINE_HAND_PATH = 5;               // 线手绘
    public static final int REGION_GPS_POINT = 6;             // 面GPS打点
    public static final int REGION_GPS_PATH = 7;              // 面GPS轨迹
    public static final int REGION_HAND_POINT = 8;            // 面打点
    public static final int REGION_HAND_PATH = 9;             // 面手绘

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    public SCollectorType(ReactApplicationContext context) {
        super(context);
    }

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();

        constants.put("POINT_GPS", POINT_GPS);                      // 打点
        constants.put("POINT_HAND", POINT_HAND);                    // 点手绘
        constants.put("LINE_GPS_POINT", LINE_GPS_POINT);            // 线GPS打点
        constants.put("LINE_GPS_PATH", LINE_GPS_PATH);              // 线GPS轨迹
        constants.put("LINE_HAND_POINT", LINE_HAND_POINT);          // 线打点
        constants.put("LINE_HAND_PATH", LINE_HAND_PATH);            // 线手绘
        constants.put("REGION_GPS_POINT", REGION_GPS_POINT);        // 面GPS打点
        constants.put("REGION_GPS_PATH", REGION_GPS_PATH);          // 面GPS轨迹
        constants.put("REGION_HAND_POINT", REGION_HAND_POINT);      // 面打点
        constants.put("REGION_HAND_PATH", REGION_HAND_PATH);        // 面手绘

        return constants;
    }
}

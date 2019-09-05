package com.supermap.containts;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by YSL on 2019/9/3.
 */

public class FixColorMode extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "FixColorMode";

    public FixColorMode(ReactApplicationContext context){
        super(context);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        //Hue
        constants.put("FCM_LH", 0);           // 线
        constants.put("FCM_FH", 1);           // 面
        constants.put("FCM_BH", 2);           // 边框
        constants.put("FCM_TH", 3);           // 文本
        //Saturation
        constants.put("FCM_LS", 4);           // 线
        constants.put("FCM_FS", 5);           // 面
        constants.put("FCM_BS", 6);           // 边框
        constants.put("FCM_TS", 7);           // 文本
        //Brightness
        constants.put("FCM_LB", 8);           // 线
        constants.put("FCM_FB", 9);           // 面
        constants.put("FCM_BB", 10);          // 边框
        constants.put("FCM_TB", 11);          // 文本
        return constants;
    }
}
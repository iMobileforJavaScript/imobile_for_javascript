package com.supermap.rnsupermap;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.supermap.data.CoordSysTransMethod;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Yang Shanglong on 2018/7/16.
 */

public class JSCoordSysTransMethod extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS="JSCoordSysTransMethod";

    public JSCoordSysTransMethod(ReactApplicationContext context){
        super(context);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put("MTH_GEOCENTRIC_TRANSLATION", 9603);         // 基于地心的三参数转换法
        constants.put("MTH_MOLODENSKY", 9604);                     // 莫洛金斯基（Molodensky）转换法
        constants.put("MTH_MOLODENSKY_ABRIDGED ", 9605);           // 简化的莫洛金斯基转换法
        constants.put("MTH_POSITION_VECTOR", 9606);                // 位置矢量法
        constants.put("MTH_COORDINATE_FRAME", 9607);               // 基于地心的七参数转换法。
        constants.put("MTH_BURSA_WOLF", 42607);                    // Bursa-Wolf 方法

        return constants;
    }
}
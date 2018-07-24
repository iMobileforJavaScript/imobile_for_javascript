package com.supermap.rnsupermap;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.supermap.mapping.collector.CollectorElement;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Yangshanglong on 2018/7/23.
 */

public class JSGPSElementType extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS="JSGPSElementType";

    public JSGPSElementType(ReactApplicationContext context){
        super(context);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put("LINE", CollectorElement.GPSElementType.LINE.name());                     // 空操作
        constants.put("POINT", CollectorElement.GPSElementType.POINT.name());                            // 地图漫游
        constants.put("POLYGON", CollectorElement.GPSElementType.POLYGON.name());
        return constants;
    }
}
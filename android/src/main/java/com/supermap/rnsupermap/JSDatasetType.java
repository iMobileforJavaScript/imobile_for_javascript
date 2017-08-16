package com.supermap.rnsupermap;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2017/8/16.
 */

public class JSDatasetType extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS="JSDatasetType";

    public JSDatasetType(ReactApplicationContext context){
        super(context);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put("TABULAR", 0);
        constants.put("POINT", 1);
        constants.put("LINE", 3);
        constants.put("Network", 4);
        constants.put("REGION", 5);
        constants.put("TEXT", 7);
        constants.put("IMAGE", 81);
        constants.put("Grid", 83);
        constants.put("DEM", 84);
        constants.put("WMS", 86);
        constants.put("WCS", 87);
//        constants.put("MBImage", 11);
        constants.put("PointZ", 101);
        constants.put("LineZ", 103);
        constants.put("RegionZ", 105);
//        constants.put("VECTORMODEL", 11);
//        constants.put("TIN", 11);
        constants.put("CAD", 149);
        constants.put("WFS", 151);
        constants.put("NETWORK3D", 205);
        return constants;
    }
}

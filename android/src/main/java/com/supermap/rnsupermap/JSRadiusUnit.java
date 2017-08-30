package com.supermap.rnsupermap;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2017/8/16.
 */

public class JSRadiusUnit extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS="JSRadiusUnit";

    public JSRadiusUnit(ReactApplicationContext context){
        super(context);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put("MiliMeter", 10);
        constants.put("CentiMeter", 100);
        constants.put("DeciMeter", 1000);
        constants.put("Meter", 10000);
        constants.put("KiloMeter", 10000000);
        constants.put("Yard", 9144);
        constants.put("Inch", 254);
        constants.put("Foot", 3048);
        constants.put("Mile", 16090000);
        return constants;
    }
}

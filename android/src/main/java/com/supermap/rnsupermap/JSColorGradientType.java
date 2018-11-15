package com.supermap.rnsupermap;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2017/8/15.
 */

public class JSColorGradientType extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS="JSColorGradientType";

    public JSColorGradientType(ReactApplicationContext context){
        super(context);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put("BLACKWHITE", 0);
        constants.put("REDWHITE", 1);
        constants.put("GREENWHITE", 2);
        constants.put("BLUEWHITE", 3);
        constants.put("YELLOWWHITE", 4);
        constants.put("PINKWHITE", 5);
        constants.put("CYANWHITE", 6);
        constants.put("REDBLACK", 7);
        constants.put("GREENBLACK", 8);
        constants.put("BLUEBLACK", 9);
        constants.put("YELLOWBLACK", 10);
        constants.put("PINKBLACK", 11);
        constants.put("CYANBLACK", 12);
        constants.put("YELLOWRED", 13);
        constants.put("YELLOWGREEN", 14);
        constants.put("YELLOWBLUE", 15);
        constants.put("GREENBLUE", 16);
        constants.put("GREENRED", 17);
        constants.put("BLUERED", 18);
        constants.put("PINKRED", 19);
        constants.put("PINKBLUE", 20);
        constants.put("CYANBLUE", 21);
        constants.put("CYANGREEN", 22);
        constants.put("RAINBOW", 23);
        constants.put("GREENORANGEVIOLET", 24);
        constants.put("TERRAIN", 25);
        constants.put("SPECTRUM", 26);
        return constants;
    }
}
package com.supermap.rnsupermap;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Yangshanglong on 2018/8/7.
 */

public class JSThemeType extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS="JSThemeType";

    public JSThemeType(ReactApplicationContext context){
        super(context);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put("UNIQUE", 1);
        constants.put("RANGE", 2);
        constants.put("GRAPH", 3);
        constants.put("GRADUATEDSYMBOL", 4);
        constants.put("DOTDENSITY", 5);
        constants.put("LABEL", 7);
        constants.put("CUSTOM", 8);
        constants.put("GRIDUNIQUE", 11);
        constants.put("GRIDRANGE", 12);
        constants.put("LABELUNIQUE", 107);
        constants.put("LABELRANGE", 207);
        return constants;
    }
}
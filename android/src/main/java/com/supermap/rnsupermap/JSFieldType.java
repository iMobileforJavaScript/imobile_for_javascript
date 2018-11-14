package com.supermap.rnsupermap;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2017/8/15.
 */

public class JSFieldType extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS="JSFieldType";

    public JSFieldType(ReactApplicationContext context){
        super(context);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put("BOOLEAN", 1);
        constants.put("BYTE", 2);
        constants.put("INT16", 3);
        constants.put("INT32", 4);
        constants.put("INT64", 16);
        constants.put("SINGLE", 6);
        constants.put("DOUBLE", 7);
        constants.put("DATETIME", 23);
        constants.put("LONGBINARY", 11);
        constants.put("TEXT", 10);
        constants.put("CHAR", 18);
        constants.put("WTEXT", 127);
        return constants;
    }
}
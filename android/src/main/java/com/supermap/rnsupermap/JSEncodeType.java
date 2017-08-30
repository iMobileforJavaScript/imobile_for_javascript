package com.supermap.rnsupermap;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2017/8/16.
 */

public class JSEncodeType extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS="JSEncodeType";

    public JSEncodeType(ReactApplicationContext context){
        super(context);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put("NONE", 0);
        constants.put("BYTE", 1);
        constants.put("INT16", 2);
        constants.put("INT24", 3);
        constants.put("INT32", 4);
        constants.put("DCT", 8);
        constants.put("SGL", 9);
        constants.put("LZW", 11);
        return constants;
    }
}

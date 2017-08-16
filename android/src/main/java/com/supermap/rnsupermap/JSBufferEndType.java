package com.supermap.rnsupermap;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2017/8/16.
 */

public class JSBufferEndType extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS="JSBufferEndType";

    public JSBufferEndType(ReactApplicationContext context){
        super(context);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put("ROUND", 1);
        constants.put("FLAT", 2);
        return constants;
    }
}

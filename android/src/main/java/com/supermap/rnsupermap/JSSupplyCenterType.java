package com.supermap.rnsupermap;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Yangshanglong on 2018/7/16.
 */

public class JSSupplyCenterType extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS="JSSupplyCenterType";

    public JSSupplyCenterType(ReactApplicationContext context){
        super(context);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put("NULL", 0);
        constants.put("OPTIONALCENTER", 1);
        constants.put("FIXEDCENTER", 2);
        return constants;
    }
}
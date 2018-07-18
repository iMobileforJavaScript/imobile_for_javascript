package com.supermap.rnsupermap;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.supermap.data.Enum;
import com.supermap.data.PrjCoordSysType;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Myself on 2017/8/15.
 */

public class JSPrjCoordSysType extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS="JSPrjCoordSysType";

    public JSPrjCoordSysType(ReactApplicationContext context){
        super(context);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();

        String[] names = Enum.getNames(PrjCoordSysType.class);
        for (int i = 0; i < names.length; i++) {
            int value = Enum.getValueByName(PrjCoordSysType.class, names[i]);
            constants.put(names[i], value);
        }

        return constants;
    }
}
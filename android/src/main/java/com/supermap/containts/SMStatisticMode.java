package com.supermap.containts;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.supermap.data.Enum;
import com.supermap.data.StatisticMode;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by YSL on 2019/11/26.
 */

public class SMStatisticMode extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "StatisticMode";

    public SMStatisticMode(ReactApplicationContext context){
        super(context);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        String[] names = Enum.getNames(StatisticMode.class);
        for (int i = 0; i < names.length; i++) {
            int value = Enum.getValueByName(StatisticMode.class, names[i]);
            constants.put(names[i], value);
        }
        return constants;
    }
}
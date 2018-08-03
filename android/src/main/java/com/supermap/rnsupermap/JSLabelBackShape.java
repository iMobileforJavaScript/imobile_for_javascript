package com.supermap.rnsupermap;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.supermap.data.Enum;
import com.supermap.mapping.LabelBackShape;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by YangShanglon on 2018/8/3.
 */

public class JSLabelBackShape extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS="JSLabelBackShape";

    public JSLabelBackShape(ReactApplicationContext context){
        super(context);
    }

    @Override
    public String getName(){return REACT_CLASS;}

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();

        String[] names = Enum.getNames(LabelBackShape.class);
        for (int i = 0; i < names.length; i++) {
            int value = Enum.getValueByName(LabelBackShape.class, names[i]);
            constants.put(names[i], value);
        }

        return constants;
    }
}
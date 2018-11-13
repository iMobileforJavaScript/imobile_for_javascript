package com.supermap.rnsupermap;
import android.drm.DrmStore;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.supermap.realspace.Layer3DType;

import java.util.Map;
import java.util.HashMap;

public class JSLayer3DType extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSLayer3DType";

    public JSLayer3DType(ReactApplicationContext context) {
        super(context);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        String[] names = Layer3DType.getNames(DrmStore.Action.class);
        for (int i = 0; i < names.length; i++) {
            String value = Layer3DType.getNameByValue(DrmStore.Action.class, Integer.parseInt(names[i]));
            constants.put(names[i], value);
        }
        return constants;
    }

}

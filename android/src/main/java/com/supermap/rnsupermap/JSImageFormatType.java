package com.supermap.rnsupermap;

import android.drm.DrmStore;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.supermap.data.ImageFormatType;

import java.util.HashMap;
import java.util.Map;

public class JSImageFormatType extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSImageFormatType";

    public JSImageFormatType(ReactApplicationContext context) {
        super(context);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        String[] names = ImageFormatType.getNames(DrmStore.Action.class);
        for (int i = 0; i < names.length; i++) {
            int value = ImageFormatType.getValueByName(DrmStore.Action.class, names[i]);
            constants.put(names[i], value);
        }
        return constants;
    }
}

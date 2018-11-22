package com.supermap.interfaces.mapping;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableArray;
import com.supermap.smNative.SMLayer;

public class SLayerManager extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "SLayerManager";
    private static SLayerManager analyst;
    private static ReactApplicationContext context;
    ReactContext mReactContext;

    public SLayerManager(ReactApplicationContext context) {
        super(context);
        this.context = context;
        mReactContext = context;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    /**
     * 获取制定类型的图层, type = -1 为所有类型
     * @param type
     * @param path
     * @param promise
     */
    @ReactMethod
    public void getLayersByType(int type, String path, Promise promise) {
        try {
            WritableArray layers = SMLayer.getLayersByType(type, path);
            promise.resolve(layers);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 获取指定名字的LayerGroup
     * @param path
     * @param promise
     */
    @ReactMethod
    public void getLayersByGroupPath(String path, Promise promise) {
        try {
            if (path == null || path.equals("")) promise.reject(new Error("Group name can not be empty"));
            WritableArray layers = SMLayer.getLayersByGroupPath(path);
            promise.resolve(layers);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    /**
     * 设置制定名字图层是否可见
     * @param path
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setLayerVisible(String path, boolean value, Promise promise) {
        try {
            SMLayer.setLayerVisible(path, value);
            promise.resolve(true);
            SMap.getSMWorkspace().getMapControl().getMap().refresh();
            promise.resolve(true);
        } catch (Exception e) {
            promise.reject(e);
        }
    }
}

package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;

import java.io.File;

public class JSOpenMapfile extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSOpenMapfile";
    ReactContext mReactContext;
    private final String sdcard = android.os.Environment.getExternalStorageDirectory().getAbsolutePath().toString();

    public JSOpenMapfile(ReactApplicationContext context) {
        super(context);
        mReactContext = context;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @ReactMethod
    public void getpathlist(String path, Promise promise) {
        try {
//            if (path == "sdcard") {
//                path = sdcard;
//            }
            File file = new File(sdcard + "/" + path);

            File[] files = file.listFiles();
            WritableArray array = Arguments.createArray();
            for (int i = 0; i < files.length; i++) {
                String p = files[i].getAbsolutePath().replace(sdcard, "");
                String n = files[i].getName();
                boolean isDirectory = files[i].isDirectory();
                WritableMap map = Arguments.createMap();
                map.putString("path", p);
                map.putString("name", n);
                map.putBoolean("isDirectory", isDirectory);
//                array.pushString(p);
                array.pushMap(map);
            }
            promise.resolve(array);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void isdirectory(String path, Promise promise) {
        try {
            File file = new File(sdcard + "/" + path);
//            if (file.isDirectory()) {
//                String str = "isfile";
//                promise.resolve(str);
//            } else {
//                String str = "notisfile";
//                promise.resolve(str);
//            }
            boolean isDirectory = file.isDirectory();
            promise.resolve(isDirectory);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

}

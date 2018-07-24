package com.supermap.rnsupermap;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableArray;

import java.io.File;
import java.sql.Array;
import java.util.ArrayList;
import java.util.List;

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
    public void getpathlist(String path,Promise promise) {
        try {

            if (path == "sdcard") {
                path = sdcard;
            }
            File file = new File(path);

            File[] files = file.listFiles();
            WritableArray array = Arguments.createArray();
            for (int i = 0; i < files.length; i++) {
                array.pushString(files[i].getAbsolutePath().toString());
                }
                promise.resolve(array);
             }
        catch (Exception e) {
            promise.reject(e);
        }
    }
    @ReactMethod
    public void isdirectory(String path,Promise promise) {
        try {
            File file = new File(path);
            if(file.isDirectory()){
                String str="isfile";
                promise.resolve(str);
            }else {
                String str="notisfile";
                promise.resolve(str);
            }

        }
        catch (Exception e) {
            promise.reject(e);
        }
    }

}

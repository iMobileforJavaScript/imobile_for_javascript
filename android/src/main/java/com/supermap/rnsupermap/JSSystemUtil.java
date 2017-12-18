package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;

import java.util.HashMap;
import java.util.Map;

public class JSSystemUtil extends ReactContextBaseJavaModule {
    public static final String REACT_CLASS = "JSSystemUtil";

    public JSSystemUtil(ReactApplicationContext context) {
        super(context);
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

@ReactMethod
public void getHomeDirectory(Promise promise){
    try{
        String homeDirectory= android.os.Environment.getExternalStorageDirectory().getAbsolutePath().toString();

        WritableMap map = Arguments.createMap();
        map.putString("homeDirectory",homeDirectory);
        promise.resolve(map);
    }catch (Exception e){
        promise.reject(e);
    }
}
}


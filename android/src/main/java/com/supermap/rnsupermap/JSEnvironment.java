package com.supermap.rnsupermap;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.supermap.data.Environment;

/**
 * Created by Myself on 2017/11/14.
 */

public class JSEnvironment extends ReactContextBaseJavaModule {
    ReactApplicationContext m_context;
    private final String sdcard= android.os.Environment.getExternalStorageDirectory().getAbsolutePath().toString();
    public static final String REACT_CLASS = "JSEnvironment";
    public JSEnvironment(ReactApplicationContext context) {
        super(context);
        m_context = context;
    }

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @ReactMethod
    public void setLicensePath(String path, Promise promise){
        try{
            Environment.setLicensePath(sdcard + path);

            WritableMap map = Arguments.createMap();
            map.putBoolean("isSet",true);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }

    @ReactMethod
    public void initialization(Promise promise){
        try{
            Environment.initialization(m_context.getBaseContext());

            WritableMap map = Arguments.createMap();
            map.putBoolean("isInit",true);
            promise.resolve(map);
        }catch(Exception e){
            promise.reject(e);
        }
    }
}

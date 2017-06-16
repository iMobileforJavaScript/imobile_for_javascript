package com.supermap.rnsupermap;

import android.util.Log;

import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;

/**
 * Created by Myself on 2017/5/26.
 */

public class LogModule extends ReactContextBaseJavaModule {
    private static final String MODULE_NAME = "Log";

    public LogModule(ReactApplicationContext reactContext){
        super(reactContext);
    }

    @Override
    public String getName(){
        return MODULE_NAME;
    }

    @ReactMethod

    public void d(String tag,String msg){
        Log.d(tag, msg);
    }
}
